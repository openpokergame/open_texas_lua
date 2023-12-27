local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = {}

local HALL_SOCKET_PROTOCOL = P
P.CONFIG = {}
P.RECE = {}
P.SEND = {}

P.HALL_CLI_HEART_BEAT                = 0x2008    --心跳
P.HALL_SVR_HEART_BEAT                = 0x600D    --心跳

-- 大厅协议
P.HALL_CLI_LOGIN                = 0x116    --登录大厅
P.HALL_SVR_LOGIN_OK             = 0x202    --登录大厅成功
P.HALL_SVR_KICK_OUT             = 0x43     --大厅踢人
-- 请求加入游戏
P.HALL_CLI_GET_GAME_ROOM        = 0x118    --获取制定游戏的房间号
P.HALL_SVR_ON_GAME_ROOM         = 0x210    --响应请求房间

-- enum FOLLOW_SYS_ERR
-- {
--     FS_SUCCESS = 0,                                   //跟随成功
--     FS_USER_NOT_LOGIN = 1,                            //用户未登录
--     FS_USER_IN_GAME = 2,                              //用户已经在玩游戏
--     FS_FOLLOWED_USER_NOT_LOGIN = 3,                   //被跟随用户未在线   
--     FS_FOLLOWED_USER_NOT_IN_GAME = 4,                 //被跟随用户未在玩游戏
-- };
P.HALL_CLI_TRACK                = 0x123    -- 请求跟踪
P.HALL_SVR_ON_TRACK_SUCCESS     = 0x215    -- 跟踪成功
P.HALL_SVR_ON_TRACK_FAIL        = 0x214    -- 跟踪失败

P.HALL_CLI_CREAT_ROOM           = 0x301    -- 请求创建私人房
P.HALL_SVR_ON_CREAT_ROOM        = 0x301    -- SVR回应私人房
P.HALL_SVR_PRIVATE_ROOM_INFO    = 0x303    -- 私人房信息
-- 私人房列表
P.HALL_CLI_GET_PRIROOM_LIST     = 0x304    -- 私人房列表
P.HALL_SVR_ON_PRIROOM_LIST      = 0x304    -- 返回私人列表

P.HALL_CLI_SEARCH_ROOM          = 0x302    -- 搜索房间
P.HALL_SVR_ON_SEARCH_ROOM       = 0x302    -- 搜索房间结果
-- 请求换桌
P.HALL_CLI_CHANGE_ROOM          = 0x1028    --请求换桌
P.HALL_SVR_CHANGE_ROOM          = 0x1029    --换桌结果错误码

-- 广播协议
P.HALL_BROADCAST_PERSON         = 0x7052    --个人广播
P.HALL_BROADCAST_SYSTEM         = 0x7852    --系统广播
-- 房间内广播  由PHP触发 暂时不用
P.TABLE_BROADCAST               = 0x7854    --房间广播协议
-- 聊天（实际为客户端触发广播  包括聊天、互动道具、礼物等）
P.TABLE_CLI_MSG                 = 0x1003    --房间客户端请求聊天等
P.TABLE_SVR_ON_MSG              = 0x1003    --服务器广播聊天等
-- 房间内同步信息
P.TABLE_CLI_SYN_PLAYER_INFO     = 0x1010    --同步信息
-- 牌力指示器  -- server为独立和游戏无关  随时可以组包请求
P.CLI_CARD_POWER                = 0x2500    --客户端请求牌力大小
P.SVR_CARD_POWER                = 0x2500    --服务器响应牌力大小

P.TABLE_MSG_TYPES = {
    [1] = 1,  --聊天
    [2] = 2,  --设置礼物
    [3] = 3,  --互动道具
    [4] = 4,  --添加好友
    [5] = 5,  --赠送筹码
    [6] = 6,  --赠送礼物
    [7] = 7,  --修改自己JSON信息同步
    [8] = 8,  --德州亮手牌 1,2
    [9] = 9,  --发送语音聊天
    [10] = 10,
    [11] = 11,
    [12] = 12,
    [13] = 13,
    [14] = 14,
    [15] = 15,
}
-- 表情
P.TABLE_CLI_EXP                 = 0x1004    --房间客户端请求表情
P.TABLE_SVR_ON_EXP              = 0x1004    --服务器广播表情

P.RECE = {
    [P.HALL_SVR_LOGIN_OK] = {
        ver = 1,
        fmt = {
            {name = "inTable", type = T.BYTE},--在普通场那个桌子
            {name = "gameId", type=T.SHORT, depends=function(ctx, row) return ctx.inTable > 0 end},
            {name = "gameSerId", type=T.INT, depends=function(ctx, row) return ctx.inTable > 0 end},
            {name = "tid", type=T.INT, depends=function(ctx, row) return ctx.inTable > 0 end},
            {name = "gameLevel", type=T.SHORT, depends=function(ctx, row) return ctx.inTable > 0 end},
            -- 比赛相关
        }
    },
    [P.HALL_SVR_KICK_OUT] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.INT},
        }
    },
    [P.HALL_SVR_ON_GAME_ROOM] = {
        ver = 1,
        fmt = {
            {name = "tid", type = T.INT},
            {name = "inTable", type=T.INT},
            {name = "gameLevel", type=T.INT},
            {name = "gameId", type=T.INT},
        }
    },
    [P.HALL_BROADCAST_PERSON] = {
        ver = 1,
        fmt = {
            {name = "type", type = T.INT},
            {name = "info", type = T.STRING}
        }
    },
    [P.HALL_BROADCAST_SYSTEM] = {
        ver = 1,
        fmt = {
            {name = "info", type = T.STRING}
        }
    },
    [P.HALL_SVR_ON_TRACK_SUCCESS] = {
        ver = 1,
        fmt = {
            {name = "code", type = T.INT}, --见错误码
            {name = "uid", type = T.UINT}, --跟随者用户ID
            {name = "nick", type = T.STRING}, --跟随者的昵称
        }
    },
    [P.HALL_SVR_ON_TRACK_FAIL] = {
        ver = 1,
        fmt = {
            {name = "code", type = T.INT}, --见错误码
        }
    },
    [P.TABLE_BROADCAST] = {
        ver = 1,
        fmt = {
            {name = "type", type = T.INT}, --类型
            {name = "fromUid", type = T.UINT}, --触发的用户ID
            {name = "toUid", type = T.UINT}, --目标用户ID
            {name = "info", type = T.STRING}, --发给客户端的json串
            {name = "default", type = T.STRING}, --预留字段,默认传空字符串即可
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
    [P.HALL_SVR_ON_CREAT_ROOM] = {
        ver = 1,
        fmt = {
            {name = "ret", type = T.INT}, --0成功 1:绿钻不够 2:表示参数错误 3:创建的房间数量超过上限
            {name = "fee", type = T.INT}, --扣取绿钻数
            {name = "tid", type = T.INT}, --房间ID
        }
    },
    [P.HALL_SVR_ON_SEARCH_ROOM] = {
        ver = 1,
        fmt = {
            {name = "ret", type = T.INT}, --0成功 -1桌子不存在
            {name = "gameId", type = T.UINT}, --游戏ID
            {name = "tid", type = T.UINT}, --房间ID
            {name = "gameLevel", type = T.UINT},--游戏等级
            {name = "needPwd", type = T.UINT},--0 or 1 是否要密码
        }
    },
    [P.HALL_SVR_CHANGE_ROOM] = {
        ver = 1,
        fmt = {
            {name="code", type=T.INT}    --int 1玩家尚未登录成功，不能换桌  2玩家退出之前房间失败
        },
    },
    [P.HALL_SVR_PRIVATE_ROOM_INFO] = {
        ver = 1,
        fmt = {
            {name="now", type=T.INT},           -- 当前时间
            {name="createTime", type=T.INT},    -- 创建时间
            {name="expireTime", type=T.INT},    -- 过期时间
        },
    },
    [P.HALL_SVR_ON_PRIROOM_LIST] = {
        ver = 1,
        fmt = {
            { name = "totalPages", type=T.UINT}, -- 总页数
            {
                name = "list",
                type = T.ARRAY,
                lengthType = T.INT,
                fmt = {
                    { name = "ownerId", type=T.UINT},--房主
                    {--所有在玩玩家
                        name = "playerList",
                        type = T.ARRAY,
                        lengthType = T.INT,
                        fmt = {
                            {name = "info", type=T.STRING},
                        }
                    },
                    { name = "tid", type=T.UINT },--房间ID
                    { name = "optTime", type = T.UINT}, --操作时间
                    { name = "blind", type=T.UINT},--底注
                    { name = "createTime", type = T.UINT}, --创建时间
                    -- receiveTime  -- 客户端接收到的时间
                    { name = "expTime", type = T.UINT, depends=function(ctx, row) row.receiveTime=os.time() return row.ownerId > 0 end }, --过期时间  剩余总时间
                    { name = "pwd", type=T.UINT},--是否有密码
                }
            },
        },
    },
    [P.SVR_CARD_POWER] = {
        ver = 1,
        fmt = {
            {name = "power", type = T.INT}, --牌力大小0--100
        }
    },
}

P.SEND = {
    --登陆大厅成功
    [P.HALL_CLI_LOGIN] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.UINT},  -- 玩家ID
            {name = "terminal", type = T.USHORT},  -- 终端号  0安卓 1 ios
            {name = "isFB", type = T.USHORT},  -- 0游客 1facebook
            {name = "ver", type = T.USHORT},     -- 版本号
            {name = "guid", type = T.STRING},  -- 
        }
    },
    -- 请求登陆普通场
    [P.HALL_CLI_GET_GAME_ROOM] = {
        ver = 1,
        fmt = {
            {name = "gameLevel", type = T.SHORT},
            {name = "gameId", type =T.INT},
        }
    },
    [P.HALL_CLI_TRACK] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.UINT},   --(被跟随用户ID)
            {name = "mtkey", type = T.STRING}, --(用户验证key)
            {name = "info", type = T.STRING},  --(用户信息json串)
            {name = "nick", type = T.STRING},  --(跟随者的昵称)
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
    [P.HALL_CLI_CREAT_ROOM] = {
        ver = 1,
        fmt = {
            {name = "gameId", type = T.UINT},
            {name = "gameLevel", type = T.UINT},
            {name = "blind", type = T.UINT}, --底注类型
            {name = "optTime", type = T.UINT}, --操作时间
            {name = "pwd", type = T.STRING}, --密码
            {name = "expTime", type = T.UINT}, --过期时间
        }
    },
    [P.HALL_CLI_SEARCH_ROOM] = {
        ver = 1,
        fmt = {
            {name = "gameId", type = T.UINT}, --游戏ID
            {name = "tid", type = T.UINT}, --房间ID
        }
    },
    [P.HALL_CLI_CHANGE_ROOM] = {
        ver = 1,
        fmt = {
            {name="gameId", type=T.UINT},       -- 游戏ID
            {name="gameLevel", type=T.UINT},    --下注筹码数
            {name="tid", type = T.UINT},        --房间ID
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
    [P.HALL_CLI_GET_PRIROOM_LIST] = {
        ver = 1,
        fmt = {
            {name="gameId", type=T.UINT},       -- 游戏ID
            {name="gameLevel", type=T.UINT},    --下注筹码数
            {name="page", type=T.UINT},     -- 页码
            {name="count", type=T.UINT},    -- 一页的数量
        }
    },
    [P.CLI_CARD_POWER] = {
        ver = 1,
        fmt = function(buf, ret)
            ret = ret or {}
            T.writeInt(buf,ret["uid"])
            T.writeInt(buf,ret["num"])
            T.writeInt(buf,ret["card1"])
            T.writeInt(buf,ret["card2"])
            local pubCards = ret["pubCards"] or {}
            T.writeInt(buf,#pubCards)
            for k,v in ipairs(pubCards) do
                T.writeInt(buf,v)
            end
        end
    },
}
return HALL_SOCKET_PROTOCOL