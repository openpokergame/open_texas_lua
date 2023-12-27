local WIDTH, HEIGHT = 910, 690
local FRAME_W, FRAME_H = WIDTH - 56, HEIGHT - 150
local ScrollLabel = import("openpoker.ui.ScrollLabel")
local HelpPopup = class("HelpPopup", tx.ui.Panel)
local CARD_TYPE
local IMAGE = {
    "img/redblack_silver_card_type_bg.jpg",
    "img/redblack_gold_card_type_bg.jpg",
    "img/redblack_draw_card_type_bg.jpg",
}

local TEXT_COLOR = {
    cc.c3b(0x0, 0x0, 0x0),
    cc.c3b(0x9a, 0x4c, 0x01),
    cc.c3b(0xff, 0xff, 0xff),
}

function HelpPopup:ctor(model)
	HelpPopup.super.ctor(self, {WIDTH, HEIGHT})

	self:addCloseBtn()

    CARD_TYPE = sa.LangUtil.getText("COMMON", "CARD_TYPE")
    self.model_ = model
    local bg = self.background_
    local x = WIDTH*0.5
    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        sa.LangUtil.getText("REDBLACK", "SUB_TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = styles.FONT_COLOR.CONTENT_TEXT, size = 22}
        }, true, true)
        :setTabBarSize(538, 52, 0, -4)
        :onTabChange(handler(self, self.onSubTabChange_))
        :pos(x, HEIGHT - 70)
        :addTo(bg)

    self.bg_ = display.newNode()
        :size(FRAME_W, FRAME_H)
        :align(display.BOTTOM_CENTER, x, 30)
        :addTo(bg)

    self:addTrendNode_()

    self:addRuleNode_()

    tab:gotoTab(1, true)
end

function HelpPopup:onSubTabChange_(selected)
    if selected == 1 then
        self.trendNode_:show()
        self.ruleNode_:hide()
    else
        self.ruleNode_:show()
        self.trendNode_:hide()
    end
end

--胜负走势
function HelpPopup:addTrendNode_()
    local data = self.model_:getHistory()
    local node = display.newNode()
        :addTo(self.bg_)
        :hide()
    self.trendNode_ = node

    --近期走势
    local label_x = 10
    local frame_w, frame_h = 840, 315
    local frame = display.newScale9Sprite("#common/setting_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.LEFT_TOP, 7, FRAME_H)
        :addTo(node)

    display.newScale9Sprite("#common/setting_item_line.png", 0, 0, cc.size(frame_w, 2))
        :pos(frame_w*0.5, frame_h - 45)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "RECENT_TREND"), size = 26})
        :align(display.LEFT_CENTER, label_x, frame_h - 25)
        :addTo(frame)

    local sx, sy = 9, frame_h - 76
    local row = 8
    local dir_x, dir_y = 103, 52
    local itme_w, item_h = 102, 50
    local len = #data
    for i, v in ipairs(data) do
        local x = sx + ((i - 1) % row) * dir_x
        local y = sy - math.floor((i - 1) / row) * dir_y
        local item = display.newSprite(IMAGE[v.winner])
            :align(display.LEFT_CENTER, x, y)
            :addTo(frame)

        local label = ui.newTTFLabel({text = CARD_TYPE[v.cardType], size = 18, color = TEXT_COLOR[v.winner]})
            :pos(itme_w*0.5, item_h*0.5)
            :addTo(item)
        sa.fitSprteWidth(label, 92)

        if i == len then
            display.newSprite("#redblack/room/redblack_win_history_new.png")
                :pos(itme_w - 10, item_h - 10)
                :addTo(item)
        end
    end

    --今日统计
    local countList = self.model_:getCountList()
    local labelX = {label_x, label_x + 145, label_x + 400, label_x + 660}
    local frame_w, frame_h = 840, 206
    local label_y = frame_h - 25
    local frame = display.newScale9Sprite("#common/setting_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.LEFT_BOTTOM, 7, 10)
        :addTo(node)

    local line_x, line_y = frame_w*0.5, 52
    for i = 1, 3 do
        display.newScale9Sprite("#common/setting_item_line.png", 0, 0, cc.size(frame_w, 2))
            :pos(line_x, line_y)
            :addTo(frame)

        line_y = line_y + 52
    end

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "TODAY_COUNT"), size = 26})
        :align(display.LEFT_CENTER, label_x, label_y)
        :addTo(frame)

    --胜 负
    label_y = label_y - 52
    local textColor = styles.FONT_COLOR.CONTENT_TEXT
    local fontSize = 22
    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "WIN_LOSE"), size = fontSize})
        :align(display.LEFT_CENTER, labelX[1], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_1", countList.goldkWinTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[2], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_2", countList.silverWinTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[3], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_3", countList.drawWinTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[4], label_y)
        :addTo(frame)

    --手 牌
    label_y = label_y - 50
    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "HAND_CARD"), size = fontSize})
        :align(display.LEFT_CENTER, labelX[1], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_4", countList.thlpTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[2], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_5", countList.daTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[3], label_y)
        :addTo(frame)

    --获胜牌型
    label_y = label_y - 54
    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "WIN_CARD_TYPE"), size = fontSize})
        :align(display.LEFT_CENTER, labelX[1], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_6", countList.hlTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[2], label_y)
        :addTo(frame)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK", "COUNT_TIPS_7", countList.jgTimes), size = fontSize, color = textColor})
        :align(display.LEFT_CENTER, labelX[3], label_y)
        :addTo(frame)
end

--游戏规则
function HelpPopup:addRuleNode_()
    local frame_w, frame_h = 840, 528
    self.ruleNode_ = display.newScale9Sprite("#common/setting_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.LEFT_TOP, 7, FRAME_H)
        :addTo(self.bg_)
        :hide()

    local dw, dh = frame_w - 60, frame_h - 40
    ScrollLabel.new({
            text=sa.LangUtil.getText("REDBLACK", "RULE"),
            color=styles.FONT_COLOR.CONTENT_TEXT,
            size=28,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(dw, dh)
        },
        {
            viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
        })
        :pos(frame_w*0.5, frame_h*0.5)
        :addTo(self.ruleNode_)
end

return HelpPopup