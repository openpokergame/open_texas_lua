local LanguageListItem = class("LanguageListItem", sa.ui.ListItem)

local ITEM_W, ITEM_H = 250, 60
local BG_W, BG_H = 178, 203

function LanguageListItem:ctor()
    LanguageListItem.super.ctor(self, ITEM_W, ITEM_H)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self:setNodeEventEnabled(true)
    
    self.line_ = display.newScale9Sprite("#common/setting_item_line.png", 0, 0, cc.size(ITEM_W, 2))
        :align(display.BOTTOM_CENTER, ITEM_W/2, 0)
        :addTo(self)

    local btn = cc.ui.UIPushButton.new({normal = "#common/transparent.png", pressed = "#dialogs/setting/drop_down_box_item_pressed.png"}, {scale9 = true})
        :setButtonSize(ITEM_W, ITEM_H)
        :onButtonClicked(buttontHandler(self,self.onSelectedClicked_))
        :pos(ITEM_W/2, ITEM_H/2)
        :addTo(self)

    btn:setTouchSwallowEnabled(false)

    self.icon_ = display.newSprite()
        :pos(32, ITEM_H/2)
        :addTo(self)

    self.lang_ = ui.newTTFLabel({text = "", size = 24, color = cc.c3b(0xef, 0xef, 0xef)})
        :align(display.LEFT_CENTER, 75, ITEM_H/2)
        :addTo(self)
end

function LanguageListItem:onSelectedClicked_()
    self:dispatchEvent({name="ITEM_EVENT", type="DROPDOWN_LIST_SELECT", data = self.data_})
end

function LanguageListItem:onDataSet(dataChanged, data)
    if dataChanged then
        self.data_ = data

        self.lang_:setString(data.lang)
        self.icon_:setSpriteFrame(data.icon)
        local index = self:getIndex()
        local list = self:getOwner()
        local listData = list:getData()
        if listData and #listData==index then
            self.line_:hide()
        else
            self.line_:show()
        end
    end
end

return LanguageListItem