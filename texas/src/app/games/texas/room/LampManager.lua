local LampManager = class("LampManager")
local RoomViewPosition = import(".views.RoomViewPosition")
local log = sa.Logger.new("LampManager")

function LampManager:ctor()
end

function LampManager:createNodes()
    self.lamp_ = display.newSprite("#texas/room/room_table_light.png", display.cx, display.cy)
    self.lamp_:setAnchorPoint(cc.p(0.5, 1))
    self.lamp_:setScaleX(1.5)
    self.lamp_:addTo(self.scene.nodes.lampNode)
    self.lampDefaultH_ = self.lamp_:getContentSize().height
    self.lamp_:hide()
    self.lampPostionId_ = 1
    self:turnTo(1, false)
    log:debug("lamp image default height is " .. self.lampDefaultH_)
end

function LampManager:show()
    self.lamp_:show()
end

function LampManager:hide()
    self.lamp_:hide()
end

function LampManager:getPositionId()
    return self.lampPostionId_ or 1
end

function LampManager:turnTo(positionId, animation)
    local seatPos = RoomViewPosition.SeatPosition[positionId]
    if not seatPos then
        seatPos = RoomViewPosition.SeatPosition[1]
        self.lampPostionId_ = 1
    else
        self.lampPostionId_ = positionId
    end
    local offSetX = 0
    local offSetY = 0
    if positionId==5 then
        if self.model and self.model:isSelfInSeat() then
            offSetX = RoomViewPosition.SelfOffsetX
            offSetY = RoomViewPosition.SelfOffsetY
        end
    end
    log:debug("lamp turn to seatPostion " .. self.lampPostionId_ .. (animation and " with animation" or ""))
    
    local seatPosX = seatPos.x + offSetX
    local seatPosY = seatPos.y + offSetY
    local lampPosX = self.lamp_:getPositionX()
    local lampPosY = self.lamp_:getPositionY()
    local angleH = math.radian2angle(math.atan((seatPosX - lampPosX) / (seatPosY - lampPosY)))
    if lampPosX > seatPosX then
        if angleH > 0 then
            angleH = angleH - 180
        end
    else
        if angleH <= 0 then
            angleH = angleH + 180
        end
    end
    local seatLightScale = ((seatPosX - lampPosX)^2 + (seatPosY - lampPosY)^2)^0.5 / self.lampDefaultH_
    --print(seatPosX, seatPosY, lampPosX, lampPosY, angleH)
    self:setLampRotation(animation, angleH, seatLightScale)
end

local function toRange360(rotation)
    if rotation >= 360 then
        while true do
            rotation = rotation - 360
            if rotation < 360 then
                return rotation
            end
        end
    elseif rotation < 0 then
        while true do
            rotation = rotation + 360
            if rotation >= 0 then
                return rotation
            end
        end
    end
    return rotation
end

function LampManager:setLampRotation(animation, rotation, scale)
    -- --print("rotation:" .. rotation .. " scale:" .. scale)
    -- if animation then
    --     self.lamp_:stopAllActions()
    --     local curRot = self.lamp_:getRotation()
    --     local dstRot = toRange360(rotation - 180)
    --     if math.abs(dstRot - curRot) > 180 then
    --         if curRot < 180 then
    --             dstRot = dstRot - 360
    --         else
    --             dstRot = dstRot + 360
    --         end
    --     end
    --     transition.scaleTo(self.lamp_, {scaleY=scale, time=0.5})
    --     transition.rotateTo(self.lamp_, {rotate=dstRot, time=0.5})
    -- else
    --     self.lamp_:setRotation(rotation - 180)
    --     self.lamp_:setScaleY(scale)
    -- end
    if self.lamp_:isVisible() then
        local curRot = self.lamp_:getRotation()
        if curRot==(rotation - 180) then return; end
        self.lamp_:stopAllActions()
        local scaleAction = cc.ScaleTo:create(0.2, 0.3, 0.2)
        local fadeAction = cc.FadeTo:create(0.2, 0)
        local spawn = cc.Spawn:create(scaleAction, fadeAction)
        local sequence = transition.sequence({
            spawn,
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function() 
                self.lamp_:setOpacity(255)
                self.lamp_:setRotation(rotation - 180)
                self.lamp_:setScaleX(1)
                self.lamp_:setScaleY(scale*1.25)
            end),
        })
        self.lamp_:runAction(sequence)
    else
        self.lamp_:stopAllActions()
        self.lamp_:setOpacity(255)
        self.lamp_:setRotation(rotation - 180)
        self.lamp_:setScaleX(1)
        self.lamp_:setScaleY(scale*1.25)
    end
end

function LampManager:dispose()
end

return LampManager