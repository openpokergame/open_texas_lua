local PublicCardManager = class("PublicCardManager")
local log = sa.Logger.new("PublicCardManager")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomViewPosition = import(".views.RoomViewPosition")
local P = RoomViewPosition.DealCardPosition
local Pub = RoomViewPosition.PubCardPosition

local tweenDuration = 0.1

function PublicCardManager:ctor()
    P = RoomViewPosition.DealCardPosition
    Pub = RoomViewPosition.PubCardPosition
    self.startDeal_ = false
end

function PublicCardManager:createNodes()
    self.cardBatchNode_ = display.newNode():addTo(self.scene.nodes.publicCardNode)
        -- :pos(display.cx,RoomViewPosition.SeatPosition[1].y-240)
    local PokerCard = tx.ui.PokerCard
    self.cards = {}
    self.cards[1] = PokerCard.new():pos(Pub[1].x, Pub[1].y):addTo(self.cardBatchNode_)
    -- self.cards[1]:setRotationSkewX(2)
    self.cards[2] = PokerCard.new():pos(Pub[2].x, Pub[2].y):addTo(self.cardBatchNode_)
    -- self.cards[2]:setRotationSkewX(2)
    self.cards[3] = PokerCard.new():pos(Pub[3].x, Pub[3].y):addTo(self.cardBatchNode_)
    -- self.cards[3]:setRotationSkewX(-1)
    self.cards[4] = PokerCard.new():pos(Pub[4].x, Pub[4].y):addTo(self.cardBatchNode_)
    -- self.cards[4]:setRotationSkewX(-2)
    self.cards[5] = PokerCard.new():pos(Pub[5].x, Pub[5].y):addTo(self.cardBatchNode_)
    -- self.cards[5]:setRotationSkewX(-2)
end

function PublicCardManager:dealPubCardAnim_(idx,value,isTipBigCard)
    local card = self.cards[idx]
    if card and value and value>0 then
        card:setCard(value):pos(P[10].x, P[10].y):scale(0.01):showBack()
        transition.scaleTo(card, {scaleX=1, scaleY=1, time=tweenDuration,onComplete=function()
            card:flip()
            if isTipBigCard then
                if self.roomController and self.roomController.dealCardProb then
                    self.roomController:dealCardProb()
                end
                self:tipBigCard()
            end
        end})
        transition.moveTo(card, {time=tweenDuration, x=Pub[idx].x, y=Pub[idx].y, onComplete=function() 
            -- card:flip()
        end})
    end
end
function PublicCardManager:tipBigCard()
    local model = self.model
    local aysManager = self.aysManager
    local seatManager = self.seatManager
    local selfSeat = self.seatManager:getSelfSeatView()
    if model and model.gameInfo and model.gameInfo.handCards and model.gameInfo.handCards[1] and model.gameInfo.handCards[1]>0 and selfSeat then
        if aysManager and aysManager.bestCards and #aysManager.bestCards>0 then
            selfSeat:showSelfCardType(aysManager.bestCards.cardType)
        else
            selfSeat:showSelfCardType(consts.CARD_TYPE.HIGH_CARD) -- 高牌
            -- 不提示直接显示牌型
            -- selfSeat.handCards_:showLight(aysManager.bestCards)
            -- for k,v in ipairs(self.cards) do
            --     if model.gameInfo.pubCards and model.gameInfo.pubCards[k] then
            --         local isBig = false
            --         for kk,vv in ipairs(aysManager.bestCards) do
            --             if vv==v.cardUint_ then
            --                 isBig = true
            --                 break
            --             end
            --         end
            --         v:setLight(isBig)
            --     end
            -- end
        end
    end
end
function PublicCardManager:showPubCard(pack)
    if pack.type==3 then
        -- self.cards[1]:setCard(pack.pubCards[1])
        -- self.cards[1]:flip()
        -- self.cards[2]:setCard(pack.pubCards[2])
        -- self.cards[2]:flip()
        -- self.cards[3]:setCard(pack.pubCards[3])
        -- self.cards[3]:flip()
        self:dealPubCardAnim_(1,pack.pubCards[1])

        self.schedulerPool:delayCall(function()
            self:dealPubCardAnim_(2,pack.pubCards[2])
        end, 0.25)
        self.schedulerPool:delayCall(function()
            self:dealPubCardAnim_(3,pack.pubCards[3],true)
        end, 0.5)
    elseif pack.type==4 then
        -- self.cards[4]:setCard(pack.pubCards[1])
        -- self.cards[4]:flip()
        self:dealPubCardAnim_(4,pack.pubCards[1],true)
    elseif pack.type==5 then
        -- self.cards[5]:setCard(pack.pubCards[1])
        -- self.cards[5]:flip()
        self:dealPubCardAnim_(5,pack.pubCards[1],true)
    end
end
function PublicCardManager:showReconnect(pack)
    if pack and pack.pubCards then
        for k,v in ipairs(pack.pubCards) do
            self.cards[k]:setCard(pack.pubCards[k])
            self.cards[k]:showFront()
        end
    end
    self:tipBigCard()
end
function PublicCardManager:showBigs(bigList)
    for k,v in pairs(self.cards) do
        local isBig = false
        for kk,vv in pairs(bigList) do
            if v.cardUint_==vv then
                isBig = true
                break;
            end
        end
        v:setLight(isBig)
        if isBig then
            v:removeDark()
            v:setPositionY(Pub[1].y+10)
        else
            v:addDark()
            v:setPositionY(Pub[1].y)
        end
    end
end
-- 重置位置与角度
function PublicCardManager:reset()
    for k,card in ipairs(self.cards) do
        card:reset()
        card:setPositionY(Pub[k].y)
        card:stopAllActions()
    end
    return self
end

-- 清理
function PublicCardManager:dispose()
    for k,v in pairs(self.cards) do
        v:dispose()
    end
end

return PublicCardManager