-- 邀请好友方式视图
local InviteFriendView = class("InviteFriendView", function()
    return display.newNode()
end)

local InvitePopup = import("app.module.facebookinvite.InvitePopup")
local ExchangeCodePopup = import("app.module.exchangecode.ExchangeCodePopup")
local InviteRewardRecordView = import(".InviteRewardRecordView")

local WIDTH, HEIGHT = 810, 380

function InviteFriendView:ctor(controller)
    self.this_ = self
    self.controller_ = controller
    self.controller_:getInviteRewardConfig(handler(self, self.addMainUI_))
end

function InviteFriendView:addMainUI_(data)
    if not self.this_ then return; end
    local bg = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER)
        :addTo(self)

    self.bg_ = bg

    -- local dir = 395
    -- local btn_x = 215

    -- self:addInviteButton_(
    --     "#dialogs/friend/friend_facenook_btn_normal.png",
    --     "#dialogs/friend/friend_facenook_btn_pressed.png",
    --     sa.LangUtil.getText("FRIEND", "INVITE_FB_FRIEND_TITLE"),
    --     "",-- sa.LangUtil.getText("FRIEND", "INVITE_FB_FRIEND_CONTENT", data.fbReward, data.fbSecReward),
    --     btn_x, buttontHandler(self, self.onFacebookInviteClicked_),
    --     35
    -- )

    local dir = 0
    local btn_x = 405
    self:addInviteButton_(
        "#dialogs/friend/friend_invite_code_btn_normal.png",
        "#dialogs/friend/friend_invite_code_btn_pressed.png",
        sa.LangUtil.getText("FRIEND", "INVITE_CODE_TITLE"),
        sa.LangUtil.getText("FRIEND", "INVITE_CODE_CONTENT", data.icodeReward, data.icodeSecReward),
        btn_x + dir, buttontHandler(self, self.onInviteCodeClicked_),
        0
    )

    InviteRewardRecordView.new(self.controller_, data)
        :pos(WIDTH/2, 42)
        :addTo(bg)
end

function InviteFriendView:addInviteButton_(normalImg, pressedImg, title, content, x, callback, offsety)
    local btn = cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg})
        :onButtonClicked(callback)
        :pos(x, HEIGHT/2 + 55)
        :addTo(self.bg_)

    ui.newTTFLabel({text = title, size = 28})
        :align(display.LEFT_CENTER, -60, 40 - offsety)
        :addTo(btn)

    ui.newTTFLabel({text = content, size = 16, align = ui.TEXT_ALIGN_LEFT})
        :align(display.LEFT_CENTER, -60, -20)
        :addTo(btn)
end

function InviteFriendView:onFacebookInviteClicked_()
    InvitePopup.new():showPanel()

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "fb_invite_friends", label = "fb_invite_friends"}
        }
    end
end

function InviteFriendView:onInviteCodeClicked_()
    ExchangeCodePopup.new():showPanel()

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "invite_code_friends", label = "invite_code_friends"}
        }
    end
end

return InviteFriendView