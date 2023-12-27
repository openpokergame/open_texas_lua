-- 奖励提示

local InviteRewardTipsView = class("InviteRewardTipsView", function()
    return display.newNode()
end)

function InviteRewardTipsView:ctor(data)
    local w, h = 260, 154
    self:size(w, h)
    self:align(display.CENTER)

    local bg = display.newScale9Sprite("#common/pop_small_tips_frame.png", 0, 0, cc.size(w, h))
        :pos(w/2, h/2)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    local x, y = 60, h*0.5
    local offsetX, offsetY = 30, 30
    display.newSprite("#common/common_chip_icon.png")
        :pos(x, y + offsetY)
        :addTo(self)

    ui.newTTFLabel({text = "+" .. sa.formatNumberWithSplit(data.money), size = 28})
        :align(display.LEFT_CENTER, x + offsetX, y + offsetY)
        :addTo(self)

    display.newSprite("#common/common_diamond_icon.png")
        :pos(x, y - offsetY)
        :addTo(self)

    ui.newTTFLabel({text = "+" .. sa.formatNumberWithSplit(data.diamond), size = 28})
        :align(display.LEFT_CENTER, x + offsetX, y - offsetY)
        :addTo(self)

    display.newSprite("#common/pop_tips_arrow.png")
        :align(display.TOP_CENTER, w - 60, 20)
        :addTo(self)
end

return InviteRewardTipsView