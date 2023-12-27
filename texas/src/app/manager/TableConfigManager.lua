-- 统一管理桌子配置信息，包含普通场，比赛场等

local TableConfigManager = class("TableConfigManager")

function TableConfigManager:ctor()
    self.texasRetryTimes_ = 2
    self.sngRetryTimes_ = 2
    self.omahaRetryTimes_ = 2
    self.texasMustRetryTimes_ = 2
end

--德州房间桌子配置
function TableConfigManager:getTexasTableConfig(callback, isFirst)
    if isFirst then
        self.texasRetryTimes_ = 2
    end
    sa.HttpService.CANCEL(self.texasRequestId_)
    self.texasRequestId_ = sa.HttpService.POST({
        mod = "Table",
        act = "tableConf",
        gameId = 1
    },
    function(data)
        local retData = json.decode(data)
        if retData and retData.code == 1 then
            tx.userData.tableConfig = retData.conf
            tx.userData.recommendTable = retData.recommendtable
            tx.userData.tableLevelLimit = retData.levelLimit
            tx.userData.newPlayerMultiple = retData.newPlayerMultiple --新手保护盲注倍数
            tx.userData.guideMultiple = retData.guideMultiple --引导大场玩牌盲注倍数
            tx.userData.guideGameNum = retData.guideGameNum --房间内引导牌局间隔
            tx.userData.maxGuideBlind = retData.maxGuideBlind --最大引导盲注，大于这个盲注不进行引导大场
            if callback then
                callback()
            end
        else
            self.texasRetryTimes_ = self.texasRetryTimes_ - 1
            if self.texasRetryTimes_ >= 0 then
                tx.schedulerPool:delayCall(function ()
                    self:getTexasTableConfig(callback)
                end, 2)
            end
        end
    end,
    function()
        self.texasRetryTimes_ = self.texasRetryTimes_ - 1
        if self.texasRetryTimes_ >= 0 then
            tx.schedulerPool:delayCall(function ()
                self:getTexasTableConfig(callback)
            end, 2)
        end
    end)
end

--SNG比赛桌子配置
function TableConfigManager:getSNGTableConfig(callback, isFirst)
    if isFirst then
        self.sngRetryTimes_ = 3
    end
    sa.HttpService.CANCEL(self.sngRequestId_)
    self.sngRequestId_ = sa.HttpService.POST({
        mod = "Match",
        act = "getTableList",
        mtype = "SNG"
    },
    function(data)
        local retData = json.decode(data)
        if retData and retData.code == 1 then
            self:initSngData_(retData.list)
            if callback then
                callback()
            end
        else
            self.sngRetryTimes_ = self.sngRetryTimes_ - 1
            if self.sngRetryTimes_ >= 0 then
                tx.schedulerPool:delayCall(function ()
                    self:getSNGTableConfig(callback)
                end, 2)
            end
        end
    end,
    function()
        self.sngRetryTimes_ = self.sngRetryTimes_ - 1
        if self.sngRetryTimes_ >= 0 then
            tx.schedulerPool:delayCall(function ()
                self:getSNGTableConfig(callback)
            end, 2)
        end
    end)
end

function TableConfigManager:initSngData_(config)
    local sngData = {}
    local index = 0
    for i, v in ipairs(config) do
        local data = {}
        data.matchType = "sng"
        data.name = v.matchname
        data.matchlevel = v.matchlevel
        data.imgIndex = index % 4 + 1
        data.player = v.MaxUserCount
        data.online = v.currentJoinCnt
        data.registerCost = v.TicketMoney 
        data.serverCost = v.service_fee
        data.chip = v.init_money
        
        local time = v.zhangmang_jiange
        data.blindTime = time

        local blindArr = string.split(v.smallblinds, ",")
        local blindData = {}
        for i,v in ipairs(blindArr) do
            local tmp = {}
            tmp.blind = blindArr[i]
            tmp.pre = 0
            tmp.time = time

            blindData[i] = tmp
        end
        data.blindData = blindData
        data.startBlind = blindData[1].blind

        local reward = {}
        local matchreward = v.matchreward
        local len = table.nums(matchreward)
        for i = 1, len do
            local t = {}
            t.chips = tonumber(matchreward["r" .. i].money)
            t.dhqReward = tonumber(matchreward["r" .. i].coupon or 0)
            reward[i] = t
        end

        data.reward = reward
        index = index + 1
        sngData[i] = data
    end

    if tx.userData then
        tx.userData.sngTableConfig = sngData --全局保存客户端转换好的数据，在房间内使用
    end
end

--奥马哈房间桌子配置
function TableConfigManager:getOmahaTableConfig(callback, isFirst)
    if isFirst then
        self.omahaRetryTimes_ = 2
    end
    sa.HttpService.CANCEL(self.omahaRequestId_)
    self.omahaRequestId_ = sa.HttpService.POST({
        mod = "Table",
        act = "tableConf",
        gameId = 3
    },
    function(data)
        local retData = json.decode(data)
        if retData and retData.code == 1 then
            tx.userData.omahaTableConfig = retData.conf
            tx.userData.omahaLevelLimit = retData.levelLimit
            if callback then
                callback()
            end
        else
            self.omahaRetryTimes_ = self.omahaRetryTimes_ - 1
            if self.omahaRetryTimes_ >= 0 then
                tx.schedulerPool:delayCall(function ()
                    self:getOmahaTableConfig(callback)
                end, 2)
            end
        end
    end,
    function()
        self.omahaRetryTimes_ = self.omahaRetryTimes_ - 1
        if self.omahaRetryTimes_ >= 0 then
            tx.schedulerPool:delayCall(function ()
                self:getOmahaTableConfig(callback)
            end, 2)
        end
    end)
end

--德州必下桌子配置
function TableConfigManager:getTexasMustTableConfig(callback, isFirst)
    if isFirst then
        self.texasMustRetryTimes_ = 2
    end
    sa.HttpService.CANCEL(self.texasMustRequestId_)
    self.texasMustRequestId_ = sa.HttpService.POST({
        mod = "Table",
        act = "tableConf",
        gameId = 5
    },
    function(data)
        local retData = json.decode(data)
        if retData and retData.code == 1 then
            tx.userData.texasMustTableConfig = retData.conf
            tx.userData.texasMustLevelLimit = retData.levelLimit
            if callback then
                callback()
            end
        else
            self.texasMustRetryTimes_ = self.texasMustRetryTimes_ - 1
            if self.texasMustRetryTimes_ >= 0 then
                tx.schedulerPool:delayCall(function ()
                    self:getTexasMustTableConfig(callback)
                end, 2)
            end
        end
    end,
    function()
        self.texasMustRetryTimes_ = self.texasMustRetryTimes_ - 1
        if self.texasMustRetryTimes_ >= 0 then
            tx.schedulerPool:delayCall(function ()
                self:getTexasMustTableConfig(callback)
            end, 2)
        end
    end)
end

return TableConfigManager