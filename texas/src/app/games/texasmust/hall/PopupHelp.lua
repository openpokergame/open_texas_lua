local WIDTH, HEIGHT = 830, 570
local ScrollLabel = import("openpoker.ui.ScrollLabel")
local PopupHelp = class("PopupHelp", tx.ui.Panel)

function PopupHelp:ctor()
	PopupHelp.super.ctor(self, {WIDTH, HEIGHT})
    local title = sa.LangUtil.getText("HALL", "TEXAS_MUST_HELP_TITLE")
    local rule = sa.LangUtil.getText("HALL", "TEXAS_MUST_RULE")

	self:setTextTitleStyle(title, true)

	local dw, dh = WIDTH - 100, 400
	ScrollLabel.new({
            text=rule,
            color=cc.c3b(0x83,0x9d,0xff),
            size=28,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(dw, dh)
        },
        {
            viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
        })
		:pos(0,-45)
        :addTo(self)
end

return PopupHelp