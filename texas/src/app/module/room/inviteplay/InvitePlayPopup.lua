local roomData = nil -- 当前桌子信息
local invitedData = nil -- 当前已经邀请的

local filterUser = function(data,needSet)
	local list = {}
	if data then
		if roomData and roomData.playerList then
			local playerList = roomData.playerList
			for k,v in pairs(data) do
				if needSet==true then
					v.isOnline = 1
					v.img = v.s_picture
				end
				if tonumber(v.uid)~=tx.userData.uid then  -- 自己要删除
					local addInTo = true
					for kk,vv in pairs(playerList) do
						if tonumber(v.uid)==vv.uid then
							addInTo = false
							break
						end
					end
					if addInTo==true then
						table.insert(list,v)
					end
				end
			end
		else
			for k,v in pairs(data) do
				if needSet==true then
					v.isOnline = 1
					v.img = v.s_picture
				end
				if tonumber(v.uid)~=tx.userData.uid then  -- 自己要删除
					table.insert(list,v)
				end
			end
		end
	end
	return list
end
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local InvitePlayItem = class("InvitePlayItem", sa.ui.ListItem)
InvitePlayItem.WIDTH = 460
InvitePlayItem.HEIGHT = 135

InvitePlayItem.ELEMENTS = {
    "iconOnline",
    "nodeHead",
    "iconSex",
    "labelName",
    "labelChips",
    "btnInvite",
    "labelInvite"
}

function InvitePlayItem:ctor()
	self:setNodeEventEnabled(true)
	InvitePlayItem.super.ctor(self, InvitePlayItem.WIDTH, InvitePlayItem.HEIGHT)
end

function InvitePlayItem:lazyCreateContent()
	if not self.created_ then
        self.created_ = true
        self.dataChanged_ = true
        tx.ui.EditPanel.bindElementsToTarget(self,"dialog_room_invite_play_item.csb",true)
        self.editView:pos(InvitePlayItem.WIDTH*0.5, InvitePlayItem.HEIGHT*0.5)

        self.avatar_ = SimpleAvatar.new()
	        :addTo(self.nodeHead)
	    NormalButton(self.avatar_):onButtonClicked(function()
	        local OtherUserPopup = require("app.module.userInfo.OtherUserPopup")
        	OtherUserPopup.new(self.data_):showPanel()
	    end)
	    self.avatar_:setTouchSwallowEnabled(false)
	    -- 按钮哦
	    ImgButton(self.btnInvite,"#common/btn_small_green.png","#common/btn_small_green_down.png"):onButtonClicked(function()
	    	tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
	    	if self.isStop_==true then return; end  -- 每3秒发送一次
	    	self.isStop_ = true
	    	self.btnInvite:performWithDelay(function()
	    		self.isStop_ = nil
	    	end,3)
	    	local msgData = {
	    		type = consts.PUSH_TYPE.PUSH_INVITE_PLAY,
    			tid = tx.socket.HallSocket.curTid,
    			gameLevel = tx.socket.HallSocket.curGameLevel,
    			gameId = tx.socket.HallSocket.curGameId,
    			pwd = tx.socket.HallSocket.curGamePwd,
    			uid = tx.userData.uid,
	            nick = tx.userData.nick, --昵称
	            img = tx.userData.s_picture,
	            sex = tx.userData.sex,
    		}
    		local jsonMsg = json.encode(msgData)
	    	if tonumber(self.data_.isOnline) == 1 then --0不在线 1在线
		    	sa.HttpService.CANCEL(self.inviteId_)
		        self.inviteId_ = sa.HttpService.POST(
			        {
			            mod = "Speaker",
			            act = "inviteFriPlaying",
			            touid = self.data_.uid,
			            msg = jsonMsg,
			        },
			        function(jsondata)
			        	local jsondata_ = json.decode(jsondata)
			        	if jsondata_ and jsondata_.code==1 then
			        		self:changeToInvited()
			        	end
			        end,
			        function(data)
			        	
			        end)
		   	else
		   		-- 发送推送
		   		local games = sa.LangUtil.getText("COMMON", "GAME_NAMES")
		   		local gameName = games[msgData.gameId] or ""
		   		local msg = sa.LangUtil.getText("FRIEND","ROOM_INVITE_TIPS_CON",msgData.nick or "",gameName,"")
		   		sa.HttpService.CANCEL(self.pushId_)
		   		self.pushId_ = sa.HttpService.POST(
			        {
			            mod = "User",
			            act = "pushMsgToOneUser",
			            touid = self.data_.uid,
			            title = sa.LangUtil.getText("FRIEND","ROOM_INVITE_TITLE"),
			            msg = msg,
			            param = jsonMsg,
			        },
			        function(jsondata)
			        	local jsondata_ = json.decode(jsondata)
			        	if jsondata_ and jsondata_.code==1 then
			        		self:changeToInvited()
			        	end
			        end,
			        function(data)
			        	
			        end)
		   	end
	    end)
	    self.btnInvite:setTouchSwallowEnabled(false)
   	end
   	if self.data_ and self.dataChanged_ then
        self.dataChanged_ = false
        if invitedData and invitedData[self.data_.uid] then
        	-- self.btnInvite:setButtonEnabled(false,cc.c3b(150,150,150))
        	self.btnInvite:hide()
        	self.labelInvite:setString(sa.LangUtil.getText("FRIEND","INVITE_SENDED"))
    		sa.fitSprteWidth(self.labelInvite, 100)
        else
        	-- self.btnInvite:setButtonEnabled(true)
        	self.btnInvite:show()
    		self.labelInvite:setString(sa.LangUtil.getText("FRIEND","SEND_INVITE"))
    		sa.fitSprteWidth(self.labelInvite, 100)
        end
        if self.data_.sex == "f" then
	        self.iconSex:setSpriteFrame("common/common_sex_female.png")
	        self.avatar_:setSpriteFrame("common/icon_female.png")
	    else
	        self.iconSex:setSpriteFrame("common/common_sex_male.png")
	        self.avatar_:setSpriteFrame("common/icon_male.png")
	    end
        if tonumber(self.data_.isOnline) == 1 then --0不在线 1在线
        	self.iconOnline:setSpriteFrame("common/icon_online.png")
	    else
	        self.iconOnline:setSpriteFrame("common/icon_offline.png")
	    end
	    -- self.labelName:setString(sa.limitNickLength(self.data_.nick, 20))
	    self.labelName:setString(tx.Native:getFixedWidthText("", 26, self.data_.nick or "", 160))
	    self.labelChips:setString(sa.formatNumberWithSplit(self.data_.money))
	    if self.data_.img and type(self.data_.img)=="string" and string.len(self.data_.img) > 5 then
        	self.avatar_:loadImage(self.data_.img)
    	end
    end
end

function InvitePlayItem:changeToInvited()
	if not invitedData then invitedData={} end
	invitedData[self.data_.uid] = true
	-- self.btnInvite:setButtonEnabled(false,cc.c3b(170,170,170))
	self.btnInvite:hide()
	self.labelInvite:setString(sa.LangUtil.getText("FRIEND","INVITE_SENDED"))
	tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "ROOM_INVITE_SUCCTIPS"))
end

function InvitePlayItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function InvitePlayItem:onCleanup()
	sa.HttpService.CANCEL(self.inviteId_)
	sa.HttpService.CANCEL(self.pushId_)
end

----------------------------------------------------------------------------------------------------------

local InvitePlayPopup = class("InvitePlayPopup", function() return display.newNode() end)
InvitePlayPopup.INDEX = 1

InvitePlayPopup.ELEMENTS = {
    "bg",
    "labelTitle",
    "bgTitle.bgTab",
    "nodeList",
    "labelNo"
}

function InvitePlayPopup:ctor(data)
	roomData = data
	invitedData = {}
	self.this_ = self
	self.data_ = {
		tabData = {   -- 详细数据
			nil,
			nil
		},
		tabStatus = {   -- 请求状态
			false,
			false
		},
		tabPage = {   -- 数据页码  false为数据终结
			1,
			1
		}
	}
	self:setNodeEventEnabled(true)
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_room_invite_play.csb",true)
	self.bg:setTouchEnabled(true)
	self.labelNo:hide()
	self.labelTitle:setString(sa.LangUtil.getText("FRIEND","ROOM_INVITE_TITLE"))
	local listW,listH = 474,456

	local size = self.bgTitle.bgTab:getContentSize()
	self.tab_ = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("FRIEND", "ROOM_INVITE_TAB"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 26},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 26}
        },
        true, true)
		:setTabBarSize(size.width, 48, 0, 0)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.bgTitle.bgTab)

	self.inviteList_ = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * listW, -0.5 * listH, listW, listH),
            upRefresh = handler(self, self.getNewData_)
        }, InvitePlayItem)
		:addTo(self.nodeList)

	self.tab_:gotoTab(InvitePlayPopup.INDEX, true)
end

function InvitePlayPopup:onTabChanged_(selectedTab,onlyShow)
	self:setLoading(false)
	self.curIndex_ = selectedTab
	InvitePlayPopup.INDEX = selectedTab
	local tabData = self.data_.tabData[self.curIndex_]
	local tabStatus = self.data_.tabStatus[self.curIndex_]
	local tabPage = self.data_.tabPage[self.curIndex_]
	if (not tabData or #tabData<1) and tabPage==false then  -- 请求了没有数据
		self.inviteList_:setData(nil)
		self.labelNo:show()
		if self.curIndex_==1 then
			self.labelNo:setString(sa.LangUtil.getText("RANKING","NOT_DATA_TIPS"))
		else
			self.labelNo:setString(sa.LangUtil.getText("FRIEND","NO_FRIEND_TIP"))
		end
		return;
	end
	self.labelNo:hide()
	if tabData and #tabData>0 then -- 有数据直接显示
		if onlyShow==true then
			self.inviteList_:setData(tabData,true)
		else
			self.inviteList_:setData(tabData)
		end
		return
	end
	if onlyShow==true then -- 获取到数据只展示
		return
	end
	-- 没数据需求请求
	self:getNewData_()
end

function InvitePlayPopup:getNewData_()
	local tabPage = self.data_.tabPage[self.curIndex_]
	if tabPage==false then
		return
	end
	local tabStatus = self.data_.tabStatus[self.curIndex_]
	self:setLoading(true)
	if tabStatus==true then  -- 正在请求数据
		return
	end
	-- 请求
	if self.curIndex_==1 then
		self.data_.tabStatus[1] = true
		sa.HttpService.CANCEL(self.tab1RequestId_)
		local blind = roomData and roomData.roomInfo.blind
        self.tab1RequestId_ = sa.HttpService.POST(
	        {
	            mod = "Online",
	            act = "getOnlineUser",
	            page = tabPage,
	            gameId = tx.socket.HallSocket.curGameId or 1,
	            blind = blind or 50
	        },
	        function(jsondata)
	        	if self.this_ then
		        	self.data_.tabStatus[1] = false
		        	local jsondata_ = json.decode(jsondata)
	        		local data = (jsondata_ and jsondata_.list) or {}
	        		if #data == 0 then -- 最后一页
	        			self.data_.tabPage[1] = false
	        		else
	        			data = filterUser(data,true)
	        			-- self.data_.tabPage[1] = false -- 直接最后一页
	        			self.data_.tabPage[1] = self.data_.tabPage[1] + 1
	        			if not self.data_.tabData[1] then
	        				self.data_.tabData[1] = data
	        			else
	        				table.insertto(self.data_.tabData[1],data)
	        			end
	        		end
	        		if self.curIndex_==1 then
	        			self:onTabChanged_(self.curIndex_,true)
	        		end
		        end
	        end,
	        function(data)
	        	if self.this_ then
		        	self.data_.tabStatus[1] = false
		            if self.curIndex_==1 then
	        			self:onTabChanged_(self.curIndex_,true)
	        		end
		        end
	        end)
	elseif self.curIndex_==2 then
		self.data_.tabStatus[2] = true
		sa.HttpService.CANCEL(self.tab2RequestId_)
        self.tab2RequestId_ = sa.HttpService.POST(
	        {
	            mod = "friend",
	            act = "list",
	            new = 1,
	            page = tabPage
	        },
	        function(jsondata)
	        	if self.this_ then
	        		self.data_.tabStatus[2] = false
		        	local jsondata_ = json.decode(jsondata)
	        		local data = (jsondata_ and jsondata_.flist) or {}
	        		if #data == 0 then -- 最后一页
	        			self.data_.tabPage[2] = false
	        		else
	        			data = filterUser(data)
	        			self.data_.tabPage[2] = self.data_.tabPage[2] + 1
	        			if not self.data_.tabData[2] then
	        				self.data_.tabData[2] = data
	        			else
	        				table.insertto(self.data_.tabData[2], data)
	        			end

	        			-- sa.sortFriendData(self.data_.tabData[2])
	        		end

	        		if self.curIndex_==2 then
	        			self:onTabChanged_(self.curIndex_,true)
	        		end
		        end
	        end,
	        function(data)
	        	if self.this_ then
		        	self.data_.tabStatus[2] = false
		            if self.curIndex_==2 then
	        			self:onTabChanged_(self.curIndex_,true)
	        		end
		        end
	        end)
	end
end

function InvitePlayPopup:setLoading(isLoading)
	if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, -40)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function InvitePlayPopup:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function InvitePlayPopup:onShow()
	if self.inviteList_ then
		self.inviteList_:setScrollContentTouchRect()
	end
end

function InvitePlayPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=-470 * 0.5, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function InvitePlayPopup:onShowPopup()
    self:stopAllActions()
    self:pos(-470 * 0.5,display.cy)
    transition.moveTo(self, {time=0.2, x=470 * 0.5, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
    end})
end

function InvitePlayPopup:onCleanup()
	roomData = nil
	invitedData = nil
    sa.HttpService.CANCEL(self.tab1RequestId_)
	sa.HttpService.CANCEL(self.tab2RequestId_)
end

return InvitePlayPopup