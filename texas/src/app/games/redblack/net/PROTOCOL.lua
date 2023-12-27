local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = {}
local REDBLACK_PROTOCOL = P
P.GAMEID  = 4 -- 游戏ID 每个游戏不一样  
P.RECE = {}
P.SEND = {}

P.CLI_LOGIN               	= 0x1001    --登录房间
P.CLI_LOGOUT          		= 0x1002    --登出房间
P.CLI_SIT_DOWN				= 0x1031    --坐下
P.CLI_BET              		= 0x1032    --下注
P.CLI_GET_ALL_USERINFO 		= 0x1037    --获取所有玩家信息

P.SVR_LOGIN_SUCCESS        	= 0x1007    --登录成功
P.SVR_LOGIN_FAIL           	= 0x1005    --登录失败
P.SVR_LOGOUT_SUCCESS        = 0x1008    --登出成功
P.SVR_GAME_START       		= 0x4001    --游戏开始
P.SVR_SIT_DOWN         		= 0x4002    --用户坐下登录成功
P.SVR_BET_SUCCESS           = 0x4003    --用户下注成功
P.SVR_GAME_OVER          	= 0x4004    --本局游戏结束
P.SVR_STAND_UP        		= 0x4006    --广播站起
P.SVR_START_BET        		= 0x4012    --开始下注
P.SVR_SIT_DOWN_FAIL         = 0x1051    --坐下失败
P.SVR_SELF_BET_FAIL    	   	= 0x1052    --自己下注失败

P.SVR_GET_HISTORY   		= 0x1056    --请求历史数据
P.SVR_GET_ALL_USERINFO  	= 0x1037    --所有玩家信息

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
}

P.RECE = {
	[P.SVR_LOGIN_SUCCESS] = {
        ver = 1,
        fmt = {
            {name = "basechip", type = T.ULONG },	--最低压注值
            {name = "minBuyIn", type = T.ULONG},	--最小携带
            {name = "maxBuyIn", type = T.ULONG},	--最大携带
            {name = "roomName", type = T.STRING},	--房间名字
            {name = "tid", type = T.UINT},	--桌子ID
            {name = "roomType", type = T.BYTE},	--房间等级 roomLevel
            {name = "userChips", type = T.ULONG},	--用户带入筹码数
            {name = "betExpire", type = T.USHORT},	--下注最大时间   100毫秒单位
            {name = "gameStatus", type = T.BYTE},	--游戏状态0 stop 1发牌状态 2下注中 10延时结算 
            {name = "seatNum", type = T.BYTE},	--座位数
            {name = "pubCard", type=T.SHORT, depends=function(ctx, row) return ctx.gameStatus == 2 or ctx.gameStatus == 1 end},--如果正在下注，亮的第一张公共牌
            {name = "betLeftTime", type=T.SHORT, depends=function(ctx, row) return ctx.gameStatus == 2 end},--剩余下注时间,100毫秒单位 
            {
                name = "allBetList", --下注数量列表
                type = T.ARRAY,
                lengthType = T.BYTE,
                depends=function(ctx, row) return ctx.gameStatus == 2 end,
                fmt = {
                	{name="betType", type=T.INT},
                	{name="betChips", type=T.ULONG},
                }
            },
            {
                name = "selfBetList", --自己下注数量列表
                type = T.ARRAY,
                lengthType = T.BYTE,
                depends=function(ctx, row) return ctx.gameStatus == 2 end,
                fmt = {
                	{name="betType", type=T.INT},
                	{name="betChips", type=T.ULONG},
                }
            },
            {name="gameLeftTime", type=T.SHORT, depends=function(ctx, row) return ctx.gameStatus == 10 end},--结算剩余时间,100毫秒单位 
            {
                name="playerList",--每个用户的信息(已经坐下的)
                type=T.ARRAY,
                lengthType=T.BYTE,
                fmt = {
                    {name = "seatId"    , type = T.BYTE}   , --座位ID
                    {name = "uid"       , type = T.INT}   , --用户id
                    {name = "userInfo"  , type = T.STRING}, --用户信息
                    {name = "seatChips" , type = T.ULONG}  , --座位的钱数
                }
            }, 
            {name="maxBetNum", type=T.INT}, --单局最大下注额度
            {
                name = "betOddsList", --赔率列表
                type = T.ARRAY,
                lengthType = T.INT,
                fmt = {
                	{name="betType", type=T.INT}, --下注类型
                	{name="odds", type=T.INT}, --赔率,真是赔率的100倍
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
	[P.SVR_BET_SUCCESS] = {
	    ver = 1,
	    fmt = {
			{
				name="playerList", --所有下注玩家
				type=T.ARRAY,
				lengthType=T.BYTE,
				fmt = {
					{name="seatId",type=T.BYTE},
					{name="uid",type=T.INT},
					{
						name = "betList",
						type = T.ARRAY,
						lengthType = T.BYTE,
						fmt = {
							{name="betType",type=T.INT},
							{name="betChips",type=T.ULONG},
						}
					}
				}
		    }
		}
	},
	[P.SVR_SIT_DOWN] = {
	    ver = 1,
	    fmt = {
            {name="seatId", type=T.BYTE},        --座位ID
            {name="uid", type=T.UINT},            --用户id
            {name="userInfo", type=T.STRING} , -- 扩展数据(json字符串)
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
    [P.SVR_LOGOUT_SUCCESS] = {
        ver = 1,
        fmt = {
            {name="chips", type=T.ULONG}
        }
    },
	[P.SVR_SELF_BET_FAIL] = {
	    ver = 1,
	    fmt = {
	        {name="err",type=T.BYTE}, --(-1下注失败，0下注成功)  
	        {name="seatChips",type=T.ULONG}, --携带的钱
	        {name="money",type=T.ULONG}, --总共的钱
	        {name="betType",type=T.INT}, --下注类型
			{name="betChips",type=T.ULONG}, --自己下注金额
			{name="betTotalChips",type=T.ULONG}, --总共下注金额
	    }
	},
	[P.SVR_GAME_OVER] = {
	    ver = 1,
	    fmt = {
	    	{name="winner",type=T.INT}, --1是银象,2金象,3平局
	    	{
	            name="winResult", --本局压中结果
	            type=T.ARRAY,
	            lengthType = T.BYTE,
	            fmt = {
	                {name="winType",type=T.INT},
	                {name="chips",type=T.ULONG}, --该类型，中奖总金额
	            }
	        },
	        {name="r_card1",type=T.SHORT},
	        {name="r_card2",type=T.SHORT},
	        {name="b_card1",type=T.SHORT},
	        {name="b_card2",type=T.SHORT},
	        {name="pub_card1",type=T.SHORT},
	        {name="pub_card2",type=T.SHORT},
	        {name="pub_card3",type=T.SHORT},
	        {name="pub_card4",type=T.SHORT},
	        {name="pub_card5",type=T.SHORT},
	        {name="r_card_type",type=T.INT}, --银象牌型
	        {name="b_card_type",type=T.INT}, --金象牌型
	        {name="win_card1",type=T.SHORT, depends=function(ctx, row) return ctx.winner ~= 3 end},
	        {name="win_card2",type=T.SHORT, depends=function(ctx, row) return ctx.winner ~= 3 end},
	        {name="win_card3",type=T.SHORT, depends=function(ctx, row) return ctx.winner ~= 3 end},
	        {name="win_card4",type=T.SHORT, depends=function(ctx, row) return ctx.winner ~= 3 end},
	        {name="win_card5",type=T.SHORT, depends=function(ctx, row) return ctx.winner ~= 3 end},
	        {
                name="playerList", --座位上玩家，下注记录
				type=T.ARRAY,
				lengthType=T.BYTE,
				fmt = {
					{name="seatId",type=T.BYTE},
					{name="uid",type=T.INT},
					{
						name = "betResult",
						type = T.ARRAY,
						lengthType = T.BYTE,
						fmt = {
							{name="betType",type=T.INT},
							{name="betChips",type=T.ULONG},
							{name="winChips",type=T.ULONG}
						}
					}
				}
            },
            {name="nextTime",type=T.INT}, --下局开始倒计时
            {
				name="betResult", --自己的下注记录
				type=T.ARRAY,
				lengthType = T.BYTE,
				fmt = {
					{name="betType",type=T.INT},
					{name="betChips",type=T.ULONG},
					{name="winChips",type=T.ULONG} --赢得钱数，大于等于0
				}
			},
			{name="userChips", type=T.ULONG}, --玩家结算后身上的钱数
			{
                name="playerChipsList",  --所有座位上玩家(包括自己)结算后总钱数
				type=T.ARRAY,
				lengthType=T.BYTE,
				fmt = {
					{name="seatId",type=T.BYTE},
					{name="uid",type=T.INT},
					{name="money",type=T.ULONG}
				}
            },
	    }
	},

	[P.SVR_GAME_START] = {
	    ver = 1,
	    fmt = {
	        {
	            name="playerList",
	            type=T.ARRAY,
	            lengthType = T.BYTE,
	            fmt = {
	                {name="seatId",type=T.BYTE},
	                {name="uid",type=T.INT},
	                {name="seatChips",type=T.ULONG},--携带的钱
	            }
	        },
	        {name="pubCard",type=T.SHORT},
	    }
	},
	[P.SVR_GET_HISTORY] = {
	    ver = 1,
	    fmt = {
	        {
	            name = "history",
	            type = T.ARRAY,
	            lengthType = T.INT,
	            fmt = {
	                {name="winner",type=T.INT},--胜方
	                {name="cardType",type=T.INT},--牌型
	            }
	        },
	        {name="silverWinTimes",type=T.INT}, --红胜次数
	        {name="goldkWinTimes",type=T.INT}, --黑胜次数
	        {name="drawWinTimes",type=T.INT}, --平局次数
	        {name="thlpTimes",type=T.INT}, --同花连牌次数
	        {name="daTimes",type=T.INT}, --对A次数
	        {name="hlTimes",type=T.INT}, --葫芦次数
	        {name="jgTimes",type=T.INT}, --金刚/同花顺/皇家次数
	    }
	},
	[P.SVR_GET_ALL_USERINFO] = {
	    ver = 1,
	    fmt = {
	        {
	            name="allUserList",--所有玩家信息
	            type=T.ARRAY,
	            lengthType = T.INT,
	            fmt = {
	            	{name = "seatId", type=T.BYTE}   , --座位ID
	                {name = "uid",type=T.INT},
	                {name = "money",type=T.ULONG},
	                {name = "userInfo",type=T.STRING},
	            }
	        }
	    }
	},
}

return REDBLACK_PROTOCOL