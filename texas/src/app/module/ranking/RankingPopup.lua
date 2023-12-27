local RankingPopup = class("RankingPopup", tx.ui.Panel)
local RankingListItem = import(".RankingListItem")
local RankingPopupController = import(".RankingPopupController")

local WIDTH, HEIGHT = 1136, 746 --弹窗
local RIGHT_FRAME_W, RIGHT_FRAME_H = 820, 590 --右边内框大小

local CHAMPION_REWARD_COLOR = cc.c3b(0x80, 0x6f, 0xe8)
local GET_REWARD_TIPS_COLOR = cc.c3b(0x89, 0x87, 0xce)

function RankingPopup:ctor()
    RankingPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setImgTitleStyle("#lang/pop_title_ranking.png")

    self.controller_ = RankingPopupController.new(self)

    self.selectedMainTab_ = 1

    self:setMainTabStyle(self:getText_("MAIN_TAB_TEXT"), self.selectedMainTab_, handler(self, self.onMainTabChange))

    self:addRightNodes_()

    self:onMainTabChange_(1)
end

function RankingPopup:addRightNodes_()
    local bg_w, bg_h = RIGHT_FRAME_W, RIGHT_FRAME_H
    local bg = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(bg_w, bg_h))
        :align(display.RIGHT_BOTTOM, WIDTH - 28, 30)
        :addTo(self.background_)

    self.curRanking_ = ui.newTTFLabel({text = "", color = GET_REWARD_TIPS_COLOR, size = 22})
        :pos(bg_w/2, bg_h - 94)
        :addTo(bg)

    local list_w, list_h = 808, 460
    local x, y = bg_w/2, bg_h/2 - 52
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        RankingListItem
    )
    :pos(x, y)
    :addTo(bg)
    self.list_.controller = self.controller_

    self.notDatatext_ = self:createNoDataTips(self:getText_("NOT_DATA_TIPS")):hide()

    self.subTabBarGlobal_ = self:createSubTabBar_(bg, self:getText_("SUB_TAB_TEXT_GLOBAL"), 540)
    self.subTabBarFriend_ = self:createSubTabBar_(bg, self:getText_("SUB_TAB_TEXT_FRIEND"), 540)
end

function RankingPopup:createSubTabBar_(parent, text, w)
    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        text,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = styles.FONT_COLOR.CONTENT_TEXT, size = 22}
        }, true, true)
        :setTabBarSize(w, 52, 0, -4)
        :onTabChange(handler(self, self.onSubTabChange_))
        :pos(RIGHT_FRAME_W/2, RIGHT_FRAME_H - 43)
        :addTo(parent)
        :gotoTab(1, true)

    return tab
end

function RankingPopup:onMainTabChange(evt)
    self:onMainTabChange_(evt.selected)
end

function RankingPopup:onMainTabChange_(selectedTab)
    self:onTabChange_()

    self.controller_:onMainTabChange(selectedTab)

    if selectedTab == 1 then
        self:showFriendRankView_()
    elseif selectedTab == 2 then
        self:showAllRankView_()
    end
end

function RankingPopup:onSubTabChange_(selectedTab)
    self:onTabChange_()

    self.controller_:onSubTabChange(selectedTab)
end

function RankingPopup:onTabChange_()
    self:setListData()
    self.notDatatext_:hide()

    self:setLoading(true)
end

function RankingPopup:updateSelfRankingTips_(data)
    local index = 0
    for i, v in ipairs(data) do
        if tonumber(v.uid) == tx.userData.uid then
            index = i
            break
        end
    end

    local str = sa.LangUtil.getText("RANKING", "NOT_IN_CHIP_RANKING")
    if index ~= 0 then
        if index == 1 then
            str = sa.LangUtil.getText("RANKING", "IN_RANKING_NO_1")
        else
            str = sa.LangUtil.getText("RANKING", "IN_RANKING", index)
        end
    end
    self.curRanking_:setString(str)
end

function RankingPopup:setListData(data)
    data = data or {}
    
    self:setLoading(false)

    if #data == 0 then
        self.notDatatext_:show()
        self.curRanking_:hide()
    else
        self.notDatatext_:hide()
        self.curRanking_:show()
        self:updateSelfRankingTips_(data)
    end

    self.list_:setData(data)
end

function RankingPopup:onShowed()
    self.list_:setScrollContentTouchRect()
end

function RankingPopup:show()
    self:showPanel_()
end

--显示总排行
function RankingPopup:showAllRankView_()
    self.subTabBarFriend_:hide()
    self.subTabBarGlobal_:show()
    self.subTabBarGlobal_:gotoTab(1, true)
end

--显示好友排行
function RankingPopup:showFriendRankView_()
    self.subTabBarGlobal_:hide()
    self.subTabBarFriend_:show()
    self.subTabBarFriend_:gotoTab(1, true)
end

function RankingPopup:onExit()
    self.controller_:dispose()
end

function RankingPopup:getText_(key, ...)
    return sa.LangUtil.getText("RANKING", key, ...)
end

return RankingPopup