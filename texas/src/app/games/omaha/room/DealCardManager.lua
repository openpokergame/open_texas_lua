-- 奥马哈发牌管理器
local DealCardManager      = import("app.games.texas.room.DealCardManager")
local OmahaDealCardManager = class("OmahaDealCardManager", DealCardManager)
local HandCard = import(".views.HandCard")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomViewPosition = import("app.games.texas.room.views.RoomViewPosition")
local P = RoomViewPosition.DealCardPosition
local log = sa.Logger.new("OmahaDealCardManager")

local tweenDuration = DealCardManager.tweenDuration

local BIG_CARD_SCALE_X = DealCardManager.BIG_CARD_SCALE_X
local BIG_CARD_SCALE_Y = DealCardManager.BIG_CARD_SCALE_Y

function OmahaDealCardManager:ctor()
    P = RoomViewPosition.DealCardPosition
    OmahaDealCardManager.super.ctor(self, 4)
end

--真正发牌逻辑
function OmahaDealCardManager:dealCard_(positionId)
    local dealingcard = self.dealCards_[self.startDealIndex_][positionId]
    if not dealingcard then return end

    if dealingcard:getParent() then
        dealingcard:removeFromParent()
    end
    dealingcard:setScale(1)
    if dealingcard:getNumberOfRunningActions() == 0 then
        dealingcard:addTo(self.cardBatchNode_):pos(P[10].x, P[10].y):rotation(180)
    end

    local targetSX, targetSY = P[positionId].x, P[positionId].y
    local targetX, targetY = targetSX, targetSY
    if self.startDealIndex_ == 1 then
        targetX = targetSX - 12
    elseif self.startDealIndex_ == 2 then
        targetX = targetSX - 4
    elseif self.startDealIndex_ == 3 then
        targetX = targetSX + 4
    elseif self.startDealIndex_ == 4 then
        targetX = targetSX + 12
    end

    local seatView = self.seatManager:getSeatView(self.currentDealSeatId_)
    if self.model:isSelfInSeat() and positionId == 5 then
        local seatData = seatView:getSeatData()
        local cardIndex = self.startDealIndex_
        local cardNum = self.dealCardsNum_
        local sx, sy = targetSX + 59, targetSY + 51
        if self.startDealIndex_ == 1 then
            targetX = sx - 60
            targetY = sy
        elseif self.startDealIndex_ == 2 then
            targetX = sx - 20
            targetY = sy
        elseif self.startDealIndex_ == 3 then
            targetX = sx + 20
            targetY = sy
        elseif self.startDealIndex_ == 4 then
            targetX = sx + 60
            targetY = sy
        end

        transition.scaleTo(dealingcard, {scaleX=BIG_CARD_SCALE_X, scaleY=BIG_CARD_SCALE_Y, time=tweenDuration,onComplete=function()
            if self.model:isSelfInSeat() then
                if dealingcard:getParent() then
                    dealingcard:removeFromParent()
                end

                if cardIndex == 4 then
                    seatView:showHandCardsElement(cardIndex,true)
                    self.schedulerPool:delayCall(function() 
                        seatView:flipHandCardsElement(cardIndex)
                        -- 提示最大牌
                        if self.roomController and self.roomController.dealCardProb then
                            self.roomController:dealCardProb()
                        end
                        self.publicCardManager:tipBigCard()
                    end, 0.15)
                elseif cardIndex < 4  then
                    seatView:showHandCardsElement(cardIndex,true)
                    self.schedulerPool:delayCall(function()
                        seatView:flipHandCardsElement(cardIndex)
                    end, 0.05)
                end
            elseif not seatView:getSeatData() then
                if dealingcard:getParent() then
                    dealingcard:removeFromParent()
                end
            end
        end})

        transition.moveTo(dealingcard, {time=tweenDuration, x=targetX, y=targetY, onComplete=function() 
                if self.showOver_==true then
                    dealingcard:removeFromParent()
                end
            end})
        dealingcard:rotateTo(tweenDuration, 0)
    else
        transition.moveTo(dealingcard, {time=tweenDuration, x=targetX, y=targetY, onComplete=function() 
                if (not seatView:getSeatData() and dealingcard:getParent()) then
                    dealingcard:removeFromParent()
                end
            end})
        dealingcard:rotateTo(tweenDuration, 0)
    end
    tx.SoundManager:playSound(tx.SoundManager.DEAL_CARD)
end

function OmahaDealCardManager:showDealedCard(player, cardNum)
    cardNum = 4
    local positionId = self.seatManager:getSeatPositionId(player.seatId)
    for i = 1, cardNum do
        local deadCard = self.dealCards_[i][positionId]
        if deadCard:getParent() then
            deadCard:removeFromParent()
        end
        deadCard:show()
        deadCard:setScale(1)
        if i <= cardNum then
            if i==1 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x-12,P[positionId].y)
                    :rotation(0)
            elseif i==2 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x-4,P[positionId].y)
                    :rotation(0)
            elseif i==3 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x+4,P[positionId].y)
                    :rotation(0)
            elseif i==4 then
                deadCard:addTo(self.cardBatchNode_)
                    :pos(P[positionId].x+12,P[positionId].y)
                    :rotation(0)
            end
        end
    end
end

function OmahaDealCardManager:playShowCardAnimation_(handCard)
    handCard:show()
    handCard:showFront()
    handCard:scale(0)
    handCard:stopAllActions()
    transition.scaleTo(handCard, {scale=1, time=0.2,onComplete=function()
        tx.SoundManager:playSound(tx.SoundManager.SHOW_HAND_CARD)
    end})
end

return OmahaDealCardManager