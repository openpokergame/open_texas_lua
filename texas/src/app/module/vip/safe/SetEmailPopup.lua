--如果设置了密码，每次登录第一次打开保险箱需要输入密码
local SetEmailPopup = class("SetEmailPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570
local TEXT_CORLOR = cc.c3b(0x9b, 0xa9, 0xff)
local INPUT_W = 650

function SetEmailPopup:ctor()
	SetEmailPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("SAFE", "SET_EMAIL"))

    self.setEmailing_ = false
    
    self.this_ = self

    self:initViews_()
end

function SetEmailPopup:initViews_()
    local bg = self.background_
    local frame_w, frame_h = WIDTH - 56, 290
    local x, y = WIDTH*0.5, HEIGHT - 120
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.TOP_CENTER, x, y)
        :addTo(bg)

    local str = sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_1")
    local email = tx.userData.safe_email
    if email ~= "" then
        str = sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_2")
    end
    ui.newTTFLabel({text = str, size = 24, dimensions = cc.size(INPUT_W, 0)})
        :align(display.TOP_CENTER, x, y - 20)
        :addTo(bg)

    local input_x, input_y = x, 220

    self.editBox_ = self:createEditBoxNode_(input_x, input_y, sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_3"))
    self.editBox_:setText(email)

    local btn_w, btn_h = 330, 146
    local btn_x, btn_y = x, 100

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 26}))
        :pos(btn_x, btn_y)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
        :addTo(bg)
end

function SetEmailPopup:createEditBoxNode_(x, y, text)
    local input_w, input_h = INPUT_W, 70
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
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_GO)
    editBox:addTo(frame)

    return editBox
end

function SetEmailPopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
        local str = editbox:getText()
        str = string.trim(str)
        editbox:setText(str)
    elseif event == "return" then
    end
end

function SetEmailPopup:onConfirmClicked_()
    if self.setEmailing_ then
        return
    end

    local str = self.editBox_:getText()
    if str == "" or not tx.checkIsEmail(str) then
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_4"))
    else
        self:bindEmail_(str)
    end
end

--如果保险箱设置了密码，必须得先验证密码
function SetEmailPopup:bindEmail_(emailStr)
    self.setEmailing_ = true
    sa.HttpService.POST(
    {
        mod = "Vip",
        act = "bindEmail", 
        email = emailStr
    }, 
    function(data)
        local recallData = json.decode(data)
        self.setEmailing_ = false
        if recallData.code == 1 then
            tx.userData.safe_email = emailStr
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_EMAIL_SUCCESS"))
            if self.this_ then
                self:hidePanel()
            end
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_FAILED"))
        end
    end, 
    function ()
        tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "SET_EMAIL_TIPS_FAILED"))
        self.setEmailing_ = false
    end)
end

return SetEmailPopup
