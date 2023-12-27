-- 免费筹码视图

local MoreGameView = class("MoreGameView", tx.ui.Panel)

local ExchangeCodePopup = import("app.module.exchangecode.ExchangeCodePopup")
local SlotPopup = import("app.module.slot.SlotPopup")
local LuckturnPopup = import("app.module.luckturn.LuckturnPopup")
local WIDTH, HEIGHT = 886, 580

function MoreGameView:ctor(controller)
    MoreGameView.super.ctor(self, {WIDTH, HEIGHT})

    self:addCloseBtn()
    self:addSecondFrame()
    self:setTextTitleStyle(sa.LangUtil.getText("HALL", "SMALL_GAME"))

    self:addContentNode_()

    self.updateRedPointStateId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, handler(self, self.updateRedPointState_))

    controller:checkLuckturnFreeTimes()
end

function MoreGameView:addContentNode_()
    local bg = self.background_
    local x, y = 130, HEIGHT - 220
    cc.ui.UIPushButton.new({normal = "#hall/hall_slot_btn_normal.png", pressed = "#hall/hall_slot_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onSlotClicked_))
        :pos(x, y)
        :addTo(bg)

    x = x + 200
    local btn = cc.ui.UIPushButton.new({normal = "#hall/hall_luckturn_btn_normal.png", pressed = "#hall/hall_luckturn_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onLuckturnClicked_))
        :pos(x, y + 5)
        :addTo(bg)

    self.luckturnPoint_ = display.newSprite("#common/common_red_point.png")
        :pos(55, 55)
        :addTo(btn)
        :hide()

    self.freeTime_ = ui.newTTFLabel({text = 0, size = 22})
        :pos(20, 20)
        :addTo(self.luckturnPoint_)

    x = x + 200
    cc.ui.UIPushButton.new({normal = "#hall/hall_exchange_btn_normal.png", pressed = "#hall/hall_exchange_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onExchangeClicked_))
        :pos(x, y + 5)
        :addTo(bg)
end

function MoreGameView:onLuckturnClicked_()
    display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
        LuckturnPopup.new():showPanel()
    end)
end

function MoreGameView:onSlotClicked_()
    display.addSpriteFrames("slot_texture.plist", "slot_texture.png", function()
        SlotPopup.new(false):showPanel()
    end)
end

function MoreGameView:onExchangeClicked_()
    ExchangeCodePopup.new(nil, 2):showPanel()
end

--同步更新红点
function MoreGameView:updateRedPointState_(evt)
    self:updateLuckturnRedPointState_(evt.freeTimes)
end

--设置大转盘红点状态
function MoreGameView:updateLuckturnRedPointState_(freeTimes)
    if freeTimes > 0 then
        self.luckturnPoint_:show()
        self.freeTime_:setString(freeTimes)
    else
        self.luckturnPoint_:hide()
    end
end

function MoreGameView:onCleanup()
    if self.updateRedPointStateId_ then
        sa.EventCenter:removeEventListener(self.updateRedPointStateId_)
    end  
end

return MoreGameView
