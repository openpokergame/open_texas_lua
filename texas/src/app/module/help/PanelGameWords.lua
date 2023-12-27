local PanelGameWords = class("PanelGameWords", function()
	return display.newNode()
end)

local ItemGameName = import(".items.ItemGameName")

function PanelGameWords:ctor(idx)
	self:setNodeEventEnabled(true)
	self.selected_ = idx or 1
	if self.selected_ < 1 or self.selected_ > 2 then
		self.selected_=1
	end

	local LIST_WIDTH,LIST_HEIGHT = 794, 490
	local tab = tx.ui.TabBarWithIndicator.new(
			{
				background = "#common/pop_tab_normal_2.png", 
				indicator = "#common/pop_tab_selected_2.png"
			},
			sa.LangUtil.getText("HELP", "GAME_WORDS_SUB_TAB_TEXT"),
			{
				selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 24},
				defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 24}
			},
		true, true)
		:setTabBarSize(460, 52, 0, -4)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(131, 207)
		:addTo(self, 10)

	ItemGameName.WIDTH = LIST_WIDTH
	self.gameNameList_ = sa.ui.ListView.new(
			{
				viewRect = cc.rect(-LIST_WIDTH * 0.5, -LIST_HEIGHT * 0.5, LIST_WIDTH, LIST_HEIGHT),
			},
			ItemGameName
		)
		:pos(131, -75)
		:addTo(self)

	self.data1_ = sa.LangUtil.getText("HELP", "PLAY_DATA_DESC")

	self.data2_ = sa.LangUtil.getText("HELP", "PLAYER_TYPE_DESC")

	tab:gotoTab(self.selected_, true)
	self.gameNameList_:onItemResize_()
end

function PanelGameWords:onTabChanged_(selectedTab)
	if selectedTab == 1 then
		self.gameNameList_:setData(self.data1_)
	elseif selectedTab == 2 then
		self.gameNameList_:setData(self.data2_)
	end
end

function PanelGameWords:setScrollContentTouchRect()
	self.gameNameList_:setScrollContentTouchRect()
end

return PanelGameWords