--节日祝福弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidayRewardPopup = class("HolidayRewardPopup", HolidayBasePopup)

local WIDTH, HEIGHT = 752, 550
local TEXT_CORLOR = cc.c3b(0xff, 0xff, 0xff)
local ICON_IMG = {
    "#common/common_chip_icon.png",
    "#common/common_diamond_icon.png",
    "#common/prop_hddj.png",
}

local ICON_SCALE = {1.5, 1.5, 0.7}

function HolidayRewardPopup:ctor(data)
	HolidayRewardPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitle(sa.LangUtil.getText("COMMON","CONGRATULATIONS"))

    self:initViews_(data)
end

function HolidayRewardPopup:initViews_(data)
    local cx = WIDTH*0.5
    local sy = 0
    local rewardNode = display.newNode()
        :addTo(self)
    for _, v in ipairs(data) do
        if v.rewardNum > 0 then
            self:createRewardNode_(sy, v, rewardNode)
            sy = sy - 85
        end
    end
    local size = rewardNode:getCascadeBoundingBox()
    rewardNode:size(size.width, size.height)
    rewardNode:align(display.LEFT_CENTER, cx - 90, HEIGHT*0.5 + size.height)

    cc.ui.UIPushButton.new({normal = "#holiday_btn_normal.png", pressed = "#holiday_btn_pressed.png"}, {scale9 = true})
        :setButtonSize(230, 70)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 30, color = cc.c3b(0xb8, 0x27, 0x72)}))
        :pos(cx, 80)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
        :addTo(self)
end

function HolidayRewardPopup:createRewardNode_(y, data, parent)
    local rewardType = tonumber(data.rewardType)
    display.newSprite(ICON_IMG[rewardType])
        :scale(ICON_SCALE[rewardType])
        :pos(0, y)
        :addTo(parent)

    ui.newTTFLabel({text = sa.formatNumberWithSplit(data.rewardNum), size = 40, color = cc.c3b(0xca, 0x03, 0x03)})
        :align(display.LEFT_CENTER, 80, y)
        :addTo(parent)
end

function HolidayRewardPopup:onConfirmClicked_()
    self:hidePanel()
end

return HolidayRewardPopup
