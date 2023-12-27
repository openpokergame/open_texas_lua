local ChatFastExp = class("ChatFastExp", function()
	return display.newNode()
end)

-- 快捷表情
--[[
	ctx 房间上下文
	sort: 排列顺序 1：横向（默认）  2：纵向
	type: 1-赢了  2-输了或弃牌  3-刚坐下
--]]
local BTN_WIDTH = 70

function ChatFastExp:ctor(ctx,sort,type)
	self:setNodeEventEnabled(true)
	if not type then type = 3 end
	if not sort then sort = 1 end

	self.clipNode_ = cc.ClippingNode:create()
		:pos(0, 0)
		:addTo(self)
	local stencil = display.newDrawNode()
	local pPolygonPtArr = nil
	if sort==1 then
		pPolygonPtArr = {{0,0},{-85*6,0},{-85*6,85},{0,85}}
	else
		pPolygonPtArr = {{0,0},{0,85*6},{-85,85*6},{-85,0}}
	end
	stencil:drawPolygon(pPolygonPtArr)
	self.clipNode_:setStencil(stencil)

	self.offX = 0   --X轴的偏移量
	self.offY = 0	 --Y轴的偏移量
	self.startX = 0 --X轴开始
	self.startY = 0 --Y轴开始
	if sort==1 then
		self.offX = 85
		self.startX = -85*6 + 45
		self.startY = 45
	else
		self.offY = -85
		self.startX = -50
		self.startY = 85*6 - 45
	end

	self.spriteList_ = {}
	for i=1,7,1 do
		local s = display.newSprite()
			:pos(self.startX + (i-1)*self.offX,self.startY + (i-1)*self.offY)
			:addTo(self.clipNode_)
			:hide()
		self.spriteList_[i] = s
		ScaleButton(s):onButtonClicked(function()
			tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
			if s.expId then
        		self:sendExpress_(s.expId)
        	end
		end)
	end
	cc.Node.hide(self)
	self.useExpId_ = sa.EventCenter:addEventListener("PLAYER_USE_EXP", handler(self, self.onPlayerUseExp_))
end

function ChatFastExp:sendExpress_(id)
	local isVipExp, price = tx.checkIsVipExpression(id)
	if isVipExp then
		if not tx.checkIsVip() then
            if tx.userData.isShowVipExpTips then
                tx.ui.Dialog.new({
                    messageText = sa.LangUtil.getText("VIP", "SEND_EXPRESSIONS_TIPS"),
                    firstBtnText =sa.LangUtil.getText("VIP", "COST_CHIPS", price),
                    secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
                    callback = function(param)
                        if param == tx.ui.Dialog.FIRST_BTN_CLICK then
                            tx.userData.isShowVipExpTips = false
                            self:sendVipExpress_(id, price)
                        elseif param == tx.ui.Dialog.SECOND_BTN_CLICK then
                            tx.PayGuideManager:openStore(4)
                            self:hidePanel()
                        end
                    end
                }):show()
            else
                self:sendVipExpress_(id, price)
            end
	    else
	    	self:sendFreeExpress_(id)
		end
    else
        self:sendFreeExpress_(id)
    end
end

function ChatFastExp:sendVipExpress_(id, price)
    tx.sendVipExpression({
        sendType = 1,
        id = id,
        price = price,
        callback = function()
            tx.socket.HallSocket:sendExpression(id,0)
        end
    })
end

function ChatFastExp:sendFreeExpress_(id)
    tx.socket.HallSocket:sendExpression(id,0)
end

function ChatFastExp:onPlayerUseExp_(evt)
	if self:isVisible() and not self.isHiding_ and evt and evt.data then
		local expId = evt.data
		local s = nil
		for i=1,6,1 do
			s = self.spriteList_[i]
			if tonumber(expId)==tonumber(s.expId) then
				return
			end
		end
		for i=1,7,1 do
			s = self.spriteList_[i]
			s:stopAllActions()
		end

		local lastIndex = 7
		s = self.spriteList_[lastIndex]
		s:pos(self.startX + (lastIndex-1)*self.offX,self.startY + (lastIndex-1)*self.offY)
		local type = tonumber(string.sub(expId,1,1))
		display.addSpriteFrames("expressionsbtns_"..type..".plist", "expressionsbtns_"..type..".png", function()
			local s = self.spriteList_[lastIndex]
   			local ss = display.newSprite("#expression_btn_" .. expId .. ".png")
   			local size = ss:getContentSize()
   			if size.width>size.height then
   				s:scale(BTN_WIDTH/size.width)
   			else
   				s:scale(BTN_WIDTH/size.height)
   			end
   			s:setSpriteFrame(ss:getSpriteFrame())
   			ScaleButton(s)
   			s.expId = tonumber(expId)
   			-- 缓动
	        for i=1,7,1 do
				transition.moveTo(self.spriteList_[i], {time=0.2, x=self.startX+(i-2)*self.offX, y=self.startY+(i-2)*self.offY, onComplete=function() 
	                if i==1 then
	                    local s = table.remove(self.spriteList_,1,1)
	                    table.insert(self.spriteList_,s)
	                end
	            end})
			end
        end)
	end
end

function ChatFastExp:show()
	if self:isVisible() and not self.isHiding_ then
		return self
	end
	local s = tx.userDefault:getStringForKey("EXP_SORT","13,16,19,312,33,320")
	if self.s_~=s then
		self.s_ = s
		self.exp_sort_ = string.split(s,",")
		if not self.exp_sort_ or #self.exp_sort_<1 then
	        self.exp_sort_ = {13,16,19,312,33,320}
	    end
	   	for k,v in ipairs(self.exp_sort_) do
	   		if k>=1 and k<=6 then
		   		v = v..""
		   		local expType = tonumber(string.sub(v,1,1))
		   		display.addSpriteFrames("expressionsbtns_"..expType..".plist", "expressionsbtns_"..expType..".png", function()
		   			local s = self.spriteList_[k]
		   			local ss = display.newSprite("#expression_btn_" .. v .. ".png")
		   			local size = ss:getContentSize()

		   			if size.width>size.height then
		   				if expType==3 then
		   					s:scale((BTN_WIDTH+15)/size.width)
		   				else
		   					s:scale(BTN_WIDTH/size.width)
		   				end
		   			else
		   				if expType==3 then
		   					s:scale((BTN_WIDTH+15)/size.height)
		   				else
		   					s:scale(BTN_WIDTH/size.height)
		   				end
		   			end
		   			s:setSpriteFrame(ss:getSpriteFrame())
		   			s:show()
		   			ScaleButton(s)
		   			s.expId = tonumber(v)
		        end)
		    end
	   	end
	end
	self.isHiding_ = nil
	self:stopAllActions()
	self:setPositionY(-100)
	transition.moveTo(self, {y = 0, time=0.2})
	cc.Node.show(self)
end

function ChatFastExp:hide()
	self.isHiding_ = true
	self:stopAllActions()
	transition.moveTo(self, {y = -100, time=0.2,onComplete=function() 
        self.isHiding_ = nil
        cc.Node.hide(self)
    end})
end

function ChatFastExp:onCleanup()
	for i=1,10,1 do
		display.removeSpriteFramesWithFile("expressionsbtns_"..i..".plist", "expressionsbtns_"..i..".png")
	end
	sa.EventCenter:removeEventListener(self.useExpId_)
end

return ChatFastExp