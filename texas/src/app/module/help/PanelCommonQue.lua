local PanelCommonQue = class("PanelCommonQue", function() return display.newNode() end)
local FAQListItem = import(".items.FAQListItem")

function PanelCommonQue:ctor()
	local LIST_WIDTH,LIST_HEIGHT = 794, 550
	FAQListItem.WIDTH = LIST_WIDTH
	self.bound = cc.rect(-LIST_WIDTH/2, -LIST_HEIGHT/2, LIST_WIDTH, LIST_HEIGHT)
	self.faqListView_ = sa.ui.ListView.new(
        	{viewRect = self.bound, direction = sa.ui.ListView.DIRECTION_VERTICAL},
        	FAQListItem
        )
        :pos(130, -45)
        :addTo(self)

    self.faqListView_:setData(sa.LangUtil.getText("HELP", "FAQ"))
end

function PanelCommonQue:setScrollContentTouchRect()
   self.faqListView_:setScrollContentTouchRect()
end

return PanelCommonQue