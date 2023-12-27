local RankingPopupController = class("RankingPopupController")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local requestRetryTimes_ = 2
local FRIEND_TAB = 1--好友榜
local WORLD_TAB = 2--世界榜
local PROFIT_TAB = 1 --盈利榜
local CHIP_TAB = 2 --游戏币榜
local MAX_DATA_LEN = 20 --保留前20个数据

function RankingPopupController:ctor(view)
    self.view_ = view
    self.subSelectedTab_ = FRIEND_TAB
    self.mainSelectedTab_ = PROFIT_TAB

    self.friendProfitData_ = nil
    self.friendData_ = nil
    self.totalProfitData_ = nil
    self.rankingData_ = nil
end

function RankingPopupController:onMainTabChange(selectedTab)
    self.mainSelectedTab_ = selectedTab

    self:cancelAllRequest_()
    requestRetryTimes_ = 2
    if selectedTab == FRIEND_TAB then
        if self.friendProfitData_ then
            self:onSubTabChange(1)
        else
            self:requestFriendProfitData_()
            self:requestFriendData_()
        end
    elseif selectedTab == WORLD_TAB then
        if self.totalProfitData_ then
            self:onSubTabChange(1)
        else
            self:requestTotalProfitData_()
            self:requestRankingData_()
        end
    end
end

function RankingPopupController:onSubTabChange(selectedTab)
    self.subSelectedTab_ = selectedTab
    if self.mainSelectedTab_ == FRIEND_TAB then
        if selectedTab == PROFIT_TAB then
            if self.friendProfitData_ then
                self.view_:setListData(self.friendProfitData_)
            end
        elseif selectedTab == CHIP_TAB then
            if self.friendData_ then
                self.view_:setListData(self.friendData_)
            end
        end      
    elseif self.mainSelectedTab_ == WORLD_TAB then
        if selectedTab == PROFIT_TAB then             
            if self.totalProfitData_ then
                self.view_:setListData(self.totalProfitData_)
            end
        elseif selectedTab == CHIP_TAB then
            if self.rankingData_ then
                self.view_:setListData(self.rankingData_)
            end          
        end  
    end   
end

-- 获取好友盈利排行榜
function RankingPopupController:requestFriendProfitData_()
    local time_ = os.time()
    self.friendProfitDataRequestId_ = sa.HttpService.POST(
    {
        mod = "Rank", 
        act = "friYesterdayRank", 
    }, 
    function(data)
        local recallData = json.decode(data)
        if recallData.code == 1 or recallData.code == 2 then
            self.friendProfitData_ = recallData.list
            -- 获取数据后，把自己的数据添加进去
            self:insertData_(self.friendProfitData_, recallData.earn)

            if self.mainSelectedTab_ == FRIEND_TAB then
                if self.subSelectedTab_ == PROFIT_TAB then
                    self.view_:setListData(self.friendProfitData_)
                end
            end    
        else
            self.friendProfitDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendProfitData_), 2)
        end
    end, 
    function ()
        requestRetryTimes_ = requestRetryTimes_ - 1
        if requestRetryTimes_ > 0 then
            self.friendProfitDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendProfitData_), 2)
        else
            self.view_:setListData()
        end
    end)
end

-- 获取好友游戏币排行
function RankingPopupController:requestFriendData_()
    self.friendDataRequestId_ = sa.HttpService.POST(
    {
        mod = "Rank", 
        act = "friMoneyRank", 
    }, 
    function(data)
        local recallData = json.decode(data)
        self.friendData_ = recallData.list

        -- 获取数据后，把自己的数据添加进去
        self:insertData_(self.friendData_, tx.userData.money)

        if self.mainSelectedTab_ == FRIEND_TAB then
            if self.subSelectedTab_ == CHIP_TAB then
                self.view_:setListData(self.friendData_)
            end
        end
    end,
    function ()
        requestRetryTimes_ = requestRetryTimes_ - 1
        if requestRetryTimes_ > 0 then
            self.friendDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendData_), 2)
        else
            self.view_:setListData()
        end
    end)
end

-- 获取总排行榜数据
function RankingPopupController:requestRankingData_()
    self.rankingDataRequestId_ = sa.HttpService.POST(
    {
        mod = "Rank", 
        act = "allMoneyRank", 
    }, 
    function(data)
        local recallData = json.decode(data)
        if recallData.code == 1 then
            self.rankingData_ = recallData.list
            if self.mainSelectedTab_ == WORLD_TAB then
                if self.subSelectedTab_ == CHIP_TAB then
                    table.sort(self.rankingData_, function (a, b) return a.money > b.money end)
                    self.view_:setListData(self.rankingData_)
                end
            end
        else
            self.rankingDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestRankingData_), 2)
        end
    end, 
    function ()
        requestRetryTimes_ = requestRetryTimes_ - 1
        if requestRetryTimes_ > 0 then
            self.rankingDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestRankingData_), 2)
        else
            self.view_:setListData()
        end
    end)
end

-- 获取总盈利排行榜
function RankingPopupController:requestTotalProfitData_()
    local time_ = os.time()
    self.totalProfitDataRequestId_ = sa.HttpService.POST(
    {
        mod = "Rank", 
        act = "allYesterdayRank", 
    }, 
    function(data)
        local recallData = json.decode(data)
        if recallData.code == 1 then
            self.totalProfitData_ = recallData.list
            if self.mainSelectedTab_ == WORLD_TAB then
                if self.subSelectedTab_ == PROFIT_TAB then
                    table.sort(self.totalProfitData_, function (a, b) return a.money > b.money end)
                    self.view_:setListData(self.totalProfitData_)
                end
            end    
        else
            self.totalProfitDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestTotalProfitData_), 2)
        end
    end, 
    function ()
        requestRetryTimes_ = requestRetryTimes_ - 1
        if requestRetryTimes_ > 0 then
            self.totalProfitDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestTotalProfitData_), 2)
        else
            self.view_:setListData()
        end
    end)
end

--用于显示不同的布局，财富榜和盈利榜
function RankingPopupController:getSubSelectedTab()
    return self.subSelectedTab_
end

function RankingPopupController:insertData_(data, chip)
    local selfData = {
        uid = tx.userData.uid,
        nick = tx.userData.nick, 
        img = tx.userData.s_picture,
        sex = tx.userData.sex,
        money = chip, 
        level = tx.userData.level
    }
    table.insert(data, selfData)
    table.sort(data, function (a, b) return a.money > b.money end)

    local s = #data
    local e = MAX_DATA_LEN + 1

    for i = s, e, -1 do
        table.remove(data, i)
    end
end

function RankingPopupController:cancelAllRequest_()
    sa.HttpService.CANCEL(self.friendDataRequestId_)
    sa.HttpService.CANCEL(self.friendProfitDataRequestId_)
    sa.HttpService.CANCEL(self.rankingDataRequestId_)
    sa.HttpService.CANCEL(self.totalProfitDataRequestId_)
end

function RankingPopupController:dispose()
    self:cancelAllRequest_()

    if self.friendProfitDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.friendProfitDataRequestScheduleHandle_)
    end

    if self.friendDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.friendDataRequestScheduleHandle_)
    end

    if self.rankingDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.rankingDataRequestScheduleHandle_)
    end

    if self.totalProfitDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.totalProfitDataRequestScheduleHandle_)
    end
end

return RankingPopupController