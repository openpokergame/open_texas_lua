--房间内侧面按钮

local SideBar = class("SideBar", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 54, 62
local LABEL_X, LABEL_Y = WIDTH, HEIGHT

function SideBar:ctor(view)
    self.view_ = view

    self.isOpened_ = false --是否展开

    self.schedulerPool_ = sa.SchedulerPool.new()

    local x, y = WIDTH/2, HEIGHT/2

    self:size(WIDTH, HEIGHT)
    self:scale(2)

    cc.ui.UIPushButton.new("#slot_side_btn_bg.png")
        :onButtonPressed(function()
            self.pressedIcon_:show()
            self.normalIcon_:hide()
        end)
        :onButtonRelease(function()
            self.normalIcon_:show()
            self.pressedIcon_:hide()
        end)
        :onButtonClicked(buttontHandler(self, self.onButtonClicked_))
        :pos(x, y)
        :addTo(self)

    local icon_x, icon_y = x + 1, y
    self.normalIcon_ = display.newSprite("#slot_side_btn_icon_up.png")
        :pos(icon_x, icon_y)
        :addTo(self)

    self.pressedIcon_ = display.newSprite("#slot_side_btn_icon_down.png")
        :pos(icon_x, icon_y)
        :addTo(self)
        :hide()

    self.animation_ = sp.SkeletonAnimation:create("spine/slot.json", "spine/slot.atlas")
        :pos(icon_x, icon_y)
        :addTo(self)
        :hide()

    self.animation_:registerSpineEventHandler(function(event)
        -- self.normalIcon_:show()
        -- self.animation_:hide()
    end, sp.EventType.ANIMATION_COMPLETE)

    self.moneyLabel_ = ui.newBMFontLabel({text = "", font = "fonts/xiaohuang.fnt"})
        :align(display.RIGHT_CENTER, LABEL_X, LABEL_Y)
        :addTo(self)

    self.view_:setIsOpened(false)
end

function SideBar:onButtonClicked_()
    if self.view_:isMoving() then
        return
    end

    self:stopAddMoneyAnimation_()
    if self.isOpened_ then
        self.isOpened_ = false
        self.view_:playHideAnimation()
    else
        self.isOpened_ = true
        self.view_:playShowAnimation()
    end
end

function SideBar:setIsOpened(isOpened)
    self.isOpened_ = isOpened
    if self.view_.controller_.slotActive==true then
        -- self:playHandlerAnimation()
        if self.isOpened_ then
            self.normalIcon_:show()
            self.pressedIcon_:hide()
            self.animation_:hide()
        end
    end
end

--摇杆动画
function SideBar:playHandlerAnimation()
    if self.isOpened_ then
        self.normalIcon_:show()
        self.pressedIcon_:hide()
        self.animation_:hide()
    else
        self.normalIcon_:hide()
        self.pressedIcon_:hide()
        self.animation_:show():setAnimation(0, "slot", true)
    end
end

function SideBar:stopRunningAnim()
    self.normalIcon_:show()
    self.pressedIcon_:hide()
    self.animation_:hide()
end

--金色动画
function SideBar:playGlowAnimation()
    self.pressedIcon_:show()
    self.schedulerPool_:delayCall(function()
        self.pressedIcon_:hide()
    end, 1.5)
end

--中奖加钱动画
function SideBar:playAddMoneyAnimation(money)
    self.moneyLabel_:pos(LABEL_X, LABEL_Y)
        :opacity(255)
        :show()
    self.moneyLabel_:setString("+" .. sa.formatBigNumber(money))

    local sequence = transition.sequence({
            cc.DelayTime:create(0.5),
            cc.Spawn:create({
                cc.MoveTo:create(1, cc.p(LABEL_X, LABEL_Y + 50)),
                cc.FadeOut:create(1)
            }),
            cc.CallFunc:create(function()
                self.moneyLabel_:hide()
            end),
        })
    self.moneyLabel_:runAction(sequence)
end

--停止加钱动画
function SideBar:stopAddMoneyAnimation_()
    self.moneyLabel_:hide()
    self.moneyLabel_:stopAllActions()
end

--房间内关闭弹窗
function SideBar:hidePanel()
    self.isOpened_ = true
    self:onButtonClicked_()
end

function SideBar:dispose()
    self.schedulerPool_:clearAll()
    self.moneyLabel_:stopAllActions()
end

return SideBar