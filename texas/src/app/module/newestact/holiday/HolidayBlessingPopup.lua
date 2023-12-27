--节日祝福弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidayBlessingPopup = class("HolidayBlessingPopup", HolidayBasePopup)

local WIDTH, HEIGHT = 752, 550
local TEXT_CORLOR = cc.c3b(0xb8, 0x27, 0x72)

function HolidayBlessingPopup:ctor(data, callback)
	HolidayBlessingPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitle(data.title)

    self.callback_ = callback

    self:initViews_(data)
end

function HolidayBlessingPopup:initViews_(data)
    self.data_ = data
    local bg = self
    local cx = WIDTH*0.5
    ui.newTTFLabel({text = data.desc, size = 26, color = TEXT_CORLOR, dimensions = cc.size(600, 0)})
        :align(display.TOP_CENTER, cx, HEIGHT - 65)
        :addTo(bg)

    self:createEditBoxNode_(data.content)

    self.sendBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_btn_normal.png", pressed = "#holiday_btn_pressed.png", disabled = "#holiday_btn_disabled.png"}, {scale9 = true})
        :setButtonSize(230, 70)
        :setButtonLabel("normal", ui.newTTFLabel({text = data.btnName, size = 30, color = TEXT_CORLOR}))
        :pos(cx, 50)
        :onButtonClicked(buttontHandler(self, self.onSendClicked_))
        :addTo(bg)
end

function HolidayBlessingPopup:createEditBoxNode_(content)
    local input_w, input_h = 700, 260
    local bg = self
    local frame = display.newScale9Sprite("#holiday_input_bg.png", 0, 0, cc.size(input_w, input_h))
        :pos(WIDTH*0.5, 235)
        :addTo(bg)

    local input_x, input_y = input_w*0.5, input_h*0.5
    local editBox = ui.newEditBox({
        size = cc.size(input_w - 6, input_h - 6),
        image="#common/transparent.png",
        x = input_x,
        y = input_y,
        listener = handler(self, self.onEditBoxChange_)
    })
    editBox:setFontName(ui.DEFAULT_TTF_FONT)
    editBox:setFontSize(26)
    editBox:setMaxLength(120)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    editBox:addTo(frame)

    self.firstEditBox_ = editBox

    self.hintText_ = content
    self.showContent = ui.newTTFLabel({
            text = self.hintText_,
            size = 26,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions = cc.size(input_w - 50, input_h - 10)
        })
        :align(display.LEFT_CENTER, 10, input_y)
        :addTo(frame)
end

function HolidayBlessingPopup:onEditBoxChange_(event, editbox)
    if event == "began" then
        editbox:setText(self.showContent:getString())
        self.showContent:setString("")
    elseif event == "changed" then
    elseif event == "ended" then
        local str = editbox:getText()
        if string.trim(str) == "" then
            self.showContent:setString(self.hintText_)
        else
            self.showContent:setString(str)
        end
        editbox:setText("")
    elseif event == "return" then
    end
end

function HolidayBlessingPopup:onSendClicked_()
    local str = self.showContent:getString()
    local callback = self.callback_
    local needNum = self.data_.needNum
    sa.HttpService.POST({
        mod="Speaker",
        act="useSpeaker",
        msg = str,
        nick = tx.userData.nick or "",
    },
    function(data) 
        local callData = json.decode(data)

        if callData and callData.code == 1 then
            if callback then
                callback(needNum)
            end
        elseif callData and callData.code==-3 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "NOT_ENOUGH_LABA"))
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_BIG_LABA_MESSAGE_FAIL"))
        end
    end, function()
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_BIG_LABA_MESSAGE_FAIL"))
    end)

    self:hidePanel()
end

return HolidayBlessingPopup
