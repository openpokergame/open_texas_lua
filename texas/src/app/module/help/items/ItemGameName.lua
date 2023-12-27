local ItemGameName = class("ItemGameName", sa.ui.ListItem)

local TITLE_DIR = 20
local CONTENT_DIR = 60
ItemGameName.WIDTH, ItemGameName.HEIGHT = 10,100

function ItemGameName:ctor()
	self:setNodeEventEnabled(true)

    local item_w, item_h = ItemGameName.WIDTH, ItemGameName.HEIGHT
	ItemGameName.super.ctor(self, item_w, item_h)

    self.labelTitle_ = ui.newTTFLabel({text = "", size = 30})
        :align(display.LEFT_TOP, 20, item_h - TITLE_DIR)
        :addTo(self)

    self.labelContent_ = ui.newTTFLabel({
            text="",
            color=styles.FONT_COLOR.CONTENT_TEXT,
            size=26,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(item_w - 40, 0)
        })
        :align(display.LEFT_TOP, 20, item_h - CONTENT_DIR)
        :addTo(self)
end

function ItemGameName:onDataSet(dataChanged, data)
	self.data_ = data
    if self.data_ and dataChanged then
        self.labelTitle_:setString(data.title)
        self.labelContent_:setString(data.desc)

	   	local labelSize = self.labelContent_:getContentSize()
        local item_h = CONTENT_DIR + labelSize.height
        self:size(self.width_, item_h)

        self.labelTitle_:setPositionY(item_h - TITLE_DIR)
        self.labelContent_:setPositionY(item_h - CONTENT_DIR)
    end
end

function ItemGameName:onCleanup()
end

return ItemGameName;