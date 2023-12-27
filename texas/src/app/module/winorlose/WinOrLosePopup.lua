-- 输赢统计弹窗
local WinOrLosePopup = class("WinOrLosePopup", function()
    return display.newNode()
end)
local WIDTH, HEIGHT = display.width, display.height
local BTN_W, BTN_H = 310, 146
local WIN_COLOR = cc.c3b(0xff, 0xff, 0xff)
local LABEL_X = -80
local BTN_DIR = 360

function WinOrLosePopup:ctor(param)
    local bg = display.newSprite("img/win_or_lose_bg.jpg")
        :scale(tx.bgScale)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
        :pos(display.cx - 50, display.cy - 50)
        :onButtonClicked(function()
            self:hidePanel()
            tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        end)
        :addTo(self)

    self.param_ = param
    if param and param.type==1 and tx.config.SHOW_GUIDE_RATE==1 then
        self:addPraiseNode_()
    else
        self:addShareNode_()
    end
end

--分享节点
function WinOrLosePopup:addShareNode_()
    local bg = self
    local x = LABEL_X
    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "YING"), color = WIN_COLOR, size = 50})
        :align(display.LEFT_CENTER, x, 240)
        :addTo(bg)

    local label = ui.newBMFontLabel({text = sa.formatNumberWithSplit(self.param_.changeChips), font = "fonts/shouchong.fnt"})    
        :align(display.LEFT_CENTER, x, 170)
        :addTo(bg)
    sa.fitSprteWidth(label, WIDTH*0.5 - 20)

    -- ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "CHOUMA", ""), color=cc.c3b(0xff,0xf0,0x63), size = 60})
    --     :align(display.LEFT_CENTER, x, 100)
    --     :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "INFO_1", self.param_.playNum),size = 38, color=WIN_COLOR})
        :align(display.LEFT_CENTER, x, -20)
        :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "INFO_2", sa.formatNumberWithSplit(self.param_.maxWin)),size = 38, color=WIN_COLOR})
        :align(display.LEFT_CENTER, x, -80)
        :addTo(bg)

    local btn_x, btn_y = x - 30, -220
    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(BTN_W, BTN_H)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "CONTINUE"), size = 30}))
        :onButtonClicked(buttontHandler(self, self.onContinueClicked_))
        :align(display.LEFT_CENTER, btn_x, btn_y)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(BTN_W, BTN_H)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "SHARE"), size = 30}))
        :onButtonClicked(buttontHandler(self, self.onShareClicked_))
        :align(display.LEFT_CENTER, btn_x + BTN_DIR, btn_y)
        :addTo(bg)
end

function WinOrLosePopup:onContinueClicked_()
    local gameId = self.param_.gameId
    local gameLevel = self.param_.gameLevel
    local curScene = display.getRunningScene()
    curScene:requestRoom({level = gameLevel, gameId = gameId})

    self:hidePanel()
end

function WinOrLosePopup:onShareClicked_()
    local feedData = clone(sa.LangUtil.getText("FEED", "COUNT"))
    feedData.name = sa.LangUtil.formatString(feedData.name, self.param_.changeChips)
    tx.ShareSDK:shareFeed(feedData, function(success, result)
        if success then
            self:hidePanel()
        end
    end)
end

--好评节点
function WinOrLosePopup:addPraiseNode_()
    local bg = self
    local x = LABEL_X
    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "YING"), color = WIN_COLOR, size = 50})
        :align(display.LEFT_CENTER, x, 240)
        :addTo(bg)

    local label = ui.newBMFontLabel({text = sa.formatNumberWithSplit(self.param_.changeChips), font = "fonts/shouchong.fnt"})    
        :align(display.LEFT_CENTER, x, 170)
        :addTo(bg)
    sa.fitSprteWidth(label, WIDTH*0.5 - 20)

    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "INFO_1", self.param_.playNum),size = 38, color=WIN_COLOR})
        :align(display.LEFT_CENTER, x, -15)
        :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "INFO_2", sa.formatNumberWithSplit(self.param_.maxWin)),size = 38, color=WIN_COLOR})
        :align(display.LEFT_CENTER, x, -75)
        :addTo(bg)

    local mulLabel = ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "RATE5"), color=cc.c3b(0xff,0xf0,0x63), size = 24, dimensions=cc.size(WIDTH*0.5 - 20, 0)})
        :align(display.LEFT_TOP, x, -110)
        :addTo(bg)
    local size = mulLabel:getContentSize()
    if size.height>75 then
        mulLabel:scale(75/size.height)
    end

    local btn_x, btn_y = x, -230
    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(BTN_W, BTN_H)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "SHARE"), size = 30}))
        -- :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "LATER"), size = 26}))
        :onButtonClicked(buttontHandler(self, self.onNextPraiseClicked_))
        :align(display.LEFT_CENTER, btn_x, btn_y)
        :addTo(bg)

    local label = ui.newTTFLabel({text = sa.LangUtil.getText("WINORLOSE", "NOW"), size = 30})
    sa.fitSprteWidth(label, 200)
    local btn = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(BTN_W, BTN_H)
        :setButtonLabel(label)
        :onButtonClicked(buttontHandler(self, self.onImmediatelyPraiseClicked_))
        :align(display.LEFT_CENTER, btn_x + BTN_DIR, btn_y)
        :addTo(bg)
end

function WinOrLosePopup:onNextPraiseClicked_()
    self:onShareClicked_()
end

function WinOrLosePopup:onImmediatelyPraiseClicked_()
    -- 直接不弹了
    tx.userDefault:setIntegerForKey("CUR_SHARE_VER_NUM",3)
    if tx.userData.commentUrl and #tx.userData.commentUrl>0 then
        device.openURL(tx.userData.commentUrl)
    end
    self:hidePanel()
end

function WinOrLosePopup:showPanel()
    tx.PopupManager:addPopup(self, false, true, false, true)
    return self
end

function WinOrLosePopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function WinOrLosePopup:onCleanup()
    tx.userDefault:flush()
end

return WinOrLosePopup