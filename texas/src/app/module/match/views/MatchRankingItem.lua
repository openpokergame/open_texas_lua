local MatchRankingItem = class("MatchRankingItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local BG_W, BG_H = 834, 120
local ITEM_W, ITEM_H = BG_W + 20, BG_H + 5
local RANKING_X = 60

function MatchRankingItem:ctor()
    MatchRankingItem.super.ctor(self, ITEM_W, ITEM_H)

    self.frame_ = display.newScale9Sprite("#common/pop_list_item_bg.png", ITEM_W/2, ITEM_H/2, cc.size(BG_W, BG_H)):addTo(self)
    local frame = self.frame_

    local y = BG_H/2

    -- 名次
    self.ranking_ = ui.newTTFLabel({text = "", size = 36, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(RANKING_X, y)
        :addTo(frame)

    -- 头像
    local avatarSize = 88
    local avatar_x = 160
    self.avatar_ = SimpleAvatar.new()
        :pos(avatar_x, y)
        :addTo(frame)
    NormalButton(self.avatar_):onButtonClicked(function()
    end)
    self.avatar_:setTouchSwallowEnabled(false)

    self.nick_ =  ui.newTTFLabel({text = "", size = 24, color = styles.FONT_COLOR.CONTENT_TEXT})
        :align(display.LEFT_CENTER, avatar_x + 50, y)
        :addTo(frame)

    self.chip_ =  ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 24})
        :pos(BG_W - 80, y)
        :addTo(frame)
end

function MatchRankingItem:onDataSet(dataChanged, data)
    if data.rank <= 3 then
        self.topRankIcon_ = display.newSprite("#common/ranking_icon_" .. data.rank .. ".png")
            :pos(RANKING_X, BG_H/2 + 13)
            :addTo(self.frame_)
        self.ranking_:hide()
    else
        if self.topRankIcon_ then
            self.topRankIcon_:removeFromParent()
        end
        self.ranking_:setString(data.rank)
        self.ranking_:show()
    end

    if string.len(data.img) > 5 then
        self.avatar_:loadImage(data.img)
    end

    self.nick_:setString(data.name)

    self.chip_:setString(sa.formatBigNumber(data.chip))
end

return MatchRankingItem
