--设置密码
local SetPasswordPopup = class("SetPasswordPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570

local TEXT_CORLOR = cc.c3b(0x9b, 0xa9, 0xff)

function SetPasswordPopup:ctor(controller)
	SetPasswordPopup.super.ctor(self, {WIDTH, HEIGHT})
    local title = sa.LangUtil.getText("SAFE", "SET_PASSWORD")
    if tx.userData.safe_password == 1 then
        title = sa.LangUtil.getText("SAFE", "CHANGE_PASSWORD")
    end
    self:setTextTitleStyle(title)

    self.controller_ = controller

    self:initViews_()
end

function SetPasswordPopup:initViews_()
    local bg = self.background_
    local frame_w, frame_h = WIDTH - 56, 290
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.TOP_CENTER, WIDTH*0.5, HEIGHT - 120)
        :addTo(bg)

    local input_x, input_y = WIDTH*0.5, HEIGHT*0.5 + 82  
    self.firstEditBox_ = self:createEditBoxNode_(input_x, input_y, sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_1"))
    self.secondEditBox_ = self:createEditBoxNode_(input_x, input_y - 110, sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_2"))

    local btn_w, btn_h = 330, 146
    local btn_x, btn_y = WIDTH*0.5, 100
    local dir = 160
    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("SAFE", "CLEAN_PASSWORD"), size = 26}))
        :pos(btn_x - dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onCancelClicked_))
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 26}))
        :pos(btn_x + dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
        :addTo(bg)
end

function SetPasswordPopup:createEditBoxNode_(x, y, text)
    local input_w, input_h = 650, 70
    local bg = self.background_
    local frame = display.newScale9Sprite("#common/common_edit_box_bg.png", 0, 0, cc.size(input_w, input_h))
        :pos(x, y)
        :addTo(bg)

    local input_x, input_y = input_w*0.5, input_h*0.5
    local editBox = ui.newEditBox({
        size = cc.size(input_w - 6, input_h - 2),
        image="#common/transparent.png",
        x = input_x,
        y = input_y,
        listener = handler(self, self.onEditBoxChange_)
    })
    editBox:setFontName(ui.DEFAULT_TTF_FONT)
    editBox:setFontSize(26)
    editBox:setFontColor(TEXT_CORLOR)
    editBox:setPlaceholderFontName(ui.DEFAULT_TTF_FONT)
    editBox:setPlaceholderFontSize(26)
    editBox:setPlaceholderFontColor(TEXT_CORLOR)
    editBox:setPlaceHolder(text)
    editBox:setMaxLength(10)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_GO)
    editBox:addTo(frame)

    return editBox
end

function SetPasswordPopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
        local str = editbox:getText()
        str = string.trim(str)
        editbox:setText(str)
    elseif event == "return" then
    end
end

--取消密码
function SetPasswordPopup:onCancelClicked_()
    self.controller_:changePassword("")
    self:hidePanel()
end

function SetPasswordPopup:onConfirmClicked_()
    local str1 = self.firstEditBox_:getText()
    local str2 = self.secondEditBox_:getText()
    if str1 ~= str2 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_3"))
    else
        if str1 == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_4"))
        else
            self.controller_:changePassword(str1)
            self:hidePanel()
        end
    end
end

return SetPasswordPopup
