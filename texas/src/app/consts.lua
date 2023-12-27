consts = consts or {}

--hall server错误定义
consts.SVR_ERROR = {}
local codes = consts.SVR_ERROR
codes.ERROR_CONNECT_FAILURE = 100 --连接失败
codes.ERROR_HEART_TIME_OUT  = 101 --心跳包超时
codes.ERROR_LOGIN_TIME_OUT  = 102 --登录超时
codes.ERROR_SEND_NOT_CON  	= 103 --发送数据包时还未连接成功

-- 登录失败原因代码
consts.SVR_LOGIN_FAIL_CODE = {}
local codes = consts.SVR_LOGIN_FAIL_CODE
codes.INVALID_MTKEY        = 0x9001 --错误的mtkey
codes.USER_BANNED          = 0x9002 --用户被禁
codes.ROOM_ERR             = 0x9003 --登录桌子错误
codes.ROOM_FULL            = 0x9004 --房间旁观人数到达上限
codes.RECONN_TO_OTHER_ROOM = 0x9005 --重连进入不同的桌子
codes.SOMEONE_ELSE_RELOGIN = 0x9006 --账号被其他人登陆了
codes.MIN_USER_LEVEL_LIMIT = 0x9007 --等级不够
codes.SERVER_STOPPED       = 0x9008 --停服标志
codes.KICKED               = 0x9009 --被踢出
codes.KICKED_ENTER_AGAIN   = 0x900B --被踢出后10分钟之内再进
codes.WRONG_PASSWORD       = 0x810A --密码错误
codes.ROOM_NOT_EXISTS      = 0x810B --房间不存在
codes.NOT_ENOUGH_MONEY     = 0x9102 -- 钱不够

-- 坐下失败原因代码
consts.SVR_SIT_DOWN_FAIL_CODE = {}
codes = consts.SVR_SIT_DOWN_FAIL_CODE
codes.IP_LIMIT              = 0x9103 --同一IP不能坐下
codes.SELF_HAS_SAT_DOWN     = 0x9104
codes.NOT_ENOUGH_BUY_IN     = 0x9105 --买入不够
codes.ALL_MONEY_ERROR       = 7 --全部买入筹码和服务器金币不一致
codes.WRONG_SEAT_ID         = 9 --座位ID错误
codes.SEAT_NOT_EMPTY        = 8 --座位上已经有人了
codes.SELF_SAT_DOWN         = 0x9108 --自己已经坐下
codes.TOO_RICH              = 11 --钱太多不能进入新手场
codes.TOO_POOR              = 10 --钱不够，不能进入非新手场
codes.NO_OPER               = 0x9111 --三次没有操作

-- 下注失败原因代码
consts.SVR_BET_FAIL_CODE = {}
codes = consts.SVR_BET_FAIL_CODE
codes.WRONG_STATE    = 0x9301 --游戏状态错误
codes.NOT_YOUR_TURN  = 0x9302 --还没轮到用户下注
codes.NOT_IN_GAME    = 0x9303 --用户没有参与本轮游戏
codes.CANNOT_CHECK   = 0x9304 --不能看牌，有人加注了
codes.WRONG_BET_TYPE = 0x9305 --错误的下注类型
codes.PRE_BET        = 0x9306 --提前下注（开始server强行每个用户下相同数额的筹码数）

--赠送筹码失败原因代码
consts.SVR_SEND_CHIPS_FAIL_CODE = {}
codes = consts.SVR_SEND_CHIPS_FAIL_CODE
codes.NOT_ENOUGH_CHIPS     	= 0x9401 --钱数不够，不能赠送
codes.TOO_OFTEN         	= 0x9402 --太频繁
codes.TOO_MANY             	= 0x9403 --太多了

-- 操作类型
consts.SVR_BET_STATE = {}
local states = consts.SVR_BET_STATE

states.WAITTING_START = 8 --等待开始
states.WAITTING_BET   = 0 --等待下注
states.FOLD           = 4 --弃牌
states.ALL_IN         = 5 --all in
states.CALL           = 2 --跟注
states.SMALL_BLIND    = 6 --小盲
states.BIG_BLIND      = 7 --大盲
states.CHECK          = 1 --看牌
states.RAISE          = 3 --加注
states.PRE_CALL       = 9 --前注  //Server帮下注
states.WAITTING_DROP  = 10 -- 等待丢牌

consts.SVR_GAME_STATUS = {}
states = consts.SVR_GAME_STATUS

states.CAN_NOT_START       = 0 --人不够还没开始 stop
states.DEAL_CARD_ANI_2     = 1 --发牌动画1（手牌） (0.5*2*n)
states.BET_ROUND_1         = 2 --发完手牌，第一轮下注开始
states.DEAL_CARD_ANI_3     = 3 --发牌动画2（前三张公共牌）  + 1(筹码动画) + 3*0.5
states.BET_ROUND_2         = 4 --已经发了第三张牌，正在第二轮下注
states.DEAL_CARD_ANI_4     = 5 --发牌动画3（第四张公共牌）  + 0 | 1(筹码动画) + 1*0.5
states.BET_ROUND_3         = 6 --已经发了第四张牌，正在第三轮下注
states.DEAL_CARD_ANI_5     = 7 --发牌动画4（第五张公共牌） + 0 | 1(筹码动画) + 1*0.5
states.BET_ROUND_4         = 8 --已经发了第五张牌，正在第四轮下注
states.DELAY_GAME_OVER     = 9 -- 延迟结束  
states.READY_TO_START      = 10 --本轮游戏结束，播放结算动画  + 0 | 1(筹码动画) + 5（亮牌：2；移动座位: 1; ) + 1：停顿时间
states.COLLECT_CHIPS_ANI   = 11  -- 播放玩家收筹码动画
states.WAIT_FOLD_CARD      = 999 -- 等待玩家弃牌  暂时没用

-- 房间打牌操作类型
consts.CLI_BET_TYPE = {}
local types = consts.CLI_BET_TYPE
types.FOLD  = 4  --弃牌
types.CHECK = 1  --看牌
types.CALL  = 2  --跟注
types.ALL_IN = 5 --ALLIN
types.RAISE = 3  --加注

-- 房间类型
consts.ROOM_TYPE = {}
types = consts.ROOM_TYPE
types.NORMAL     = 1 -- 普通场
types.PRO        = 2 -- 专业场
types.TOURNAMENT = 3 -- 锦标赛
types.TYPE_4K    = 4
types.TYPE_5K    = 5
-- types.KNOCKOUT   = 4 -- 淘汰赛
-- types.PROMOTION  = 5 -- 晋级赛

consts.CARD_TYPE = {}
types = consts.CARD_TYPE
types.HIGH_CARD 		= 2 --高牌
types.PAIR 				= 3 --一对
types.TWO_PAIRS 		= 4 --两对
types.THREE_KIND     	= 5 --三条
types.STRAIGHT         	= 6 --顺子
types.FLUSH         	= 7 --同花
types.FULL_HOUSE    	= 8 -- 葫芦
types.FOUR_KIND     	= 9 --四条
types.STRAIGHT_FLUSH	= 10 --同花顺
types.ROYAL_FLUSH		= 11 -- 皇家同花顺

consts.AD_TYPE = {}
types = consts.AD_TYPE
types.AD_START 				= 1
types.AD_REG 				= 2
types.AD_LOGIN 				= 3
types.AD_PLAY 				= 4
types.AD_PAY 				= 5
types.AD_CUSTOM 			= 6
types.AD_RECALL 			= 7
types.AD_LOGOUT 			= 8
types.AD_SHARE 				= 9
types.AD_INVITE 			= 10
types.AD_PURCHASE_CANCEL 	= 11

-- 推送类型
consts.PUSH_TYPE = {}
types = consts.PUSH_TYPE
types.PUSH_INVITE_PLAY 	= 1 -- 邀请打牌
types.INVITE_CODE 		= 2 -- 邀请码
types.EXCHANGE_CODE 	= 3 -- 兑换码
types.LUCKTURN 			= 4 -- 大转盘
return consts