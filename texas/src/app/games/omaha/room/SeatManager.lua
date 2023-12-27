
local SeatManager           = import("app.games.texas.room.SeatManager")
local OmahaSeatManager      = class("OmahaSeatManager", SeatManager)
local SeatView              = import(".views.SeatView")
local RoomViewPosition      = import("app.games.texas.room.views.RoomViewPosition")

local SeatPosition = RoomViewPosition.SeatPosition

local SEAT_PROGRESS_TIMER_TAG = 8390

local SEATS_9 = {0, 1, 2, 3, 4, 5, 6, 7, 8}
local SEATS_6 = {0, 1, 2, 3, 4, 5}
local SEATS_5 = {0, 2, 4, 6, 8}
local SEATS_2 = {2, 6}

local logger = sa.Logger.new("OmahaSeatManager")

function OmahaSeatManager:ctor(ctx)
    SeatPosition = RoomViewPosition.SeatPosition
    OmahaSeatManager.super.ctor(self, ctx)
end

function OmahaSeatManager:createNodes()
    --创建座位
    self.seats_ = {}
    for i = 0, 8 do
        local seat = SeatView.new(self.ctx, i)
        cc.EventProxy.new(seat, self.scene)
            :addEventListener(SeatView.CLICKED, handler(self, self.onSeatClicked_))
        self.seats_[i] = seat

        local pos = SeatPosition[i + 1]
        seat:setPosition(pos)
        seat:setPositionId(i + 1)
        seat:addTo(self.scene.nodes.seatNode)
    end
end

return OmahaSeatManager
