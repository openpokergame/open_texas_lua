local CardTypePopup = class("CardTypePopup", function() return display.newNode() end)
local WIDTH, HEIGHT = 400, 800
local SCALE = display.height/HEIGHT --适配缩放
local VIEW_SHOW_X = WIDTH*SCALE*0.5
local VIEW_HIDE_X = -WIDTH*SCALE*0.5
local VIEW_Y = HEIGHT*SCALE*0.5
local orderList = {
    "RoyalFlush",
    "StraightFlush",
    "FourKind",
    "FullHouse",
    "Flush",
    "Straight",
    "Threekind",
    "TwoPairs",
    "OnePairs",
    "High",
}

function CardTypePopup:ctor(probValue)
    self:setContentSize(cc.size(WIDTH, HEIGHT))
    self:setNodeEventEnabled(true)

    self.isMoving_ = false

    self.content_ = display.newSprite("img/texas_card_type.jpg")
        :scale(SCALE)
        :addTo(self)

    self.probLabelList_ = {}  -- 概率
    local cardTypeList = sa.LangUtil.getText("COMMON", "TEXAS_CARD_TYPE")
    local itemHeight = 72
    for k,v in ipairs(cardTypeList) do
        local label1 = ui.newTTFLabel({
                size=22,
                text=v,
                color=cc.c3b(0x9b, 0xa9, 0xff),
            })
        :pos(320,HEIGHT - itemHeight*k - 27 - 13)
        :addTo(self.content_)

        local label = ui.newTTFLabel({size=22, text="0%"})
            :pos(320,HEIGHT - itemHeight*k - 27 + 13)
            :addTo(self.content_)
        table.insert(self.probLabelList_,label)
        if k==1 or k==9 or k==10 then
            label:hide()
            label1:setPositionY(HEIGHT - itemHeight*k - 27)
        end
        sa.fitSprteWidth(label1, 150)
    end

    ui.newTTFLabel({size=32, text=sa.LangUtil.getText("COMMON", "CARD_TIPS")})
        :pos(WIDTH * 0.5-14, HEIGHT-36)
        :addTo(self.content_)

    self.content_:setTouchEnabled(true)
    self.content_:setTouchSwallowEnabled(true)

    self:pos(VIEW_HIDE_X, VIEW_Y)
    self:onCardProbChange_({data = probValue})
    self.cardProbChangeId_ = sa.EventCenter:addEventListener("CHANGECARDPROB", handler(self, self.onCardProbChange_))
end

function CardTypePopup:onCardProbChange_(evt)
    local probValue = evt and evt.data
    probValue = probValue or {}
    -- probValue.High = 1
    -- probValue.OnePairs = 0
    -- probValue.TwoPairs = kindValue[2]
    -- probValue.Threekind = kindValue[3]
    -- probValue.Straight = kindValue[4]
    -- probValue.Flush = kindValue[5]
    -- probValue.FullHouse = kindValue[6]
    -- probValue.FourKind = kindValue[7]
    -- probValue.StraightFlush = kindValue[8]
    -- probValue.RoyalFlush = 0
    local maxIndex = 1
    local maxValue = 0
    local curValue = nil

    for i = 1, 8 do
        curValue = tonumber(probValue[orderList[i]] or 0)
        if curValue>maxValue then
            maxValue=curValue
            maxIndex=i
        end
        self.probLabelList_[i]:setString((curValue*100).."%")
        self.probLabelList_[i]:setColor(cc.c3b(255, 255, 255))
    end

    if maxValue~=0 then
        self.probLabelList_[maxIndex]:setColor(cc.c3b(0xfc, 0xf0, 0x8a))
    end
end

function CardTypePopup:onCleanup()
    sa.EventCenter:removeEventListener(self.cardProbChangeId_)
end

function CardTypePopup:setMovePositionX(offsetX)
    local x = self:getPositionX() + offsetX
    if x >= VIEW_SHOW_X then
        x = VIEW_SHOW_X
    elseif x <= VIEW_HIDE_X  then
        x = VIEW_HIDE_X
    end
    self:setPositionX(x)
end

--显示动画
function CardTypePopup:playShowAnimation()
    self:playMoveAnimation_(VIEW_SHOW_X)
end

--隐藏动画
function CardTypePopup:playHideAnimation()
    self:playMoveAnimation_(VIEW_HIDE_X)
end

--移动动画
function CardTypePopup:playMoveAnimation_(px)
    self.isMoving_ = true
    
    self:stopAllActions()
    transition.moveTo(self, {
        time = 0.2,
        easing = "OUT",
        x = px,
        onComplete = function()
            self.isMoving_ = false
        end,
    })
end

function CardTypePopup:isMoving()
    return self.isMoving_
end

return CardTypePopup