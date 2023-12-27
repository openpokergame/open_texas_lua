local HddjController = class("HddjController")
local RoomViewPosition = import(".views.RoomViewPosition")
local SeatPosition = RoomViewPosition.SeatPosition

local selfOffX = RoomViewPosition.SelfOffsetX
local selfOffY = RoomViewPosition.SelfOffsetY
local selfOffScale = RoomViewPosition.SelfScale
function HddjController:ctor(container)
    RoomViewPosition = require("app.games.texas.room.views.RoomViewPosition")
    SeatPosition = RoomViewPosition.SeatPosition
    selfOffX = RoomViewPosition.SelfOffsetX
    selfOffY = RoomViewPosition.SelfOffsetY
    selfOffScale = RoomViewPosition.SelfScale

    if _G.curInGameId == 4 then --红黑
        RoomViewPosition = require("app.games.redblack.room.views.RoomViewPosition")
        SeatPosition = RoomViewPosition.SeatPosition
        RoomViewPosition.SelfScale = 1
        selfOffX = 0
        selfOffY = 0
        selfOffScale = 1
    end

    self.container_ = container
    self.loadedHddjIds_ = {}
    self.loadingHddj_ = {}
    self.cachedSpineData_ = {}
    self.zorder_ = 0
end

function HddjController:dispose()
    for k, v in pairs(self.loadedHddjIds_) do
        display.removeAnimationCache("hddjAnim" .. k)
        display.removeSpriteFramesWithFile("hddjs/hddj-" .. k .. ".plist", "hddjs/hddj-" .. k .. ".png")
    end
    self.loadedHddjIds_ = nil
    self.loadingHddj_ = nil
    self.cachedSpineData_ = nil
    self.isDisposed_ = true
end

function HddjController:playHddj(fromPositionId, toPositionId, hddjId, isSelf)
    if self.isDisposed_ then
        return
    end

    if fromPositionId == nil or toPositionId == nil then
        return
    end

    return self:playSpineAnim(hddjId, fromPositionId, toPositionId, isSelf)
end

HddjController.hddjConfig = {
    [1] = {curvePath=true,rotation=3},
    [2] = {frameNum=13, x=35, y=30, iconX=35 + 48, iconY=30 + 38, soundDelay=0.2, endIconX=75},
    [3] = {frameNum=14, },
    [5] = {frameNum=12, y=12},
    [6] = {frameNum=14, iconScale=0.8, curvePath=true, delay=0, rotation=3, x=0, y=-10, iconX=0, iconY=10, soundDelay=0.2},
    [7] = {frameNum=13, scale=1.6, iconScale=1.6, x=0, y=10, iconX=-38 * 1.6, iconY=-20},
    [8] = {frameNum=15, x=-4, y=0, iconX=44, iconY=26, soundDelay=0.05},
    [9] = {frameNum=17, delay=0, x=0, y=0, iconX=0, iconY=0},
    [11] = {frameNum=10, x = 22, iconX = 22, soundDelay=0.2},
    [12] = {},
    [13] = {},
    [14] = {curvePath=true,rotation=1},
}

function HddjController:playSpineAnim(hddjId, fromPositionId, toPositionId, isSelf)
    local container = nil
    for k,v in pairs(self.cachedSpineData_) do
        if not v:isVisible() then
            container = v
        end
    end

    if not container then
        container = display.newNode():addTo(self.container_)
        container.anim_ = sp.SkeletonAnimation:create("spine/hudongdaojv.json","spine/hudongdaojv.atlas")
            :addTo(container)
        container.anim_:hide()
        table.insert(self.cachedSpineData_,container)
    end

    if not container.anim_:findAnimation("H"..hddjId) then
        return
    end

    self.zorder_ = self.zorder_ + 1

    container:zorder(self.zorder_)
    container:show()
    container:stopAllActions()
    local iconScale = 1--1/RoomViewPosition.SelfScale
    local animScale = 1
    local xx,yy = SeatPosition[toPositionId].x,SeatPosition[toPositionId].y
    if isSelf then
        iconScale = 1
        animScale = RoomViewPosition.SelfScale
        xx = xx + selfOffX
        yy = yy + selfOffY
    end

    local config = HddjController.hddjConfig[hddjId] or {}
    local icon = display.newSprite("#hddj_" .. hddjId .. ".png"):scale(1)
    icon:pos(SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y)
    icon:addTo(container)
    if config.curvePath then
        local distance = cc.pGetDistance(cc.p(SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y), cc.p(xx + (config.spineIconX or 0), yy + (config.spineIconY or 0)))
        local bconfig = {}
        --controlPoint_1
        bconfig[1] = cc.p((SeatPosition[fromPositionId].x + xx + (config.spineIconX or 0)) * 0.5, (SeatPosition[fromPositionId].y + yy + (config.spineIconY or 0)) * 0.5 + distance * 0.16)
        --controlPoint_2
        bconfig[2] = cc.p((SeatPosition[fromPositionId].x + xx + (config.spineIconX or 0)) * 0.5, (SeatPosition[fromPositionId].y + yy + (config.spineIconY or 0)) * 0.5 + distance * 0.16)
        --endPosition
        bconfig[3] = cc.p(xx + (config.spineIconX or 0) + (config.endIconX or 0), yy + (config.spineIconY or 0))
        icon:runAction(transition.sequence({
            cc.EaseInOut:create(cc.BezierTo:create(1, bconfig), 2),
            cc.DelayTime:create(config.delay or 0.1),
            cc.CallFunc:create(function()
                icon:removeFromParent()
                if not config.soundDelay then
                    tx.SoundManager:playHddjSound(hddjId)
                end
            end)
        }))
        icon:scaleTo(1,1*iconScale)
    else
        icon:runAction(transition.sequence({
            cc.EaseOut:create(cc.MoveTo:create(1, cc.p(xx + (config.spineIconX or 0) + (config.endIconX or 0), yy + (config.spineIconY or 0))), 1),
            cc.DelayTime:create(config.delay or 0.1),
            cc.CallFunc:create(function()
                icon:removeFromParent()
                if not config.soundDelay then
                    tx.SoundManager:playHddjSound(hddjId)
                end
            end)
        }))
        icon:scaleTo(1,1*iconScale)
    end

    if config.rotation then
        if SeatPosition[fromPositionId].x < xx then
            icon:rotateBy(1, 360 * config.rotation)
        else
            icon:rotateBy(1, -360 * config.rotation)
        end
    end

    container:performWithDelay(function()
            if self.isDisposed_ then
                return
            end
            container.anim_:pos(xx, yy)
            container.anim_:setScale(1*animScale)
            container.anim_:setAnimation(0, "H"..hddjId, false)
            container.anim_:show()
            container.anim_:registerSpineEventHandler(function (event)
                container.anim_:hide()
                container:hide()
            end, sp.EventType.ANIMATION_COMPLETE)
        end,
        1 + (config.delay or 0.1)
    )

    if config.soundDelay then
        container:runAction(transition.sequence({
            cc.DelayTime:create(1 + (config.delay or 0.1) + config.soundDelay),
            cc.CallFunc:create(function()
                tx.SoundManager:playHddjSound(hddjId)
            end)
        }))
    end
end

function HddjController:changeSeatPosition(isDealer)
    if isDealer then
        SeatPosition[5] = RoomViewPosition.SelfSeatPosition[1]
    else
        SeatPosition[5] = RoomViewPosition.SelfSeatPosition[2]
    end
end

return HddjController