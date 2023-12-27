local PotChipView = class("PotChipView")

local RoomViewPosition = import(".RoomViewPosition")
local SP = RoomViewPosition.SeatPosition
local PP = RoomViewPosition.PotPosition
-- local MOVE_TO_SEAT_DURATION = 0.5
-- local MOVE_DELAY_DURATION = 0.075
-- BetChipView.MOVE_FROM_SEAT_DURATION = 0.1
-- BetChipView.MOVE_TO_POT_DURATION = 0.2
-- BetChipView.MOVE_DELAY_DURATION = 0.01
local MOVE_TO_SEAT_DURATION = 0.2
local MOVE_DELAY_DURATION = 0.01
local GAP_WITH_CHIPS = 4
local logger = sa.Logger.new("PotChipView")
PotChipView.MOVE_TO_SEAT_DURATION = MOVE_TO_SEAT_DURATION

function PotChipView:ctor(parent, manager, potId)
    SP = RoomViewPosition.SeatPosition
    PP = RoomViewPosition.PotPosition
    self.parent_ = parent
    self.manager_ = manager
    self.potId_ = potId
    self.potChips_ = 0
end

function PotChipView:resetPotId(potId)
    self.potId_ = potId
end

-- 创建筹码堆
function PotChipView:createChipStack()
    for i, chipData in ipairs(self.potChipData_) do
        chipData:getSprite():pos(PP[self.potId_].x, PP[self.potId_].y + 28 + (i - 1) * GAP_WITH_CHIPS):opacity(255):addTo(self.parent_)
    end

    return self
end

-- 重置筹码堆
function PotChipView:resetChipStack(potChips)
    if self.potChips_ == potChips then
        return self
    else
        self.potChips_ = potChips
    end
    if self.potChips_ > 0 then
        self.manager_:recycleChipData(self.potChipData_)
        self.potChipData_ = self.manager_:getChipData(self.potChips_)

        -- 替换筹码堆
        self:createChipStack()
    end
    
    return self
end

function PotChipView:moveToSeat(positionId, completeCallback)
    self.moveToSeatCompleteCallback_ = completeCallback
    if self.potChipData_ then
        local chipNum = #self.potChipData_
        for i, chipData in ipairs(self.potChipData_) do
            local sp = chipData:getSprite()
            if i > 1 then
                transition.execute(
                    sp, 
                    cc.MoveTo:create(
                        MOVE_TO_SEAT_DURATION, 
                        cc.p(SP[positionId].x, SP[positionId].y)
                    ), 
                    {delay = (chipNum - i) * MOVE_DELAY_DURATION}
                )
            else
                transition.execute(
                    sp, 
                    cc.MoveTo:create(
                        MOVE_TO_SEAT_DURATION, 
                        cc.p(SP[positionId].x, SP[positionId].y)
                    ), 
                    {delay = (chipNum - i) * MOVE_DELAY_DURATION, onComplete = handler(self, self.moveToSeatComplete_)}
                )
            end
            transition.execute(
                sp, 
                cc.FadeTo:create(
                    MOVE_TO_SEAT_DURATION, 
                    128
                ), 
                {
                    delay = (chipNum - i) * MOVE_DELAY_DURATION, 
                    onComplete = function ()
                        sp:opacity(0)
                    end
                }
            )
        end
    end
end

function PotChipView:moveToSeatComplete_(clear)
    if clear=="clear" then
        self.moveToSeatCompleteCallback_ = nil
    end
    if self.moveToSeatCompleteCallback_ then
        self.moveToSeatCompleteCallback_(self.potChips_)
        self.moveToSeatCompleteCallback_ = nil
    end
    if self.potChipData_ then
        self.manager_:recycleChipData(self.potChipData_)
        self.potChipData_ = nil
    end
    self.potChips_ = 0
end

function PotChipView:reset()
    if self.potChipData_ then
        self.manager_:recycleChipData(self.potChipData_)
        self.potChipData_ = nil
    end
    self.potChips_ = 0
end

-- 清理
function PotChipView:dispose()
    self:reset()
end

return PotChipView