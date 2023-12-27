local logger           = sa.Logger.new("RoomController")

local P = import("..net.PROTOCOL")

local RoomController = class("RoomController")
local RoomModel        = import(".model.RoomModel")
local SeatManager      = import(".SeatManager")
local DealerManager    = import(".DealerManager")
local PublicCardManager = import(".PublicCardManager")
local DealCardManager  = import(".DealCardManager")
local LampManager      = import(".LampManager")
local ChipManager      = import(".ChipManager")
local AnimManager      = import(".AnimManager")
local OperationManager = import(".OperationManager")
local CardAnalysisManager = import(".CardAnalysisManager")
local BetChipView      = import(".views.BetChipView")
local PotChipView      = import(".views.PotChipView")

local PACKET_PROC_FRAME_INTERVAL = 4

function RoomController:ctor(scene, gameId)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.gameId_ = gameId

    local ctx = {}
    ctx.roomController = self
    ctx.scene = scene
    ctx.model = RoomModel.new(ctx)
    ctx.controllerEventProxy = cc.EventProxy.new(self, scene)
    ctx.schedulerPool = sa.SchedulerPool.new()
    ctx.sceneSchedulerPool = sa.SchedulerPool.new()
    ctx.gameSchedulerPool = sa.SchedulerPool.new()

    ctx.seatManager = SeatManager.new(ctx)

    ctx.dealerManager = DealerManager.new(ctx, 1, false)

    ctx.dealCardManager = DealCardManager.new()
    ctx.publicCardManager = PublicCardManager.new()
    ctx.lampManager = LampManager.new()
    ctx.chipManager = ChipManager.new()
    ctx.animManager = AnimManager.new()
    ctx.oprManager = OperationManager.new()
    ctx.aysManager = CardAnalysisManager.new()

    ctx.export = function(target)
        if target ~= ctx.model then
            target.ctx = ctx
            for k, v in pairs(ctx) do
                if k ~= "export" and v ~= target then
                    target[k] = v
                end
            end
        else
            rawset(target, "ctx", ctx)
            for k, v in pairs(ctx) do
                if k ~= "export" and v ~= target then
                    rawset(target, k, v)
                end
            end
        end
        return target
    end

    ctx.export(self)
    ctx.export(ctx.seatManager)
    ctx.export(ctx.dealerManager)
    ctx.export(ctx.dealCardManager)
    ctx.export(ctx.publicCardManager)
    ctx.export(ctx.lampManager)
    ctx.export(ctx.chipManager)
    ctx.export(ctx.animManager)
    ctx.export(ctx.oprManager)
    ctx.export(ctx.aysManager)

    cc.EventProxy.new(tx.socket.HallSocket, scene)
        :addEventListener(tx.socket.HallSocket.EVT_PACKET_RECEIVED, handler(self, self.onPacketReceived_))
        :addEventListener(tx.socket.HallSocket.EVT_CONNECTED, handler(self, self.onConnected_))

    self.packetCache_ = {}
    self.loginRoomRetryTimes_ = 0
    self.frameNo_ = 1
    self.playGameNum_ = 0 --当次坐下玩牌局数，站起就清零
    self.showGuideTimes_ = 0 --显示引导弹窗次数，最多显示3次

    ctx.sceneSchedulerPool:loopCall(handler(self, self.onEnterFrame_), 1 / 30)
    ctx.sceneSchedulerPool:loopCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        return not self.isDisposed_
    end, 60)
end

function RoomController:dispose()
    self.isDisposed_ = true
    self.seatManager:dispose()
    self.dealerManager:dispose()
    self.dealCardManager:dispose()
    self.publicCardManager:dispose()
    self.lampManager:dispose()
    self.chipManager:dispose()
    self.animManager:dispose()
    self.oprManager:dispose()
    self.aysManager:dispose()

    self.schedulerPool:clearAll()
    self.sceneSchedulerPool:clearAll()
    self.gameSchedulerPool:clearAll()

    self:unbindDataObservers_()
end

function RoomController:createNodes()
    self.seatManager:createNodes()
    self.dealerManager:createNodes()
    self.dealCardManager:createNodes()
    self.publicCardManager:createNodes()
    self.lampManager:createNodes()
    self.chipManager:createNodes()
    self.animManager:createNodes()
    self.oprManager:createNodes()

    self.oprManager:hideOperationButtons(false)

    self:bindDataObservers_()
end

function RoomController:onConnected_(evt)
    self.packetCache_ = {}
    self.loginRoomRetryTimes_ = 0
end

function RoomController:onEnterFrame_(dt)
    if #self.packetCache_ > 0 then
        if #self.packetCache_ == 1 then
            self.frameNo_ = 1
            local pack = table.remove(self.packetCache_, 1)
            self:processPacket_(pack)
        else
            --先检查并干掉累计的超过一局的包
            local startPackIndex = 0
            local removeFromIdx = 0
            local removeEndIdx = 0
            local gameStartCount = 0
            for i, v in ipairs(self.packetCache_) do
                if v.cmd == P.SVR_GAME_OVER then
                    if removeFromIdx == 0 then
                        removeFromIdx = i
                    else
                        removeEndIdx = i --到最后一个结束包
                    end
                elseif v.cmd == P.SVR_GAME_START then
                    gameStartCount = gameStartCount + 1
                    startPackIndex = i
                end
            end

            if gameStartCount > 1 then --跳过一个完整局，上局肯定没买下一局
                tx.userData.isBuyGoldIsland = false
                tx.userData.isJoinGoldIsland = false
            end

            -- 正好一局多一点  前一局的直接干掉
            if startPackIndex~=0 and removeFromIdx~=0 and startPackIndex>removeFromIdx and removeEndIdx==0 then
                removeEndIdx = removeFromIdx
            end

            -- 这一局的也不要了
            if removeEndIdx ~= 0 then
                removeFromIdx = 1
            end
            if removeFromIdx ~= 0 and removeEndIdx ~= 0 then
                print("!=!=!=! THROW AWAY PACKET FROM " .. removeFromIdx .. " to " .. removeEndIdx)
                --干掉超过一局的包，但是要保留坐下站起包，以保证座位数据正确
                local keepPackets = {}
                for i = removeFromIdx, removeEndIdx do
                    local pack = table.remove(self.packetCache_, removeFromIdx)
                    if pack.cmd == P.SVR_SIT_DOWN or pack.cmd == P.SVR_STAND_UP then
                        keepPackets[#keepPackets + 1] = pack
                        pack.fastForward = true
                    end
                end
                if #keepPackets > 0 then
                    table.insertto(self.packetCache_, keepPackets, removeFromIdx)
                end
            end

            self.frameNo_ = self.frameNo_ + 1
            if self.frameNo_ > PACKET_PROC_FRAME_INTERVAL then
                self.frameNo_ = 1
                local pack = table.remove(self.packetCache_, 1)
                self:processPacket_(pack)
            end
        end
    end
    return true
end

--接收发过来的包，并缓存,游戏切到后台，不回调，切回来会缓存一堆包
function RoomController:onPacketReceived_(evt)
    table.insert(self.packetCache_, evt.packet)
end

--解析包 
function RoomController:processPacket_(pack)
    local cmd = pack.cmd
    local ctx = self.ctx
    local model = self.model
    local PROTOCOL = tx.socket.HallSocket.PROTOCOL -- 大厅公共协议
    if table.keyof(P, cmd) then
        logger:debugf("TexasRoomController.processPacket[%x]%s", cmd, table.keyof(P, cmd))
    else
        logger:debugf("TexasRoomController.processPacket[%x]%s", cmd, table.keyof(PROTOCOL, cmd))
    end

    if _G.curInGameId ~= self.gameId_ then --邀请进入其他游戏房间，RoomController还没销毁，还能调用这个接口，所以要判断当前游戏场景是否和协议一致
        return
    end

    if cmd == P.SVR_LOGIN_SUCCESS then
        if self.roomLoading_ then
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
        if self.scene and self.scene.roomLoading_ then
            self.scene.roomLoading_:removeFromParent()
            self.scene.roomLoading_ = nil
        end

        self:reset()

        --登录成功
        model:initWithLoginSuccessPack(pack)

        self.scene:showGoldIslandNode(model.roomInfo.blind)

        --显示房间信息
        self.scene:setRoomInfoText(model.roomInfo)

        --老虎机盲注
        self.scene:setSlotBlind(model.roomInfo)

        --初始化座位及玩家
        ctx.seatManager:initSeats(model.seatsInfo, model.playerList)

        --如果是6人场，显示FB邀请
        if pack.seatNum == 6 then
            self.scene:showInviteView()
        end

        --设置庄家指示
        ctx.animManager:moveDealerTo(ctx.seatManager:getSeatPositionId(model.gameInfo.dealerSeatId), false)

        --初始隐藏灯光
        if model.gameInfo.bettingSeatId ~= -1 then
            ctx.lampManager:turnTo(ctx.seatManager:getSeatPositionId(model.gameInfo.bettingSeatId), false)
            ctx.lampManager:show()

            --座位开始计时器动画
            ctx.seatManager:startCounter(model.gameInfo.bettingSeatId,pack.leftTime/10)
        else
            ctx.lampManager:hide()
            ctx.seatManager:stopCounter()
        end

        --(要在庄家指示和灯光之后转动，否则可能位置不正确)
        if model:isSelfInSeat() then
            ctx.seatManager:rotateSelfSeatToCenter(model:selfSeatId(), false)
        end

        --如果玩家坐下并且不在本轮游戏，则提示等待下轮游戏
        if model:isSelfInSeat() and not model:isSelfInGame() then
            tx.HorseLamp:showTips(sa.LangUtil.getText("ROOM", "WAIT_NEXT_ROUND"),nil,true)
        end
        --重置操作栏自动操作状态
        ctx.oprManager:resetAutoOperationStatus()
        --更新操作栏状态
        ctx.oprManager:updateOperationStatus()
        --动画显示操作栏
        if model:isSelfInSeat() then
            ctx.oprManager:showOperationButtons(true)
        else
            ctx.oprManager:hideOperationButtons(true)
        end
        
        -- 设置登录筹码堆
        ctx.chipManager:setLoginChipStacks()

        self.gameSchedulerPool:clearAll()

        self:updateChangeRoomButtonMode()

        --自动坐下
        self:applyAutoSitDown()

        model.standChatCount = 0
        self:dealCardProb()
        self.publicCardManager:showReconnect(pack)
        self.scene:dealSitDownView()
        -- 亮牌
        self.oprManager:setShowCardStatus()

        --更新夺金岛购买状态
        self:updateGoldIslandBuyStatus_(false)

        tx.getPlayPokerNum(model.roomInfo.blind)

        -- -- 测试亮牌
        -- for i=1,10,1 do
        --     self.dealCardManager:showLiangPai(i,0x03,0x04)
        -- end
    elseif cmd == P.SVR_GAME_START then
        if not self.hasReset_ then
            self:reset()
        end
        self.hasReset_ = false

        tx.userData.isJoinGoldIsland = tx.userData.isBuyGoldIsland
        tx.userData.goldIslandRewardData = nil

        self.scene:updateGoldIslandBtnStatus(false)

        self:updateGoldIslandBuyStatus_(false)

        --牌局开始
        model:processGameStart(pack)

        --移动庄家指示
        ctx.animManager:moveDealerTo(ctx.seatManager:getSeatPositionId(model.gameInfo.dealerSeatId), true)

        --隐藏亮牌
        ctx.dealCardManager:hideLiangPai()

        ctx.seatManager:prepareDealCards()
        self.gameSchedulerPool:delayCall(function ()
            ctx.dealCardManager:dealCards()
        end, 0.2)

        --重置操作栏自动操作状态
        ctx.oprManager:resetAutoOperationStatus()
        --更新操作栏状态
        ctx.oprManager:updateOperationStatus()

        --更新座位状态
        ctx.seatManager:updateAllSeatState()

        self:updateChangeRoomButtonMode()

        self.scene:hideShareBtn()
        -- self:dealCardProb() 动画完毕
    elseif cmd == P.SVR_BET_SUCCESS then
        --下注成功
        local seatId = model:processBetSuccess(pack)

        --更新座位信息
        ctx.seatManager:updateSeatState(seatId)

        local player = model.playerList[seatId]
        local isSelf = model:isSelf(player.uid)
        if player then
            --如果当前座位正在计时，强制停止
            ctx.seatManager:stopCounterOnSeat(seatId)
            ctx.chipManager:betChip(player)

            local betState = player.betState
            -- 看牌
            if betState == consts.SVR_BET_STATE.CHECK then
                tx.SoundManager:playSound(tx.SoundManager.CHECK)
            -- 弃牌
            elseif betState == consts.SVR_BET_STATE.FOLD then
                tx.SoundManager:playSound(tx.SoundManager.FOLD)

                ctx.dealCardManager:foldCard(player)
                ctx.seatManager:fadeSeat(seatId)
                -- 亮牌
                self.oprManager:setShowCardStatus()
                --弃牌则不显示
                if isSelf then
                    self.scene:dealCardPower(false)
                end
            -- 跟注
            elseif betState == consts.SVR_BET_STATE.CALL then
                tx.SoundManager:playSound(tx.SoundManager.CALL)
            -- 加注
            elseif betState == consts.SVR_BET_STATE.RAISE then
                tx.SoundManager:playSound(tx.SoundManager.RAISE)
            -- all in
            elseif betState == consts.SVR_BET_STATE.ALL_IN then
                tx.SoundManager:playSound(tx.SoundManager.ALLIN)
                ctx.seatManager:playAllInAnimation(seatId)
            --blind
            elseif betState == consts.SVR_BET_STATE.SMALL_BLIND or betState == consts.SVR_BET_STATE.BIG_BLIND then
                tx.SoundManager:playSound(tx.SoundManager.BLINDCHIPS)
            end
        end
    elseif cmd == P.SVR_TURN_TO_BET then 
        --轮到某个玩家下注
        local seatId = model:processTurnToBet(pack)

        --更新座位信息
        ctx.seatManager:updateSeatState(seatId)
        local turnToFunc = function()
            if model:selfSeatId() == seatId then
                tx.SoundManager:playSound(tx.SoundManager.NOTICE)
                if tx.userDefault:getBoolForKey(tx.cookieKeys.SHOCK, false) then
                    tx.Native:vibrate(500)
                end
            end
            --打光切换
            ctx.lampManager:turnTo(self.seatManager:getSeatPositionId(seatId), true)
            ctx.lampManager:show()
            --座位开始计时器动画
            self.gameSchedulerPool:delayCall(function()
                ctx.seatManager:startCounter(seatId)
                --更新操作栏状态
                ctx.oprManager:updateOperationStatus()
            end, 0.5)
        end
        turnToFunc()
    elseif cmd == P.SVR_BET_FAIL then
        model:processBetFail(pack)
        -- 更新操作
        if model.gameInfo and model.gameInfo.bettingSeatId==pack.seatId and model:isSelfInSeat() then
            if pack.code==-6 then  -- 赠送筹码钱已经没那么多了
                tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.ALL_IN, pack.maxRaiseChips)
            else
                if model:selfSeatId() == model.gameInfo.bettingSeatId then
                    local virtualPack = {
                        cmd = P.SVR_TURN_TO_BET,
                        seatId = pack.seatId,
                        callChips = pack.callChips,
                        minRaiseChips = pack.minRaiseChips,
                        maxRaiseChips = pack.maxRaiseChips,
                    }
                    model:processTurnToBet(virtualPack)
                    ctx.oprManager:updateOperationStatus()
                end
            end
        end
    elseif cmd == P.SVR_DEAL_PUB_CARD then
        model:processDealPubCard(pack)

        ctx.seatManager:updateAllSeatState()--每轮开始下注后，清除上一轮玩家状态

        self.oprManager:setShowCardStatus()--刷新玩家状态，会把已选择的亮牌加上阴影，需要刷新亮牌状态

        --座位停止计时器
        ctx.seatManager:stopCounter()
        ctx.publicCardManager:showPubCard(pack)
        -- self:dealCardProb()  -- 动画完毕
    elseif cmd == P.SVR_POT then
        -- 奖池
        model:processPot(pack)

        -- 收奖池动画
        ctx.chipManager:gatherPot()

        --禁用操作栏
        ctx.oprManager:blockOperationButtons()
        --AllIn导致的结算
        if pack.allInHandCards and #pack.allInHandCards>0 then
            self.gameSchedulerPool:delayCall(function ()
                self.seatManager:showHandCard()
            end, 1.3-PotChipView.MOVE_TO_SEAT_DURATION)
        end
    elseif cmd == P.SVR_SIT_DOWN then 
        --坐下
        local seatId, isAutoBuyin = model:processSitDown(pack)
        if isAutoBuyin then
            local seatView_ = ctx.seatManager:getSeatView(seatId)
            seatView_:playAutoBuyinAnimation(pack.seatChips)
            return
        end

        local anim = not pack.fastForward

        if model:selfSeatId() == seatId then
            self.playGameNum_ = 0
            self.showGuideTimes_ = 0
            --更新全部座位状态，没人的座位会隐藏
            ctx.seatManager:updateAllSeatState()
            --把自己的座位转到中间去
            ctx.seatManager:rotateSelfSeatToCenter(seatId, anim)
            --动画显示操作栏
            ctx.oprManager:showOperationButtons(anim)
            --记录坐下时的钱数
            tx.userData.seatdownMoney = pack.chips
            model.standChatCount = 0;
        else
            --更新座位信息
            ctx.seatManager:updateSeatState(seatId)
        end
        --播放坐下动画
        if anim then
            ctx.seatManager:playSitDownAnimation(seatId)
        end
        self:updateChangeRoomButtonMode()
        self.scene:dealSitDownView()
    elseif cmd == P.SVR_STAND_UP then 
        --站起
        local selfSeatId = model:selfSeatId()
        local seatId = model:processStandUp(pack)
        local positionId = ctx.seatManager:getSeatPositionId(seatId)
        local anim = not pack.fastForward
        --如果自己站起，则把位置转回去
        if selfSeatId == seatId then
            --更新全部座位状态，没人的座位会显示
            ctx.seatManager:updateAllSeatState()
            --把转动过的座位还原
            ctx.seatManager:rotateSeatToOrdinal()
            --动画隐藏操作栏
            ctx.oprManager:hideOperationButtons(false)
            --弃牌则不显示
            self.scene:dealCardPower(false)

            if pack.code and pack.code == 3 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "NO_BET_STAND_UP"))
            end

            tx.userData.autoBuyGoldIsland = false
            tx.userData.isBuyGoldIsland = false
        else
            --更新座位信息
            if not anim then
                ctx.seatManager:updateSeatState(seatId)
            end
        end
        --播放站起动画
        if anim then
            ctx.seatManager:playStandUpAnimation(seatId, function() 
                ctx.seatManager:updateSeatState(seatId)
            end)
        end
        --干掉已经发的手牌
        self.dealCardManager:stopDealCardToPos(positionId)
        self.dealCardManager:hideDealedCard(positionId)
        --如果当前座位正在计时，强制停止
        ctx.seatManager:stopCounterOnSeat(seatId)

        self:updateChangeRoomButtonMode()
        self.scene:dealSitDownView()
        -- 亮牌
        self.oprManager:setShowCardStatus()
    elseif cmd == P.SVR_GAME_OVER then
        self.hasReset_ = false   -- 切入后台BUG
        self.gameSchedulerPool:clearAll()
        --[[
            牌局结束
            前注处理时间3s
            server预留处理游戏结束时间（每个奖池处理时间为3s）：
            普通场或专业场正常结束：奖池数量 * 3 + 4s
            专业场第一轮发牌后all in：奖池数量 * 3 + 2s + 4s
        ]] 
        model:processGameOver(pack,selectStatus)

        --更新座位状态
        ctx.seatManager:updateAllSeatState()

        --隐藏灯光
        ctx.lampManager:hide()

        --禁用操作按钮
        ctx.oprManager:blockOperationButtons()
        --座位停止计时器
        ctx.seatManager:stopCounter()
        --清楚AllIn状态
        ctx.seatManager:stopAllInAnim()

        if model:isSelfInRound() then
            self.playGameNum_ = self.playGameNum_ + 1
        end

        if tx.userData.playPokerNum and model:isSelfPlayCurGame() then
            tx.userData.playPokerNum = tx.userData.playPokerNum + 1
            sa.EventCenter:dispatchEvent(tx.eventNames.UPDATE_PLAY_CARD_STATUS)
        end

        -- 延迟处理
        local splitPotsDelayTime = 1
        local resetDelayTime = #model.gameInfo.splitPots * 3 + splitPotsDelayTime
        
        if model and model.gameInfo and model.gameInfo.allAllIn then
            splitPotsDelayTime = 0.2
            resetDelayTime = #model.gameInfo.splitPots * 3 + splitPotsDelayTime
        else
            ctx.seatManager:showHandCard()
        end
        
        -- 分奖池动画
        self.schedulerPool:delayCall(function ()
            ctx.chipManager:splitPots(model.gameInfo.splitPots)
            if tx.userData.goldIslandRewardData then
                sa.EventCenter:dispatchEvent({name = tx.eventNames.SHOW_GOLD_ISLAND_REWARD, data = tx.userData.goldIslandRewardData})
                tx.userData.goldIslandRewardData = nil
            end

            --座位经验值变化动画
            ctx.seatManager:playExpChangeAnimation()
        end, splitPotsDelayTime)

        -- 刷新游戏状态
        self.schedulerPool:delayCall(function()
            if pack.isTutorialGuide==true then --新手教程稍后reset

            else
                self:reset()
            end
        end, resetDelayTime)
        
        self:dealCardProb(true)
        -- 亮牌
        self.oprManager:setShowCardStatus()

        self:autoBuyGoldIsland_()
    elseif cmd == P.SVR_LOGOUT_SUCCESS then
        --登出成功
        if self.isKickedOut then
            self.scene:doBackToHall()
            self.isKickedOut = false
        end
        -- 记录给荷官送筹码次数大于五次，播放互动道具动画
        cc.UserDefault:getInstance():setIntegerForKey(tx.cookieKeys.RECORD_SEND_DEALER_CHIP_TIME .. tx.userData.uid, 5)
    elseif cmd == P.SVR_SIT_DOWN_FAIL then
        --坐下失败
        local errorCode = pack.code
        local Q = consts.SVR_SIT_DOWN_FAIL_CODE
        local M = sa.LangUtil.getText("ROOM", "SIT_DOWN_FAIL_MSG")
        local msg = nil
        printf("SVR_SIT_DOWN_FAIL ==> %x", errorCode)
        if errorCode == Q.IP_LIMIT then
            msg = M["IP_LIMIT"]
        elseif errorCode == Q.SEAT_NOT_EMPTY then
            msg = M["SEAT_NOT_EMPTY"]
        elseif errorCode == Q.TOO_RICH then
            msg = M["TOO_RICH"]
        elseif errorCode == Q.TOO_POOR then
            msg = M["TOO_POOR"]
        elseif errorCode == Q.NO_OPER then
            msg = M["NO_OPER"]
        end
        -- 自己的最大量筹码和服务器的不一致
        if errorCode==Q.ALL_MONEY_ERROR then
            if pack.chips and pack.chips>0 then
                tx.userData.money = pack.chips
                -- 再重新买入坐下
                if self.lastRequestSeatId then
                    if not model.playerList[self.lastRequestSeatId] then
                        self:applyAutoSitDown(self.lastRequestSeatId)
                    else
                        msg = M["SEAT_NOT_EMPTY"]
                    end
                end
            end
        end
        if msg then
            tx.TopTipManager:showToast(msg)
        end
    elseif cmd == P.SVR_INIT_GOLD_ISLAND_POOL then
        sa.EventCenter:dispatchEvent({name = tx.eventNames.UPDATE_GOLD_ISLAND_POOL, data = pack.poolMoney})
        self:updateGoldIslandBuyStatus_(pack.isBuy == 1)
        tx.userData.isJoinGoldIsland = (pack.isJoin == 1)
        self.scene:updateGoldIslandBtnStatus(false)
    elseif cmd == PROTOCOL.TABLE_SVR_ON_MSG then
        local seatId,player = model:getSeatIdByUid(pack.uid)
        local msgInfo = json.decode(pack.info)
        if msgInfo then
            if msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[1] or msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[9] then  --普通聊天 / 语音聊天
                local canShow = true
                if _G.FORBID_CHAT_LIST and _G.FORBID_CHAT_LIST[pack.uid] then
                    canShow = false
                end
                if canShow then
                    if msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[1] and msgInfo.m then  -- 普通聊天
                        local shortcutList = sa.LangUtil.getText("ROOM", "CHAT_SHORTCUT")
                        local chatIndex = tonumber(msgInfo.i)
                        if chatIndex and chatIndex>0 and shortcutList[chatIndex] then
                            msgInfo.m = shortcutList[chatIndex]
                        end
                        self.animManager:showChatMsg(seatId, msgInfo.m, msgInfo.v)
                        --更新最近聊天文字
                        self.scene:setLatestChatMsg(msgInfo.n,msgInfo.m,pack.uid)
                        -- 快捷聊天音效
                        if seatId>-1 and appconfig.LANG=="th" then
                            for k,v in ipairs(shortcutList) do
                                if msgInfo.m==v then
                                    tx.SoundManager:playChatSound(k)
                                    break
                                end
                            end
                        end
                    elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[9] and msgInfo.url and tx.VoiceSDK and tx.VoiceSDK.open then  -- 语音聊天
                        -- 添加历史聊天记录
                        if seatId>-1 then
                            if self.scene:checkPlayVoice(pack) then --同一时间只能播放一个声音 先缓存吧
                                self.animManager:playVoiceChat(seatId, msgInfo)
                                self.scene:setLatestChatMsg(msgInfo.n,"",pack.uid,msgInfo.url)
                            end
                        else -- 直接记录
                            self.scene:setLatestChatMsg(msgInfo.n,"",pack.uid,msgInfo.url)
                        end
                    end
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[2] then  --设置礼物
                self.model:processSetGift(msgInfo)
                if msgInfo.seatId and msgInfo.seatId~=-1 then
                    self.seatManager:updateGiftUrl(msgInfo.seatId, msgInfo.gid)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[6] then  --赠送礼物
                self.model:processSendPresentGift(msgInfo)
                if msgInfo.fromSeatId ~= -1 and #msgInfo.toSeatIdArr > 0 then
                    self.animManager:playSendGiftAnimation(msgInfo.gid, msgInfo.id, msgInfo.toUidArr)
                elseif #msgInfo.toSeatIdArr > 0 then
                    for _, seatId in ipairs(msgInfo.toSeatIdArr) do
                        if seatId ~= -1 then
                            self.seatManager:updateGiftUrl(seatId, msgInfo.gid)
                        end
                    end
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[3] then  --互动道具
                if pack.uid~=tx.userData.uid then
                    self.animManager:playHddjAnimation(msgInfo.from,msgInfo.to,msgInfo.id)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[4] then  --加好友
                if pack.uid~=tx.userData.uid then
                    self.animManager:playAddFriendAnimation(msgInfo.from,msgInfo.to)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[5] then  --送筹码
                if pack.uid~=tx.userData.uid then
                    model:processSendChipSuccess(msgInfo,((msgInfo.isInT)==1))
                    self.animManager:playSendChipAnimation(msgInfo.from,msgInfo.to,msgInfo.chips)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[7] then  --信息同步
                model:svrModifyUserinfo(pack)
                self.seatManager:updateSeatState(seatId)
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[8] then  --亮牌~~
                -- 当前正好是游戏结束状态
                if seatId>-1 and model.gameInfo and model.gameInfo.gameStatus>=consts.SVR_GAME_STATUS.READY_TO_START then
                    local seatView = self.seatManager:getSeatView(seatId)
                    if seatView then
                        local num = 2
                        local cardList = {}
                        local sum = 0
                        for i = 1, num do
                            cardList[i] = msgInfo[i] or msgInfo["" .. i]
                            sum = sum + cardList[i]
                        end

                        if sum == 0 then
                            return
                        end

                        local positionId = self.seatManager:getSeatPositionId(seatId)
                        self.dealCardManager:hideDealedCard(positionId)
                        if player.isSelf then
                            seatView:showLiangPai2(cardList)
                            self.oprManager:hideShowBtn(cardList)
                            self.dealCardManager:showLiangPai(10, cardList, msgInfo.cardTypeName)
                        else
                            self.dealCardManager:showLiangPai(positionId, cardList, msgInfo.cardTypeName)
                        end
                    end
                end
            end
        end
    elseif cmd == PROTOCOL.TABLE_SVR_ON_EXP then
        local seatId,player = model:getSeatIdByUid(pack.uid)
        if seatId>-1 and player then
            self.animManager:playExpression(seatId, pack.expId)
        end
    elseif cmd== PROTOCOL.HALL_SVR_PRIVATE_ROOM_INFO then -- 私人房
        if model then
            model.roomFlag_ = 1
            if model.roomInfo then
                model.roomInfo.roomFlag = 1
            end
        end
        if self.scene and self.scene.setPrivateRoomInfo then
            self.scene:setPrivateRoomInfo(pack)
            if model:getNumInSeat()>1 then
                self.scene:hideShareBtn()
            end
        end
    elseif cmd == PROTOCOL.TABLE_BROADCAST then
    else
        logger:debugf("not processed pack %x", pack.cmd)
    end
end

--申请自动坐下
function RoomController:applyAutoSitDown(lastRequestSeatId)
    if not self.model:isSelfInGame() then
        local emptySeatId = lastRequestSeatId or self.seatManager:getEmptySeatId()
        if emptySeatId then
            local isAutoSit = tx.userDefault:getBoolForKey(tx.cookieKeys.AUTO_SIT, true)
            if isAutoSit or _G.Quick_Play_Now==1 then
                local userData = tx.userData
                local money = userData.money
                local minIn = self.model.roomInfo.minBuyIn
                if money >= minIn then
                    logger:debug("auto sit down", emptySeatId)
                    local isAutoBuyin = tx.userDefault:getStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
                    local isAutoIn = false
                    local autoInType = 0
                    if isAutoBuyin=="true" or isAutoBuyin=="1" then
                        isAutoIn = true
                    elseif isAutoBuyin=="2" then
                        isAutoIn = true
                        autoInType = 1
                    end
                    self.lastRequestSeatId = emptySeatId
                    -- 快速开始
                    local autoTakeMoney = minIn
                    local multi = money/minIn
                    if multi>10 then
                        autoTakeMoney = self.model.roomInfo.maxBuyIn
                    elseif multi>5 then
                        autoTakeMoney = (self.model.roomInfo.maxBuyIn - minIn)*0.5 + minIn
                    elseif multi>=2 then
                        autoTakeMoney = money*0.5
                    end
                    -- 算错了大于自己的钱
                    if autoTakeMoney>money then
                        autoTakeMoney = money
                    end

                    if _G.curInGameId == 5 then
                        autoTakeMoney = minIn
                    end
                    tx.socket.HallSocket:sendGameCmd("sendSitDown",emptySeatId,autoTakeMoney,isAutoIn and 1 or 0,autoInType)
                else
                    if _G.Quick_Play_Now~=1 then
                        return
                    end
                    --这里可能scene还未切换完成，等待1S再弹对话框
                    self.sceneSchedulerPool:delayCall(function()
                        self.scene:sitFailHandler()
                    end, 1)
                end
            end
        else
            logger:debug("can't auto sit down, no emtpy seat")
        end
    end
end

function RoomController:dealCardProb(clear)
    local ctx = self.ctx
    local model = self.model
    local aysManager = self.aysManager
    if clear==true then
        if aysManager then
            aysManager:getProbValue()
            self.scene:dealCardTypeWord(aysManager.probValue)
        end
        self.scene:dealCardPower(false)
        return
    end
    if model and model.gameInfo and model.gameInfo.handCards and model.gameInfo.handCards[1] and model.gameInfo.handCards[1]>0 then
        -- 加上翻一张牌时间
        local list = {model.gameInfo.handCards[1],model.gameInfo.handCards[2]}
        if model.gameInfo.pubCards then
            for k,v in pairs(model.gameInfo.pubCards) do
                if v>0 then
                    table.insert(list,v)
                end
            end
        end
        if aysManager then
            aysManager:getProbValue(list)
            self.scene:dealCardTypeWord(aysManager.probValue)
        end
        -- 牌力指示器 重服务器获取
        if model:isSelfInGame() then
            self.scene:dealCardPower()
        else
            self.scene:dealCardPower(false)
        end
    else
        if aysManager then
            aysManager:getProbValue()
            self.scene:dealCardTypeWord(aysManager.probValue)
        end
        self.scene:dealCardPower(false)
    end
end

function RoomController:updateChangeRoomButtonMode()
    if self.model:isSelfInSeat() then
        self.scene:setChangeRoomButtonMode(2)
    else
        self.scene:setChangeRoomButtonMode(1)
    end
end

function RoomController:showGuidePopup()
    if self.showGuideTimes_ >= 3 then
        return
    end

    local smallblind = self.model.roomInfo.blind
    if smallblind <= tx.userData.maxGuideBlind and self.playGameNum_ >= tx.userData.guideGameNum and tx.userData.money > (smallblind * tx.userData.guideMultiple) then
        self.playGameNum_ = 0
        self.showGuideTimes_ = self.showGuideTimes_ + 1
        tx.ui.Dialog.new({
            -- hasCloseButton = false,
            closeWhenTouchModel = true,
            messageText = sa.LangUtil.getText("HALL", "TEXAS_GUIDE_TIPS_3"),
            firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
            secondBtnText = sa.LangUtil.getText("HALL", "TEXAS_UPGRADE"),
            callback = function (btnType)
                if btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
                    self.showGuideTimes_ = 0
                    self:gotoHigherRoom()
                end
            end
        }):show()
    end
end

function RoomController:gotoHigherRoom()
    self.scene:changeRoomFromQuickStart()
end

function RoomController:reset()
    self.hasReset_ = true

    self.model:reset()
    self.dealCardManager:reset()
    self.chipManager:reset()
    self.seatManager:reset()
    self.publicCardManager:reset()
    self.animManager:reset()
    self.lampManager:hide()
    -- 亮牌
    self.oprManager:setShowCardStatus(true)

    self.schedulerPool:clearAll()
    self.gameSchedulerPool:clearAll()
end

function RoomController:bindDataObservers_()
end

function RoomController:unbindDataObservers_()
end

function RoomController:changeDealer(dealerId)
    self.dealerManager:changeDealer(dealerId, false)
end

function RoomController:updateGoldIslandBuyStatus_(isBuy)
    tx.userData.isBuyGoldIsland = isBuy
    sa.EventCenter:dispatchEvent(tx.eventNames.UPDATE_GOLD_ISLAND_BUY_STATUS)
end

function RoomController:autoBuyGoldIsland_()
    if tx.userData.autoBuyGoldIsland and not tx.userData.isBuyGoldIsland then
        self:buyGoldIsland()
    end
end

function RoomController:buyGoldIsland()
    local model = self.model
    if model:isSelfInSeat() then
        local data = model:selfSeatData()
        local blind = model.roomInfo.blind * 2
        local betChips = tx.userData.goldIslandConfig.betChips
        if data.seatChips >= blind + betChips then
            tx.HorseLamp:showTips(sa.LangUtil.getText("GOLDISLAND", "BUY_SUCCESS"))
            tx.socket.HallSocket:sendGameCmd("sendBuyGoldIsland", betChips)
            data.seatChips = data.seatChips - betChips
            self.seatManager:updateSeatState(model:selfSeatId())
            self.scene:updateGoldIslandBtnStatus(true)
            self:updateGoldIslandBuyStatus_(true)
        else
            if tx.userData.autoBuyGoldIsland then
                tx.userData.autoBuyGoldIsland = false
            end
            tx.HorseLamp:showTips(sa.LangUtil.getText("GOLDISLAND", "BUY_FAILED"))
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("GOLDISLAND", "BUY_TIPS"))
    end
end

return RoomController
