local ChipManager = class("ChipManager")
local BetChipView = import(".views.BetChipView")
local BetChipData = import(".views.BetChipData")
local AddChipView = import(".views.AddChipView")
local P = import(".views.RoomViewPosition")
local CHIP_IMG = {
    "#redblack/room/redblack_bet_small_chip_1.png",
    "#redblack/room/redblack_bet_small_chip_2.png",
    "#redblack/room/redblack_bet_small_chip_3.png",
    "#redblack/room/redblack_bet_small_chip_4.png",
    "#redblack/room/redblack_bet_small_chip_5.png",
    "#redblack/room/redblack_bet_small_chip_6.png",
    "#redblack/room/redblack_bet_small_chip_7.png",
    "#redblack/room/redblack_bet_small_chip_8.png",
    "#redblack/room/redblack_bet_small_chip_9.png",
    "#redblack/room/redblack_bet_small_chip_10.png",
    "#redblack/room/redblack_bet_small_chip_11.png",
    "#redblack/room/redblack_bet_small_chip_12.png",
    "#redblack/room/redblack_bet_small_chip_13.png",
    "#redblack/room/redblack_bet_small_chip_14.png",
}
local CHIP_VALUE = {100, 500, 5000, 20000, 50000, 100000, 200000, 250000, 500000, 1000000, 2000000, 5000000, 10000000, 20000000}

local BET_VIEW_NUM = 13 --下注视图数量

function ChipManager:ctor()
end

function ChipManager:createNodes()
    self.chipNode_ = display.newNode():addTo(self.scene.nodes.chipNode)
    local function funcFactory(filename, index)
        return function()
            return BetChipData.new(filename, index)
        end
    end

    self.chipPool_ = {}
    for i = 1, #CHIP_IMG do
        self.chipPool_[i] = sa.ObjectPool.new(funcFactory(CHIP_IMG[i], i), true, 10, 15, true)
    end

    self.betChipViews_ = {}
    for i = 1, BET_VIEW_NUM do
        self.betChipViews_[i] = BetChipView.new(self.chipNode_, self, i)
    end
end

--其他玩家的人下注
function ChipManager:betChipOther(uid, betType, betChips,callback)
    local seatId = self.ctx.model:getSeatIdByUid(uid)
    local position = self.seatManager:getPosition(seatId,uid)
    self.betChipViews_[betType]:userBet(position,betChips,callback)
    self:playBetAvatarAnimation_(position)
    tx.SoundManager:playSound(tx.SoundManager.REDBLACK_BET)
end

--播放
function ChipManager:playBetAvatarAnimation_(position)
    if position == 10 then
        self.ctx.scene:playBetAvatarAnimation()
    else
        self.ctx.seatManager:playBetAvatarAnimation(position)
    end
end

--自己下注
function ChipManager:betChipSelf(betType,betChips,callback)
    self.betChipViews_[betType]:userBet(9,betChips,callback)
    self.ctx.oprManager:playBetAvatarAnimation()
    tx.SoundManager:playSound(tx.SoundManager.REDBLACK_BET)
end

--更新所有筹码
function ChipManager:updateAllChips(data)
    if data then
        for i,v in pairs(data) do
            self.betChipViews_[v.betType]:showChips(v.betChips)
        end
    end
end

--显示胜利结果，筹码移动到胜利一方
function ChipManager:showWinResult(data, winner)
    local isSelfWin = self.ctx.model:isSelfWin()
    if isSelfWin then
        tx.SoundManager:playSound(tx.SoundManager.REDBLACK_SELF_WIN)
    end

    for i = 1, BET_VIEW_NUM do
        local lose = true
        self.betChipViews_[i]:setIsSelfWin(isSelfWin)
        for k,v in pairs(data) do
            if i == v.winType then
                lose = false
                break
            end
        end

        if lose then
            self.betChipViews_[i]:moveToDealer(winner)
        end
    end

    self.gameSchedulerPool:delayCall(function()
        for i,v in pairs(data) do
            self.betChipViews_[v.winType]:showWinResult(v, winner)
        end
    end, 1.2)
end

--根据下注数值，创建对应数值的不同类型的筹码1600=3*500+100
function ChipManager:getChipData(chips)
    local chipDataArr = {}
    local num = chips
    local keys = {}
    local count = #CHIP_VALUE
    for i = count,1,-1 do
        local k = CHIP_VALUE[i]
        if num >= k then
            local t = math.floor(num / k)
            for m = 1,t do
                table.insert(chipDataArr,self.chipPool_[i]:retrive())
                num = num - k
                if #chipDataArr > 200 then
                    break
                end
            end
        end

        if #chipDataArr > 200 then
            num = 0
            break
        end
    end

    if num > 0 then
        table.insert(chipDataArr,self.chipPool_[1]:retrive())
    end

    return chipDataArr
end

function ChipManager:showAddChipView(seatId, betResult, uid)
    local winChips = 0
    for _, v in ipairs(betResult) do
        winChips = winChips + v.winChips
    end

    if winChips > 0 then
        local positionId = self.ctx.seatManager:getPosition(seatId, uid)
        local position = P.SeatPosition[positionId]
        AddChipView.new(winChips):pos(position.x, position.y):addTo(self.chipNode_)
    end

    return winChips
end

--回收一组筹码
function ChipManager:recycleChipData(chipDataArr)
    if chipDataArr then
        for _,chipData in pairs(chipDataArr) do
            self:recycleChip(chipData)
        end
    end
end
        
--回收单个筹码
function ChipManager:recycleChip(chipData)
    chipData:getSprite():opacity(255):removeFromParent()
    self.chipPool_[chipData:getIndex()]:recycle(chipData)
end

function ChipManager:reset()
    for _, v in pairs(self.betChipViews_) do
        v:reset()
    end
end

function ChipManager:dispose()
    for _, v in pairs(self.betChipViews_) do
        v:dispose()
    end
    for _, v in pairs(self.chipPool_) do
        v:dispose()
    end
end

return ChipManager
