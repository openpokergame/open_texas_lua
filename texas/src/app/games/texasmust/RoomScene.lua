local RoomScene             = import("app.games.texas.RoomScene")
local TexasMustRoomScene    = class("TexasMustRoomScene", RoomScene)
local P                     = import(".net.PROTOCOL")

local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
    {"c_9", "c_6"},--普通场
    {"q_9", "q_6"},--快速场
}

function TexasMustRoomScene:ctor()
    TexasMustRoomScene.super.ctor(self, P.GAMEID)
end

function TexasMustRoomScene:getCityName_()
    local levelType = 2
    local index = 1
    local config = tx.userData.texasMustTableConfig
    if not config then
        return "", levelType
    end

    local level = tonumber(tx.socket.HallSocket.curGameLevel)
    local city = sa.LangUtil.getText("HALL", "TEXAS_MUST_ROOM_CITY_NAME")
    local data = config[1][ROOM_TYPE_KEY[QUICK_PLAY][NUM_6]]

    for i, v in ipairs(data) do
        if level == tonumber(v.level) then
            index = v.index or i
            break
        end
    end

    return city[index], levelType
end

function TexasMustRoomScene:dealSitDownView()
    TexasMustRoomScene.super.dealSitDownView(self)

    self.addChipsBtn_:hide()
end

return TexasMustRoomScene
