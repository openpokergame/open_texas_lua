local DiscountTips = class("DiscountTips",function()
    return display.newNode()
end)

function DiscountTips:ctor(img)
	self:setNodeEventEnabled(true)
	self.scaleBg_ = display.newSprite(img or "#common/icon_discount.png")
		:addTo(self)
	self.labelDiscount_ = ui.newTTFLabel({text = "", size = 22, color = styles.FONT_COLOR.CHIP_TEXT})
		:pos(0,12)
        :addTo(self)
    self.labelTime_ = ui.newTTFLabel({text = "", size = 16})
    	:pos(0,-6)
        :addTo(self)
end

function DiscountTips:setInfo(time,discount)
	self:stopAllActions()
	self.time_ = time
	self.discount_ = discount
	self.initTime_ = os.time()
	self:show()
	self.labelDiscount_:setString(discount)

	if self.time_ <= 0  then --防止手机卡顿，时间为负数，需要隐藏及时刷新界面
		self:hide()
		sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
	else
		self.labelTime_:setString(sa.TimeUtil:getTimeString1(self.time_))
		self:schedule(function()
	        local runTime = os.time() - self.initTime_
	        if runTime>=self.time_ then
				self:stopAllActions()
				self:hide()
				sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
	        	return
	        end
	        self.labelTime_:setString(sa.TimeUtil:getTimeString1(self.time_-runTime))
	    end, 1)
	end
end

function DiscountTips:onCleanup()
	self:stopAllActions()
end

return DiscountTips