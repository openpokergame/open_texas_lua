local AnimManagerBase = import("app.games.AnimManagerBase")
local AnimManager = class("AnimManager", AnimManagerBase)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local HddjController = import(".HddjController")
local RoomViewPosition = import(".views.RoomViewPosition")
local RoomChatBubble = import("app.module.room.chat.RoomChatBubble")
local RoomSignalIndicator = import(".views.RoomSignalIndicator")
local RoomBatteryIndicator = import(".views.RoomBatteryIndicator")
local ExpressionConfig = import("app.module.room.chat.ExpressionConfig").new()
local LoadGiftControl = import("app.module.gift.LoadGiftControl")

local DealerPosition = RoomViewPosition.DealerPosition
local SeatPosition = RoomViewPosition.SeatPosition

function AnimManager:ctor()
    DealerPosition = RoomViewPosition.DealerPosition
    SeatPosition = RoomViewPosition.SeatPosition
end

function AnimManager:createNodes()
    AnimManager.super.createNodes(self)

    self.tableDealerPositionId_ = 1
    self.tableDealer_ = display.newSprite("#texas/room/dealer_icon.png")
        :pos(DealerPosition[self.tableDealerPositionId_].x, DealerPosition[self.tableDealerPositionId_].y)
        :addTo(self.ctx.scene.nodes.dealerNode)

    self.signal_ = RoomSignalIndicator.new()
        :addTo(self.ctx.scene.nodes.dealerNode)
        :pos(display.cx + 180, display.top - 22)

    self.battery_ = RoomBatteryIndicator.new()
        :addTo(self.ctx.scene.nodes.dealerNode)
        :pos(display.cx + 225, display.top - 22)

    self.isTimeSplitStr = true;
    self.clock_ = ui.newTTFLabel({size=20, color=cc.c3b(0x8d, 0x8a, 0x96), text=os.date("%H:%M", os.time()), align=ui.TEXT_ALIGN_CENTER})
        :addTo(self.ctx.scene.nodes.dealerNode)
        :pos(display.cx - 215, display.top - 21)
    self.ctx.sceneSchedulerPool:loopCall(function()
        if self.disposed_ then
            return false
        end

        local date = os.date("*t",os.time())
        local hour = date.hour
        if tonumber(hour)<10 then
            hour = "0"..hour
        end
        local min = date.min
        if tonumber(min)<10 then
            min = "0"..min
        end

        local splitStr = self.isTimeSplitStr and ":" or " "
        self.clock_:setString(hour..splitStr..min);
        self.isTimeSplitStr = not self.isTimeSplitStr;
        return true;
    end, 1)

    -- 互动道具控制器
    self:bindDataObservers_()
    self:getBatteryInfo()
end

function AnimManager:changeColor(r,g,b)
    self.clock_:setTextColor(cc.c3b(r, g, b))
end

function AnimManager:getBatteryInfo()
    tx.Native:getBatteryInfo(function(result)
        self.battery_:setSignalStrength(tonumber(result))
    end);
end

function AnimManager:onSignalStrengthChanged_(strength)
    self.signal_:setSignalStrength(strength or 5)
end

function AnimManager:moveDealerTo(positionId, animation)
    local p = DealerPosition[positionId]
    if not p then
        p = DealerPosition[1]
        self.tableDealerPositionId_ = 1
    end
    local pp = {x=p.x,y=p.y}
    if positionId==5 and self.ctx.model and self.ctx.model:isSelfInSeat() then
        pp.x = pp.x + RoomViewPosition.SelfDealerOffsetX
    end
    self.tableDealer_:stopAllActions()
    if animation then
        self.tableDealer_:moveTo(0.5, pp.x, pp.y)
    else
        self.tableDealer_:setPosition(pp)
    end
    if positionId then
        self.tableDealerPositionId_ = positionId
    end
end

function AnimManager:rotateDealer(step)
    local newPositionId = self.tableDealerPositionId_ - step
    if newPositionId > 9 then
        newPositionId = newPositionId - 9
    elseif newPositionId < 1 then
        newPositionId = newPositionId + 9
    end
    self:moveDealerTo(newPositionId, true)
end

-- 播放赢牌其中一个动画
function AnimManager:playWinAnimId_(animName,x,y)
    local spAnim = sp.SkeletonAnimation:create("spine/YP3.json","spine/YP3.atlas")
        :pos(x,y)
        :addTo(self.animNode_)
    spAnim:registerSpineEventHandler(function (event)
        spAnim:performWithDelay(function()
            spAnim:removeFromParent()
        end, 0.08)
    end, sp.EventType.ANIMATION_COMPLETE)
    -- 查找
    if spAnim:findAnimation(animName) then
        spAnim:setAnimation(0, animName, false)
        spAnim:show()
    else
        spAnim:removeFromParent()
    end
end

function AnimManager:playYouWinAnim(cardType_, changeChips)
    local animName = "0"
    local animPrev = "Y"
    if appconfig.LANG=="th" or appconfig.LANG=="vi" then
        animPrev = "T"
    elseif appconfig.LANG=="en" then
        animPrev = "Y"
    elseif appconfig.LANG=="zh" then
        animPrev = "Z"
    end
    if cardType_ and cardType_>=consts.CARD_TYPE.HIGH_CARD then
        animName = animPrev..(cardType_-1)
    else
        animName = animPrev..animName
    end
    -- 上头皇冠
    self:playWinAnimId_(animName,display.cx,display.cy)
    -- 爆炸闪光效果
    if _G.curInGameId==3 then -- 奥玛哈
        self:playWinAnimId_("11",display.cx-33,display.cy)
    else  -- 德州
        self:playWinAnimId_("11",display.cx,display.cy)
    end

    -- 粒子效果
    self.schedulerPool:delayCall(function( ... )
        local particleList = nil
        if cardType_<=consts.CARD_TYPE.TWO_PAIRS then
            particleList = {4,5}
        elseif cardType_==consts.CARD_TYPE.THREE_KIND then
            particleList = {2,3,4,5}
        else
            particleList = {0,1,2,3,4,5}
        end
        for k, v in pairs(particleList) do
            local emitter = cc.ParticleSystemQuad:create(string.format("particle/fk_%d.plist",v))
                :pos(display.cx,display.cy)
                :addTo(self.animNode_)
            emitter:setAutoRemoveOnFinish(true)
        end
    end,0.1)

    local x, y = SeatPosition[5].x + RoomViewPosition.SelfOffsetX, SeatPosition[5].y + RoomViewPosition.SelfOffsetY
    local blind = self.model.roomInfo.blind
    local isBigWin = (changeChips >= blind*200)
    self:playChipAnimation_(x, y, isBigWin)

    self.schedulerPool:delayCall(function()
        app:tip(1, changeChips, x, y - 30)
    end, 1.5)
end

function AnimManager:playChipAnimation_(x, y, isBigWin)
    if isBigWin then
        -- tx.SoundManager:playSound(tx.SoundManager.CHIP_DROP)

        self.schedulerPool:delayCall(function()
            local max_num = 16
            local index = 0
            local emitter = cc.ParticleSystemQuad:create("particle/jia.plist")
                :pos(x, y - 80)
                :addTo(self.animNode_)
            emitter:setAutoRemoveOnFinish(true)
            emitter:schedule(function()
                local id = index % max_num
                local img = "particle/P" .. id .. ".png"
                index = index + 1
                emitter:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
            end, 0.01)
        end, 0.55)
    else
        self.schedulerPool:delayCall(function()
            local emitter = cc.ParticleSystemQuad:create("particle/KKB_2.plist")
                :pos(x, y - 80)
                :addTo(self.animNode_)
            emitter:setAutoRemoveOnFinish(true)
        end, 0.55)
    end
end

function AnimManager:playAddFriendAnimation(fromSeatId, toSeatId)
    local fromPositionId = self.seatManager:getSeatPositionId(fromSeatId)
    local toPositionId = self.seatManager:getSeatPositionId(toSeatId)
    
    local ex, ey = SeatPosition[toPositionId].x,SeatPosition[toPositionId].y
    if self.ctx.model:selfSeatId()==toSeatId then
        ex = ex + RoomViewPosition.SelfOffsetX
        ey = ey + RoomViewPosition.SelfOffsetY
    end

    local sx, sy = 0, display.top
    if fromPositionId then
        sx, sy = SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y
    end
   
    AnimManager.super.playAddFriendAnimation(self, sx, sy, ex, ey)
end

function AnimManager:playSendChipAnimation(fromSeatId, toSeatId, chips)
    self.seatManager:updateSeatState(fromSeatId)

    local fromPositionId = self.seatManager:getSeatPositionId(fromSeatId)
    local toPositionId = self.seatManager:getSeatPositionId(toSeatId)
    local ex, ey
    if toSeatId == -100 then -- 赠送给荷官
        ex = SeatPosition[10].x
        ey = SeatPosition[10].y
    else
        ex = SeatPosition[toPositionId].x
        ey = SeatPosition[toPositionId].y
    end

    if self.ctx.model:selfSeatId()==toSeatId then
        ex = ex + RoomViewPosition.SelfOffsetX
        ey = ey + RoomViewPosition.SelfOffsetY
    end

    if self.ctx.model:selfSeatId()==toSeatId then
        ex = ex + RoomViewPosition.SelfOffsetX
        ey = ey + RoomViewPosition.SelfOffsetY
    end

    local sx, sy = 0, display.top
    if fromPositionId then
        sx, sy = SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y
    end

    AnimManager.super.playSendChipAnimation(self, sx, sy, ex, ey, chips, function()
        if toSeatId == -100 then
            self.schedulerPool:delayCall(function()
                self:playHddjAnimation(toSeatId,fromSeatId,4)
            end,0.3)
        else
            self.seatManager:updateSeatState(toSeatId)
        end
    end)
end

function AnimManager:playSendGiftAnimation(giftId, fromUid, toUidArr)
    LoadGiftControl:getInstance():getGiftUrlById(giftId, function(url)
        if url and self:checkUidInSeat({fromUid}) and self:checkUidInSeat(toUidArr) then
            -- 
            local sendGiftCallback_ = function(success, sprite)
                if success and self:checkUidInSeat({fromUid}) and self:checkUidInSeat(toUidArr) then
                    local tex
                    local scaleVal = 1
                    if sprite and (type(sprite)=="table" or type(sprite)=="userdata") and sprite.getTexture then
                        scaleVal = 0.5
                        tex = sprite:getTexture()
                    end

                    local fromPositionId = self.seatManager:getSeatPositionId(self.model:getSeatIdByUid(fromUid))
                    local fromX, fromY = SeatPosition[fromPositionId].x, SeatPosition[fromPositionId].y
                    for _, toUid in ipairs(toUidArr) do
                        local toSeatId = self.model:getSeatIdByUid(toUid)
                        if toSeatId ~= -1 then
                            if not self.sendGiftViews_ then
                                self.sendGiftViews_ = {}
                            end
                            local toPositionId = self.seatManager:getSeatPositionId(toSeatId)
                            local toX = SeatPosition[toPositionId].x
                            local toY = SeatPosition[toPositionId].y
                            if toPositionId<=5 then
                                toX = toX - RoomViewPosition.GiftX
                                if toPositionId==5 and self.ctx.model:isSelfInSeat() then  -- 自己的位置稍微不一样
                                    toX = toX+RoomViewPosition.SelfGiftOffsetX
                                    toY = toY+RoomViewPosition.SelfOffsetY
                                end
                            else
                                toX = toX + RoomViewPosition.GiftX
                            end

                            local sp = nil
                            if tex then  -- 静态图片
                                sp = display.newSprite(tex):pos(fromX, fromY):scale(scaleVal):addTo(self.animNode_)
                            else  -- spine动图
                                local AnimationIcon = require("openpoker.ui.AnimationIcon")
                                sp = AnimationIcon.new("#common/btn_gift_room.png", 1.0, 1.0, nil)
                                    :pos(fromX, fromY):scale(scaleVal):addTo(self.animNode_)
                                sp:onData(url, 70, 70)
                            end
                            table.insert(self.sendGiftViews_, sp)
                            transition.moveTo(sp, {
                                time = 2,
                                easing = "exponentialInOut",
                                x = toX,
                                y = toY,
                                onComplete = function()
                                    toSeatId = self.model:getSeatIdByUid(toUid)
                                    if toSeatId ~= -1 then
                                        self.seatManager:updateGiftUrl(toSeatId, giftId)
                                    end
                                    sp:removeFromParent()
                                    table.removebyvalue(self.sendGiftViews_, sp, true)
                                end,
                            })
                        end
                    end
                end
            end
            -- 
            local params = sa.getFileNameByFilePath(url)
            if params["extension"] == "zip" then
                tx.ImageLoader:loadAndCacheAnimationExt(nil, tx.ImageLoader:nextLoaderId(), url, sendGiftCallback_, tx.ImageLoader.CACHE_TYPE_ANIMATION)
            else
                tx.ImageLoader:loadAndCacheImage(tx.ImageLoader:nextLoaderId(), url, sendGiftCallback_, tx.ImageLoader.CACHE_TYPE_GIFT)
            end
            
        end
    end)
end

function AnimManager:checkUidInSeat(uidArr)
    for _, uid in ipairs(uidArr) do
        if self.model:getSeatIdByUid(uid) ~= -1 then
            return true
        end
    end
    return false
end

function AnimManager:playHddjAnimation(fromSeatId, toSeatId, hddjId)
    local fromPositionId
    local toPositionId
    if fromSeatId == -100 then
        fromPositionId = 10
    else
        fromPositionId = self.seatManager:getSeatPositionId(fromSeatId)
    end
    if toSeatId == -100  then
        toPositionId = 10
    else
        toPositionId = self.seatManager:getSeatPositionId(toSeatId)
    end

    AnimManager.super.playHddjAnimation(self, fromPositionId, toPositionId, hddjId, self.ctx.model:selfSeatId()==toSeatId)
end

-- 播放语音聊天
function AnimManager:playVoiceChat(seatId, voiceData)
    local positionId = self.seatManager:getSeatPositionId(seatId)
    local p = SeatPosition[positionId]
    if not p or not voiceData or not voiceData.url then return end
    local offX, offY = 0, 80
    if voiceData.id==tx.userData.uid then
        offX = offX + RoomViewPosition.SelfOffsetX
        offY = offY + RoomViewPosition.SelfOffsetY+20
    end

    AnimManager.super.playVoiceChat(self, p.x + offX, p.y + offY, voiceData)
end

function AnimManager:playExpression(seatId, expressionId, time)
    if self.model.playerList[seatId] then
        AnimManager.super.playExpression(self, seatId, expressionId, time)
    end
end

function AnimManager:playExpressionAnim_(seatId, expressionId, anim)
    if self.model.playerList[seatId] then
        local config = ExpressionConfig:getConfig(expressionId)
        local positionId = self.seatManager:getSeatPositionId(seatId)
        local p = SeatPosition[positionId]

        local xx, yy, scale = 0, 0, 1
        if self.model.playerList[seatId].isSelf then
            xx, yy, scale = RoomViewPosition.SelfOffsetX, RoomViewPosition.SelfOffsetY, RoomViewPosition.SelfScale
        end

        -- 展示缩放
        local index = self:getExpressionType_(expressionId)
        local finalScale = scale
        if index == 1 then
            finalScale = 1.5*scale
        end

        local px, py = p.x + config.offsetX * finalScale + xx, p.y + config.offsetY * finalScale + yy
        AnimManager.super.playExpressionAnim_(self, px, py, finalScale, expressionId, anim)
    end
end

--显示聊天消息
function AnimManager:showChatMsg(seatId, message, vipLevel)
    local px, py
    local dir
    if seatId==-100 then -- 荷官说话
        dir = RoomChatBubble.DIRECTION_LEFT
        px, py = display.cx + 32, RoomViewPosition.SeatPosition[1].y + 16
    elseif seatId ~= -1 then
        local positionId = self.seatManager:getSeatPositionId(seatId)
        local p = SeatPosition[positionId]
        if p then
            if positionId >= 1 and positionId <=3 then
                dir = RoomChatBubble.DIRECTION_RIGHT
                px = p.x + 8
            else
                dir = RoomChatBubble.DIRECTION_LEFT
                px = p.x - 8
            end

            if positionId == 1 or positionId == 9 then
                py = p.y + 8
            elseif positionId == 2 or positionId == 8 then
                py = p.y + 8
            elseif positionId == 3 or positionId == 7 then
                py = p.y + 48
            else
                py = p.y + 36
            end

            if positionId == 5 and self.ctx.model and self.ctx.model:isSelfInSeat() then
                px = px + RoomViewPosition.SelfOffsetX
                py = py + RoomViewPosition.SelfOffsetY + 40
            end
        end
    end

    if dir then
        AnimManager.super.showChatMsg(self, px, py, dir, message, vipLevel)
    end
end

function AnimManager:getExpressionType_(expressionId)
    return tonumber(string.sub(expressionId, 1, 1)) or 1
end

function AnimManager:dispose()
    if self.youWinScheduleHandle_ then
        scheduler.unscheduleGlobal(self.youWinScheduleHandle_)
    end

    if self.youWinAnim_ then
        self.youWinAnim_:release()
    end

    self:unbindDataObservers_()

    AnimManager.super.dispose(self)
end

function AnimManager:reset()
end

function AnimManager:bindDataObservers_()
    self.onSignalStengthHandlerId_ = sa.DataProxy:addDataObserver(tx.dataKeys.SIGNAL_STRENGTH, handler(self, self.onSignalStrengthChanged_))
end

function AnimManager:unbindDataObservers_()
    sa.DataProxy:removeDataObserver(tx.dataKeys.SIGNAL_STRENGTH, self.onSignalStengthHandlerId_)
end

return AnimManager