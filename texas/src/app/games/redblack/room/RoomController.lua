local RoomController        = class("RoomController")

local logger                = sa.Logger.new("RoomController")
local P                     = import("..net.PROTOCOL")
local RoomModel             = import(".model.RoomModel")
local SeatManager           = import(".SeatManager")
local DealCardManager       = import(".DealCardManager")
local ChipManager           = import(".ChipManager")
local AnimManager           = import(".AnimManager")
local OperationManager      = import(".OperationManager")
local BetTypeManager        = import(".BetTypeManager")
local BetChipView           = import(".views.BetChipView")

local PACKET_PROC_FRAME_INTERVAL = 2

function RoomController:ctor(scene)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local ctx = {}
    ctx.roomController = self
    ctx.scene = scene
    ctx.model = RoomModel.new(ctx)
    ctx.controllerEventProxy = cc.EventProxy.new(self, scene)
    ctx.schedulerPool = sa.SchedulerPool.new()
    ctx.sceneSchedulerPool = sa.SchedulerPool.new()
    ctx.gameSchedulerPool = sa.SchedulerPool.new()

    ctx.seatManager = SeatManager.new(ctx)

    ctx.dealCardManager = DealCardManager.new()
    ctx.betTypeManager = BetTypeManager.new()
    ctx.chipManager = ChipManager.new()
    ctx.animManager = AnimManager.new()
    ctx.oprManager = OperationManager.new()

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
    ctx.export(ctx.dealCardManager)
    ctx.export(ctx.betTypeManager)
    ctx.export(ctx.chipManager)
    ctx.export(ctx.animManager)
    ctx.export(ctx.oprManager)

    cc.EventProxy.new(tx.socket.HallSocket, scene)
        :addEventListener(tx.socket.HallSocket.EVT_PACKET_RECEIVED, handler(self, self.onPacketReceived_))
        :addEventListener(tx.socket.HallSocket.EVT_CONNECTED, handler(self, self.onConnected_))

    self.packetCache_ = {}
    self.loginRoomRetryTimes_ = 0
    self.frameNo_ = 1

    ctx.sceneSchedulerPool:loopCall(handler(self, self.onEnterFrame_), 1 / 30)
    ctx.sceneSchedulerPool:loopCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        return not self.isDisposed_
    end, 60)
end

function RoomController:dispose()
    self.isDisposed_ = true
    self.seatManager:dispose()
    self.dealCardManager:dispose()
    self.chipManager:dispose()
    self.animManager:dispose()
    self.oprManager:dispose()
    self.betTypeManager:dispose()

    self.schedulerPool:clearAll()
    self.sceneSchedulerPool:clearAll()
    self.gameSchedulerPool:clearAll()

    self:unbindDataObservers_()
end

function RoomController:createNodes()
    self.seatManager:createNodes()
    self.betTypeManager:createNodes()
    self.dealCardManager:createNodes()
    self.chipManager:createNodes()
    self.animManager:createNodes()
    self.oprManager:createNodes()

    self.betTypeManager:setBetEnabled(false)

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
            for i, v in ipairs(self.packetCache_) do
                if v.cmd == P.SVR_GAME_OVER then
                    if removeFromIdx == 0 then
                        removeFromIdx = i
                    else
                        removeEndIdx = i --到最后一个结束包
                    end
                elseif v.cmd == P.SVR_GAME_START then
                    self:reset()--从后台切回来，可能显示之前的倒计时，所以先reset一次，不会有影响
                    startPackIndex = i
                end
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
                for kk,vv in ipairs(self.packetCache_) do
                    local pack = table.remove(self.packetCache_, 1)
                    self:processPacket_(pack)
                end
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
        logger:debugf("RedBlackRoomController.processPacket[%x]%s", cmd, table.keyof(P, cmd))
    else
        logger:debugf("RedBlackRoomController.processPacket[%x]%s", cmd, table.keyof(PROTOCOL, cmd))
    end

    if _G.curInGameId ~= P.GAMEID then --邀请进入其他游戏房间，RoomController还没销毁，还能调用这个接口，所以要判断当前游戏场景是否和协议一致
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

        --初始化座位
        ctx.seatManager:initSeats(model.playerList)

        tx.userData.money = pack.userChips

        ctx.scene:updateBetOdds(pack.betOddsList)

        ctx.dealCardManager:hideElephantIcon()

        self:applyAutoSitDown(model.playerList)
        
        self.isHandleGameOver_ = true --重连的时候，如果正在结算，不处理结算包
        if pack.gameStatus == 1 or pack.gameStatus == 2 then --1发牌,2下注中
            ctx.dealCardManager:showDealedCard(pack.pubCard)
            if pack.gameStatus == 2 then
                ctx.chipManager:updateAllChips(pack.allBetList)
                ctx.betTypeManager:updateBetStatus(pack.selfBetList, pack.allBetList)
                ctx.betTypeManager:setBetEnabled(true)
                ctx.dealCardManager:showBetStatus(model:getBetLeftTime())
            else
                ctx.dealCardManager:playElephantAnimation(true)
            end
        elseif pack.gameStatus == 10 then
            self.isHandleGameOver_ = false
            ctx.dealCardManager:playGameStartTime(model:getGameLeftTime(), true)
        end
    elseif cmd == P.SVR_GAME_START then
        self.isHandleGameOver_ = true
        if not self.hasReset_ then
            self:reset()
        end
        self.hasReset_ = false

        --牌局开始
        model:processGameStart(pack)
        for _, v in ipairs(pack.playerList) do
            ctx.seatManager:updateSeatState(v.seatId)
        end

        self.gameSchedulerPool:delayCall(function ()
            ctx.dealCardManager:playStartAnimation(pack.pubCard)
        end, 0.2)
    elseif cmd == P.SVR_START_BET then--开始下注
        ctx.betTypeManager:setBetEnabled(true)
        ctx.dealCardManager:playBetStatusAnimation(model:getBetTime())
        ctx.oprManager:updateBetButtonState()
    elseif cmd == P.SVR_BET_SUCCESS then--下注成功
        for _, v in ipairs(pack.playerList) do
            local uid = v.uid
            if uid ~= tx.userData.uid then
                for _, vv in ipairs(v.betList) do
                    model:processOtherBetSuccess(uid, vv.betChips)
                    ctx.chipManager:betChipOther(uid, vv.betType, vv.betChips, function()
                        ctx.seatManager:updateSeatState(v.seatId)
                        ctx.betTypeManager:updateAllChips(vv.betType, vv.betChips)
                    end)
                end
            end
        end
    elseif cmd == P.SVR_SELF_BET_FAIL then
        tx.TopTipManager:showToast(sa.LangUtil.getText("REDBLACK","BET_FAILD_TIMES_OUT"))
        tx.userData.money = pack.seatChips
        ctx.betTypeManager:updateBetFailedStatus(pack.betType, pack.betChips, pack.betTotalChips)
    elseif cmd == P.SVR_SIT_DOWN then --坐下
        local seatId, isSelf = model:processSitDown(pack)
        if not isSelf then
            ctx.seatManager:updateUserSitDown(seatId)
        end
    elseif cmd == P.SVR_STAND_UP then --站起
        local seatId = pack.seatId
        model:processStandUp(seatId)
        ctx.seatManager:updateUserStandUp(seatId)
    elseif cmd == P.SVR_GAME_OVER then
        ctx.betTypeManager:setBetEnabled(false)
        ctx.oprManager:stopBetButton()
        self.hasReset_ = false   -- 切入后台BUG
        self.gameSchedulerPool:clearAll()
        model:updateCountList(pack.winResult)

        if not self.isHandleGameOver_ then
            return
        end

        local result = model:processGameOver(pack)
        local t = 0.5
        self.schedulerPool:delayCall(function ()
            ctx.dealCardManager:showGameOverStatus(result)
        end, t)

        t = t + 3
        self.schedulerPool:delayCall(function ()
            ctx.betTypeManager:showWinType(result.winData)
        end, t)

        t = t + 0.5
        self.schedulerPool:delayCall(function ()
            ctx.chipManager:showWinResult(result.winData, result.winner)
        end, t)

        t = t + 2.5
        self.schedulerPool:delayCall(function ()
            ctx.chipManager:showAddChipView(nil, pack.betResult, tx.userData.uid)

            for _, v in ipairs(pack.playerList) do
                if v.uid ~= tx.userData.uid then
                    ctx.chipManager:showAddChipView(v.seatId, v.betResult, v.uid)
                    ctx.seatManager:updateSeatState(v.seatId)
                end
            end

            self:showBroke_(pack.userChips)
        end, t)

        t = t + 1
        self.schedulerPool:delayCall(function ()
            local cardType = pack.r_card_type
            if pack.winner == 2 then
                cardType = pack.b_card_type
            end
            
            local history = {
                winner = pack.winner,
                cardType = cardType
            }
            ctx.betTypeManager:updateHistory(pack.winner)
            model:updateHistory(history)
            ctx.dealCardManager:playElephantOverAnimation()

            self:reset() 
            ctx.dealCardManager:showGameStartTime()
        end, t)
    elseif cmd == P.SVR_GET_HISTORY then
        local len = #pack.history
        local history = pack.history
        if len > 10 then
            history = table.slice(pack.history, len - 9)
        end
        ctx.betTypeManager:setHistory(history)
        model:setHistory(pack)
    elseif cmd == P.SVR_SIT_DOWN_FAIL then --坐下失败
        -- 现在暂时不需要处理这个协议
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

        if msg then
            tx.TopTipManager:showToast(msg)
        end
    elseif cmd == PROTOCOL.TABLE_SVR_ON_MSG then
        local seatId,player = model:getSeatIdByUid(pack.uid)
        local positionId = ctx.seatManager:getPosition(seatId, pack.uid)
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
                        ctx.animManager:showChatMsg(pack.uid, msgInfo.m, msgInfo.v)
                        --更新最近聊天文字
                        self.scene:setLatestChatMsg(msgInfo.n,msgInfo.m,pack.uid)
                        -- 快捷聊天音效
                        if positionId and positionId ~= 10 and appconfig.LANG=="th" then --不在旁观位置
                            for k,v in ipairs(shortcutList) do
                                if msgInfo.m==v then
                                    tx.SoundManager:playChatSound(k)
                                    break
                                end
                            end
                        end
                    elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[9] and msgInfo.url and tx.VoiceSDK and tx.VoiceSDK.open then  -- 语音聊天
                        -- 添加历史聊天记录
                        if positionId and positionId ~= 10 then
                            if self.scene:checkPlayVoice(pack) then --同一时间只能播放一个声音 先缓存吧
                                ctx.animManager:playVoiceChat(pack.uid, msgInfo)
                                self.scene:setLatestChatMsg(msgInfo.n,"",pack.uid,msgInfo.url)
                            end
                        else -- 直接记录
                            self.scene:setLatestChatMsg(msgInfo.n,"",pack.uid,msgInfo.url)
                        end
                    end
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[3] then  --互动道具
                if pack.uid~=tx.userData.uid then
                    local extraData = {
                        fromUid = msgInfo.fromUid,
                        toUid = msgInfo.toUid
                    }
                    ctx.animManager:playHddjAnimation(msgInfo.from, msgInfo.to, msgInfo.id, extraData)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[4] then  --加好友
                if pack.uid~=tx.userData.uid then
                    local extraData = {
                        fromUid = msgInfo.fromUid,
                        toUid = msgInfo.toUid
                    }
                    ctx.animManager:playAddFriendAnimation(msgInfo.from, msgInfo.to, extraData)
                end
            elseif msgInfo.t==PROTOCOL.TABLE_MSG_TYPES[7] then  --信息同步
                if pack.uid==tx.userData.uid then-- 自己已经修改过了
                elseif seatId and seatId>=0 and seatId<=8 then
                    model:svrModifyUserinfo(pack)
                    ctx.seatManager:updateSeatState(seatId)
                end
            end
        end
    elseif cmd == PROTOCOL.TABLE_SVR_ON_EXP then
        ctx.animManager:playExpression(pack.uid, pack.expId)
    elseif cmd == P.SVR_LOGIN_FAIL then
    elseif cmd == P.SVR_GET_ALL_USERINFO then
        self.allUserList = pack.allUserList
        self.getAllUserListTime = os.time()
        sa.EventCenter:dispatchEvent({name=tx.eventNames.REDBLACK_ALL_PLAYER_LIST, data=pack.allUserList})
    else
        logger:debugf("not processed pack %x", pack.cmd)
    end
end

--申请自动坐下
function RoomController:applyAutoSitDown()
    if not self.model:isSelfInGame() then
        local seatId = self.seatManager:getEmptySeatId()
        if seatId then
            logger:debug("auto sit down", seatId)
            tx.socket.HallSocket:sendGameCmd("sendSitDown", seatId, tx.userData.money)
        else
            logger:debug("can't auto sit down, no emtpy seat")
        end
    end
end

function RoomController:showBroke_(money)
    if self.ctx.model:isSelfPlaying() then
        tx.userData.money = money
        if not self.scene.isback_ and self.scene.onBrokeShow and (tx.userData.money+tx.userData.safe_money)<appconfig.CRASHMONEY then
            local gameId = P.GAMEID
            local blind = 5000
            self.scene:onBrokeShow({gameId=gameId,blind=blind})
        end
    end
end

function RoomController:reset()
    self.hasReset_ = true
    self.dealCardManager:reset()
    self.chipManager:reset()
    self.betTypeManager:reset()
    self.oprManager:reset()
    self.animManager:reset()

    self.schedulerPool:clearAll()
    self.gameSchedulerPool:clearAll()
end

function RoomController:bindDataObservers_()
    
end

function RoomController:unbindDataObservers_()
    
end

return RoomController
