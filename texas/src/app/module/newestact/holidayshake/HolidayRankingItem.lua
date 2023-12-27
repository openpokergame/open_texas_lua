--赠送记录item
local HolidayRankingItem = class("HolidayRankingItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local WIDTH, HEIGHT = 680, 110
local BG_W, BG_H = WIDTH - 10, HEIGHT - 10
local RANK_X = 50

function HolidayRankingItem:ctor()
    HolidayRankingItem.super.ctor(self, WIDTH, HEIGHT)
end

function HolidayRankingItem:createContent_()
    local bg = display.newScale9Sprite("#holiday_shake_item_normal.png", 0, 0, cc.size(BG_W, BG_H), cc.rect(140, 48, 1, 1))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local cy = BG_H*0.5
    local pos_x = {RANK_X, 190, 330, 590}
    self.ranking_ = ui.newBMFontLabel({text = "", font = "fonts/hall_ranking.fnt"})
        :pos(pos_x[1], cy)
        :addTo(bg)

    self.fromNick_ =  ui.newTTFLabel({text = "", size = 20})
        :pos(pos_x[2], cy)
        :addTo(bg)

    local money_x = pos_x[3]
    display.newSprite("#common/common_chip_icon.png")
        :scale(0.8)
        :align(display.LEFT_CENTER, money_x, cy)
        :addTo(bg)

    self.money_ = ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 24})
        :align(display.LEFT_CENTER, money_x + 35, cy)
        :addTo(bg)

    self.toNick_ = ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 20})
        :pos(pos_x[4], cy)
        :addTo(bg)
end

function HolidayRankingItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function HolidayRankingItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function HolidayRankingItem:setData_(data)
    if self.index_ <= 3 then
        self.topRankIcon_ = display.newSprite("#common/ranking_icon_" .. self.index_ .. ".png")
            :pos(RANK_X + 5, BG_H/2 + 8)
            :addTo(self)
        self.ranking_:hide()
    else
        if self.topRankIcon_ then
            self.topRankIcon_:removeFromParent()
        end
        self.ranking_:setString(self.index_)
        self.ranking_:show()
    end

    self.fromNick_:setString(tx.Native:getFixedWidthText("", 20, data.fromName, 220))

    self.money_:setString(sa.formatNumberWithSplit(data.sendChips))

    self.toNick_:setString(tx.Native:getFixedWidthText("", 20, data.toName, 150))
end

return HolidayRankingItem