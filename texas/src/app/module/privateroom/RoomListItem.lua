local SimpleAvatar  = import("openpoker.ui.SimpleAvatar")
local OtherUserPopup = import("app.module.userInfo.OtherUserPopup")

local RoomListItem = class("RoomListItem", sa.ui.ListItem)
RoomListItem.WIDTH = 1000
RoomListItem.HEIGHT = 155

RoomListItem.ELEMENTS = {
	"bg",
	"nodeHead.head1",
	"nodeHead.head2",
	"nodeHead.head3",
	"nodeHead.more",
	"nodeHead.own.label",

	"nodeRight.enter.label",
	"nodeRight.lock",
	"nodeRight.pro",
	"nodeRight.labelPro",

	"nodeCenter.labelId",
	"nodeCenter.labelName",
	"nodeCenter.labelBlind",
	"nodeCenter.iconFast",
	"nodeCenter.labelTime",
}

function RoomListItem:ctor()
	self.this_ = self
	RoomListItem.super.ctor(self, RoomListItem.WIDTH, RoomListItem.HEIGHT)
end

function RoomListItem:lazyCreateContent()
	if not self.created_ then
		self.created_ = true
		self.dataChanged_ = true
		tx.ui.EditPanel.bindElementsToTarget(self,"private_room_item.csb",true)
		self.editView:pos(RoomListItem.WIDTH*0.5,RoomListItem.HEIGHT*0.5+5)
		local size = self.bg:getContentSize()
		local width,height = RoomListItem.WIDTH-18,size.height
		self.w_,self.h_ = width,height
		self.bg:setContentSize(cc.size(width,height))
		self.nodeHead:setPositionX(-width*0.5)
		self.nodeRight:setPositionX(width*0.5)
		self.nodeHead.own.label:setString(sa.LangUtil.getText("PRIVTE", "OWNER"))
		sa.fitSprteWidth(self.nodeHead.own.label, 66)
		ImgButton(self.nodeRight.enter,"#dialogs/privateroom/green.png","#dialogs/privateroom/green_d.png")
			:onButtonClicked(function()
				tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
				self:checkJoin(true)
			end)
		ColorButton(self.nodeHead.head1)
			:onButtonClicked(function()
				tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
				if self.nodeHead.head1.data then
					OtherUserPopup.new(self.nodeHead.head1.data):showPanel()
				else
					self:checkJoin()
				end
			end)
		ColorButton(self.nodeHead.head2)
			:onButtonClicked(function()
				tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
				if self.nodeHead.head2.data then
					OtherUserPopup.new(self.nodeHead.head2.data):showPanel()
				else
					self:checkJoin()
				end
			end)
		ColorButton(self.nodeHead.head3)
			:onButtonClicked(function()
				tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
				if self.nodeHead.head3.data then
					OtherUserPopup.new(self.nodeHead.head3.data):showPanel()
				else
					self:checkJoin()
				end
			end)

		local size = self.nodeRight.pro:getContentSize()
		self.progress_ = tx.ui.ProgressBar.new(
		        "#common/transparent.png",
		        "#dialogs/privateroom/pro_green.png",
		        {
		            bgWidth = size.width, 
		            bgHeight = size.height,
		            fillWidth = 1,
		            fillHeight = size.height
		        }
		    )
		    :addTo(self.nodeRight.pro)
		    :pos(0,size.height*0.5)
		self.progress_:setAnchorPoint(cc.p(1, 0.5))
	   	self.progress_:setValue(0.6)
	   	-- 内部图
	   	self.proCapInsets_ = self.progress_.fill_:getCapInsets()
	   	-- 头像
	   	self.avatarIcon1_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
	   		:scale(0.57)
	        :pos(55,54)
	        :addTo(self.nodeHead.head1)
		self.avatarIcon1_.boder:hide()
		self.avatarIcon2_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
	   		:scale(0.57)
	        :pos(55,54)
	        :addTo(self.nodeHead.head2)
	        :hide()
		self.avatarIcon2_.boder:hide()
		self.avatarIcon3_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
	   		:scale(0.57)
	        :pos(55,54)
	        :addTo(self.nodeHead.head3)
	        :hide()
		self.avatarIcon3_.boder:hide()
	end
	if self.data_ and self.dataChanged_ then
		self.dataChanged_ = false
		self.nodeCenter.labelId:setString(sa.LangUtil.getText("PRIVTE", "ROOMID",self.data_.tid))

		local xx,yy = self.nodeCenter.labelName:getPosition()
		self.nodeCenter.labelName:setString("")
		local size = self.nodeCenter.labelName:getContentSize()
		xx = xx+size.width
		if self.data_.optTime<=100 then --秒乘以10
			self.nodeCenter.iconFast:show()
			self.nodeCenter.iconFast:setPositionX(xx)
			size = self.nodeCenter.iconFast:getContentSize()
			xx = xx+ size.width
		else
			self.nodeCenter.iconFast:hide()
		end
		self.nodeCenter.labelBlind:setPositionX(xx)
		local smallBlind = sa.formatBigNumber(self.data_.blind)
   		local bigBlind = sa.formatBigNumber(self.data_.blind*2)
		self.nodeCenter.labelBlind:setString(sa.LangUtil.getText("COMMON", "BLIND_BIG_SMALL", smallBlind, bigBlind))
		if self.data_.pwd==1 then
			self.nodeRight.lock:show()
		else
			self.nodeRight.lock:hide()
		end
		self:showPlayer()
		self:checkTime()
	end
end
function RoomListItem:showPlayer()
	local ownerData = nil
	local ownerId = self.data_.ownerId -- 房主
	local playerList = self.data_.playerList or {}
	local otherList = {} -- 另外两个
	for k,v in pairs(playerList) do
		if v.uid==ownerId then
			ownerData = v
		else
			if #otherList<2 then
				table.insert(otherList,v)
			else
				for kk,vv in ipairs(otherList) do  -- 优先显示有头像的
					if not vv.img or #vv.img<5 then
						otherList[kk] = v
						break
					end
				end
			end
		end
	end
	self.nodeHead.head1.data = ownerData or {uid=ownerId}
	self.nodeHead.head2.data = otherList[1]
	self.nodeHead.head3.data = otherList[2]
	if ownerData then
		self:showOwner(ownerData)
	else
		self:loadOwner()
	end
	if otherList[1] then
		self.avatarIcon2_:show()
		self.avatarIcon2_:setDefaultAvatar(otherList[1].sex)
		self:loadBigHead(self.avatarIcon2_,otherList[1].img)
	else
		self.avatarIcon2_:hide()
	end
	if otherList[2] then
		self.avatarIcon3_:show()
		self.avatarIcon3_:setDefaultAvatar(otherList[2].sex)
		self:loadBigHead(self.avatarIcon3_,otherList[2].img)
	else
		self.avatarIcon3_:hide()
	end
end

function RoomListItem:loadBigHead(avatar,avatarUrl)
	if avatar and avatarUrl and string.len(avatarUrl) > 5 then
        local imgurl = avatarUrl
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        avatar:loadImage(imgurl)
    end
end

function RoomListItem:showOwner(data)
	self.avatarIcon1_:show()
	self.avatarIcon1_:setDefaultAvatar(data.sex)
	self:loadBigHead(self.avatarIcon1_,data.img)
end
function RoomListItem:loadOwner()
	sa.HttpService.CANCEL(self.userDataRequestId_)
	self.userDataRequestId_ = sa.HttpService.POST(
        {
            mod = "User",
            act = "checkPlayer",
            cuid = self.data_.ownerId,
        },
        function (data)
        	if self.this_ then
	            local retData = json.decode(data)
	            if retData.code == 1 then
	            	local data = retData.info
	            	data.uid = self.data_.ownerId
	                data.img = data.s_picture
	                self.data_.playerList = self.data_.playerList or {}
	                table.insert(self.data_.playerList,data)
	                self.data_.reduce = true  -- 虚拟的一个人
	            	self:showOwner(data)
	            else
	            	self:loadOwner()
	            end
	        end
        end,
        function()
        	if self.this_ then
        		self:loadOwner()
        	end
        end
    )
end

function RoomListItem:checkTime()
	self.bg:stopAllActions() -- 倒计时停止
	local totalTime = self.data_.expTime
	local passTime = os.time()-self.data_.receiveTime
	local leftTime = totalTime - passTime
	if leftTime>1 then
		self.data_.isEnd = nil
		if not self.data_.playerList then self.data_.playerList={} end
		local num = #self.data_.playerList
		if self.data_.reduce then
			num = num - 1
		end
		if num<0 then
			num = 0
		end
		self.nodeRight.labelPro:setString(num.."/9")
		local str = sa.LangUtil.getText("PRIVTE","ENTERPLAY")
		ImgButton(self.nodeRight.enter,"#dialogs/privateroom/green.png","#dialogs/privateroom/green_d.png")
		if num<1 then
			self.progress_:hide()
		else
			local s = nil
			if num>=9 then
				ImgButton(self.nodeRight.enter,"#dialogs/privateroom/blue.png","#dialogs/privateroom/blue_d.png")
				s = display.newSprite("#dialogs/privateroom/pro_purple.png")
				str = sa.LangUtil.getText("PRIVTE","ENTERLOOK")
			else
				s = display.newSprite("#dialogs/privateroom/pro_green.png")
			end
			self.progress_.fill_:setSpriteFrame(s:getSpriteFrame(),self.proCapInsets_)
			self.progress_.value_ = -1 -- fix不刷新的问题
			self.progress_:setValue(num/9)
			self.progress_:show()
		end
		self.nodeRight.enter.label:setString(str)
		if leftTime>24*3600 then
			local time = leftTime/(24*3600)
			time = string.format("%.1f",time)
			self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTDAY",time))
		elseif leftTime>3600 then
			local time = leftTime/3600
			time = string.format("%.1f",time)
			self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTHOUR",time))
		else
			local time = math.ceil(leftTime/60)
			self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTMIN",time))
		end
		-- 倒计时
		self.bg:schedule(function()
			local totalTime = self.data_.expTime
			local passTime = os.time()-self.data_.receiveTime
			local leftTime = totalTime - passTime
			if leftTime>1 then
				if leftTime>24*3600 then
					local time = leftTime/(24*3600)
					time = string.format("%.1f",time)
					self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTDAY",time))
				elseif leftTime>3600 then
					local time = leftTime/3600
					time = string.format("%.1f",time)
					self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTHOUR",time))
				else
					local time = math.ceil(leftTime/60)
					self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","LEFTMIN",time))
				end
			else
				self:checkTime()
			end
		end, 1)
	else
		self.data_.isEnd = true
		self.progress_:hide()
		self.nodeRight.labelPro:setString("0/9")
		self.nodeRight.enter.label:setString(sa.LangUtil.getText("PRIVTE","ENTEREND"))
		self.nodeCenter.labelTime:setString(sa.LangUtil.getText("PRIVTE","ENTEREND"))
		ImgButton(self.nodeRight.enter,"#dialogs/privateroom/green.png","#dialogs/privateroom/green_d.png")
		self.nodeRight.enter:setButtonEnabled(false,cc.c3b(100,100,100))
	end
	sa.fitSprteWidth(self.nodeRight.enter.label, 115)
	self.nodeRight.enter:setTouchSwallowEnabled(false)
	self.nodeHead.head1:setTouchSwallowEnabled(false)
	self.nodeHead.head2:setTouchSwallowEnabled(false)
	self.nodeHead.head3:setTouchSwallowEnabled(false)
end

function RoomListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function RoomListItem:checkShowPWD(isTrace)
	if self.data_.isEnd then  -- 在确认框内等待太久了 房间已经结束了
		tx.TopTipManager:showToast(sa.LangUtil.getText("PRIVTE", "ENTERENDTIPS"))
	else
		local doEnterRoom = function(pwd)   -- 进入房间
			local roomData = {pwd = pwd, serverGameid = tx.config.TEXAS_GAME_ID, serverLevel = tx.config.TEXAS_PRI_ROOM_LEVEL, serverTid = self.data_.tid}
	    	sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = roomData})--, isTrace = isTrace
		end
		if self.data_.pwd==1 then
			local EnterRommPwdPop = require("app.module.privateroom.EnterRommPwdPop")
            EnterRommPwdPop.new(function(pwd)
                doEnterRoom(pwd)
            end):showPanel()
		else
			doEnterRoom(nil)
		end
	end
end

function RoomListItem:checkJoin(isTrace)
	if isTrace then
		self:checkShowPWD(isTrace)
	else
		tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("PRIVTE", "ENTERCHECK"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                	self:checkShowPWD(isTrace)
                end
            end
        }):show()
    end
end

function RoomListItem:onCleanup()
	sa.HttpService.CANCEL(self.userDataRequestId_)
end

return RoomListItem