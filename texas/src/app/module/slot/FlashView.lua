-- 中奖提示闪光灯

local FlashView = class("FlashView", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 658, 87

function FlashView:ctor()
    self.schedulerPool_ = sa.SchedulerPool.new()

    display.newScale9Sprite("#slot_flash_bg.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :addTo(self)

    display.newSprite("#slot_flash_fg.png")
        :addTo(self)

    self.tipLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("SLOT", "FLASH_TIP", "1000000"), size = 30, color = cc.c3b(0xff, 0xff, 0xff)})
        :addTo(self)

    self.light_1 = display.newSprite("#slot_flash_light_1.png")
        :pos(0, 2)
        :addTo(self)
    self.isShow_ = true

    self.light_2 = display.newSprite("#slot_flash_light_2.png")
        :pos(0, 2)
        :addTo(self)
end

function FlashView:setTip(chips)
    self.tipLabel_:setString(sa.LangUtil.getText("SLOT", "FLASH_TIP", chips * 1000))
end

function FlashView:flash(winMoney)
    self.tipLabel_:setString(sa.LangUtil.getText("SLOT", "FLASH_WIN", winMoney))
    self.schedulerPool_:clearAll()
    self.poolId = self.schedulerPool_:loopCall(handler(self, self.start), 0.25)
end

function FlashView:start()
    if self.isShow_ then
        self.light_2:show()
        self.light_1:hide()
        self.isShow_ = false
    else
        self.light_2:hide()
        self.light_1:show()
        self.isShow_ = true
    end

    return true
end

function FlashView:stop()
    self.schedulerPool_:clear(self.poolId)
    self.light_2:show()
    self.light_1:show()
end

function FlashView:delayStop(delay, callback)
    self.schedulerPool_:delayCall(function()
        self:stop()
        if callback then
            callback()
        end
    end, delay)
end

function FlashView:dispose()
    self.schedulerPool_:clearAll()
end

return FlashView