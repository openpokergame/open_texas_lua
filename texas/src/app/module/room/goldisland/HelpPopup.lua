local HelpPopup = class("HelpPopup", tx.ui.Panel)
local WIDTH, HEIGHT = 910, 690
local ScrollLabel = import("openpoker.ui.ScrollLabel")

function HelpPopup:ctor()
	HelpPopup.super.ctor(self, {WIDTH, HEIGHT})
	self:setTextTitleStyle(sa.LangUtil.getText("GOLDISLAND", "RULE_TITLE"))

    local bg = self.background_
    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(WIDTH - 56, 550))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 30)
        :addTo(bg)

    local label_1 = ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "RULE_POOL"), size = 46}):addTo(bg)
    local size_1 = label_1:getContentSize()

    local label_2 = ui.newTTFLabel({text = sa.formatNumberWithSplit(tx.userData.goldIslandPool), size = 46, color = styles.FONT_COLOR.CHIP_TEXT}):addTo(bg)
    local size_2 = label_2:getContentSize()

    local w = size_1.width + size_2.width + 5
    local label_x, label_y = WIDTH*0.5 - w*0.5, HEIGHT- 150
    label_1:align(display.LEFT_CENTER, label_x, label_y)
    label_2:align(display.LEFT_CENTER, label_x + size_1.width + 5, label_y)

	local dw, dh = WIDTH - 120, 460
	ScrollLabel.new({
            text=sa.LangUtil.getText("GOLDISLAND", "RULE_DESC"),
            color=cc.c3b(0x83,0x9d,0xff),
            size=28,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(dw, dh)
        },
        {
            viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
        })
		:pos(0,-80)
        :addTo(self)
end

return HelpPopup