local BetChipItem = class("BetChipItem", sa.ui.ListItem)

local ITEM_W, ITEM_H = 120, 120
local C_X, C_Y = ITEM_W*0.5, ITEM_H*0.5

function BetChipItem:ctor()
    self:setNodeEventEnabled(true)
    BetChipItem.super.ctor(self, ITEM_W, ITEM_H)

    self.icon_ = display.newSprite()
        :pos(C_X, C_Y)
        :addTo(self)

    local btn = cc.ui.UICheckBoxButton.new({on = "#redblack/room/redblack_bet_chip_selected.png", off = "#common/transparent.png"}, {scale9 = true})
        :setButtonSize(ITEM_W, ITEM_H)
        :pos(C_X, C_Y)
        :addTo(self)
    btn:setTouchSwallowEnabled(false)

    self.btn_ = btn
end

function BetChipItem:onDataSet(dataChanged, data)
    self.data_ = data
    self.icon_:setSpriteFrame(data)
end

function BetChipItem:getCheckBoxButton()
    return self.btn_
end

return BetChipItem