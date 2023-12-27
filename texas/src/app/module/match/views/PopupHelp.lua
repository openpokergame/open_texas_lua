local WIDTH, HEIGHT = 910, 690
local ScrollLabel = import("openpoker.ui.ScrollLabel")
local PopupHelp = class("PopupHelp", tx.ui.Panel)

function PopupHelp:ctor(index)
	PopupHelp.super.ctor(self, {WIDTH, HEIGHT})
    local title
    local rule
    if index == 1 then
        title = sa.LangUtil.getText("MATCH", "SNG_HELP_TITLE")
        rule = sa.LangUtil.getText("MATCH", "SNG_RULE")
    else
        title = sa.LangUtil.getText("MATCH", "MTT_HELP_TITLE")
        rule = sa.LangUtil.getText("MATCH", "MTT_RULE")
    end

	self:setTextTitleStyle(title, true)

    local content = ""
    for i, v in ipairs(rule) do
        if i > 1 then
            content = content .. "\n\n"
        end
        content = content .. v.title .. "\n" .. v.content
    end

	local dw, dh = WIDTH - 120, 520
	self.playDesc_ = ScrollLabel.new({
            text=content,
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