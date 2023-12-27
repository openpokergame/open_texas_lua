local DealCardManager = class("DealCardManager")

local PokerCard = tx.ui.PokerCard
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomViewPosition = import(".views.RoomViewPosition")
local log = sa.Logger.new("DealCardManager")
local ClockView = import(".views.ClockView")
local CardTypeView = import(".views.CardTypeView")

local DEAL_CARDS_NUM = 9 --发牌数量
local P = RoomViewPosition.DealCardPosition
local Pub = RoomViewPosition.PubCardPosition
local SeatPosition = RoomViewPosition.SeatPosition
local BetTypePosition = RoomViewPosition.BetTypePosition
local CARD_START_POS = P[3]
local CARD_POS = {
    cc.p(P[1].x - 24, P[1].y),
    cc.p(P[1].x + 24, P[1].y),
    cc.p(P[2].x - 24, P[2].y),
    cc.p(P[2].x + 24, P[2].y),
    Pub[1],
    Pub[2],
    Pub[3],
    Pub[4],
    Pub[5],
}

local ELEPHANT_IMG = {
    "#redblack/room/redblack_silver_elephant.png",
    "#redblack/room/redblack_gold_elephant.png",
}

function DealCardManager:ctor()
end

function DealCardManager:createNodes()
    local node = self.scene.nodes.dealCardNode
    self.cardBatchNode_ = node
    self.numNeedCards_ = DEAL_CARDS_NUM

    self:addElephantIcon_()

    self.winLight_ = display.newSprite("#redblack/room/redblack_win_light.png")
        :pos(P[1].x, P[1].y)
        :addTo(node)
        :hide()

    self.cardsList_ = {}
    for i = 1, DEAL_CARDS_NUM do
        self.cardsList_[i] = PokerCard.new()
            :pos(CARD_START_POS.x, CARD_START_POS.y)
            :scale(0.72)
            :addTo(node)
            :showBack()
            :hide()
    end

    self.winCard_ = CardTypeView.new(true)
        :pos(P[1].x, P[1].y - 40)
        :addTo(node)
        :hide()

    self.drawCard_ = CardTypeView.new(true) --平局
        :pos(P[1].x, P[1].y - 40)
        :addTo(node)
        :hide()

    self.loseCard_ = CardTypeView.new(false)
        :pos(P[2].x, P[2].y - 40)
        :addTo(node)
        :hide()

    self.startTips_ = ui.newTTFLabel({text = "", size = 26})
        :pos(Pub[3].x, Pub[3].y)
        :addTo(node)
        :hide()

    self.clock_ = ClockView.new()
        :align(display.TOP_CENTER, display.cx, display.height - 42)
        :addTo(node)
        :hide()

    self.elephantAnimation_ = sp.SkeletonAnimation:create("spine/JYdaxiang.json", "spine/JYdaxiang.atlas")
        :pos(BetTypePosition[3].x - 328, BetTypePosition[3].y - 115)
        :addTo(node)
        :hide()

    self.elephantAnimation_:registerSpineEventHandler(function(event)
        if event.animation == "1" then
            self:playElephantAnimation(true)
            self:dealCards()
        elseif event.animation == "2" and event.loopCount == 2 then
            self:playElephantAnimation(false)
        elseif event.animation == "6" then
            self:showElephantIcon_()
        end
    end, sp.EventType.ANIMATION_COMPLETE)
end

function DealCardManager:addElephantIcon_()
    self.elephantList_ = {}
    self.elephantMarkList_ = {}
    local isFlip = true
    local offsetX = -10
    local y = P[1].y
    for i = 1, 2 do
        if i == 2 then
            offsetX = 10
            isFlip = false
        end

        self.elephantMarkList_[i] = display.newSprite("#redblack/room/redblack_elephant_mark.png")
            :flipX(isFlip)
            :pos(P[i].x, y)
            :addTo(self.scene.nodes.dealCardNode)
            -- :hide()

        -- self.elephantList_[i] = display.newSprite(ELEPHANT_IMG[i])
        --     :pos(P[i].x + offsetX, y)
        --     :addTo(self.scene.nodes.dealCardNode)
        --     :hide()
    end
end

function DealCardManager:showElephantIcon_()
    -- for i = 1, 2 do
    --     self.elephantList_[i]:show()
    --     self.elephantMarkList_[i]:hide()
    -- end
end

function DealCardManager:hideElephantIcon()
    -- for i = 1, 2 do
    --     self.elephantList_[i]:hide()
    --     self.elephantMarkList_[i]:show()
    -- end
end

-- 从庄家位置开始发手牌
function DealCardManager:dealCards()
    if not self.cardsList_ then
        return self
    end

    self.numNeedCards_ = DEAL_CARDS_NUM   -- 需要发牌的数量

    -- 发牌定时器
    self.startDealIndex_ = 0 -- 开始发第几张牌
    if self.scheduleHandle_ then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end
    self.scheduleHandle_  = scheduler.scheduleGlobal(handler(self, self.scheduleHandler), 0.1)
end

function DealCardManager:scheduleHandler()
    self.startDealIndex_ = self.startDealIndex_ + 1
    self:dealCard_()

    -- 需发牌总数减1，发牌总数为0则已发完，结束发牌
    self.numNeedCards_ = self.numNeedCards_ - 1
    if self.numNeedCards_ == 0 then
        --显示第一张公共牌
        self.flipCardScheduleHandle_ = scheduler.performWithDelayGlobal(function()
            self.flipCardScheduleHandle_ = nil
            self.cardsList_[5]:setCard(self.pubCard_)
            self.cardsList_[5]:redblackFlip()
        end, 0.2)
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end
end

--真正发牌逻辑
function DealCardManager:dealCard_()
    local index = self.startDealIndex_
    local card = self.cardsList_[index]
    if not card then return end

    if card:getNumberOfRunningActions() == 0 then
        card:show():pos(CARD_START_POS.x, CARD_START_POS.y):rotation(180):showBack()
    end

    local t = 0.25
    transition.moveTo(card, {time=t, x=CARD_POS[index].x, y=CARD_POS[index].y})

    card:rotateTo(t, 0)

    tx.SoundManager:playSound(tx.SoundManager.DEAL_CARD)
end

-- 直接显示要发的牌(重连的时候才用到)
function DealCardManager:showDealedCard(pubCard)
    for i, card in ipairs(self.cardsList_) do
        card:show():pos(CARD_POS[i].x, CARD_POS[i].y):rotation(0):showBack()
    end

    self.cardsList_[5]:setCard(pubCard):showFront()
end

--显示结算状态
function DealCardManager:showGameOverStatus_(winIndex, cardType, winCards)
    if winIndex == 3 then
        self:showDrawStatus_(cardType)
    else
        self:showWinStatus_(winIndex, cardType, winCards)
    end
    if self.elephantAnimation_:findAnimation(2 + winIndex) then
        self.elephantAnimation_:initialize()
        self.elephantAnimation_:setToSetupPose()
        self.elephantAnimation_:show():setAnimation(0, 2 + winIndex, true)
        self.elephantAnimation_:update(0)
    end
end

--平局
function DealCardManager:showDrawStatus_(cardType)
    self.winLight_:hide()
    self.loseCard_:hide()

    self.ctx.schedulerPool:delayCall(function ()
        self:showWinCardType_(winCards)

        self.winCard_:show()
            :setCardType(cardType[1])
            :setPositionX(P[1].x)

        self.drawCard_:show()
            :setCardType(cardType[2])
            :setPositionX(P[2].x)
    end, 0.2)
end

function DealCardManager:showWinLight_(winIndex)
    self.ctx.schedulerPool:delayCall(function ()
        self:showWinStatus_(winIndex, cardType, winCards)
    end, 0.2)
end

--胜利
function DealCardManager:showWinStatus_(winIndex, cardType, winCards)
    self.winLight_:show():setPositionX(P[winIndex].x)

    self.ctx.schedulerPool:delayCall(function ()
        self:showWinCardType_(winCards)

        self.winCard_:show()
            :setCardType(cardType[winIndex])
            :setPositionX(P[winIndex].x)

        local loseIndex = 1
        if winIndex == 1 then
            loseIndex = 2
        end

        self.loseCard_:show()
            :setCardType(cardType[loseIndex])
            :setPositionX(P[loseIndex].x)
    end, 0.2)
end

--隐藏胜利状态
function DealCardManager:hideWinStatus()
    self.winLight_:hide()
    self.winCard_:hide()
    self.loseCard_:hide()
    self.drawCard_:hide()
end

--胜利牌型高亮
function DealCardManager:showWinCardType_(winCards)
    if winCards then
        local flag = {}
        for _, v in ipairs(winCards) do
            flag[v] = true
        end

        for i, v in ipairs(self.cardsList_) do
            if flag[v:getCardValue()] then
                v:setLight(true)
            else
                v:addDark()
            end
        end
    end
end

--游戏开始倒计时
function DealCardManager:playGameStartTime(time, isShow)
    self.time_ = time

    self:stopGameStartTime()

    if isShow then
        self:showGameStartTime()
    else
        self:hideGameStartTime()
    end

    self.startTips_:setString(sa.LangUtil.getText("REDBLACK", "START_GAME_TIPS", self.time_))
    self.startTips_:schedule(function()
        self.time_ = self.time_ - 1
        self.startTips_:setString(sa.LangUtil.getText("REDBLACK", "START_GAME_TIPS", self.time_))
        if self.time_ <= 0 then
            self.startTips_:stopAllActions()
        end
    end, 1)
end

--显示游戏倒计时
function DealCardManager:showGameStartTime()
    self.startTips_:show()
end

--隐藏游戏开始倒计时
function DealCardManager:hideGameStartTime()
    self.startTips_:hide()
end

--停止游戏开始倒计时
function DealCardManager:stopGameStartTime()
    self.startTips_:stopAllActions()
    self.startTips_:hide()
end

--播放VS动画
function DealCardManager:playStartAnimation(pubCard)
    self:stopGameStartTime()

    self.pubCard_ = pubCard

    self.ctx.animManager:playStartAnimation()

    if self.elephantAnimation_:findAnimation(7) then
        self.elephantAnimation_:initialize()
        self.elephantAnimation_:setToSetupPose()
        self.elephantAnimation_:show():setAnimation(0, 7, false)
        self.elephantAnimation_:update(0)
    end
end

function DealCardManager:playBetStatusAnimation(time)
    self.clock_:startCountDown(time, function()
        self.ctx.betTypeManager:setBetEnabled(false)
    end)

    self.ctx.animManager:playBetAnimation(function()
        self.clock_:playShowAnimation()
    end)
end

--显示下注状态中，大象动画
function DealCardManager:playElephantAnimation(isLoop)
    if self.elephantAnimation_ and self.elephantAnimation_:findAnimation(2) then
        self.elephantAnimation_:initialize()
        self.elephantAnimation_:setToSetupPose()
        self.elephantAnimation_:show():setAnimation(0, 2, isLoop)
        self.elephantAnimation_:update(0)
    end
end

--直接显示下注倒计时，重连的时候调用
function DealCardManager:showBetStatus(time)
    self.clock_:showCountDown(time)

    self:playElephantAnimation(true)
end

--结算完成，大象飞到旗子上
function DealCardManager:playElephantOverAnimation()
    if self.elephantAnimation_ and self.elephantAnimation_:findAnimation(6) then
        self.elephantAnimation_:initialize()
        self.elephantAnimation_:setToSetupPose()
        self.elephantAnimation_:show():setAnimation(0, 6, false)
        self.elephantAnimation_:update(0)
    end
end

function DealCardManager:showGameOverStatus(data)
    self.clock_:hideCountDown()

    self:playGameStartTime(data.nextTime)

    self.ctx.animManager:playGameOverAnimation(function()
        local cards = data.cards
        local t = 0
        for i, v in ipairs(self.cardsList_) do
            if i ~= 5 then
                if i == 3 or i == 6 then
                    t = t + 0.4
                end

                v:performWithDelay(function()
                    if self.ctx.model:getGameStatus() == consts.SVR_GAME_STATUS.READY_TO_START then
                        v:setCard(cards[i])
                        v:redblackFlip()
                    end
                end, t)

                if i >= 6 then
                    t = t + 0.1
                end
            end
        end

        self.ctx.schedulerPool:delayCall(function ()
            self:showGameOverStatus_(data.winner, data.cardType, data.winCards)
        end, t + 0.4)
    end)
end

function DealCardManager:playElephantEnterAnimation()
    if self.elephantAnimation_ and self.elephantAnimation_:findAnimation(1) then
        self.elephantAnimation_:initialize()
        self.elephantAnimation_:setToSetupPose()
        self.elephantAnimation_:show():setAnimation(0, 1, false)
        self.elephantAnimation_:update(0)
    end
end

-- 重置
function DealCardManager:reset()
    for _,v in ipairs(self.cardsList_) do
        v:hide()
    end

    if self.scheduleHandle_ then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end

    self:hideWinStatus()

    self.clock_:hideCountDown()

    return self
end

-- 清理
function DealCardManager:dispose()
    if self.scheduleHandle_ then
        scheduler.unscheduleGlobal(self.scheduleHandle_)
        self.scheduleHandle_ = nil
    end

    if self.flipCardScheduleHandle_ then
        scheduler.unscheduleGlobal(self.flipCardScheduleHandle_)
        self.flipCardScheduleHandle_ = nil
    end
end

return DealCardManager