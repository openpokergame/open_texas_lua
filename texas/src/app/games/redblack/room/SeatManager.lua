-- 座位管理器
local SeatManager = class("SeatManager")

local SeatView = import(".views.SeatView")
local RoomViewPosition = import(".views.RoomViewPosition")
local SeatPosition = RoomViewPosition.SeatPosition

function SeatManager:ctor()
    self.seatViews_ = {}
    self.seatViewsId_ = {}
    self.seatIds_ = {0, 1, 2, 3, 4, 5, 6, 7, 8}
end

--创建座位，初始化座位id为-1，表示为空
function SeatManager:createNodes()
    local seatNode = self.scene.nodes.seatNode
    for i = 1,8 do
        self.seatViews_[i] = SeatView.new(self.ctx)
            :pos(SeatPosition[i].x, SeatPosition[i].y)
            :addTo(seatNode)
        self.seatViewsId_[i] = -1
    end
    self.seatViews_[4]:hide()
end

--重置座位id绑定
function SeatManager:resetBindIds()
    for i = 1,8 do
        self.seatViewsId_[i] = -1
        self.seatViews_[i]:removeData()
    end
end

--初始化座位，寻找空位坐下，坐满为止
function SeatManager:initSeats(players)
    self:resetBindIds()

    for _, v in pairs(players) do 
        local viewId = self:getViewIdBySeatId(-1)
        if viewId > 0 then
            self.seatViews_[viewId]:setData(v)
            self.seatViews_[viewId]:setSeatId(v.seatId)
            self.seatViewsId_[viewId] = v.seatId
        end
    end
end

--更新坐在座位上的玩家
function SeatManager:updateUserSitDown(seatId)
    local viewId = self:getViewIdBySeatId(-1)
    if viewId > 0 then
        local seatData = self.model.playerList[seatId]
        self.seatViews_[viewId]:setData(seatData)
        self.seatViews_[viewId]:setSeatId(seatId)
        self.seatViewsId_[viewId] = seatId
    end
end

--更新座位上站起的玩家
function SeatManager:updateUserStandUp(seatId)
    local viewId = self:getViewIdBySeatId(seatId)
    if viewId > 0 then
        self.seatViews_[viewId]:setData(nil)
        self.seatViewsId_[viewId] = -1
    end
end

--更新座位信息状态
function SeatManager:updateSeatState(seatId)
    local viewId = self:getViewIdBySeatId(seatId)
    if viewId > 0 then
        local seatData = self.model.playerList[seatId]
        self.seatViews_[viewId]:setData(seatData)
        self.seatViewsId_[viewId] = seatId
    end
end

--通过玩家seatId获取界面上的座位号
function SeatManager:getViewIdBySeatId(seatId)
    for i = 1,8 do
        if self.seatViewsId_[i] == seatId and i ~= 4 then
            return i
        end
    end
    return -1
end

--通过界面上的座位号，获取玩家seatId
function SeatManager:getSeatIdByViewId(viewId)
    return self.seatViewsId_[viewId] 
end

--获取空的座位
function SeatManager:getEmptySeatId()
    if self.seatIds_ then
        local playerList = self.model.playerList
        for i, seatId in ipairs(self.seatIds_) do
            if not playerList[seatId] then
                return seatId
            end
        end
    end
    return nil
end

--先通过uid确定自己的座位号，再根据seatId获取其他玩家的座位号
function SeatManager:getPosition(seatId, uid)
    local position = -1
    if uid == tx.userData.uid then
        positionId = 9
    else
        if seatId > -1 then
            positionId = self:getViewIdBySeatId(seatId)
            if positionId == -1 then
                positionId = 10
            end
        else
            positionId = 10
        end
    end

    return positionId
end

function SeatManager:playBetAvatarAnimation(positionId)
    local seat = self.seatViews_[positionId]
    seat:stopAllActions()
    seat:scale(1)

    local t = 0.1
    transition.scaleTo(seat, {scale = 0.9, time=t, onComplete=function()
        transition.scaleTo(seat, {scale = 1.1, time=t, onComplete=function()
            transition.scaleTo(seat, {scale = 1, time=t})
        end})
    end})
end

function SeatManager:dispose()
end

return SeatManager