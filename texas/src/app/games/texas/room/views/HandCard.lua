local HandCard = class("HandCard", function ()
    return display.newNode()
end)

-- 除了自己，其他座位上的牌默认scale = 0.8
function HandCard:ctor(sizeScale)
    -- 设置缩放
    if sizeScale then self:setScale(sizeScale) end

    -- 扑克牌容器
    local PokerCard = tx.ui.PokerCard
    self.cards = {}
    self.cards[1] = PokerCard.new(true):pos(-20, 0):rotation(0):addTo(self)
    self.cards[2] = PokerCard.new(true):pos(20, 0):rotation(0):addTo(self)
    self.notRotate = true
    -- self.cards[1]:pos(-18, 0):rotation(-10)
    -- self.cards[2]:pos(18, -7):rotation(10)
    self.cardNum_ = 2
end

-- 设置牌面
function HandCard:setNotRotate(notRotate)
    self.notRotate = notRotate
    if notRotate then
        if self.isSelf_ then
            self.cards[1]:pos(-32, 0):rotation(0)
            self.cards[2]:pos(32, 0):rotation(0)
        else
            self.cards[1]:pos(-20, 0):rotation(0)
            self.cards[2]:pos(20, 0):rotation(0)
        end
    else
        self.cards[1]:pos(-18, 0):rotation(-10)
        self.cards[2]:pos(18, -7):rotation(10)
    end
    return self
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

function HandCard:setCardNum(cardNum)
    if cardNum>2 then
        cardNum = 2
    end
    self.cardNum_ = cardNum
    if self.notRotate then
        if self.isSelf_ then
            self.cards[1]:moveTo(0.2, -32, 0):rotation(0)
            self.cards[2]:moveTo(0.2, 32, 0):rotation(0)
        else
            self.cards[1]:moveTo(0.2, -20, 0):rotation(0)
            self.cards[2]:moveTo(0.2, 20, 0):rotation(0)
        end
    else
        self.cards[1]:moveTo(0.2, -18, 0):rotateTo(0.2, -10)
        self.cards[2]:moveTo(0.2, 18, -7):rotateTo(0.2, 10)
    end
end

function HandCard:hideAllCards()
    for i = 1, 2 do
        self.cards[i]:hide()
    end
end

function HandCard:showAllCards()
    for i = 1, self.cardNum_ do
        self.cards[i]:show()
    end
end


-- 指定第几张牌翻牌
function HandCard:flipWithIndex(...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        for i = 1, numArgs do
            local value = select(i, ...)
            if value >= 1 and value <= self.cardNum_ then
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
            if value >= 1 and value <= self.cardNum_ then
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
    for i = 1, self.cardNum_ do
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

-- 震动牌：numCard = 2，前两张；numCard = 3，所有牌
function HandCard:shakeWithNum(numCard)
    for i = 1, numCard do
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

-- 暗化牌：numCard = 2，前两张；numCard = 3，所有牌
function HandCard:addDarkWithNum(numCard)
    for i = 1, numCard do
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
    for i = 1, 2 do
        self.cards[i]:stopAllActions()
        self.cards[i].cardUint_ = 0
        self.cards[i]:reset()
    end
end

return HandCard