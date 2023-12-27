local ItemFeedback = class("ItemFeedback", sa.ui.ListItem)
local TITLEHEIGHT = 55
ItemFeedback.WIDTH, ItemFeedback.HEIGHT = 10,85
function ItemFeedback:ctor()
	self:setNodeEventEnabled(true)
	ItemFeedback.super.ctor(self, ItemFeedback.WIDTH, ItemFeedback.HEIGHT)
	self.bg_ = display.newScale9Sprite("#dialogs/help/feed_split.png",0,0,cc.size(ItemFeedback.WIDTH-2, 2))
        :align(display.LEFT_BOTTOM,0,0)
		:addTo(self)
    self.qTitle_ = ui.newTTFLabel({text = "名字", color = cc.c3b(0xc6, 0xb3, 0xff), size = 22})
        :align(display.LEFT_CENTER,6,62)
        :addTo(self)
    self.aTitle_ = ui.newTTFLabel({text = "名字", color = cc.c3b(0x85, 0x73, 0xbf), size = 22})
        :align(display.LEFT_CENTER,6,28)
        :addTo(self)
end

function ItemFeedback:onDataSet(dataChanged, data)
	self.data_ = data;
    if self.data_ and dataChanged then
        self.qTitle_:setString(data.q)
        self.aTitle_:setString(data.a)
    end
end

function ItemFeedback:onCleanup()
	if self.iconLoaderId_ then
		
	end
end

return ItemFeedback;