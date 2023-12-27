local AnimManagerBase = class("AnimManagerBase")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local ExpressionConfig = import("app.module.room.chat.ExpressionConfig").new()
local VoicePlayAnim = import("app.pokerUI.VoicePlayAnim")
local RoomChatBubble = import("app.module.room.chat.RoomChatBubble")
local HddjController = import("app.games.texas.room.HddjController")
local SendChipView = import("app.games.texas.room.views.SendChipView")

function AnimManagerBase:ctor()
end

function AnimManagerBase:createNodes()
    self.animNode_ = self.scene.nodes.animNode
    self.hddjController_ = HddjController.new(self.animNode_)
end

function AnimManagerBase:playAddFriendAnimation(sx, sy, ex, ey)
    local sp = display.newSprite("#room_add_friend.png")
        :pos(sx, sy)
        :addTo(self.animNode_)

    transition.moveTo(sp, {
        time = 2,
        easing = "exponentialInOut",
        x = ex,
        y = ey,
        onComplete = function()
            sp:removeFromParent()
        end,
    })
end

function AnimManagerBase:playSendChipAnimation(sx, sy, ex, ey, chips, callback)
    local sp = SendChipView.new(chips)
        :pos(sx, sy)
        :addTo(self.animNode_)

    transition.moveTo(sp, {
        time = 2,
        easing = "exponentialInOut",
        x = ex,
        y = ey,
        onComplete = function()
            sp:removeFromParent()
            if callback then
                callback()
            end
        end,
    })
end

function AnimManagerBase:playHddjAnimation(fromPositionId, toPositionId, hddjId, isSelf)
    self.hddjController_:playHddj(fromPositionId, toPositionId, hddjId, isSelf)
end

-- 播放语音聊天
function AnimManagerBase:playVoiceChat(x, y, voiceData)
    local voiceBubble = display.newSprite("#common/microphone_chat_bg.png")
        :pos(x, y)
        :addTo(self.animNode_)

    VoicePlayAnim.new(voiceData, 1, voiceBubble):pos(40, 45):addTo(voiceBubble)
end

function AnimManagerBase:playExpression(waitId, expressionId, time)
    if not self.sendExpressions_ then
        self.sendExpressions_ = {}
        self.loadingExpressions_ = {}
        self.waitPlay_ = {}
        self.loadedExpressions_ = {}
    end

    local animName = "expression" .. expressionId
    local anim = display.getAnimationCache(animName)
    if anim then
        self:playExpressionAnim_(waitId, expressionId, anim)
    else
        if not self.waitPlay_[animName] then
            self.waitPlay_[animName] = {}
        end
        table.insert(self.waitPlay_[animName], waitId)
        if not self.loadingExpressions_[animName] then
            self.loadingExpressions_[animName] = true
            local index = self:getExpressionType_(expressionId)
            if index == 3 then
                display.addSpriteFrames("expressionsbtns_3.plist", "expressionsbtns_3.png", function()
                    local config = ExpressionConfig:getConfig(expressionId)
                    local animation = cc.Animation:create()
                    local frame = display.newSpriteFrame("expression_btn_"..expressionId..".png")
                    animation:addSpriteFrame(frame)
                    animation:setDelayPerUnit(1 / 3)
                    display.setAnimationCache(animName, animation)
                    table.insert(self.loadedExpressions_, animName)
                    local toPlay = self.waitPlay_[animName]
                    while #toPlay > 0 do
                        local waitId = table.remove(toPlay, 1)
                        self:playExpressionAnim_(waitId, expressionId, animation)
                     end
                end)
                return
            end

            display.addSpriteFrames("expressions/expression" .. expressionId ..".plist", "expressions/expression" .. expressionId ..".png", function()
                if self.disposed_ then
                    self.loadingExpressions_[animName] = nil
                    display.removeSpriteFramesWithFile("expressions/expression" .. expressionId ..".plist", "expressions/expression" .. expressionId ..".png")
                    return
                end
                local config = ExpressionConfig:getConfig(expressionId)
                local frames = display.newFrames("expression" .. expressionId .. "_%d.png", 1, config.frameNum, false)
                local animation = display.newAnimation(frames, time or 1 / 12)
                display.setAnimationCache(animName, animation)
                table.insert(self.loadedExpressions_, animName)
                local toPlay = self.waitPlay_[animName]
                while #toPlay > 0 do
                    local waitId = table.remove(toPlay, 1)
                    self:playExpressionAnim_(waitId, expressionId, animation)
                end

                self.waitPlay_[animName] = nil
                self.loadingExpressions_[animName] = nil
             end)
        end
    end
end

function AnimManagerBase:playExpressionAnim_(px, py, finalScale, expressionId, anim)
    local sp = display.newSprite()
        :scale(finalScale)
        :pos(px, py)
        :addTo(self.animNode_)
    table.insert(self.sendExpressions_, sp)

    local index = self:getExpressionType_(expressionId)
    if index == 3 then
        sp:setScale(0.8*finalScale)
        sp:runAction(cc.RepeatForever:create(transition.sequence({
            transition.scaleTo(sp, {scale = finalScale,time = 0.3}),
            transition.scaleTo(sp, {scale = 0.8*finalScale,time = 0.3}),
        })))
    end

    transition.playAnimationForever(sp, anim)
    sp:runAction(transition.sequence({
    cc.DelayTime:create(3),
    cc.CallFunc:create(function() 
        sp:removeFromParent()
        table.removebyvalue(self.sendExpressions_, sp, true)
    end)}))
end

--显示聊天消息
function AnimManagerBase:showChatMsg(px, py, dir, message, vipLevel)
    --删除之前还在显示的消息
    if self.chatBubble_ then
        self.chatBubble_:stopAllActions()
        self.chatBubble_:removeFromParent()
    end

    local bubble = RoomChatBubble.new(message, dir)
    bubble:show(self.animNode_, px, py, vipLevel)

    self.chatBubble_ = bubble
    self.chatBubble_:runAction(transition.sequence({cc.DelayTime:create(5), cc.CallFunc:create(function() 
        self.chatBubble_:removeFromParent()
        self.chatBubble_ = nil
    end)}))
end

function AnimManagerBase:getExpressionType_(expressionId)
    return tonumber(string.sub(expressionId, 1, 1)) or 1
end

function AnimManagerBase:dispose()
    display.removeSpriteFramesWithFile("expressionsbtns_3.plist", "expressionsbtns_3.png")
    if self.loadedExpressions_ and #self.loadedExpressions_ > 0 then
        while #self.loadedExpressions_ > 0 do
            local animName = table.remove(self.loadedExpressions_, 1)
            display.removeAnimationCache(animName)
            display.removeSpriteFramesWithFile("expressions/" .. animName .. ".plist", "expressions/" .. animName .. ".png")
        end
    end

    self.hddjController_:dispose()
    self.disposed_ = true
end

function AnimManagerBase:reset()
end

return AnimManagerBase