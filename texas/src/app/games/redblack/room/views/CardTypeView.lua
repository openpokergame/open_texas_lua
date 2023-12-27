-- 牌型视图
local CardTypeView = class("CardTypeView", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 150, 58
local CARD_TYPE

function CardTypeView:ctor(isWin)
    CARD_TYPE = sa.LangUtil.getText("COMMON", "CARD_TYPE")

    local img = "#redblack/room/redblack_lose_card_type_bg.png"
    local color = cc.c3b(0xff, 0xff, 0xff)
    if isWin then
        img = "#redblack/room/redblack_win_card_type_bg.png"
        color = cc.c3b(0xff, 0xdb, 0x6d)
    end

    display.newScale9Sprite(img, 0, 0, cc.size(WIDTH, HEIGHT))
        :addTo(self)

    self.cardType_ = ui.newTTFLabel({text = "", color = color, size = 30})
        :addTo(self)
end

function CardTypeView:setCardType(cardType)
    self.cardType_:setString(CARD_TYPE[cardType])
    sa.fitSprteWidth(self.cardType_, WIDTH - 5)
    return self
end

return CardTypeView