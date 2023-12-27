local CardPowerPopup = class("CardPowerPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570 --弹窗大小
function CardPowerPopup:ctor() 
    CardPowerPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("SETTING", "CARD_POWER"))

    roomLevel = roomLevel or 1
    local bg = self.background_
    local frame_w ,frame_h = WIDTH - 64, 420
    local label_x = 32
    local frame = display.newScale9Sprite("#common/setting_frame.png", 0, 0, cc.size(WIDTH - 64, 420))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 32)
        :addTo(bg)
    self.frame_ = frame

    ui.newTTFLabel({text = sa.LangUtil.getText("ROOM", "CARD_POWER_DESC"), size = 26, color = styles.FONT_COLOR.CONTENT_TEXT, dimensions = cc.size(frame_w - 60, 0)})
        :align(display.TOP_LEFT, label_x, frame_h - 20)
        :addTo(frame)

    display.newScale9Sprite("#common/setting_item_line.png", 0, 0, cc.size(frame_w - 10, 2))
        :pos(frame_w*0.5, 84)
        :addTo(frame)

    if not tx.checkIsVip() then
        self:addVipNode_()
    end

    local isCardPowerTips = tx.userDefault:getBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, true)
    self.openCardPowerStatus_ = isCardPowerTips
    local y = 45
    ui.newTTFLabel({text = sa.LangUtil.getText("SETTING", "CARD_POWER"), size = 30})
        :align(display.LEFT_CENTER, label_x, y)
        :addTo(frame)

    cc.ui.UICheckBoxButton.new({on = "#common/setting_checkbox_on.png", off = "#common/setting_checkbox_off.png"})
        :onButtonStateChanged(handler(self, self.onCardPowerChangeListener_))
        :setButtonSelected(isCardPowerTips)
        :pos(frame_w - 98, y)
        :addTo(frame)
end

function CardPowerPopup:onCardPowerChangeListener_(event)
    tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)

    if event.target:isButtonSelected() then
        self.isCardPowerTips_ = true
    else
        self.isCardPowerTips_ = false
    end
end

function CardPowerPopup:addVipNode_()
    local frame = self.frame_
    local label_x, label_y =32, 120
    local labelColor = cc.c3b(0xff, 0xec, 0x69)
    local label = ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "CARD_POWER_TIPS"), size = 26})
        :align(display.LEFT_CENTER, label_x, label_y)
        :addTo(frame)
    local labelSize = label:getContentSize()

    local btnLabel = ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "CARD_POWER_OPEN_VIP"), size = 26, color = labelColor})
    local btnSize = btnLabel:getContentSize()
    local btn_x, btn_y = label_x + labelSize.width + btnSize.width*0.5 + 5, label_y
    local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btnSize.width, btnSize.height)
        :setButtonLabel("normal", btnLabel)
        :onButtonClicked(buttontHandler(self, self.onOpenVIPClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)

    local line = ui.newTTFLabel({text = "_", size = 26, color = labelColor})
        :pos(btn_x, btn_y)
        :addTo(frame)
    local lineSize = line:getContentSize()
    line:setScaleX(btnSize.width/lineSize.width)
end

function CardPowerPopup:onOpenVIPClicked_()
    tx.PayGuideManager:openStore(4)
    self:hidePanel()
end

function CardPowerPopup:onCleanup()
    tx.userDefault:setBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, self.isCardPowerTips_)
    local curScene = tx.runningScene
    if curScene and curScene.dealCardPower and self.isCardPowerTips_~=self.openCardPowerStatus_ then
        curScene:dealCardPower()
    end
end

return CardPowerPopup