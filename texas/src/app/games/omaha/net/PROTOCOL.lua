local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = clone(require("app.games.texas.net.PROTOCOL"))
local OMAHA_PROTOCOL = P   -- 1 德州扑克普通玩法
P.GAMEID  = 3 -- 游戏ID 每个游戏不一样  
-- 覆盖之前的协议

P.RECE[P.SVR_GAME_START] = {
    ver = 1,
    fmt = function(ret, buf)
        local isPlaying = false
        local len = T.readByte(buf)
        local playerList = {}
        for i=1, len, 1 do
            local item = {}
            item.seatId = T.readByte(buf)
            item.uid = T.readUInt(buf)
            item.seatChips = T.readULong(buf)
            playerList[i] = item
            if tx.userData and item.uid==tx.userData.uid then
                isPlaying = true
            end
        end
        ret["playerList"] = playerList
        ret["dealerSeatId"] = T.readByte(buf)
        ret["bigSeatId"] = T.readByte(buf)
        ret["bigChips"] = T.readULong(buf)
        ret["smallSeatId"] = T.readByte(buf)
        ret["smallChips"] = T.readULong(buf)
        if isPlaying then
            ret["handCard1"] = T.readUShort(buf)
            ret["handCard2"] = T.readUShort(buf)
            ret["handCard3"] = T.readUShort(buf)
            ret["handCard4"] = T.readUShort(buf)
        end
    end
}

P.RECE[P.SVR_GAME_OVER] = {
    ver = 1,
    fmt = function(ret, buf)
        local len = T.readByte(buf)
        local playerList = {}
        for i=1, len, 1 do
            local item = {}
            item["seatId"] = T.readByte(buf)      --type=T.BYTE},        --座位ID
            item["uid"] = T.readUInt(buf)         --type=T.UINT},        --用户ID
            item["changeChips"] = T.readULong(buf)--type=T.ULONG},--筹码变化
            item["exp"] = T.readUInt(buf)         --type=T.UINT},        --经验变化
            item["seatChips"] = T.readULong(buf)  --type=T.ULONG}, --座位的钱数
            item["handCard1"] = T.readUShort(buf) --type=T.USHORT},    --手牌1
            item["handCard2"] = T.readUShort(buf) --type=T.USHORT},    --手牌2
            item["handCard3"] = T.readUShort(buf) --type=T.USHORT},    --手牌3
            item["handCard4"] = T.readUShort(buf) --type=T.USHORT},    --手牌4
            item["cardType"] = T.readByte(buf)    --type=T.BYTE},     --牌型
            item["status"] = T.readByte(buf)      --type=T.BYTE},     --玩家是否是已经弃牌
            playerList[i] = item
        end
        local potLen = T.readByte(buf)
        local potsList = {}
        for i=1, potLen, 1 do
            local item = {}
            item["potChips"] = T.readLong(buf)
            local winList = {}
            local winListLen = T.readByte(buf)
            for j=1,winListLen,1 do
                local winItem = {}
                winItem["seatId"]=T.readByte(buf) --type=T.BYTE},     --赢家座位ID
                winItem["uid"]=T.readUInt(buf)--type=T.UINT},        --赢家用户ID
                winItem["card1"]=T.readUShort(buf) --type=T.USHORT},    --最大牌1
                winItem["card2"]=T.readUShort(buf) --type=T.USHORT},    --最大牌2
                winItem["card3"]=T.readUShort(buf) --type=T.USHORT},    --最大牌3
                winItem["card4"]=T.readUShort(buf) --type=T.USHORT},    --最大牌4
                winItem["card5"]=T.readUShort(buf) --type=T.USHORT},    --最大牌5
                winItem["winChips"]=T.readLong(buf) --type=T.LONG},   --赢取筹码数   可能是输了
                winList[j] = winItem
            end
            item["winList"] = winList
            potsList[i] = item
        end
        -- 补充牌局信息
        if buf:getAvailable() <= 0 then -- 兼容线上老版本
            for k,v in pairs(playerList) do
                v.pretaxWinChips = v.changeChips --真实赢钱 不扣税前 用牌局记录
                v.totalWinChips = nil --玩家当前总共的筹码数量
                v.preField = 0 --预留字段
            end
        else
            for i=1, len, 1 do
                local uid = T.readUInt(buf) --用户ID
                for k,v in pairs(playerList) do
                    if v.uid==uid then
                        v.pretaxWinChips = T.readULong(buf) --真实赢钱 不扣税前 用牌局记录
                        v.totalWinChips = T.readULong(buf) --玩家当前总共的筹码数量
                        v.preField = T.readULong(buf) --预留字段
                        break
                    end
                end
            end
        end
        ret["playerList"] = playerList
        ret["potsList"] = potsList
    end
}


P.RECE[P.SVR_POT] = {
    ver = 1,
    fmt = {
        {
            name="pots",--奖池
            type=T.ARRAY,
            lengthType=T.BYTE,
            fmt={type=T.ULONG}
        },
        {
            name="allInHandCards",--AllIn时候直接导致的结算
            type=T.ARRAY,
            lengthType=T.BYTE,
            fmt={
                {name="seatId", type=T.BYTE},        --座位ID
                {name="handCard1", type=T.USHORT},   --手牌1
                {name="handCard2", type=T.USHORT},   --手牌2
                {name="handCard3", type=T.USHORT},   --手牌3
                {name="handCard4", type=T.USHORT},   --手牌4
            },
        }
    },
}

return OMAHA_PROTOCOL