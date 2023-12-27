--玩牌活动
local HolidayContent = class("HolidayContent", function()
    return display.newNode()
end)

local HolidayActListItem = import(".HolidayActListItem")
local HolidayRewardListItem = import(".HolidayRewardListItem")

local WIDTH, HEIGHT = 820, 590

function HolidayContent:ctor(data)
    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#holiday_tab_bg.png", 
            indicator = "#holiday_tab.png"
        }, 
        sa.LangUtil.getText("NEWESTACT","HOLIDAY_TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0xb8, 0x27, 0x72), size = 22},
            defaltText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22}
        }, true, true)
        :setTabBarSize(386, 50)
        :onTabChange(handler(self, self.onSubTabChange_))
        :pos(545, 390)
        :addTo(self)

    local list_w, list_h = 520, 340
    local list_x, list_y = 545, 185
    self.actList_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        HolidayActListItem
    )
    :hideScrollBar()
    :pos(list_x, list_y)
    :addTo(self)
    :hide()

    self.rewardList_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        HolidayRewardListItem
    )
    :hideScrollBar()
    :pos(list_x, list_y)
    :addTo(self)
    :hide()

    -- local actData = {
    --     {
    --         reward = 1, --喇叭奖励数量
    --         name = "play 5", --任务名字
    --         progress = 1, --当前完成次数
    --         target = 5, --需要完成次数
    --         status = 1, -- 领奖 0未完成，1可领取，2已领取
    --         goto = 7, --跳转哪个场次去玩牌，同活动中心
    --     },
    -- }
    self.actList_:setData(data.list)

    local rewardData = data.exchangeList
    self.rewardData_ = rewardData
    for _, v in ipairs(rewardData) do
        v.actProps = data.actProps
    end

    self.rewardList_:setData(rewardData)
    self.rewardList_.updateDataListener = handler(self, self.updateRewardListData_)

    self:schedule(function()
        self.actList_:setScrollContentTouchRect()
        self.rewardList_:setScrollContentTouchRect()
    end, 0.5)

    tab:gotoTab(1, true)
end

function HolidayContent:onSubTabChange_(selected)
    self.actList_:hide()
    self.rewardList_:hide()

    if selected == 1 then
        self.actList_:show()
    else
        self.rewardList_:show()
    end
end

function HolidayContent:updateRewardListData_(needNum)
    for _,v in ipairs(self.rewardData_) do
        v.actProps = v.actProps - needNum
    end

    self.rewardList_:setData({})
    self.rewardList_:setData(self.rewardData_)
end

return HolidayContent