local GameRecordItem = import(".GameRecordItem")
local GameRecordPopup = class("GameRecordPopup", tx.ui.Panel)

local timeSort = function(a,b)
	if a.tableInfo and b.tableInfo and a.tableInfo.time and b.tableInfo.time then
		return a.tableInfo.time>b.tableInfo.time
	end
	return true
end
local winSort = function(a,b)
	if a.tableInfo and b.tableInfo and a.tableInfo.result and b.tableInfo.result then
		return a.tableInfo.result>b.tableInfo.result
	end
	return true
end

local WIDTH, HEIGHT = 1040, 746
function GameRecordPopup:ctor(isInRoom)
	self.isInRoom_ = isInRoom
	GameRecordPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("USERINFO","BOARD"))
    self:initViews_()
end

function GameRecordPopup:initViews_()
	display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(WIDTH - 56, 555))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 30)
        :addTo(self.background_)

	self.noRecordLabel_ = ui.newTTFLabel({size=32, text=sa.LangUtil.getText("USERINFO","NO_RECORD")})
        :addTo(self)
        :hide()

	--牌局列表
    local list_w, list_h = 960, 540
    self.recordListView_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h),
                upRefresh = handler(self, self.onGameRecordFrefresh_)
            },
            GameRecordItem
        )
        :pos(0, -65)
        :addTo(self)

	local text = sa.LangUtil.getText("USERINFO", "BOARD_SORT")
	self.tab_ = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        text,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
        }, true, true)
        :setTabBarSize(538, 52, 0, -4)
        :onTabChange(handler(self, self.onTabChange_))
        :pos(0, 245)
        :addTo(self)

    --请求数据
    self.tab_:gotoTab(1, true)
end

function GameRecordPopup:onShowed()
	if self.recordListView_ then
		self.recordListView_:setScrollContentTouchRect()
	end
end

function GameRecordPopup:onTabChange_(selectedTab)
	if self.isInRoom_ then
		if not _G.LocalGameRecord or #_G.LocalGameRecord<1 then
   			self.noRecordLabel_:show()
   		else
   			local isFirst = false
   			if not self.data_ then
   				self:parseData(_G.LocalGameRecord)
   				self.data_ = _G.LocalGameRecord
   				isFirst = true
   			end
   			if selectedTab==1 then
				table.sort(self.data_,timeSort)
			elseif selectedTab==2 then
				table.sort(self.data_,winSort)
			end
   			self.recordListView_:setData(self.data_)
   		end
	else
		if not self.data_ then
			self.page_ = 1
			self:onGameRecordFrefresh_()
		else
			if selectedTab==1 then
				table.sort(self.data_,timeSort)
			elseif selectedTab==2 then
				table.sort(self.data_,winSort)
			end
			self.recordListView_:setData(self.data_)
		end
	end
end

function GameRecordPopup:onGameRecordFrefresh_()
	if self.isInRoom_ then return; end
	if not self.isLoading_ then
		self.isLoading_ = true
		self:setLoading(true)
		sa.HttpService.CANCEL(self.gameRecordId_)
		self.gameRecordId_ = sa.HttpService.POST(
	        {
	            mod = "Handhistory",
	            act = "getList",
	            page = self.page_,
	        },
	        function (data)
	            local retData = json.decode(data)
	            if retData and retData.code == 1 then
	            	local list = retData.list
	                self.isLoading_ = false
	                self:setLoading(false)
	               	if not list or #list<1 then
	               		self.isLoading_ = true
	               		if not self.data_ or #self.data_<1 then
	               			self.noRecordLabel_:show()
	               		end
	               	else
	               		self:parseData(list)
	               		-- 排序
	               		local index = self.tab_:getSelectedTab()
	               		if index==1 then
	               			table.sort(list,timeSort)
	               		elseif index==2 then
	               			table.sort(list,winSort)
	               		end
	               		if not self.data_ then
	               			self.data_ = list
	               		else
	               			table.insertto(self.data_,list)
	               		end
	               		self.page_ = self.page_ + 1
	               		self.recordListView_:setData(self.data_,true)
	               		if #self.data_<1 then
	               			self.noRecordLabel_:show()
	               		end
	               	end
	           	else  -- 拉到了页尾
	           		self:setLoading(false)
	           		self.isLoading_ = true
	            end
	        end,
	        function()
	        	self.isLoading_ = false
				self:setLoading(false)
	        end
	    )
	end
end

function GameRecordPopup:parseData(list)
	-- 赋值座位号
	local handHas0x = nil
	local pubHas0x = nil
	local cardStart = nil
	local cardEnd = nil
	for k,v in pairs(list) do
		-- seatid返回都是0的BUG
		local have_0_Seat = false
		local selfIsInGame = false
		for kk,vv in pairs(v) do
			if kk~="tableInfo" then
				-- "hh_twohandcards": "0x2d,0x2c,0x3",
				-- "hh_commoncards": "0x180x350x1c0x3d0x31",
				handHas0x = string.find(vv.hh_twohandcards or "","0x")
				pubHas0x = string.find(vv.hh_commoncards or "","0x")
				--解析手牌  解析两种牌型...
				if handHas0x==1 then
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"(0x)%x[1-9A-Fa-f]?",1)
					if cardStart then
						vv.hand1 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
					else
						vv.hand1 = 0
						cardEnd = 0
					end
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"(0x)%x[1-9A-Fa-f]?",cardEnd+1)
					if cardStart then
						vv.hand2 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
					else
						vv.hand2 = 0
					end
					-- 奥马哈
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"(0x)%x[1-9A-Fa-f]?",cardEnd+1)
					if cardStart then
						vv.hand3 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
						cardStart,cardEnd = string.find(vv.hh_twohandcards,"(0x)%x[1-9A-Fa-f]?",cardEnd+1)
						if cardStart then
							vv.hand4 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
						end
					else
						vv.hand3 = nil
						vv.hand4 = nil
					end
				else
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"%x%x",1)
					if cardStart then
						vv.hand1 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
					else
						vv.hand1 = 0
						cardEnd = 0
					end
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"%x%x",cardEnd+1)
					if cardStart then
						vv.hand2 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
					else
						vv.hand2 = 0
					end
					-- 奥马哈
					cardStart,cardEnd = string.find(vv.hh_twohandcards,"%x%x",cardEnd+1)
					if cardStart then
						vv.hand3 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
						cardStart,cardEnd = string.find(vv.hh_twohandcards,"%x%x",cardEnd+1)
						if cardStart then
							vv.hand4 = tonumber(string.sub(vv.hh_twohandcards,cardStart,cardEnd))
						end
					else
						vv.hand3 = nil
						vv.hand4 = nil
					end
				end
				-- 解析公共牌
				if pubHas0x==1 then
					cardStart,cardEnd = nil,0
					for i=1,5,1 do
						cardStart,cardEnd = string.find(vv.hh_commoncards,"(0x)%x[1-9A-Fa-f]?",cardEnd+1)
						if cardStart then
							vv["pubCard"..i] = tonumber(string.sub(vv.hh_commoncards,cardStart,cardEnd))
						else
							for j=i,5,1 do
								vv["pubCard"..i] = 0
							end
							break;
						end
					end
				else
				cardStart,cardEnd = nil,0
				for i=1,5,1 do
						cardStart,cardEnd = string.find(vv.hh_commoncards,"%x%x",cardEnd+1)
						if cardStart then
							vv["pubCard"..i] = tonumber(string.sub(vv.hh_commoncards,cardStart,cardEnd))
						else
							for j=i,5,1 do
								vv["pubCard"..i] = 0
							end
							break;
						end
					end
				end
				-- 赋值公共牌
				local info = v.tableInfo or {}
				v.tableInfo = info
				info.pubCard1 = (info.pubCard1==0 or info.pubCard1==nil) and vv.pubCard1 or info.pubCard1
				info.pubCard2 = (info.pubCard2==0 or info.pubCard2==nil) and vv.pubCard2 or info.pubCard2
				info.pubCard3 = (info.pubCard3==0 or info.pubCard3==nil) and vv.pubCard3 or info.pubCard3
				info.pubCard4 = (info.pubCard4==0 or info.pubCard4==nil) and vv.pubCard4 or info.pubCard4
				info.pubCard5 = (info.pubCard5==0 or info.pubCard5==nil) and vv.pubCard5 or info.pubCard5
				-- 解析座位
				vv.seatid = tonumber(vv.seatid) or tonumber(kk-1)
				if vv.seatid==0 then
					if have_0_Seat then
						vv.seatid = tonumber(kk-1)
					end
					have_0_Seat = true
				end
				-- 赋值桌子信息
				if tonumber(vv.hh_uid)==tx.userData.uid then
					local info = v.tableInfo or {}
					v.tableInfo = info
					info.id = tonumber(k) + (self.data_ and #self.data_ or 0)
					info.seatid = tonumber(vv.seatid) or tonumber(kk-1)
					info.blind = tonumber(vv.hh_base) or 50
					info.time = tonumber(vv.hh_endtime) or os.time()
					info.hand1 = vv.hand1
					info.hand2 = vv.hand2
					info.hand3 = vv.hand3
					info.hand4 = vv.hand4
					info.result = tonumber(vv.hh_wincoins)
					vv.isSelf = true
					selfIsInGame = true
				elseif tonumber(vv.hh_isfold)==1 then -- 特殊处理下弃牌
					vv.hand1 = 0
					vv.hand2 = 0
					vv.hand3 = (vv.hand3 and 0)
					vv.hand4 = (vv.hand4 and 0)
				end
				-- 自己旁观的...
				if kk==#v and not selfIsInGame then
					local info = v.tableInfo or {}
					v.tableInfo = info
					info.id = tonumber(k) + (self.data_ and #self.data_ or 0)
					info.blind = tonumber(vv.hh_base) or 50
					info.time = tonumber(vv.hh_endtime) or os.time()
					info.hand1 = 0
					info.hand2 = 0
					info.hand3 = (vv.hand3 and 0)
					info.hand4 = (vv.hand4 and 0)
					info.result = 0
				end
			end
		end
	end
end

function GameRecordPopup:onCleanup()
	self.data_ = nil
	sa.HttpService.CANCEL(self.gameRecordId_)
end

return GameRecordPopup