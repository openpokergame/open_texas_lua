local SlotPopup = class("SlotPopup", function()
    return display.newNode()
end)

local SlotController    = import(".SlotController")
local FlashView         = import(".FlashView")
local SlotScrollView    = import(".SlotScrollView")
local BetChooseView     = import(".BetChooseView")
local HelpPopup         = import(".HelpPopup")
local SideBar           = import(".SideBar")

local WIDTH, HEIGHT = 1037, 731
local POP_OFFSET = 510 * 0.5
local VIEW_SHOW_X, VIEW_SHOW_Y = display.width - POP_OFFSET, display.cy+40 --房间内显示老虎机的坐标
local VIEW_HIDE_X, VIEW_HIDE_Y = display.width + POP_OFFSET, display.cy+40 --房间内隐藏老虎机的坐标

function SlotPopup:ctor(isInRoom)
    self:setContentSize(cc.size(WIDTH, HEIGHT))
    self:setNodeEventEnabled(true)

    self.schedulerPool_ = sa.SchedulerPool.new()
    self.isInRoom_ = isInRoom
    self.isAutoBet_ = false
    self.isMoving_ = false --是否正在移动
    self.controller_ = SlotController.new(self)

    self:addMainUI_()
end

function SlotPopup:addMainUI_()
    local bg = display.newSprite("#slot_background.png")
        :addTo(self)
    bg:setTouchEnabled(true)
    self.bg_ = bg

    cc.ui.UIPushButton.new({normal = "#slot_help_btn_normal.png", pressed = "#slot_help_btn_pressed.png"})
        :pos(65, HEIGHT - 100)
        :onButtonClicked(buttontHandler(self, self.onHelpClicked_))
        :addTo(bg)

    display.newSprite("#slot_title.png")
        :pos(WIDTH/2, HEIGHT - 25)
        :addTo(bg)

    self.flashView_ = FlashView.new()
        :pos(WIDTH/2, HEIGHT - 115)
        :addTo(bg)

    local nor, pre = "#slot_close_btn_normal.png", "#slot_close_btn_pressed.png"
    if self.isInRoom_ then
        nor, pre = "#slot_room_close_btn_normal.png", "#slot_room_close_btn_pressed.png"
    end
    cc.ui.UIPushButton.new({normal = nor, pressed = pre})
        :pos(WIDTH - 55, HEIGHT - 100)
        :onButtonClicked(buttontHandler(self, self.onCloseClicked_))
        :addTo(bg)

    self.nodeItems_ = display.newNode():addTo(self)
    self.slotScrollView_ = SlotScrollView.new(function(i, rewardMoney, leftMoney)
            self.controller_:slotScrollViewCallback(i, rewardMoney, leftMoney)
        end)
        :addTo(self.nodeItems_)

    self:addBottomNode_()

    if self.isInRoom_ then
        self.sideBar_ = SideBar.new(self)
            :align(display.RIGHT_CENTER, -WIDTH*0.5+8, 0)
            :addTo(self)

        self:pos(VIEW_HIDE_X, VIEW_HIDE_Y)
    end
end

function SlotPopup:addBottomNode_()
    local bg = self.bg_
    self.betChooseView_ = BetChooseView.new(100, self.isInRoom_, function(bet)
        self.flashView_:setTip(bet)
    end)
    :pos(298, 80)
    :addTo(bg)

    self.autoBetBtn_ = cc.ui.UICheckBoxButton.new({on="#slot_auto_bet_btn_on.png", off="#slot_auto_bet_btn_off.png"})
        :onButtonClicked(buttontHandler(self, self.onAutoBetClicked_))
        :pos(WIDTH/2 + 145, 80)
        :addTo(bg)

    self.spinBtn_ = cc.ui.UIPushButton.new({normal = "#slot_spin_btn_normal.png", pressed = "#slot_spin_btn_pressed.png", disabled = "#slot_spin_btn_disabled.png"})
        :pos(WIDTH - 150, 80)
        :onButtonClicked(buttontHandler(self, self.onSpinClicked_))
        :addTo(bg)
end

function SlotPopup:onCloseClicked_()
    self:hidePanel()
end

--帮助
function SlotPopup:onHelpClicked_()
    local bet = self.betChooseView_:getBet()
    local config = self.controller_:getSlotconfig()
    HelpPopup.new(bet, config):showPanel(self.isInRoom_)
end

--自动
function SlotPopup:onAutoBetClicked_(evt)
    if not self:isHaveMoney_() then
        self:updateAutoBetBtnStatus(false)
        return
    end

    if self.isAutoBet_ then
        self.isAutoBet_ = false
        self:stopLoopAutoBet()
    else
        self.isAutoBet_ = true
        self:updateSpinBetBtnStatus(false)
    end

    self.controller_:autoBetCallback(self.isAutoBet_)
end

--立刻开始
function SlotPopup:onSpinClicked_()
    if not self:isHaveMoney_() then
        return
    end

    self:updateSpinBetBtnStatus(false)
    local betMoney = self.betChooseView_:getBet()
    self.flashView_:stop()
    self.flashView_:setTip(betMoney)
    self.controller_:playSlot(betMoney)
end

function SlotPopup:isHaveMoney_()
    if tonumber(tx.userData.money) < 5000 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("SLOT", "NOT_ENOUGH_MIN_MONEY"))
        self:updateAutoBetBtnStatus(false)

        return false
    end

    return true
end

--中奖提示动画
function SlotPopup:setFlashViewTip()
    local betMoney = self.betChooseView_:getBet()
    self.flashView_:setTip(betMoney)
end

--更新自动按钮状态
function SlotPopup:updateAutoBetBtnStatus(isCheck)
    self.autoBetBtn_:setButtonSelected(isCheck)
end

--更新立即开始按钮状态
function SlotPopup:updateSpinBetBtnStatus(enabled)
    self.spinBtn_:setButtonEnabled(enabled)
end

--抽奖成功状态
function SlotPopup:playSlotSuccessCallback(rewardMoney, callback)
    self.flashView_:flash(rewardMoney)
    self.flashView_:delayStop(2, callback)
end

--老虎机获取结果成功
function SlotPopup:playSlotSuccess(data)
    self:updateSpinBetBtnStatus(false)
    self.slotScrollView_:start(data)
end

--老虎机获取结果失败
function SlotPopup:playSlotFailed()
    self.isAutoBet_ = false
    self:updateAutoBetBtnStatus(false)
    self:updateSpinBetBtnStatus(true)
    self:stopLoopAutoBet()
end

--检测自动抽奖
function SlotPopup:checkAutoBet()
    self.controller_:autoBetCallback(self.isAutoBet_)
end

--自动抽奖
function SlotPopup:loopAutoBet(delay)
    self:stopLoopAutoBet()
    self.loopAutoId_ = self.schedulerPool_:delayCall(function()
        self:onSpinClicked_()
    end, 2)
end

--停止自动抽奖
function SlotPopup:stopLoopAutoBet()
    if self.loopAutoId_ then
        self.schedulerPool_:clear(self.loopAutoId_)
        self.loopAutoId_ = nil
    end
end

--是否在房间内
function SlotPopup:isInRoom()
    return self.isInRoom_
end

--设置是否在打开状态
function SlotPopup:setIsOpened(isOpened)
    self.controller_:setIsOpened(isOpened)
    if self.sideBar_ then
        self.sideBar_:setIsOpened(isOpened)
    end
end

--设置底注
function SlotPopup:setPreBlind(blind)
    self.betChooseView_:setPreBlind(blind)

    return self
end

--播放摇杆动画
function SlotPopup:playHandlerAnimation()
    self.sideBar_:playHandlerAnimation()
end

--播放摇杆中奖动画
function SlotPopup:playGlowAnimation()
    self.sideBar_:playGlowAnimation()
end

--播放加钱动画
function SlotPopup:playAddMoneyAnimation(money)
    self.sideBar_:playAddMoneyAnimation(money)
end

function SlotPopup:stopRunningAnim()
    if self.sideBar_ then
        self.sideBar_:stopRunningAnim()
    end
end

function SlotPopup:showPanel()
    if self.isInRoom_ then
        self:scale(0.5)
    else
        tx.PopupManager:addPopup(self)
    end  

    return self
end

function SlotPopup:hidePanel()
    if self.isInRoom_ then
        self.sideBar_:hidePanel()
    else
        tx.PopupManager:removePopup(self)
    end
end

--根据中奖的倍率播放不同数量的粒子动画
function SlotPopup:playChipAnimation()
    if self.isInRoom_ then
        return
    end

    app:playChipsDropAnimation()
end

function SlotPopup:isMoving()
    return self.isMoving_
end

function SlotPopup:setMovePositionX(offsetX)
    local x = self:getPositionX() + offsetX
    if x <= VIEW_SHOW_X then
        x = VIEW_SHOW_X
    elseif x >= VIEW_HIDE_X  then
        x = VIEW_HIDE_X
    end
    self:setPositionX(x)
end

--显示动画，只在房间里调用
function SlotPopup:playShowAnimation()
    self:playMoveAnimation_(VIEW_SHOW_X, VIEW_SHOW_Y)
    self:setIsOpened(true)
end

--隐藏动画，只在房间里调用
function SlotPopup:playHideAnimation()
    self:playMoveAnimation_(VIEW_HIDE_X, VIEW_HIDE_Y)
    self:setIsOpened(false)
end

--移动动画
function SlotPopup:playMoveAnimation_(px, py)
    self.isMoving_ = true
    
    self:stopAllActions()
    transition.moveTo(self, {
        time = 0.3,
        easing = "exponentialOut",
        x = px,
        y = py,
        onComplete = function()
            self.isMoving_ = false
        end,
    })
end

function SlotPopup:onCleanup()
    self:stopLoopAutoBet()
    self.controller_:dispose()
    self:dispose()
    if not self.isInRoom_ then
        display.removeSpriteFramesWithFile("slot_texture.plist", "slot_texture.png")
    end
end

function SlotPopup:dispose()
    if self.isInRoom_ then
        self.sideBar_:dispose()
    end

    self.flashView_:dispose()
    self.slotScrollView_:dispose()
end

return SlotPopup