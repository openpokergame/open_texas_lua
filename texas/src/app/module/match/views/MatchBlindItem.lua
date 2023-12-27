local MatchBlindItem = class("MatchBlindItem", sa.ui.ListItem)

local ITEM_W, ITEM_H = 854, 50
local TEXT_COLOR = styles.FONT_COLOR.CONTENT_TEXT
local SELECTED_COLOR = cc.c3b(0xff, 0xe3, 0x62)

function MatchBlindItem:ctor()
    MatchBlindItem.super.ctor(self, ITEM_W, ITEM_H)

    local frame = display.newNode()
        :size(ITEM_W, ITEM_H)
        :align(display.CENTER, ITEM_W/2, ITEM_H/2)
        :addTo(self)

    display.newScale9Sprite("#common/split_line_h.png", ITEM_W/2, ITEM_H/2, cc.size(ITEM_W, 2))
        :align(display.BOTTOM_CENTER, ITEM_W/2, 1)
        :addTo(frame)

    local y = ITEM_H/2
    self.level_ = ui.newTTFLabel({text = "", color = TEXT_COLOR, size = 26})
        :pos(104, y)
        :addTo(frame)

    self.blind_ = ui.newTTFLabel({text = "", color = TEXT_COLOR, size = 26})
        :pos(309, y)
        :addTo(frame)

    self.preBlind_ = ui.newTTFLabel({text = "", color = TEXT_COLOR, size = 26})
        :pos(519, y)
        :addTo(frame)

    self.time_ =  ui.newTTFLabel({text = "", color = TEXT_COLOR, size = 26})
        :pos(729, y)
        :addTo(frame)
end

function MatchBlindItem:onDataSet(dataChanged, data)
    self.level_:setString(self.index_)

    local smallBlind = sa.formatBigNumber(data.blind)
    local bigBlind = sa.formatBigNumber(data.blind*2)
    self.blind_:setString(sa.LangUtil.getText("MATCH", "FORMAT_BLIND", smallBlind, bigBlind))

    self.preBlind_:setString(data.pre)

    self.time_:setString(data.time)
end

function MatchBlindItem:setNormalColor()
    self.level_:setTextColor(TEXT_COLOR)
    self.blind_:setTextColor(TEXT_COLOR)
    self.preBlind_:setTextColor(TEXT_COLOR)
    self.time_:setTextColor(TEXT_COLOR)
end

function MatchBlindItem:setSelectedColor()
    self.level_:setTextColor(SELECTED_COLOR)
    self.blind_:setTextColor(SELECTED_COLOR)
    self.preBlind_:setTextColor(SELECTED_COLOR)
    self.time_:setTextColor(SELECTED_COLOR)
end

return MatchBlindItem
