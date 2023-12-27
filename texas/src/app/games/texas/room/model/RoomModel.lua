local SeatStateMachine = import(".SeatStateMachine")
local CardType = import(".CardType")
local logger = sa.Logger.new("RoomModel")
local RoomModel = {}

function RoomModel.new(ctx,isInMatch)
    local instance = {}
    local datapool = {}
    local function getData(table, key)
        return RoomModel[key] or datapool[key]
    end
    local function setData(table, key, value)
        datapool[key] = value
    end
    local function clearData(self)
        local newdatapool = {}
        local isInMatch = datapool.isInMatch_
        local statistics = datapool.statistics_
        for k, v in pairs(datapool) do
            if type(v) == "function" then
                newdatapool[k] = v
            end
        end
        datapool = newdatapool
        datapool.isInMatch_ = isInMatch
        datapool.statistics_ = statistics
        return self
    end
    instance.clearData = clearData
    local mtable = {__index = getData, __newindex = setData}
    setmetatable(instance, mtable)
    instance:ctor(isInMatch)
    return instance
end

function RoomModel:ctor(isInMatch)
    -- clear的时候保留
    self.isInMatch_ = isInMatch
    self.statistics_ = { -- 资产统计
        changeChips = 0,
        playNum = 0,
        maxWin = 0,
    }

    self.isInitialized = false

    self.isSelfInGame_ = false
    self.isSelfInRound_ = false
    self.isSelfAllIn_ = false
    self.isSelfPlayCurGame_ = false
    self.canShowHandcard_ = false
    self.canShowHandcardButton_ = false
    self.selfSeatId_ = -1
    self.selfTotalBet_ = 0
    self.roomType_ = 0
    self.roomField_ = 1 
end

-- 是否是自己
function RoomModel:isSelf(uid)
    return tx.userData.uid == uid
end

-- 是否在本轮游戏（游戏开始至游戏刷新）
function RoomModel:isSelfInRound()
    return self.isSelfInRound_
end

-- 是否正在游戏（游戏开始至游戏刷新，弃牌置为false）
function RoomModel:isSelfInGame()
    return self.isSelfInGame_
end

--是否参与当前这局游戏，只要游戏开始的时候参与了就算。如果结算前站起则不算参与，但是弃牌了还是算参与了(就算重连也算)。
function RoomModel:isSelfPlayCurGame()
    return self.isSelfPlayCurGame_
end

-- 本人是否在座
function RoomModel:isSelfInSeat()
    return self.selfSeatId_ >= 0 and self.selfSeatId_ <= 8
end

-- 本人是否all in
function RoomModel:isSelfAllIn()
    return self.isSelfAllIn_
end

--可以亮出手牌
function RoomModel:canShowHandcard()
    return self.canShowHandcard_
end

function RoomModel:canShowHandcardButton()
    return self.canShowHandcardButton_
end

-- 是否在比赛场
function RoomModel:isInMatch()
    return self.isInMatch_
end

-- 获取自己的座位id
function RoomModel:selfSeatId()
    return self.selfSeatId_
end

function RoomModel:selfSeatData()
    return self.playerList[self.selfSeatId_]
end

-- 自己本轮下注总筹码
function RoomModel:selfTotalBet()
    return self.selfTotalBet_
end

-- 获取当前房间类型
function RoomModel:roomType()
    return self.roomType_
end

-- 1初级场 2中级场 3高级场
function RoomModel:roomField()
    return self.roomField_
end

--判断是否为私人房，大于0为私人房
function RoomModel:isPrivateRoom()
    return self.roomFlag_ and self.roomFlag_ > 0 or false
end

-- 获取当前在桌人数
function RoomModel:getNumInSeat()
    local num = 0
    for i = 0, 8 do
        if self.playerList[i] then
            num = num + 1
        end
    end

    return num
end

-- 获取牌桌所有用户的UID 
function RoomModel:getTableAllUid()
    local tableAllUid = ""
    local userUid = ""
    local toUidArr = {}
    for seatId = 0, 8 do
        local player = self.playerList[seatId]
        if player and player.uid then
            userUid = userUid..","..player.uid
            table.insert(toUidArr, player.uid)
        end
        tableAllUid = string.sub(userUid,2)
    end
    return tableAllUid,toUidArr
end

-- 获取当前在玩人数
function RoomModel:getNumInGame()
    local num = 0
    for i = 0, 8 do
        if self.playerList[i] and self.playerList[i].inGame then
            num = num + 1
        end
    end

    return num
end

function RoomModel:getSeatIdByUid(uid)
    for seatId = 0, 8 do
        local player = self.playerList[seatId]
        if player and player.uid == uid then
            return seatId,player
        end
    end
    return -1,nil
end

-- 获取本轮参与玩家人数
function RoomModel:getNumInRound()
    local num = 0
    for i = 0, 8 do
        if self.playerList[i] and self.playerList[i].inRound then
            num = num + 1
        end
    end

    return num
end

function RoomModel:getNewCardType(cardType, pointCount)
    return CardType.new(cardType)
end

function RoomModel:selfCallNeedChips()
    local seatData = self:selfSeatData()
    if seatData  then
        return seatData.betNeedChips
    end
    return 0
end

--当前桌子上的总筹码（奖池+座位已下注筹码)
function RoomModel:totalChipsInTable()

    local total = 0
    local pots = self.gameInfo.pots
    if pots and #pots > 0 then
        for i = 1, #pots do
            total = total + pots[i]
        end
    end
    for i = 0, 8 do
        local player = self.playerList[i]
        if player and player.betChips then
            total = total + tonumber(player.betChips)
        end
    end
    return total
end

function RoomModel:currentMaxBetChips()
    local max = 0
    for i = 0, 8 do
        local player = self.playerList[i]
        if player and player.inGame and player.betChips and player.betChips > max then
            max = player.betChips
        end
    end
    return max
end

function RoomModel:initWithLoginSuccessPack(pack)
    self.clearData()
    self.isInitialized = true
    self.isSelfInGame_ = false
    self.isSelfInRound_ = false
    self.isSelfPlayCurGame_ = false
    self.isSelfAllIn_ = false
    self.canShowHandcard_ = false
    self.canShowHandcardButton_ = false
    self.selfSeatId_ = -1
    self.selfTotalBet_ = 0
    self.roomType_ = 0
    --座位配置
    local seatsInfo = {}
    self.seatsInfo = seatsInfo
    seatsInfo.seatNum = pack.seatNum
    for i=1, pack.seatNum do
        local seatId = i - 1
        local seatInfo = {}
        seatInfo.seatId = seatId
        seatsInfo[seatId] = seatInfo
    end
    --房间信息
    local roomInfo = {}
    self.roomInfo = roomInfo
    roomInfo.betExpire = pack.betExpire/10 -- server是以100毫秒为单位
    roomInfo.roomField = pack.roomField or 1
    roomInfo.roomFlag = pack.roomFlag or 0
    roomInfo.minBuyIn = pack.minBuyIn
    roomInfo.maxBuyIn = pack.maxBuyIn
    roomInfo.roomName = pack.roomName
    roomInfo.roomType = pack.roomType
    roomInfo.blind = pack.blind
    roomInfo.playerNum = pack.seatNum
    roomInfo.ip     = pack.ip or ""
    roomInfo.port     = pack.port or 999
    roomInfo.tid     = pack.tid

    -- 设置当前field 1初级场 2中级场 3高级场
    self.roomField_ = roomInfo.roomField

    self.roomFlag_ = roomInfo.roomFlag

    -- 设置当前房间类型，判断是否是比赛场
    self.roomType_ = roomInfo.roomType

    --游戏信息
    local gameInfo = {}
    self.gameInfo = gameInfo
    gameInfo.pubCards = pack.pubCards
    gameInfo.gameStatus = pack.gameStatus
    gameInfo.bettingSeatId = pack.bettingSeatId
    gameInfo.dealerSeatId = pack.dealerSeatId
    gameInfo.pots = pack.pots
    gameInfo.hasRaise = false
    gameInfo.dealCardNum = 0  --发了牌的玩家
    if gameInfo.bettingSeatId ~= -1 then
        gameInfo.callChips = pack.callChips
        gameInfo.minRaiseChips = pack.minRaiseChips
        gameInfo.maxRaiseChips = pack.maxRaiseChips
    else
        gameInfo.callChips = 0
        gameInfo.minRaiseChips = 0
        gameInfo.maxRaiseChips = 0
    end
    gameInfo.selfBuyInChips = pack.userChips

    --在玩玩家信息
    local playerList = {}
    self.playerList = playerList
    -- 需要考虑只有一个玩家在座但游戏尚未结束的情况
    if #pack.playerList == 1 then
        pack.playerList[1].betState = consts.SVR_BET_STATE.WAITTING_START
        pack.playerList[1].playing = 0
    end
    for i, player in ipairs(pack.playerList) do
        player.isSelf = self:isSelf(player.uid)
        -- 判断是否在玩
        if player.playing==1 then
            gameInfo.dealCardNum = gameInfo.dealCardNum + 1
            player.inGame = true
            player.inRound = true
            if player.betState == consts.SVR_BET_STATE.FOLD or player.betState == consts.SVR_BET_STATE.WAITTING_START then
                player.inGame = false
                player.inRound = false
            end
            if player.isSelf then
                gameInfo.handCards = player.handCards
                gameInfo.cardType = CardType.new(0)
                self.isSelfPlayCurGame_ = true
                if player.betState == consts.SVR_BET_STATE.FOLD then
                    self.canShowHandcard_ = true
                end
            end
            -- 重连没有AllIn状态
            if player.seatChips==0 then
                player.betState = consts.SVR_BET_STATE.ALL_IN
            end
        else
            player.inGame = false
            player.inRound = false
            player.betChips = 0
            player.betState = consts.SVR_BET_STATE.WAITTING_START
        end

        self:updateUserInfo(player)
        -- 计算玩家实际当前的钱数
        player.curChips = player.seatChips + player.betChips -- 当前筹码
        
        playerList[player.seatId] = player
        player.statemachine = SeatStateMachine.new(player, player.seatId == gameInfo.bettingSeatId, gameInfo.gameStatus)
        -- 判断是否是自己，获取自己的座位id，判断是否在游戏中
        if player.isSelf then
            self.selfSeatId_ = player.seatId
            if player.inGame then
                self.isSelfInGame_ = true
                self.isSelfInRound_ = true
                player.cardType = gameInfo.cardType or CardType.new(0)
            end
            sa.DataProxy:setData(tx.dataKeys.SIT_OR_STAND, self:isSelfInSeat())
        end
    end

    if self.isSelfInRound_ then
        for i, player in ipairs(pack.playerList) do
            if player.betChips > self:selfSeatData().betChips then
                gameInfo.hasRaise = true
            end
        end
    end
end

--比赛基本信息
function RoomModel:initMatchBaseInfo(pack)
    local info = json.decode(pack.matchBaseInfo)
    local matchBaseInfo = {}
    matchBaseInfo.startMatchNum = info.user_num --开赛人数

    self.matchBaseInfo = matchBaseInfo
end

function RoomModel:processGameStart(pack)
    -- 测试
    -- pack.handCard1 = 0x23
    -- pack.handCard2 = 0x28
    -- pack.handCard3 = 0x18
    -- pack.handCard4 = 0x38
    -- 设置gameInfo
    self.gameInfo.gameStatus = consts.SVR_GAME_STATUS.BET_ROUND_1
    self.gameInfo.dealerSeatId = pack.dealerSeatId
    self.gameInfo.bettingSeatId = -1
    self.gameInfo.pots = {}
    self.gameInfo.dealCardNum = 0
    
    self.gameInfo.handCards = {pack.handCard1, pack.handCard2, pack.handCard3, pack.handCard4}
    self.gameInfo.cardType = CardType.new(0)
    self.gameInfo.selfBuyInChips = 0
    self.gameInfo.pubCards = {}
    --是否有加注
    self.gameInfo.hasRaise = false
    --是否all导致结算
    self.gameInfo.allAllIn = false
    --不可亮牌
    self.canShowHandcard_ = false
    self.canShowHandcardButton_ = false
    -- 设置playerList
    for i, v in ipairs(pack.playerList) do
        local player = self.playerList[v.seatId]
        assert(player, "PLAYER NOT FOUND")
        assert(player.uid == v.uid, "PLAYER CHANGED " .. player.uid .. " to " .. v.uid)
        player.seatChips = v.seatChips
        player.curChips = player.seatChips -- 当前筹码
        if player.isSelf then
            self.gameInfo.selfBuyInChips = player.seatChips
        end
    end
    for i = 0, 8 do
        local player = self.playerList[i]
        if player then
            self.gameInfo.dealCardNum = self.gameInfo.dealCardNum + 1
            player.inGame = true
            player.inRound = true
            player.betState = consts.SVR_BET_STATE.WAITTING_BET
            player.statemachine:doEvent(SeatStateMachine.GAME_START)

            if player.isSelf then
                self.isSelfInGame_ = true
                self.isSelfInRound_ = true
                self.isSelfPlayCurGame_ = true
                player.handCards = self.gameInfo.handCards
                player.cardType = self.gameInfo.cardType
            else
                player.handCards = {0, 0, 0, 0}
                player.cardType = nil
            end
        end
    end
end

function RoomModel:processBetFail(pack)
    local player = self.playerList[pack.seatId]
    assert(player, "PLAYER NOT EXISTS")
    player.betChips = pack.roundBetChips
    player.seatChips = pack.leftChips
end

function RoomModel:processBetSuccess(pack)
    local player = self.playerList[pack.seatId]
    assert(player, "PLAYER NOT EXISTS")
    player.betState = pack.betState
    player.betNeedChips = pack.betChips - player.betChips -- 当前实际下注
    player.betChips = pack.betChips -- 总下注
    player.seatChips = player.seatChips - player.betNeedChips

    local betState = player.betState
    -- 大小盲
    if betState == consts.SVR_BET_STATE.SMALL_BLIND or betState == consts.SVR_BET_STATE.BIG_BLIND then
        if player.seatChips == 0 then
            if player.isSelf then
                self.isSelfAllIn_ = true
            end
            player.betState = consts.SVR_BET_STATE.ALL_IN    -- 显示ALLin状态
            player.statemachine:doEvent(SeatStateMachine.ALL_IN, player.betNeedChips)
        end
    -- 看牌
    elseif betState == consts.SVR_BET_STATE.CHECK then
        player.statemachine:doEvent(SeatStateMachine.CHECK)
    -- 弃牌
    elseif betState == consts.SVR_BET_STATE.FOLD then
        player.inGame = false
        player.inRound = false
        -- 自己弃牌
        if player.isSelf then
            self.canShowHandcard_ = true
            self.isSelfInGame_ = false
            self.isSelfInRound_ = false
        end
        player.statemachine:doEvent(SeatStateMachine.FOLD)
    -- 跟注
    elseif betState == consts.SVR_BET_STATE.CALL then
        if player.isSelf then
            self.gameInfo.hasRaise = false
        end
        player.statemachine:doEvent(SeatStateMachine.CALL, player.betNeedChips)
    -- 加注
    elseif betState == consts.SVR_BET_STATE.RAISE then
        if player.isSelf then
            self.gameInfo.hasRaise = false
        else
            self.gameInfo.hasRaise = true
        end
        player.statemachine:doEvent(SeatStateMachine.RAISE, player.betNeedChips)
    -- all in
    elseif betState == consts.SVR_BET_STATE.ALL_IN then
        -- 自己all in，需播放加注的声音
        if player.isSelf then
            self.isSelfAllIn_ = true
            self.gameInfo.hasRaise = false
        else
            if self:selfSeatData() and player.betChips > self:selfSeatData().betChips then
                self.gameInfo.hasRaise = true
            end
        end
        player.statemachine:doEvent(SeatStateMachine.ALL_IN, player.betNeedChips)
    end

    return pack.seatId
end

function RoomModel:processPot(pack)
    self.gameInfo.pots = pack.pots
    self.gameInfo.hasRaise = false
    for i = 0, 8 do
        local player = self.playerList[i]
        if player then
            if player.isSelf and self.isSelfInGame_ then
                self.selfTotalBet_ = self.selfTotalBet_ + player.betChips
            end
            player.betChips = 0
        end
    end
    -- 没发完公共牌导致的结算
    local player = nil
    local allInHandCards = pack.allInHandCards
    if #allInHandCards>0 then
        self.gameInfo.allAllIn = true
    end
    for k,v in pairs(allInHandCards) do
        player = self.playerList[v.seatId]
        if player then
            if not player.handCards then
                player.handCards = {0, 0, 0, 0}
            end
            player.inGameBeforeGameOver = true
            player.handCards[1] = v.handCard1 ~= 0 and v.handCard1 or player.handCards[1]
            player.handCards[2] = v.handCard2 ~= 0 and v.handCard2 or player.handCards[2]
            player.handCards[3] = v.handCard3 ~= 0 and v.handCard3 or player.handCards[3]
            player.handCards[4] = v.handCard4 ~= 0 and v.handCard4 or player.handCards[4]
            if not player.cardType or not player.cardType:getLabel() then
                player.cardType = CardType.new(v.cardType)
            end
        end
    end
end

function RoomModel:processFee(pack)
     local player = self.playerList[pack.seatId]
     if player then
        player.chips = pack.coins
        player.seatChips = pack.curCoins
    end
    return pack.seatId
end

function RoomModel:processDealPubCard(pack)
    if pack and pack.type then
        if pack.type==3 then
            self.gameInfo.pubCards = {}
            
            -- pack.pubCards = {0x2A,0x31,0x2B}-- 测试
        -- elseif pack.type==4 then
        --     pack.pubCards = {0x08}
        -- elseif pack.type==5 then
        --     pack.pubCards = {0x39}
        end
        if not self.gameInfo.pubCards then
            self.gameInfo.pubCards = {}
        end
        for k,v in ipairs(pack.pubCards) do
            table.insert(self.gameInfo.pubCards,v)
        end
    end

    for i = 0, 8 do
        local player = self.playerList[i]
        if player then
            player.statemachine:resetStateText()
        end
    end
end

function RoomModel:processTurnToBet(pack)
    local player = self.playerList[pack.seatId]
    self.gameInfo.bettingSeatId = pack.seatId
    self.gameInfo.callChips = pack.callChips
    self.gameInfo.minRaiseChips = pack.minRaiseChips
    -- if pack.callChips + self.roomInfo.blind < pack.maxRaiseChips then
    --     self.gameInfo.minRaiseChips = pack.callChips + self.roomInfo.blind
    -- else
    --     self.gameInfo.minRaiseChips = pack.minRaiseChips
    -- end
    -- self.gameInfo.minRaiseChips = pack.callChips + self.roomInfo.blind--pack.minRaiseChips
    self.gameInfo.maxRaiseChips = pack.maxRaiseChips
    player.statemachine:doEvent(SeatStateMachine.TURN_TO)
    return pack.seatId
end

function RoomModel:processSitDown(pack)
    local player = pack
    local prePlayer = self.playerList[player.seatId]
    local isAutoBuyin = false
    if prePlayer then
        if prePlayer.uid == player.uid then
            isAutoBuyin = true
        end
    end

    self:updateUserInfo(player)

    player.betChips = 0
    player.betState = consts.SVR_BET_STATE.WAITTING_START
    player.inGame = false
    player.inRound = false
    player.curChips = player.seatChips -- 当前筹码
    player.statemachine = SeatStateMachine.new(player, false)
    self.playerList[player.seatId] = player
    player.isSelf = self:isSelf(player.uid)
    -- 判断是否是自己
    if player.isSelf then
        self.selfSeatId_ = player.seatId
        player.img = tx.userData.s_picture
        player.giftId = tx.userData.user_gift
        sa.DataProxy:setData(tx.dataKeys.SIT_OR_STAND, self:isSelfInSeat())
    end
    return player.seatId, isAutoBuyin
end

function RoomModel:processStandUp(pack)
    local player = self.playerList[pack.seatId]
    if player and player.isSelf then
        self.gameInfo.handCards = nil
        self.isSelfAllIn_ = false
        self.canShowHandcard_ = false
        self.canShowHandcardButton_ = false
        self.isSelfInRound_ = false
        self.isSelfInGame_ = false
        self.isSelfPlayCurGame_ = false
        self.selfSeatId_ = -1
        sa.DataProxy:setData(tx.dataKeys.SIT_OR_STAND, self:isSelfInSeat())
    end
    player = nil
    self.playerList[pack.seatId] = nil
    return pack.seatId
end

function RoomModel:processGameOver(pack)
    self.gameInfo.gameStatus = consts.SVR_GAME_STATUS.READY_TO_START
    --把座位的经验和筹码变化值清零
    for i = 0, 8 do
        local player = self.playerList[i]
        if player then
            player.changeExp = 0        -- 经验变化
            player.changeChips = -1      -- 筹码变化  筹码堆收回来的钱 包括自己下的
            player.pretaxWinChips = -1  -- --真实赢钱 不扣税前 用牌局记录
            player.isPlayWinned = false  -- 是否已经播放过赢牌动画  只播放一次赢牌动画
            player.curChips = player.seatChips  -- 当前筹码
        end
    end
    local leftPlayer = 0
    for i, v in ipairs(pack.playerList) do
        local player = self.playerList[v.seatId]
        if player then
            player.changeExp = v.exp
            player.changeChips = v.changeChips
            player.pretaxWinChips = v.pretaxWinChips
            player.curChips = v.seatChips  -- 当前筹码
            player.isFold = v.status
            if not player.handCards then
                player.handCards = {0, 0, 0, 0}
            end
            player.handCards[1] = v.handCard1 ~= 0 and v.handCard1 or player.handCards[1]
            player.handCards[2] = v.handCard2 ~= 0 and v.handCard2 or player.handCards[2]
            player.handCards[3] = v.handCard3 ~= 0 and v.handCard3 or player.handCards[3]
            player.handCards[4] = v.handCard4 ~= 0 and v.handCard4 or player.handCards[4]
            if player.isFold==0 then  -- 没有弃牌
                leftPlayer = leftPlayer + 1
            end
            if not player.cardType or not player.cardType:getLabel() then
                player.cardType = CardType.new(v.cardType)
            end
            if player.isSelf then
                if player.isFold==1 then
                    self.canShowHandcard_ = true
                end
                self.statistics_.changeChips = self.statistics_.changeChips + player.pretaxWinChips
                self.statistics_.playNum = self.statistics_.playNum + 1
                if self.statistics_.maxWin<player.pretaxWinChips then
                    self.statistics_.maxWin=player.pretaxWinChips
                end
            elseif player.isFold==1 then  -- 别人弃牌了就不用展示了吧 亮牌的时候再传过来
                player.handCards[1] = 0
                player.handCards[2] = 0
                player.handCards[3] = 0
                player.handCards[4] = 0
            end
        end
    end

    self.gameInfo.splitPots = {}
    local isSelfWin = false
    for i, v in ipairs(pack.potsList) do

        local pot = {}
        self.gameInfo.splitPots[#self.gameInfo.splitPots + 1] = pot

        local potChips = v.potChips
        local winList = v.winList
        -- local perWinChips = math.floor(potChips/#winList)
        for kk,vv in ipairs(winList) do
            local subPot = {}
            subPot.winChips = vv.winChips
            subPot.seatId = vv.seatId
            subPot.uid = vv.uid
            subPot.potId = i
            local cardType = self.playerList[vv.seatId] and self.playerList[vv.seatId].cardType or 0
            subPot.cardType = CardType.new(cardType)
            subPot.handCards = {vv.card1, vv.card2, vv.card3, vv.card4, vv.card5}
            subPot.compareEnd = (leftPlayer>1)
            subPot.isReallyWin = false
            local player = self.playerList[vv.seatId]
            if player and player.pretaxWinChips>=0 and not player.isPlayWinned then  --pretaxWinChips=0就是多个人一样的大小的牌，均分，都是最大的
                player.isPlayWinned = true
                subPot.isReallyWin = true
                if vv.seatId == self.selfSeatId_ then
                    isSelfWin = true
                    -- 自己是否可以亮牌
                    if leftPlayer<=1 then
                        self.canShowHandcard_ = true
                        self.canShowHandcardButton_ = true
                    end
                end
            end
            table.insert(pot,subPot)
        end
    end
    -- 记录牌局
    -- 是否是奥马哈
    local has4Card = pack.playerList[1] and pack.playerList[1].handCard4
    self:recordGames(has4Card)
    -- 重置状态
    for i = 0, 8 do
        local player = self.playerList[i]
        if player then
            player.inGameBeforeGameOver = player.inGame
            player.inGame = false
            player.inRound = false
            player.statemachine:doEvent(SeatStateMachine.GAME_OVER)
        end
    end
end

function RoomModel:processSendChipSuccess(pack,toTable)
    local fromPlayer = self.playerList[pack.from]
    local toPlayer = self.playerList[pack.to]
    local chips = pack.chips
    if fromPlayer then
        if toTable==true then
            fromPlayer.seatChips = fromPlayer.seatChips - chips

        else
            fromPlayer.money = fromPlayer.money - chips
        end
    end
    if toPlayer then
        if toTable==true then
            toPlayer.seatChips = toPlayer.seatChips + chips
        else
            toPlayer.money = toPlayer.money + chips
        end
    end
end

function RoomModel:processSetGift(pack)
    -- 设置礼物
    local uidToSet = pack.id
    local giftId = pack.gid
    local seatIdToSet = self:getSeatIdByUid(uidToSet)
    if seatIdToSet ~= -1 then
        self.playerList[seatIdToSet].giftId = giftId
    end
    pack.seatId = seatIdToSet
end

function RoomModel:processSendPresentGift(pack)
    -- 赠送礼物
    local fromUid = pack.id
    local fromSeatId = self:getSeatIdByUid(fromUid)
    local giftId = pack.gid
    local toUidArr = string.split(pack.toids, ",")
    local toSeatIdArr = {}
    if toUidArr and #toUidArr > 0 then
        for _, toUid in ipairs(toUidArr) do
            toUidArr[_] = tonumber(toUid) --字符串...
            local toSeatId = self:getSeatIdByUid(tonumber(toUid))
            if toSeatId ~= -1 then
                self.playerList[toSeatId].giftId = giftId
                table.insert(toSeatIdArr,toSeatId)
            end
            if tonumber(toUid)==tx.userData.uid then
                tx.userData.user_gift = giftId
            end
        end
    end
    pack.fromSeatId=fromSeatId
    pack.toSeatIdArr=toSeatIdArr
    pack.toUidArr=toUidArr
end

function RoomModel:reset()
    if self.gameInfo then
        self.gameInfo.allAllIn = false
    end
    -- 清空玩家上一局的牌
    local playerList = self.playerList or {}
    for k,player in pairs(playerList) do
        player.handCards = {0,0,0,0}
    end
    self.isSelfAllIn_ = false
    self.canShowHandcard_ = false
    self.canShowHandcardButton_ = false
    self.isSelfInRound_ = false
    self.isSelfInGame_ = false
    self.isSelfPlayCurGame_ = false

    self.selfTotalBet_ = 0
end

function RoomModel:updateUserInfo(player)
    local info = player.info
    info = json.decode(info)
    if info then
        player.nick = info.nick
        player.img = info.img
        player.sex = info.sex
        player.money = info.money or 0
        player.giftId = info.giftId or 0
        player.vip = info.vip or 0
    end
end

function RoomModel:svrModifyUserinfo(pack)
    local uid = pack.uid
    local info = json.decode(pack.info)
    local seatId = self:getSeatIdByUid(uid)
    if seatId < 0 then
        return seatId
    end
    local player = self.playerList[seatId]
    if info then
        player.info = pack.info
        if info.giftId then
            player.giftId = info.giftId
        end
        if info.nick then
            player.nick = info.nick
            if player.statemachine then
                player.statemachine:setDefaultString(player.nick)
            end
        end
        if info.img then
            player.img = info.img
        end
        if info.vip then
            player.vip = info.vip
        end
    end
    return seatId
end

-- 记录牌局
function RoomModel:recordGames(has4Card)
    -- 公共牌
    local base = 0
    if self.roomInfo and self.roomInfo.blind then
        base = self.roomInfo.blind
    end
    local pubCard = ""
    if self.gameInfo and self.gameInfo.pubCards then
        local card = nil
        for k,v in ipairs(self.gameInfo.pubCards) do
            card = v
            if card<10 then
                card = "0"..card
            end
            pubCard = pubCard..card
        end
    end
    local list = {}
    for i = 0, 8 do
        local player = self.playerList[i]
        if player and player.betState ~= consts.SVR_BET_STATE.WAITTING_START then
            local item = {}
            item.hh_base = base
            if player.betState==consts.SVR_BET_STATE.FOLD then
                item.hh_commoncards = ""
            else
                item.hh_commoncards = pubCard
            end
            item.hh_endtime = os.time()
            -- item.hh_seatid = player
            local card1 = player.handCards[1] or 0
            if card1<10 then
                card1 = "0"..card1
            end
            local card2 = player.handCards[2] or 0
            if card2<10 then
                card2 = "0"..card2
            end
            local card3 = player.handCards[3] or 0
            if card3<10 then
                card3 = "0"..card3
            end
            local card4 = player.handCards[4] or 0
            if card4<10 then
                card4 = "0"..card4
            end
            if has4Card then
                item.hh_twohandcards = string.format("%s,%s,%s,%s",card1,card2,card3,card4)
            else
                item.hh_twohandcards = string.format("%s,%s",card1,card2)
            end
            item.hh_uid = player.uid
            item.hh_wincoins = player.pretaxWinChips or 0
            item.nick = player.nick or ""
            item.seatid = player.seatId or 0
            table.insert(list,item)
        end
    end
    if #list>0 then
        if not _G.LocalGameRecord then
            _G.LocalGameRecord = {}
        end
        table.insert(_G.LocalGameRecord,1,list) -- 加入到最前一个
        -- 最多存储20条
        if #_G.LocalGameRecord>20 then
            while(true) do
                table.remove(_G.LocalGameRecord,#_G.LocalGameRecord)
                if #_G.LocalGameRecord<=20 then
                    break;
                end
            end
        end
    end
end

return RoomModel
