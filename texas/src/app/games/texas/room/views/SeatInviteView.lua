-- 新版邀请好友
local SeatInviteView = class("SeatInviteView", function() 
    return display.newNode()
end)

local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local InviteFriendPopup = import("app.module.room.inviteplay.InviteFriendPopup")

local WIDTH, HEIGHT = 124, 186

function SeatInviteView:ctor(ctx)
	self.ctx_ = ctx

    self.this_ = self

    self:createNode_()

    self:hide()
end

function SeatInviteView:createNode_()
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)
    local x, y = WIDTH*0.5, HEIGHT*0.5

	display.newScale9Sprite("#texas/room/room_seat_bg.png", x, y, cc.size(WIDTH, HEIGHT)):addTo(self)
    
    self.avatarNode_ = SimpleAvatar.new({
            shapeImg = "#common/modal_texture.png",
            frameImg = "#common/transparent.png",
            scale9 = 1,
            offsetSize = 0,
            size = WIDTH
        })

    local rect = cc.rect(-WIDTH*0.5, -WIDTH*0.5, WIDTH, WIDTH)
    self.clipNode_ = display.newClippingRectangleNode(rect)
        :pos(x, y)
        :addTo(self)

    self.clipNode_:addChild(self.avatarNode_)

    local label = ui.newTTFLabel({text=sa.LangUtil.getText("FRIEND", "SEND_INVITE"), size=20})
    sa.fitSprteWidth(label, 70)
    local btn = cc.ui.UIPushButton.new({normal = "#texas/room/invite_btn_normal.png", pressed = "#texas/room/invite_btn_pressed.png"}, {scale9 = true})
        :onButtonClicked(buttontHandler(self, self.onInviteClicked_))
        :setButtonSize(126, 50)
        :setButtonLabel(label)
        :setButtonLabelAlignment(display.LEFT_CENTER)
        :setButtonLabelOffset(-15, 0)
        :pos(x, 20)
        :addTo(self)

    display.newSprite("#texas/room/invite_btn_icon.png")
        :pos(-35, 0)
        :addTo(btn)
end

function SeatInviteView:onInviteClicked_()
    InviteFriendPopup.new():showPanel()

    self:hide()
    self:performWithDelay(function ()
        self:updateViewPosition()
    end, 20)
end

--旋转以后，需要更新位置
function SeatInviteView:updateViewPosition()
    if self.ctx_.model and self.ctx_.model:isSelfInSeat() and self.ctx_.model:getNumInSeat() < 6 then
        local seatView = self.ctx_.seatManager:getSeatView(7) --固定显示7号座位
        local x, y = seatView:getPosition()
        self:show()
        self:pos(x, y)
    else
        self:hide()
    end
end

return SeatInviteView