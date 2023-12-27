local HolidayBasePopup = class("HolidayBasePopup", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 752, 550

function HolidayBasePopup:ctor(args)
    WIDTH, HEIGHT = args[1], args[2]
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)
    

    local cx, cy = WIDTH*0.5, HEIGHT*0.5
    local node = display.newNode():addTo(self)
    display.newSprite("holiday_reward_bg.jpg")
        :align(display.RIGHT_CENTER, cx, cy)
        :addTo(node)

    display.newSprite("holiday_reward_bg.jpg")
        :flipX(true)
        :align(display.LEFT_CENTER, cx, cy)
        :addTo(node)

    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)

    self.title_ = ui.newTTFLabel({text = "", size = 40})
        :pos(cx, HEIGHT - 40)
        :addTo(self)
end

function HolidayBasePopup:setTextTitle(title)
    self.title_:setString(title)
end

function HolidayBasePopup:showPanel()
    tx.PopupManager:addPopup(self)

    return self
end

function HolidayBasePopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function HolidayBasePopup:hidePanel_()
end

return HolidayBasePopup
