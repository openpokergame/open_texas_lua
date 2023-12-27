local AnimManagerBase = import("app.games.AnimManagerBase")
local AnimManager = class("AnimManager", AnimManagerBase)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomViewPosition = import(".views.RoomViewPosition")
local BetTipsView = import(".views.BetTipsView")

local ExpressionConfig = import("app.module.room.chat.ExpressionConfig").new()
local RoomChatBubble = import("app.module.room.chat.RoomChatBubble")

local SeatPosition = RoomViewPosition.SeatPosition

function AnimManager:ctor()
    AnimManager.super.ctor(self)
end

function AnimManager:createNodes()
    AnimManager.super.createNodes(self)
    local node =  self.animNode_

    -- self.vsAnimation_ = sp.SkeletonAnimation:create("spine/JYdaxiang.json","spine/JYdaxiang.atlas")
    --     :pos(display.cx, display.cy)
    --     :addTo(node, 1)
    --     :hide()

    -- self.vsAnimation_:registerSpineEventHandler(function()
    --     self.vsAnimation_:hide()
    -- end, sp.EventType.ANIMATION_COMPLETE)

    self.betTipsView_ = BetTipsView.new()
        :align(display.TOP_CENTER, display.cx, SeatPosition[1].y - 68)
        :addTo(node)
        :hide()
end

--加好友
function AnimManager:playAddFriendAnimation(fromSeatId, toSeatId, extraData)
    local fromPositionId = self.seatManager:getPosition(fromSeatId, extraData.fromUid)
    local toPositionId = self.seatManager:getPosition(toSeatId, extraData.toUid)

    local sx, sy = 0, display.top
    if fromPositionId then
        sx, sy = SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y
    end

    local ex, ey = SeatPosition[toPositionId].x,SeatPosition[toPositionId].y

    AnimManager.super.playAddFriendAnimation(self, sx, sy, ex, ey)
end

--发表情
function AnimManager:playExpression(uid, expressionId, time)
    AnimManager.super.playExpression(self, uid, expressionId, time)
end

function AnimManager:playExpressionAnim_(uid, expressionId, anim)
    local config = ExpressionConfig:getConfig(expressionId)
    local seatId = self.ctx.model:getSeatIdByUid(uid)
    local positionId = self.seatManager:getPosition(seatId, uid)
    local p = SeatPosition[positionId]

    local px, py = p.x + config.offsetX, p.y + config.offsetY

    -- 展示缩放
    local finalScale = 1
    local index = self:getExpressionType_(expressionId)
    if index ~= 1 then
        finalScale = 0.6
    end

    AnimManager.super.playExpressionAnim_(self, px, py, finalScale, expressionId, anim)
end

--播放VS动画
function AnimManager:playStartAnimation()
    tx.SoundManager:playSound(tx.SoundManager.REDBLACK_VS)

    self.ctx.dealCardManager:hideElephantIcon()

    -- if self.vsAnimation_ and self.vsAnimation_:findAnimation(7) then
    --     self.vsAnimation_:initialize()
    --     self.vsAnimation_:show():setAnimation(0, 7, false)
    --     self.vsAnimation_:stopAllActions()
    --     self.vsAnimation_:performWithDelay(function()
    --         self.vsAnimation_:hide()
    --     end,1)
    -- end

    if self.playElephantId_ then
        scheduler.unscheduleGlobal(self.playElephantId_)
        self.playElephantId_ = nil
    end

    self.playElephantId_ = scheduler.performWithDelayGlobal(function()
        self.ctx.dealCardManager:playElephantEnterAnimation()
    end, 1)

    local emitter = cc.ParticleSystemQuad:create("particle/redblack_vs.plist")
        :pos(display.cx, display.cy)
        :addTo(self.animNode_)
    emitter:setAutoRemoveOnFinish(true)
end

--游戏结束动画
function AnimManager:playGameOverAnimation(callbcak)
    self.betTipsView_:setTipsSetp(2, function()
        if callbcak then
            callbcak()
        end
    end)
end

--游戏下注动画
function AnimManager:playBetAnimation(callbcak)
    self.betTipsView_:setTipsSetp(1, function()
        if callbcak then
            callbcak()
        end
    end)
end

-- 播放语音聊天
function AnimManager:playVoiceChat(uid, voiceData)
    local seatId = self.ctx.model:getSeatIdByUid(uid)
    local positionId = self.seatManager:getPosition(seatId, uid)
    local p = SeatPosition[positionId]

    if p and positionId ~= 10 then
        AnimManager.super.playVoiceChat(self, p.x, p.y, voiceData)
    end
end

--显示聊天消息
function AnimManager:showChatMsg(uid, message, vipLevel)    
    local seatId = self.ctx.model:getSeatIdByUid(uid)
    local positionId = self.seatManager:getPosition(seatId, uid)
    local p = SeatPosition[positionId]
    if p then
        local px, py = p.x, p.y
        local dir
        if (positionId >= 5 and positionId <=8) or positionId == 10 then
            dir = RoomChatBubble.DIRECTION_RIGHT
            px = p.x + 16
        else
            dir = RoomChatBubble.DIRECTION_LEFT
            px = p.x - 16
        end

        AnimManager.super.showChatMsg(self, px, py, dir, message, vipLevel)
    end
end

function AnimManager:playHddjAnimation(fromSeatId, toSeatId, hddjId, extraData)
    local fromPositionId = self.seatManager:getPosition(fromSeatId, extraData.fromUid)
    local toPositionId = self.seatManager:getPosition(toSeatId, extraData.toUid)

    AnimManager.super.playHddjAnimation(self, fromPositionId, toPositionId, hddjId, tx.userData.uid == extraData.toUid)
end

function AnimManager:dispose()
    if self.playElephantId_ then
        scheduler.unscheduleGlobal(self.playElephantId_)
        self.playElephantId_ = nil
    end

    AnimManager.super.dispose(self)
end

function AnimManager:reset()
    self.betTipsView_:reset()

    if self.playElephantId_ then
        scheduler.unscheduleGlobal(self.playElephantId_)
        self.playElephantId_ = nil
    end
end

return AnimManager