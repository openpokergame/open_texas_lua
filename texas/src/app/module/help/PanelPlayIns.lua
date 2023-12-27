local ScrollLabel = import("openpoker.ui.ScrollLabel")
local ButtonDescItem = import(".items.ButtonDescItem")

---------------------------------------------------------------------------------------
local PanelPlayIns_1 = class("PanelPlayIns_1", function() return display.newNode() end)
PanelPlayIns_1.ELEMENTS = {
	"labelHand",
	"labelPub",
	"labelFinal",
	"labelPlayerName1",
	"labelPlayerName2",
	"labelPub3",
	"labelPub4",
	"labelPub5",
	"labelWin",
	"labelLose",
	"nodeListLabel",
}
function PanelPlayIns_1:ctor()
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_help_play_ins_1.csb",true)
	local desc = sa.LangUtil.getText("HELP", "PLAY_DESC")
	for i = 1, 10 do
		self[PanelPlayIns_1.ELEMENTS[i]]:setString(desc[i])
	end

	sa.fitSprteWidth(self.labelPub4, 45)
	sa.fitSprteWidth(self.labelPub5, 55)

	local dw, dh = 790, 145
	self.playDesc_ = ScrollLabel.new(
        {
            text=sa.LangUtil.getText("HELP", "PLAY_DESC_2"),
            color=styles.FONT_COLOR.CONTENT_TEXT,
            size=20,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(dw, dh)
        },
        {
            viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
        })
    :addTo(self.nodeListLabel)
end

---------------------------------------------------------------------------------------
local PanelPlayIns_2 = class("PanelPlayIns_2", function() return display.newNode() end)
PanelPlayIns_2.ELEMENTS = {
	"pai1.labelPai1",
	"pai1.labelPai1_i",
	"pai1.labelPai2",
	"pai1.labelPai2_i",
	"pai1.labelPai3",
	"pai1.labelPai3_i",
	"pai1.labelPai4",
	"pai1.labelPai4_i",
	"pai1.labelPai5",
	"pai1.labelPai5_i",
	"pai2.labelPai6",
	"pai2.labelPai6_i",
	"pai2.labelPai7",
	"pai2.labelPai7_i",
	"pai2.labelPai8",
	"pai2.labelPai8_i",
	"pai2.labelPai9",
	"pai2.labelPai9_i",
	"pai2.labelPai10",
	"pai2.labelPai10_i",
	"labelRule"
}
function PanelPlayIns_2:ctor()
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_help_play_ins_2.csb",true)
	local desc = sa.LangUtil.getText("HELP", "RULE_DESC")
	local notes = sa.LangUtil.getText("HELP", "RULE_DESC_NOTES")
	for i = 1, 5 do
		self.pai1["labelPai"..i]:setString(i .. "." .. desc[i])
		self.pai1["labelPai"..i.."_i"]:setString(notes[i])
	end

	for i = 6, 10 do
		self.pai2["labelPai"..i]:setString(i .. "." .. desc[i])
		self.pai2["labelPai"..i.."_i"]:setString(notes[i])
	end

	sa.fitSprteWidth(self.pai2.labelPai10, 180)
	
	local ruleStr = desc[1]
	for i = 2, 10 do
		ruleStr = ruleStr .. " > " .. desc[i]
	end
	self.labelRule:setString(ruleStr)
end

---------------------------------------------------------------------------------------
local PanelPlayIns_3 = class("PanelPlayIns_3", function() return display.newNode() end)
PanelPlayIns_3.ELEMENTS = {
	"labelCaiDan",
	"labelShangChen",
	"labelChiDi",
	"labelZhuangJia",
	"labelGongPai",
	"labelShouPai",
	"labelPaiTiShi",
	"labelCaoZuo",
	"labelDaiRu",
	"labelPaiGaiLv",
	"labelPaiDui",
	"labelJia",
	"labelCheck",
	"labelFold",
}
local LABEL_MAX_W = {130, 150, 150, 120, 180, 120, 120, 140, 140, 200, 50, 140, 140, 140}
function PanelPlayIns_3:ctor()
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_help_play_ins_3.csb",true)
	local desc = sa.LangUtil.getText("HELP", "OPERATING_DESC")
	for i = 1, 14 do
		local label = self[PanelPlayIns_3.ELEMENTS[i]]
		label:setString(desc[i])
		sa.fitSprteWidth(label, LABEL_MAX_W[i])
	end
end

---------------------------------------------------------------------------------------
local PanelPlayIns = class("PanelPlayIns", function() return display.newNode() end)

local BTN_IMG = {
	"#dialogs/help/green_btn_icon.png",--看牌
	"#dialogs/help/red_btn_icon.png",--弃牌
	"#dialogs/help/green_btn_icon.png",--跟注
	"#dialogs/help/yellow_btn_icon.png",--加注
	"#dialogs/help/red_btn_icon.png",--全下
	"#dialogs/help/purple_btn_icon.png",--看或弃牌
	"#dialogs/help/purple_btn_icon.png",--弃牌
	"#dialogs/help/purple_btn_icon.png",--跟任何注
}

function PanelPlayIns:ctor(idx)
	self:setNodeEventEnabled(true)
	self.selected_ = idx or 1
	if self.selected_<1 or self.selected_>4 then self.selected_=1 end
	local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("HELP", "PLAY_SUB_TAB_TEXT"),
        {
            selectedText = {color = styles.FONT_COLOR.SUB_TAB_ON, size = 24},
            defaltText = {color = styles.FONT_COLOR.SUB_TAB_OFF, size = 24}
        },
        true, true)
		:setTabBarSize(698, 52, 0, -4)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(131, 207)
		:addTo(self)
	tab:gotoTab(self.selected_, true)
end

function PanelPlayIns:onTabChanged_(selectedTab)
	if self.panelPlayIns_1_ then
		self.panelPlayIns_1_:hide()
	end
	if self.panelPlayIns_2_ then
		self.panelPlayIns_2_:hide()
	end
	if self.panelPlayIns_3_ then
		self.panelPlayIns_3_:hide()
	end
	if self.gameNameList_ then
		self.gameNameList_:hide()
	end
	if selectedTab==1 then
		if not self.panelPlayIns_1_ then
			self.panelPlayIns_1_ = PanelPlayIns_1.new()
				:pos(0,0)
				:addTo(self)
		end
		self.panelPlayIns_1_:show()
	elseif selectedTab==2 then
		if not self.panelPlayIns_2_ then
			self.panelPlayIns_2_ = PanelPlayIns_2.new()
				:pos(0,0)
				:addTo(self)
		end
		self.panelPlayIns_2_:show()
	elseif selectedTab==3 then
		if not self.panelPlayIns_3_ then
			self.panelPlayIns_3_ = PanelPlayIns_3.new()
				:pos(0, -5)
				:addTo(self)
		end
		self.panelPlayIns_3_:show()
	elseif selectedTab==4 then
		if not self.gameNameList_ then
			local LIST_WIDTH,LIST_HEIGHT = 800,470
		    self.gameNameList_ = sa.ui.ListView.new(
		            {
		                viewRect = cc.rect(-LIST_WIDTH * 0.5, -LIST_HEIGHT * 0.5, LIST_WIDTH, LIST_HEIGHT),
		            },
		            ButtonDescItem
		        )
		    	:pos(130,-72)
		        :addTo(self)
		    local data = sa.LangUtil.getText("HELP", "PLAY_BTN_DESC")

		    for i = 1, 8 do
		    	data[i].img = BTN_IMG[i]
		    end
		   	self.gameNameList_:setData(data)
			self.gameNameList_:onItemResize_()
		end
		self.gameNameList_:show()
	end
end

function PanelPlayIns:setScrollContentTouchRect()
	if self.gameNameList_ then
		self.gameNameList_:setScrollContentTouchRect()
	end
end

return PanelPlayIns