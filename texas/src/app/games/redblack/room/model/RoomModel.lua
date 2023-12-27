local logger = sa.Logger.new("RoomModel")
local RoomModel = {}

function RoomModel.new()
    local instance = {}
    local datapool = {}
    local function getData(table,key)
        return RoomModel[key] or datapool[key]
    end
    local function setData(table, key, value)
        datapool[key] = value
    end
    local function clearData(self)
        local newdatapool = {}
        for k, v in pairs(datapool) do
            if type(v) == "function" then
                newdatapool[k] = v
            end
        end
        datapool = newdatapool
        return self
    end
    instance.clearData = clearData
    local mtable = {__index = getData, __newindex = setData}
    setmetatable(instance, mtable)
    instance:ctor()
    return instance
end

function RoomModel:ctor()
    self.history_ = {}
    self.lastBetList = {}
    self.betList = {}
    self.selfSeatId_ = -1
    self.roomType_ = 0

    local countList = {}
    countList.silverWinTimes = 0
    countList.goldkWinTimes = 0
    countList.drawWinTimes = 0
    countList.thlpTimes = 0
    countList.daTimes = 0
    countList.hlTimes = 0
    countList.jgTimes = 0
    self.countList_ = countList

    self.isSelfWin_ = false
    self.isPlaying_ = false
end

function RoomModel:roomType()
    return self.roomType_
end

--登录成功
function RoomModel:initWithLoginSuccessPack(pack)
    local roomInfo = {}
    self.roomInfo = roomInfo
    roomInfo.basechip = pack.basechip
    roomInfo.minBuyIn = pack.minBuyIn
    roomInfo.maxBuyIn = pack.maxBuyIn
    roomInfo.roomName = pack.roomName
    
    roomInfo.roomType = pack.roomType
    roomInfo.userChips = pack.userChips
    roomInfo.betExpire = pack.betExpire/10 --最大下注时间
    roomInfo.playerNum = pack.seatNum
    roomInfo.blind = 5000 --快捷商城需要的参数

    roomInfo.tid = pack.tid

    self.roomType_ = roomInfo.roomType

    --游戏信息
    local gameInfo = {}
    self.gameInfo = gameInfo
    gameInfo.gameStatus = pack.gameStatus
    gameInfo.pubCard = pack.pubCard
    gameInfo.betLeftTime = math.floor((pack.betLeftTime or 0) / 10)
    gameInfo.gameLeftTime = math.floor((pack.gameLeftTime or 0) / 10)
    gameInfo.allBetList = pack.allBetList
    gameInfo.maxBetNum = pack.maxBetNum

    --座位上玩家信息
    local playerList = {}
    self.playerList = playerList
    for i, player in ipairs(pack.playerList) do
        if player.uid == tx.userData.uid then
            self.selfSeatId_ = player.seatId
        else
            playerList[player.seatId] = player
            self:updateUserInfo(player)
        end
    end

    self.isSelfWin_ = false
    self.isPlaying_ = false
    self.betList = {}
    self.lastBetList = {}
end

--坐下
function RoomModel:processSitDown(player)
    local isSelf = false
    if player.uid == tx.userData.uid then
        self.selfSeatId_ = player.seatId
        isSelf = true
    else
        self.playerList[player.seatId] = player
        self:updateUserInfo(player)
    end

    return player.seatId, isSelf
end

--座位上的玩家，离开房间
function RoomModel:processStandUp(seatId)
    self.playerList[seatId] = nil
end

--游戏开始
function RoomModel:processGameStart(pack)
    self.gameInfo.gameStatus = consts.SVR_GAME_STATUS.DEAL_CARD_ANI_2
    self.isSelfWin_ = false
    self.isPlaying_ = false
    for _,v in pairs(pack.playerList) do
        if self.playerList[v.seatId] then
            self.playerList[v.seatId].uid = v.uid
            self.playerList[v.seatId].money = v.seatChips
        end
    end
    self.betList = {}
end

--服务器同步用户数据
function RoomModel:svrModifyUserinfo(pack)
    local uid = pack.uid
    if uid == tx.userData.uid then
        return 9
    end

    local seatId = self:getSeatIdByUid(uid)
    if seatId < 0 then
        return seatId
    end

    local player = self.playerList[seatId]
    player.userInfo = pack.info
    self:updateUserInfo(player)

    return seatId
end

--更新用户数据
function RoomModel:updateUserInfo(player)
    local info = json.decode(player.userInfo)
    if info then
        player.nick = info.nick
        player.img = info.img
        player.sex = info.sex
        if info.money then  -- 真人有 机器人没有
            player.money = info.money
        elseif player.seatChips then  -- 机器人
            player.money = player.seatChips
        end
        player.vip = info.vip or 0
    end
end

--获取位置ID
function RoomModel:getSeatIdByUid(uid)
    for seatId = 0, 8 do
        local player = self.playerList[seatId]
        if player and player.uid == uid then
            return seatId
        end
    end
    return -1
end

--自己下注成功,保存下注记录,判断双倍下注按钮是否可以点击
function RoomModel:processSelfBetSuccess(pack)
    self.isPlaying_ = true
    local data = {}
    data.betType = pack.betType
    data.betChips = pack.betChips

    for _, v in ipairs(self.betList) do
        if v.betType == data.betType then
            v.betChips = v.betChips + data.betChips
            return
        end
    end

    table.insert(self.betList, data)
end

--处理其他玩家下注,同步筹码显示
function RoomModel:processOtherBetSuccess(uid, betChips)
    local seatId = self:getSeatIdByUid(uid)
    if seatId >= 0 then
        local player = self.playerList[seatId]
        player.money = player.money - betChips
        if player.money <= 0 then
            player.money = 0
        end
    end
end

--获取当前下注总额，用于双倍点击
function RoomModel:getTotalBetChips()
    local total = 0 

    for _, v in ipairs(self.betList) do
        total = total + v.betChips
    end

    return total
end

--获取上局下注总额，用于重复上局点击
function RoomModel:getLastBetChips()
    local total = 0 

    for _, v in ipairs(self.lastBetList) do
        total = total + v.betChips
    end

    return total
end

--获取胜利的座位
function RoomModel:getWinSeats_(winType, allchip, pack)
    local seats = {}
    local chip = 0
    for i,v in pairs(pack.betResult) do
        if v.betType == winType then
            local data = {}
            data.uid = tx.userData.uid
            data.chips = v.winChips
            data.seatId = self:selfSeatId()
            self.isSelfWin_ = true
            table.insert(seats,data)
            chip = chip + v.winChips
            break
        end
    end

    for _,v in pairs(pack.playerList) do
        if v.uid == tx.userData.uid then
        else
            for _,value in pairs(v.betResult) do
                if value.betType == winType then
                    local data = {}
                    data.uid = v.uid
                    data.chips = value.winChips
                    data.seatId = v.seatId
                    table.insert(seats,data)
                    chip = chip + value.winChips
                    break
                end
            end
        end
    end

    if allchip > chip then
        local data = {}
        data.uid = -1
        data.chips = allchip - chip
        data.seatId = -1
        table.insert(seats,data)
    end

    return seats
end

--牌局结果
function RoomModel:processGameOver(pack)
    self.gameInfo.gameStatus = consts.SVR_GAME_STATUS.READY_TO_START

    local result = {}
    result.winner = pack.winner
    result.playerList = pack.playerList
    result.nextTime = pack.nextTime / 10

    result.cards = {
        pack.r_card1,
        pack.r_card2,
        pack.b_card1,
        pack.b_card2,
        pack.pub_card1,
        pack.pub_card2,
        pack.pub_card3,
        pack.pub_card4,
        pack.pub_card5
    }

    result.cardType = {
        pack.r_card_type, --银象牌型
        pack.b_card_type --金象牌型
    }

    if pack.win_card1 then
        result.winCards = {
            pack.win_card1,
            pack.win_card2,
            pack.win_card3,
            pack.win_card4,
            pack.win_card5
        }
    end

    --封装押注数据
    result.winData = {}
    for _, v in pairs(pack.winResult) do
        local data = {}
        data.winType = v.winType
        data.winChips = v.chips
        data.winSeats = self:getWinSeats_(v.winType, v.chips, pack)
        table.insert(result.winData, data)
    end

    self.lastBetList = self.betList
    self.betList = {}

    --同步其他玩家结算后的筹码
    for _, v in ipairs(pack.playerChipsList) do
        local seatId = self:getSeatIdByUid(v.uid)
        if seatId >= 0 then
            local player = self.playerList[seatId]
            player.money = v.money
        end
    end

    return result
end

--自己的位置
function RoomModel:selfSeatId()
    return self.selfSeatId_
end

--是否在座位上
function RoomModel:isSelfInSeat()
    return true
end

function RoomModel:isSelfInGame()
    for _, v in pairs(self.playerList) do
        if v.uid == tx.userData.uid then
            return true
        end
    end

    return false
end

--和比赛场一样，不能赠送筹码，这里为了统一接口，所以没改名字
function RoomModel:isInMatch()
    return true
end

--获取下注时间
function RoomModel:getBetTime()
    return self.roomInfo.betExpire
end

--获取下注时间
function RoomModel:getBetTime()
    return self.roomInfo.betExpire
end

--下注中状态，获取剩余下注时间
function RoomModel:getBetLeftTime()
    return self.gameInfo.betLeftTime
end

--结算状态，获取结算剩余时间
function RoomModel:getGameLeftTime()
    return self.gameInfo.gameLeftTime
end

--获取游戏状态
function RoomModel:getGameStatus()
    return self.gameInfo.gameStatus
end

--本次下注betChips+之前总下注totalBet，是否超出本局最大下注限额
function RoomModel:isMaxBetNum(betChips)
    local totalBet = self:getTotalBetChips()
    local maxBetBum = self.gameInfo.maxBetNum
    if totalBet + betChips > maxBetBum then
        return true
    end

    return false
end

--获取本局最大下注限额
function RoomModel:getMaxBetNum()
    return self.gameInfo.maxBetNum
end

--历史牌局
function RoomModel:setHistory(pack)
    local countList = self.countList_
    countList.silverWinTimes = pack.silverWinTimes
    countList.goldkWinTimes = pack.goldkWinTimes
    countList.drawWinTimes = pack.drawWinTimes
    countList.thlpTimes = pack.thlpTimes
    countList.daTimes = pack.daTimes
    countList.hlTimes = pack.hlTimes
    countList.jgTimes = pack.jgTimes

    self.history_ = pack.history
end

function RoomModel:updateHistory(history)
    table.insert(self.history_, history)
    self:updateHistory_()
end

function RoomModel:getHistory()
    self:updateHistory_()
    return self.history_
end

function RoomModel:updateHistory_()
    local len = #self.history_
    if len > 40 then
        self.history_ = table.slice(self.history_, len - 39)
    end
end

function RoomModel:updateCountList(winResult)
    local countList = self.countList_
    for _, v in ipairs(winResult) do
        local winType = v.winType
        if winType == 1 then
            countList.silverWinTimes = countList.silverWinTimes + 1
        elseif winType == 2 then
            countList.drawWinTimes = countList.drawWinTimes + 1
        elseif winType == 3 then
            countList.goldkWinTimes = countList.goldkWinTimes + 1
        elseif winType == 7 then
             countList.thlpTimes = countList.thlpTimes + 1
        elseif winType == 8 then
            countList.daTimes = countList.daTimes + 1
        elseif winType == 12 then
            countList.hlTimes = countList.hlTimes + 1
        elseif winType == 13 then
            countList.jgTimes = countList.jgTimes + 1
        end
    end
end

function RoomModel:getCountList()
    return self.countList_
end

function RoomModel:isSelfWin()
    return self.isSelfWin_
end

function RoomModel:isSelfPlaying()
    return self.isPlaying_
end

return RoomModel
