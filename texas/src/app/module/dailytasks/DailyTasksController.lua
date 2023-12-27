local DailyTasksController = class("DailyTasksController")
local DailyTask = import(".DailyTask")
local Achieve = import(".Achieve")


function DailyTasksController:ctor()
    self.allTaskList = {}
    self.allAchieveList = {}
end

function DailyTasksController:setData()
    self.allTaskList = nil
    if self.schedulerPool then
        self.schedulerPool:clearAll()
        self.schedulerPool = nil
    end
    self.schedulerPool = sa.SchedulerPool.new()
    self.isBusy = false

    self.schedulerPool:delayCall(function()
        self:getTasksListData(true)
    end, 0.5)
end

--获取任务数据
function DailyTasksController:getTasksListData(init)
    if not self.isBusy then
        self.isBusy = true
        self.allTaskList = nil
        self.allTaskList = {}

        sa.HttpService.POST(
            {
                mod = "Task",
                act = "getList"
            },
            function(data)
                local retData = json.decode(data)
                if retData and retData.code == 1 then
                    self:setTaskData_(retData, init)
                end
                self.isBusy = false
            end,
            function()
                self.isBusy = false
            end
        )
    end
end

--获取成就数据
function DailyTasksController:getAchieveListData(init)
    if not self.isAchieveBusy then
        self.isAchieveBusy = true
        self.allAchieveList = nil
        self.allAchieveList = {}

        sa.HttpService.POST(
            {
                mod = "Achievement",
                act = "get"
            },
            function(data)
                local retData = json.decode(data)
                if retData and retData.code == 1 then
                    self:setAchieveData_(retData, init)
                end
            end,
            function() end
        )
    end
end

--封装任务数据结构
function DailyTasksController:setTaskData_(retData, init)
    local cdn = tx.userData.missionDomain
    if retData and retData.list then
        for k, v in pairs(retData.list) do
            v.iconUrl = cdn .. v.image
        end
    end

    self:processTask_(retData.list)

    if not init then
        sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.LOAD_TASK_LIST_ALREAD, data = self.allTaskList}) 
    end
    sa.DataProxy:setData(tx.dataKeys.NEW_REWARD_TASK, self:checkCanRewardTask())
end

function DailyTasksController:processTask_(taskList)
    if taskList then
        for _, v in pairs(taskList) do
            if v then
                local task = DailyTask.new()
                task:parseTableData(v)
                if v.goto == 13 then
                    local isEnabled = tx.Native:checkPushEnabled()
                    local isFinished = tx.userDefault:getBoolForKey(tx.cookieKeys.IS_FINISHED_PUSH_TASK .. tx.userData.uid .. os.date("%Y%m%d"), false)
                    if isFinished then
                        v.cur = 1
                        task:parseTableData(v)
                    end
                    if not isEnabled or task.status == DailyTask.STATUS_CAN_REWARD then
                        table.insert(self.allTaskList, task)
                    end
                else
                    table.insert(self.allTaskList, task)
                end
            end
        end

        self:sortData_(self.allTaskList)
    end
end

--检测任务是否有可领取奖励
function DailyTasksController:checkCanRewardTask()
    for _,task in pairs(self.allTaskList) do
        if task and task.status == DailyTask.STATUS_CAN_REWARD then
            return true
        end
    end

    return false
end

--封装成就数据结构
function DailyTasksController:setAchieveData_(retData, init)
    local cdn = tx.userData.missionDomain
    if retData and retData.list then
        for k, v in pairs(retData.list) do
            v.iconUrl = cdn .. v.image
            v.id = k
        end
    end

    self:processAchieve_(retData.list)

    if not init then
        sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.LOAD_ACHIEVE_LIST_ALREAD, data = self.allAchieveList})
    end

    -- sa.DataProxy:setData(tx.dataKeys.NEW_REWARD_ACHIEVE, self:checkCanRewardAchieve())

    self.isAchieveBusy = false
end

function DailyTasksController:processAchieve_(achieveList)
    if achieveList then
        for _, v in pairs(achieveList) do
            if v then
                local achieve = Achieve.new()
                achieve:parseTableData(v)
                table.insert(self.allAchieveList, achieve)
            end
        end

        table.sort(self.allAchieveList, function(o1, o2)
            return o1.sort > o2.sort
        end)

        -- self:sortData_(self.allAchieveList)
    end
end

--检测成就是否有可领取奖励
function DailyTasksController:checkCanRewardAchieve()
    for _,achieve in pairs(self.allAchieveList) do
        if achieve and achieve.status == Achieve.STATUS_CAN_REWARD then
            return true
        end
    end
    return false
end

--任务成就排序, 更新任务成就状态
function DailyTasksController:sortData_(list)
    if list then
        for _, v in pairs(list) do
            v:update()
        end

        table.sort(list, function(o1, o2)
            if o1.status == o2.status then
                if o1.progress and o1.target and o2.progress and o2.target then
                    local p1 = o1.progress*1.0/o1.target
                    local p2 = o2.progress*1.0/o2.target
                    if math.abs(p1 - p2) < 0.02 then
                        return o1.sort > o2.sort
                    else
                        return p1 > p2
                    end
                else
                    return o1.sort > o2.sort
                end
            else
                return o1.status < o2.status
            end
        end)
    end
end

--任务上报 1 allin; 2. fb分享; 3.赠送荷官 4好牌胜利
function DailyTasksController:reportDailyTask(type, data)
    local params = {
        mod = "Task",
        act = "report"
    }

    if type == 1 then
        params.allin = 1 --allin次数
        if data and data.iswin then
            params.iswin = data.iswin --是否胜利
        end
    elseif type == 2 then
        params.sharefb = 1 --分享FB次数
    elseif type == 3 then
        params.senddealer = 1 --赠送荷官次数
    elseif type == 4 and data then
        if data.cardType == consts.CARD_TYPE.FLUSH then
            params.flush = 1 -- 同花胜利
        elseif data.cardType == consts.CARD_TYPE.STRAIGHT then
            params.straight = 1 --顺子胜利
        elseif data.cardType == consts.CARD_TYPE.FOUR_KIND then
            params.stiao = 1 --四条胜利
        elseif data.cardType == consts.CARD_TYPE.STRAIGHT_FLUSH then
            params.straight_flush = 1 --同花顺子胜利
        elseif data.cardType == consts.CARD_TYPE.FULL_HOUSE then
            params.hlu = 1 --葫芦胜利
        end
    end

    sa.HttpService.POST(params,
        function(data)
        end,
        function() end
    )
end

--领取任务奖励
function DailyTasksController:onGetReward_(evt)
    local task = evt.data
    sa.HttpService.POST(
        {
            mod = "Task",
            act = "reward",
            id = task.id,
            subtask = task.currentSubTaskId or 0,
        },
        function(data)
            local retData = json.decode(data)
            if retData.code == 1 then
                local str = ""
                if retData.money and retData.money ~= 0 then
                    local reward = sa.LangUtil.getText("STORE", "FORMAT_CHIP", retData.money)
                    str = sa.LangUtil.getText("COMMON", "REWARD_TIPS", reward)
                    tx.userData.money = tx.userData.money + tonumber(retData.money)
                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=retData.money}})
                end

                if str ~= "" then
                    tx.TopTipManager:showGoldTips(str)
                end
                if task.subtask and task.subtask[task.currentSubTaskIndex] then
                    task.subtask[task.currentSubTaskIndex].rewarded = 1
                end
            end

            self:sortData_(self.allTaskList)

            --刷新数据列表
            sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GET_RWARD_ALREADY, data = self.allTaskList})
            --刷新大厅任务红点提示
            tx.userData.canTasksReward = self:checkCanRewardTask()
            sa.DataProxy:setData(tx.dataKeys.NEW_REWARD_TASK, tx.userData.canTasksReward)
            sa.EventCenter:dispatchEvent({name=tx.eventNames.TASK_REWARD_POINT})
        end,
        function()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_TASK_REWARD"))
        end
    )
end

--领取成就奖励
function DailyTasksController:onGetAchieveReward_(evt)
    local achieve = evt.data
    sa.HttpService.POST(
        {
            mod = "Achievement",
            act = "reward",
            id = achieve.id,
            subtask = achieve.currentSubTaskId or 0,
        },
        function(data)
            
            local retData = json.decode(data)
            if retData.code == 1 then
                local str = ""
                if retData.money and retData.money ~= 0 then
                    local reward = sa.LangUtil.getText("STORE", "FORMAT_CHIP", retData.money)
                    str = sa.LangUtil.getText("COMMON", "REWARD_TIPS", reward)
                    tx.userData.money = tx.userData.money + tonumber(retData.money)
                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=retData.money}})
                end

                if str ~= "" then
                    tx.TopTipManager:showGoldTips(str)
                end

                if achieve.subtask and achieve.subtask[achieve.currentSubTaskIndex] then
                    achieve.subtask[achieve.currentSubTaskIndex].rewarded = 1
                    achieve:update()
                end
            end

            -- self:sortData_(self.allAchieveList)

            --刷新数据列表
            sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GET_ACHIEVE_RWARD_ALREADY, data = self.allAchieveList})
            
            --刷新大厅任务红点提示
            tx.userData.canAchieveReward = self:checkCanRewardAchieve()
            sa.EventCenter:dispatchEvent({name=tx.eventNames.TASK_REWARD_POINT})
        end,
        function()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_TASK_REWARD"))
        end
    )
end

return DailyTasksController
