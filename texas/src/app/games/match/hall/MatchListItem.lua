local MatchListItem = class("MatchListItem", sa.ui.ListItem)
MatchListItem.WIDTH = 80
MatchListItem.HEIGHT = 150

MatchListItem.ELEMENTS = {
	"bg",
	"table.labelName",
	"table.labelPlayer",
	"real.nodeReal",
	"nodeAward.icon_1",
	"nodeAward.icon_2",
	"nodeAward.icon_3",
	"nodeAward.label_1",
	"nodeAward.label_2",
	"nodeAward.label_3",
	"progress.label",
	"labelCost",
	"btnReg.labelReg",
}

local MTT_ICON = {
	"match_real_reward_1.png",
	"match_real_reward_2.png",
	"match_real_reward_3.png",
	"match_real_reward_4.png",
	"match_real_reward_5.png",
	"match_real_reward_6.png",
	"match_real_reward_7.png",
	"match_real_reward_8.png",
}

local SNG_ICON = {
	"match/hall/table1.png",
	"match/hall/table2.png",
	"match/hall/table3.png",
	"match/hall/table4.png",
}

local NAME_COLOR = {
	cc.c3b(0x5c, 0xf0, 0x84),
	cc.c3b(0x7d, 0xda, 0xff),
	cc.c3b(0xde, 0x85, 0xff),
	cc.c3b(0xf3, 0xcc, 0x47),
}

function MatchListItem:ctor()
	self:setNodeEventEnabled(true)
	MatchListItem.super.ctor(self, MatchListItem.WIDTH, MatchListItem.HEIGHT)
end

function MatchListItem:lazyCreateContent()
	if not self.created_ then
		self.created_ = true
		self.dataChanged_ = true
		local itemWidth = MatchListItem.WIDTH/5
		self.nodeItem_ =  tx.ui.EditPanel.bindElementsToTarget(self,"match_hall_list_item.csb",true)
			:pos(MatchListItem.WIDTH*0.5, MatchListItem.HEIGHT*0.5)
		local bgSize = self.bg:getContentSize()
		self.bg:setContentSize(cc.size(MatchListItem.WIDTH,bgSize.height))
		self.table:setPositionX(-MatchListItem.WIDTH*0.5+143)
		self.real:setPositionX(-MatchListItem.WIDTH*0.5+133)
		self.nodeAward:setPositionX(-MatchListItem.WIDTH*0.5 + itemWidth*1.5)
		self.progress:setPositionX(-MatchListItem.WIDTH*0.5 + itemWidth*2.5-20)
		self.labelCost:setPositionX(-MatchListItem.WIDTH*0.5 + itemWidth*3.5 + 70)
		self.btnReg:setPositionX(MatchListItem.WIDTH*0.5-2)

		self.progress.label:setLocalZOrder(1)
		local size = self.progress:getContentSize()
		self.progress_ = tx.ui.ProgressBar.new(
		        "#common/transparent.png",
		        "#common/common_progress_green.png",
		        {
		            bgWidth = size.width, 
		            bgHeight = size.height,
		            fillWidth = 26,
		            fillHeight = 20
		        }
		    )
			:setZeroState(true)
			:setValue(0)
			:align(display.CENTER, 0, size.height*0.5)
		    :addTo(self.progress)

		NormalButton(self.nodeItem_):onButtonClicked(function(evt)
				if not self.isClickRegBtn_ then  -- 点击了报名按钮
					tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
					local list = self:getOwner()
					if list.onItemClickListener then
						list.onItemClickListener(self.data_, 1)
					end
				end
			end)
			:onButtonRelease(function(evt)
				self.isClickRegBtn_ = false
			end)

		ImgButton(self.btnReg,"#match/hall/btn_yellow.png","#match/hall/btn_yellow_down.png")
			:onButtonClicked(function(evt)
				tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
				local list = self:getOwner()
				if list.onItemClickListener then
					list.onItemClickListener(self.data_, 2)
				end
			end)
			:onButtonPressed(function(evt)
				self.isClickRegBtn_ = true
			end)

		self.nodeItem_:setTouchSwallowEnabled(false)
		self.btnReg:setTouchSwallowEnabled(false)
		self.regCountChangeId_ = tx.matchProxy:addEventListener("MATCH_REG_COUNT_CHANGE", handler(self, self.onRegCountChange_))
		self.regStatusChangeId_ = tx.matchProxy:addEventListener("MATCH_REG_STATUS_CHANGE", handler(self, self.onRegStatusChange_))
		self:schedule(function()
			if self:isVisible() then
				self:updateRegisterCount_()
			end
		end, 15)
	end

	if self.data_ and self.dataChanged_ then
		self.dataChanged_ = false
		self:flushView()
	end
end

function MatchListItem:flushView()
	local data = self.data_
	if data.matchType == "sng" then
		self.table:setSpriteFrame(SNG_ICON[data.imgIndex])
		self.table:show()
		self.real:hide()

		self.table.labelName:setString(data.name)
		self.table.labelName:setColor(NAME_COLOR[data.imgIndex])
		
		self.table.labelPlayer:setString(data.player)
		-- 长度适配
		sa.fitSprteWidth(self.table.labelName, 213)
	else
		self.table:hide()
		self.real:show()
	end

	local y = 0
	local len = #data.reward
	if len == 3 then
		y = 22
	end
	self.nodeAward:setPositionY(y)

	for i = 1, 3 do
		self.nodeAward["icon_" .. i]:hide()
		self.nodeAward["label_" .. i]:hide()
	end

	for i = 1, len do
		self.nodeAward["icon_" .. i]:show()
		self.nodeAward["label_" .. i]:show()
		local reward = data.reward[i].chips
		if reward >= 100000 then
			reward = sa.formatBigNumber(reward)
		end
		self.nodeAward["label_" .. i]:setString(reward)
	end

	data.online = 0 --强制显示所有为0，然后根据server同步
	self.progress.label:setString(data.online .. "/" .. data.player)
	self.progress_:setValue(data.online / data.player)

	local cost
	if data.registerCost >= 100000 then
		cost = sa.formatBigNumber(data.registerCost) .. "+" .. sa.formatBigNumber(data.serverCost)
	else
		cost = data.registerCost .. "+" .. data.serverCost
	end

	self.labelCost:setString(cost)

	self:onRegStatusChange_()

	self:updateRegisterCount_()
end

function MatchListItem:onRegCountChange_(evt)
	local level = self.data_.matchlevel
	local count = tx.matchProxy.online and tx.matchProxy.online[level] or 0
	self.progress.label:setString(count .. "/" .. self.data_.player)
	self.progress_:setValue(count / self.data_.player)
end

function MatchListItem:onRegStatusChange_(evt)
	local level = self.data_.matchlevel
	if evt and evt.data and evt.data.level == level then
		local status = evt.data.status
		if status == "START_REGISTER" then
			self.btnReg.labelReg:setString(sa.LangUtil.getText("MATCH", "REGISTERING"))
		elseif status == "REGISTER_SUCCESS" then
			self.btnReg.labelReg:setString(sa.LangUtil.getText("MATCH", "UNREGISTER"))
		elseif status == "REGISTER_FAILED" then
			self.btnReg.labelReg:setString(sa.LangUtil.getText("MATCH", "REGISTER"))
		end
	else
		local matchid = tx.matchProxy.regList and tx.matchProxy.regList[level]
		self:setRegisterBtnEnabled(true)
		if matchid then
			self.btnReg.labelReg:setString(sa.LangUtil.getText("MATCH", "UNREGISTER"))
		else
			self.btnReg.labelReg:setString(sa.LangUtil.getText("MATCH", "REGISTER"))
		end
	end

	sa.fitSprteWidth(self.btnReg.labelReg, 115)
end

function MatchListItem:onDataSet(dataChanged, data)
	self.dataChanged_ = dataChanged
    self.data_ = data
end

function MatchListItem:setRegisterBtnEnabled(enabled)
	if self.btnReg then
		self.btnReg:setButtonEnabled(enabled, cc.c3b(255,255,255))
	end
	
	if self.nodeItem_ then
		self.nodeItem_:setButtonEnabled(enabled, cc.c3b(255,255,255))
	end
end

function MatchListItem:updateRegisterCount_()
	tx.socket.MatchSocket:getRegCount(self.data_.matchlevel)
end

function MatchListItem:onCleanup()
	if self.iconLoaderId_ then	
	end
	tx.matchProxy:removeEventListener(self.regCountChangeId_)
	tx.matchProxy:removeEventListener(self.regStatusChangeId_)
end

return MatchListItem