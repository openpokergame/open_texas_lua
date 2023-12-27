local SeatManager = class("SeatManager")

local SeatView              = import(".views.SeatView")
local RoomViewPosition      = import(".views.RoomViewPosition")
local BuyInPopup            = import(".views.BuyInPopup")
local RoomLevelUp           = import("app.module.room.levelup.RoomLevelUp")
local UserInfoPopup         = import("app.module.userInfo.UserInfoPopup")

local SeatPosition = RoomViewPosition.SeatPosition

local SEAT_PROGRESS_TIMER_TAG = 8390

local SEATS_9 = {0, 1, 2, 3, 4, 5, 6, 7, 8}
local SEATS_6 = {0, 1, 2, 3, 4, 5}
local SEATS_5 = {0, 2, 4, 6, 8}
local SEATS_2 = {2, 6}

local function isHandcard3_(handcards)
    return handcards and #handcards == 3 and handcards[1] and handcards[2] and handcards[3] and handcards[1] > 0 and handcards[2] > 0 and handcards[3] > 0
end

local function isHandcard2_(handcards)
    return handcards and handcards[1] and handcards[2] and handcards[1] > 0 and handcards[2] > 0
end

local logger = sa.Logger.new("SeatManager")

function SeatManager:ctor(ctx)
    SeatPosition = RoomViewPosition.SeatPosition
    self.appEnterForegroundListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.APP_ENTER_FOREGROUND, handler(self, self.onAppEnterForeground_))
    self.appEnterBackgroundListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.APP_ENTER_BACKGROUND, handler(self, self.onAppEnterBackground_))
    self.addExpListenerId_ =  sa.EventCenter:addEventListener(tx.eventNames.SVR_BROADCAST_ADD_EXP, handler(self, self.onAddExp))
    self.onOffLoadId_ = sa.EventCenter:addEventListener("OnOff_Load", handler(self, self.onOffLoadCallback_))
    self.onAddMoneyAnimationId_ =  sa.EventCenter:addEventListener("onAddMoneyAnimationEvent", handler(self, self.onAddMoneyAnimation))
end

function SeatManager:createNodes()
    --创建座位
    self.seats_ = {}
    for i = 0, 8 do
        local seat = SeatView.new(self.ctx, i)
        cc.EventProxy.new(seat, self.scene)
            :addEventListener(SeatView.CLICKED, handler(self, self.onSeatClicked_))
        self.seats_[i] = seat
        -- 测试
        local pos = SeatPosition[i + 1]
        seat:setPosition(pos)
        seat:setPositionId(i + 1)
        seat:addTo(self.scene.nodes.seatNode)
    end
end

function SeatManager:onAppEnterBackground_()
    logger:debug("onAppEnterBackground_", self.counterSeatId_)
    local counterSeatId = self.counterSeatId_
    self:stopCounter()
    self.counterSeatId_ = counterSeatId
end

function SeatManager:onAppEnterForeground_()
    logger:debug("onAppEnterForeground_", self.counterSeatId_)

    --延时0.1s，如果这里直接开始计时, 测试时发现有可能导致材质损坏
    self.gameSchedulerPool:delayCall(function()
        local counterSeatId = self.counterSeatId_
        if counterSeatId then
            logger:debug("startCounter", counterSeatId)
            self:stopCounter()
            self:startCounter(counterSeatId)
        end
    end, 0.1)
end

function SeatManager:dispose()
    if self.seats_ then
        for i,v in pairs(self.seats_) do
            local seat = self.seats_[i]
            if seat then
                local counter = seat:getChildByTag(SEAT_PROGRESS_TIMER_TAG)
                if counter then
                    counter:pause()
                    counter:removeFromParent()
                end
                seat:dispose()
            end
        end
    end
    if self.appEnterForegroundListenerId_ then
        sa.EventCenter:removeEventListener(self.appEnterForegroundListenerId_)
        self.appEnterForegroundListenerId_ = nil
    end
    if self.appEnterBackgroundListenerId_ then
        sa.EventCenter:removeEventListener(self.appEnterBackgroundListenerId_)
        self.appEnterBackgroundListenerId_ = nil
    end
    if self.addExpListenerId_ then
        sa.EventCenter:removeEventListener(self.addExpListenerId_)
        self.addExpListenerId_ = nil
    end
    if self.onOffLoadId_ then
        sa.EventCenter:removeEventListener(self.onOffLoadId_)
        self.onOffLoadId_ = nil
    end
    if self.onAddMoneyAnimationId_ then
        sa.EventCenter:removeEventListener(self.onAddMoneyAnimationId_)
        self.onAddMoneyAnimationId_ = nil
    end
end

function SeatManager:getSeatView(seatId)
    return self.seats_[seatId]
end

function SeatManager:getSelfSeatView()
    return self:getSeatView(self.model:selfSeatId())
end

function SeatManager:getSeatPosition(seatId)
    local seat = self.seats_[seatId]
    if seat then
        return SeatPosition[seat:getPositionId()]
    end
    return nil
end

function SeatManager:getSeatPositionId(seatId)
    local seat = self.seats_[seatId]
    if seat then
        return seat:getPositionId()
    end
    return nil
end

function SeatManager:getEmptySeatId()
    if self.seatIds_ then
        local playerList = self.model.playerList
        for i, seatId in ipairs(self.seatIds_) do
            if not playerList[seatId] then
                return seatId
            end
        end
    end
    return nil
end

function SeatManager:initSeats(seatsInfo, playerList, specialSeatId)
    local model = self.model
    local scene = self.scene
    local seats = self.seats_
    assert(seatsInfo and seatsInfo.seatNum, "seatNum is nil")
    local P = SeatPosition
    local seatIds = nil
    if seatsInfo.seatNum == 9 then
        seatIds = SEATS_9
    elseif seatsInfo.seatNum == 6 then
        seatIds = SEATS_6
    elseif seatsInfo.seatNum == 5 then
        seatIds = SEATS_5
    elseif seatsInfo.seatNum == 2 then
        seatIds = SEATS_2
    end
    self.seatIds_ = seatIds

    self.dealCardManager:reset()
    -- for seatId = 0, 8 do
    for seatId, v in pairs(self.seats_) do
        local shouldShow = false
        if seatIds then
            for i, v in ipairs(seatIds) do
                if v == seatId then
                    shouldShow = true
                    break
                end
            end
        end
        if seatId==specialSeatId then  -- 庄家座位ID
            shouldShow = true
        end

        local seat = self.seats_[seatId]
        local pos = P[seatId + 1]
        seat:setPosition(pos)
        seat:setPositionId(seatId + 1)

        if shouldShow then
            local player = playerList[seatId]
            seat:resetToEmpty()
            seat:setSeatData(player)
            -- 猎杀动画移动动画播放器中了，确保添加成功
            local curParent = seat:getParent()
            if curParent and curParent~=scene.nodes.seatNode then
                seat:removeFromParent()
                curParent = nil
            end

            if not curParent then
                seat:addTo(scene.nodes.seatNode, seatId + 1, seatId + 1)
                seat:enableTouch()
            end

            if player then
                local gameStatus = self.model.gameInfo.gameStatus
                if player.isSelf then
                    local is3 = isHandcard3_(player.handCards)
                    local is2 = isHandcard2_(player.handCards)
                    if is3 then
                        seat:setHandCardNum(3)
                    elseif is2 then
                        seat:setHandCardNum(2)
                    end
                    if player.handCards and #player.handCards > 1 and player.handCards[1]>0 then
                        seat:setHandCardValue(player.handCards)
                        seat:showHandCardFrontAll()
                        seat:showAllHandCardsElement()
                        seat:showHandCards()
                        seat:showCardTypeIf()
                        -- if player.betState == consts.SVR_BET_STATE.FOLD then  --已经弃牌

                        -- end
                    else
                        seat:hideHandCards()
                    end
                else
                    if player.playing==1 and player.betState ~= consts.SVR_BET_STATE.FOLD then
                        self.dealCardManager:showDealedCard(player, 2)
                    end
                end
                -- 重连AllIn状态没有显示
                if player.betState == consts.SVR_BET_STATE.ALL_IN then
                    seat:playAllInAnimation()
                end
            end

            seat:updateState()
        else
            seat:removeFromParent()
        end
    end
end

function SeatManager:rotateSeatToOrdinal()
    if self.dealCardRotateShowDelayId_ then
        self.schedulerPool:clear(self.dealCardRotateShowDelayId_)
        self.dealCardRotateShowDelayId_ = nil
    end

    local seat = self.seats_[2]
    local positionId = seat:getPositionId()
    if positionId ~= 3 then
        local step = positionId - 3
        self:rotateSeatByStep_(step, true)
    else  -- 自己的大头像盖住了庄家
        self.animManager:rotateDealer(0)
    end
    if self.selfArrowDelayId_ then
        self.schedulerPool:clear(self.selfArrowDelayId_)
        self.selfArrowDelayId_ = nil
    end
end

function SeatManager:rotateSelfSeatToCenter(selfSeatId, animation)
    if self.dealCardRotateShowDelayId_ then
        self.schedulerPool:clear(self.dealCardRotateShowDelayId_)
        self.dealCardRotateShowDelayId_ = nil
    end

    local selfSeat = self.seats_[selfSeatId]
    local selfPositionId = selfSeat and selfSeat:getPositionId()
    if selfPositionId ~= 5 then
        local step = selfPositionId - 5
        self:rotateSeatByStep_(step, animation)
    else  -- 自己的大头像盖住了庄家
        self.animManager:rotateDealer(0)
    end
    if animation then
        -- 新版
        local selfSeat = self:getSelfSeatView()
        if selfSeat then
            local spAnim = sp.SkeletonAnimation:create("spine/sitandpro.json","spine/sitandpro.atlas")
                :pos(SeatPosition[5].x + RoomViewPosition.SelfOffsetX , SeatPosition[5].y + RoomViewPosition.SelfOffsetY)
                :addTo(self.scene.nodes.animNode)
            spAnim:registerSpineEventHandler(function (event)
                    if event.type == "complete" then
                        spAnim:performWithDelay(function()
                            spAnim:removeFromParent()
                        end, 0.01)
                    end
            end, sp.EventType.ANIMATION_COMPLETE)
            --Vip
            local vip = 0
            if tx.userData.vipinfo and tx.userData.vipinfo.level then
                vip = tonumber(tx.userData.vipinfo.level) or 0
            end
            if vip>0 then
                spAnim:setAnimation(0, "3", false)
            else
                spAnim:setAnimation(0, "1", false)
            end

            selfSeat:stopAllActions()  -- 自己的动画停止
            selfSeat:setLocalZOrder(10)
            selfSeat:pos(SeatPosition[5].x, SeatPosition[5].y + 400)
            selfSeat:runAction(cc.MoveTo:create(0.4, cc.p(SeatPosition[5].x, SeatPosition[5].y)))
        end
    end
end

function SeatManager:rotateSeatByStep_(step, animation)
    if step > 4 then
        step = step - 9
    elseif step < -4 then
        step = step + 9
    end
    self.dealCardManager:reset()
    local setDealedCardDisplay = function()
        --显示手牌
        for i = 0, 8 do
            local player = self.model.playerList[i]
            if player and not player.isSelf and player.inGame then
                self.dealCardManager:showDealedCard(player, 2)
            end
        end
    end

    --转动座位
    local capacity = math.abs(step)
    for seatId = 0, 8 do
        local seat = self.seats_[seatId]
        local seatCurPos = seat:getPositionId()
        local len = 1
        if seat then
            local seatPa = {}
            seatPa[#seatPa + 1] = cc.p(seat:getPositionX(), seat:getPositionY())
            for i = 1, capacity do
                local idx
                if step > 0 then
                    --逆时针转
                    if seatCurPos - i >= 1 then
                        idx = seatCurPos - i
                    else
                        idx = seatCurPos - i + 9
                    end
                else
                    --顺时针转
                    if seatCurPos + i <= 9 then
                        idx = seatCurPos + i
                    else
                        idx = seatCurPos + i - 9
                    end
                end
                seatPa[#seatPa + 1] = SeatPosition[idx]
                if i == capacity then
                    seat:setPositionId(idx)
                    if not seat:getParent() or not animation then
                        seat:setPosition(SeatPosition[idx])
                    end
                end
            end
            if animation then
                if seat:getParent() then
                    -- seat:runAction(cc.CatmullRomTo:create(0.5, seatPa))
                    seat:runAction(cc.CatmullRomTo:create(0.4, seatPa))
                end
            end
        end
    end

    if animation then
        --隐藏手牌
        self.dealCardRotateShowDelayId_ = self.schedulerPool:delayCall(function()
            self.dealCardRotateShowDelayId_ = nil
            setDealedCardDisplay()
        end, 0.6)
    else
        setDealedCardDisplay()
    end

    --移动dealer位置
    self.animManager:rotateDealer(step)

    --转动灯光
    local lampPositionId = self.lampManager:getPositionId()
    lampPositionId = lampPositionId - step
    if lampPositionId > 9 then
        lampPositionId = lampPositionId - 9
    elseif lampPositionId < 1 then
        lampPositionId = lampPositionId + 9
    end
    self.lampManager:turnTo(lampPositionId, true)

    -- 转动筹码
    self.chipManager:moveChipStack()
end

function SeatManager:updateAllSeatState()
    for i,v in pairs(self.seats_) do
        local seat = self.seats_[i]
        seat:setSeatData(self.model.playerList[i])
        seat:updateState()
    end
end

function SeatManager:updateSeatState(seatId)
    local seat = self.seats_[seatId]
    if seat then
        local seatData = self.model.playerList[seatId]
        seat:setSeatData(seatData)
        seat:updateState()
    end
end

function SeatManager:playSitDownAnimation(seatId)
    local seat = self.seats_[seatId]
    if seat then
        seat:playSitDownAnimation()
    end
end

function SeatManager:fadeSeat(seatId)
    local seat = self.seats_[seatId]
    if seat then
        seat:fade()
    end
end

function SeatManager:playAllInAnimation(seatId, onCompleteCallback)
    local seat = self.seats_[seatId]
    if seat then
        seat:playAllInAnimation(onCompleteCallback)
    end
end

function SeatManager:playStandUpAnimation(seatId, onCompleteCallback)
    local seat = self.seats_[seatId]
    if seat then
        seat:playStandUpAnimation(onCompleteCallback)
    end
end

function SeatManager:updateHeadImage(seatId, imageUrl)
    local seat = self.seats_[seatId]
    if seat then
        if imageUrl then
            seat:updateHeadImage(imageUrl)
        end
    end
end

function SeatManager:updateGiftUrl(seatId, giftId)
    local seat = self.seats_[seatId]
    if seat and giftId then
        seat:updateGiftUrl(giftId)
    end
end

function SeatManager:playSeatWinAnimation(seatId, type_, label_,pot)
    local seat = self.seats_[seatId]
    if seat then
        seat:playWinAnimation(type_, label_, pot)
    end
end

function SeatManager:clearWinStatus()
    local seat = nil
    for i, v in pairs(self.seats_) do
        seat = self.seats_[i]
        if seat then
            seat:clearWinStatus()
        end
    end
end

function SeatManager:stopCounter()
    for i, v in pairs(self.seats_) do
        local counter = self.seats_[i]:getChildByTag(SEAT_PROGRESS_TIMER_TAG)
        if counter then
            counter:pause()
            counter:removeFromParent()
        end
    end
    if self.counterTimeoutId_ then
        self.schedulerPool:clear(self.counterTimeoutId_)
        self.counterTimeoutId_ = nil
    end
    if self.dealerTapTableTimeoutId_ then
        self.schedulerPool:clear(self.dealerTapTableTimeoutId_)
        self.dealerTapTableTimeoutId_ = nil
    end
    self.counterSeatId_ = nil
end

function SeatManager:stopCounterOnSeat(seatId)
    local counter = self.seats_[seatId]:getChildByTag(SEAT_PROGRESS_TIMER_TAG)
    if counter then
        counter:pause()
        counter:removeFromParent()

        if self.counterTimeoutId_ then
            self.schedulerPool:clear(self.counterTimeoutId_)
            self.counterTimeoutId_ = nil
        end
        if self.dealerTapTableTimeoutId_ then
            self.schedulerPool:clear(self.dealerTapTableTimeoutId_)
            self.dealerTapTableTimeoutId_ = nil
        end
        self.counterSeatId_ = nil
    end
end

function SeatManager:startCounter(seatId,leftTime)
    self:stopCounter()
    local seat = self.seats_[seatId]
    local seatData = seat:getSeatData()
    if seat and seatData then
        self.counterSeatId_ = seatId
        -- if USE_COUNTER_POOL then
        --     self.counterPool_:retrive():addTo(seat, 2, SEAT_PROGRESS_TIMER_TAG)
        -- else
            self.seatTimerBetExpire_ = self.model.roomInfo.betExpire or self.seatTimerBetExpire_
            if leftTime and leftTime>0 then
                self.seatTimerBetExpire_ = leftTime
            else -- 时间没转到底就到下一个操作了 外面延迟了0.5秒
                self.seatTimerBetExpire_ = self.seatTimerBetExpire_ - 0.5
            end
            if seatData and seatData.isSelf then
                local counterAnim = sp.SkeletonAnimation:create("spine/sitandpro.json","spine/sitandpro.atlas")
                    :pos(RoomViewPosition.SelfOffsetX, RoomViewPosition.SelfOffsetY)
                    :addTo(seat, 2, SEAT_PROGRESS_TIMER_TAG)
                counterAnim:setAnimation(0, 2, false)
                counterAnim:setTimeScale(15/self.seatTimerBetExpire_)
            else
                local counterAnim = sp.SkeletonAnimation:create("spine/sitandpro.json","spine/sitandpro.atlas")
                    :addTo(seat, 2, SEAT_PROGRESS_TIMER_TAG)
                counterAnim:setScaleX(SeatView.WIDTH/SeatView.SELFWIDTH)
                counterAnim:setScaleY(SeatView.HEIGHT/SeatView.SELFHEIGHT)
                counterAnim:setAnimation(0, 2, false)
                counterAnim:setTimeScale(15/self.seatTimerBetExpire_)
            end
        -- end
        if seatData.isSelf then
            self.counterTimeoutId_ = self.schedulerPool:delayCall(function() 
                seat:shakeAllHandCards()
            end, self.model.roomInfo.betExpire * 0.75)
        end

        -- 荷官敲桌子
        self.dealerTapTableTimeoutId_ = self.schedulerPool:delayCall(function() 
            self.dealerManager:tapTable()
        end, self.model.roomInfo.betExpire * 0.5)
    end
end

function SeatManager:setLoading(isLoading)
    if isLoading then
        if not self.scene.juhua_ then
            self.scene.juhua_ = tx.ui.Juhua.new()
                :pos(display.cx, display.cy)
                :addTo(self.scene)
        end
    else
        if self.scene.juhua_ then
            self.scene.juhua_:removeFromParent()
            self.scene.juhua_ = nil
        end
    end
end

function SeatManager:onSeatClicked_(evt)
    local seat = self.seats_[evt.seatId]
    if seat:isEmpty() then
        if self.model and not self.model:isSelfInSeat() then
            local canSeat = tx.userData.money < self.model.roomInfo.minBuyIn
            if canSeat then
                self.ctx.scene:sitFailHandler(self.model.roomInfo.minBuyIn)
            else
                BuyInPopup.new({
                        minBuyIn = self.model.roomInfo.minBuyIn,
                        maxBuyIn = self.model.roomInfo.maxBuyIn,
                        blind = self.model.roomInfo.blind,
                        callback = function(buyinChips, autoBuyType)
                            local isAutoIn = false
                            if autoBuyType>0 then
                                isAutoIn = true
                                if autoBuyType==2 then
                                    autoBuyType = 1
                                else
                                    autoBuyType = 0
                                end
                            else
                                autoBuyType = 0
                            end
                            self:onBuyin_(evt.seatId, buyinChips, isAutoIn, autoBuyType)
                        end
                    }):showPanel()
            end
        end
    elseif seat:getSeatData().isSelf then
        local tableAllUid, toUidArr = self.model:getTableAllUid()
        local tableNum = self.model:getNumInSeat()
        local tableMessage = {tableAllUid = tableAllUid,toUidArr = toUidArr,tableNum = tableNum}
        if self.isUserInfoClick_ then
            return
        end
        self.isUserInfoClick_ = true
        tx.schedulerPool:delayCall(function()
            self.isUserInfoClick_ = false
        end, 0.5)
        UserInfoPopup.new(self.ctx):show(true,tableMessage)
    else
        if self.isUserInfoOtherClick_ then
            return
        end
        self.isUserInfoOtherClick_ = true
        tx.schedulerPool:delayCall(function()
            self.isUserInfoOtherClick_ = false
        end, 0.5)
        local OtherUserRoomPopup = require("app.module.userInfo.OtherUserRoomPopup")
        OtherUserRoomPopup.new(self.ctx,seat:getSeatData()):showPanel()
    end
end

function SeatManager:onBuyin_(seatId, buyinChips, isAutoBuyin, autoBuyType)
    if self.ctx and self.ctx.roomController then
        self.ctx.roomController.lastRequestSeatId = seatId
    end
    tx.socket.HallSocket:sendGameCmd("sendSitDown",seatId,buyinChips,isAutoBuyin and 1 or 0, autoBuyType)
end

function SeatManager:showHandCard()
    for i, v in pairs(self.seats_) do
        local seat = self.seats_[i]
        local seatData = seat:getSeatData()
        if seatData and seatData.inGameBeforeGameOver then
            local handCards = seatData.handCards
            local is3 = isHandcard3_(handCards)
            local is2 = isHandcard2_(handCards)
            if is3 or is2 then
                if not seatData.isSelf then
                    self.dealCardManager:moveDealedCardToSeat(seatData, function()
                        print("seat " .. seat.seatId_ .. " showHandCard")
                        if seat:getSeatData() == seatData then
                            if is3 then
                                seat:setHandCardNum(3)
                            elseif is2 then
                                seat:setHandCardNum(2)
                            end
                            seat:setHandCardValue(handCards)
                            seat:showHandCardBackAll()
                            seat:showAllHandCardsElement()
                            seat:showHandCards()
                            seat:flipAllHandCards()
                            self.schedulerPool:delayCall(function() 
                                if seat:getSeatData() == seatData then
                                    seat:showCardTypeIf()
                                end
                            end, 0.8)
                        elseif seat:getSeatData() == nil then
                            print("seat " .. seat.seatId_ .. " player changed from " .. seatData.uid .. " to nil")
                        else
                            print("seat " .. seat.seatId_ .. " player changed from " .. seatData.uid .. " to " .. seat:getSeatData().uid)
                        end
                    end)
                else
                    if is3 then
                        seat:setHandCardNum(3)
                    elseif is2 then
                        seat:setHandCardNum(2)
                    end
                    seat:setHandCardValue(handCards)
                    seat:showAllHandCardsElement()
                    seat:showHandCardFrontAll()
                    seat:showHandCards()
                    seat:showCardTypeIf()
                end
            end
        end
    end
end

function SeatManager:prepareDealCards()
    local selfSeatId = self.model:selfSeatId()
    for i, v in pairs(self.seats_) do
        local seat = self.seats_[i]
        seat:setSeatData(self.model.playerList[i])
        seat:setHandCardNum(2)
        if i == selfSeatId then
            seat:setHandCardValue(seat:getSeatData().handCards)
            seat:showHandCardBackAll()
            seat:hideAllHandCardsElement()
            seat:showHandCards()
        else
            seat:showHandCardBackAll()
            seat:hideHandCards()
        end
    end
end

function SeatManager:onOffLoadCallback_()
    local selfSeatId = self.model:selfSeatId()
    if selfSeatId ~= -1 then
        local seat = self.seats_[selfSeatId]
    end
end

function SeatManager:onAddExp(evt)
    local selfSeatId = self.model:selfSeatId()
    if selfSeatId ~= -1 and evt and evt.exp and evt.exp ~= 0 then
        local seat = self.seats_[selfSeatId]
        if seat then
            seat:playExpChangeAnimation(evt.exp)
        end
    end
end
-- 筹码、黄金币变化
function SeatManager:onAddMoneyAnimation(evt)
    -- itype, value
    local evtData = evt.data
    if not evtData or not evtData.itype or not evtData.num or evtData.num == 0 then
        return
    end
    -- 
    local seatId = evtData.seatId or self.model:selfSeatId()
    if seatId ~= -1 then
        local seat = self.seats_[seatId]
        if seat then
            local rect = seat:getParent():convertToWorldSpace(cc.p(seat:getPosition()))
            local fontSize = 20
            if evtData.num > 0 then
                fontSize = 32
            end
            app:tip(evtData.itype, evtData.num, rect.x, rect.y-20)
        end
    end
end
--播放座位加经验的动画，只播放自己的
function SeatManager:playExpChangeAnimation()
    if self.model:isSelfInSeat() then
        local selfSeatId = self.model:selfSeatId()
        local playerSelf = self.model:selfSeatData()
        if playerSelf and playerSelf.inGameBeforeGameOver then
            if playerSelf.changeExp > 0 then
                self:expChange(playerSelf.changeExp)
                local seat = self.seats_[selfSeatId]
                if seat then
                    seat:playExpChangeAnimation(playerSelf.changeExp)
                end
            end
        end
    end
end

function SeatManager:expChange(changeExp)
    tx.userData.exp = tx.userData.exp + changeExp
    local level = tx.Level:getLevelByExp(tx.userData.exp) or tx.userData.level
    if tonumber(level) > tonumber(tx.userData.level) then
        self:levelUp_(level)
    else
        tx.userData.level = level
    end
    tx.userData.title = tx.Level:getTitleByExp(tx.userData.exp) or tx.userData.title
end

function SeatManager:levelUp_(level)
    tx.userData.level = level
    tx.userData.title = tx.Level:getTitleByLevel(level)
    local haveAward,awardInfo = tx.Level:checkLevelAward(level)
    if haveAward and awardInfo then
        self.schedulerPool:delayCall(function()
            tx.userData.nextRewardLevel = level
            RoomLevelUp.new(level,awardInfo)
        end, 2)
    end

    -- if device.platform == "android" or device.platform == "ios" then
    --     cc.analytics:doCommand{
    --         command = "setUserLevel",
    --         args = {level = level}
    --     }
    -- end

    if device.platform == "android" then
        tx.Native:reporttUserLevel(tx.userData.level)
    end
end

function SeatManager:stopAllInAnim()
    for i,v in pairs(self.seats_) do
        local seat = self.seats_[i]
        seat:stopAllInAnimation()
    end
end

function SeatManager:reset()
    for i,v in pairs(self.seats_) do
        local seat = self.seats_[i]
        seat:reset()
    end
    self:stopCounter()
end

return SeatManager
