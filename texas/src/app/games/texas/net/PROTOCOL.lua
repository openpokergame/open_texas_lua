local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = {}
local TEXAS_PROTOCOL = P   -- 1 德州扑克普通玩法
P.GAMEID  = 1 -- 游戏ID 每个游戏不一样  
P.CONFIG = {}
P.RECE = {}
P.SEND = {}


P.CLI_LOGIN                     = 0x1001    --登录房间
P.CLI_LOGOUT                    = 0x1002    --登出房间
P.CLI_SIT_DOWN                  = 0x1031    --坐下
P.CLI_STAND_UP                  = 0x1033    --站起
P.CLI_BET                       = 0x1032    --下注
P.CLI_SET_AUTO_SIT              = 0x1006    --自动坐下
P.CLI_ADD_CHIPS                 = 0x1035    --房间内增购,客户端增加筹码
P.CLI_ROOM_SET                  = 0x1036    --房间内设置自动买入
P.CLI_BUY_GOLD_ISLAND           = 0x1037    --购买夺金岛

P.SVR_LOGIN_SUCCESS             = 0x1007    --登录成功
P.SVR_LOGIN_FAIL                = 0x1005    --登录失败
P.SVR_LOGOUT_SUCCESS            = 0x1008    --登出成功
P.SVR_GAME_START                = 0x4001    --游戏开始
P.SVR_GAME_OVER                 = 0x4004    --游戏结束
P.SVR_SIT_DOWN                  = 0x4002    --坐下成功
P.SVR_SIT_DOWN_FAIL             = 0x1051    --坐下失败
P.SVR_STAND_UP                  = 0x4006    --广播站起
P.SVR_BET_SUCCESS               = 0x4003    --下注成功
P.SVR_BET_FAIL                  = 0x1052    --下注失败
P.SVR_DEAL_PUB_CARD             = 0x4011    --发公共牌
P.SVR_TURN_TO_BET               = 0x4012    --轮到座位下注
P.SVR_POT                       = 0x2010    --奖池
P.SVR_INIT_GOLD_ISLAND_POOL     = 0x1055    -- 夺金岛奖池，登录成功的时候才有，同步奖池

P.SEND = {
	[P.CLI_LOGIN] = {
        ver = 1,
        fmt = {
            { name = "gameId", type = T.UINT }, -- 游戏ID
            { name = "gameLevel", type = T.UINT }, -- 游戏等级
            { name = "tid", type = T.UINT },   -- 用户ID
            { name = "uid", type = T.UINT },   -- 用户ID
            { name = "info" , type = T.STRING }, -- 用户信息，json格式
            { name = "mtkey" , type = T.STRING }, -- 密钥 用户mtkey
            { name = "pwd", type = T.STRING }, -- 密码
        }
    },
    [P.CLI_SIT_DOWN] = {
        ver = 1,
        fmt = {
            {name="seatId", type=T.BYTE},        --座位ID
            {name="buyIn", type=T.ULONG},        --买入筹码
            {name="auto", type=T.INT},        --买入筹码
            {name="type", type=T.INT},        --自动买入类型 0:不足小盲时; 1:不足最低买入时
        }
    },
    [P.CLI_BET] = {
        ver = 1,
        fmt = {
            {name="betType", type=T.BYTE},        --下注类型
            {name="betChips", type=T.ULONG},    --下注筹码数
        }
    },
    [P.CLI_ADD_CHIPS] = {
        ver = 1,
        fmt = {
            {name="chips", type=T.ULONG},    --客户端增加筹码
        }
    },
    [P.CLI_ROOM_SET] = {
        ver = 1,
        fmt = {
            {name="auto", type=T.INT},        --买入筹码
            {name="type", type=T.INT},        --自动买入类型 0:不足小盲时; 1:不足最低买入时
        }
    },
    [P.CLI_BUY_GOLD_ISLAND] = {
        ver = 1,
        fmt = {
            {name="betChips", type=T.ULONG},        --买入筹码
        }
    },
}

P.RECE = {
	[P.SVR_LOGIN_SUCCESS] = {
        ver = 1,
        fmt = {
            {name = "blind"        , type = T.ULONG } , --盲注(小盲注)
            {name = "minBuyIn"     , type = T.ULONG}  , --最小携带
            {name = "maxBuyIn"     , type = T.ULONG}  , --最大携带
            {name = "roomName"     , type = T.STRING} , --房间名字
            {name = "tid"          , type = T.UINT}   , --桌子ID
            {name = "roomType"     , type = T.BYTE}   , --房间等级 roomLevel
            {name = "userChips"    , type = T.ULONG}  , --用户带入筹码数
            {name = "betExpire"    , type = T.USHORT}   , --下注最大时间   100毫秒单位
            {name = "gameStatus"   , type = T.BYTE}   , --游戏状态
            {name = "seatNum"      , type = T.BYTE}   , --座位数
            {name = "dealerSeatId" , type = T.BYTE}   , --(前一局赢家，要是赢家离开就是下一位) 啥意思
            {    --奖池
                name="pots",
                type=T.ARRAY,
                lengthType=T.BYTE,
                fmt = {type=T.ULONG}
            },
            {
                name = "pubCards",
                type = T.ARRAY,
                lengthType=T.BYTE,
                fmt = {type=T.USHORT},
            },
            {name="bettingSeatId", type=T.BYTE},--正在下注的座位ID (当前下注座位,-1--表示不是下注阶段,)
            {name="leftTime", type=T.USHORT, depends=function(ctx, row) return ctx.bettingSeatId ~= -1 end},          --剩余操作时间    100毫秒单位
            {name="callChips", type=T.ULONG, depends=function(ctx, row) return ctx.bettingSeatId ~= -1 end},        --跟注需要钱数
            {name="minRaiseChips", type=T.ULONG, depends=function(ctx, row) return ctx.bettingSeatId ~= -1 end},    --加注最小钱数
            {name="maxRaiseChips", type=T.ULONG, depends=function(ctx, row) return ctx.bettingSeatId ~= -1 end},    --加注最大钱数
            {    --每个用户的信息(已经坐下的)
                name="playerList",
                type=T.ARRAY,
                lengthType=T.BYTE,
                fmt = {
                    {name = "seatId"    , type = T.BYTE}   , --座位ID
                    {name = "uid"       , type = T.UINT}   , --用户id
                    {name = "info"      , type = T.STRING}, --用户信息
                    {name = "seatChips" , type = T.ULONG}  , --座位的钱数
                    {name = "playing"   , type = T.BYTE}  , --是否在玩
                    {name = "betChips"  , type = T.ULONG, depends=function(ctx, row) return row.playing == 1 end}  , --座位的总下注数
                    {name = "betState"  , type = T.BYTE, depends=function(ctx, row) return row.playing == 1 end}   , --下注类型(座位状态)  -下注类型 //0：其他状态（游戏停止状态） 1看牌 2跟注 3加注 4弃牌 5 allin
                    {
                        name = "handCards" , 
                        type = T.ARRAY,
                        lengthType = T.BYTE,
                        depends=function(ctx, row) return row.playing == 1 end,
                        fmt = {type=T.USHORT},
                    }
                }
            },
        }
    },
    [P.SVR_LOGIN_FAIL] = {
        ver = 1,
        fmt = {
            {name="code", type=T.BYTE}    --失败原因代码  错误码 2:桌子人数已经满了; 3:钱不够进场; 4:钱太多不能进场; 6:桌子不存在; 8:房间已经过期; 10:密码错误;
        }
    },
    [P.SVR_LOGOUT_SUCCESS] = {
        ver = 1,
        fmt = {
            {name="chips", type=T.ULONG}
        }
    },
	[P.SVR_GAME_START] = {
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
            end
        end
    },
    [P.SVR_GAME_OVER] = {
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
    },
    [P.SVR_SIT_DOWN] = {
        ver = 1,
        fmt = {
            {name="seatId", type=T.BYTE},        --座位ID
            {name="uid", type=T.UINT},            --用户id
            {name="info", type=T.STRING} , -- 扩展数据(json字符串)
            {name="seatChips", type=T.ULONG},    --买入筹码数
        },
    },
    [P.SVR_SIT_DOWN_FAIL] = {
        ver = 1,
        fmt = {
            {name="code", type=T.BYTE},    --失败原因代码 7携带金币不在房间最小携带和最大携带之间 8座位已经有人
            {name="chips", type=T.ULONG, optional=true}, --客户端的金币数和服务器的金币数不同步 大于服务器的导致坐不下 
        },
    },
    [P.SVR_STAND_UP] = {
        ver = 1,
        fmt = {
            {name="seatId", type=T.BYTE},        --座位ID
            {name="uid", type=T.INT},        --玩家ID
            {name="chips", type=T.ULONG},        --用户筹码
            {name="code", type=T.INT},        --原因：0玩家登出,1玩家请求站起,2玩家没钱了,3三局未操作,4比赛场重新分配桌子
        },
    },
    [P.SVR_BET_SUCCESS] = {
        ver = 1,
        fmt = {
            {name="seatId", type=T.BYTE},        --座位ID
            {name="uid", type=T.INT},            --玩家ID
            {name="betState", type=T.BYTE},      --下注类型
            {name="betChips", type=T.ULONG},     --下注筹码数
        },
    },
    [P.SVR_BET_FAIL] = {
        ver = 1,
        fmt = {
            {name="code", type=T.BYTE},    --错误代码 byte类型 -1参数错误 -2不能看牌 -3跟注错误 -4加注错误 -5弃牌时下注数量不为0 -6 allin大于最大下注值 
            {name="totalChips", type=T.ULONG},   --用户实时筹码数
            {name="seatId", type=T.BYTE},        --座位ID
            {name="roundBetChips", type=T.ULONG},--自己本轮下注总筹码数
            {name="leftChips", type=T.ULONG},    --玩家实时剩余筹码数
            {name="callChips", type=T.ULONG},    --跟注需要的金额
            {name="minRaiseChips", type=T.ULONG},--最小加注金额
            {name="maxRaiseChips", type=T.ULONG},--最大加注金额
        },
    },
    [P.SVR_DEAL_PUB_CARD] = {
        ver = 1,
        fmt = {
            {name="type", type=T.BYTE},  --3发三张公共牌 4发第四张牌 5发第五张牌
            {
                name = "pubCards",
                type = T.ARRAY,
                lengthType = T.BYTE,
                fmt={type=T.USHORT},
            }
        },
    },
	[P.SVR_TURN_TO_BET] = {
        ver = 1,
        fmt = {
            {name="seatId", type=T.BYTE},        --轮到下注的座位ID
            {name="callChips", type=T.ULONG},    --跟注需要的金额
            {name="minRaiseChips", type=T.ULONG},--最小加注金额
            {name="maxRaiseChips", type=T.ULONG},--最大加注金额
        },
    },
    [P.SVR_POT] = {
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
                },
            }
        },
    },
    [P.SVR_INIT_GOLD_ISLAND_POOL] = {
        ver = 1,
        fmt = {
            {name="poolMoney", type=T.ULONG},  --奖池钱数
            {name="isBuy", type=T.INT},        --自己是否已经购买下局 0没买，1买了
            {name="isJoin", type=T.INT},       --自己是否加入本局夺金岛 0没加入，1加入
        },
    },
}

return TEXAS_PROTOCOL