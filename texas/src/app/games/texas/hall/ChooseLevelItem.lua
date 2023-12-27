local ChooseLevelItem = class("ChooseLevelItem", sa.ui.ListItem)
ChooseLevelItem.WIDTH = 80
ChooseLevelItem.HEIGHT = 420
ChooseLevelItem.CURTYPE = 1
ChooseLevelItem.ELEMENTS = {
	"img",
	"bg",
	"labelBlind",
	"iconPeaple",
	"labelPeaple",
	"labelTakeIn",
	"labelPlace",
	"labelName",
	"labelTips",
}

function ChooseLevelItem:ctor()
	local w, h = ChooseLevelItem.WIDTH, ChooseLevelItem.HEIGHT
	ChooseLevelItem.super.ctor(self, w, h)

	self.CITY_NAME = sa.LangUtil.getText("HALL", "CHOOSE_ROOM_CITY_NAME")
	self:setNodeEventEnabled(true)
	
	self.isLocking = false
	self.nodeItem_ =  tx.ui.EditPanel.bindElementsToTarget(self,"texas_hall_item.csb",true)
		:pos(w*0.5, h*0.5 - 20)

	ScaleButton(self.nodeItem_,0.85):onButtonClicked(function()
      	tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
      	local list = self:getOwner()
      	if self.isLocking then
      		-- tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "TEXAS_LIMIT_LEVEL", self.tableLevelLimit_[self.data_.index]))
      	else
      		if list.onItemClickListener then
      			local askUpLevel = true
      			if self.light_ and self.light_:isVisible() then
      				askUpLevel = false
      			end
	        	list.onItemClickListener(self.data_, askUpLevel)
	    	end
      	end
 	end)
 	self.nodeItem_:setTouchSwallowEnabled(false)

    self.labelName:scale(0.95)
end

function ChooseLevelItem:onDataSet(dataChanged, data)
	self.data_ = data
	self.isLocking = false
    if self.data_ then
    	if self.light_ then
    		self.light_:hide()
    	end

	  	local idx = data.index or self:getIndex()
	  	if idx < 1 then
	  		idx = 2
	  	elseif idx > 6 then
	  		idx = 6
	  	end

	  	local str = ""
	  	local curType = ChooseLevelItem.CURTYPE
	  	if curType == 1 then
	  		str = "primary_"
	  	elseif curType == 2 then
	  		str = "intermediate_"
	  	elseif curType == 3 then
	  		str = "senior_"
	  	end

	  	local sf = display.newSpriteFrame("texas_hall_"..str..idx..".png")
	  	if sf then
	  		self.img:setSpriteFrame(sf)
	  	else
	  		self.img:setSpriteFrame("texas_hall_senior_1.png")
	  	end

	  	self.labelPlace:setString(self.CITY_NAME[idx + (curType - 1)*6])

	  	local minAnte = sa.formatBigNumber(data.min_ante)
	  	local maxAnte = sa.formatBigNumber(data.max_ante)
	  	self.labelTakeIn:setString(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_MIN_MAX_ANTE", minAnte, maxAnte))

	  	local icon_w = self.iconPeaple:getContentSize().width
	  	self.labelPeaple:setString(data.online)
	  	local label_w = self.labelPeaple:getContentSize().width
	  	local x = -(icon_w + label_w + 10)*0.5

	  	self.iconPeaple:setPositionX(x)
	  	self.labelPeaple:setPositionX(x + icon_w + 10)

	  	local minBlind = sa.formatBigNumber(data.smallblind)
	  	local maxBlind = sa.formatBigNumber(data.smallblind * 2)
	  	self.labelBlind:setString(sa.LangUtil.getText("MATCH", "BLIND_TITLE"))
	  	self.labelName:setString(sa.LangUtil.getText("MATCH", "FORMAT_BLIND", minBlind, maxBlind))

	  	self.labelTips:setString(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))

	  	sa.fitSprteWidth(self.labelPlace, 172)
	  	sa.fitSprteWidth(self.labelTakeIn, 228)
	  	sa.fitSprteWidth(self.labelBlind, 228)
	  	sa.fitSprteWidth(self.labelTips, 210)

	  	-- self.tableLevelLimit_ = tx.userData.tableLevelLimit[curType]
	  	-- local limitLevel = self.tableLevelLimit_[data.index]

	  	local limitLevel = tx.userData.tableLevelLimit[data.index] --new
	  	self:addLock_(limitLevel)
	  	self:setLockStatus_(limitLevel)
    end
end

function ChooseLevelItem:showRecommendLight()
	if not self.light_ then
	    self.light_ = sp.SkeletonAnimation:create("spine/DZXC.json", "spine/DZXC.atlas")
			:pos(-2, 48)   		
	        :addTo(self.nodeItem_, -1)
		self.light_:setAnimation(0, 3, true)
	end
	self.light_:show()
end

function ChooseLevelItem:addLock_(limitLevel)
	if self.lockShadow_ then
		self.lockShadow_:removeFromParent()
		self.lockShadow_ = nil
	end

	local minAnte = self.data_.min_ante
	if minAnte < 20000 then
		return
	end

	self.isLocking = true

	self.lockShadow_ = display.newSprite("#texas/hall/lock_shadow.png")
		:pos(0, 18)
        :addTo(self.nodeItem_)

    if tx.userData.level >= limitLevel then
    	self.isLocking = false
    	self.lockShadow_:removeFromParent()
    	self.lockShadow_ = nil
    end
end

function ChooseLevelItem:setLockStatus_(limitLevel)
	local isTips = false
	if self.isLocking and limitLevel > 31 then
		isTips = true
	end
	local isShowLabel = not isTips

	self.labelBlind:setVisible(isShowLabel)
	self.iconPeaple:setVisible(isShowLabel)
	self.labelPeaple:setVisible(isShowLabel)
	self.labelTakeIn:setVisible(isShowLabel)
	self.labelName:setVisible(isShowLabel)

	self.labelTips:setVisible(isTips)
end

function ChooseLevelItem:onCleanup()
end

return ChooseLevelItem