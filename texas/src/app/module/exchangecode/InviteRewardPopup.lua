-- 邀请码奖励提示弹窗
local InviteRewardPopup = class("InviteRewardPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570

function InviteRewardPopup:ctor(data, delegate)
    InviteRewardPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("ECODE", "INVITE_REWARD_TIPS_1"))

    self.delegate_ = delegate
    local frame_w, frame_h = 774, 310
    local x = WIDTH*0.5
    local frame = display.newSprite("img/invite_reward_frame.jpg")
        :align(display.BOTTOM_CENTER, x, 154)
        :addTo(self.background_)

    ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "INVITE_REWARD_TIPS_2", data.money, data.name, data.friGetMoney), size = 30, align = ui.TEXT_ALIGN_CENTER})
        :pos(frame_w*0.5, 41)
        :addTo(frame)

    cc.ui.UIPushButton.new({normal= "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(410, 146)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("ECODE", "INVITE_BTN_NAME"), size = 30}))
        :onButtonClicked(handler(self, self.onInviteClicked_))
        :pos(x, 92)
        :addTo(self.background_)
end

function InviteRewardPopup:onInviteClicked_()
    self.delegate_:goToInviteFriend()
    self:hidePanel()
end

return InviteRewardPopup