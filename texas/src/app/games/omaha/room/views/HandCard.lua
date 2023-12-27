local HandCard = class("HandCard", function ()
    return display.newNode()
end)

-- 扑克牌容器
local PokerCard = tx.ui.PokerCard

--自己牌坐标
local SELF_POS = {
    {x = -30-35, y = -2},
    {x = 10-35, y = -2},
    {x = 50-35, y = -2},
    {x = 90-35, y = -2},
}

--其他玩家牌坐标
local OTHER_POS = {
    {x = -60, y = 0},
    {x = -20, y = 0},
    {x = 20, y = 0},
    {x = 60, y = 0},
}

--亮牌坐标
local SHOW_POS = {
    {x = -10.05-47, y = -0.7},
    {x = 23.15-47, y = 3.2},
    {x = 58-47, y = 0},
    {x = 91.8-47, y = -9.4},
}

--亮牌角度
local SHOW_ROTATION = {-20, -10, 0, 10}

local CARDS_NUM = 4

-- 除了自己，其他座位上的牌默认scale = 0.8
function HandCard:ctor(sizeScale)
    -- 设置缩放
    if sizeScale then self:setScale(sizeScale) end

    self.cards = {}
    for i = 1, CARDS_NUM do
        self.cards[i] = PokerCard.new(true):pos(SELF_POS[i].x, SELF_POS[i].y):rotation(0):addTo(self)
    end
    self.notRotate = true
    self.cardNum_ = 2
end

-- 设置牌面
function HandCard:setNotRotate(notRotate)
    self.notRotate = notRotate
    if notRotate then
        if self.isSelf_ then
            self:setSelfCardsPos_()
        else
            self:setOtherCardsPos_()
        end
    else
        self:setShowCardPos_()
    end
    return self
end

--设置自己牌位置
function HandCard:setSelfCardsPos_()
    for i = 1, CARDS_NUM do
        self.cards[i]:pos(SELF_POS[i].x, SELF_POS[i].y):rotation(0)
    end
end

--设置其他玩家牌位置
function HandCard:setOtherCardsPos_()
    for i = 1, CARDS_NUM do
        self.cards[i]:pos(OTHER_POS[i].x, OTHER_POS[i].y):rotation(0)
    end
end

-- 设置牌面
function HandCard:setCards(cardsValue)
    for i, cardUint in ipairs(cardsValue) do
        if self.cards[i] then
            self.cards[i]:setCard(cardUint)
        end
    end
    return self
end

function HandCard:setIsSelf(value)
    self.isSelf_ = value
    self:setNotRotate(self.notRotate)
end

function HandCard:setCardNum()
    if self.notRotate then
        if self.isSelf_ then
            self:setSelfCardsPos_()
        else
            self:setOtherCardsPos_()
        end
    else
        self:setShowCardPos_()
    end
end

function HandCard:setShowCardPos_()
    for i = 1, CARDS_NUM do
        self.cards[i]:pos(SHOW_POS[i].x, SHOW_POS[i].y):rotation(SHOW_ROTATION[i])
    end
end

function HandCard:hideAllCards()
    for i = 1, CARDS_NUM do
        self.cards[i]:hide()
    end
end

function HandCard:showAllCards()
    for i = 1, CARDS_NUM do
        self.cards[i]:show()
    end
end

-- 指定第几张牌翻牌
function HandCard:flipWithIndex(...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        for i = 1, numArgs do
            local value = select(i, ...)
            if value >= 1 and value <= CARDS_NUM then
                self.cards[value]:flip()
            end
        end
    end
    return self
end

function HandCard:showWithIndex(...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        for i = 1, numArgs do
            local value = select(i, ...)
            if value >= 1 and value <= CARDS_NUM then
                self.cards[value]:show()
            end
        end
    end
    return self
end

function HandCard:showBackWithIndex(idx)
    local card = self.cards[idx]
    if card then
        card:showBack()
    end
end

function HandCard:isCardShow(idx)
    return self.cards[idx]:isVisible()
end

function HandCard:isCardBack(idx)
    return self.cards[idx]:isBack()
end

function HandCard:isCardFront(idx)
    return self.cards[idx]:isFront()
end

-- 翻开所有牌（比牌时）
function HandCard:flipAll()
    for i = 1, CARDS_NUM do
        self.cards[i]:flip()
    end

    return self
end

function HandCard:showFrontAll()
    for _, card in ipairs(self.cards) do
        card:showFront()
    end

    return self
end

function HandCard:showBackAll()
    for _, card in ipairs(self.cards) do
        card:showBack()
    end

    return self
end

-- 震动所有牌
function HandCard:shakeWithNum()
    for i = 1, CARDS_NUM do
        if self.cards[i] then
            self.cards[i]:shake()
        end
    end

    return self
end

function HandCard:stopShakeAll()
    for _, card in ipairs(self.cards) do
        card:stopShake()
    end

    return self
end

-- 暗化所有牌
function HandCard:addDarkWithNum()
    for i = 1, CARDS_NUM do
        if self.cards[i] then
            self.cards[i]:addDark()
        end
    end

    return self
end

function HandCard:removeDarkAll()
    for _, card in ipairs(self.cards) do
        card:removeDark()
    end

    return self
end

function HandCard:dispose()
    for _, card in ipairs(self.cards) do
        card:dispose()
    end
end

function HandCard:hide()
    for k,v in ipairs(self.cards) do
        v:reset()
    end
    return cc.Node.hide(self)
end

function HandCard:showLight(bigList)
    for k,v in ipairs(self.cards) do
        local isBig = false
        for kk,vv in ipairs(bigList) do
            if v.cardUint_==vv then
                isBig = true
                break;
            end
        end
        v:setLight(isBig)
    end
end

function HandCard:showBigs(bigList)
    for k,v in ipairs(self.cards) do
        local isBig = false
        for kk,vv in ipairs(bigList) do
            if v.cardUint_==vv then
                isBig = true
                break;
            end
        end
        v:setLight(isBig)
        if isBig then
            v:removeDark()
        else
            v:addDark()
        end
    end
end

function HandCard:clearAll()
    for i = 1, CARDS_NUM do
        self.cards[i]:stopAllActions()
        self.cards[i].cardUint_ = 0
        self.cards[i]:reset()
    end
end

return HandCard