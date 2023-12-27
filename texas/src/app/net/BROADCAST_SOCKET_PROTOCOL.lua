local P = {}

-- personal
P.SVR_ADD_SIT_EXP           = 0x1004    -- 坐下加经验
P.SVR_MODIFY_USER_ASSET     = 0x1007    -- 修改个人筹码、经验值、钻石
P.SVR_MODIFY_USER_PROP     	= 0x1008    -- 修改个人道具
P.SVR_MESSAGE_CENTER		= 0x1009    -- 消息中心
P.SVR_TASK_REWARD_CHANGE    = 0x1010    -- 每日任务有可以领取奖励会广播
P.SVR_PAY_SUCCESS           = 0x100D    -- 购买商品支付成功
P.SVR_ACT_STATE             = 0x1015    -- 个人完成活动
P.SVR_VIP_LIGHT             = 0x6003    -- vip点亮
P.SVR_INVITE_PLAY		 	= 0x1011	-- 邀请打牌
P.SVR_PLAY_CARD_ACT_REWARD  = 0x1013    -- 玩牌活动,领奖通知
P.SVR_MODIFY_USER_AVATAR  	= 0x1014    -- 修改个人头像

-- system
P.SVR_BIG_SLOT_REWARD    	= 0x2003    -- 老虎机大奖提示
P.SVR_BIG_LABA           	= 0x2006    -- 大喇叭消息
P.SVR_SERVER_STOP        	= 0x4001    -- 服务器停服
P.SVR_GOLD_ISLAND_WIN    	= 0x5001    -- 全服广播夺金岛中奖
P.SVR_GOLD_ISLAND_CUR_POOL  = 0x5002    -- 全服广播夺金岛奖池钱数
P.SVR_GOLD_ISLAND_BET_POOL  = 0x5003    -- 全服广播夺金岛下注成功以后，奖池改变

return P
