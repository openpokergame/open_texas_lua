local ResetPasswordPopup = class("ResetPasswordPopup", tx.ui.Panel)
local SafePopup = import(".SafePopup")

local WIDTH, HEIGHT = 830, 570
local TEXT_CORLOR = cc.c3b(0x9b, 0xa9, 0xff)

function ResetPasswordPopup:ctor()
	ResetPasswordPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("SAFE", "RESET_PASSWORD"))

    self.reseting_ = false
    
    self.this_ = self

    self:initViews_()
end

function ResetPasswordPopup:initViews_()
    local bg = self.background_
    local frame_w, frame_h = WIDTH - 56, 290
    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.TOP_CENTER, WIDTH*0.5, HEIGHT - 120)
        :addTo(bg)

    local x = WIDTH*0.5
    ui.newTTFLabel({text = sa.LangUtil.getText("SAFE", "RESET_PASSWORD_TIPS_2"), size = 26, dimensions = cc.size(WIDTH - 120, 0), align = ui.TEXT_ALIGN_LEFT})
        :align(display.TOP_CENTER, x, HEIGHT - 140)
        :addTo(bg)

    self.editBox_ = self:createEditBoxNode_(x, HEIGHT*0.5 - 50, sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_1"))

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(330, 146)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 26}))
        :pos(x, 100)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
        :addTo(bg)
end

function ResetPasswordPopup:createEditBoxNode_(x, y, text)
    local input_w, input_h = WIDTH - 120, 70
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

function ResetPasswordPopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
        local str = editbox:getText()
        str = string.trim(str)
        editbox:setText(str)
    elseif event == "return" then
    end
end

function ResetPasswordPopup:onConfirmClicked_()
    if not self.reseting_ then
        local password = self.editBox_:getText()
        if password == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_PASSWORD_TIPS_4"))
        else
            self:resetPassword_(password)
        end
    end
end

--重置密码
function ResetPasswordPopup:resetPassword_(password)
    self.reseting_ = true
    sa.HttpService.POST(
    {
        mod = "Vip",
        act = "forgetPasswd", 
        passwd = crypto.md5(password),
        lang = appconfig.LANG
    }, 
    function(data)
        local recallData = json.decode(data)
        self.reseting_ = false
        local code = recallData.code
        if code == 1 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "RESET_PASSWORD_TIPS_1"))
            if self.this_ then
                self:hidePanel()
            end
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "RESET_PASSWORD_TIPS_4"))
        end
    end, 
    function ()
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "RESET_PASSWORD_TIPS_4"))
        self.reseting_ = false
    end)
end

return ResetPasswordPopup
