--赠送记录弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidaySendSuccPopup = class("HolidaySendSuccPopup", HolidayBasePopup)

local WIDTH, HEIGHT = 750, 550
local ICON_IMG = {
	"#holiday_shake_icon_4.png",
	"#holiday_shake_icon_2.png",
}
local ICON_POS_Y = {260, 180}
local BTN_COLOR = cc.c3b(0x5a, 0x0e, 0xaf)

function HolidaySendSuccPopup:ctor(data)
	HolidaySendSuccPopup.super.ctor(self, {WIDTH, HEIGHT})

	local cx, cy = WIDTH*0.5, HEIGHT*0.5
    display.newSprite("#holiday_shake_icon_1.png")
        :align(display.TOP_CENTER, cx, HEIGHT - 5)
        :addTo(self)

    local icon_x, icon_y = cx, 360
    display.newSprite("#holiday_shake_icon_3.png")
		:pos(icon_x, icon_y)
        :addTo(self)

    local dir = 75
    ui.newTTFLabel({text = tx.userData.nick, size = 30})
        :align(display.RIGHT_CENTER, icon_x - dir, icon_y)
        :addTo(self)

    ui.newTTFLabel({text = data.toName, size = 30})
        :align(display.LEFT_CENTER, icon_x + dir, icon_y)
        :addTo(self)

  	for i, v in ipairs(ICON_IMG) do
  		self:addInfo_(i, data.shakeTimes)
  	end

  	cc.ui.UIPushButton.new({normal = "#holiday_shake_btn_normal.png", pressed = "#holiday_shake_btn_pressed.png"}, {scale9 = true})
        :setButtonSize(180, 70)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_BTN"), size = 30, color = BTN_COLOR}))
        :pos(cx, 70)
        :onButtonClicked(buttontHandler(self, self.onShakeClicked_))
        :addTo(self)
end

function HolidaySendSuccPopup:addInfo_(index, num)
	local x, y = 350, ICON_POS_Y[index]
	display.newSprite(ICON_IMG[index])
		:pos(x, y)
        :addTo(self)

    if index == 2 then
    	num = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_TIMES", num)
    end
    ui.newTTFLabel({text = num, size = 30})
        :align(display.LEFT_CENTER, x + 40, y)
        :addTo(self)
end

function HolidaySendSuccPopup:onShakeClicked_()
	tx.PopupManager:removeAllPopup()
    
    sa.EventCenter:dispatchEvent("HOLIDAY_SHAKE_GIRL_CHAT")
end

return HolidaySendSuccPopup
