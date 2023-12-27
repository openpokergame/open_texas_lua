local ChipManager = class("ChipManager")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ChipData = import(".model.ChipData")
local BetChipView = import(".views.BetChipView")
local PotChipView = import(".views.PotChipView")
local RoomViewPosition = import(".views.RoomViewPosition")
local BP = RoomViewPosition.BetPosition
local PP = RoomViewPosition.PotPosition
local logger = sa.Logger.new("ChipManager")

local BET_LABEL_OFFX = 8

function ChipManager:ctor()
    BP = RoomViewPosition.BetPosition
    PP = RoomViewPosition.PotPosition
end

function ChipManager:createNodes()
    self.chipsBgWidth_,self.chipsBgHeight_ = 80, 34
    -- 文字背景层，不移动，根据positionId确定位置
    self.textBgBatchNode_ = display.newNode()
        :addTo(self.scene.nodes.chipNode)
    self.betChipTextBgs_ = {}
    for i = 1, 9 do
        self.betChipTextBgs_[i] = display.newScale9Sprite("#texas/room/room_chip_text_bg.png",0,0,cc.size(self.chipsBgWidth_, self.chipsBgHeight_))
            :addTo(self.textBgBatchNode_)
            :pos(BP[i].x, BP[i].y)
            :hide()
    end
    self.potChipTextBgs_ = {}
    for i = 1, 9 do
        self.potChipTextBgs_[i] = display.newScale9Sprite("#texas/room/room_chip_text_bg.png",0,0,cc.size(self.chipsBgWidth_, self.chipsBgHeight_))
            :addTo(self.textBgBatchNode_)
            :pos(PP[i].x, PP[i].y)
            :hide()
    end

    -- 文字标签层，不移动，根据positionId或者potId确定位置
    self.betChipTextLabels_ = {}
    for i = 1, 9 do
        -- self.betChipTextLabels_[i] = ui.newTTFLabel({text = "999.9M", size = 20, align = ui.TEXT_ALIGN_CENTER, color = cc.c3b(255, 204, 0)})
        self.betChipTextLabels_[i] = display.newBMFontLabel({text = "0", font = "fonts/room_seat_money.fnt"})
            :addTo(self.betChipTextBgs_[i])
            :pos(self.chipsBgWidth_*0.5, 5)
    end
    self.potChipTextLabels_ = {}
    for i = 1, 9 do
        -- self.potChipTextLabels_[i] = ui.newTTFLabel({text = "999.9M", size = 20, align = ui.TEXT_ALIGN_CENTER, color = cc.c3b(255, 204, 0)})
        self.potChipTextLabels_[i] = display.newBMFontLabel({text = "0", font = "fonts/room_seat_money.fnt"})
            :addTo(self.potChipTextBgs_[i])
            :pos(self.chipsBgWidth_*0.5, 5)
    end

    -- 筹码对象池
    local function funcFactory(filename, oddOrEven, key)
        return function()
            return ChipData.new(filename, oddOrEven, key)
        end
    end
    self.chipPool_ = {}
    self.chipPool_.odd = {}
    self.chipPool_.odd[1] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_odd_1.png", "odd", 1), true, 10, 15, true)
    self.chipPool_.odd[2] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_odd_2.png", "odd", 2), true, 10, 15, true)
    self.chipPool_.odd[5] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_odd_5.png", "odd", 5), true, 10, 15, true)
    self.chipPool_.even = {}
    self.chipPool_.even[1] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_even_1.png", "even", 1), true, 10, 15, true)
    self.chipPool_.even[2] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_even_2.png", "even", 2), true, 10, 15, true)
    self.chipPool_.even[5] = sa.ObjectPool.new(funcFactory("#texas/room/room_chip_even_5.png", "even", 5), true, 10, 15, true)

    -- 筹码容器
    self.chipBatchNode_ = display.newNode()
        :addTo(self.scene.nodes.chipNode)
    -- 下注筹码试图，key由seatId确定
    self.betChipViews_ = {}
    for i = 0, 8 do
        self.betChipViews_[i] = BetChipView.new(self.chipBatchNode_, self, i)
    end
    -- 下注筹码试图，key由potId确定
    self.potChipViews_ = {}
    for i = 1, 9 do
        self.potChipViews_[i] = PotChipView.new(self.chipBatchNode_, self, i)
    end
    -- 分筹码动画  一起分的时候
    self.splitChipViews_ = {}
    for i=0, 8 do
        self.splitChipViews_[i] = PotChipView.new(self.chipBatchNode_, self, i)
    end
end

-- 登录成功，设置登录筹码堆
function ChipManager:setLoginChipStacks()
    local gameInfo = self.model.gameInfo
    local playerList = self.model.playerList

    -- 奖池筹码堆
    for potId, potChips in ipairs(gameInfo.pots) do
        self.potChipViews_[potId]:resetChipStack(potChips)
        self:modifyPotText(potChips, potId)
    end

    -- 下注筹码堆
    for i = 0, 8 do
        if playerList[i] then
            local betTotalChips = playerList[i].betChips
            local seatId        = playerList[i].seatId
            local positionId    = self.seatManager:getSeatPositionId(seatId)
            self.betChipViews_[seatId]:resetChipStack(betTotalChips)
            self:modifyBetText(betTotalChips, positionId)
        end
    end
end

-- 坐下动画，移动筹码堆
function ChipManager:moveChipStack()
    for i = 0, 8 do
        local positionId = self.seatManager:getSeatPositionId(i)
        self.betChipViews_[i]:rotate(positionId)
        self:modifyBetText(self.betChipViews_[i]:getBetTotalChips(), positionId)
    end
end

-- 筹码下注动画
function ChipManager:betChip(player)
    local betNeedChips  = player.betNeedChips
    local betTotalChips = player.betChips
    local seatId        = player.seatId
    local positionId    = self.seatManager:getSeatPositionId(seatId)

    -- 播放下注动画
    self.betChipViews_[seatId]:moveFromSeat(betNeedChips, betTotalChips)
    if betTotalChips > 0 then
        self:modifyBetText(betTotalChips, positionId)
    end
end

-- 设置下注筹码数字
function ChipManager:modifyBetText(chips, positionId)
    if chips > 0 then
        -- chips = 555555
        local curBgs,curLabel = self.betChipTextBgs_[positionId],self.betChipTextLabels_[positionId]
        curBgs:show()
        curLabel:show():setString(sa.formatBigNumber(chips))
        -- 调整大小
        local size = curLabel:getContentSize()
        size.width = size.width + BET_LABEL_OFFX*2 + 15
        if size.width<self.chipsBgWidth_ then
            size.width = self.chipsBgWidth_
        end
        curBgs:setContentSize(cc.size(size.width,self.chipsBgHeight_))
        local offSetX = (size.width - self.chipsBgWidth_)*0.5

        if positionId~=2 and positionId~=3 then
            curLabel:setPositionX(size.width*0.5 + BET_LABEL_OFFX)
            -- 调整
            local tempCoord = BP[positionId]
            if positionId==5 then
                if self.model and self.model:isSelfInSeat() then
                    tempCoord = BP[10]
                end
            end
            if tempCoord then
                curBgs:pos(tempCoord.x + offSetX,tempCoord.y)
            end
        else
            curLabel:setPositionX(size.width*0.5 - BET_LABEL_OFFX)
            -- 调整
            curBgs:pos(BP[positionId].x - offSetX,BP[positionId].y)
        end
    else
        self.betChipTextBgs_[positionId]:hide()
        self.betChipTextLabels_[positionId]:hide()
    end
end

-- 合奖池动画
function ChipManager:gatherPot()
    -- 设置需要移至奖池区的筹码数据
    for i = 0, 8 do
        self.betChipViews_[i]:setPotChipData()
    end

    if self.gatherPotScheduleHandle_ then
        scheduler.unscheduleGlobal(self.gatherPotScheduleHandle_)
    end

    -- 前注奖池包，多延迟1秒合奖池
    local delayTime = BetChipView.MOVE_FROM_SEAT_DURATION + 0.3
    self.gatherPotScheduleHandle_ = scheduler.performWithDelayGlobal(
        handler(self, self.gatherPotDelayCallback_), 
        delayTime
    )
end

function ChipManager:gatherPotDelayCallback_()
    for seatId = 0, 8 do
        self.betChipViews_[seatId]:moveToPot()
        self:modifyBetText(self.betChipViews_[seatId]:getBetTotalChips(), self.seatManager:getSeatPositionId(seatId))
    end
    self.createPotScheduleHandle_ = scheduler.performWithDelayGlobal(
        handler(self, self.createPotDelayCallback_), 
        BetChipView.MOVE_TO_POT_DURATION
    )
end

function ChipManager:createPotDelayCallback_()
    for potId, potChips in ipairs(self.model.gameInfo.pots) do
        self.potChipViews_[potId]:resetChipStack(potChips)
        self:modifyPotText(potChips, potId)
    end
end

-- 设置奖池筹码数字
function ChipManager:modifyPotText(chips, potId)
    if chips > 0 then
        -- chips = 555555
        self.potChipTextBgs_[potId]:show()
        self.potChipTextLabels_[potId]:show():setString(sa.formatBigNumber(chips))
        local size = self.potChipTextLabels_[potId]:getContentSize()
        size.width = size.width + 15
        if size.width<self.chipsBgWidth_ then
            size.width = self.chipsBgWidth_
        end
        self.potChipTextBgs_[potId]:setContentSize(cc.size(size.width,self.chipsBgHeight_))
        self.potChipTextLabels_[potId]:setPositionX(size.width*0.5)
    else
        self.potChipTextBgs_[potId]:hide()
        self.potChipTextLabels_[potId]:hide()
    end
end

-- 分奖池
function ChipManager:splitPots(potsData)
    if potsData then
        -- 获取奖池数量
        self.potsNum_ = 1
        if #potsData > 0 then
            self:startSplit()
            -- if potsData[1].cardType:getCardTypeValue() >= 4 and not self.model:canShowHandcard() then
            --     tx.SoundManager:playSound(tx.SoundManager.APPLAUSE)
            -- end
        end
        if #potsData > 1 then
            self.splitPotsScheduleHandle_ = scheduler.scheduleGlobal(handler(self, self.startSplit), 3)
        end
    end
end

-- 分奖池动画
function ChipManager:startSplit()
    local potsData = self.model.gameInfo.splitPots
    if potsData[self.potsNum_] then
        self.seatManager:clearWinStatus()  --清楚前一堆的
        local outPot = potsData[self.potsNum_]
        for kk,pot in ipairs(outPot) do
            local seatId = pot.seatId
            local winChips = pot.winChips
            local fee = pot.fee or 0
            local positionId = self.seatManager:getSeatPositionId(seatId)
            --桌子播放赢牌动画
            if pot.isReallyWin then
                local player = self.model.playerList[seatId]
                if player and player.handCards and player.cardType then
                    local cardType_ = player.cardType:getCardTypeValue()
                    if cardType_ <= consts.CARD_TYPE.THREE_KIND then  -- 他人的不播
                        -- tx.SoundManager:playSound(tx.SoundManager.WINNER1)
                    elseif cardType_ <= consts.CARD_TYPE.FULL_HOUSE then
                        tx.SoundManager:playSound(tx.SoundManager.WINNER2)
                    else
                        tx.SoundManager:playSound(tx.SoundManager.WINNER3)
                    end
                    self.seatManager:playSeatWinAnimation(seatId, cardType_, player.cardType:getLabel(),pot)
                end
            else  -- 已经播放过一次了 只显示牌型
                local player = self.model.playerList[seatId]
                local seatView = self.seatManager:getSeatView(seatId)
                if player and player.isPlayWinned and seatView and player.handCards and player.cardType then
                    seatView:onlyShowBigCards(pot)
                end
            end
            if #outPot==1 then  -- 只有一个 直接回收桌面的
                self.potChipViews_[self.potsNum_]:moveToSeat(positionId, function(localPotChips) 
                        local player = self.model.playerList[seatId]
                        if player then
                            player.betChips = 0
                            player.seatChips = player.curChips
                            self.seatManager:updateSeatState(seatId)
                        end
                    end)
            else    -- 多个再创建
                self.potChipViews_[self.potsNum_]:moveToSeatComplete_("clear")
                local temp = self.splitChipViews_[seatId]
                temp:resetPotId(self.potsNum_)
                temp:resetChipStack(winChips)
                temp:moveToSeat(positionId, function(localPotChips) 
                        local player = self.model.playerList[seatId]
                        if player then
                            player.betChips = 0
                            player.seatChips = player.curChips
                            self.seatManager:updateSeatState(seatId)
                        end
                    end)
            end
            -- 修改奖池筹码数字
            self:modifyPotText(0, self.potsNum_)
            
            -- 播放筹码声音
            tx.SoundManager:playSound(tx.SoundManager.MOVE_CHIP)
            -- 如果是自己，播放赢牌动画
            if self.model:selfSeatId() == seatId and pot.isReallyWin then
                local player = self.model:selfSeatData()
                if player and player.handCards and player.cardType then
                    local cardType_ = player.cardType:getCardTypeValue()
                    self.animManager:playYouWinAnim(cardType_,player.changeChips)
                    if cardType_ <= consts.CARD_TYPE.THREE_KIND then
                        tx.SoundManager:playSound(tx.SoundManager.WINNER1)
                    elseif cardType_ <= consts.CARD_TYPE.FULL_HOUSE then
                        tx.SoundManager:playSound(tx.SoundManager.WINNER2)
                    else
                        tx.SoundManager:playSound(tx.SoundManager.WINNER3)
                    end
                end

                self:reportDailyTask_(player)
                if _G.curInGameId == 1 and self.ctx.roomController.showGuidePopup then --只在德州场引导
                    self.ctx.roomController:showGuidePopup()
                end
            end
        end
    end

    -- 判断奖池是否分发完毕
    if self.potsNum_ == #potsData and self.splitPotsScheduleHandle_ then
        scheduler.unscheduleGlobal(self.splitPotsScheduleHandle_)
    else
        self.potsNum_ = self.potsNum_ + 1
    end
end

function ChipManager:reportDailyTask_(player)
    if self.model:isSelfAllIn() then
        sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.REPORT_USER_ALLIN, data = {iswin = 1}})
    end

    if player and player.handCards and player.cardType then
        local cardType_ = player.cardType:getCardTypeValue()
        if cardType_ >= consts.CARD_TYPE.STRAIGHT then
           sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.REPORT_WIN_GOODCARD, data = {cardType = cardType_}})
        end
    end
end

-- 从对象池获取筹码数据
function ChipManager:getChipData(chips,isBetChip)
    local numStr = tostring(chips)
    local strLen = string.len(numStr)
    local chipDataArr = {}
    for i = strLen, 1, -1 do
        local oddOrEven
        local value
        if (strLen - i + 1) % 2 == 0 then
            oddOrEven = "even"
        else
            oddOrEven = "odd"
        end
        value = string.sub(numStr, i, i) + 0
        if value > 5 then
            table.insert(chipDataArr, self.chipPool_[oddOrEven][5]:retrive())
            value = value - 5
        end
        while value >= 2 do
            table.insert(chipDataArr, self.chipPool_[oddOrEven][2]:retrive())
            value = value - 2
        end
        if value == 1 then
            table.insert(chipDataArr, self.chipPool_[oddOrEven][1]:retrive())
        end
    end
    return chipDataArr
end

-- 回收筹码数据
function ChipManager:recycleChipData(chipDataArr)
    if chipDataArr then
        for _, chipData in pairs(chipDataArr) do
            chipData:getSprite():opacity(255):removeFromParent()
            self.chipPool_[chipData:getOddOrEven()][chipData:getKey()]:recycle(chipData)
        end
    end
end

-- 重置筹码视图
function ChipManager:reset()
    -- 重置定时器
    if self.gatherPotScheduleHandle_ then
        scheduler.unscheduleGlobal(self.gatherPotScheduleHandle_)
    end
    if self.createPotScheduleHandle_ then
        scheduler.unscheduleGlobal(self.createPotScheduleHandle_)
    end
    if self.splitPotsScheduleHandle_ then
        scheduler.unscheduleGlobal(self.splitPotsScheduleHandle_)
    end

    -- 重置筹码堆
    for _, v in pairs(self.betChipViews_) do
        v:reset()
    end
    for _, v in pairs(self.potChipViews_) do
        v:reset()
    end
    for _, v in pairs(self.splitChipViews_) do
        v:reset()
    end

    -- 隐藏文字显示区
    for i = 1, 9 do
        self.betChipTextBgs_[i]:hide()
        self.potChipTextBgs_[i]:hide()
        self.betChipTextLabels_[i]:hide()
        self.potChipTextLabels_[i]:hide()
    end
end

-- 清理
function ChipManager:dispose()
    -- 重置定时器
    if self.gatherPotScheduleHandle_ then
        scheduler.unscheduleGlobal(self.gatherPotScheduleHandle_)
    end
    if self.createPotScheduleHandle_ then
        scheduler.unscheduleGlobal(self.createPotScheduleHandle_)
    end
    if self.splitPotsScheduleHandle_ then
        scheduler.unscheduleGlobal(self.splitPotsScheduleHandle_)
    end

    -- 释放下注和奖池筹码视图
    for _, v in pairs(self.betChipViews_) do
        v:dispose()
    end
    for _, v in pairs(self.potChipViews_) do
        v:dispose()
    end
    for _, v in pairs(self.splitChipViews_) do
        v:dispose()
    end

    -- 释放对象池
    for _, v in pairs(self.chipPool_.odd) do
        v:dispose()
    end
    for _, v in pairs(self.chipPool_.even) do
        v:dispose()
    end
end

return ChipManager
