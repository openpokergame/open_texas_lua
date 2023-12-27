local ChooseCountryItem = class("ChooseCountryItem", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 320, 60
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5

function ChooseCountryItem:ctor(data)
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)

    self.data_ = data

    local btn = cc.ui.UICheckBoxButton.new({on = "#common/country_checkbox_on.png", off = "#common/country_checkbox_off.png"})
        :pos(C_X, C_Y)
        :addTo(self)
    btn:setTouchSwallowEnabled(false)

    self.btn_ = btn

    display.newSprite("#country_" .. data.id .. ".png")
        :pos(32, C_Y)
        :addTo(self)

    ui.newTTFLabel({text = data.name, size = 24, color = cc.c3b(0x9b, 0xa9, 0xff)})
        :align(display.LEFT_CENTER, 73, C_Y)
        :addTo(self)
end

function ChooseCountryItem:getCheckBoxButton()
    return self.btn_
end

function ChooseCountryItem:getData()
    return self.data_
end

return ChooseCountryItem