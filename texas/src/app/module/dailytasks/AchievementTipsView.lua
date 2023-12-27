local AchievementTipsView = class("AchievementTipsView", function()
    return display.newNode()
end)

function AchievementTipsView:ctor(textStr, direction)
    local label = ui.newTTFLabel({text = textStr, size = 18, color = styles.FONT_COLOR.CONTENT_TEXT})

    local size = label:getContentSize()
    local w, h = size.width + 66, size.height + 66
    self:size(w, h)
    self:align(display.CENTER)

    local bg = display.newScale9Sprite("#common/pop_small_tips_frame.png", 0, 0, cc.size(w, h))
        :pos(w/2, h/2)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    label:pos(w/2, h/2):addTo(bg)

    local x, y = w/2, 20 --默认箭头在中间
    if direction == 1 then --箭头在左边
        self:align(display.LEFT_CENTER)
        x = 75
    elseif direction == 3 then --箭头在右边
        x = w - 75
        self:align(display.RIGHT_CENTER)
    end

    display.newSprite("#common/pop_tips_arrow.png")
        :align(display.TOP_CENTER, x, y)
        :addTo(bg)
end

return AchievementTipsView