--如果设置了密码，每次登录第一次打开保险箱需要输入密码
local InputPasswordPopup = class("InputPasswordPopup", tx.ui.Panel)
local SafePopup = import(".SafePopup")
local ResetPasswordPopup = import(".ResetPasswordPopup")

local WIDTH, HEIGHT = 830, 570
local TEXT_CORLOR = cc.c3b(0x9b, 0xa9, 0xff)

function InputPasswordPopup:ctor()
	InputPasswordPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("SAFE", "TITLE"))

    self.checkPasswording_ = false
    
    self.this_ = self

    self:initViews_()
end

function InputPasswordPopup:initViews_()
    local bg = self.background_
    local frame_w, frame_h = WIDTH - 56, 290
    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.TOP_CENTER, WIDTH*0.5, HEIGHT - 120)
        :addTo(bg)

    local input_x, input_y = WIDTH*0.5, HEIGHT*0.5 + 20
    self.editBox_ = self:createEditBoxNode_(input_x, input_y, sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_5"))

    local btn_w, btn_h = 330, 146
    local btn_x, btn_y = WIDTH*0.5, 100
    local btn_dir = 197
    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("SAFE", "FORGET_PASSWORD"), size = 26}))
        :pos(btn_x - btn_dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onForgetPasswordClicked_))
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 26}))
        :pos(btn_x + btn_dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
        :addTo(bg)
end

function InputPasswordPopup:createEditBoxNode_(x, y, text)
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

function InputPasswordPopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
        local str = editbox:getText()
        str = string.trim(str)
        editbox:setText(str)
    elseif event == "return" then
    end
end

function InputPasswordPopup:onForgetPasswordClicked_()
    if tx.userData.safe_email ~= "" then
        ResetPasswordPopup.new():showPanel()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "RESET_PASSWORD_TIPS_3"))
    end

    self:hidePanel()
end

function InputPasswordPopup:onConfirmClicked_()
    if self.checkPasswording_ then
        return
    end

    local str = self.editBox_:getText()
    if str == "" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_4"))
    else
        self:checkPassword_(str)
    end
end

--如果保险箱设置了密码，必须得先验证密码
function InputPasswordPopup:checkPassword_(password)
    self.checkPasswording_ = true
    sa.HttpService.POST(
    {
        mod = "Vip",
        act = "checkPasswd", 
        passwd = crypto.md5(password)
    }, 
    function(data)
        local recallData = json.decode(data)
        self.checkPasswording_ = false
        local code = recallData.code
        if code == 1 then
            SafePopup.new():showPanel()
            if self.this_ then
                self:hidePanel()
            end
        elseif code == -1 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "CHECK_PASSWORD_ERROR"))
        end
    end, 
    function ()
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "CHECK_PASSWORD_FAILED"))
        self.checkPasswording_ = false
    end)
end

return InputPasswordPopup
