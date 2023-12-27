local EnterRommPwdPop = class("EnterRommPwdPop", tx.ui.Panel)

local logger = sa.Logger.new("EnterRommPwdPop")
local KeyboardView = import("app.module.keyboard.KeyboardView")

local WIDTH, HEIGHT = 600, 750

function EnterRommPwdPop:ctor(callback)
	EnterRommPwdPop.super.ctor(self,{WIDTH, HEIGHT})
    self.callback_ = callback

	self:setTextTitleStyle(sa.LangUtil.getText("PRIVTE","PWDPOPTITLE"))
    if self.title_ then
        sa.fitSprteWidth(self.title_, 350)
    end
    local input_x, input_y = 0, 210

    display.newScale9Sprite("#common/common_edit_box_bg.png", 0, 0, cc.size(536, 68))
        :pos(input_x, input_y)
        :addTo(self)

    self.pwdLabel_ = ui.newTTFLabel({text = "", size = 32, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(input_x, input_y)
        :addTo(self)

    self.cursor_ = display.newSprite("#common/common_input_cursor.png")
        :pos(input_x, input_y)
        :addTo(self)

    self:startBlink_()

    KeyboardView.new(false)
        :pos(0, -30)
        :addTo(self)

    self.tip_ = ui.newTTFLabel({text = sa.LangUtil.getText("PRIVTE","PWDPOPTIPS"),size = 22,color = cc.c3b(0xEE, 0x0, 0x0)})
        :pos(0,-HEIGHT*0.5+111)
        :hide()
        :addTo(self)

    cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png"},{scale9 = true})
        :setButtonSize(240, 104)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON","CONFIRM"),size = 28,color = cc.c3b(0xff, 0xff, 0xff)}))
        :pos(0, -HEIGHT*0.5 + 85)
        :addTo(self)
        :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))

    self.onEnterListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_ENTER, handler(self, self.onEnterClicked_))
    self.onNumChangedListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_NUM_CHANGED, handler(self, self.onNumChanged_))
end

function EnterRommPwdPop:startBlink_()
    self.cursor_:show():runAction(cc.RepeatForever:create(cc.Blink:create(1, 1)))
end

function EnterRommPwdPop:stopBlink_()
    self.cursor_:hide():stopAllActions()
end

function EnterRommPwdPop:onConfirmClicked_()
    local pwd = self.pwd_
    local callback = self.callback_
    if not pwd or string.trim(pwd)=="" then
        self.step_ = 0
        self.tip_:show()
        self:stopAllActions()
        self:schedule(function()
            self.step_ = self.step_ + 1
            if self.step_>10 then
                self.tip_:hide()
                self:stopAllActions()
                return
            end

            if self.step_%2==0 then
                self.tip_:show()
            else
                self.tip_:hide()
            end
        end, 0.2)

        return
    end

    self:hidePanel()

    if callback then
        callback(pwd)
    end
end

function EnterRommPwdPop:onEnterClicked_()
    self:onConfirmClicked_()
end

function EnterRommPwdPop:onNumChanged_(evt)
    self.pwd_ = evt.data
    local text = evt.data
    self:stopBlink_()
    if text == "" then
        -- text = sa.LangUtil.getText("PRIVTE", "PWDPOPINPUT")
        self:startBlink_()
    end

    self.pwdLabel_:setString(text)
end

function EnterRommPwdPop:onCleanup()
    self:stopAllActions()
    sa.EventCenter:removeEventListener(self.onEnterListenerId_)
    sa.EventCenter:removeEventListener(self.onNumChangedListenerId_)
end

return EnterRommPwdPop