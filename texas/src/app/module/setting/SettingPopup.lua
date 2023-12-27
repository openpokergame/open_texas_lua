local SettingPopup = class("SettingPopup", tx.ui.Panel)
local AboutPopup   = import("app.module.about.AboutPopup")
local UpdatePopup = import(".UpdatePopup")
local LanguageSwitchView = import(".LanguageSwitchView")
local ExchangeCodePopup = import("app.module.exchangecode.ExchangeCodePopup")
local BindGuestView = import(".BindGuestView")
local BindRewardView = import(".BindRewardView")

local WIDTH, HEIGHT = 910, 690 --弹窗大小
local ITEM_W, ITEM_H = WIDTH - 92, 84 --item大小
local DIVIDER_WIDTH, DIVIDER_HEIGHT = ITEM_W - 10, 2 --分割线大小
local TITLE_X = 30 --设置名字X坐标
local TITLE_COLOR = styles.FONT_COLOR.CONTENT_TEXT --设置颜色
local LABEL_SIZE = 26 --设置名字大小
local SWITCH_X = ITEM_W - 170   --开关按钮位置

function SettingPopup:ctor(isInRoom, roomLevel)--roomLevel 1初级 2中级 3高级
    SettingPopup.super.ctor(self, {WIDTH, HEIGHT})

    self.initLang_ = appconfig.LANG
    self.roomlevel_ = roomLevel or 1
    self.isInRoom = isInRoom

    display.addSpriteFrames("setting_texture.plist", "setting_texture.png")

    self:setNodeEventEnabled(true)

    self:setTextTitleStyle(sa.LangUtil.getText("SETTING", "TITLE"))

    self:addMainUI_()

    self.changLangueId_ = sa.EventCenter:addEventListener("CHANGE_LANGUE", handler(self, self.onLangeChange_))
    self.bindGuestId_ = sa.EventCenter:addEventListener("GUEST_BIND_REWARD", handler(self, self.onBindGuestReward_))
end

function SettingPopup:onBindGuestReward_(evt)
    if self.bindBtn_ then
        self.bindBtn_:hide()
    end
end

function SettingPopup:onLangeChange_()
    self.title_:setString(sa.LangUtil.getText("SETTING", "TITLE"))
    -- 切换语言文字重合
    self.nick_:setString(sa.LangUtil.getText("SETTING", "NICK"))
    local titleSize = self.nick_:getContentSize()
    self.nickName_:setPositionX(TITLE_X + titleSize.width + 20)

    if self.logOutBtn_ then
        self.logOutBtn_:setButtonLabelString(sa.LangUtil.getText("SETTING", "LOGOUT"))
    end

    if self.bindBtn_ then
        local reward = sa.formatNumberWithSplit(tx.userData.guestBindReward)
        self.bindBtn_:setButtonLabelString(sa.LangUtil.getText("BIND", "BTN_TITLE", reward))
    end

    self.language_:setString(sa.LangUtil.getText("SETTING", "LANGUAGE"))
    -- self.exchange_:setString(sa.LangUtil.getText("SETTING", "EXCHANGE"))

    if self.pushTitle_ then
        self.pushTitle_:setString(sa.LangUtil.getText("SETTING", "PUSH_NOTIFY"))
    end

    self.sound_:setString(sa.LangUtil.getText("SETTING", "SOUND"))
    self.bg_sound_:setString(sa.LangUtil.getText("SETTING", "BG_SOUND"))
    self.chatvoice_:setString(sa.LangUtil.getText("SETTING", "CHATVOICE"))
    self.vibrate_:setString(sa.LangUtil.getText("SETTING", "VIBRATE"))
    self.auto_sit_:setString(sa.LangUtil.getText("SETTING", "AUTO_SIT"))
    self.auto_buyin_1:setString(sa.LangUtil.getText("SETTING", "AUTO_BUYIN"))
    self.auto_buyin_2:setString(sa.LangUtil.getText("ROOM", "BUY_IN_AUTO_MIN"))

    if self.card_power_ then
        self.card_power_:setString(sa.LangUtil.getText("SETTING", "CARD_POWER"))
    end

    self.app_store_grade_:setString(sa.LangUtil.getText("SETTING", "APP_STORE_GRADE"))
    self.check_version_:setString(sa.LangUtil.getText("SETTING", "CHECK_VERSION"))
    local currentVersion = tx.Native:getAppVersion()
    self.current_version_:setString(sa.LangUtil.getText("SETTING", "CURRENT_VERSION", SA_UPDATE and SA_UPDATE.VERSION or currentVersion))
    self.about_:setString(sa.LangUtil.getText("SETTING", "ABOUT"))
    self.policies_:setString(sa.LangUtil.getText("ABOUT", "SERVICE"))

    if self.tutorialLabel_ then
        self.tutorialLabel_:setString(sa.LangUtil.getText("TUTORIAL", "SETTING_TITLE"))
    end
end

function SettingPopup:addMainUI_()
    local posY = 0
    local dir = 15
    local scrollContent = display.newNode() 
    self.container_ = display.newNode():addTo(scrollContent)

    --添加登出，语言设置，邀请码
    posY = posY - ITEM_H * 2 - 10
    self:addLoginOutNode_(posY, 2)

    --推送开关
    local isEnabled = tx.Native:checkPushEnabled()
    if not isEnabled then
        posY = posY - ITEM_H - dir
        self:addPushNode_(posY, 1)
    end

    --添加声音设置
    posY = posY - ITEM_H * 4 - dir
    self:addSoundNode_(posY, 4)
    
    --自动坐下以及自动买入，牌力指示器
    posY = posY - ITEM_H * 4  - dir
    self:addAutoBtn_(posY, 4)
    
    --其他内容
    if self.isInRoom then
        posY = posY - ITEM_H * 4  - dir
        self:addOtherNode_(posY, 4)
    else
        posY = posY - ITEM_H * 5  - dir
        self:addOtherNode_(posY, 5)
    end

    local list_w, list_h = ITEM_W + 10, 500
    self.scrollView_ = sa.ui.ScrollView.new({viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h), scrollContent = scrollContent})
        :pos(WIDTH/2, HEIGHT/2 - 45)
        :addTo(self.background_)

    local size = self.container_:getCascadeBoundingBox()
    self.container_:pos(0, size.height/2)
end

--添加名字和登出
function SettingPopup:addLoginOutNode_(y, num)
    local container = self.container_
    local bg_h = ITEM_H * num + 10
    local bg = display.newNode()
        :size(ITEM_W, bg_h)
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(container)

    display.newScale9Sprite("#common/setting_frame.png", ITEM_W/2, bg_h*0.5, cc.size(ITEM_W, bg_h))
        :addTo(bg)

    --分割线
    for i = 1, num - 1 do
        display.newScale9Sprite("#common/setting_item_line.png", ITEM_W/2, ITEM_H * i, cc.size(DIVIDER_WIDTH, DIVIDER_HEIGHT))
            :addTo(bg)
    end

    --昵称
    local posY = bg_h - ITEM_H * 0.5
    self.nick_ = ui.newTTFLabel({
            text = sa.LangUtil.getText("SETTING", "NICK"),
            size = LABEL_SIZE,
            color = TITLE_COLOR,
            align = ui.TEXT_ALIGN_CENTER
        })
        :align(display.LEFT_CENTER, TITLE_X, posY)
        :addTo(bg)

    local titleSize = self.nick_:getContentSize()

    local dir = 20
    self.nickName_ = ui.newTTFLabel({
            text = tx.userData.nick, 
            size = LABEL_SIZE, 
            color = labelTitleColor,
        })
        :align(display.LEFT_CENTER, TITLE_X + titleSize.width + dir, posY)
        :addTo(bg)

    --登出按钮
    local btn_w, btn_h = 288, 104
    local btn_x, btn_y = ITEM_W - 90, posY 
    if not self.isInRoom then
        -- -- guest模式下显示 facebook引导
        -- local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
        -- if lastLoginType == "GUEST" then
        --     local btn = sp.SkeletonAnimation:create("spine/denglu.json","spine/denglu.atlas")
        --         :scale(0.6)
        --         :size(420, 120)
        --         :align(display.CENTER, btn_x, btn_y - 5)
        --         :addTo(bg)
        --     btn:setAnimation(0, "3", true)
        --     ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onFbGuideClicked_))
        --     btn:setTouchSwallowEnabled(false)
        -- else
            self.logOutBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png"}, {scale9 = true})
                :setButtonSize(200, btn_h)
                :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("SETTING", "LOGOUT"), size = 24, color = cc.c3b(0xc7, 0xe5, 0xff)}))
                :pos(btn_x, btn_y)
                :onButtonClicked(buttontHandler(self, self.onLogoutClicked_))
                :addTo(bg)
            self.logOutBtn_:setTouchSwallowEnabled(false)
        -- end
        if tx.getBindGuestStatus() > 0 then
            local reward = sa.formatNumberWithSplit(tx.userData.guestBindReward)
            self.bindBtn_ = nil
            self.bindBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png"}, {scale9 = true})
                :setButtonSize(320, btn_h)
                :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("BIND", "BTN_TITLE", reward), size = 22}))
                :pos(btn_x-250, btn_y)
                :onButtonClicked(buttontHandler(self, function()
                    if tx.getBindGuestStatus() == 1 then
                        BindGuestView.new():showPanel()
                    elseif tx.getBindGuestStatus() == 2 then
                        BindRewardView.new():showPanel()
                    end
                end))
                :addTo(bg)
            self.bindBtn_:setTouchSwallowEnabled(false)
        end
    else
        self.nickName_:align(display.RIGHT_CENTER, ITEM_W - 40, posY)
    end

    --设置语言
    posY = posY - ITEM_H - 10
    self.language_ = ui.newTTFLabel({text = sa.LangUtil.getText("SETTING", "LANGUAGE"), size = LABEL_SIZE, color = TITLE_COLOR})
        :align(display.LEFT_CENTER, TITLE_X, posY)
        :addTo(bg)

    local xx = ITEM_W*0.5 - 146
    if self.isInRoom then
        xx = ITEM_W*0.5 - 80
    end

    -- listView 添加入scale9的bug
    local node = display.newNode()
        :align(display.BOTTOM_CENTER)
        :pos(xx, y + ITEM_H*0.5)
        :addTo(self.container_, 2)
    self.languageView_ = LanguageSwitchView.new(self.isInRoom)
        :addTo(node)

    -- --兑换码
    -- posY = posY - ITEM_H
    -- self.exchange_ = self:createItemButton_(bg, sa.LangUtil.getText("SETTING", "EXCHANGE"), posY, buttontHandler(self, self.onExchangeClicked_))
end

function SettingPopup:addPushNode_(y, num)
    local container = self.container_
    local bg_h = ITEM_H * num
    local bg = display.newNode()
        :size(ITEM_W, bg_h)
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(container)

    display.newScale9Sprite("#common/setting_frame.png", ITEM_W/2, bg_h*0.5, cc.size(ITEM_W, bg_h))
        :addTo(bg)

    local posY = bg_h - ITEM_H * 0.5
    self.pushTitle_ = ui.newTTFLabel({text = sa.LangUtil.getText("SETTING", "PUSH_NOTIFY"), size = LABEL_SIZE, color = TITLE_COLOR})
        :align(display.LEFT_CENTER, TITLE_X, posY)
        :addTo(bg)

    local btn = cc.ui.UIPushButton.new({normal = "#common/setting_checkbox_off.png", pressed = "#common/setting_checkbox_off.png"})
        :onButtonClicked(handler(self, self.onOpenPushClicked_))
        :align(display.LEFT_CENTER, SWITCH_X, posY)
        :addTo(bg)
    btn:setTouchSwallowEnabled(false)
end

--添加声音设置
function SettingPopup:addSoundNode_(y, num)
    local container = self.container_
    local bg_h = ITEM_H * num
    local bg = display.newNode()
        :size(ITEM_W, bg_h)
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(container)

    display.newScale9Sprite("#common/setting_frame.png", ITEM_W/2, bg_h*0.5, cc.size(ITEM_W, bg_h))
        :addTo(bg)

    --分割线
    for i = 1, num - 1 do
        display.newScale9Sprite("#common/setting_item_line.png", ITEM_W/2, ITEM_H * i, cc.size(DIVIDER_WIDTH, DIVIDER_HEIGHT))
            :addTo(bg)
    end

    local posY = bg_h - ITEM_H * 0.5

    --声音调节
    self.sound_ = ui.newTTFLabel({text = sa.LangUtil.getText("SETTING", "SOUND"), size = LABEL_SIZE, color = TITLE_COLOR})
        :align(display.LEFT_CENTER, TITLE_X, posY)
        :addTo(bg)
    local progressWidth, progressHeight = 496, 19
    local soundPosX = ITEM_W - progressWidth - 75
    self.soundProgress_ = tx.ui.ProgressBar.new(
            "#dialogs/setting/setting_progress_bg.png", 
            "#dialogs/setting/setting_progress_bar.png", 
            {
                bgWidth = progressWidth, 
                bgHeight = 16, 
                fillWidth = 30, 
                fillHeight = 14
            }
        )
        :setValue(0)
        :pos(soundPosX, posY)
        :addTo(bg)

    local soundSlider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, {bar = "#common/transparent.png", button = "#dialogs/setting/setting_slider_btn.png"}, {scale9 = true})
        :setSliderSize(progressWidth, progressHeight)
        :onSliderValueChanged(handler(self, self.soundValueChangeListener))
        :onSliderRelease(handler(self, self.soundValueUpdate_))
        :align(display.LEFT_CENTER, soundPosX, posY)
        :addTo(bg)
    soundSlider:setTouchSwallowEnabled(false)
        
    local volume = tx.userDefault:getIntegerForKey(tx.cookieKeys.VOLUME, 100)
    soundSlider:setSliderValue(volume)

    --静音按钮
    local minBtn = cc.ui.UIPushButton.new({normal = "#dialogs/setting/min_sound_btn.png", pressed = "#dialogs/setting/min_sound_btn_down.png"})
        :pos(soundPosX - 35, posY)
        :onButtonPressed(function(evt)
            evt.target:setColor(cc.c3b(0x0, 0xff, 0xff))
        end)
        :onButtonRelease(function(evt)
            evt.target:setColor(cc.c3b(0xff, 0xff, 0xff))
        end)
        :onButtonClicked(function(evt)
            soundSlider:setSliderValue(0)
            self:soundValueUpdate_()
        end)
        :addTo(bg)
    minBtn:setTouchSwallowEnabled(false)

    --最大音量按钮
    local maxBtn = cc.ui.UIPushButton.new({normal = "#dialogs/setting/max_sound_btn.png", pressed = "#dialogs/setting/max_sound_btn_down.png"})
        :pos(ITEM_W - 40, posY)
        :onButtonPressed(function(evt)
            evt.target:setColor(cc.c3b(0x0, 0xff, 0xff))
        end)
        :onButtonRelease(function(evt)
            evt.target:setColor(cc.c3b(0xff, 0xff, 0xff))
        end)
        :onButtonClicked(function ()
            soundSlider:setSliderValue(100)
            self:soundValueUpdate_()
        end)
        :addTo(bg)
    maxBtn:setTouchSwallowEnabled(false)

    --背景音效
    posY = posY - ITEM_H
    local isBgSound = tx.userDefault:getBoolForKey(tx.cookieKeys.BG_SOUND, true)
    self.isBgSound_ = isBgSound
    self.isBgSound1_ = isBgSound
    self.bg_sound_ = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "BG_SOUND"), posY, handler(self, self.bgSoundChangeListener), isBgSound) 
        
    --聊天音效
    posY = posY - ITEM_H
    local isChatVoice = tx.userDefault:getBoolForKey(tx.cookieKeys.CHATVOICE, true)
    self.isChatVoice_ = isChatVoice
    self.isChatVoice1_ = isChatVoice
    self.chatvoice_ = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "CHATVOICE"), posY, handler(self, self.chatVoiceChangeListener), isChatVoice)  
        
    --震动
    posY = posY - ITEM_H
    local isShock = tx.userDefault:getBoolForKey(tx.cookieKeys.SHOCK, false)
    self.vibrate_ = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "VIBRATE"), posY, handler(self, self.vibrateChangeListener), isShock)  
end

--自动坐下以及自动买入
function SettingPopup:addAutoBtn_(y, num)
    local container = self.container_
    local bg_h = ITEM_H * num
    local bg = display.newNode()
        :size(ITEM_W, bg_h)
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(container)

    display.newScale9Sprite("#common/setting_frame.png", ITEM_W/2, bg_h*0.5, cc.size(ITEM_W, bg_h))
        :addTo(bg)

    --分割线
    for i = 1, num - 1 do
        display.newScale9Sprite("#common/setting_item_line.png", ITEM_W/2, ITEM_H * i, cc.size(DIVIDER_WIDTH, DIVIDER_HEIGHT))
            :addTo(bg)
    end

    --自动坐下
    local posY = bg_h - ITEM_H * 0.5
    local isAutoSit = tx.userDefault:getBoolForKey(tx.cookieKeys.AUTO_SIT, true)
    self.auto_sit_ = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "AUTO_SIT"), posY, handler(self, self.autoSitChangeListener), isAutoSit) 
        
    --自动买入
    posY = posY - ITEM_H
    local isBuyin = tx.userDefault:getStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
    local buyIn1_ = false
    if isBuyin=="true" or isBuyin=="1" then
        buyIn1_ = true
    end
    self.auto_buyin_1,self.auto_buyin_btn_1 = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "AUTO_BUYIN"), posY, handler(self, self.autoBuyinChangeListener), buyIn1_)
    --最小筹码带入
    posY = posY - ITEM_H
    local buyIn2_ = false
    if isBuyin=="2" then
        buyIn2_ = true
    end
    self.auto_buyin_2,self.auto_buyin_btn_2 = self:createSwitchNode_(bg, sa.LangUtil.getText("ROOM", "BUY_IN_AUTO_MIN"), posY, handler(self, self.autoBuyinChangeListener2), buyIn2_)

    --牌力指示器
    posY = posY - ITEM_H
    local isCardPowerTips = tx.userDefault:getBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, true)
    self.openCardPowerStatus_ = isCardPowerTips
    self.card_power_ = self:createSwitchNode_(bg, sa.LangUtil.getText("SETTING", "CARD_POWER"), posY, handler(self, self.cardPowerTipsChangeListener), isCardPowerTips)  
end

function SettingPopup:createSwitchNode_(parent, title, y, callback, isSelected)
    local label = ui.newTTFLabel({text = title, size = LABEL_SIZE, color = TITLE_COLOR})
        :align(display.LEFT_CENTER, TITLE_X, y)
        :addTo(parent)

    local btn = cc.ui.UICheckBoxButton.new({on = "#common/setting_checkbox_on.png", off = "#common/setting_checkbox_off.png"})
        :onButtonStateChanged(callback)
        :setButtonSelected(isSelected)
        :align(display.LEFT_CENTER, SWITCH_X, y)
        :addTo(parent)
    btn:setTouchSwallowEnabled(false)
    return label,btn
end

--其他内容
function SettingPopup:addOtherNode_(y, num)
    local container = self.container_
    local bg_h = ITEM_H * num
    local bg = display.newNode()
        :size(ITEM_W, bg_h)
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(container)

    display.newScale9Sprite("#common/setting_frame.png", ITEM_W/2, bg_h*0.5, cc.size(ITEM_W, bg_h))
        :addTo(bg)

    --分割线
    for i = 1, num - 1 do
        display.newScale9Sprite("#common/setting_item_line.png", ITEM_W/2, ITEM_H * i, cc.size(DIVIDER_WIDTH, DIVIDER_HEIGHT))
            :addTo(bg)
    end

    local posY = bg_h - ITEM_H * 0.5
    local arrowPadding = 47
    local r = -90
    local arrow_x = ITEM_W - arrowPadding
    local btn_w, btn_h = ITEM_W, ITEM_H

    if self.isInRoom then
        posY = posY - 0
    else
        -- 新手教学
        self.tutorialLabel_ = self:createItemButton_(bg, sa.LangUtil.getText("TUTORIAL", "SETTING_TITLE"), posY, buttontHandler(self, self.onTutorialClicked_))
        posY = posY - ITEM_H
    end

    --评分
    self.app_store_grade_ = self:createItemButton_(bg, sa.LangUtil.getText("SETTING", "APP_STORE_GRADE"), posY, buttontHandler(self, self.onAppStoreClicked_))

    --检测更新
    posY = posY - ITEM_H
    self.check_version_ = self:createItemButton_(bg, sa.LangUtil.getText("SETTING", "CHECK_VERSION"), posY, buttontHandler(self, self.onCheckVersionClicked_))

    local currentVersion = tx.Native:getAppVersion()
    self.current_version_ = ui.newTTFLabel({
            text = sa.LangUtil.getText("SETTING", "CURRENT_VERSION", SA_UPDATE and SA_UPDATE.VERSION or currentVersion),
            size = LABEL_SIZE,
            color = TITLE_COLOR
        })
        :align(display.RIGHT_CENTER, ITEM_W - arrowPadding - 20, posY)
        :addTo(bg)

    --关于
    posY = posY - ITEM_H
    self.about_ = self:createItemButton_(bg, sa.LangUtil.getText("SETTING", "ABOUT"), posY, buttontHandler(self, self.onAboutClicked_))

    -- 服务与条款
    posY = posY - ITEM_H
    self.policies_ = self:createItemButton_(bg, sa.LangUtil.getText("ABOUT", "SERVICE"), posY, function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        local WebDialog = require("app.pokerUI.WebDialog")
        WebDialog.new(WIDTH, HEIGHT,sa.LangUtil.getText("ABOUT", "SERVICE"),appconfig.POLICY_URL):showPanel()
    end)
end

function SettingPopup:createItemButton_(parent, title, y, callback)
    local label = ui.newTTFLabel({text = title, size = LABEL_SIZE, color = TITLE_COLOR})
        :align(display.LEFT_CENTER, TITLE_X, y)
        :addTo(parent)

    --关于箭头
    display.newSprite("#common/setting_arrow_icon.png")
        :pos(ITEM_W - 47, y)
        :rotation(-90)
        :addTo(parent)

    local btn = cc.ui.UIPushButton.new({normal = "#common/transparent.png", pressed = "#dialogs/setting/setting_item_pressed.png"}, {scale9 = true})
        :setButtonSize(ITEM_W, ITEM_H)
        :setTouchSwallowEnabled(false)
        :onButtonPressed(function(evt)
            self.btnPressedY_ = evt.y
            self.btnClickCanceled_ = false
        end)
        :onButtonRelease(function(evt)
            if math.abs(evt.y - self.btnPressedY_) > 10 then
                self.btnClickCanceled_ = true
            end
        end)
        :onButtonClicked(function(evt)
            if not self.btnClickCanceled_ and self:getParent():getParent():getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
                callback()
            end
        end) 
        :pos(ITEM_W/2, y)
        :addTo(parent)

    return label
end

-- 派发登出成功事件
function SettingPopup:onLogoutClicked_()
    self:onClose()

    sa.EventCenter:dispatchEvent(tx.eventNames.HALL_LOGOUT_SUCC)
end

function SettingPopup:onFbGuideClicked_()
    self:onClose()
    _G.isFbGuideLogin = true
    sa.EventCenter:dispatchEvent(tx.eventNames.HALL_LOGOUT_SUCC)
end

function SettingPopup:onExchangeClicked_()
    ExchangeCodePopup.new():showPanel()
end

function SettingPopup:onOpenPushClicked_()
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end

    tx.ui.Dialog.new({
        align = ui.TEXT_ALIGN_LEFT,
        messageText = sa.LangUtil.getText("SETTING", "PUSH_TIPS"),
        firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
        secondBtnText = sa.LangUtil.getText("COMMON", "CONFIRM"),
        callback = function (btnType)
            if btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
                self.appForegroundListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.APP_ENTER_FOREGROUND, handler(self, self.setPushEnabledCallback_))
                tx.Native:setPushEnabled()
            end
        end
    }):show()
end

function SettingPopup:setPushEnabledCallback_()
    if self.appForegroundListenerId_ then
        sa.EventCenter:removeEventListener(self.appForegroundListenerId_)
        self.appForegroundListenerId_ = nil
    end

    self:performWithDelay(function ()
        local isEnabled = tx.Native:checkPushEnabled()
        if isEnabled then
            self:hidePanel()
        end
    end, 0.1)
end

function SettingPopup:vibrateChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    
    if event.target:isButtonSelected() then
        self.isVibrate_ = true
        if self.canSound then
            tx.Native:vibrate(500)
        end
    else
        self.isVibrate_ = false
    end
end    

function SettingPopup:bgSoundChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    
    if event.target:isButtonSelected() then
        self.isBgSound1_ = true
    else
        self.isBgSound1_ = false
    end
    if tx.userData.inHall_ then
        tx.userDefault:setBoolForKey(tx.cookieKeys.BG_SOUND, self.isBgSound1_)
        tx.userDefault:flush()
        if self.isBgSound1_ then
            tx.SoundManager:playBgMusic()
        else
            tx.SoundManager:stopBgMusic()
        end
    end
end

function SettingPopup:chatVoiceChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    
    if event.target:isButtonSelected() then
        self.isChatVoice1_ = true
    else
        self.isChatVoice1_ = false
    end
end

function SettingPopup:autoSitChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    
    if event.target:isButtonSelected() then
        self.isAutoSit_ = true
    else
        self.isAutoSit_ = false
    end
end

function SettingPopup:autoBuyinChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    if event.target:isButtonSelected() then
        self.isAutoBuyin_1 = true
        if self.auto_buyin_btn_2 then
            self.auto_buyin_btn_2:setButtonSelected(false)
        end
    else
        self.isAutoBuyin_1 = false
    end
end

function SettingPopup:autoBuyinChangeListener2(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
    if event.target:isButtonSelected() then
        self.isAutoBuyin_2 = true
        if self.auto_buyin_btn_1 then
            self.auto_buyin_btn_1:setButtonSelected(false)
        end
    else
        self.isAutoBuyin_2 = false
    end
end

function SettingPopup:cardPowerTipsChangeListener(event)
    if self.canSound then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end

    if event.target:isButtonSelected() then
        self.isCardPowerTips_ = true
        if self.isInRoom and self.roomlevel_ > 1 and not tx.checkIsVip() then
            event.target:setButtonSelected(false)
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("VIP", "NO_VIP_TIPS"),
                secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
                callback = function(param)
                    if param == tx.ui.Dialog.SECOND_BTN_CLICK then
                        tx.PayGuideManager:openStore(4)
                        self:hidePanel()
                    end
                end
            }):show()
        end
    else
        self.isCardPowerTips_ = false
    end
end

function SettingPopup:soundValueChangeListener(event)
    self.soundProgress_:setValue(event.value/100)

    self.soundValue = event.value

    self.prevValue_ = self.curValue_
    self.curValue_ = self.soundValue
    local curTime = sa.getTime()
    local prevTime = self.lastRaiseSliderGearTickPlayTime_ or 0
    if self.prevValue_ ~= self.curValue_  and curTime - prevTime > 0.05 then
        self.lastRaiseSliderGearTickPlayTime_ = curTime
        if self.canSound then
            tx.SoundManager:playSound(tx.SoundManager.GEAR_TICK,false,self.soundValue)
        end
    end
end

function SettingPopup:soundValueUpdate_()
    if self.soundValue then
        tx.userDefault:setIntegerForKey(tx.cookieKeys.VOLUME, self.soundValue)
        tx.userDefault:flush()
        tx.SoundManager:updateVolume()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    end
end

function SettingPopup:onAppStoreClicked_()
    if tx.userData.commentUrl and #tx.userData.commentUrl>0 then
        device.openURL(tx.userData.commentUrl)
    end
end

function SettingPopup:onTutorialClicked_()
    local curScene = tx.runningScene
    if curScene and curScene.openTutorial then
        curScene:openTutorial()
        self:onClose()
    end
end

function SettingPopup:onCheckVersionClicked_()
    sa.HttpService.POST_URL(appconfig.VERSION_CHECK_URL, 
        {
            device = (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform), 
            pay = (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform), 
            osVersion = SA_UPDATE.VERSION, 
            version = SA_UPDATE.VERSION, 
            noticeVersion = "noticeVersion",
            lang = appconfig.LANG,
            sid = appconfig.SID[string.upper(device.platform)],
        }, 
        function (data)
            if data then
                local retData = json.decode(data)
                self:checkUpdate(retData.curVersion, retData.verTitle, retData.verMessage, retData.updateUrl)
            end
        end
    )
end

function SettingPopup:checkUpdate(curVersion, verTitle, verMessage, updateUrl)
    local latestVersionNum = sa.getVersionNum(curVersion)
    local installVersionNum = sa.getVersionNum(SA_UPDATE.VERSION)

    if latestVersionNum <= installVersionNum then
        tx.TopTipManager:showToast(sa.LangUtil.getText("UPDATE", "HAD_UPDATED"))
    else
        UpdatePopup.new(verTitle, verMessage, updateUrl):showPanel()
    end
end

function SettingPopup:onAboutClicked_()
    AboutPopup.new():showPanel()
end

function SettingPopup:onShowed()
    self.scrollView_:setScrollContentTouchRect()
    self.canSound = true
end

function SettingPopup:onExit()
    tx.userDefault:setBoolForKey(tx.cookieKeys.SHOCK, self.isVibrate_)
    tx.userDefault:setBoolForKey(tx.cookieKeys.AUTO_SIT, self.isAutoSit_)
    -- 自动买入
    if self.isAutoBuyin_1 then
        tx.userDefault:setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
        if self.isInRoom then
            tx.socket.HallSocket:sendGameCmd("setAutoBuy",1,0)
        end
    elseif self.isAutoBuyin_2 then
        tx.userDefault:setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "2")
        if self.isInRoom then
            tx.socket.HallSocket:sendGameCmd("setAutoBuy",1,1)
        end
    else
        tx.userDefault:setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "")
        if self.isInRoom then
            tx.socket.HallSocket:sendGameCmd("setAutoBuy",0,0)
        end
    end
    tx.userDefault:setBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, self.isCardPowerTips_)

    if self.isBgSound1_~=self.isBgSound_ then
        tx.userDefault:setBoolForKey(tx.cookieKeys.BG_SOUND, self.isBgSound1_)
    end

    if self.isChatVoice1_~=self.isChatVoice_ then
        tx.userDefault:setBoolForKey(tx.cookieKeys.CHATVOICE, self.isChatVoice1_)
    end

    tx.userDefault:flush()
    if self.isChatVoice1_~=self.isChatVoice_ then
        tx.SoundManager:updateVolume()
    end

    display.removeSpriteFramesWithFile("setting_texture.plist", "setting_texture.png")

    sa.EventCenter:removeEventListener(self.changLangueId_)
    sa.EventCenter:removeEventListener(self.bindGuestId_)

    if self.initLang_ ~= appconfig.LANG and tx.userData then
        -- 活动缓存清理
        tx.userData.activityConfig = nil
        -- 等级配置加载
        if tx.userData.levelJsonDomain then
            local params = sa.getFileNameByFilePath(tx.userData.levelJsonDomain)
            if params and params.filename then
                tx.userData.levelJsonDomain = string.gsub(tx.userData.levelJsonDomain, "/[a-zA-Z0-9]+/"..params.filename, "/"..appconfig.LANG.."/"..params.filename)
                tx.Level:loadConfig(tx.userData.levelJsonDomain)
            end
        end
        -- 礼品兑换商城礼品名字
        if tx.userData.mallGoodsNameJsonDomain then
            local params = sa.getFileNameByFilePath(tx.userData.mallGoodsNameJsonDomain)
            if params and params.filename then
                tx.userData.mallGoodsNameJsonDomain = string.gsub(tx.userData.mallGoodsNameJsonDomain, "/[a-zA-Z0-9]+/"..params.filename, "/"..appconfig.LANG.."/"..params.filename)
            end
        end
        -- 礼券名字
        if tx.userData.mallCouponNameJsonDomain then
            local params = sa.getFileNameByFilePath(tx.userData.mallCouponNameJsonDomain)
            if params and params.filename then
                tx.userData.mallCouponNameJsonDomain = string.gsub(tx.userData.mallCouponNameJsonDomain, "/[a-zA-Z0-9]+/"..params.filename, "/"..appconfig.LANG.."/"..params.filename)
            end
        end
        -- 比赛名字重新加载
        if tx.userData.sngTableConfig then
            local getMatchTitleFun = nil
            local retryTime = 3
            getMatchTitleFun = function()
                retryTime = retryTime - 1
                if tx.userData and tx.userData.sngTableConfig and retryTime>0 then
                    sa.HttpService.CANCEL(self.matchNameId_)
                    self.sngRequestId_ = sa.HttpService.POST({
                            mod = "Match",
                            act = "getMatchTitle",
                        },
                        function(data)
                            local retData = json.decode(data)
                            if retData and retData.list and type(retData.list)=="table" and tx.userData then
                                for kk,vv in pairs(retData.list) do
                                    for k,v in pairs(tx.userData.sngTableConfig) do
                                        if tonumber(v.matchlevel)==tonumber(kk) then
                                            v.name = vv
                                            break;
                                        end
                                    end
                                end
                                getMatchTitleFun = nil
                                sa.HttpService.CANCEL(self.matchNameId_)
                            else
                                getMatchTitleFun()
                            end
                        end,
                        function(data)
                            getMatchTitleFun()
                        end
                    )
                else
                    getMatchTitleFun = nil
                    sa.HttpService.CANCEL(self.matchNameId_)
                end
            end
            getMatchTitleFun()
        end
    end
    -- 牌力指示器
    if self.isInRoom then
        local curScene = tx.runningScene
        if curScene and curScene.dealCardPower and self.isCardPowerTips_~=self.openCardPowerStatus_ then
            curScene:dealCardPower()
        end
    end
end

return SettingPopup