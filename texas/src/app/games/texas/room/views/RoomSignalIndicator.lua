local RoomSignalIndicator = class("RoomSignalIndicator", function() return display.newNode() end)

function RoomSignalIndicator:ctor()
    self.signalIcon1_ = display.newSprite("#commonroom/signal1.png", -15, -6)
    self.signalIcon2_ = display.newSprite("#commonroom/signal2.png", -5, -4)
    self.signalIcon3_ = display.newSprite("#commonroom/signal3.png", 5, -2)
    self.signalIcon4_ = display.newSprite("#commonroom/signal4.png", 15, 0)
    local size = self.signalIcon4_:getContentSize()
    size.width =  36
    self.signalWidth_,self.signalHeight_ = size.width,size.height
    self.perWidth_ = self.signalWidth_*0.25
    --遮罩
    local viewClipNode_ = cc.ClippingNode:create():addTo(self)
    local stencil = display.newDrawNode()
    stencil:drawPolygon({
             {-self.signalWidth_/2, -self.signalHeight_/2},
             {-self.signalWidth_/2, self.signalHeight_/2},
             {self.signalWidth_/2, self.signalHeight_/2},
             {self.signalWidth_/2, -self.signalHeight_/2}
        })
    viewClipNode_:setStencil(stencil)
    viewClipNode_:addChild(self.signalIcon1_)
    viewClipNode_:addChild(self.signalIcon2_)
    viewClipNode_:addChild(self.signalIcon3_)
    viewClipNode_:addChild(self.signalIcon4_)

    self.signalNode_ = viewClipNode_

    self.stencil_ = stencil

    self.isFlashing_ = false

    self.wifiNode_ = display.newNode():addTo(self)
    self.wifiIcon_1 = display.newSprite("#commonroom/wifi1.png", 0, 0)
        :addTo(self.wifiNode_)
    self.wifiIcon_2 = display.newSprite("#commonroom/wifi2.png", 0, 0)
        :addTo(self.wifiNode_)
    self.wifiIcon_3 = display.newSprite("#commonroom/wifi3.png", 0, 0)
        :addTo(self.wifiNode_)
    self.wifiIcon_4 = display.newSprite("#commonroom/wifi4.png", 0, 0)
        :addTo(self.wifiNode_)
    self:dealSignalShow()
end

function RoomSignalIndicator:dealSignalShow()
    local netState = network.getInternetConnectionStatus()
    if netState == cc.kCCNetworkStatusReachableViaWiFi then
        self.wifiNode_:show()
        self.signalNode_:hide()
    else
        self.wifiNode_:hide()
        self.signalNode_:show()
    end
end

function RoomSignalIndicator:reSetMask(num)
    if not num or num<2 then
        num = 2
    end
    self.stencil_:clear()
    self.stencil_:drawPolygon({
         {-self.signalWidth_/2, -self.signalHeight_/2},
         {-self.signalWidth_/2, self.signalHeight_/2},
         {-self.signalWidth_/2+self.perWidth_*num, self.signalHeight_/2},
         {-self.signalWidth_/2+self.perWidth_*num, -self.signalHeight_/2}
    })
    for i=1,4,1 do
        local wifiIcon = self["wifiIcon_"..i]
        if wifiIcon then
            if i>num then
                wifiIcon:hide()
            else
                wifiIcon:show()
            end
        end
    end
end

function RoomSignalIndicator:setSignalStrength(strength)
    -- if strength>2 then
    --     self.signalIcon_:setSpriteFrame(display.newSpriteFrame("room_signal_normal.png"))
    -- else
    --     self.signalIcon_:setSpriteFrame(display.newSpriteFrame("room_signal_abnormal.png"))
    -- end
    self:dealSignalShow()
    self:reSetMask(strength)
    self:flash_(strength == 0)
end

function RoomSignalIndicator:flash_(isFlash)
    if self.isFlashing_ ~= isFlash then
        self.isFlashing_ = isFlash
        self:stopAllActions();
        if isFlash then
            self:runAction(cc.RepeatForever:create(transition.sequence({
                cc.Show:create(),
                cc.DelayTime:create(0.8),
                cc.Hide:create(),
                cc.DelayTime:create(0.6)
            })))
        else
            self:show()
        end
    end
end

return RoomSignalIndicator