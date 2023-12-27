-- 兑换码界面
local ExchangeCodePopup = class("ExchangeCodePopup", tx.ui.Panel)

local logger = sa.Logger.new("ExchangeCodePopup")
local ExchangeCodePopupController = import(".ExchangeCodePopupController")
local InviteRewardRecordView = import(".InviteRewardRecordView")
local InviteRewardPopup = import(".InviteRewardPopup")

local WIDTH, HEIGHT = 1016, 746
local TEXT_COLOR = cc.c3b(0xf6, 0xdc, 0x8f)
local TAB_ON_COLOR = cc.c3b(0xff, 0xff, 0xff)
local TAB_OFF_COLOR = cc.c3b(0xb6, 0x97, 0x5a)

local MAX_LEN = 8
local INVITE_CODE_VIEW = 1
local EXCHANGE_CODE_VIEW = 2

local IMAGE = {
    "#common/exchange_code_more_btn.png",
    "#common/share_sdk_line_icon.png",
    "#common/exchange_code_sms_btn.png",
    "#common/share_sdk_whatsapp_icon.png",
    "#common/share_sdk_facebookmessenger_icon.png",
    "#common/share_sdk_facebook_icon.png",
}

function ExchangeCodePopup:ctor(code, selected)
    ExchangeCodePopup.super.ctor(self, {WIDTH, HEIGHT})

    self:addCloseBtn()

    self.code_ = code

    self.selected_ = selected or INVITE_CODE_VIEW

    self.friGetMoney_ = 55555

    self.curNumStr_ = ""

    self.controller_ = ExchangeCodePopupController.new(self)

    local x, y = WIDTH*0.5, HEIGHT*0.5
    display.newSprite("img/exchange_code_bg.jpg")
        :align(display.RIGHT_CENTER, x, y)
        :addTo(self.background_)

    display.newSprite("img/exchange_code_bg.jpg")
        :align(display.LEFT_CENTER, x, y)
        :flipX(true)
        :addTo(self.background_)

    display.addSpriteFrames("dialog_exchange_texture.plist", "dialog_exchange_texture.png")
    display.addSpriteFrames("dialog_friend.plist", "dialog_friend.png")

    self:addMainUI()

    self.controller_:getInviteCode()
end

function ExchangeCodePopup:addMainUI()
    self.bgNode_ = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER, 0, 0)
        :addTo(self)

    self:addInviteView_()
    self:addExchangeView_()

    local title = sa.LangUtil.getText("ECODE", "TITLE")

    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    local btn_w, btn_h = 331, 85
    local posX = {360, WIDTH-360}
    local posY = HEIGHT - 49
    for i = 1, #title do
        local btn = cc.ui.UICheckBoxButton.new({
                on="#dialogs/exchange/exchange_code_tab_on.png",
                off="#common/transparent.png",
                off_pressed = "#dialogs/exchange/exchange_code_tab_off_pressed.png"},
                {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel("on", ui.newTTFLabel({text = title[i], size = 36, color = TAB_ON_COLOR}))
            :setButtonLabel("off", ui.newTTFLabel({text = title[i], size = 36, color = TAB_OFF_COLOR}))
            :setButtonLabelAlignment(display.CENTER)
            :setButtonLabelOffset(0, 6)
            :align(display.TOP_CENTER, posX[i], posY)
            :addTo(self.bgNode_)

        tabGroup:addButton(btn)
    end

    tabGroup:onButtonSelectChanged(handler(self, self.onMainTabChange))
    tabGroup:getButtonAtIndex(self.selected_):setButtonSelected(true):updateButtonLable_() --刷新label状态，感觉是引擎bug
    self.tabGroup_ = tabGroup
end

function ExchangeCodePopup:onMainTabChange(evt)
    local selected = evt.selected

    if selected == INVITE_CODE_VIEW then
        self.inviteViewNode_:show()
        self.exchangeViewNode_:hide()
    elseif selected == EXCHANGE_CODE_VIEW then
        self.exchangeViewNode_:show()
        self.inviteViewNode_:hide()
    end
end

function ExchangeCodePopup:addInviteView_()
    self.inviteViewNode_ = display.newNode()
        :addTo(self.bgNode_)
        :hide()

    self:addInviteTopView_()
    self:addInviteBottomView_()
end

function ExchangeCodePopup:addInviteTopView_()
    local frame_w, frame_h = 860, 360
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.TOP_CENTER, WIDTH*0.5, HEIGHT - 120)
        :addTo(self.inviteViewNode_)

    local data = {
        maxGetMoney = 55555000,
        onceGetMoney = {30000, 80000},
        friGetMoney = 55555,
        secGetMoney = 5555
    }

    local label_x, label_y = frame_w*0.5, frame_h - 30
    local maxTitleLabel_ = ui.newTTFLabel({text= sa.LangUtil.getText("ECODE","MAX_REWARD_TIPS"), size = 26, color = TEXT_COLOR})
        :pos(label_x, label_y)
        :addTo(frame)

    label_y = label_y - 70
    local maxNumLabel_ = display.newSprite("#dialogs/exchange/exchange_code_reward.png")
        :pos(label_x, label_y)
        :addTo(frame)

    --邀请码
    label_y = label_y - 105
    self.inviteCode_ = ui.newTTFLabel({text="", size = 40})
        :pos(label_x, label_y)
        :addTo(frame)

    local dir = 250
    display.newSprite("#dialogs/exchange/exchange_code_line_frame.png")
        :pos(label_x - dir, label_y)
        :addTo(frame)

    display.newSprite("#dialogs/exchange/exchange_code_line_frame.png")
        :pos(label_x + dir, label_y)
        :flipX(true)
        :addTo(frame)

    local label = ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "MY_CODE"), size = 26, color = TEXT_COLOR})
        :pos(label_x - 170, label_y)
        :addTo(frame)
    sa.fitSprteWidth(label, 160)

    self.copyBtn_ = cc.ui.UIPushButton.new("#dialogs/exchange/exchange_code_copy_btn.png", {scale9 = true})
        :setButtonSize(150, 54)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "COPY_CODE"), size = 22, color = cc.c3b(0x71, 0x22, 0x03)}))
        :onButtonClicked(handler(self, self.onCopyClicked_))
        :pos(label_x + 180, label_y)
        :addTo(frame)
    self.copyBtn_:setButtonEnabled(false)

    label_y = label_y - 55
    local str_1 = sa.formatNumberWithSplit(data.friGetMoney)
    local str_2 = sa.formatNumberWithSplit(data.onceGetMoney[1]) .. "-" .. sa.formatNumberWithSplit(data.onceGetMoney[2])
    local str_3 = sa.formatNumberWithSplit(data.secGetMoney)
    self.rewardTips_ = ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "INVITE_REWARD_TIPS", str_1, str_2, str_3),
            size = 20, color = TEXT_COLOR, align = ui.TEXT_ALIGN_LEFT, dimensions = cc.size(900, 0)})
        :align(display.TOP_CENTER, label_x, label_y)
        :addTo(frame)

    if tx.config.SHOW_INVITE_AWARD==0 then
        maxTitleLabel_:hide()
        maxNumLabel_:hide()
        self.rewardTips_:hide()
    end
end

function ExchangeCodePopup:addInviteBottomView_()
    local frame_w, frame_h = 860, 200
    local x, y = frame_w * 0.5, frame_h*0.5
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 46)
        :addTo(self.inviteViewNode_)

    display.newScale9Sprite("#dialogs/exchange/exchange_code_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :pos(frame_w*0.5, frame_h*0.5)
        :addTo(frame)

    display.newScale9Sprite("#dialogs/exchange/exchange_code_title_frame.png", 0, 0, cc.size(frame_w, 60))
        :align(display.TOP_CENTER, frame_w*0.5, frame_h - 1)
        :addTo(frame)

    ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "INVITE_TIPS"), size = 24, color = TEXT_COLOR})
        :align(display.LEFT_CENTER, 25, frame_h - 30)
        :addTo(frame)

    local sx = 75
    local dir = 142
    local y = 72
    self.btnList_ = {}
    for i = 1, 6 do
        local btn_x = sx + (i - 1) * dir
        local btn = cc.ui.UIPushButton.new(IMAGE[i])
            :onButtonPressed(function(evt)
                evt.target.light:show()
            end)
            :onButtonRelease(function(evt)
                evt.target.light:hide()
            end)
            :onButtonClicked(handler(self, self.onShareClicked_))
            :pos(btn_x, y)
            :addTo(frame)
        self.btnList_[i] = btn

        btn:setTag(i)

        btn.light = display.newSprite("#common/common_share_light.png")
            :addTo(btn, cc.ui.UIPushButton.IMAGE_ZORDER - 1)
            :hide()
    end
    -- 删除SMS
    local sid = appconfig.SID[string.upper(device.platform)]
    if sid==19 or sid==20 then  --俄语版 短信 改为 VK分享
        self.btnList_[3]:hide()
        local xx,yy = self.btnList_[3]:getPosition()

        local i = 7
        local btn = cc.ui.UIPushButton.new("vk_share_btn.png")
            :onButtonPressed(function(evt)
                evt.target.light:show()
            end)
            :onButtonRelease(function(evt)
                evt.target.light:hide()
            end)
            :onButtonClicked(handler(self, self.onShareClicked_))
            :pos(xx,yy)
            :addTo(frame)
        btn:setTag(i)

        btn.light = display.newSprite("#common/common_share_light.png")
            :addTo(btn, cc.ui.UIPushButton.IMAGE_ZORDER - 1)
            :hide()
        self.btnList_[3] = btn
        if tx.config.SHOW_SMS~=1 then
            self.btnList_[1]:hide()
            local list = clone(self.btnList_)
            table.remove(list, 1)
            local newDir = dir*(#self.btnList_-1)/(#list-1)
            for k,v in pairs(list) do
                v:setPositionX(sx + (k - 1) * newDir)
            end
        end
    elseif tx.config.SHOW_SMS~=1 then
        self.btnList_[3]:hide()
        self.btnList_[1]:hide()
        local list = clone(self.btnList_)
        table.remove(list, 3)
        table.remove(list, 1)
        local newDir = dir*(#self.btnList_-1)/(#list-1)
        for k,v in pairs(list) do
            v:setPositionX(sx + (k - 1) * newDir)
        end
    end
end

function ExchangeCodePopup:updateInviteView(data)
    self.icode_ = data.icode

    local str_1 = sa.formatNumberWithSplit(data.friGetMoney)
    local str_2 = sa.formatNumberWithSplit(data.onceGetMoney[1]) .. "-" .. sa.formatNumberWithSplit(data.onceGetMoney[2])
    local str_3 = sa.formatNumberWithSplit(data.secGetMoney)
    self.friGetMoney_ = data.friGetMoney

    self.rewardTips_:setString(sa.LangUtil.getText("ECODE", "INVITE_REWARD_TIPS", str_1, str_2, str_3))

    self:initFeedData_(data.icode)
    local icode = string.sub(data.icode, 1, 4) .. " " .. string.sub(data.icode, 5)
    self.inviteCode_:setString(icode)
    self.copyBtn_:setButtonEnabled(true)
end

function ExchangeCodePopup:initFeedData_(code)
    local feedData = clone(sa.LangUtil.getText("FEED", "INVITE_CODE"))
    feedData.name = sa.LangUtil.formatString(feedData.name, code)
    feedData.link = feedData.link.."&type="..consts.PUSH_TYPE.INVITE_CODE.."&code="..code

    self.feedData_ = feedData --邀请码数据
end

function ExchangeCodePopup:addExchangeView_()
    self.exchangeViewNode_ = display.newNode()
        :addTo(self.bgNode_)
        :hide()

    self:addExchangeLeftView_()
    self:addExchangeRightView_()
end

function ExchangeCodePopup:addExchangeLeftView_()
    local frame_w, frame_h = 446, 570
    local x = frame_w * 0.5
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.BOTTOM_LEFT, 60, 38)
        :addTo(self.exchangeViewNode_, 1)

    display.newScale9Sprite("#dialogs/exchange/exchange_code_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :pos(frame_w*0.5, frame_h*0.5)
        :addTo(frame)

    local titles = sa.LangUtil.getText("ECODE", "INVITE_TITLES")
    local y = frame_h - 1
    self:addTipsTitle_(frame, titles[1], x, y)
    
    y = y - 85
    local label_x = 23
    ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "FANS_DESC"), size = 24, dimensions = cc.size(410, 0)})
        :align(display.LEFT_TOP, label_x, y)
        :addTo(frame)

    y = y - 180
    cc.ui.UIPushButton.new({normal= "#dialogs/exchange/exchange_code_fans_btn_normal.png", pressed = "#dialogs/exchange/exchange_code_fans_btn_pressed.png"})
        :onButtonClicked(handler(self, self.onFansClicked_))
        :pos(frame_w - 76, y)
        :addTo(frame)

    local fansColor = cc.c3b(0xff, 0x99, 0xe5)
    ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "FANS"), size = 24, color = fansColor})
        :align(display.LEFT_CENTER, label_x, y + 10)
        :addTo(frame)

    ui.newTTFLabel({text=appconfig.FANS_URL, size = 15, color = fansColor})
        :align(display.LEFT_CENTER, label_x, y - 15)
        :addTo(frame)

    self:addTipsTitle_(frame, titles[2], x, 260)

    local inviteRewardNode_ = InviteRewardRecordView.new(self.controller_)
        :pos(x, 100)
        :addTo(frame)
    if tx.config.SHOW_INVITE_AWARD==0 then
        inviteRewardNode_:hide()
    end
end

function ExchangeCodePopup:addTipsTitle_(parent, title, x, y)
    local w, h = 446, 60
    local frame = display.newScale9Sprite("#dialogs/exchange/exchange_code_title_frame.png", 0, 0, cc.size(w, h))
        :align(display.TOP_CENTER, x, y)
        :addTo(parent)

    local label = ui.newTTFLabel({text=title, size = 24})
        :pos(w*0.5 - 20, h*0.5)
        :addTo(frame)
    sa.fitSprteWidth(label, 400)

    display.newSprite("#dialogs/exchange/exchange_code_arrow.png")
        :align(display.RIGHT_CENTER, w - 10, h*0.5)
        :addTo(frame)
end

function ExchangeCodePopup:addExchangeRightView_()
    local frame_w, frame_h = 446, 570
    local x = frame_w * 0.5
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.BOTTOM_CENTER, WIDTH - 280, 38)
        :addTo(self.exchangeViewNode_)

    display.newScale9Sprite("#dialogs/exchange/exchange_code_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :pos(x, frame_h*0.5)
        :addTo(frame)

    local exitbox = display.newNode()
        :size(frame_w, 70)
        :align(display.TOP_CENTER, x, frame_h)
        :addTo(frame)

    self.inputTips_ = ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "EDITDEFAULT"), size = 20})
        :pos(x, 32)
        :addTo(exitbox)

    self.inputText_ = ui.newBMFontLabel({text = "", font = "fonts/duihuan.fnt"})
        :pos(x, 30)
        :addTo(exitbox)

    if self.code_ and self.code_~="" and self.code_~=0 and self.code_~="0" then
        self.inputTips_:hide()
        self.inputText_:setString(self.code_)
        self.curNumStr_ = tostring(self.code_)
    end

    self:addKeyboardNode_(frame)

    cc.ui.UIPushButton.new({normal= "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonSize(230, 104)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "EXCHANGE"), size = 28}))
        :onButtonClicked(handler(self, self.onExchangeClicked_))
        :pos(x, 58)
        :addTo(frame)
end

function ExchangeCodePopup:addKeyboardNode_(parent)
    local tagList = {1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 0, 10}
    local btn_w, btn_h = 147, 96
    local sx, sy = 74, 446
    local dir_x, dir_y = 149, 98
    local icon_x, icon_y = 0, 0
    for i = 1, 12 do
        local x = sx + ((i - 1) % 3) * dir_x
        local y = sy - math.floor((i - 1) / 3) * dir_y

        local btn = cc.ui.UIPushButton.new({normal= "#dialogs/exchange/exchange_code_num_btn_normal.png", pressed = "#dialogs/exchange/exchange_code_num_btn_pressed.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :onButtonClicked(buttontHandler(self, self.onKeyboardClicked_))
            :setDelayTouchEnabled(false)
            :pos(x, y)
            :addTo(parent)

        local tag = tagList[i]
        btn:setTag(tag)

        if tag == 10 then
            display.newSprite("#dialogs/exchange/exchange_code_del.png")
                :pos(icon_x, icon_y)
                :addTo(btn)
        elseif tag == 11 then
            display.newSprite("#dialogs/exchange/exchange_code_clear.png")
                :pos(icon_x, icon_y)
                :addTo(btn)
        else
            ui.newBMFontLabel({text = tag, font = "fonts/duihuan.fnt"})
                :pos(icon_x, icon_y)
                :addTo(btn)
        end
    end
end

function ExchangeCodePopup:onKeyboardClicked_(evt)
    local tag = evt.target:getTag()
    local len = string.len(self.curNumStr_)
    if tag == 10 then
        if len > 0 then
            len = len - 1
            self.curNumStr_ = string.sub(self.curNumStr_, 1, len)
        end
    elseif tag == 11 then
        self.curNumStr_ = ""
    else
        
        if len == MAX_LEN then
            return
        end

        self.curNumStr_ = self.curNumStr_ .. tag
    end
    
    self.inputText_:setString(self.curNumStr_)
    if self.curNumStr_ == "" then
        self.inputTips_:show()
    else
        self.inputTips_:hide()
    end
end

function ExchangeCodePopup:onExchangeClicked_()
    local text = self.curNumStr_
    local len = string.len(text)
    if len == 6 or len == 8 then
        if len == 8 and tonumber(text) == self.icode_ then
            tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "NO_INPUT_SELF_CODE"))
            return
        end
        self.controller_:getExchangeReward(text, len)
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "EDITDEFAULT"))
    end
end

function ExchangeCodePopup:onFansClicked_()
    -- device.openURL(appconfig.FANS_URL)
    tx.Native:OpenFansUrl()
end

function ExchangeCodePopup:onCopyClicked_()
    tx.ShareSDK:shareByCopy(self.feedData_)
end

function ExchangeCodePopup:onShareClicked_(evt)
    local tag = evt.target:getTag()
    local feedData = self.feedData_

    self.controller_:getShareInviteCodeMoney()

    if feedData then
        if tag == 1 then
            tx.ShareSDK:ShareBySystem(feedData)
        elseif tag == 2 then
            tx.ShareSDK:shareByLine(feedData)
        elseif tag == 3 then
            tx.ShareSDK:shareByShortMessage(feedData)
        elseif tag == 4 then
            tx.ShareSDK:shareByWhatsApp(feedData)
        elseif tag == 5 then
            tx.ShareSDK:shareByFacebookMessenger(feedData)
        elseif tag == 6 then
            tx.ShareSDK:shareByFacebook(feedData)
        elseif tag == 7 then
            tx.ShareSDK:shareByVK(feedData)
        end
    end
end

function ExchangeCodePopup:showRewardDialog(reward)
    local data = {}
    if reward.money then
        local desc = sa.LangUtil.getText("STORE", "FORMAT_CHIP", reward.money)
        local feedData = clone(sa.LangUtil.getText("FEED", "EXCHANGE_CODE"))

        data.rewardType = 1
        data.num = reward.money
        feedData.name = sa.LangUtil.formatString(feedData.name, desc)
        data.feedData = feedData
    end

    tx.ui.RewardDialog.new(data, true):showPanel()
end

function ExchangeCodePopup:showInviteCodeReward(name, money)
    local data = {
        name = name,
        money = money,
        friGetMoney = self.friGetMoney_
    }
    InviteRewardPopup.new(data, self):showPanel()
end

function ExchangeCodePopup:goToInviteFriend()
    self.tabGroup_:getButtonAtIndex(INVITE_CODE_VIEW):setButtonSelected(true)
end

function ExchangeCodePopup:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function ExchangeCodePopup:onRemovePopup(removeFunc)
    if self.closeCallback_ then
        self.closeCallback_()
    end

    removeFunc()
end

function ExchangeCodePopup:onCleanup()
    self.controller_:dispose()

    display.removeSpriteFramesWithFile("dialog_exchange_texture.plist", "dialog_exchange_texture.png")
end

return ExchangeCodePopup
