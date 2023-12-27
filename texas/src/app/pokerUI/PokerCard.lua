local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local CARD_WIDTH      = 122
local CARD_HEIGHT     = 162

-- local VARIETY_DIAMOND = 0 -- 方块
-- local VARIETY_CLUB    = 1 -- 梅花
local VARIETY_DIAMOND = 1 -- 方块
local VARIETY_CLUB    = 0 -- 梅花
local VARIETY_HEART   = 2 -- 红桃
local VARIETY_SPADE   = 3 -- 黑桃

local function getValue(cardUint)
    local var = cardUint % 16
    if var==1 then var=14 end
    if var<2 or var>14 then
        var = 2
    end
    return var
end

local function getVariety(cardUint)
    local uint = math.floor(cardUint / 16)
    if uint<0 or uint>3 then
        uint = 0
    end
    return uint
end

local getFrame = display.newSpriteFrame

local PokerCard = class("PokerCard", function ()
    return display.newNode()
end)

function PokerCard:ctor(noCleanDis)
    self.noCleanDis_ = noCleanDis -- 清空的时候不要释放资源，房间内出bug 房间需要手动释放
    -- 初始数值
    self.cardUint_    = 0xFF
    self.cardValue_   = 2
    self.cardVariety_ = 0
    self.isBack_ = true
    self.isset_ = false
    -- 牌背
    self.backBg_ = display.newSprite("#common/poker_back_bg.png"):pos(0, 0)
    -- self.backBg_:setScaleX(-1)
    self.backBg_:retain()

    -- 初始化node
    self.frontBatch_ = display.newNode():pos(0, 0)
    self.frontBatch_:retain()

    -- 前背景
    self.frontBg_         = display.newSprite("#common/poker_front_bg.png"):pos(0, 0):addTo(self.frontBatch_)
    
    -- 大花色
    self.bigVarietySpr_   = display.newSprite("#common/poker_big_heart.png"):pos(4, 17):addTo(self.frontBatch_)
    
    -- 小花色
    self.smallVarietySpr_ = display.newSprite("#common/poker_small_heart.png"):pos(-34, 18):addTo(self.frontBatch_)
    
    -- 数字
    self.numberSpr_       = display.newSprite("#common/poker_red_14.png"):pos(-34, 52):addTo(self.frontBatch_)

    -- 大牌提示
    self.bigLight_        = display.newSprite("#common/poker_light_overlay.png"):pos(0, 1):addTo(self.frontBatch_):hide()

    -- 帧事件
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))

    -- 打开node event
    self:setNodeEventEnabled(true)
end

-- 设置扑克牌面
function PokerCard:setCard(cardUint)
    self.isset_ = true
    if self.cardUint_ == cardUint then
        return self
    end
    self.cardUint_ = cardUint or 3

    -- 获取值与花色
    self.cardValue_ = getValue(cardUint)
    self.cardVariety_ = getVariety(cardUint)

    -- 设置纹理
    if self.cardVariety_ == VARIETY_DIAMOND then
        self.smallVarietySpr_:setSpriteFrame(getFrame("common/poker_small_diamond.png"))
        self.numberSpr_:setSpriteFrame(getFrame("common/poker_red_"..self.cardValue_..".png"))
        if self.cardValue_ > 10 and self.cardValue_ < 14 then
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_character_"..self.cardValue_..".png"))
        else
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_big_diamond.png"))
        end
    elseif self.cardVariety_ == VARIETY_HEART then
        self.smallVarietySpr_:setSpriteFrame(getFrame("common/poker_small_heart.png"))
        self.numberSpr_:setSpriteFrame(getFrame("common/poker_red_"..self.cardValue_..".png"))
        if self.cardValue_ > 10 and self.cardValue_ < 14 then
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_character_"..self.cardValue_..".png"))
        else
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_big_heart.png"))
        end
    elseif self.cardVariety_ == VARIETY_CLUB then
        self.smallVarietySpr_:setSpriteFrame(getFrame("common/poker_small_club.png"))
        self.numberSpr_:setSpriteFrame(getFrame("common/poker_black_"..self.cardValue_..".png"))
        if self.cardValue_ > 10 and self.cardValue_ < 14 then
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_character_"..self.cardValue_..".png"))
        else
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_big_club.png"))
        end
    elseif self.cardVariety_ == VARIETY_SPADE then
        self.smallVarietySpr_:setSpriteFrame(getFrame("common/poker_small_spade.png"))
        self.numberSpr_:setSpriteFrame(getFrame("common/poker_black_"..self.cardValue_..".png"))
        if self.cardValue_ > 10 and self.cardValue_ < 14 then
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_character_"..self.cardValue_..".png"))
        else
            self.bigVarietySpr_:setSpriteFrame(getFrame("common/poker_big_spade.png"))
        end
    end
    
    local bigVarietySize = self.bigVarietySpr_:getContentSize()
    self.bigVarietySpr_:pos(CARD_WIDTH * 0.5 - bigVarietySize.width * 0.5-12, bigVarietySize.height * 0.5 - CARD_HEIGHT * 0.5+12)

    return self
end

-- 翻牌动画
function PokerCard:flip()
    if self.cardUint_==0 then
        return self
    end
    self.isBack_ = false
    if not self.flipBackAction_ then
        -- local delayAction = cc.DelayTime:create(0.2)
        -- local orbitAction = cc.OrbitCamera:create(0.25, 1, 0, 0, 90, 0, 0)
        local delayAction = cc.DelayTime:create(0.02)
        local orbitAction = cc.OrbitCamera:create(0.1, 1, 0, 0, 90, 0, 0)
        local callback = cc.CallFunc:create(handler(self, self.onBackActionComplete_))
        local array = {
            delayAction,
            orbitAction,
            callback
        }
        self.flipBackAction_ = cc.Sequence:create(array)
        self.flipBackAction_:retain()
    end

    if not self.flipFrontAction_ then
        -- local orbitAction = cc.OrbitCamera:create(0.25, 1, 0, -90, 90, 0, 0)
        local orbitAction = cc.OrbitCamera:create(0.1, 1, 0, -90, 90, 0, 0)
        local callback = cc.CallFunc:create(handler(self, self.onFrontActionComplete_))
        local array = {
            orbitAction,
            callback
        }
        self.flipFrontAction_ = cc.Sequence:create(array)
        self.flipFrontAction_:retain()
    end

    -- 首先显示牌背，0.5s后开始翻牌动画
    self:showBack_()
    self.backBg_:runAction(self.flipBackAction_)
    self.delayHandle_ = scheduler.performWithDelayGlobal(handler(self, self.playSoundDelayCall_), 0.2)
    return self
end

function PokerCard:playSoundDelayCall_()
    tx.SoundManager:playSound(tx.SoundManager.FLIP_CARD)
end

function PokerCard:onBackActionComplete_()
    self:showFront();
    self.frontBatch_:runAction(self.flipFrontAction_)
end

function PokerCard:onFrontActionComplete_()
    self.backBg_:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
    self.frontBatch_:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
end

-- 红黑场里面的翻牌动画
function PokerCard:redblackFlip()
    if self.cardUint_==0 then
        return self
    end

    self.isBack_ = false
    local t = 0.2
    if not self.flipBackAction_ then
        local spawnAction = cc.Spawn:create(
            cc.OrbitCamera:create(t, 1, 0, 0, 90, 0, 0),
            cc.ScaleTo:create(t, 0.6)
        )
        local callback = cc.CallFunc:create(handler(self, self.onRedblackBackActionComplete_))
        local array = {
            spawnAction,
            callback
        }
        self.flipBackAction_ = cc.Sequence:create(array)
        self.flipBackAction_:retain()
    end

    if not self.flipFrontAction_ then
        local spawnAction = cc.Spawn:create(
            cc.OrbitCamera:create(t, 1, 0, -90, 90, 0, 0),
            cc.ScaleTo:create(t, 1.2)
        )
        local scaleAction = cc.ScaleTo:create(t*0.5, 1)
        local callback = cc.CallFunc:create(handler(self, self.onRedblackFrontActionComplete_))
        local array = {
            spawnAction,
            scaleAction,
            callback
        }
        self.flipFrontAction_ = cc.Sequence:create(array)
        self.flipFrontAction_:retain()
    end

    -- 首先显示牌背，0.5s后开始翻牌动画
    self:showBack_()
    self.backBg_:runAction(self.flipBackAction_)
    self.delayHandle_ = scheduler.performWithDelayGlobal(handler(self, self.playSoundDelayCall_), t*2)
    return self
end

-- 红黑场里面的翻牌动画回调
function PokerCard:onRedblackBackActionComplete_()
    self:showFront()
    self.frontBatch_:runAction(self.flipFrontAction_)
end

-- 红黑场里面的翻牌动画回调
function PokerCard:onRedblackFrontActionComplete_()
    self.backBg_:scale(1):runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
    self.frontBatch_:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
end

-- 显示正面
function PokerCard:showFront()
    -- assert(self.isset_,"not set card")
    self.isBack_ = false
    self.backBg_:removeFromParent()
    if not self.frontBatch_:getParent() then
        self.frontBatch_:addTo(self)
        self.frontBatch_:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
    end

    return self
end

-- 显示背面
function PokerCard:showBack()
    self.isBack_ = true
    self:showBack_()

    return self
end

function PokerCard:showBack_()
    self.frontBatch_:removeFromParent()
    if not self.backBg_:getParent() then
        self.backBg_:scale(1):addTo(self)
        self.backBg_:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
    end
    return self
end

function PokerCard:isBack()
    return self.isBack_
end

-- 震动扑克牌
function PokerCard:shake()
    if self._isShaking then
        self:unscheduleUpdate()
    end
    self:scheduleUpdate();
    self._isShaking = true

    return self
end

function PokerCard:onEnterFrame(dt)
    local posX, posY = self.frontBatch_:getPosition()
    if posX <= -1 or posX >= 1 then
        posX = 0
        self.frontBatch_:setPositionX(posX)
    end
    if posY <= -1 or posY >= 1 then
        posY = 0
        self.frontBatch_:setPositionY(posY)
    end
    posX = posX + math.random(-1, 1)
    posY = posY + math.random(-1, 1)
    self.frontBatch_:pos(posX, posY)

    return self
end

-- 停止震动扑克牌
function PokerCard:stopShake()
    if self._isShaking then
        self:unscheduleUpdate()
    end
    self.frontBatch_:pos(0, 0)
    self._isShaking = false

    return self
end

-- 暗化牌
function PokerCard:addDark()
    if not self.darkOverlay_ then
        self.darkOverlay_ = display.newSprite("#common/poker_dark_overlay.png")
    end
    if not self.darkOverlay_:getParent() then
        self.darkOverlay_:addTo(self.frontBatch_):pos(0, 0)
    end
    return self
end

-- 移除暗化
function PokerCard:removeDark()
    if self.darkOverlay_ then
        self.darkOverlay_:removeFromParent()
        self.darkOverlay_ = nil
    end
end

-- 获取扑克宽度（不包括阴影）
function PokerCard:getCardWidth()
    return CARD_WIDTH
end

-- 获取扑克高度（不包括阴影）
function PokerCard:getCardHeight()
    return CARD_HEIGHT
end

-- 重置扑克牌（移除舞台时自动调用）
function PokerCard:onCleanup()
    -- 恢复扑克
    self:stopShake()
    self:removeDark()

    -- 移除scheduler的handle
    if self.delayHandle_ then
        scheduler.unscheduleGlobal(self.delayHandle_)
    end

    -- 移除扑克视图
    self.frontBatch_:removeFromParent()
    self.backBg_:removeFromParent()
    if not self.isDispose_ and not self.noCleanDis_ then
        self:dispose()
    end
end

function PokerCard:setLight(value)
    if value and value==true then
        self.bigLight_:show()
    else
        self.bigLight_:hide()
    end
end

function PokerCard:hide()
    self:reset()

    cc.Node.hide(self)
    return self
end

-- 重置
function PokerCard:reset()
    self:stopAllActions()

    -- 移除scheduler的handle
    if self.delayHandle_ then
        scheduler.unscheduleGlobal(self.delayHandle_)
    end

    -- 恢复扑克
    self:stopShake()
    self:removeDark()

    -- 移除扑克视图
    self.frontBatch_:stopAllActions()
    if self.frontBatch_:getParent() then
        self.frontBatch_:removeFromParent()
    end

    self.backBg_:stopAllActions()
    if self.backBg_:getParent() then
        self.backBg_:removeFromParent()
    end

    self.bigLight_:hide()
end

-- 清理
function PokerCard:dispose()
    self.isDispose_ = true
    -- 释放retain的对象
    self.backBg_:release()
    self.frontBatch_:release()
    if self.flipBackAction_ then
        self.flipBackAction_:release()
    end
    if self.flipFrontAction_ then
        self.flipFrontAction_:release()
    end

    -- 移除node事件
    self:unscheduleUpdate();
    self:removeAllNodeEventListeners()

    -- 移除scheduler的handle
    if self.delayHandle_ then
        scheduler.unscheduleGlobal(self.delayHandle_)
    end
end

function PokerCard:getCardValue()
    return self.cardUint_
end

return PokerCard