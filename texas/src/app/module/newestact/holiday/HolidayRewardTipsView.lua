-- 奖励提示
local HolidayRewardTipsView = class("HolidayRewardTipsView", function()
    return display.newNode()
end)

function HolidayRewardTipsView:ctor(rewardDesc)
    local w, h = 290, 150
    self:size(w, h)
    self:align(display.CENTER)

    local frame_w, frame_h = w, h
    local bg = display.newScale9Sprite("#holiday_reward_tips.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, w*0.5, 0)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    local label = ui.newTTFLabel({text = rewardDesc, size = 22, color = cc.c3b(0xad, 0x5c, 0x0d), dimensions = cc.size(w - 60, 0)})
        :pos(w/2, frame_h/2)
        :addTo(self)
    local size = label:getContentSize()
    if size.height > h - 50 then
        frame_h = size.height + 80
        label:setPositionY(frame_h*0.5)
        bg:setPreferredSize(cc.size(frame_w, frame_h))
    end

    display.newSprite("#holiday_reward_tips_arrow.png")
        :align(display.TOP_CENTER, w*0.5, 30)
        :addTo(self)
end

return HolidayRewardTipsView