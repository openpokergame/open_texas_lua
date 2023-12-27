-- 成就元素
local PlayerListItem = class("PlayerListItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local ITEM_W, ITEM_H = 910, 124
local BG_W, BG_H = 408, 120
local ITEM_DISTANCE = 416
local ROW_NUM = 2

function PlayerListItem:ctor()
    PlayerListItem.super.ctor(self, ITEM_W, ITEM_H)
end

function PlayerListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self.dataChanged_ = true
        local posX, posY = BG_W/2, BG_H/2
        local label_x = 142
        self.items_ = {}
        for i = 1, ROW_NUM do
            local item = display.newScale9Sprite("#common/pop_list_item_bg.png", 0, 0, cc.size(BG_W, BG_H))
                :pos(247 + ITEM_DISTANCE * (i - 1), ITEM_H/2)
                :addTo(self)
            self.items_[i] = item

            -- 头像
            item.avatar_ = SimpleAvatar.new()
                :pos(80, posY)
                :addTo(item)
            NormalButton(item.avatar_):onButtonClicked(buttontHandler(self, self.onPlayerClicked_))
            item.avatar_:setTouchSwallowEnabled(false)
            item.avatar_:setTag(i)

            -- 昵称标签
            item.nick_ =  ui.newTTFLabel({text = "", size = 26})
                :align(display.LEFT_CENTER, label_x, posY + 20)
                :addTo(item)

            display.newSprite("#common/common_chip_icon.png")
                :align(display.LEFT_CENTER, label_x - 5, posY - 20)
                :scale(0.7)
                :addTo(item)

            -- 资产
            item.money_ =  ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 26})
                :align(display.LEFT_CENTER, label_x + 30, posY - 20)
                :addTo(item)
        end
    end
    if self.data_ and self.dataChanged_ then
        self.dataChanged_ = false
        local data = self.data_
        for _, v in ipairs(self.items_) do
            v:hide()
        end

        local nick = ""
        for i, v in ipairs(data) do
            local item = self.items_[i]:show()

            nick = v.nick
            if not nick or string.trim(nick)=="" then
                nick = "ID:" .. v.uid
            end

            item.nick_:setString(nick)
            item.money_:setString(sa.formatNumberWithSplit(v.money))
            item.avatar_:setDefaultAvatar(v.sex)

            sa.fitSprteWidth(item.nick_, 260)
            if string.len(v.img) > 5 then
                item.avatar_:loadImage(v.img)
            end
        end
    end
end

function PlayerListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function PlayerListItem:onPlayerClicked_(evt)
    local tag = evt.target:getTag()
    local list = self:getOwner()
    list.onItemClickListener(self.data_[tag])
end

return PlayerListItem