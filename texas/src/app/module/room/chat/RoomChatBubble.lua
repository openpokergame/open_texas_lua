local RoomChatBubble = class("RoomChatBubble", function() return display.newNode() end)

RoomChatBubble.DIRECTION_LEFT = 1
RoomChatBubble.DIRECTION_RIGHT = 2

local VIP_BUBBLE = {
    "#commonroom/vip_chat_bubble_1.png",
    "#commonroom/vip_chat_bubble_2.png",
    "#commonroom/vip_chat_bubble_3.png",
    "#commonroom/vip_chat_bubble_4.png"
}

local NORMAL_BUBBLE = "#commonroom/chat_bubble1.png"
local VOICE_BUBBLE = "#commonroom/chat_bubble2.png"

function RoomChatBubble:ctor(label, direction)
    self.labelData_ = label
    self.directionData_ = direction
end

function RoomChatBubble:show(parent, x, y, vipLevel)
    if self:getParent() then
        self:removeFromParent()
    end
    self:pos(x, y):addTo(parent)

    local label = self.labelData_
    local direction = self.directionData_
    local img = NORMAL_BUBBLE
    vipLevel = vipLevel or 0
    if vipLevel > 0 then
        img = VIP_BUBBLE[vipLevel]
    end

    if direction == RoomChatBubble.DIRECTION_LEFT then
        if string.find(label, "@") then
            self.background_ = display.newScale9Sprite(VOICE_BUBBLE)
        else
            self.background_ = display.newScale9Sprite(img)
        end
    else
        if string.find(label, "@") then
            self.background_ = display.newScale9Sprite(VOICE_BUBBLE)
        else
            self.background_ = display.newScale9Sprite(img)
        end
        self.background_:setScaleX(-1)
    end
    self.background_:setCapInsets(cc.rect(40, 30, 5, 20))
    self.background_:addTo(self)

    if appconfig.LANG == "vn" then
        self.label_ = ui.newTTFLabel({text=label, size=18, color=cc.c3b(0x1d, 0x50, 0xad), align=ui.TEXT_ALIGN_CENTER})
            :addTo(self)
    else
        self.label_ = ui.newTTFLabel({text=label, size=22, color=cc.c3b(0x1d, 0x50, 0xad), align=ui.TEXT_ALIGN_CENTER})
            :addTo(self)
    end
    if string.find(label, "@") then
        self.label_:setTextColor(cc.c3b(0x96, 0x3c, 0x00))
    end
    self.label_:setAnchorPoint(cc.p(0.5, 0.5))
    if self.label_:getContentSize().width > 220 then
        self.label_:setDimensions(220, 0)
    end
    local lbsize = self.label_:getContentSize()
    local bgw = math.max(70, lbsize.width + 30)
    local bgh = math.max(lbsize.height + 40, 74)
    self.background_:setContentSize(cc.size(bgw, bgh))

    if direction == RoomChatBubble.DIRECTION_LEFT then
        self.background_:pos(bgw * 0.5, bgh * 0.5 - 16)
        self.label_:pos(bgw * 0.5, math.floor((bgh - 16) * 0.5-3))
    else
        self.background_:pos(bgw * -0.5, bgh * 0.5 - 16)
        self.label_:pos(bgw * -0.5, math.floor((bgh - 16) * 0.5-3))
    end

    if vipLevel > 0 then
        display.newSprite("#commonroom/vip_mark_icon.png")
            :pos(20, bgh - 8)
            :addTo(self.background_)
    end
end

return RoomChatBubble