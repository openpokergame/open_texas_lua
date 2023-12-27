--房间内弹出
local PopupRoomDetail = class("PopupRoomDetail", tx.ui.Panel)
local MatchBlindItem = import(".MatchBlindItem")
local MatchRankingItem = import(".MatchRankingItem")
local MatchRewardItem = import(".MatchRewardItem")

local WIDTH, HEIGHT = 910, 690

PopupRoomDetail.ELEMENTS = {
	"tabBg",
	"contentBg",
	"contentBg_2.labelTips",

	"nodeTab1.labelName",
	"nodeTab1.labelCanSaiKey",
	"nodeTab1.labelCanSaiValue",
	"nodeTab1.labelFuWuKey",
	"nodeTab1.labelFuWuValue",
	"nodeTab1.labelChuShiKey",
	"nodeTab1.labelChuShiValue",
	"nodeTab1.labelJoinTime",

	"nodeTab2.labelSelfRank",

	"nodeTab3.labelLevel",
	"nodeTab3.labelBlind",
	"nodeTab3.labelQian",
	"nodeTab3.labelUpTime",

	"nodeTab4.labelRank",
	"nodeTab4.labelAward",

	"btnReg.label",

	"nodeTab5.labelRankTitle",
	"nodeTab5.labelRank",
	"nodeTab5.labelPlayerTitle",
	"nodeTab5.labelPlayer",
	"nodeTab5.labelRewardTitle",
	"nodeTab5.labelReward",
	"nodeTab5.labelChipTitle",
	"nodeTab5.labelChip",
	"nodeTab5.labelTimeTitle",
	"nodeTab5.labelTime",
	"nodeTab5.labelCurLevel",
	"nodeTab5.labelCountDown",
	"nodeTab5.labelPreBlindTitle",
	"nodeTab5.labelPreBlind",
	"nodeTab5.labelBlindTitle",
	"nodeTab5.labelBlind",
	"nodeTab5.labelNextLevelTitle",
	"nodeTab5.labelNextLevelPreBlind",
	"nodeTab5.labelNextLevelBlind",
}

function PopupRoomDetail:ctor(matchLevel, roomData)
	self.this_ = self
	PopupRoomDetail.super.ctor(self, {WIDTH, HEIGHT})
	
	if not tx.userData.sngTableConfig then
		self:setLoading(true)
		tx.TableConfigManager:getSNGTableConfig(function()
			if self.this_ then
				self:setLoading(false)
	    		self:initViews_(matchLevel, roomData)
	    	end
    	end, true)
	else
		self:initViews_(matchLevel, roomData)
	end
end

function PopupRoomDetail:initData_(matchLevel, roomData)
	local data
	local config = tx.userData.sngTableConfig
	for _,v in ipairs(config) do
		if v.matchlevel == matchLevel then
			data = v
			break
		end
	end

	self.data_ = data
	self.blindData_ = data.blindData --盲注列表
	self.rewardNum_ = #data.reward --奖励人数
	self.rewardData_ = data.reward
	self.playerNum_ = data.player --参赛人数
	self.maxLevel_ = #data.blindData

	self.roomData_  = roomData
	if roomData then
		self.curRank_ = roomData.curRank
		self.blindTime_ = roomData.blindTime
		self.rankList_ = roomData.rankList
		self.curCount_ = roomData.curCount
		self.avgChip_ = roomData.avgChip
		local curLevel = roomData.curBlindLevel
		self.curLevel_ = curLevel

		local totalTime = 0
		for i = 1, curLevel - 1 do
			totalTime = totalTime + data.blindData[i].time
		end
		totalTime = totalTime + self.blindData_[curLevel].time - self.blindTime_
		self.totalTime_ = totalTime
	end
end

function PopupRoomDetail:initViews_(matchLevel, roomData)
	self:initData_(matchLevel, roomData)

	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_match_detail_info.csb",true)
	self:setTextTitleStyle(sa.LangUtil.getText("MATCH", "MATCH_INFO"))

	self.nodeTab1:hide()
	self.contentBg:hide()

	self.mainNode_ = {
		self.nodeTab5,
		self.nodeTab2,
		self.nodeTab3,
		self.nodeTab4,
	}

	local size = self.tabBg:getContentSize()
	local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("MATCH", "ROOM_TAB_TEXT_2"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 24},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 24}
        },
        true, true)
		:setTabBarSize(size.width, 52, 0, -4)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.tabBg)

	self.rankingList_ = self:createListView_(MatchRankingItem)
	self.blindList_ = self:createListView_(MatchBlindItem)
	self.rewardList_ = self:createListView_(MatchRewardItem)

	self.rankingList_:setData(self.rankList_)
	self.blindList_:setData(self.blindData_)
	self.rewardList_:setData(self.rewardData_)

	self.regBtn_ = ImgButton(self.btnReg,"#common/btn_big_green.png","#common/btn_big_green_down.png"):onButtonClicked(function()
 		tx.matchProxy:dealReg(self.data_.level)
 		self:hidePanel()
	end)
	self.btnReg.label:setString(sa.LangUtil.getText("MATCH", "REGISTER"))
	self.regBtn_:hide()

	self:setLabelText_()

	if self.roomData_ then
		self:updateBlindInfo_()

		self.nodeTab5.labelPlayer:setString(self.playerNum_)
		self.nodeTab5.labelReward:setString(self.rewardNum_)
		self.nodeTab5.labelRank:setString(sa.LangUtil.getText("MATCH", "FORMAT_BLIND", self.curRank_, self.curCount_))
		self.nodeTab5.labelChip:setString(self.avgChip_)

		self.nodeTab2.labelSelfRank:setString(sa.LangUtil.getText("MATCH", "RANKING_INFO", self.curRank_))

		self:startSchedule_()
	end

	tab:gotoTab(1, true)
end

function PopupRoomDetail:setLabelText_()
	self.contentBg_2.labelTips:setString(sa.LangUtil.getText("RANKING", "NOT_DATA_TIPS")):hide()

	self.nodeTab5.labelRankTitle:setString(sa.LangUtil.getText("MATCH", "RANKING_TITLE"))

	self.nodeTab5.labelPlayerTitle:setString(sa.LangUtil.getText("MATCH", "MATCH_PLAYER"))
	
	self.nodeTab5.labelRewardTitle:setString(sa.LangUtil.getText("MATCH", "REWARD_PLAYER"))
	
	self.nodeTab5.labelChipTitle:setString(sa.LangUtil.getText("MATCH", "AVERAGE_CHIPS_TITLE"))
	
	self.nodeTab5.labelTimeTitle:setString(sa.LangUtil.getText("MATCH", "MATCH_CUR_TIME"))

	self.nodeTab5.labelPreBlindTitle:setString(sa.LangUtil.getText("MATCH", "PRE_BLIND_TITLE"))

	self.nodeTab5.labelBlindTitle:setString(sa.LangUtil.getText("MATCH", "BLIND_TITLE"))
	self.nodeTab5.labelNextLevelTitle:setString(sa.LangUtil.getText("MATCH", "NEXT_LEVEL_TITLE"))

	self.nodeTab3.labelLevel:setString(sa.LangUtil.getText("MATCH", "LEVEL_TITLE"))
	self.nodeTab3.labelBlind:setString(sa.LangUtil.getText("MATCH", "BLIND_TITLE"))
	self.nodeTab3.labelQian:setString(sa.LangUtil.getText("MATCH", "PRE_BLIND_TITLE"))
	self.nodeTab3.labelUpTime:setString(sa.LangUtil.getText("MATCH", "ADD_BLIND_TITLE"))

	self.nodeTab4.labelRank:setString(sa.LangUtil.getText("MATCH", "RANKING_TITLE"))
	self.nodeTab4.labelAward:setString(sa.LangUtil.getText("MATCH", "REWARD_TITLE"))
end

--定时器开启，比赛总时间和当前盲注倒计时
function PopupRoomDetail:startSchedule_()
	local label_1 = self.nodeTab5.labelTime
	local label_2 = self.nodeTab5.labelCountDown
	label_1:schedule(function()
		self.totalTime_ = self.totalTime_ + 1
		label_1:setString(sa.TimeUtil:getTimeString(self.totalTime_))
	end, 1)
	
	label_2:schedule(function()
		self.blindTime_ = self.blindTime_ - 1
		label_2:setString(sa.TimeUtil:getTimeString1(self.blindTime_))
		if self.blindTime_ <= 0 then
			self.curLevel_ = self.curLevel_ + 1
			if self.curLevel_ > self.maxLevel_ then
				label_2:stopAllActions()
				return
			end
			local data = self.blindData_[self.curLevel_]
			self.blindTime_ = data.time
			self:updateBlindInfo_()
		end
	end, 1)
end

function PopupRoomDetail:updateBlindColor_()
	local items = self.blindList_:getListItems()
	for _, item in ipairs(items) do
		item:setNormalColor()
	end
	
	items[self.curLevel_]:setSelectedColor()
end

--更新前注和盲注信息,暂时不需要考虑达到最大等级，因为达到最大等级必须有人all in.
--极端情况all in 的时候筹码少的轮流赢
function PopupRoomDetail:updateBlindInfo_()
	local level = self.curLevel_
	local data = self.blindData_[level]

	self.nodeTab5.labelCurLevel:setString(sa.LangUtil.getText("MATCH", "CUR_LEVEL_TITLE", level, self.maxLevel_))
	self.nodeTab5.labelTime:setString(sa.TimeUtil:getTimeString(self.totalTime_))
	self.nodeTab5.labelCountDown:setString(sa.TimeUtil:getTimeString1(self.blindTime_))

	self.nodeTab5.labelPreBlind:setString(data.pre)
	self.nodeTab5.labelBlind:setString(sa.LangUtil.getText("MATCH", "FORMAT_BLIND", data.blind, data.blind*2))

	if level < self.maxLevel_ then
		data = self.blindData_[level + 1]
		self.nodeTab5.labelNextLevelPreBlind:setString(data.pre)
		self.nodeTab5.labelNextLevelBlind:setString(sa.LangUtil.getText("MATCH", "FORMAT_BLIND", data.blind, data.blind*2))
	else
		self.nodeTab5.labelNextLevelPreBlind:hide()
		self.nodeTab5.labelNextLevelBlind:hide()
	end

	self:updateBlindColor_()
end

function PopupRoomDetail:onTabChanged_(selectedTab)
	for i = 1, 4 do
		if selectedTab == i then
			self.mainNode_[i]:show()
		else
			self.mainNode_[i]:hide()
		end
	end

	self.rankingList_:hide()
	self.blindList_:hide()
	self.rewardList_:hide()
	self.contentBg_2.labelTips:hide()

	if selectedTab == 1 then
		if not self.roomData_ then
			self.mainNode_[1]:hide()
			self.contentBg_2.labelTips:show()
		end
	elseif selectedTab == 2 then
		self.rankingList_:show()

		if not self.rankList_ then
			self.nodeTab2.labelSelfRank:hide()
			self.contentBg_2.labelTips:show()
		end
	elseif selectedTab == 3 then
		self.blindList_:show()
	elseif selectedTab == 4 then
		self.rewardList_:show()
	end
end

function PopupRoomDetail:createListView_(item)
	local list_w, list_h = 854, 442
	local x, y = list_w/2, list_h/2
	local list = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        item
    )
    :pos(x, y)
    :addTo(self.contentBg_2)
    :hide()

    return list
end

function PopupRoomDetail:onShowed()
	if self.rankingList_ then
        self.rankingList_:setScrollContentTouchRect()
    end

    if self.blindList_ then
        self.blindList_:setScrollContentTouchRect()
    end

    if self.rewardList_ then
        self.rewardList_:setScrollContentTouchRect()
    end
end

return PopupRoomDetail