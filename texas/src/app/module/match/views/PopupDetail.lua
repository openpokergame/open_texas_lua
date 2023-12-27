-- 定时赛选场界面弹出

local PopupDetail = class("PopupDetail", tx.ui.Panel)
local MatchBlindItem = import(".MatchBlindItem")
local MatchRankingItem = import(".MatchRankingItem")
local MatchRewardItem = import(".MatchRewardItem")

local WIDTH, HEIGHT = 910, 690

PopupDetail.ELEMENTS = {
	"tabBg",
	"contentBg",
	"contentBg_2.labelTips",

	"nodeTab1.labelName",
	"nodeTab1.labelCanSaiKey",
	"nodeTab1.labelFuWuKey",
	"nodeTab1.labelChuShiKey",
	"nodeTab1.labelJoinTime",

	"nodeTab2.labelSelfRank",

	"nodeTab3.labelLevel",
	"nodeTab3.labelBlind",
	"nodeTab3.labelQian",
	"nodeTab3.labelUpTime",

	"nodeTab4.labelRank",
	"nodeTab4.labelAward",

	"btnReg.label",

	"nodeTab5",
}

local BLIND_DATA ={ --由PHP返回数据
	{
		blind = 50,
		pre = 5,
		time = 120
	},
	{
		blind = 75,
		pre = 10,
		time = 120
	},
	{
		blind = 100,
		pre = 15,
		time = 120
	},
	{
		blind = 150,
		pre = 25,
		time = 120
	},
	{
		blind = 200,
		pre = 50,
		time = 120
	},
	{
		blind = 300,
		pre = 75,
		time = 120
	},
	{
		blind = 400,
		pre = 100,
		time = 120
	},
	{
		blind = 500,
		pre = 200,
		time = 120
	},
	{
		blind = 700,
		pre = 300,
		time = 120
	},
}

local REWARD_DATA = {1000000, 500000, 200000}

local RANKING_DATA ={ --由PHP返回数据
	{
		name = "dadad 1",
		img = "",
		chip = 1000000
	},
	{
		name = "dadad 2",
		img = "",
		chip = 800000
	},
	{
		name = "dadad 3",
		img = "",
		chip = 600000
	},
	{
		name = "dadad 4",
		img = "",
		chip = 500000
	},
	{
		name = "dadad 5",
		img = "",
		chip = 400000
	},
	{
		name = "dadad 6",
		img = "",
		chip = 300000
	},
}

function PopupDetail:ctor(data)
	PopupDetail.super.ctor(self, {WIDTH, HEIGHT})
	self.data_ = data
	self:initViews_()
end

function PopupDetail:initViews_()
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_match_detail_info.csb",true)
	self:setTextTitleStyle(sa.LangUtil.getText("MATCH", "MATCH_INFO"))

	self.nodeTab5:hide()
	self.contentBg_2:hide()

	local size = self.tabBg:getContentSize()
	local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("MATCH", "TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 24},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 24}
        },
        true, true)
		:setTabBarSize(size.width, 52, 0, -4)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.tabBg)

	self:setLabelText_()

	self.rankingList_ = self:createListView_(MatchRankingItem)
	self.blindList_ = self:createListView_(MatchBlindItem)
	self.rewardList_ = self:createListView_(MatchRewardItem)

	RANKING_DATA = nil
	self.rankingList_:setData(RANKING_DATA)
	self.blindList_:setData(BLIND_DATA)
	self.rewardList_:setData(REWARD_DATA)

	self.regBtn_ = ImgButton(self.btnReg,"#common/btn_big_green.png","#common/btn_big_green_down.png"):onButtonClicked(function()
 		tx.matchProxy:dealReg(self.data_.matchlevel)
 		self:hidePanel()
	end)
	self.btnReg.label:setString(sa.LangUtil.getText("MATCH", "REGISTER"))

	tab:gotoTab(1, true)
end

function PopupDetail:setLabelText_()
	local data = self.data_

	self.contentBg_2.labelTips:setString(sa.LangUtil.getText("RANKING", "NOT_DATA_TIPS")):hide()

	self.nodeTab1.labelName:setString(data.name)
	self.nodeTab1.labelCanSaiKey:setString(sa.LangUtil.getText("MATCH", "REGISTER_COST") .. data.registerCost)

	self.nodeTab1.labelFuWuKey:setString(sa.LangUtil.getText("MATCH", "SERVER_COST") .. data.serverCost)

	self.nodeTab1.labelChuShiKey:setString(sa.LangUtil.getText("MATCH", "START_CHIPS") .. data.chip)

	self.nodeTab1.labelJoinTime:setString(sa.LangUtil.getText("MATCH", "MATCH_TIME", data.matchTime or 0))

	self.nodeTab2.labelSelfRank:setString(sa.LangUtil.getText("MATCH", "RANKING_INFO", 5))

	self.nodeTab3.labelLevel:setString(sa.LangUtil.getText("MATCH", "LEVEL_TITLE"))
	self.nodeTab3.labelBlind:setString(sa.LangUtil.getText("MATCH", "BLIND_TITLE"))
	self.nodeTab3.labelQian:setString(sa.LangUtil.getText("MATCH", "PRE_BLIND_TITLE"))
	self.nodeTab3.labelUpTime:setString(sa.LangUtil.getText("MATCH", "ADD_BLIND_TITLE"))

	self.nodeTab4.labelRank:setString(sa.LangUtil.getText("MATCH", "RANKING_TITLE"))
	self.nodeTab4.labelAward:setString(sa.LangUtil.getText("MATCH", "REWARD_TITLE"))
end

function PopupDetail:onTabChanged_(selectedTab)
	for i = 1, 4 do
		if selectedTab == i then
			self["nodeTab" .. i]:show()
		else
			self["nodeTab" .. i]:hide()
		end
	end

	self.rankingList_:hide()
	self.blindList_:hide()
	self.rewardList_:hide()
	self.contentBg_2.labelTips:hide()
	self.contentBg:hide()
	self.contentBg_2:hide()
	self.regBtn_:hide()

	if selectedTab == 1 then
		self.contentBg:show()
		self.regBtn_:show()
	elseif selectedTab == 2 then
		self.contentBg_2:show()
		self.rankingList_:show()
		if not RANKING_DATA then
			self.nodeTab2.labelSelfRank:hide()
			self.contentBg_2.labelTips:show()
		end
	elseif selectedTab == 3 then
		self.contentBg_2:show()
		self.blindList_:show()
	elseif selectedTab == 4 then
		self.contentBg_2:show()
		self.rewardList_:show()
	end
end

function PopupDetail:createListView_(item)
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

function PopupDetail:onShowed()
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

return PopupDetail