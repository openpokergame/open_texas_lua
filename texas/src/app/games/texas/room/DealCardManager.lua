local DealCardManager = class("DealCardManager")

local HandCard = import(".views.HandCard")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomViewPosition = import(".views.RoomViewPosition")
local P = RoomViewPosition.DealCardPosition
local log = sa.Logger.new("DealCardManager")
local ShowHandCard = import(".views.ShowHandCard")

DealCardManager.tweenDuration = 0.25
DealCardManager.BIG_CARD_SCALE_X = 122/37
DealCardManager.BIG_CARD_SCALE_Y = 162/48

-- local tweenDuration = 0.5
local tweenDuration = DealCardManager.tweenDuration

local BIG_CARD_SCALE_X = DealCardManager.BIG_CARD_SCALE_X
local BIG_CARD_SCALE_Y = DealCardManager.BIG_CARD_SCALE_Y

function DealCardManager:ctor(dealCardsNum)
    P = RoomViewPosition.DealCardPosition
    self.startDeal_ = false
    self.dealCardsNum_ = dealCardsNum or 2 --每个玩家的扑克牌数量
end

function DealCardManager:createNodes()
    self.cardBatchNode_ = display.newNode():addTo(self.scene.nodes.dealCardNode)
    self.numNeedCards_ = 0
    --最多9个人，先创建好反面  -- 博定再加1个庄家位
    self.dealCards_ = {}
    for i = 1, self.dealCardsNum_ do
        self.dealCards_[i] = {}
        for j = 1, 10 do
            self.dealCards_[i][j] = display.newSprite("#common/poker_dealed_hand_card.png")
            self.dealCards_[i][j]:retain()
        end
    end
end

-- 从庄家位置开始发手牌
function DealCardManager:dealCards()
    self:dealCardsWithRound(1, self.dealCardsNum_)
end

-- startDealIndex扑克牌起始ID,endDealIndex扑克牌结束ID
function DealCardManager:dealCardsWithRound(startDealIndex, endDealIndex)
    if not self.dealCards_ then
        return self
    end
    self.currentDealSeatId_ = -1  -- 初始发牌座位id
    self.numInGamePlayers_  = 0   -- 在玩玩家数量
    self.numNeedCards_      = 0   -- 需要发牌的数量
    self.numDealedCards_    = 0   -- 已经发牌的数量
    self.dealSeatIdList_    = nil -- 需要发牌的座位id列表

    local gameInfo = self.model.gameInfo
    local playerList = self.model.playerList

    self.tempIndex_ = nil  -- 发牌BUG

    self.currentDealSeatId_ = gameInfo.dealerSeatId -- 从第一轮开始，则先从庄家位置开始发牌
    self.numInGamePlayers_ = self.model:getNumInRound() -- 当前在玩人数
    self.numNeedCards_ = self.numInGamePlayers_ * (endDealIndex - startDealIndex + 1) -- 计算本次需要发多少张牌
    self.dealSeatIdList_ = {}
    local index = 1
    for i = 0, 8 do
        if playerList[i] and playerList[i].inRound then
            self.dealSeatIdList_[index] = i
            if i == self.currentDealSeatId_ then
                self.tempIndex_ = index
            end
            index = index + 1
        end
    end

    -- 发牌报错【发牌时候玩家正好离开】只显示两张或者一张牌
    if not self.tempIndex_ then
        local index = 1
        for i = 0, 8 do
            local seatId = gameInfo.dealerSeatId + i
            if seatId > 8 then
                seatId = seatId - 9
            end
            local player = playerList[seatId]
            if player and player.inRound then
                self.currentDealSeatId_ = seatId
                self.tempIndex_ = index
                break
            end
            index = index + 1
        end
    end

    -- 发牌定时器
    if self.currentDealSeatId_ >= 0 and self.currentDealSeatId_ <= 8 then
        self.startDealIndex_ = startDealIndex -- 开始发第几张牌
        if self.scheduleHandle_ then
            scheduler.unscheduleGlobal(self.scheduleHandle_)
            self.startDeal_ = false
            self.stopPos = {}
            self.scheduleHandle_ = nil
        end
        self.startDeal_ = true
        self.scheduleHandle_  = scheduler.scheduleGlobal(handler(self, self.scheduleHandler), 0.1)
    end

    return self
end

--每轮发一张牌
function DealCardManager:scheduleHandler()
    self:dealCard_(self.seatManager:getSeatPositionId(self.currentDealSeatId_))
    -- 找到下一个需要发牌的座位id
    self.currentDealSeatId_ = self:findNextDealSeatId_()

    -- 已发牌总数加1
    self.numDealedCards_ = self.numDealedCards_ + 1
    if self.numDealedCards_ % self.numInGamePlayers_ == 0 then
        self.startDealIndex_ = self.startDealIndex_ + 1
    end
    -- 需发牌总数减1，发牌总数为0则已发完，结束发牌
    self.numNeedCards_ = self.numNeedCards_ - 1
    if self.numNeedCards_ == 0 then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.startDeal_ = false
        self.stopPos = {}
        self.scheduleHandle_ = nil
    end
end

--真正发牌逻辑
function DealCardManager:dealCard_(positionId)
    local dealingcard = self.dealCards_[self.startDealIndex_][positionId]
    if not dealingcard then return end

    if dealingcard:getParent() then
        dealingcard:removeFromParent()
    end
    dealingcard:setScale(1)
    if dealingcard:getNumberOfRunningActions() == 0 then
        dealingcard:addTo(self.cardBatchNode_):pos(P[10].x, P[10].y):rotation(180)
    end

    local targetX
    local targetY = P[positionId].y
    local targetR
    if self.startDealIndex_ == 1 then
        targetX = P[positionId].x - 6
        targetR = -6
    elseif self.startDealIndex_ == 2 then
        targetX = P[positionId].x + 6
        targetR = 6
    end

    local seatView = self.seatManager:getSeatView(self.currentDealSeatId_)
    if self.model:isSelfInSeat() and positionId == 5 then
        local seatData = seatView:getSeatData()
        local cardIndex = self.startDealIndex_
        if self.startDealIndex_ == 1 then
            targetX = targetX + 64 - 27
            targetY = targetY + 53
            targetR = 0
        elseif self.startDealIndex_ == 2 then
            targetX = targetX + 64 + 27
            targetY = targetY + 53
            targetR = 0
        end

        transition.scaleTo(dealingcard, {scaleX=BIG_CARD_SCALE_X, scaleY=BIG_CARD_SCALE_Y, time=tweenDuration,onComplete=function()
            if self.model:isSelfInSeat() then
                if dealingcard:getParent() then
                    dealingcard:removeFromParent()
                end

                if cardIndex == 2 then
                    seatView:showHandCardsElement(cardIndex,true)
                    self.schedulerPool:delayCall(function() 
                        seatView:flipHandCardsElement(cardIndex)
                        -- 提示最大牌
                        if self.roomController and self.roomController.dealCardProb then
                            self.roomController:dealCardProb()
                        end
                        self.publicCardManager:tipBigCard()
                    end, 0.15)
                elseif cardIndex == 1 then
                    seatView:showHandCardsElement(cardIndex,true)
                    self.schedulerPool:delayCall(function()
                        seatView:flipHandCardsElement(cardIndex)
                    end, 0.05)
                end
            elseif not seatView:getSeatData() then
                if dealingcard:getParent() then
                    dealingcard:removeFromParent()
                end
            end
        end})

        transition.moveTo(dealingcard, {time=tweenDuration, x=targetX, y=targetY, onComplete=function() 
                if self.showOver_==true then
                    dealingcard:removeFromParent()
                end
            end})
        dealingcard:rotateTo(tweenDuration, targetR)
    else
        transition.moveTo(dealingcard, {time=tweenDuration, x=targetX, y=targetY, onComplete=function() 
                if (not seatView:getSeatData() and dealingcard:getParent()) then
                    dealingcard:removeFromParent()
                end
            end})
        dealingcard:rotateTo(tweenDuration, targetR)
    end
    tx.SoundManager:playSound(tx.SoundManager.DEAL_CARD)
end

--寻找下一个发牌位置
function DealCardManager:findNextDealSeatId_()
    self.tempIndex_ = self.tempIndex_ + 1
    if self.tempIndex_ > #self.dealSeatIdList_ then
        self.tempIndex_ = 1
    end
    return self.dealSeatIdList_[self.tempIndex_]
end

-- 玩家弃牌
function DealCardManager:foldCard(player)
    local positionId = self.seatManager:getSeatPositionId(player.seatId)
    for i = 1, self.dealCardsNum_ do
        local foldingCard = self.dealCards_[i][positionId]
        if foldingCard:getParent() then
            local moveAction = cc.MoveTo:create(tweenDuration, cc.p(P[10].x, P[10].y))
            local rotateAction = cc.RotateTo:create(tweenDuration, 180)
            local callback = cc.CallFunc:create(function ()
                foldingCard:removeFromParent()
            end)
            foldingCard:runAction(cc.Sequence:create(cc.Spawn:create(moveAction, rotateAction), callback))
        end
    end
end

-- 显示指定位置id的发牌sprite(坐下的时候，旋转位置，刷新显示)
function DealCardManager:showDealedCard(player, cardNum)
    local positionId = self.seatManager:getSeatPositionId(player.seatId)
    for i = 1, cardNum do
        local deadCard = self.dealCards_[i][positionId]
        if deadCard:getParent() then
            deadCard:removeFromParent()
        end
        deadCard:show()
        deadCard:setScale(1)
        if i <= cardNum then
            if i==1 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x-6,P[positionId].y)
                    :rotation(-6)
            elseif i==2 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x+6,P[positionId].y)
                    :rotation(6)
            end
        end
    end
end

-- 隐藏所有的发牌sprite
function DealCardManager:hideAllDealedCard()
    for i = 1, self.dealCardsNum_ do
        for j = 1, 10 do
            if self.dealCards_[i] and self.dealCards_[i][j] then
                self.dealCards_[i][j]:removeFromParent()
            end
        end
    end
end

-- 隐藏指定位置id的发牌sprite,站起时调用
function DealCardManager:hideDealedCard(positionId)
    for i = 1, self.dealCardsNum_ do
        local deadCard = self.dealCards_[i][positionId]
        if deadCard and deadCard:getParent() then
            deadCard:removeFromParent()
        end
    end
end

-- 停止发牌,站起时调用
function DealCardManager:stopDealCardToPos(positionId)
    if self.startDeal_ then
        if self.stopPos then
            table.insert(self.stopPos,positionId)
        else
            self.stopPos = {}
            table.insert(self.stopPos,positionId)
        end
    end
end

-- 移动至座位中央
function DealCardManager:moveDealedCardToSeat(player, callback)
    self.showOver_ = true
    local positionId = self.seatManager:getSeatPositionId(player.seatId)
    local destPosition = self.seatManager:getSeatPosition(player.seatId)
    if destPosition then
        for i = 1, self.dealCardsNum_ do
            local deadCard = self.dealCards_[i][positionId]
            if not deadCard:getParent() then
                deadCard:addTo(self.cardBatchNode_):pos(P[10].x, P[10].y):rotation(180)
            end
            transition.moveTo(deadCard, {
                time = tweenDuration, 
                x = destPosition.x + i * 8 - 16, 
                y = destPosition.y,
                onComplete = function ()
                    deadCard:removeFromParent()
                    if i == 1 and callback then
                        callback()
                    end
                end
            })
        end
    end
end

function DealCardManager:showLiangPaiTest()
    for i = 1, 9 do
        self:showLiangPai(i, {0x3,0x4,0x5,0x6})
    end
end

--亮牌
function DealCardManager:showLiangPai(positionId, cardList, cardTypeName)
    if not positionId or positionId<1 or positionId>10 then return self end
    if not self.showLiangCards_ then self.showLiangCards_ = {} end
    local showCard = self.showLiangCards_[positionId]
    if not showCard then
        showCard = self:showLiangPai_(positionId)
    end
    showCard:show()

    local flag = {}
    for i, v in ipairs(cardList) do
        if v ~= 0 then
            flag[v] = true
        end
    end

    --首先我们是不知道V是否已经显示了，也不知道v显示的位置，需要遍历判断
    local showCardNum = 0
    for _, v in ipairs(cardList) do
        if v ~= 0 then
            for _, card in ipairs(showCard.cards) do
                local value = card:getCardValue()
                if v == value then --v已经展示,点击每张牌展示
                    showCardNum = showCardNum + 1
                    break
                elseif not flag[value] then --当前手牌位置，没放需要展示的牌并且v没有展示
                    showCardNum = showCardNum + 1
                    card:setCard(v)
                    self:playShowCardAnimation_(card)
                    break
                end
            end
        end
    end

    if showCardNum == showCard:getCardsNum() then
        showCard:showLiangPaiType(cardTypeName)
    end

    return self
end

function DealCardManager:showLiangPai_(positionId)
    local coord = RoomViewPosition.ShowCardPosition
    local scale = coord[positionId+20] or 0.72
    local x, y = coord[positionId].x,coord[positionId].y
    local showCard = ShowHandCard.new(scale, positionId)
        :pos(x, y)
        :addTo(self.scene.nodes.dealCardNode)

    self.showLiangCards_[positionId] = showCard

    return showCard
end

function DealCardManager:playShowCardAnimation_(handCard)
    handCard:show()
    handCard:showFront()
    handCard:scale(0)
    handCard:stopAllActions()
    transition.scaleTo(handCard, {scale=1, time=0.2,onComplete=function()
        tx.SoundManager:playSound(tx.SoundManager.SHOW_HAND_CARD)
    end})
end

-- 隐藏已经亮出的牌
function DealCardManager:hideLiangPai()
    if self.showLiangCards_ then
        for k,v in pairs(self.showLiangCards_) do
            v:clearAll()
            v:hide()
        end
    end
end

-- 重置位置与角度
function DealCardManager:reset()
    self:hideLiangPai()
    if self.dealCards_ then
        for i = 1, self.dealCardsNum_ do
            for j = 1, 10 do
                self.dealCards_[i][j]:removeFromParent()
                self.dealCards_[i][j]:stopAllActions()
            end
        end
    end
    if self.scheduleHandle_ then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end
    return self
end

-- 清理
function DealCardManager:dispose()
    if self.showLiangCards_ then
        for k,v in pairs(self.showLiangCards_) do
            v:dispose()
        end
    end
    sa.objectReleaseHelper(self.dealCards_)
    if self.scheduleHandle_ then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end
end

return DealCardManager