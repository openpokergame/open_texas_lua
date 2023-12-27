local ItemLevels = class("ItemLevels", sa.ui.ListItem);
ItemLevels.WIDTH, ItemLevels.HEIGHT = 10,60
function ItemLevels:ctor()
	self:setNodeEventEnabled(true)
	ItemLevels.super.ctor(self, ItemLevels.WIDTH, ItemLevels.HEIGHT)
end

function ItemLevels:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self.bg_ = display.newScale9Sprite("#dialogs/help/level_item.png",0,0,cc.size(ItemLevels.WIDTH, ItemLevels.HEIGHT))
            :pos(self.width_*0.5,self.height_*0.5)
            :addTo(self)
        self.labelName_ = ui.newTTFLabel({text = "", color = cc.c3b(0xf3, 0xe0, 0xb6), size = 22})
            :pos(55, self.height_*0.5)
            :addTo(self)
        self.labelChenHao_ = ui.newTTFLabel({text = "", dimensions=cc.size(220, 0),  align=ui.TEXT_ALIGN_CENTER, size = 22})
            :pos(235, self.height_*0.5)
            :addTo(self)
        self.labelJinYan_ = ui.newTTFLabel({text = "", color = cc.c3b(0x43, 0xbf, 0xff), size = 22})
            :pos(460, self.height_*0.5)
            :addTo(self)
        self.labelJiangLi_ = ui.newTTFLabel({text = "", color = cc.c3b(0xff, 0xf2, 0x63), dimensions=cc.size(220, 0),  align=ui.TEXT_ALIGN_CENTER, size = 22})
            :pos(668, self.height_*0.5)
            :addTo(self)
    end
    if self.data_ and self.dataChanged_ then
        self.labelName_:setString(self.data_.level or "")
        self.labelChenHao_:setString(self.data_.name or "")
        self.labelJinYan_:setString(self.data_.exp or "")
        self.labelJiangLi_:setString(self.data_.reward or "")
    end
    if self:getIndex()%2==0 then
        self.bg_:show()
    else
        self.bg_:hide()
    end
end

function ItemLevels:onDataSet(dataChanged, data)
	self.dataChanged_ = true
    self.data_ = data
end

function ItemLevels:onCleanup()
	if self.iconLoaderId_ then
		
	end
end

return ItemLevels;