local UserInfoPopup = class("UserInfoPopup", tx.ui.Panel)

local UserInfoPopupController   = import(".UserInfoPopupController")
local UserBoardRecordView       = import(".UserBoardRecordView")
local StorePopup                = import("app.module.store.StoreView")
local UpgradePopup              = import("app.module.upgrade.UpgradePopup")
local LoadGiftControl           = import("app.module.gift.LoadGiftControl")
local GiftShopPopup             = import("app.module.gift.GiftShopPopup")
local SimpleAvatar              = import("openpoker.ui.SimpleAvatar")
local AnimationIcon             = import("openpoker.ui.AnimationIcon")
local HelpPopup                 = import("app.module.help.HelpPopup")
local DailyTasksPopup           = import("app.module.dailytasks.DailyTasksPopup")
local ExchangeCodePopup         = import("app.module.exchangecode.ExchangeCodePopup")
local GameRecordPopup           = import("app.module.gamerecord.GameRecordPopup")
local PackagePopup              = import(".PackagePopup")
local SafePopup                 = import("app.module.vip.safe.SafePopup")
local InputPasswordPopup        = import("app.module.vip.safe.InputPasswordPopup")
local VipAvatarPopup            = import("app.module.vip.VipAvatarPopup")
local ChooseCountryPopup        = import("app.module.userInfo.ChooseCountryPopup")

local WIDTH, HEIGHT = 1020, 660
local AVATAR_SIZE = 182
local TEXT_COLOR = styles.FONT_COLOR.CONTENT_TEXT

function UserInfoPopup:ctor(ctx,isRedblack)
    UserInfoPopup.super.ctor(self, {WIDTH, HEIGHT})

    self.editNick_ = tx.userData and tx.userData.nick

    self.countryId_ = tx.userData and tx.userData.countryId

    self.isRedblack = isRedblack

    self.noCheckLineStr_ = sa.LangUtil.getText("USERINFO", "NO_CHECK_LINE")

    self.ctx_ = ctx
    self.controller_ = UserInfoPopupController.new(self)

    self:addCloseBtn()

    self:addAvatarNode_()

    self:addUserInfo_()

    self:addBottomNode_()

    self:addPropertyObservers_()

    self.controller_:getBoardRecord(tx.userData.uid)
end

--添加头像结点
function UserInfoPopup:addAvatarNode_()
    local bg = self.background_
    local avatar_x, avatar_y = 155, HEIGHT - 135
    self.avatarNode_ = display.newNode()
        :size(AVATAR_SIZE, AVATAR_SIZE)
        :align(display.CENTER, avatar_x, avatar_y)
        :pos(avatar_x, avatar_y)
        :addTo(bg)

    self.avatarIcon_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :pos(AVATAR_SIZE/2, AVATAR_SIZE/2)
        :addTo(self.avatarNode_)
    NormalButton(self.avatarIcon_):onButtonClicked(buttontHandler(self, self.onUploadPicClicked_))

    local cameraImage = cc.ui.UIPushButton.new({normal = "#common/userinfo_camera_btn_normal.png", pressed = "#common/userinfo_camera_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onUploadPicClicked_))
        :pos(AVATAR_SIZE - 35, 28)
        :addTo(self.avatarNode_)

    self.giftImage_ = AnimationIcon.new("#common/userinfo_gift_btn_normal.png", 0.6, 0.5, buttontHandler(self, self.onGiftClicked_))
        :pos(10, 132)
        :addTo(self.avatarNode_, 99)

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:start("analytics.UmengAnalytics")
    end

    local userData = tx.userData

    if not userData.canEditAvatar or not userData.userUploadIconUrl then
        cameraImage:hide()
    end

    -- 礼物
    if tx.config.GIFT_SHOP_ENABLED then
        if self.giftUrlReqId_ then
            LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
        end

        self.giftUrlReqId_ = LoadGiftControl:getInstance():getGiftUrlById(tx.userData.user_gift, function(url)
            self.giftUrlReqId_ = nil
            if url and string.len(url) > 5 then
                self.giftImage_:onData(url, AnimationIcon.MAX_GIFT_DW, AnimationIcon.MAX_GIFT_DH)
            end
        end)
    end

    ui.newTTFLabel({text = "ID:".. tx.userData.uid , color = TEXT_COLOR, size = 26})
        :pos(AVATAR_SIZE/2, -25)
        :addTo(self.avatarNode_)
end

--添加名字，现金币等用户信息
function UserInfoPopup:addUserInfo_() 
    self:addVipInfo_()

    self:addNameInfo_()

    self:addCountryInfo_()

    self:addLineInfo_()

    self:addPropertyInfo_()

    self:addLevelInfo_()
end

function UserInfoPopup:addVipInfo_()
    local bg = self.background_

    local vipinfo = tx.userData.vipinfo
    local img = ""
    local icon_y = 0
    if vipinfo.level > 0 then
        img = "#common/vip_level_icon_" .. vipinfo.level .. ".png"
        icon_y = 395
    else
        img = "#common/vip_level_icon_0.png"
        icon_y = 390
    end

    cc.ui.UIPushButton.new(img)
        :onButtonClicked(buttontHandler(self, self.onVipClicked_))
        :align(display.BOTTOM_CENTER, 68, icon_y)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/safe_btn_normal.png", pressed = "#common/safe_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onSafeClicked_))
        :pos(WIDTH - 100, 450)
        :addTo(bg)
end

--添加姓名节点
function UserInfoPopup:addNameInfo_()
    local bg = self.background_
    local x, y = 300, HEIGHT - 70
    self.genderIcon_ = display.newSprite("#common/common_sex_male.png")
        :pos(x, y)
        :addTo(bg)

    -- 昵称标签
    local nick_x = x + 30
    local editbox_w = 240
    self.nickLabel_ = ui.newTTFLabel({text = "", size = 26})
        :align(display.LEFT_CENTER, nick_x, y)
        :addTo(bg)

    if tx.userData.canEditAvatar then
        sa.TouchHelper.new(self.genderIcon_, handler(self, self.onGenderIconClick_))

        local nickEdit = ui.newEditBox({image = "#common/transparent.png", listener = handler(self, self.onNickEdit_), size = cc.size(editbox_w, 40)})
            :align(display.LEFT_CENTER, nick_x, y)
            :addTo(bg)
        nickEdit:setFont(ui.DEFAULT_TTF_FONT, 26)
        nickEdit:setPlaceholderFont(ui.DEFAULT_TTF_FONT, 26)
        nickEdit:setMaxLength(25)
        nickEdit:setPlaceholderFontColor(cc.c3b(0xEE, 0xEE, 0xEE))
        nickEdit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        nickEdit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        nickEdit:setCascadeOpacityEnabled(true)
        nickEdit:setOpacity(0)

        display.newSprite("#common/btn_editbox_normal.png")
            :align(display.RIGHT_CENTER, nick_x + editbox_w, y)
            :addTo(bg)
    elseif tx.userData.canEditGender then
        sa.TouchHelper.new(self.genderIcon_, handler(self, self.onGenderIconClick_))
    end
end

--添加国籍
function UserInfoPopup:addCountryInfo_()
    local bg = self.background_
    local x, y = 300, HEIGHT - 120
    self.countryIcon_ = display.newSprite("#country_" .. self.countryId_ .. ".png")
        :scale(0.75)
        :pos(x, y)
        :addTo(bg)

    local country_x = x + 30
    local name = tx.getCountryNameById(self.countryId_)
    self.countryLabel_ = ui.newTTFLabel({text = name, size = 26})
        :align(display.LEFT_CENTER, country_x, y)
        :addTo(bg)
    sa.fitSprteWidth(self.countryLabel_, 180)

    cc.ui.UIPushButton.new("#common/transparent.png", {scale9=true})
        :setButtonSize(230, 40)
        :onButtonClicked(buttontHandler(self, self.onChooseCountryClicked_))
        :pos(x + 135, y)
        :addTo(bg)

    display.newSprite("#common/btn_editbox_normal.png")
        :align(display.RIGHT_CENTER, country_x + 240, y)
        :addTo(bg)
end

--添加line节点
function UserInfoPopup:addLineInfo_()
    local bg = self.background_
    local x, y = 652, HEIGHT - 120
    local lineIcon = display.newSprite("#common/common_line_icon.png")
        :pos(x, y)
        :addTo(bg)

    local line_x = x + 30
    self.lineLabel_ = ui.newTTFLabel({text = "", size = 20})
        :align(display.LEFT_CENTER, line_x, y)
        :addTo(bg)

    if tonumber(tx.userData.line) == 0 then
        sa.DisplayUtil.setGray(lineIcon)
        local lineStr = self.noCheckLineStr_
        if tx.userData.lineaccount and tx.userData.lineaccount ~= "" then
            lineStr = tx.userData.lineaccount
        end

        self.lineLabel_:setString(lineStr)
        local size = self.lineLabel_:getContentSize()
        local editbox_w = size.width + 50

        self.lineEdit_ = ui.newEditBox({image = "#common/transparent.png", listener = handler(self, self.onLineEdit_), size = cc.size(editbox_w, 40)})
            :align(display.LEFT_CENTER, line_x, y)
            :addTo(bg)
        self.lineEdit_:setFont(ui.DEFAULT_TTF_FONT, 26)
        self.lineEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, 26)
        self.lineEdit_:setMaxLength(15)
        self.lineEdit_:setAnchorPoint(cc.p(0, 0.5))
        self.lineEdit_:setPlaceholderFontColor(cc.c3b(0xEE, 0xEE, 0xEE))
        self.lineEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.lineEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        self.lineEdit_:setCascadeOpacityEnabled(true)
        self.lineEdit_:setOpacity(0)

        self.editIcon_ = display.newSprite("#common/btn_editbox_normal.png")
            :align(display.RIGHT_CENTER, line_x + editbox_w + 5, y)
            :addTo(bg)
    else
        self.lineLabel_:setString(tx.userData.lineaccount)
    end
end

--添加资产节点
function UserInfoPopup:addPropertyInfo_()
    local bg = self.background_
    local x, y = 300, HEIGHT - 180
    display.newSprite("#common/common_chip_icon.png")
        :pos(x, y)
        :addTo(bg)

    self.chip_ = ui.newTTFLabel({text = sa.formatNumberWithSplit(tx.userData.money), color = styles.FONT_COLOR.CHIP_TEXT, size = 26})
        :align(display.LEFT_CENTER, x + 30, y)
        :addTo(bg)

    x = 650
    display.newSprite("#common/common_diamond_icon.png")
        :pos(x, y)
        :addTo(bg)  

    self.diamondLabel_ = ui.newTTFLabel({text = sa.formatNumberWithSplit(tx.userData.diamonds), color = styles.FONT_COLOR.DIAMOND, size = 26})
        :align(display.LEFT_CENTER, x + 30, y)
        :addTo(bg)
end

-- 添加等级节点
function UserInfoPopup:addLevelInfo_()
    local bg = self.background_
    local x, y = 300, HEIGHT - 240

    local icon = display.newSprite("#common/common_level_icon.png")
        :pos(x, y)
        :addTo(bg)
    local size = icon:getContentSize()

    x = x + 30
    self.level_ = ui.newTTFLabel({text = tx.userData.level, color = TEXT_COLOR, size = 24})
        :align(display.LEFT_CENTER, x, y)
        :addTo(bg)

    size = self.level_:getContentSize()

    -- 经验值条
    local bg_w, bg_h = 390, 22
    x = x + size.width + 5
    self.expProgBar_ = tx.ui.ProgressBar.new(
            "#common/common_progress_bg.png",
            "#common/common_progress.png",
            {
                bgWidth = bg_w,
                bgHeight = bg_h,
                fillWidth = 26,
                fillHeight = 20
            }
        )
        :pos(x, y)
        :setZeroState(true)
        :setValue(tx.Level:getLevelUpProgress(tx.userData.exp))
        :addTo(bg)

    local ratio, progress, all = tx.Level:getLevelUpProgress(tx.userData.exp)

    -- 经验值标签
    self.experience_ = ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "EXPERIENCE_VALUE", progress, all), size = 14})
        :pos(bg_w/2, 0)
        :addTo(self.expProgBar_)

    --升级领取奖励按钮
    self.upgradeBtn_ = cc.ui.UIPushButton.new({normal = "#common/user_info_upgrade_normal.png", pressed = "#common/user_info_upgrade_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onUpgradeClick_))
        :pos(x + bg_w + 35, y + 5)
        :addTo(bg)
        :hide()

    --经验帮助按钮
    self.expHelpBtn_ = cc.ui.UIPushButton.new({normal = "#common/userinfo_mark_help_btn_normal.png", pressed = "#common/userinfo_mark_help_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onLevelHelpClick_))
        :pos(x + bg_w + 35, y)
        :addTo(bg)
        
    display.newScale9Sprite("#common/transparent.png", 0, 0, cc.size(45, 45)):addTo(self.expHelpBtn_)

    if tx.userData.nextRewardLevel and tx.userData.nextRewardLevel ~= 0 then
        self.upgradeBtn_:show()
        self.expHelpBtn_:hide()
    end
end

function UserInfoPopup:addUserBoardRecordView(data)
    UserBoardRecordView.new(data, self)
        :pos(WIDTH/2, HEIGHT/2 - 68)
        :addTo(self.background_)
    local ratio,progress,all,level = tx.Level:getLevelUpProgress(tx.userData.exp)
    self.level_:setString(level)
    self.expProgBar_:setValue(ratio)
    self.experience_:setString(sa.LangUtil.getText("USERINFO", "EXPERIENCE_VALUE", progress, all))
end

function UserInfoPopup:addBottomNode_()
    local bg = self.background_
    local btn_x, btn_y = WIDTH - 153, 86
    local btn_w, btn_h = 250, 104
    local icon_x, icon_y = -65, 0
    local label_off_x = 30
    local dir = 240

    local btn = self:addIconButton_(
        "#common/real_store_icon_selected.png",
        sa.LangUtil.getText("USERINFO", "REAL_STORE"),
        btn_x, btn_y, buttontHandler(self, self.onRealStoreClicked_))
    if tx.OnOff:check("switch_real_store") then
        btn:show()
        btn_x = btn_x - dir  -- 显示的距离
    else
        dir = dir + dir*0.5  -- 隐藏的距离
        btn:hide()
    end

    self:addIconButton_(
        "#common/userinfo_package_icon.png",
        sa.LangUtil.getText("USERINFO", "MY_PACK"),
        btn_x, btn_y, buttontHandler(self, self.onMyPackClicked_))

    if tx.config.SHOW_SHARE==1 then
        btn_x = btn_x - dir
        self:addIconButton_(
            "#common/userinfo_code_icon.png",
            sa.LangUtil.getText("ECODE", "MY_CODE"),
            btn_x, btn_y, buttontHandler(self, self.onExchangeClicked_))
    end

    local label = ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "ACHIEVEMENT_TITLE"), size = 24})
    sa.fitSprteWidth(label, 140)
    local btn = cc.ui.UIPushButton.new({normal = "#common/userinfo_achieve_btn_normal.png", pressed = "#common/userinfo_achieve_btn_pressed.png"}, {scale9 = true})
        :setButtonSize(230, 86)
        :onButtonClicked(handler(self, self.onAchieveClicked_))
        :setButtonLabel(label)
        :setButtonLabelOffset(25, 0)
        :align(display.LEFT_CENTER, 36, 82)
        :addTo(bg)

    local icon = display.newSprite("#common/userinfo_achieve_icon.png")
        :pos(86, 82)
        :addTo(bg)
    if tx.config.SHOW_SHARE~=1 then
        btn:setPositionX(36+450)
        icon:setPositionX(86+450)
    end
end

function UserInfoPopup:addIconButton_(icon, title, x, y, callback)
    local label = ui.newTTFLabel({text = title, size = 24, align = ui.TEXT_ALIGN_CENTER})
    sa.fitSprteWidth(label, 150)
    local btn = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png"}, {scale9 = true})
        :setButtonSize(250, 104)
        :onButtonClicked(callback)
        :setButtonLabel(label)
        :setButtonLabelOffset(25, 0)
        :pos(x, y)
        :addTo(self.background_)

    display.newSprite(icon)
        :pos(-70, 0)
        :addTo(btn)
    return btn
end

function UserInfoPopup:setNickString_(name)
    self.nickLabel_:show()
    self.nickLabel_:setString(tx.Native:getFixedWidthText("", 26, name or "", 190))
end

function UserInfoPopup:addPropertyObservers_()
    self.nickObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "nick", function (nick)
        self.editNick_ = nick
        self:setNickString_(nick)
    end)

    self.sexObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "sex", function (sex)
        if sex == "f" then
            self.selectedGender_ = "f"
            self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
        else
            self.selectedGender_ = "m"
            self.genderIcon_:setSpriteFrame("common/common_sex_male.png")
        end
    end)

    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", function (money)
        if not money then return end
        if self.chip_ then
            self.chip_:setString(sa.formatNumberWithSplit(money))
        end
    end)

    self.expObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "exp", function (exp)
        if not exp then return end
        local ratio, progress, all, lv = tx.Level:getLevelUpProgress(exp)
        if self.expProgBar_ then
            self.expProgBar_:setValue(ratio)
        end

        if self.experience_ then
            self.experience_:setString(sa.LangUtil.getText("USERINFO","EXPERIENCE_VALUE",progress,all))
        end
        if self.level_ then
            self.level_:setString(lv)
        end
    end)

    self.avatarUrlObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "s_picture", function (s_picture)
        if tx.userData.sex == "f" then
            self.avatarIcon_:setSpriteFrame("common/icon_female.png")
        else
            self.avatarIcon_:setSpriteFrame("common/icon_male.png")
        end
        if s_picture and string.len(s_picture) > 5 then
            local imgurl = s_picture
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.avatarIcon_:loadImage(imgurl)
        end
    end)

    self.diamondsId_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "diamonds", handler(self, function (obj, diamonds)
        obj.diamondLabel_:setString(sa.formatNumberWithSplit(tx.userData.diamonds))
    end))

    self.nextRewardLevelHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "nextRewardLevel", function (level)
        if level and level ~= 0 then
            self.upgradeBtn_:show()
            self.expHelpBtn_:hide()
        else
            self.upgradeBtn_:hide()
            self.expHelpBtn_:show()
        end
    end)

    if tx.config.GIFT_SHOP_ENABLED then
        self.giftImageHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "user_gift", function ()
            if self.giftUrlReqId_ then
                LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
            end

            self.giftUrlReqId_ = LoadGiftControl:getInstance():getGiftUrlById(tx.userData.user_gift, function(url)
                self.giftUrlReqId_ = nil
                if url and string.len(url) > 5 then
                    self.giftImage_:onData(url, AnimationIcon.MAX_GIFT_DW, AnimationIcon.MAX_GIFT_DH)
                end
            end)
        end)
    end

    self.updateCountryId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_COUNTRY, handler(self, self.updateCountry_))
end

function UserInfoPopup:removePropertyObservers_()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "nick", self.nickObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "sex", self.sexObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "s_picture", self.avatarUrlObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "exp", self.expObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "nextRewardLevel", self.nextRewardLevelHandle_)
    if tx.config.GIFT_SHOP_ENABLED then
        sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "user_gift", self.giftImageHandle_)
    end
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "diamonds", self.diamondsId_)

    sa.EventCenter:removeEventListener(self.updateCountryId_)
end

function UserInfoPopup:onNickEdit_(event, editbox)
    if event == "began" then
        local text = self.nickLabel_:getString()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        editbox:setText(text)
        if device.platform == "ios" then
            self.nickLabel_:hide()
        end
    elseif event == "changed" then
    elseif event == "ended" then
    elseif event == "return" then
        local text = editbox:getText()
        local filteredText = tx.keyWordFilter(text)
        self.editNick_ = string.trim(filteredText)
        if self.editNick_ == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "NICK_NO_EMPTY"))
            self.editNick_ = self.nickLabel_:getString()
        end
        self:setNickString_(self.editNick_)
    end
end

function UserInfoPopup:onLineEdit_(event, editbox)
    if event == "began" then
        if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand {
                command = "event",
                args = {eventId = "hall_line_click", label = "hall_line_click"}
            }
        end

        local text = self.lineLabel_:getString()
        if text == self.noCheckLineStr_ then
            text = ""
        end
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        editbox:setText(text)
        if device.platform == "ios" then
            self.lineLabel_:hide()
        end
    elseif event == "changed" then
    elseif event == "ended" then
    elseif event == "return" then
        local text = editbox:getText()
        local filteredText = tx.keyWordFilter(text)
        filteredText = string.trim(filteredText)
        self:onLineEditCallback_(filteredText)
    end
end

function UserInfoPopup:onLineEditCallback_(text)
    self.lineLabel_:show()
    if string.len(text) == 0 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "LINE_CHECK_NO_EMPTY"))
    else
        local today = os.date('%Y%m%d')
        local key = "CHECK_LINE" .. today
        local isCheck = tx.userDefault:getIntegerForKey(key, 0)
        if isCheck == 0 then
            self.lineLabel_:setString(text)
            self.controller_:checkLine(text)
            self:updateLineEditboxSize_()
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "LINE_CHECK_ONECE"))
        end
    end
end

function UserInfoPopup:updateLineEditboxSize_()
    local size = self.lineLabel_:getContentSize()
    local editbox_w = size.width + 50
    self.lineEdit_:setContentSize(cc.size(editbox_w, 40))
    local x, y = self.lineEdit_:getPosition()
    self.editIcon_:pos(x + editbox_w, y)
end

function UserInfoPopup:onLevelHelpClick_()
    HelpPopup.new({index = 3}):showPanel()
end

function UserInfoPopup:onUpgradeClick_()
    UpgradePopup.new():showPanel()
end

function UserInfoPopup:onGenderIconClick_(target, evt)
    if evt == sa.TouchHelper.CLICK then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.selectedGender_ == "f" then
            self.genderIcon_:setSpriteFrame("common/common_sex_male.png")
            self.selectedGender_ = "m"
        else
            self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
            self.selectedGender_ = "f"
        end
    end
end

function UserInfoPopup:onExchangeClicked_()
    ExchangeCodePopup.new():showPanel()
end

function UserInfoPopup:openBoardPopup()
    GameRecordPopup.new(self.isInRoom_):showPanel()
end

function UserInfoPopup:onMyPackClicked_()
    PackagePopup.new():showPanel()
end

function UserInfoPopup:onAchieveClicked_()
    DailyTasksPopup.new(2):showPanel()
end

function UserInfoPopup:onRealStoreClicked_()
    if tx.OnOff:check("switch_real_store") then
        StorePopup.new(nil, nil, 1):show()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function UserInfoPopup:onVipClicked_()
    self:hidePanel()
    tx.schedulerPool:delayCall(function ()
        tx.PayGuideManager:openStore(4)
    end, 0.05)
end

function UserInfoPopup:onChooseCountryClicked_()
    ChooseCountryPopup.new(self.countryId_):showPanel()
end

function UserInfoPopup:show(isInRoom, tableMessage)
    self.isInRoom_ = isInRoom
    tx.userData.isInRoom = isInRoom
    if self.isInRoom_ then
        self.tableAllUid = tableMessage.tableAllUid
        self.toUidArr = tableMessage.toUidArr
        self.tableNum = tableMessage.tableNum
    end

    self:showPanel_()
    tx.cacheKeyWordFile()
end

function UserInfoPopup:onUploadPicClicked_()
    VipAvatarPopup.new(self.controller_, self.isInRoom_, self.isRedblack):showPanel()
end

function UserInfoPopup:onGiftClicked_()
    if tx.config.GIFT_SHOP_ENABLED then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.isInRoom_ then
            GiftShopPopup.new(3):show(self.isInRoom_,tx.userData.uid,self.tableAllUid,self.tableNum,self.toUidArr)
        else
            GiftShopPopup.new(3):show(self.isInRoom_,tx.userData.uid)
        end
    end
end

function UserInfoPopup:onSafeClicked_()
    if tx.checkIsVip() or tx.userData.safe_money > 0 then
        if tx.userData.safe_password == 0 then
            SafePopup.new():showPanel()
        else
            InputPasswordPopup.new():showPanel()
        end
    else
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("SAFE", "VIP_TIPS_1"),
            secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
            callback = function(param)
                if param == tx.ui.Dialog.SECOND_BTN_CLICK then
                    tx.PayGuideManager:openStore(4)
                end
            end
        }):show()
    end
end

function UserInfoPopup:updateCountry_(evt)
    local data = evt.data
    self.countryId_ = data.id
    self.countryIcon_:setSpriteFrame("country_" .. data.id .. ".png")
    self.countryLabel_:setString(data.name)
    sa.fitSprteWidth(self.countryLabel_, 180)
end

function UserInfoPopup:onCleanup()
    self.controller_:dispose()
    self:removePropertyObservers_()
    
    if (self.selectedGender_ and self.selectedGender_ ~= tx.userData.sex)
        or (self.editNick_ and self.editNick_ ~= tx.userData.nick)
        or (self.countryId_ and self.countryId_ ~= tx.userData.countryId) then

        sa.HttpService.POST(
            {
                mod = "User",
                act = "modifyInfo",
                nick = self.editNick_,
                s = self.selectedGender_,
                countryId = self.countryId_,
            }
        )

        if self.selectedGender_ and self.selectedGender_ ~= tx.userData.sex then
            tx.userData.sex = self.selectedGender_
        end

        if self.editNick_ and self.editNick_ ~= tx.userData.nick then
            tx.userData.nick = self.editNick_
            if self.isInRoom_ or self.isRedblack==true then
                tx.socket.HallSocket:sendUserInfoChanged(true)
            end
        end

        if self.countryId_ and self.countryId_ ~= tx.userData.countryId then
            tx.userData.countryId = self.countryId_
        end
    end
end

return UserInfoPopup
