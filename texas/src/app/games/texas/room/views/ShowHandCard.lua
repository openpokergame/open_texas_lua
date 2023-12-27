local ShowHandCard = class("ShowHandCard", function ()
    return display.newNode()
end)

-- 扑克牌容器
local PokerCard = tx.ui.PokerCard

--其他玩家亮牌坐标
local TEXAS_OTHER_POS = {
    {x = -110, y = 15},
    {x = -70, y = 15},
}
local OMAHA_OTHER_POS = {
    {x = -140, y = 15},
    {x = -100, y = 15},
    {x = -60, y = 15},
    {x = -20, y = 15},
}

--自己亮牌坐标
local TEXAS_SELF_POS = {
    {x = -150, y = -10},
    {x = -117, y = -10},
}
local OMAHA_SELF_POS = {
    {x = -150 - 90, y = -11},
    {x = -117 - 90, y = -10},
    {x = -84 - 90, y = -10},
    {x = -51 - 90, y = -11},
}

--亮牌角度
local TEXAS_SHOW_ROTATION = {-5, 5}
local OMAHA_SHOW_ROTATION = {-10, -5, 5, 10}

local FRAME_W = 256
local LABEL_X = 70
local LABEL_LEN = 120

-- 除了自己，其他座位上的牌默认scale = 0.8
function ShowHandCard:ctor(sizeScale, positionId)
    sizeScale = sizeScale or 1
    if sizeScale then self:scale(sizeScale) end -- 设置缩放

    self.cards = {}

    local gameId = _G.curInGameId
    --默认德州
    self.otherPos_ = TEXAS_OTHER_POS
    self.pos_ = TEXAS_SELF_POS
    self.rotation_ = TEXAS_SHOW_ROTATION
    self.cardsNum_ = 2
    FRAME_W = 256
    LABEL_X = 70
    LABEL_LEN = 120
    if gameId == 3 then --奥马哈
        self.otherPos_ = OMAHA_OTHER_POS
        self.pos_ = OMAHA_SELF_POS
        self.rotation_ = OMAHA_SHOW_ROTATION
        self.cardsNum_ = 4
        FRAME_W = 295
        LABEL_X = 62
        LABEL_LEN = 100
    end

    if positionId == 10 then
        self:createSlefLiangPai(sizeScale)
    else
        self:createOtherLiangPai(sizeScale, positionId)
    end
end

function ShowHandCard:createSlefLiangPai(sizeScale)
    for i = 1, self.cardsNum_ do
        self.cards[i] = PokerCard.new(true)
            :pos(self.pos_[i].x, self.pos_[i].y)
            :rotation(self.rotation_[i])
            :addTo(self)
    end
end

function ShowHandCard:createOtherLiangPai(sizeScale, positionId)
    local frame_w, frame_h = FRAME_W, 100
    local frame = display.newScale9Sprite("#texas/room/room_seat_card_type_other_bg.png", 0, 0, cc.size(frame_w, frame_h))
        :scale(1 / sizeScale)
        :addTo(self)

    local arrow_x = frame_w - 72
    local cardX = clone(self.otherPos_)
    local label_x = frame_w - LABEL_X
    local isFilpX = false
    if positionId > 5 then
        arrow_x = 72
        label_x = LABEL_X
        isFilpX = true
        local index = #cardX
        for _, v in ipairs(self.otherPos_) do
            cardX[index].x = -v.x
            index = index - 1
        end
    end
    display.newSprite("#texas/room/room_seat_card_type_other_arrow.png")
        :flipX(isFilpX)
        :align(display.TOP_CENTER, arrow_x, 19)
        :addTo(frame)

    local sx, sy = 50, 62
    for i = 1, self.cardsNum_ do
        self.cards[i] = PokerCard.new(true)
            :scale(sizeScale)
            :pos(cardX[i].x, cardX[i].y)
            :addTo(self)
        sx = sx + 30
    end

    self.cardTypeLabel_ = ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER, dimensions=cc.size(LABEL_LEN, 0)})
        :pos(label_x, frame_h*0.5)
        :addTo(frame)
end

function ShowHandCard:showLiangPaiType(cardType)
    if self.cardTypeLabel_ then
        self.cardTypeLabel_:setString(cardType or "")
    end
end

function ShowHandCard:getCardsNum()
    return self.cardsNum_
end

function ShowHandCard:dispose()
    for _, card in ipairs(self.cards) do
        card:dispose()
    end
end

function ShowHandCard:hide()
    for k,v in ipairs(self.cards) do
        v:reset()
    end
    return cc.Node.hide(self)
end

function ShowHandCard:clearAll()
    for i = 1, self.cardsNum_ do
        self.cards[i]:stopAllActions()
        self.cards[i].cardUint_ = 0
        self.cards[i]:reset()
    end
end

return ShowHandCard