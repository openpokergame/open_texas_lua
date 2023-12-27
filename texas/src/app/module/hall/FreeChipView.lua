-- 免费筹码视图

local FreeChipView = class("FreeChipView", function ()
    return display.newNode()
end)

local ExchangeCodePopup = import("app.module.exchangecode.ExchangeCodePopup")
local SlotPopup = import("app.module.slot.SlotPopup")
local LuckturnPopup = import("app.module.luckturn.LuckturnPopup")

local FRAME_W, FRAME_H = 497, 154  --展开时的宽度
local SHOW_X, SHOW_Y = -FRAME_W/2 + 35, 0 --展开时的坐标
local HIDE_X, HIDE_Y = FRAME_W/2 + 20, 0

function FreeChipView:ctor(controller)
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)

    self.controller_ = controller

    self:addContentNode_()

    self.updateRedPointStateId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, handler(self, self.updateRedPointState_))
end

function FreeChipView:addContentNode_()
    local btn_w, btn_h = 104, 104
    local w, h = FRAME_W, FRAME_H
    self.contentNode_ = display.newSprite("#hall/hall_free_chip_frame.png")
        :pos(HIDE_X, HIDE_Y)
        :addTo(self)

    local node = self.contentNode_

    local x, y = 42, h/2
    cc.ui.UIPushButton.new({normal = "#hall/hall_free_shrink_btn_normal.png", pressed = "#hall/hall_free_shrink_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onShrinkClicked_))
        :pos(x, y)
        :addTo(node)

    x = x + 90
    cc.ui.UIPushButton.new({normal = "#hall/hall_slot_btn_normal.png", pressed = "#hall/hall_slot_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onSlotClicked_))
        :pos(x, y - 5)
        :addTo(node)

    x = x + 135
    self.luckturnBtn_ = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(cc.size(btn_w, btn_h))
        :align(display.CENTER, x+5, y+7)
        :addTo(node)
    self.luckturnBtn_:scale(1.09)
    self.luckturnBtn_:setAnimation(0, "9", true)
    ScaleButton(self.luckturnBtn_, 0.9):onButtonClicked(buttontHandler(self, self.onLuckturnClicked_))
    self.luckturnPoint_ = display.newSprite("#common/common_red_point.png")
        :pos(82, 82)
        :addTo(self.luckturnBtn_)
        :hide()
    self.freeTime_ = ui.newTTFLabel({text = 0, size = 22})
        :pos(20, 20)
        :addTo(self.luckturnPoint_)

    x = x + 135
    self.exchangeBtn_ = cc.ui.UIPushButton.new({normal = "#hall/hall_exchange_btn_normal.png", pressed = "#hall/hall_exchange_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onExchangeClicked_))
        :pos(x, y + 5)
        :addTo(node)

    self.show_x_ = SHOW_X
    if tx.config.SHOW_SHARE~=1 then
        self.exchangeBtn_:hide()
        self.show_x_ = SHOW_X + 120
    end
end

--收缩
function FreeChipView:onShrinkClicked_()
    self:playHideAnimation_()
end

--收缩
function FreeChipView:playHideAnimation_()
    self:playMoveAnimation_(HIDE_X, HIDE_Y)
end

--展开
function FreeChipView:playShowAnimation()
    -- if self.havePrivate_ then
        self:playMoveAnimation_(self.show_x_, SHOW_Y)
    -- else
    --     self:playMoveAnimation_(SHOW_X, SHOW_Y)
    -- end
    self:performWithDelay(function ()
        self:playHideAnimation_()
    end, 3)
end

function FreeChipView:playMoveAnimation_(x, y)
    self:stopAllActions()
    transition.moveTo(self.contentNode_, {
        time = 0.3,
        easing = "exponentialOut",
        x = x,
        y = y
    })
end

function FreeChipView:onLuckturnClicked_()
    display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
        LuckturnPopup.new():showPanel()
    end)
end

function FreeChipView:onSlotClicked_()
    display.addSpriteFrames("slot_texture.plist", "slot_texture.png", function()
        SlotPopup.new(false):showPanel()
    end)
end

function FreeChipView:onExchangeClicked_()
    ExchangeCodePopup.new():showPanel()
end

--同步更新红点
function FreeChipView:updateRedPointState_(evt)
    self:updateLuckturnRedPointState_(evt.freeTimes)
end

--设置大转盘红点状态
function FreeChipView:updateLuckturnRedPointState_(freeTimes)
    if freeTimes > 0 then
        self.luckturnPoint_:show()
        self.freeTime_:setString(freeTimes)
    else
        self.luckturnPoint_:hide()
    end
end

function FreeChipView:onCleanup()
    if self.updateRedPointStateId_ then
        sa.EventCenter:removeEventListener(self.updateRedPointStateId_)
    end  
end

return FreeChipView
