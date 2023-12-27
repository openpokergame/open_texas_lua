--保险箱
local SafePopup = class("SafePopup", tx.ui.Panel)
local SafePopupController = import(".SafePopupController")
local SetPasswordPopup = import(".SetPasswordPopup")
local SetEmailPopup = import(".SetEmailPopup")

local WIDTH, HEIGHT = 1040, 746

SafePopup.ELEMENTS = {
    "bgTab",

    "bgMiddle.bgInput.iconMoney",
    "bgMiddle.bgInput.labelNum",
    "bgMiddle.bgInput.btnDel",

    "bgMiddle.btnNode.btn_0",
    "bgMiddle.btnNode.btn_1",
    "bgMiddle.btnNode.btn_2",
    "bgMiddle.btnNode.btn_3",
    "bgMiddle.btnNode.btn_4",
    "bgMiddle.btnNode.btn_5",
    "bgMiddle.btnNode.btn_6",
    "bgMiddle.btnNode.btn_7",
    "bgMiddle.btnNode.btn_8",
    "bgMiddle.btnNode.btn_9",

    "bgMiddle.btnSaveMoney.label",
    "bgMiddle.btnGetMoney.label",
    "bgMiddle.btnPwd.label",

    "bgMiddle.labelTips",

    "safeNode.labelTitle",
    "safeNode.iconChip",
    "safeNode.labelChips",
    "safeNode.iconDiamond",
    "safeNode.labelDiamonds",

    "purseNode.labelTitle",
    "purseNode.iconChip",
    "purseNode.labelChips",
    "purseNode.iconDiamond",
    "purseNode.labelDiamonds",
}

local ICON_IMG = {
    "common/common_chip_icon.png", 
    "common/common_diamond_icon.png", 
}

local SELECTED_COLOR = styles.FONT_COLOR.LIGHT_TEXT
local UNSELECTED_COLOR = styles.FONT_COLOR.GREY_TEXT

local TAB_CHIPS     = 1  --筹码
local TAB_DIAMONDS  = 2  --钻石

local MAX_LEN = 9

local userData

function SafePopup:ctor()
	SafePopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("SAFE", "TITLE"))

    self.controller_ = SafePopupController.new(self)

    self.selected_ = TAB_CHIPS
    userData = tx.userData
    self.curNumStr_ = "0" --当前输入的值
    self.curSafeMoney_ = userData.safe_money --选中货币类型，存在保险箱里的钱
    self.curMoney_ = userData.money --选中货币类型，身上携带的钱

    self:initViews_()

    self:addPropertyObservers_()
end

function SafePopup:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self, "dialog_safe.csb", true)

    local size = self.bgTab:getContentSize()
    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("SAFE", "TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 24},
            defaltText = {color = styles.FONT_COLOR.SUB_TAB_OFF, size = 24}
        },
        true, true)
        :setTabBarSize(size.width, 52, 0, -4)
        :onTabChange(handler(self, self.onTabChanged_))
        :pos(size.width*0.5, size.height*0.5)
        :addTo(self.bgTab)

    ImgButton(self.bgMiddle.bgInput.btnDel,"#dialogs/safe/del_btn_normal.png","#dialogs/safe/del_btn_pressed.png")
        :onButtonClicked(buttontHandler(self, self.onDeleteClicked_))

    for i = 0, 9 do
        local btn = self.bgMiddle.btnNode["btn_" .. i]
        ImgButton(btn,"#dialogs/keyboard/keyboard_num_btn_normal.png","#dialogs/keyboard/keyboard_num_btn_pressed.png")
            :onButtonClicked(buttontHandler(self, self.onNumClicked_))
            :setTag(i)
    end

    ImgButton(self.bgMiddle.btnSaveMoney,"#common/btn_small_green.png","#common/btn_small_green_down.png")
        :onButtonClicked(buttontHandler(self, self.onSaveMoneyClicked_))

    ImgButton(self.bgMiddle.btnGetMoney,"#common/btn_small_blue.png","#common/btn_small_blue_down.png")
        :onButtonClicked(buttontHandler(self, self.onGetMoneyClicked_))

    ImgButton(self.bgMiddle.btnPwd,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        :onButtonClicked(buttontHandler(self, self.onPasswordClicked_))

    self.bgMiddle.btnSaveMoney.label:setString(sa.LangUtil.getText("SAFE", "SAVE_MONEY"))
    self.bgMiddle.btnGetMoney.label:setString(sa.LangUtil.getText("SAFE", "GET_MONEY"))

    self.safeNode.labelTitle:setString(sa.LangUtil.getText("SAFE", "MY_SAFE"))
    self.purseNode.labelTitle:setString(sa.LangUtil.getText("SAFE", "MY_PURSE"))
    
    self:updateSafeAndPurseNumText_()

    tab:gotoTab(self.selected_, true)
end

function SafePopup:setSafeEmailStatus_(email)
    local tips = sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_5")
    local btnName = sa.LangUtil.getText("SAFE", "SET_EMAIL_BTN")
    if email ~= "" then
        local index = string.find(email, "@")
        local str = "***" .. string.sub(email, index)

        tips = sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_6", str)
        btnName = sa.LangUtil.getText("SAFE", "CHANGE_EMAIL_BTN")
    end

    self.bgMiddle.labelTips:setString(tips)

    if self.emailBtn_ then
        self.emailBtn_:removeFromParent()
        self.emailBtn_ = nil
    end

    if self.emailBtnLine_ then
        self.emailBtnLine_:removeFromParent()
        self.emailBtnLine_ = nil
    end

    local labelColor = cc.c3b(0xff, 0xec, 0x69)
    local labelSize = self.bgMiddle.labelTips:getContentSize()
    local x, y = self.bgMiddle.labelTips:getPosition()

    local btnLabel = ui.newTTFLabel({text = btnName, size = 24, color = labelColor})
    local btnSize = btnLabel:getContentSize()
    local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btnSize.width, btnSize.height + 40)
        :setButtonLabel("normal", btnLabel)
        :onButtonClicked(buttontHandler(self, self.onSetEmailClicked_))
        :addTo(self.bgMiddle, 100)

    local sx = 492 - btnSize.width*0.5
    self.bgMiddle.labelTips:setPositionX(sx)

    local btn_x = sx + labelSize.width*0.5 + btnSize.width*0.5 + 5
    btn:pos(btn_x, y)

    local line = ui.newTTFLabel({text = "_", size = 24, color = labelColor})
        :pos(btn_x, y)
        :addTo(self.bgMiddle, 100)
    local lineSize = line:getContentSize()
    line:setScaleX(btnSize.width/lineSize.width)

    self.emailBtn_ = btn
    self.emailBtnLine_ = line
end

function SafePopup:updateSafeAndPurseNumText_()
    self.safeNode.labelChips:setString(sa.formatNumberWithSplit(userData.safe_money))
    self.safeNode.labelDiamonds:setString(sa.formatNumberWithSplit(userData.safe_diamonds))

    self.purseNode.labelChips:setString(sa.formatNumberWithSplit(userData.money))
    self.purseNode.labelDiamonds:setString(sa.formatNumberWithSplit(userData.diamonds))
end

function SafePopup:onTabChanged_(selected)
    self.selected_ = selected

    self:updateSelectedTextStatus_()
    self:initInputText_()
end

function SafePopup:initInputText_()
    self.curNumStr_ = "0"
    if self.selected_ == TAB_CHIPS then
        self.curSafeMoney_ = userData.safe_money
        self.curMoney_ = userData.money
    elseif self.selected_ == TAB_DIAMONDS then
        self.curSafeMoney_ = userData.safe_diamonds
        self.curMoney_ = userData.diamonds
    end

    self:updateInputText_()
end

--更新选中货币，文本状态
function SafePopup:updateSelectedTextStatus_()
    local selected = self.selected_

    self.bgMiddle.bgInput.iconMoney:setSpriteFrame(ICON_IMG[selected])

    local color = {
        SELECTED_COLOR,
        SELECTED_COLOR,
        UNSELECTED_COLOR,
        UNSELECTED_COLOR,
    }
    if selected == TAB_CHIPS then
        color = {
            SELECTED_COLOR,
            SELECTED_COLOR,
            UNSELECTED_COLOR,
            UNSELECTED_COLOR,
        }
    elseif selected == TAB_DIAMONDS then
        color = {
            UNSELECTED_COLOR,
            UNSELECTED_COLOR,
            SELECTED_COLOR,
            SELECTED_COLOR,
        }
    end

    self.safeNode.iconChip:setColor(color[1])
    self.safeNode.labelChips:setTextColor(color[2])
    self.safeNode.iconDiamond:setColor(color[3])
    self.safeNode.labelDiamonds:setTextColor(color[4])

    self.purseNode.iconChip:setColor(color[1])
    self.purseNode.labelChips:setTextColor(color[2])
    self.purseNode.iconDiamond:setColor(color[3])
    self.purseNode.labelDiamonds:setTextColor(color[4])
end

--数字按钮点击
function SafePopup:onNumClicked_(evt)
    local len = string.len(self.curNumStr_)
    if len == MAX_LEN then
        return
    end

    local tag = evt.target:getTag()
    self.curNumStr_ = self.curNumStr_ .. tag

    self:updateInputText_()
end

--删除点击
function SafePopup:onDeleteClicked_()
    local len = string.len(self.curNumStr_)
    if len > 0 then
        len = len - 1
        local str = string.sub(self.curNumStr_, 1, len)
        if str == "" then
            str = "0"
        end

        self.curNumStr_ = str
    end

    self:updateInputText_()
end

--检测输入的数值是否合法
function SafePopup:checkNumber_()
    local str = self.curNumStr_

    local p = "0*(%d*)" --去掉前导0
    str = string.match(str, p)
    if str == "" then --全部为0
        str = "0"
    end

    local number = tonumber(str)
    local maxNum = math.max(self.curSafeMoney_, self.curMoney_)
    if number > maxNum then
        number = maxNum
    end

    self:updateBtnStatus_(true, true)
    if self.curSafeMoney_ > self.curMoney_ and number > self.curMoney_ then
        self:updateBtnStatus_(false, true)
    elseif self.curMoney_ > self.curSafeMoney_  and number > self.curSafeMoney_ then
        self:updateBtnStatus_(true, false)
    end

    self.curNumStr_ = tostring(number)
end

--更新输入框显示的文本
function SafePopup:updateInputText_()
    self:checkNumber_()
    self.bgMiddle.bgInput.labelNum:setString(sa.formatNumberWithSplit(self.curNumStr_))
end

--更新按钮状态
function SafePopup:updateBtnStatus_(saveBtnEnabled, getBtnEnabled)
    self.bgMiddle.btnSaveMoney:setButtonEnabled(saveBtnEnabled)
    self.bgMiddle.btnGetMoney:setButtonEnabled(getBtnEnabled)
end

--存钱
function SafePopup:onSaveMoneyClicked_()
    local num = tonumber(self.curNumStr_)
    if num and num > 0 then
        if tx.checkIsVip() then
            self.controller_:saveMoney(self.selected_, num)
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "VIP_TIPS_2"))
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "INPUT_MONEY_TIPS"))
    end
end

--取钱
function SafePopup:onGetMoneyClicked_()
    local num = tonumber(self.curNumStr_)
    if num and num > 0 then
        self.controller_:getMoney(self.selected_, num)
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "INPUT_MONEY_TIPS"))
    end
end

--设置密码
function SafePopup:onPasswordClicked_()
    SetPasswordPopup.new(self.controller_):showPanel()
end

function SafePopup:onSetEmailClicked_()
    SetEmailPopup.new():showPanel()
end

function SafePopup:updateTextInfo(moneyType, num)
    if moneyType == TAB_CHIPS then
        userData.safe_money = userData.safe_money + num
        userData.money = userData.money - num
    else
        userData.safe_diamonds = userData.safe_diamonds + num
        userData.diamonds = userData.diamonds - num
    end

    self:playMoneyAnimation_(moneyType, num)

    self:initInputText_()
    self:updateSafeAndPurseNumText_()
end

function SafePopup:playMoneyAnimation_(itype, num)
    local sign
    local info = {}
    info.offx,info. offy = 0, 0
    if itype == 1 then -- 筹码
        info.icon = "#common/common_chip_icon.png"
        info.font = "fonts/xiaohuang.fnt"
        info.offx = 2
    elseif itype == 2 then
        info.icon = "#common/common_diamond_icon.png"
        info.font = "fonts/xiaolv.fnt"
        info.offy = 3
    end

    local safeData, purseData = clone(info), clone(info)
    local numStr = sa.formatBigNumber(math.abs(num))
    local addStr, subStr = " + " .. numStr, " - " .. numStr
    if num > 0 then
        safeData.txt = addStr

        purseData.txt = subStr
        purseData.font = "fonts/xiaohong.fnt"
    else
        purseData.txt = addStr

        safeData.txt = subStr
        safeData.font = "fonts/xiaohong.fnt"
    end

    self:createMoneyAnimation_(safeData, self.safeNode)
    self:createMoneyAnimation_(purseData, self.purseNode)
end

function SafePopup:createMoneyAnimation_(info, parent)
    local node = display.newNode():pos(0, 50):addTo(parent, 100)
    local label = ui.newBMFontLabel({text = info.txt, font = info.font}):addTo(node)

    local icon = display.newSprite(info.icon):addTo(node)
    local iconSize = icon:getContentSize()

    label:align(display.LEFT_CENTER, iconSize.width*0.5 + info.offx, info.offy)

    local move = cc.Spawn:create(
        cc.FadeIn:create(0.5),
        cc.MoveBy:create(0.5, cc.p(0, 90))
    )

    local sequence = transition.sequence({
        move,
        cc.DelayTime:create(0.2),
        cc.FadeOut:create(0.5),
        cc.CallFunc:create(function() 
            node:removeSelf()
        end),
    })

    node:setCascadeOpacityEnabled(true)
    node:opacity(0)
    node:runAction(sequence)
end

function SafePopup:addPropertyObservers_()
    self.passwordObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "safe_password", function (password)
        local pwdStr = sa.LangUtil.getText("SAFE", "SET_PASSWORD")
        if password == 1 then
            pwdStr = sa.LangUtil.getText("SAFE", "CHANGE_PASSWORD")
        end
        self.bgMiddle.btnPwd.label:setString(pwdStr)
    end)

    self.emailObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "safe_email", function (email)
        self:setSafeEmailStatus_(email)
    end)
end

function SafePopup:removePropertyObservers_()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "safe_password", self.passwordObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "safe_email", self.emailObserverHandle_)
end

function SafePopup:onCleanup()
    self:removePropertyObservers_()

    display.removeSpriteFramesWithFile("dialog_keyboard_texture.plist", "dialog_keyboard_texture.png")
    display.removeSpriteFramesWithFile("dialog_safe_texture.plist", "dialog_safe_texture.png")
end

return SafePopup
