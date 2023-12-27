--摇一摇活动
local HolidayShakeContent = class("HolidayShakeContent", function()
    return display.newNode()
end)

local HolidayFriendPopup = import(".HolidayFriendPopup")
local HolidayRecordPopup = import(".HolidayRecordPopup")
local HolidayRankingPopup = import(".HolidayRankingPopup")
local HolidaySendSuccPopup = import(".HolidaySendSuccPopup")
local HolidayHelpView = import(".HolidayHelpView")

local WIDTH, HEIGHT = 820, 590
local BTN_COLOR = cc.c3b(0x5a, 0x0e, 0xaf)
local BTN_GRAY_COLOR = cc.c3b(0x55, 0x55, 0x55)

function HolidayShakeContent:ctor(data)
    self:setNodeEventEnabled(true)

    self.data_ = data
    self.minSend_ = data.minSend
    self.sendChips_ = ""
    self.this_ = self

    tx.userData.isHolidayShakeSendChips = data.isSend

    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#holiday_shake_tab_bg.png", 
            indicator = "#holiday_shake_tab.png"
        }, 
        sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_TAB_TEXT"),
        {
            selectedText = {color = BTN_COLOR, size = 22},
            defaltText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22}
        }, true, true)
        :setTabBarSize(386, 50) 
        :onTabChange(handler(self, self.onSubTabChange_))
        :pos(WIDTH*0.5, 365)
        :addTo(self)

    self:addSendNode_()

    self:addShakeNode_()

    tab:gotoTab(1, true)

    self.selectedFriendListenerId_ = sa.EventCenter:addEventListener("HOLIDAY_SELECTED_SEND_FRIEND", handler(self, self.onSelectedSendFriend_))
end

function HolidayShakeContent:addShakeNode_()
    local node = display.newNode():addTo(self)
    self.shakeNode_ = node

    local dir = 150
    local cx = WIDTH*0.5
    local heart_x, heart_y = cx - 80, 250
    display.newSprite("#holiday_shake_heart.png")
        :pos(heart_x, heart_y)
        :addTo(node)

    local shakeTimes = self.data_.shakeTimes
    self.shakeTimes_ = ui.newTTFLabel({text = "x " .. shakeTimes, size = 80, color = cc.c3b(0xff, 0xf9, 0x56)})
        :align(display.LEFT_CENTER, heart_x + 100, heart_y)
        :addTo(node)

    ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_TIPS", 1, 1), size = 36})
        :pos(cx, 140)
        :addTo(node)

    local btnName = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_BTN")
    self.shakeBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_shake_btn_normal.png", pressed = "#holiday_shake_btn_pressed.png", disabled = "#holiday_shake_btn_disabled.png"}, {scale9 = true})
        :setButtonSize(260, 70)
        :setButtonLabel("normal", ui.newTTFLabel({text = btnName, size = 30, color = BTN_COLOR}))
        :setButtonLabel("disabled", ui.newTTFLabel({text = btnName, size = 30, color = BTN_GRAY_COLOR}))
        :pos(cx, 65)
        :onButtonClicked(buttontHandler(self, self.onShakeClicked_))
        :addTo(node)

    if shakeTimes > 0 then
        self.shakeBtn_:setButtonEnabled(true)
    else
        self.shakeBtn_:setButtonEnabled(false)
    end
    self.shakeBtn_:updateButtonLable_()
end

function HolidayShakeContent:addSendNode_()
    local node = display.newNode():addTo(self)
    self.sendNode_ = node

    ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_PLAY_TIPS"), size = 24, color = cc.c3b(0xff, 0xf9, 0x56)})
        :pos(WIDTH*0.5, 315)
        :addTo(node)

    local x, y = 175, 260
    local editName = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_NAME_1")
    local editTips = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_1")
    self.idEdit_ = self:createEditBoxNode_(1, editName, editTips, x, y)

    local btn_x = 620
    local dir = 80
    cc.ui.UIPushButton.new({normal = "#holiday_shake_friend_normal.png", pressed = "#holiday_shake_friend_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onFriendClicked_))
        :pos(btn_x, y)
        :addTo(node)

    btn_x = btn_x + dir
    cc.ui.UIPushButton.new({normal = "#holiday_shake_ranking_normal.png", pressed = "#holiday_shake_ranking_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onRankingClicked_))
        :pos(btn_x, y)
        :addTo(node)

    btn_x = btn_x + dir
    cc.ui.UIPushButton.new({normal = "#holiday_shake_record_normal.png", pressed = "#holiday_shake_record_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onRecordClicked_))
        :pos(btn_x, y)
        :addTo(node)

    y = y - 95
    editName = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_NAME_2")
    editTips = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_2", sa.formatNumberWithSplit(self.minSend_))
    self.chipsEdit_ = self:createEditBoxNode_(2, editName, editTips, x, y)
    cc.ui.UIPushButton.new({normal = "#holiday_shake_help_normal.png", pressed = "#holiday_shake_help_pressed.png"})
        :onButtonPressed(handler(self, self.showRewardTips_))
        :onButtonRelease(handler(self, self.hideRewardTips_))
        :pos(620, y)
        :addTo(node)

    local btnName = sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_SEND_BTN")
    self.sendBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_shake_btn_normal.png", pressed = "#holiday_shake_btn_pressed.png", disabled = "#holiday_shake_btn_disabled.png"}, {scale9 = true})
        :setButtonSize(260, 70)
        :setButtonLabel("normal", ui.newTTFLabel({text = btnName, size = 30, color = BTN_COLOR}))
        :setButtonLabel("disabled", ui.newTTFLabel({text = btnName, size = 30, color = BTN_GRAY_COLOR}))
        :pos(WIDTH*0.5, 70)
        :onButtonClicked(buttontHandler(self, self.onSendClicked_))
        :addTo(node)

    if self.data_.isSend == 1 then
        self.sendBtn_:setButtonEnabled(true)
    else
        self.sendBtn_:setButtonEnabled(false)
    end
    self.sendBtn_:updateButtonLable_()
end

function HolidayShakeContent:createEditBoxNode_(index, title, content, x, y)
    local node = self.sendNode_
    ui.newTTFLabel({text = title, size = 26})
        :align(display.RIGHT_CENTER, x - 10, y)
        :addTo(node)

    local input_w, input_h = 400, 70
    local frame = display.newScale9Sprite("#holiday_shake_input_bg.png", 0, 0, cc.size(input_w, input_h))
        :align(display.LEFT_CENTER, x, y)
        :addTo(node)

    local input_x, input_y = input_w*0.5, input_h*0.5
    local editBox = ui.newEditBox({
        size = cc.size(input_w - 6, input_h - 6),
        image="#common/transparent.png",
        x = input_x,
        y = input_y,
        listener = handler(self, self.onEditBoxChange_)
    })
    editBox:setFontName(ui.DEFAULT_TTF_FONT)
    editBox:setFontSize(24)
    editBox:setMaxLength(50)
    editBox:setPlaceholderFontName(ui.DEFAULT_TTF_FONT)
    editBox:setPlaceholderFontSize(24)
    editBox:setPlaceholderFontColor(cc.c3b(0xff, 0xff, 0xff))
    editBox:setPlaceHolder(content)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    editBox:resetEditBoxManager()
    editBox:setTag(index)
    editBox:addTo(frame)

    return editBox
end

function HolidayShakeContent:onSubTabChange_(selected)
    self.shakeNode_:hide()
    self.sendNode_:hide()

    if selected == 1 then
        self.sendNode_:show()
    else
        self.shakeNode_:show()
    end
end

function HolidayShakeContent:onEditBoxChange_(event, editbox)
    if event == "began" then
    elseif event == "changed" then
        local str = editbox:getText()
        str = string.trim(str)
        editbox:setText(str)
    elseif event == "return" then
        local str = editbox:getText()
        self:checkIsNumber_(str, editbox)
    end
end

function HolidayShakeContent:checkIsNumber_(str, editbox)
    local number = tx.delNumberPreZero(str)
    local tag = editbox:getTag()
    if str == "" then
        editbox:setText("")
        tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "INPUT_NO_EMPTY"))
    else
        if number then
            if tag == 2 then
                self.sendChips_ = number
                if number < self.minSend_ then
                    editbox:setText("")
                    tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_2", sa.formatNumberWithSplit(self.minSend_)))
                else
                    if number > tx.userData.money then
                        number = tx.userData.money
                        self.sendChips_ = number
                        if number >= self.minSend_ then
                            editbox:setText(sa.formatNumberWithSplit(number))
                            tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_6"))
                        else
                            editbox:setText("")
                            tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_7", sa.formatNumberWithSplit(self.minSend_)))
                        end
                    else
                        editbox:setText(sa.formatNumberWithSplit(number))
                    end
                end
            else
                editbox:setText(number)
            end
        else
            editbox:setText("")
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "INPUT_NUMBER"))
        end
    end
end

function HolidayShakeContent:onFriendClicked_()
    HolidayFriendPopup.new():showPanel()
end

function HolidayShakeContent:onRankingClicked_()
    -- local data = {
    --     {--排序规则，按赠送筹码多少排序 
    --         fromName = "aaaaaaa", --a送给b，a的昵称
    --         toName = "bbbbb", --b的昵称
    --         sendChips = 12345678, --赠送总筹码数，
    --     },
    -- }
    HolidayRankingPopup.new(data):showPanel()
end

function HolidayShakeContent:onRecordClicked_()
    -- local data = {
    --     {
    --         uid = 1111,--a赠送给b，b的UID
    --         sex = "f",
    --         img = "http://api.110x.com:10086/thailandrobotpic/tx(7).jpg", --头像
    --         nick = "ssa2seqa", --昵称
    --         sendChips = 12345678, --本次赠送筹码
    --         time = "2018.8.26"--时间
    --     },
    -- }
    HolidayRecordPopup.new():showPanel()
end

function HolidayShakeContent:showRewardTips_(evt)
    self:hideRewardTips_()
    local x, y = evt.target:getPosition()
    local view = HolidayHelpView.new(self.data_.helpDesc)
        :align(display.BOTTOM_CENTER, x, y)
        :addTo(self.sendNode_, 10)

    self.rewardTipsView_ = view
end

function HolidayShakeContent:hideRewardTips_()
    if self.rewardTipsView_ then
        self.rewardTipsView_:removeFromParent()
        self.rewardTipsView_ = nil
    end
end

function HolidayShakeContent:onSendClicked_()
    -- local data = { --a赠送给b
    --     fromName = "xiao ming", --a的昵称
    --     toName = "xiao hua", --b的昵称
    --     shakeTimes = 3, --获得多少次摇一摇
    -- }
    local uid = self.idEdit_:getText()
    local chips = self.sendChips_

    if uid == "" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_3"))
    elseif chips == "" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_4"))
    elseif tonumber(uid) == tonumber(tx.userData.uid) then
        tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_EDIT_TIPS_5"))
    else
        self.sendBtn_:setButtonEnabled(false)
        sa.HttpService.POST(
        {
            mod = "Activity",
            act = "sendFriendMoney",
            fid = uid,
            money = chips
        },
        function(data)
            local retData = json.decode(data)
            local code = retData.code
            if code == 1 then
                if self.this_ then
                    self.data_.shakeTimes = self.data_.shakeTimes + retData.data.shakeTimes
                    self.shakeTimes_:setString("x" .. self.data_.shakeTimes)
                    self.shakeBtn_:setButtonEnabled(true)
                end
                HolidaySendSuccPopup.new(retData.data):showPanel()
            else
                self.sendBtn_:setButtonEnabled(true)
                if code == -4 then
                    if self.this_ then
                        self.idEdit_:setText("")
                    end
                    tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_SEND_FAILED_2"))
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_SEND_FAILED_1"))
                end
            end
        end,
        function ()
            self.sendBtn_:setButtonEnabled(true)
            tx.TopTipManager:showToast(sa.LangUtil.getText("NEWESTACT", "HOLIDAY_SHAKE_SEND_FAILED_1"))
        end)
    end
end

function HolidayShakeContent:onShakeClicked_()
    tx.PopupManager:removeAllPopup()
    sa.EventCenter:dispatchEvent("HOLIDAY_SHAKE_GIRL_CHAT")
end

function HolidayShakeContent:onSelectedSendFriend_(evt)
    self.idEdit_:setText(evt.data)
end

function HolidayShakeContent:onCleanup()
    sa.EventCenter:removeEventListener(self.selectedFriendListenerId_)
end

return HolidayShakeContent