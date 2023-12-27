local PanelFeedback = import(".PanelFeedback")
local PanelCommonQue = import(".PanelCommonQue")
local PanelLevel = import(".PanelLevel")
local PanelPlayIns = import(".PanelPlayIns")
local PanelGameWords = import(".PanelGameWords")

local HelpPopup = class("HelpPopup", tx.ui.Panel)
local WIDTH, HEIGHT = 1136, 746
local RIGHT_FRAME_W, RIGHT_FRAME_H = 820, 590 --右边内框大小
local PLAY_DESC_TAB = 1
local WORDS_DESC_TAB = 2
local LEVEL_DESC_TAB = 3
local FAQ_TAB = 4
local FEED_BACK_TAB = 5

function HelpPopup:ctor(param)
    self.param_ = param
    HelpPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setImgTitleStyle("#lang/pop_title_help.png")
    self:setLoading(true)

    display.addSpriteFrames("dialog_help.plist", "dialog_help.png", function()
        self:initViews_()
    end)
end

function HelpPopup:initViews_()
    local icon_x, icon_y = 63, 60
    local sid = appconfig.SID[string.upper(device.platform)]
    if sid==19 or sid==20 then

    else
        self:addIconNode_("#dialogs/help/line_icon.png", sa.LangUtil.getText("HELP", "LINE"), cc.c3b(0x59, 0xff, 0x70), icon_x, icon_y + 54)
        self:addIconNode_("#dialogs/help/fensi_home.png", sa.LangUtil.getText("HELP", "FANS"), cc.c3b(0x56, 0x77, 0xbc), icon_x, icon_y)
    end

    local bg_w, bg_h = RIGHT_FRAME_W, RIGHT_FRAME_H
    local frame = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(bg_w, bg_h))
        :align(display.RIGHT_BOTTOM, WIDTH - 28, 30)
        :addTo(self.background_)

    self.nodeRight = display.newNode():addTo(self)

    self:setLoading(false)

    local index = self.param_ and self.param_.index
    if not index or index<1 or index>5 then
        index = 1
    end

    local tabGroup = self:setMainTabStyle(sa.LangUtil.getText("HELP", "MAIN_TAB_TEXT"), index, handler(self, self.onMainTabChange_))
    self:onMainTabChange_({selected = index})
end

function HelpPopup:addIconNode_(img, title, color, x, y)
    display.newSprite(img)
        :pos(x, y)
        :addTo(self.background_)

    local label = ui.newTTFLabel({text = title, size = 22, color = color})
        :align(display.LEFT_CENTER, x + 25, y)
        :addTo(self.background_)
    sa.fitSprteWidth(label, 200)
end

function HelpPopup:onMainTabChange_(evt)
    local idx = evt.selected
    if self.playIns_ then self.playIns_:hide() end
    if self.levelIns_ then self.levelIns_:hide() end
    if self.question_ then self.question_:hide() end
    if self.feedBack_ then self.feedBack_:hide() end
    if self.gameWords_ then self.gameWords_:hide() end

    if idx == PLAY_DESC_TAB then
        if self.playIns_ then
            self.playIns_:show()
        else
            self.playIns_ = PanelPlayIns.new(self.param_ and self.param_.subIndex):addTo(self.nodeRight)
        end
    elseif idx == LEVEL_DESC_TAB then
        if self.levelIns_ then
            self.levelIns_:show()
        else
            self.levelIns_ = PanelLevel.new(self.param_ and self.param_.subIndex):addTo(self.nodeRight)
        end
    elseif idx == FAQ_TAB then
        if self.question_ then
            self.question_:show()
        else
            self.question_ = PanelCommonQue.new(self.param_ and self.param_.subIndex):addTo(self.nodeRight)
        end
    elseif idx == FEED_BACK_TAB then
        if self.feedBack_ then
            self.feedBack_:show()
        else
            self.feedBack_ = PanelFeedback.new(self.param_ and self.param_.subIndex):addTo(self.nodeRight)
        end
    elseif idx == WORDS_DESC_TAB then
        if self.gameWords_ then
            self.gameWords_:show()
        else
            self.gameWords_ = PanelGameWords.new(self.param_ and self.param_.subIndex):addTo(self.nodeRight)
        end  
    end

    self.param_ = nil
end

function HelpPopup:onShowed()
    if self.playIns_ then
        self.playIns_:setScrollContentTouchRect()
    end
    if self.levelIns_ then
        self.levelIns_:setScrollContentTouchRect()
    end
    if self.question_ then
        self.question_:setScrollContentTouchRect()
    end
    if self.gameWords_ then
        self.gameWords_:setScrollContentTouchRect()
    end
end

function HelpPopup:onCleanup()
    display.removeSpriteFramesWithFile("dialog_help.plist", "dialog_help.png")
end

return HelpPopup