--好友item
local HolidayFriendListItem = class("HolidayFriendListItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local WIDTH, HEIGHT = 680, 110
local BG_W, BG_H = 330, HEIGHT - 10
local ITEM_NUM = 2

function HolidayFriendListItem:ctor()
    HolidayFriendListItem.super.ctor(self, WIDTH, HEIGHT)
end

function HolidayFriendListItem:createContent_()
    self.itemList_ = {}
    local dir = 340
    local sx = WIDTH * 0.5 - dir*0.5
    for i = 1, ITEM_NUM do
        local cy = BG_H*0.5

        local item = display.newScale9Sprite("#holiday_shake_item_normal.png", 0, 0, cc.size(BG_W, BG_H), cc.rect(140, 48, 1, 1))
            :pos(sx, HEIGHT*0.5)
            :addTo(self)
            :hide()
        self.itemList_[i] = item

        ImgButton(item,"#holiday_shake_item_normal.png","#holiday_shake_pressed.png")
        item:setTouchSwallowEnabled(false)
        item:onButtonClicked(buttontHandler(self, self.onSelectedClicked_))
        item:setTag(i)

        item.avatar = SimpleAvatar.new()
            :pos(60, cy)
            :addTo(item)

        local sex_x = 135
        item.sexIcon = display.newSprite("#common/common_sex_male.png")
            :align(display.LEFT_CENTER, sex_x, cy + 20)
            :scale(0.7)
            :addTo(item)

        item.nick =  ui.newTTFLabel({text = "", size = 24})
            :align(display.LEFT_CENTER, sex_x + 30, cy + 20)
            :addTo(item)

        item.uid =  ui.newTTFLabel({text = "", size = 24})
            :align(display.LEFT_CENTER, sex_x, cy - 20)
            :addTo(item)

        sx = sx + dir
    end
end

function HolidayFriendListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function HolidayFriendListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function HolidayFriendListItem:setData_(data)
    for _, item in ipairs(self.itemList_) do
        item:hide()
    end

    for i, v in ipairs(data) do
        local item = self.itemList_[i]
        item:show()
        item.avatar:setDefaultAvatar(v.sex)
        item.avatar:loadImage(v.img)
        if v.sex == "f" then
            item.sexIcon:setSpriteFrame("common/common_sex_female.png")
        else
            item.sexIcon:setSpriteFrame("common/common_sex_male.png")
        end
        item.nick:setString(tx.Native:getFixedWidthText("", 24, v.nick, 150))
        item.uid:setString("ID:" .. v.uid)
    end
end

function HolidayFriendListItem:onSelectedClicked_(evt)
    local tag = evt.target:getTag()
    sa.EventCenter:dispatchEvent({name = "HOLIDAY_SELECTED_SEND_FRIEND", data = self.data_[tag].uid})
end

return HolidayFriendListItem