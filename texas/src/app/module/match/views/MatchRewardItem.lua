local MatchRewardItem = class("MatchRewardItem", sa.ui.ListItem)

local ITEM_W, ITEM_H = 854, 80
local RANKING_X = 99

function MatchRewardItem:ctor()
    MatchRewardItem.super.ctor(self, ITEM_W, ITEM_H)

    local frame = display.newNode()
        :size(ITEM_W, ITEM_H)
        :align(display.CENTER, ITEM_W/2, ITEM_H/2)
        :addTo(self)
    self.frame_ = frame

    display.newScale9Sprite("#common/split_line_h.png", ITEM_W/2, ITEM_H/2, cc.size(ITEM_W, 2))
        :align(display.BOTTOM_CENTER, ITEM_W/2, 1)
        :addTo(frame)

    local y = ITEM_H/2
    self.ranking_ = ui.newTTFLabel({text = "", size = 36, color = styles.FONT_COLOR.CONTENT_TEXT, align = ui.TEXT_ALIGN_CENTER})
        :pos(RANKING_X, y)
        :addTo(frame)
        :hide()

    self.reward_ = ui.newTTFLabel({text = "", size = 30, color = styles.FONT_COLOR.CHIP_TEXT, align = ui.TEXT_ALIGN_CENTER})
        :align(display.RIGHT_CENTER, ITEM_W - 60, y)
        :addTo(frame)
end

function MatchRewardItem:onDataSet(dataChanged, data)
    if self.index_ <= 3 then
        self.topRankIcon_ = display.newSprite("#common/ranking_icon_" .. self.index_ .. ".png")
            :pos(RANKING_X, ITEM_H/2 + 10)
            :scale(0.7)
            :addTo(self.frame_)
        self.ranking_:hide()
    else
        if self.topRankIcon_ then
            self.topRankIcon_:removeFromParent()
        end
        self.ranking_:setString(self.index_)
        self.ranking_:show()
    end

    local str = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatBigNumber(data.chips))
    if self.index_ == 1 and data.dhqReward > 0 then
        local str2 = sa.LangUtil.getText("STORE", "FORMAT_DHQ", data.dhqReward)
        str = str .. " + " .. str2
    end
    self.reward_:setString(str)
end

return MatchRewardItem
