local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = {}

local MATCH_SOCKET_PROTOCOL = P
P.CONFIG = {}
P.RECE = {}
P.SEND = {}

P.HALL_CLI_HEART_BEAT           = 0x110    --心跳
P.HALL_SVR_HEART_BEAT           = 0x110    --心跳

-- 比赛大厅协议
P.CLI_LOGIN                     = 0x116    --登录大厅
P.SVR_LOGIN_OK                  = 0x201    --登录大厅成功
P.SVR_LOGIN_ERROR               = 0x203    --登录大厅失败

P.CLI_GET_COUNT                 = 0x131    --获取等级在线人数
P.SVR_GET_COUNT                 = 0x132    --响应等级在线人数

P.CLI_REGISTER                  = 0x101    --注册
P.SVR_REGISTER_RET              = 0x102    --报名注册返回的结果

P.CLI_CANCEL_REGISTER           = 0x103    --取消注册
P.SVR_CANCEL_REGISTER_RET       = 0x104    --取消报名注册返回的结果

P.SVR_JOIN_GAME                 = 0x105    --S加入游戏
P.CLI_JOIN_GAME                 = 0x113    --C加入游戏
P.SVR_JOIN_GAME_SUCC            = 0x210    --加入游戏成功

P.CLI_GET_MATCH_STATUS          = 0x106    --获取已报比赛状态
P.SVR_MATCH_STATUS              = 0x107    --服务器通知比赛状态

-- P.SET_PUSH_INFO                 = 0x150    --设置推送信息
-- P.GET_PUSH_INFO                 = 0x151    --获取推送信息
-- P.ON_GET_PUSH_INFO              = 0x152    --ON获取推送信息

P.SVR_REGISTER_COUNT            = 0x108    --通知已经报名的人当前场次报名的人数

P.SVR_AUTO_CANCEL_REGISTER      = 0x109    --server主动取消用户的报名状态

P.UPDATE_USER_PROP              = 0x10A    --刷新道具

P.CLI_GET_REGED_COUNT           = 0x10B    --获取当前场次报名人数
P.SVR_REGED_COUNT               = 0x10C    --回应报名人数

P.SVR_MATCH_END_STATUS          = 0x523    --通知房间内所有人比赛结束

P.SVR_CMD_USER_MATCH_SCORE      = 0x2307   -- 自己结束比赛
P.SVR_CMD_USER_MATCH_RISECHIP   = 0x2308   -- 倒计时 涨盲
P.SVR_CMD_CHANGE_ROOM           = 0x230B   -- 等待换桌
P.SVR_CMD_USER_MATCH_RANK       = 0x230C   -- 游戏排名
P.MATCH_ROOM_BASE_INFO          = 0x2309   -- 比赛基本信息

-- 定义在大厅内部 的部分协议  -- 同步比赛场没有定义协议的问题 写在这里不太好理解 需要提取到matchSocket中
-- 聊天（实际为客户端触发广播  包括聊天、互动道具、礼物等）
P.TABLE_CLI_MSG                 = 0x1003    --房间客户端请求聊天等
P.TABLE_SVR_ON_MSG              = 0x1003    --服务器广播聊天等
-- 房间内同步信息
P.TABLE_CLI_SYN_PLAYER_INFO     = 0x1010    --同步信息
-- 表情
P.TABLE_CLI_EXP                 = 0x1004    --房间客户端请求表情
P.TABLE_SVR_ON_EXP              = 0x1004    --服务器广播表情

P.RECE = {
    [P.SVR_LOGIN_OK] = {
        ver = 1,
        fmt = {
            {name = "matchid", type = T.STRING},--比赛ID
            {name = "tid", type=T.INT},--0:表示第一次登陆，无桌子；>0 :表示已经在桌子，需要重连
            {name = "ip", type=T.STRING}, -- (内网ip，客户端忽略)
            {name = "port", type=T.INT}, -- 
            {name = "time", type=T.INT},
            {name = "level", type = T.INT},
        }
    },
    [P.SVR_GET_COUNT] = {
        ver = 1,
        fmt = {
            { 
                name = "levels",
                type = T.ARRAY,
                lengthType = T.INT,
                fmt = {
                    { name = "level", type=T.INT },--等级
                    { name = "userCount", type=T.INT},--等级在线人数  
                }
            },
        }
    },
    [P.SVR_REGISTER_RET] = {
        ver = 1,
        fmt = {
            { name = "ret", type = T.INT },  -- int(-1--未知错误，0--成功，1--重复报名，2--用户不存在，3--比赛状态错误，4--比赛人数已满，5--比赛券不足，6--金券不足, 8--游戏币不够, 10比赛正在维护)
            { name = "level", type = T.INT },  -- int(报名比赛等级，成功返回等级；重复报名返回已报名等级，其他返回0)
            { name = "matchid", type = T.STRING },  -- string(报名比赛ID，成功返回ID；重复报名返回已报名比赛ID，定人赛其他返回空，定时赛报名成功返回空)
        }
    },
    [P.SVR_CANCEL_REGISTER_RET] = {
        ver = 1,
        fmt = {
            { name = "ret", type = T.INT },   -- 0--取消成功，1--比赛不存在，2--比赛状态错误，无法取消  3--请求比赛ID错误
            { name = "level" , type = T.UINT },
        }
    },
    [P.SVR_JOIN_GAME] = {
        ver = 1,
        fmt = {
            { name = "joinTime", type = T.INT},  -- int(入场超时时长)
            { name = "level", type = T.UINT}, -- int(入场超时时长)
            { name = "matchid", type = T.STRING}, -- int(定人赛中比赛ID，定时赛为空)
        }
    },
    [P.SVR_JOIN_GAME_SUCC] = {
        ver = 1,
        fmt = {
            { name = "tid", type = T.INT }, -- int(桌子ID)
            { name = "serverid", type = T.INT }, -- int(serverid，具体的逻辑server)
            { name = "level", type = T.UINT }, -- int(比赛等级ID)
            { name = "ret", type = T.INT }, -- int(返回码，0--表示登陆成功，1--房间不存在，2--用户已经在房间，3--房间人数已满)
            { name = "ip", type = T.STRING },
            { name = "port", type = T.INT },
            { name = "matchid", type = T.STRING } -- string(定时赛返回的比赛ID，定人赛为请求时ID)
        }
    },
    [P.SVR_MATCH_STATUS] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT }, -- int(比赛等级)
            { name = "matchid", type = T.STRING },  -- string(比赛ID，定人赛当已经报名、正在入场时为目标ID，定时赛当比赛中，为目标ID，其他为空)
            { name = "status", type = T.INT },  -- int(比赛状态，-1--未报名，0--已经报名；1--正在入场；2--比赛中；3--比赛结束)
        }
    },
    [P.SVR_REGISTER_COUNT] = {
        ver = 1,
        fmt = {
            {name="level", type=T.UINT},   -- int(比赛等级)
            {name="matchid", type=T.STRING},  -- string(比赛ID,定时赛ID为空)
            {name="regCount", type=T.INT},  -- int(当前比赛人数)
        },
    },
    [P.SVR_AUTO_CANCEL_REGISTER] = {
        ver = 1,
        fmt = {
            { name = "level" , type = T.UINT },
            { name = "matchid" , type = T.STRING },
            { name = "reason" , type = T.INT } -- (取消比赛原因，1--未入场（客户端没发113），2--人数不足（入场），3--人数不足（报名），4--未入场（客户端发了113，但是没发1001或者是超时发1001【入场时间过了】）5--系统维护退券)
        },
    },
    [P.UPDATE_USER_PROP] = {
        ver = 1,
        fmt = {
            {
                name = "propList",
                type = T.ARRAY,
                lengthType = T.INT,
                fmt = {
                    { name = "pid", type=T.INT },-- int(道具ID； 1--游戏币，8--钻石)
                    { name = "num", type=T.ULONG},--int64(道具当前数目)
                }
            },
        }
    },
    [P.SVR_REGED_COUNT] = {
        ver = 1,
        fmt = {
            {name="level", type=T.UINT},
            {name="regCount", type=T.INT},
        }
    },
    [P.SVR_CMD_USER_MATCH_SCORE] = {
        ver = 1,
        fmt = {
            {name="level", type=T.UINT},
            {name="totalCount", type=T.INT},
            {name="selfRank", type=T.INT},
            -- {name="huntNum", type=T.INT, optional=true}, --猎杀人数
        },
    },
    [P.SVR_CMD_USER_MATCH_RISECHIP] = {
        ver = 1,
        fmt = {
            {name="times", type=T.INT},          --(涨盲次数，从0开始)
            {name="leftTime", type=T.INT},       --(涨盲间隔)
            {name="blind", type=T.ULONG},       --(涨盲后的盲注)
            {name="avgChip", type=T.INT},       --均筹
        },
    },
    [P.SVR_CMD_USER_MATCH_RANK] = {
        ver = 1,
        fmt = {
            {name="curTotalCnt", type=T.INT}, --比赛当前总人数
            { 
                name = "rankList",
                type = T.ARRAY,
                lengthType = T.INT,
                fmt = {
                    {name = "rank", type=T.INT },--排名
                    {name = "uid", type=T.INT},
                    {name = "info", type=T.STRING },--详细信息
                    {name = "money", type=T.ULONG},--比赛筹码 
                }
            },
        }
    },
    [P.MATCH_ROOM_BASE_INFO] = {
        ver = 1,
        fmt = {
            {name = "matchBaseInfo", type = T.STRING},--比赛ID
        }
    },
    [P.TABLE_SVR_ON_MSG] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.UINT}, --用户类型
            {name = "info", type = T.STRING}, --信息
        }
    },
    [P.TABLE_SVR_ON_EXP] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.UINT}, --用户类型
            {name = "expId", type = T.UINT}, --表情ID
            {name = "isVip", type = T.UINT}, --是否为VIP表情
        }
    },
}

P.SEND = {
    [P.CLI_LOGIN] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.UINT}, --用户ID
            {name = "info", type = T.STRING}, --信息
        }
    },
    [P.CLI_GET_COUNT] = {
        ver = 1,
        fmt = function(buf, ret)
            local list = ret.list or {}
            T.writeInt(buf,#list)
            for k,v in ipairs(list) do
                T.writeInt(buf,v)
            end
        end
    },
    [P.CLI_REGISTER] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT }, --等级
            { name = "info", type = T.STRING }, --玩家信息
        }
    },
    [P.CLI_CANCEL_REGISTER] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT },  -- int(比赛等级ID)
            { name = "matchid", type = T.STRING },  -- string(定人赛中为比赛ID，定时赛为空)
        }
    },
    [P.CLI_JOIN_GAME] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT },    -- int(比赛等级ID)
            { name = "matchid", type = T.STRING } -- string(比赛ID,定时赛时为空)
            
        }
    },
    [P.CLI_GET_MATCH_STATUS] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT },     -- 比赛等级
        },
    },
    [P.CLI_GET_REGED_COUNT] = {
        ver = 1,
        fmt = {
            { name = "level", type = T.UINT },
        }
    },
    [P.TABLE_CLI_MSG] = {
        ver = 1,
        fmt = {
            {name = "info", type = T.STRING},  --请求的信息
        }
    },
    [P.TABLE_CLI_EXP] = {
        ver = 1,
        fmt = {
            {name = "expId", type = T.UINT},  --表情ID
            {name = "isVip", type = T.INT},  --是否为VIP表情
        }
    },
    [P.TABLE_CLI_SYN_PLAYER_INFO] = {
        ver = 1,
        fmt = function(buf, ret)
            local list = ret["list"] or {}
            T.writeByte(buf,#list)
            for k,v in ipairs(list) do
                T.writeInt(buf,v["uid"])
                T.writeString(buf,v["info"])
            end
        end
    },
}
return MATCH_SOCKET_PROTOCOL