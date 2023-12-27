-- 邀请好友列表元素

local InviteListItem = class("InviteListItem", function ()
    return display.newNode()
end)

local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local ITEM_W, ITEM_H = 552, 120
local NORMAL_IMAGE = "invite_friend_selected_off.png"
local SELECTED_IMAGE = "invite_friend_selected_on.png"
local TEXT_CORLOR = cc.c3b(0xc9, 0x76, 0x0)
local TEXT_GRAY = cc.c3b(0xa7, 0xa7, 0xa7)

InviteListItem.ITEM_WIDTH = ITEM_W
InviteListItem.ITEM_HEIGHT = ITEM_H

function InviteListItem:ctor(data, owner, popup, index)
    self:size(ITEM_W, ITEM_H)

    self.data_ = data
    self.owner_ = owner
    self.popup_ = popup

    self.isShowFBTips_ = tx.config.IS_SHOW_FB_TIPS
end

function InviteListItem:createContent_()
    local data = self.data_

    local btn = cc.ui.UIPushButton.new({normal = "#invite_friend_frame_normal.png", pressed = "#invite_friend_frame_pressed.png"}, {scale9=true})
        :setButtonSize(ITEM_W, ITEM_H)
        :onButtonClicked(handler(self, self.onSelectedClicked_))
        :setDelayTouchEnabled(false)
        :pos(ITEM_W/2, ITEM_H/2)
        :addTo(self)
    btn:setTouchSwallowEnabled(false)

    -- 头像
    self.avatar_ = SimpleAvatar.new({shapeImg = "#invite_friend_head_bg.png", frameImg = "#invite_friend_head_frame.png", isRectHead = true})
        :setDefaultAvatar(data.sex)
        :pos(60, ITEM_H/2)
        :addTo(self)

    if string.len(data.url) > 5 then
        self.avatar_:loadImage(data.url)
    end
 
    self.selectedIcon_ = display.newSprite("#" .. NORMAL_IMAGE)
        :pos(ITEM_W - 60, ITEM_H/2)
        :addTo(self)

    local nameLabel = ui.newTTFLabel({text = data.name, color = styles.FONT_COLOR.DARK_TEXT, size = 30})
        :align(display.LEFT_CENTER, 130, ITEM_H/2)
        :addTo(self)

    if self.isShowFBTips_ == 1 then
        nameLabel:pos(130, ITEM_H/2 + 25)
    end

    local x, y = 125, ITEM_H/2 - 25
    self.chipIcon_ =  display.newSprite("#invite_friend_chip_icon.png")
        :align(display.LEFT_CENTER, x, y)
        :addTo(self)

    self.reward_ = ui.newBMFontLabel({text = "+" .. data.chips, font = "fonts/xiaohuang.fnt"})
        :align(display.LEFT_CENTER, x + 75, y - 5)
        :addTo(self)

    self:updateSetSelectedStatus_()
end

function InviteListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end
    if self.avatarDeactived_ and self.data_ then
        self.avatarDeactived_ = false
        self.avatar_:loadImage(self.data_.url)
    end
end

function InviteListItem:onItemDeactived()
    if self.created_ then
        if self.avatarLoaded_ then
            self.avatarLoaded_ = false
            self.avatarDeactived_ = true
            self.avatar_:setDefaultAvatar(self.data_.sex)
        end
    end
end

function InviteListItem:onSelectedClicked_()
    if self.isSelected_ then
        self.isSelected_ = false
    else
        if self.popup_:isCanSelected() then
            self.isSelected_ = true
        end
    end

    self:updateSetSelectedStatus_()

    self.popup_:setSelecteTip()
end

function InviteListItem:getData()
    return self.data_
end

function InviteListItem:isSelected()
    return self.isSelected_
end

function InviteListItem:setSelected(isSelected)
    self.isSelected_ = isSelected
    if self.created_ then
        self:updateSetSelectedStatus_()
    end
end

function InviteListItem:updateSetSelectedStatus_()
    if self.isSelected_ then
        self.selectedIcon_:setSpriteFrame(SELECTED_IMAGE)
        self.chipIcon_:show()
        self.reward_:show()
    else
        self.selectedIcon_:setSpriteFrame(NORMAL_IMAGE)
        self.chipIcon_:hide()
        self.reward_:hide()
    end

    if self.isShowFBTips_ == 0 then
        self.chipIcon_:hide()
        self.reward_:hide()
    end
end

function InviteListItem:onCleanup()
end

return InviteListItem