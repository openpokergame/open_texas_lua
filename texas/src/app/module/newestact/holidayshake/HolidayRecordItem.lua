--赠送记录item
local HolidayRecordItem = class("HolidayRecordItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local WIDTH, HEIGHT = 680, 110
local BG_W, BG_H = WIDTH - 10, HEIGHT - 10

function HolidayRecordItem:ctor()
    HolidayRecordItem.super.ctor(self, WIDTH, HEIGHT)
    self.this_ = self
end

function HolidayRecordItem:createContent_()
    local bg = display.newScale9Sprite("#holiday_shake_item_normal.png", 0, 0, cc.size(BG_W, BG_H), cc.rect(140, 48, 1, 1))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local cy = BG_H*0.5
    self.avatar_ = SimpleAvatar.new()
        :pos(60, cy)
        :addTo(bg)

    local sex_x = 135
    self.sexIcon_ = display.newSprite("#common/common_sex_male.png")
        :align(display.LEFT_CENTER, sex_x, cy + 20)
        :scale(0.7)
        :addTo(bg)

    self.nick_ =  ui.newTTFLabel({text = "", size = 24})
        :align(display.LEFT_CENTER, sex_x + 30, cy + 20)
        :addTo(bg)

    self.uid_ =  ui.newTTFLabel({text = "", size = 24})
        :align(display.LEFT_CENTER, sex_x, cy - 20)
        :addTo(bg)

    local money_x = 330
    display.newSprite("#common/common_chip_icon.png")
        :scale(0.8)
        :align(display.LEFT_CENTER, money_x, cy)
        :addTo(bg)

    self.money_ =  ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 24})
        :align(display.LEFT_CENTER, money_x + 35, cy)
        :addTo(bg)

    self.time_ =  ui.newTTFLabel({text = "", size = 24})
        :align(display.LEFT_CENTER, 540, cy)
        :addTo(bg)
end

function HolidayRecordItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function HolidayRecordItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function HolidayRecordItem:setData_(data)
    self.avatar_:setDefaultAvatar(data.sex)
    self.avatar_:loadImage(data.img)
    if data.sex == "f" then
        self.sexIcon_:setSpriteFrame("common/common_sex_female.png")
    else
        self.sexIcon_:setSpriteFrame("common/common_sex_male.png")
    end
    self.nick_:setString(tx.Native:getFixedWidthText("", 24, data.nick, 150))
    self.uid_:setString("ID:" .. data.uid)
    self.money_:setString(sa.formatNumberWithSplit(data.sendChips))
    self.time_:setString(data.time)
end

return HolidayRecordItem