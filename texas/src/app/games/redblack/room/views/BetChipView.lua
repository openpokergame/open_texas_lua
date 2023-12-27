-- 下注筹码显示视图
local BetChipView = class("BetChipView")
local P = import(".RoomViewPosition")

local DealCardPosition = P.DealCardPosition
local MOVE_FROM_SEAT_DURATION = 0.2
local MOVE_FROM_DEALER_DURATION = 0.5
local MOVE_TO_DEALER_DURATION = 0.5
local MOVE_DELAY_TIME = 0.01
local CHIP_WIDTH = 62

function BetChipView:ctor(parent, manager, typeId)
    self.isSelfWin_ = false
    self.parent_ = parent --父节点
    self.manager_ = manager --筹码管理器
    self.chips_ = 0 --筹码数量
    self.areaData = {} --押注区域
    self.potData_ = {} --筹码堆数据
    self.areaData.p = P.BetTypePosition[typeId]
    self.areaData.w = P.BetTypeArea[typeId].width
    self.areaData.h = P.BetTypeArea[typeId].height
end

--生成筹码位置
function BetChipView:generateChipPos()
    local x = self.areaData.p.x
    local y = self.areaData.p.y
    local w = self.areaData.w - CHIP_WIDTH
    local h = self.areaData.h - CHIP_WIDTH
    local r1 = (math.random() + math.random() + math.random())/3
    local r2 = (math.random() + math.random() + math.random())/3

    return cc.p(x + (r1 - 0.5) * w, y + (r2 - 0.5) * h)
end

--用户下注
function BetChipView:userBet(seatId,chips,callback)
    self.chips_ = self.chips_ + chips
    local position = P.SeatPosition[seatId]
    local chipsData = self.manager_:getChipData(chips)
    if chipsData then
        local chipNum = #chipsData
        for i,chipData in ipairs(chipsData) do
            local sp = chipData:getSprite()
            sp:pos(position.x, position.y):addTo(self.parent_)
            sp:setRotation(math.random(1,360))
            local p = self:generateChipPos()
            table.insert(self.potData_,chipData)
            if i > 1 then
                transition.execute(
                    sp, 
                    cc.Spawn:create(cc.EaseSineIn:create(
                        cc.MoveTo:create(MOVE_FROM_SEAT_DURATION, cc.p(p.x, p.y))),
                        cc.RotateBy:create(MOVE_FROM_SEAT_DURATION + 0.1, math.random(1,90))
                    ),
                    {delay = i * MOVE_DELAY_TIME / chipNum}
                )
            else
                transition.execute(
                    sp, 
                    cc.Spawn:create(cc.EaseSineIn:create(
                        cc.MoveTo:create(MOVE_FROM_SEAT_DURATION,  cc.p(p.x, p.y))),
                        cc.RotateBy:create(MOVE_FROM_SEAT_DURATION  + 0.1, math.random(1,90))
                    ),
                    {delay = MOVE_DELAY_TIME, onComplete = function()
                        if callback then
                            callback()
                        end
                    end}
                )
            end
        end
    end
end

--登录成功时候调用，显示当前筹码下注状态
function BetChipView:showChips(winChips)
    local chipsData = self.manager_:getChipData(winChips - self.chips_)
    if chipsData then
        for i,chipData in ipairs(chipsData) do
            table.insert(self.potData_,chipData)
            local sp = chipData:getSprite()
            local p = self:generateChipPos()
            sp:pos(p.x,p.y):addTo(self.parent_)
            sp:setRotation(math.random(1,360))
        end
    end
end

--显示胜利结果
function BetChipView:showWinResult(data, winner)
    if winner == 3 then --平局不移动
        self:showWinResult_(data.winSeats)
    else
        self:moveFromDealer(data.winChips - self.chips_, winner, function()
            self:showWinResult_(data.winSeats)
        end)
    end
end

function BetChipView:showWinResult_(data)
    for i,v in pairs(data) do
        if v.chips ~= 0 then
            self:showWinChips(v.seatId,v.chips,v.uid)
        end
    end
    self:reset()
end

--压中的筹码移到对应的座位上
function BetChipView:showWinChips(seatId,chip,uid)
    local positionId = self.manager_.ctx.seatManager:getPosition(seatId, uid)
    local position = P.SeatPosition[positionId]
    local chipsData = self.manager_:getChipData(chip)
    if chipsData then
        if not self.isSelfWin_ then
            tx.SoundManager:playSound(tx.SoundManager.REDBLACK_CHIPMOVE)
        else
            tx.SoundManager:playSound(tx.SoundManager.REDBLACK_SELF_CHIPMOVE)
        end

        for i,chipData in ipairs(chipsData) do
            local sp = chipData:getSprite()
            local p = self:generateChipPos()
            sp:pos(p.x, p.y):opacity(255):addTo(self.parent_)
            transition.execute(
                sp, 
                cc.MoveTo:create(0.8, position), 
                {delay = 0.05,onComplete = function ()
                    self.manager_:recycleChip(chipData)
                end}
            )
        end
    end
end

--胜利一方收筹码动画
function BetChipView:moveToDealer(winner)
    if winner == 3 then --平局不移动
        return
    end

    local chipNum = #self.potData_
    if chipNum > 0 then
        if not self.isSelfWin_ then
            tx.SoundManager:playSound(tx.SoundManager.REDBLACK_CHIPMOVE)
        end

        for i,chipData in pairs(self.potData_) do
            local sp = chipData:getSprite()
            if i > 1 then
                transition.execute(
                    sp, 
                    cc.MoveTo:create(MOVE_TO_DEALER_DURATION, DealCardPosition[winner]),
                    {delay = i * MOVE_DELAY_TIME / chipNum}
                )
            else
                transition.execute(
                    sp, 
                    cc.MoveTo:create(MOVE_TO_DEALER_DURATION, DealCardPosition[winner]),
                    {delay = MOVE_DELAY_TIME,onComplete = function ()
                        self:reset()
                    end}
                )
            end
        end
    end
    
end

--收完筹码后，放出支付的筹码动画
function BetChipView:moveFromDealer(winChips, winner, callback)
    if winner == 3 then --平局不移动
        return
    end

    local position = DealCardPosition[winner]
    local chipsData = self.manager_:getChipData(winChips)
    if chipsData then
        local chipNum = #chipsData
        for i,chipData in ipairs(chipsData) do
            local sp = chipData:getSprite()
            sp:pos(position.x, position.y):addTo(self.parent_)
            sp:setRotation(math.random(1,360))
            local p = self:generateChipPos()
            table.insert(self.potData_, chipData)
            if i > 1 then
                transition.execute(
                    sp, 
                    cc.EaseSineOut:create(cc.MoveTo:create(MOVE_FROM_DEALER_DURATION, cc.p(p.x, p.y))),
                    {delay = i * MOVE_DELAY_TIME / chipNum}
                )
            else
                transition.execute(
                    sp, 
                    cc.EaseSineOut:create(cc.MoveTo:create(MOVE_FROM_DEALER_DURATION, cc.p(p.x, p.y))),
                    {delay = MOVE_DELAY_TIME, onComplete = function()
                        if callback then
                            callback()
                        end
                    end}
                )
            end
        end
    end
end

function BetChipView:setIsSelfWin(isSelfWin)
    self.isSelfWin_ = isSelfWin
end

--重置
function BetChipView:reset()
    if self.potData_ then
        self.manager_:recycleChipData(self.potData_)
    end

    self.potData_ = {}
    self.chips_ = 0
    self.isSelfWin_ = false
end

-- 清理
function BetChipView:dispose()
    self:reset()
end

return BetChipView