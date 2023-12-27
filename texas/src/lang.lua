local L = {}
local T, T1

L.COMMON        = {}
L.LOGIN         = {}
L.HALL          = {}
L.ROOM          = {}
L.STORE         = {}
L.USERINFO      = {}
L.FRIEND        = {}
L.RANKING       = {}
L.MESSAGE       = {}
L.SETTING       = {}
L.LOGINREWARD   = {}
L.HELP          = {}
L.UPDATE        = {}
L.ABOUT         = {}
L.DAILY_TASK    = {}
L.COUNTDOWNBOX  = {}
L.NEWESTACT     = {}
L.FEED          = {}
L.ECODE         = {}
L.LUCKTURN      = {}
L.SLOT          = {}
L.GIFT          = {}
L.CRASH         = {}
L.MATCH         = {}
L.E2P_TIPS      = {}
L.VIP           = {}
L.WINORLOSE     = {}
L.PRIVTE        = {}
L.ACT           = {}
L.REDBLACK      = {}
L.TUTORIAL      = {}
L.TIPS          = {}
L.SAFE          = {}
L.GOLDISLAND    = {}
L.CHECKOUTGUIDE = {}
L.BIND          = {}
L.PAYGUIDE      = {}

-- tips
L.TIPS.ERROR_INVITE_FRIEND = "邀请好友失败"
L.TIPS.ERROR_TASK_REWARD = "领取任务奖励失败"
L.TIPS.ERROR_SEND_FRIEND_CHIP = "送筹码给朋友失败"
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "送朋友给筹码异常"
L.TIPS.ERROR_BUY_GIFT = "赠送礼物失败"
L.TIPS.ERROR_LOTTER_DRAW = "神秘礼盒领奖失败"
L.TIPS.EXCEPTION_LOTTER_DRAW = "砸金蛋剩余次数不够"
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "登录房间失败"
L.TIPS.ERROR_LOGIN_FACEBOOK = "FaceBook登录失败"
L.TIPS.ERROR_LOGIN_FAILED = "登录失败"
L.TIPS.ERROR_QUICK_IN = "获取房间信息失败"
L.TIPS.EXCEPTION_QUICK_IN = "获取房间信息异常"
L.TIPS.ERROR_SEND_FEEDBACK = "服务器错误或网络链接超时，发送反馈失败！"
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "服务器错误,发送反馈失败"
L.TIPS.ERROR_MATCH_FEEDBACK = "反馈比赛场错误失败"
L.TIPS.EXCEPTION_ACT_LIST = "服务器错误，加载活动数据失败"
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "校验密码：服务器错误"
L.TIPS.ERROR_BACK_CHECK_PWD = "服务器错误或网络链接超时，校验密码失败"
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "反馈图片上传失败！"
L.TIPS.ERROR_LEVEL_UP_REWARD = "服务器错误或网络超时，领取升级奖励失败"
L.TIPS.WARN_NO_PERMISSION = "您还不能使用此功能，请先到系统授权"
L.TIPS.VIP_GIFT = "VIP用户才能购买此礼物"
L.TIPS.KAOPU_TIPS = "游戏初始化失败,请重试"
L.TIPS.INPUT_NUMBER = "请输入纯数字"
L.TIPS.INPUT_NO_EMPTY = "输入不能为空"

-- COMMON MODULE
L.COMMON.LEVEL = "等级: "
L.COMMON.ASSETS = "${1}"
L.COMMON.CONFIRM = "确定"
L.COMMON.CANCEL = "取消"
L.COMMON.AGREE = "同意"
L.COMMON.REJECT = "拒绝"
L.COMMON.RETRY = "重连"
L.COMMON.NOTICE = "温馨提示"
L.COMMON.BUY = "购买"
L.COMMON.SEND = "发送"
L.COMMON.BAD_NETWORK = "网络连接中断，请检查您的网络连接是否正常."
L.COMMON.REQUEST_DATA_FAIL = "网络连接中断，请检查您的网络连接是否正常，点击重连按钮重新连接。"
L.COMMON.ROOM_FULL = "现在该房间旁观人数过多，请换一个房间"
L.COMMON.USER_BANNED = "您的账户被冻结了，请你反馈或联系管理员"
L.COMMON.SHARE = "分  享"
L.COMMON.GET_REWARD = "领取奖励"
L.COMMON.BUY_CHAIP = "购买"
L.COMMON.SYSTEM_BILLBOARD = "官方公告"
L.COMMON.DELETE = "删除"
L.COMMON.CHECK = "查看"
L.COMMON.CONGRATULATIONS = "恭喜你"
L.COMMON.REWARD_TIPS = "恭喜您获得了{1}"
L.COMMON.GET = "领取"
L.COMMON.CLICK_GET = "点击领取"
L.COMMON.ALREADY_GET = "已领取"
L.COMMON.NEXT_GET = "下次领取"
L.COMMON.LOGOUT = "登出"
L.COMMON.LOGOUT_DIALOG_TITLE = "确认退出登录"
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "您的筹码不足最小买入{1},请补充筹码后重试。"
L.COMMON.USER_SILENCED_MSG = "您的帐号已被禁言，您可以在帮助-反馈里联系管理员处理"
L.COMMON.USER_NEED_RELOGIN = "操作失败，请重新登录再试，或者联系客服"
L.COMMON.BLIND_BIG_SMALL = "盲注:{1}/{2}"
L.COMMON.NOT_ENOUGH_DIAMONDS = "对不起，您的钻石不足!"
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "您的筹码不足，请充值后重试"
L.COMMON.NOT_FINISH = "未完成"

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE = "确认退出"
L.COMMON.QUIT_DIALOG_MSG = "真的确认退出游戏吗？人家好舍不得滴啦~\\(≧▽≦)/~"
L.COMMON.QUIT_DIALOG_MSG_A = "确定要退出了吗?\n明天登录还可以领取更多奖励哦。"
L.COMMON.QUIT_DIALOG_CONFIRM = "忍痛退出"
L.COMMON.QUIT_DIALOG_CANCEL = "我点错了"
L.COMMON.GAME_NAMES = {
    [1] = "德州扑克",
    [2] = "比赛场",
    [3] = "奥马哈",
    [4] = "德州百人场",
    [5] = "德州必下场",
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "新用户前三次登录,可以免费领取超值幸运注册大礼包.\nFaceBook登录用户领取更高奖励哦!"
L.LOGIN.FB_LOGIN = "FB账户登录"
L.LOGIN.GU_LOGIN = "游客账户登录"
L.LOGIN.REWARD_SUCCEED = "领取奖励成功"
L.LOGIN.REWARD_FAIL = "领取失败"
L.LOGIN.LOGINING_MSG = "正在登录游戏..."
L.LOGIN.CANCELLED_MSG = "登录已经取消"
L.LOGIN.DOUBLE_LOGIN_MSG = "您的账户在其他地方登录"
L.LOGIN.LOGIN_DEALING = "正在处理登陆,请耐心等待"
L.LOGIN.INIT_SDK = "游戏正在初始化,请耐心等待."

-- HALL MODULE
L.HALL.USER_ONLINE = "当前在线人数: {1}"
L.HALL.INVITE_TITLE = "邀请好友"
L.HALL.INVITE_FAIL_SESSION = "获取Facebook信息失败，请重试"
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "你输入的房间号码有误"
L.HALL.MATCH_NOT_OPEN = "比赛场将尽快开放"
L.HALL.NOT_TRACK_TIPS = "暂不在线,无法追踪"
L.HALL.TEXAS_LIMIT_LEVEL = "您的等级不足{1}级，请先玩牌升级后再来!"
L.HALL.TEXAS_GUIDE_TIPS_1 = "您已经是高手了,不要在新手场虐菜了!"
L.HALL.TEXAS_GUIDE_TIPS_2 = "您已经是高手了,可以去适合您的大场赢钱更多."
L.HALL.TEXAS_GUIDE_TIPS_3 = "恭喜您!您的筹码已经上升到一个新的高度,是否立即换到更高级的场玩牌?"
L.HALL.TEXAS_UPGRADE = "立即提升"
L.HALL.TEXAS_STILL_ENTER = "依旧进入"
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
    "初级场", ---初级场
    "中级场", ---中级场
    "高级场",----高级场
}
L.HALL.PLAYER_LIMIT_TEXT = {
    "9\n人",
    "6\n人"
}
L.HALL.CHOOSE_ROOM_TYPE = {
    "普通场",
    " 快速场",
}

L.HALL.CHOOSE_ROOM_CITY_NAME = {
    "曼谷",
    "首尔",
    "吉隆坡",
    "上海",

    "莫斯科",
    "东京",
    "米兰",
    "巴黎",
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "最小{1}/最大{2}"
L.HALL.CHOOSE_ROOM_BLIND = "盲注:{1}/{2}"
L.HALL.GIRL_SHORT_CHAT = {
    "你好，我是荷官，我叫小爱。",
    "我在游戏房间等你哦~",
    "我们的游戏很好玩的，经常来玩吧。",
    "讨~厌~啦~你在做什么？",
    "亲爱的快去打牌吧。",
    "喜欢吗？那就去粉丝页点个赞。",
    "你好可爱，祝你好运。",
    "么么哒~ ~(￣3￣)|~",
    "别忘了每天点击邀请好友一起来捧场哦！大量免费筹码赠送！",
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "您的等级不足{1}级，请先在德州场玩到{2}级后再来！"
L.HALL.OMAHA_HELP_TITLE = "奥马哈规则说明"
L.HALL.OMAHA_RULE = [[
玩家每次都会发到4张手牌，玩家必须使用2张且只能用2张手牌与5张公共牌中的3张牌组成最大牌型。
每手牌都包括组成的5张最大的牌型，牌型的大小同德州扑克一样，详情可参考牌桌左下角的牌型提示。

奥马哈更注重手中牌面的数字大小等。在奥马哈中，手牌值非常重要，因为最可能好的手牌常常胜出。

奥马哈与德州扑克的不同
1.奥马哈游戏开始发给每个玩家第4张底牌，而德州扑克游戏则是发给每个玩家2张底牌。
2.每一个玩家必须要用4张底牌中的2张底牌与3张公共牌组成一手最好的牌。
3.与德州扑克最多可以加入22个玩家相比，奥马哈游戏人数的上限为11个玩家。
]]
L.HALL.TRACE_LIMIT_LEVEL = "追踪失败,需要等级达到{1}级,才可以进入房间"
L.HALL.TRACE_LIMIT_ANTE = "追踪失败,需要携带{1}筹码,才可以进入房间"
L.HALL.OMAHA_ROOM_CITY_NAME = {
    "堪培拉",
    "悉尼",
    "西班牙",
    "加拿大",
}
L.HALL.TEXAS_MUST_ROOM_CITY_NAME = {
    "北京",
    "墨西哥",
    "蒙特卡洛",
    "拉斯维加斯",
}
L.HALL.TEXAS_MUST_TITLE = "必下"
L.HALL.TEXAS_MUST_HELP_TITLE = "德州必下场规则说明"
L.HALL.TEXAS_MUST_RULE = [[
必下场是一种全新的玩法，每位玩家需要在每局游戏一开始的时候投入5倍大盲的前注，底池将膨胀的更快，玩法更加刺激。

玩家进入游戏桌时带入的筹码为一个固定值。当入座玩家每局开始前筹码不够时，系统将自动帮他补充。
]]
L.HALL.SMALL_GAME = "小游戏"

-- ROOM MODULE
L.ROOM.OPR_TYPE = {
    "看  牌",
    "弃  牌",
    "跟  注",
    "加  注",
}
L.ROOM.MY_MONEY = "My money {1} {2}"
L.ROOM.INFO_UID = "ID {1}"
L.ROOM.INFO_LEVEL = "Lv.{1}"
L.ROOM.INFO_WIN_RATE = "胜率:  {1}%"
L.ROOM.INFO_SEND_CHIPS = "赠送筹码"
L.ROOM.ADD_FRIEND = "关注" 
L.ROOM.DEL_FRIEND = "取消关注"
L.ROOM.FORBID_CHAT = "屏蔽"
L.ROOM.CANCEL_FORBID_CHAT = "已屏蔽"
L.ROOM.NO_SEND_CHIP_TIPS = "不可赠送"
L.ROOM.ADD_FRIEND_SUCC_MSG = "添加好友成功"
L.ROOM.ADD_FRIEND_FAILED_MSG = "添加好友失败"
L.ROOM.DELE_FRIEND_SUCCESS_MSG = "删除好友成功"
L.ROOM.DELE_FRIEND_FAIL_MSG = "删除好友失败"
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "只有普通场才可以赠送筹码"
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "你的筹码不够多，不足给荷官小费"
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "坐下才可以赠送筹码"
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "钱不够啊"
L.ROOM.SEND_CHIP_TOO_OFTEN = "赠送的太频繁了"
L.ROOM.SEND_CHIP_TOO_MANY = "赠送的太多了"
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "比赛场不能发送互动道具"
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = "坐下才能发送互动道具"
L.ROOM.SEND_HDDJ_NOT_ENOUGH = "您的互动道具数量不足，赶快去商城购买吧"
L.ROOM.SEND_HDDJ_FAILED = "发送互动道具失败,请重试"
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = "坐下才可以发送表情"
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "您还未坐下，请坐下后重试"
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2}人)  房间号:{3}  盲注:{4}/{5}"
L.ROOM.PRIVATE_ROOM_INFO = "私人房({1}人)  房间号:{2}  盲注:{3}/{4}"
L.ROOM.PRIVTE_INFO = "房间剩余时间：{1}"
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "发送大喇叭消息失败"
L.ROOM.NOT_ENOUGH_LABA = "您的大喇叭不足"
L.ROOM.CHAT_MAIN_TAB_TEXT = {
    "消息", 
    "消息记录"
}
L.ROOM.USER_CARSH_REWARD_DESC = "您获得了{1}筹码的破产补助，终身只有三次机会获得，且用且珍惜"
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "您也可以立即购买，输赢只是转瞬的事"
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = "您已经领完所有破产补助，您可以去商城购买筹码，每天登录还有免费筹码赠送哦！"
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = "输赢乃兵家常事，不要灰心，立即购买筹码，重整旗鼓。"
L.ROOM.WAIT_NEXT_ROUND = "请等待下一局开始"
L.ROOM.LOGIN_ROOM_FAIL_MSG = "登录房间失败"
L.ROOM.BUYIN_ALL_POT= "全部奖池"
L.ROOM.BUYIN_3QUOT_POT = "3/4奖池"
L.ROOM.BUYIN_HALF_POT = "1/2奖池"
L.ROOM.BUYIN_TRIPLE = "3倍反加"
L.ROOM.CHAT_TAB_SHORTCUT = "快捷聊天"
L.ROOM.CHAT_TAB_HISTORY = "聊天记录"
L.ROOM.INPUT_HINT_MSG = "点击输入聊天内容"
L.ROOM.INPUT_ALERT = "请输入有效内容"
L.ROOM.CHAT_SHIELD = "您已成功屏蔽{1}的发言"
L.ROOM.CHAT_SHORTCUT = {
  "你们好! ",
  "快点，等不了了",
  "ALL IN！！",
  "冲动是魔鬼，淡定",
  "好厉害",
  "谁敢来比比",
  "谢谢你送我筹码",
  "和你玩牌真有意思",
  "有筹码任性",
  "今天有点背",
  "不要吵架",
  "有女/男朋友了吗",
  "牌不好，换房间试试",
  "多多关照",
  "今天手气不错",
  "送点钱吧",
  "求跟注，求ALL-IN！",
  "买点筹码再战！",
  "可以看看牌吗",
  "不好意思，先走了"
}
L.ROOM.VOICE_TOOSHORT = "录音时间太短了"
L.ROOM.VOICE_TOOLONG = "录音时间太长了"
L.ROOM.VOICE_RECORDING = "正在录音，上滑取消"
L.ROOM.VOICE_CANCELED = "录音已取消"
L.ROOM.VOICE_TOOFAST = "您操作太频繁啦"
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
    "感谢你{1}！幸运必将常伴你左右！",
    "感谢你{1}！好运即将到来！",
    "感谢好心的{1}",
}
--买入弹框
L.ROOM.BUY_IN_TITLE = "买入筹码"
L.ROOM.BUY_IN_BALANCE_TITLE = "您的账户余额:"
L.ROOM.BUY_IN_MIN = "最低买入"
L.ROOM.BUY_IN_MAX = "最高买入"
L.ROOM.BUY_IN_AUTO = "小于大盲时自动买入"
L.ROOM.BUY_IN_AUTO_MIN = "小于最小买入时自动买入"
L.ROOM.BUY_IN_BTN_LABEL = "买入坐下"
L.ROOM.ADD_IN_TITLE = "增加筹码"
L.ROOM.ADD_IN_BTN_LABEL = "买 入"
L.ROOM.ADD_IN_BTN_TIPS = "坐下才能增加筹码"
L.ROOM.ADD_IN_BTN_TIPS_2 = "没有多余的筹码，无法增加"
L.ROOM.ADD_IN_BTN_TIPS_3 = "您的筹码已经达到场次上限，无法增加更多"
L.ROOM.ADD_IN_SUC_TIPS = "增加成功，将在下局开始为您自动增加{1}筹码"
L.ROOM.BACK_TO_HALL = "返回大厅"
L.ROOM.CHANGE_ROOM = "换  桌"
L.ROOM.SETTING = "设  置"
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "您的筹码不足当前房间的最小携带，您可以点击换桌系统帮你选择房间或者补足筹码重新坐下。"
L.ROOM.AUTO_CHANGE_ROOM = "换  桌"
L.ROOM.USER_INFO_ROOM = "个人信息"
L.ROOM.CHARGE_CHIPS = "补充筹码"
L.ROOM.ENTERING_MSG = "正在进入，请稍候...\n有识尚需有胆方可成赢家"
L.ROOM.OUT_MSG = "正在退出，请稍候..."
L.ROOM.CHANGING_ROOM_MSG = "正在更换房间.."
L.ROOM.CHANGE_ROOM_FAIL = "更换房间失败，是否重试？"
L.ROOM.STAND_UP_IN_GAME_MSG = "您还在当前牌局中，确认站起吗？"
L.ROOM.LEAVE_IN_GAME_MSG = "您还在当前牌局中，确认要离开吗？"
L.ROOM.RECONNECT_MSG = "正在重新连接.."
L.ROOM.OPR_STATUS = {
    "弃  牌",
    "ALL_IN",
    "跟  注",
    "跟注 {1}",
    "小  盲",
    "大  盲",
    "看  牌",
    "加注 {1}",
    "加  注",
}
L.ROOM.AUTO_CHECK = "自动看牌"
L.ROOM.AUTO_CHECK_OR_FOLD = "看或弃"
L.ROOM.AUTO_FOLD = "自动弃牌"
L.ROOM.AUTO_CALL_ANY = "跟任何注"
L.ROOM.FOLD = "弃  牌"
L.ROOM.ALL_IN = "ALL IN"
L.ROOM.CALL = "跟  注"
L.ROOM.CALL_NUM = "跟注 {1}"
L.ROOM.SMALL_BLIND = "小盲"
L.ROOM.BIG_BLIND = "大盲"
L.ROOM.RAISE = "加  注"
L.ROOM.RAISE_NUM = "加注 {1}"
L.ROOM.CHECK = "看  牌"
L.ROOM.BLIND3 = "3x大盲"
L.ROOM.BLIND4 = "4x大盲"
L.ROOM.TABLECHIPS = "1x底池"
L.ROOM.TIPS = {
    "小提示：游客用户点击自己的头像弹框或者性别标志可更换头像和性别哦",
    "小经验：当你牌比对方小的时候，你会输掉已经押上的所有筹码",
    "高手养成：所有的高手，在他会德州游戏之前，一定是一个德州游戏的菜鸟",
    "有了好牌要加注，要掌握优势，主动进攻。",
    "留意观察对手，不要被对手的某些伎俩所欺骗。",
    "要打出气势，让别人怕你。",
    "控制情绪，赢下该赢的牌。",
    "游客玩家可以自定义自己的头像。",
    "小提示：设置页可以设置进入房间是否自动买入坐下。",
    "小提示：设置页可以设置是否震动提醒。",
    "忍是为了下一次All In。",
    "冲动是魔鬼，心态好，好运自然来。",
    "风水不好时，尝试换个位置。",
    "输牌并不可怕，输掉信心才是最可怕的。",
    "你不能控制输赢，但可以控制输赢的多少。",
    "用互动道具砸醒长时间不反应的玩家。",
    "运气有时好有时坏，知识将伴随你一生。",
    "诈唬是胜利的一大手段，要有选择性的诈唬。",
    "下注要结合池底，不要看绝对数字。",
    "All In是一种战术，用好并不容易。",
    








    
}
L.ROOM.SHOW_HANDCARD = "亮出手牌"
L.ROOM.SERVER_UPGRADE_MSG = "服务器正在升级中，请稍候.."
L.ROOM.KICKED_BY_ADMIN_MSG = "您已被管理员踢出该房间"
L.ROOM.KICKED_BY_USER_MSG = "您被用户{1}踢出了房间"
L.ROOM.TO_BE_KICKED_BY_USER_MSG = "您被用户{1}踢出房间，本局结束之后将自动返回大厅"
L.ROOM.BET_LIMIT = "下注失败，您单局下注不能超过最大下注100M限制。"
L.ROOM.BET_LIMIT_1 = "下注失败，您单局下注不能超过最大下注{1}限制。"
L.ROOM.NO_BET_STAND_UP = "你三局未操作,已自动站起"
L.ROOM.PRE_BLIND = "前注"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "坐下失败，同一IP不能坐下"
T["SEAT_NOT_EMPTY"] = "坐下失败，该桌位已经有玩家坐下。"
T["TOO_RICH"] = "坐下失败，这么多筹码还来新手场虐人？"
T["TOO_POOR"] = "坐下失败，筹码不足无法进入非新手场房间。"
T["NO_OPER"] = "您超过三次没有操作，已被自动站起，重新坐下即可重新开始"
L.ROOM.SERVER_STOPPED_MSG = "系统正在停服维护, 请耐心等候"
L.ROOM.GUIDEHEIGHT = "去{1}场可赢更多钱"
L.ROOM.GUIDELOW = "去{1}场可以较少损失"
L.ROOM.CARD_POWER_DESC = [[
牌力指示器仅基于玩家手牌和底池综合计算得出的胜率,仅供参考

初级场免费使用,开通任意VIP即可免费在任意场无限制使用

默认开启您也可以手动关闭,关闭后还可以从设置里再次打开
]]

--STORE
L.STORE.TOP_LIST = {
    "筹码",
    "钻石",
    "道具",
    "VIP"
}
L.STORE.NOT_SUPPORT_MSG = "您的账户暂不支持支付"
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "已支付成功，正在进行发货，请稍候.."
L.STORE.PURCHASE_CANCELED_MSG = "支付已经取消"
L.STORE.PURCHASE_FAILED_MSG = "支付失败，请重试"
L.STORE.PURCHASE_FAILED_MSG_2 = "请输入正确卡号和密码"
L.STORE.PURCHASE_FAILED_MSG_3 = "此卡已经使用过"
L.STORE.PURCHASE_FAILED_MSG_4 = "此卡无效"
L.STORE.DELIVERY_FAILED_MSG = "网络故障，系统将在您下次打开商城时重试。"
L.STORE.DELIVERY_SUCC_MSG = "发货成功，感谢您的购买。"
L.STORE.TITLE_STORE = "商城"
L.STORE.TITLE_CHIP = "筹码"
L.STORE.TITLE_PROP = "互动道具"
L.STORE.TITLE_MY_PROP = "我的道具"
L.STORE.TITLE_HISTORY = "购买记录"
L.STORE.RATE_DIAMONDS = "1{2}={1}钻石"
L.STORE.RATE_CHIP = "1{2}={1}筹码"
L.STORE.RATE_PROP = "1{2}={1}个道具"
L.STORE.FORMAT_DIAMONDS = "{1} 钻石"
L.STORE.FORMAT_CHIP = "{1} 筹码"
L.STORE.FORMAT_PROP = "{1} 道具"
L.STORE.FORMAT_HDDJ = "{1} 互动道具"
L.STORE.FORMAT_DLB = "{1} 大喇叭"
L.STORE.FORMAT_LPQ = "{1} 礼品券"
L.STORE.FORMAT_DHQ = "{1} 兑换券"
L.STORE.FORMAT_MYB = "{1} 开源币"
L.STORE.HDDJ_DESC = "可在牌桌上对玩家使用{1}次互动道具"
L.STORE.DLB_DESC = "可在牌桌聊天弹框对全服的玩家发送{1}次广播"
L.STORE.BUY = "购买"
L.STORE.USE = "使用"
L.STORE.BUY_DESC = "购买 {1}"
L.STORE.RECORD_STATUS = {
    "已下单",
    "已发货",
    "已退款"
}
L.STORE.NO_PRODUCT_HINT = "暂无商品"
L.STORE.NO_BUY_HISTORY_HINT = "暂无支付记录"
L.STORE.BUSY_PURCHASING_MSG = "正在购买，请稍候.."
L.STORE.CARD_INPUT_SUBMIT = "TOP UP"
L.STORE.BLUEPAY_CHECK = "你确定要花{1}购买{2}吗?"
L.STORE.GENERATE_ORDERID_FAIL = "下单失败，请重试！"
L.STORE.INPUT_NUM_EMPTY = "卡号输入不能为空，请重新输入！"
L.STORE.INPUT_PASSWORD_EMPTY = "密码输入不能为空，请重新输入！"
L.STORE.INPUT_NUM_PASSWORD_EMPTY = "卡号或密码输入为空，请重新输入！"
L.STORE.INPUT_CRAD_NUM = "请输入卡号"
L.STORE.INPUT_CRAD_PASSWORD = "请输入密码"
L.STORE.QUICK_MORE = "查看更多"
L.STORE.REAL_TAB_LIST = {
    "礼品券",
    "兑换券",
    "开源币",
}
L.STORE.REAL_ADDRESS_BTN = "收货地址"
L.STORE.REAL_EXCHANGE_BTN = "兑换"
L.STORE.ADDRESS_POP_TITLE = "编辑收货地址"
L.STORE.REAL_TIPS = "请务必填写真实姓名和联系方式,以便获奖后联系"
L.STORE.REAL_TIPS_2 = "请把信息填写完整"
L.STORE.REAL_SAVE = "保存"
L.STORE.REAL_TITLES = {
    "收货人:",
    "手机号码:",
    "收货地址:",
    "邮编:",
    "电子邮箱:"
}
L.STORE.REAL_PLACEHOLDER = {
    "姓名",
    "手机号码",
    "请务必填写详细的省.市.区(县)及街道门牌信息",
    "邮编",
    "邮箱地址"
}
L.STORE.EXCHANGE_REAL_SUCCESS = "恭喜您,兑换{1}成功,我们会尽快给您发货!"
L.STORE.EXCHANGE_REAL_FAILED_1 = "你的{1}数量不足,兑换{2}需要{3}"
L.STORE.EXCHANGE_REAL_FAILED_2 = "兑换失败,请重试!"
L.STORE.TAB_LIST = {
    "商城",
    "礼品兑换"
}
L.STORE.CASH_CARD_TITLE = "兑换充值卡"
L.STORE.CASH_CARD_TIPS_1 = "请输入您的手机号码,务必真实有效的.\n我们将把充值卡的信息,发送到您填写的手机上."
L.STORE.CASH_CARD_TIPS_2 = "请输入您的手机号码"
L.STORE.CASH_CARD_TIPS_3 = "请输入10位由数字组成的电话号码"
L.STORE.CASH_CARD_TIPS_4 = "您输入的电话号码是{1}-{2}-{3},我们将向此号码发送充值卡的信息."

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "您的场外筹码不足5000，暂时无法使用VIP表情"
L.VIP.SEND_EXPRESSIONS_TIPS = "您还不是VIP用户,使用VIP表情需要扣除相应的筹码,成为VIP即可免费使用,还有超多优惠和特权."
L.VIP.BUY_PROP = "购买道具"
L.VIP.OPEN_VIP = "成为VIP"
L.VIP.COST_CHIPS = "花费{1}筹码"
L.VIP.LIST_TITLE = {
    "价格",
    -- "踢人卡",
    "VIP牌力指示器",
    "VIP礼物",
    "VIP道具",
    "VIP表情",
    -- "私人房折扣",
    -- "破产优惠",
    -- "经验",
    "每天登录",
    "立即赠送筹码",
}
L.VIP.NOT_VIP = "未购买"
L.VIP.AVAILABLE_DAYS = "剩余{1}天"
L.VIP.OPEN_BTN = "开通{1}钻石"
L.VIP.AGAIN_BTN = "续费{1}钻石"
L.VIP.CONTINUE_BUY = "继续购买"
L.VIP.BROKE_REWARD = "多送{1}% 每天{2}次"
L.VIP.LOGINREWARD = "{1}*31天"
L.VIP.PRIVATE_SALE = "优惠{1}%"
L.VIP.SEND_PROPS_TIPS_1 = "互动道具VIP免费任意使用"
L.VIP.SEND_PROPS_TIPS_2 = "您的互动道具已用完,您可以选择花费筹码使用,成为VIP即可免费使用,还有超多优惠和特权."
-- L.VIP.KICK_CARD = "踢人卡"
-- L.VIP.KICK_SUCC = "踢人成功，玩家将在本局结束后被提出牌桌。"
-- L.VIP.KICK_FAILED = "踢人失败,请稍后重试"
-- L.VIP.KICKED_TIP = "抱歉，您被玩家{1}踢出牌局，将在本局结束后离开此牌桌。"
-- L.VIP.KICKER_TOO_MUCH = "您当天的使用次数已达到上限，请遵守牌桌秩序，严禁恶意踢人。"
-- L.VIP.KICKED_ENTER_AGAIN = "您已被踢出此房间，20分钟内无法进入，你可以选择其他房间或者重新快速开始"
L.VIP.BUY_SUCCESS = "恭喜你,购买VIP成功!"
L.VIP.BUY_FAILED = "VIP购买失败,请重试"
L.VIP.BUY_FAILED_TIPS = "您的钻石不足,请先购买钻石!"
L.VIP.BUY_TIPS_1 = "您将购买{1},需要花费{2}钻石."
L.VIP.BUY_TIPS_2 = "您目前是{1}VIP还未到期,如果您选择继续购买,将放弃现在的{2}VIP的所有特权并立即成为{3}VIP,是否继续?"
L.VIP.BUY_TIPS_3 = "您现在是{1}VIP,将对此等级VIP服务进行续费,使用期限延长{2}天,需要花费{3}钻石."
L.VIP.LEVEL_NAME = {
    "领主",
    "贵族",
    "王族",
    "皇族"
}
L.VIP.NO_VIP_TIPS = "您还不是VIP用户,是否立即成为VIP,还有超多优惠和特权."
L.VIP.CARD_POWER_TIPS = "您还不是VIP用户,是否"
L.VIP.CARD_POWER_OPEN_VIP = "立即开通"
L.VIP.VIP_AVATAR = "VIP动态头像"
L.VIP.NOR_AVATAR = "普通头像"
L.VIP.SET_AVATAR_SUCCESS = "设置头像成功!"
L.VIP.SET_AVATAR_FAILED_1 = "设置头像失败,请重试."
L.VIP.SET_AVATAR_FAILED_2 = "您的VIP等级不够,请选择其他头像."
L.VIP.SET_AVATAR_TIPS = [[
您还不是VIP用户,只能预览头像效果,需要成为VIP后才可使用VIP专属头像,开通VIP可获赠大量免费筹码,充值优惠等一系列特权.

是否需要立即开通VIP？
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "Facebook登录领取"
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}"
L.LOGINREWARD.REWARD_BTN        = "领取{1}"
L.LOGINREWARD.GET_REWARD_FAILED = "签到失败，请重试!"
L.LOGINREWARD.VIP_REWARD_TIPS   = "VIP登录奖励"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2}" --经验值
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
    "常规场",
    "坐满即玩",
    "锦标赛"
}
L.USERINFO.BOARD_SORT = {
    "时间排序",
    "输赢排序"
}
L.USERINFO.NO_RECORD = "暂无记录"
L.USERINFO.LAST_GAME = "上一局"
L.USERINFO.NEXT_GAME = "下一局"
L.USERINFO.PLAY_TOTOAL_COUNT = "牌局: "
L.USERINFO.PLAY_START_RATE = "入局率: "
L.USERINFO.WIN_TOTAL_RATE = "胜率: "
L.USERINFO.SHOW_CARD_RATE = "摊牌率: "
L.USERINFO.MAX_CARD_TYPE = "最大牌型"
L.USERINFO.JOIN_MATCH_NUM = "参赛次数"
L.USERINFO.GET_REWARD_NUM = "获奖次数"
L.USERINFO.MATCH_BEST_SCORE = "锦标赛最好成绩"
L.USERINFO.MY_CUP = "我的奖杯"
L.USERINFO.NO_CHECK_LINE = "未填写"
L.USERINFO.BOARD = "牌局记录"
L.USERINFO.MY_PACK = "我的背包"
L.USERINFO.ACHIEVEMENT_TITLE = "成就"
L.USERINFO.REAL_STORE = "礼品兑换"
L.USERINFO.LINE_CHECK_NO_EMPTY = "Line号不能为空！请重新输入"
L.USERINFO.NICK_NO_EMPTY = "名字不能为空！请重新输入"
L.USERINFO.LINE_CHECK_ONECE = "一天只能提交一次Line认证"
L.USERINFO.LINE_CHECK_FAIL = "提交认证失败，请重试!"
L.USERINFO.LINE_CHECK_SUCCESS = "提交认证成功"
L.USERINFO.GET_BOARD_RECORD_FAIL = "获取个人战绩信息失败，请关闭弹窗重试！"
L.USERINFO.PACKAGE_INFO = {
    {
        title = "互动道具",
        desc = "可以在牌桌上对其他玩家释放的互动道具"
    },
    {
        title = "大喇叭",
        desc = "可以在牌桌上对全服的玩家进行广播"
    },
    {
        title = "兑换券",
        desc = "可花费多张劵兑换相应的礼品"
    },
    {
        title = "礼品券",
        desc = "可直接兑换券上相应的礼品"
    },
    {
        title = "开源币",
        desc = "非常有价值的一种数字货币"
    },
}
L.USERINFO.MARK_TEXT = {
    "跟注站",
    "疯子",
    "紧凶型",
    "紧弱型",
    "岩石型",
    "黄色警报",
    "松弱鱼",
    "自定义"
}
L.USERINFO.MARK_TITLE = "标记玩家"
L.USERINFO.MARK_TIPS = "点击选中标记"
L.USERINFO.MARK_SUCCESS = "标记玩家成功"
L.USERINFO.MARK_FAIL = "标记玩家失败，请重试"
L.USERINFO.MARK_NO_EMPTY = "玩家标记输入不能为空，请重新输入"
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "没有安装SD卡，无法使用头像上传功能"
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "获取图像失败"
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "上传头像失败，请稍后重试"
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "正在上传头像，请稍候..."
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "上传头像成功"
L.USERINFO.CHOOSE_COUNTRY_TITLE = "选择国家"
L.USERINFO.COUNTRY_LIST = {
    {
        title = "亚洲",
        list = {
            "阿联酋",
            "澳门",
            "巴基斯坦",
            "菲律宾",
            "哈萨克斯坦",
            "韩国",
            "老挝",
            "马来西亚",
            "缅甸",
            "日本",
            "台湾",
            "泰国",
            "香港",
            "新加坡",
            "以色列",
            "印度",
            "印度尼西亚",
            "越南",
            "中国",
        }
    },
    {
        title = "北美洲",
        list = {
            "巴拿马",
            "哥斯达黎加",
            "古巴",
            "加拿大",
            "美国",
            "墨西哥",
        }
    },
    {
        title = "南美洲",
        list = {
            "阿根廷",
            "巴拉圭",
            "巴西",
            "哥伦比亚",
            "秘鲁",
            "委内瑞拉",
            "乌拉圭",
            "智利",
        }
    },
    {
        title = "欧洲",
        list = {
            "奥地利",
            "白俄罗斯",
            "比利时",
            "波兰",
            "德国",
            "俄罗斯",
            "法国",
            "芬兰",
            "荷兰",
            "捷克",
            "克罗地亚",
            "立陶宛",
            "罗马尼亚",
            "摩纳哥",
            "葡萄牙",
            "瑞典",
            "瑞士",
            "塞尔维亚",
            "斯洛文尼亚",
            "乌克兰",
            "西班牙",
            "希腊",
            "匈牙利",
            "意大利",
            "英国",
        }
    },
    {
        title = "大洋洲",
        list = {
            "澳大利亚",
            "新西兰",
        }
    },
    {
        title = "非洲",
        list = {
            "刚果",
            "加纳",
            "津巴布韦",
            "南非",
            "尼日利亚",
            "塞内加尔",
        }
    },
}

-- FRIEND MODULE
L.FRIEND.TITLE = "好友"
L.FRIEND.NO_FRIEND_TIP = "暂无好友"
L.FRIEND.SEND_CHIP = "赠送筹码"
L.FRIEND.RECALL_CHIP = "召回+{1}"
L.FRIEND.ONE_KEY_SEND_CHIP = "一键赠送"
L.FRIEND.ONE_KEY_RECALL = "一键召回"
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "您的携带筹码的一半不足全部送出，请先补充筹码后重试。"
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "确定要赠你给您的{1}位好友总计{2}筹码吗？"
L.FRIEND.ADD_FULL_TIPS = "您的好友已达到{1}的上限，系统将根据玩牌情况删除长久不玩牌的好友。"
L.FRIEND.SEND_CHIP_WITH_NUM = "赠送{1}筹码"
L.FRIEND.SEND_CHIP_SUCCESS = "您成功给好友赠送了{1}筹码。"
L.FRIEND.SEND_CHIP_PUSH = "{1} 赠送了10K筹码给你，快来领取吧！"
L.FRIEND.SEND_CHIP_TOO_POOR = "您的筹码太少了，请去商城购买筹码后重试。"
L.FRIEND.SEND_CHIP_COUNT_OUT = "您今天已经给该好友赠送过筹码了，请明天再试。"
L.FRIEND.SELECT_ALL = "全选"
L.FRIEND.SELECT_NUM = "选择{1}人"
L.FRIEND.DESELECT_ALL = "取消选择"
L.FRIEND.SEND_INVITE = "邀请"
L.FRIEND.INVITE_SENDED = "已邀请"
L.FRIEND.INVITE_SUBJECT = "您绝对会喜欢"
L.FRIEND.CALL_FRIEND_TO_GAME = "来玩牌吧！很好玩的游戏"
L.FRIEND.INVITE_CONTENT = "为您推荐一个既刺激又有趣的扑克游戏，我给你赠送了15万的筹码礼包，注册即可领取，快来和我一起玩吧！"..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP = "您已选择了{1}位好友，发送邀请即可获得{2}筹码的奖励"
L.FRIEND.INVITE_SELECT_TIP_1 = "您已选择了"
L.FRIEND.INVITE_SELECT_TIP_2 = "位好友，发送邀请即可获得"
L.FRIEND.INVITE_SELECT_TIP_3 = "筹码的奖励"
L.FRIEND.INVITE_SUCC_TIP = "成功发送了邀请，获得{1}筹码的奖励！"
L.FRIEND.INVITE_SUCC_FULL_TIP = "成功发送邀请，今日已获得{1}邀请发送奖励。"
L.FRIEND.INVITE_FULL_TIP = "Facebook邀请已达上限，您可以选择旁边的邀请码邀请获得更多奖励"
L.FRIEND.RECALL_SUCC_TIP = "发送成功奖励{1}，好友上线后即可获赠{2}筹码奖励。"
L.FRIEND.RECALL_FAILED_TIP = "发送失败，请稍后重试."
L.FRIEND.INVITE_LEFT_TIP = "今天还可以邀请{1}个好友！"
L.FRIEND.CANNOT_SEND_MAIL = "您还没有设置邮箱账户，现在去设置吗？"
L.FRIEND.CANNOT_SEND_SMS = "对不起，无法调用发送短信功能！"
L.FRIEND.MAIN_TAB_TEXT = {
    "我关注的",
    "关注我的",
    "更多好友"
}
L.FRIEND.INVITE_EMPTY_TIP = "请先选择好友"
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "您的好友已达到{1}上限，请删除部分后重新添加"
L.FRIEND.SEARCH_FRIEND = "请输入FB好友名称"
L.FRIEND.INVITE_REWARD_TIPS_1 = "邀请"
L.FRIEND.INVITE_REWARD_TIPS_2 = "位好友可获得"
L.FRIEND.INVITE_REWARD_TIPS_3 = ",好友越多奖励越多,每位好友成功登录游戏还可以再获得"
L.FRIEND.SEARCH = "查找"
L.FRIEND.CLEAR = "清除"
L.FRIEND.INPUT_USER_ID = "点击输入玩家ID"
L.FRIEND.INPUT_USER_ID_NO_EXIST = "您输入的ID不存在，请确认后重新输入"
L.FRIEND.NO_SEARCH_SELF = "无法查找自己的ID，请重新输入"
L.FRIEND.NO_LINE_APP = "您没有安装Line应用,请使用其他方式邀请"
L.FRIEND.INVITE_REWARD_TIPS = "达成邀请人数还有超级大礼包赠送，可点击礼包查看详情\n您累计成功邀请了{1}位好友，获得了{2}的筹码奖励"
L.FRIEND.INVITE_FB_FRIEND_TITLE = "邀请FB好友"
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "每天发送就送{1}\n成功一个再送{2}筹码"
L.FRIEND.INVITE_CODE_TITLE = "邀请码"
L.FRIEND.INVITE_CODE_CONTENT = "成功就送{1}\n好友的好友再送{2}"
L.FRIEND.GET_REWARD_TIPS_1 = "恭喜您获得了邀请奖励!"
L.FRIEND.GET_REWARD_TIPS_2 = "您还差{1}人才能领取奖励，点击邀请按钮继续邀请您的好友吧!"
L.FRIEND.ROOM_INVITE_TITLE = "邀请打牌"
L.FRIEND.ROOM_INVITE_SUCCTIPS = "邀请已发出，请耐心等待"
L.FRIEND.ROOM_INVITE_TAB = {
    "当前在线",
    "好友"
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1}邀请您去{2}{3}一起玩牌"
L.FRIEND.ROOM_INVITE_PLAY_DES = "独乐乐不如与众乐乐，您可以点击下面的按钮发送链接发送给好友或者群里邀请大家一起来玩。\n\n好友安装后点击或者刷新页面即可直接进入房间。"

-- RANKING MODULE
L.RANKING.TITLE = "排行榜"
L.RANKING.TRACE_PLAYER = "追踪玩家"
L.RANKING.GET_REWARD_BTN = "领取"
L.RANKING.NOT_DATA_TIPS = "暂无数据"
L.RANKING.NOT_IN_CHIP_RANKING = "您的排名:>20名,您暂时未进入排行榜，请继续加油!"
L.RANKING.IN_RANKING = "您的排名:第{1}名，再接再厉！"
L.RANKING.IN_RANKING_NO_1 = "您的排名：第1名，无敌是多么寂寞！"
L.RANKING.MAIN_TAB_TEXT = {
    "好友排行",
    "世界排行",
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
    "昨日盈利榜",
    "财富榜",
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
    "昨日盈利榜",
    "财富榜",
}

-- SETTING MODULE
L.SETTING.TITLE = "设置"
L.SETTING.NICK = "昵称"
L.SETTING.LANGUAGE = "语言"
L.SETTING.EXCHANGE = "兑换码"
L.SETTING.LOGOUT = "登出"
L.SETTING.FB_LOGIN = "登录 +19999"
L.SETTING.SOUND_VIBRATE = "声音和震动"
L.SETTING.SOUND = "声音"
L.SETTING.BG_SOUND = "背景音效"
L.SETTING.CHATVOICE = "聊天音效"
L.SETTING.VIBRATE = "震动"
L.SETTING.AUTO_SIT = "进入房间自动坐下"
L.SETTING.AUTO_BUYIN = "小于大盲时自动买入"
L.SETTING.CARD_POWER = "牌力指示器"
L.SETTING.APP_STORE_GRADE = "喜欢我们，打分鼓励"
L.SETTING.CHECK_VERSION = "检测更新"
L.SETTING.CURRENT_VERSION = "当前版本号：V{1}"
L.SETTING.ABOUT = "关于"
L.SETTING.PUSH_NOTIFY = "推送通知"
L.SETTING.PUSH_TIPS = [[
系统每天会随机赠送大量免费筹码，先到先得抢完为止，
开启后可以直接点击抢钱快人一步。

点击确定按钮,找到通知管理-打开通知,即可领取免费兑换码.
]]

--HELP
L.HELP.TITLE = "帮助中心"
L.HELP.FANS = "官方粉丝页"
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
    "玩法介绍",
    "名词解释",
    "等级说明",
    "常见问题",
    "问题反馈",
}

L.HELP.PLAY_SUB_TAB_TEXT = {
    "玩法说明",
    "比牌规则",
    "操作说明",
    "按钮说明",
}

L.HELP.LEVEL_RULE = "玩牌即可获得经验,普通场入局一次赢钱+2, 输钱+1,特殊场次玩牌不加经验,如比赛场"
L.HELP.LEVEL_TITLES = {
    "等级",
    "称号",
    "经验",
    "奖励"
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
    "支付问题",
    "账号问题",
    "游戏BUG",
    "游戏建议",
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
    "玩法数据说明",
    "玩家类型标注",
}

L.HELP.FEED_BACK_SUCCESS = "反馈成功!"
L.HELP.FEED_BACK_FIAL = "反馈失败!请重试!"
L.HELP.UPLOADING_PIC_MSG = "正在上传图片，请稍候.."
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "请输入反馈内容"
L.HELP.MATCH_QUESTION = "比赛问题"
L.HELP.FAQ = {
    {
        "我的筹码用完了，但是还想玩，要怎么办？",
        "点击头像右侧的商城购买筹码即可。"
    },
    {
        "为什么我赠送不了游戏币？",
        "在牌桌上每人每天只能赠送五千，在好友列表里每人每天只能赠送五百。"
    },
    {
        "在哪里领取免费筹码？",
        "有登录奖励、在线奖励、任务奖励、粉丝奖励、邀请好友奖励等，还有不同的活动。"
    },
    {
        "怎样购买筹码？",
        "点击商城按钮，然后选择您需要的筹码。"
    },
	{
        "怎样成为粉丝？",
        "点击设置按钮，下方有粉丝页面入口，或点击链接"..appconfig.FANS_URL.."/ \n系统会经常给粉丝发福利哟~"
    },
	{
        "怎样登出？",
        "点击设置按钮，再选择登出即可。"
    },
	{
        "怎样改变名字、头像和性别？",
        "点击自己的头像，点击不同功能按钮即可。"
    },
	{
        "line认证是什么？",
        "添加官方Line号:OpenPoker，经过工作人员认证后，在游戏里显示您正确的line号，方便交到更多朋友"
    }
}

L.HELP.PLAY_DESC = {
    "手牌",
    "公共牌",
    "成牌",
    "玩家A",
    "玩家B",
    "翻牌",
    "转牌",
    "河牌",
    "葫芦 WIN",
    "两对 LOSE",
}

L.HELP.PLAY_DESC_2 = "在牌局开始的时候，每个玩家分的两张牌作为“底牌”，荷官会分三次连续发出五张公共牌。由每个玩家的底牌和公共牌中选出组合成最大牌型的五张与其他玩家比较，判定胜负。"

L.HELP.RULE_DESC = {
    "皇家同花顺",
    "同花顺",
    "四条",
    "葫芦",
    "同花",
    "顺子",
    "三条",
    "两对",
    "一对",
    "高牌",
}
L.COMMON.CARD_TIPS = "牌型提示"
L.COMMON.TEXAS_CARD_TYPE = L.HELP.RULE_DESC
T = {}
L.COMMON.CARD_TYPE = T
T[1] = ""
T[2] = L.HELP.RULE_DESC[10]
T[3] = L.HELP.RULE_DESC[9]
T[4] = L.HELP.RULE_DESC[8]
T[5] = L.HELP.RULE_DESC[7]
T[6] = L.HELP.RULE_DESC[6]
T[7] = L.HELP.RULE_DESC[5]
T[8] = L.HELP.RULE_DESC[4]
T[9] = L.HELP.RULE_DESC[3]
T[10] = L.HELP.RULE_DESC[2]
T[11] = L.HELP.RULE_DESC[1]

L.HELP.RULE_DESC_NOTES = {
    "同一花色最大的顺子",
    "同一花色的顺子",
    "4张相同+1单张",
    "3张相同+1对",
    "5张牌花色相同",
    "花色不同的顺子",
    "3张相同+2单张",
    "2对+1单张",
    "1对+3单张",
    "5个单张牌"
}
L.HELP.OPERATING_DESC = {
    "主菜单",
    "购买筹码",
    "池底+边池",
    "庄家",
    "公共牌",
    "底牌",
    "牌型提示",
    "操作界面",
    "带入筹码",
    "牌型大小和成牌概率",
    "一对",
    "加注",
    "跟注",
    "弃牌",
}

L.HELP.FEED_BACK_HINT = {
    "请尽可能提供详细的支付信息以方便我们的客服人员快速为您解决问题",
    "请提供您的用户ID以便我们为您解决问题，用户ID一般位于头像下方",
    "非常抱歉，您提出的任何问题我们都会第一时间给出反馈",
    "非常欢迎您对我们提出的任何建议或者意见，您的反馈是我们持续优化的动力",
}

L.HELP.PLAY_BTN_DESC = {
    {
        title="看牌",
        desc="在无人下注的情况下选择把决定“让”给下一位。",
        type = 1
    },
    {
        title="弃牌",
        desc="放弃继续牌局的机会。",
        type = 1
    },
    {
        title="跟注",
        desc="跟随众人押上同等的注额",
        type = 1
    },
    {
        title="加注",
        desc="把现有的注金抬高",
        type = 1
    },
    {
        title="全下",
        desc="一次把手上的筹码全部押上。",
        type = 1
    },
    {
        title="看或弃牌",
        desc="首先看牌，如果需要下注则选择弃牌",
        type = 2
    },
    {
        title="弃牌",
        desc="自动弃牌",
        type = 2
    },
    {
        title="跟任何注",
        desc="字段选择跟任何注",
        type = 2
    },
}

L.HELP.PLAY_DATA_DESC = {
    {
        title="入池率/入局率",
        desc="VPIP（通常缩写为VP）是玩家主动向底池中投入筹码的比率。"
    },
    {
        title="翻牌前加注率",
        desc="PFR即翻牌前加注，指的是一个玩家翻牌前加注的比率。"
    },
    {
        title="激进度",
        desc="AF即是用来衡量一个玩家打牌激进程度的数值。"
    },
    {
        title="再次加注率",
        desc="即在他人下注，有人加注之后的再加注，由于是一轮下注中的第三次加注，故称3bet。"
    },
    {
        title="偷盲率",
        desc="Stealing Blinds即偷盲,是指一个玩家单纯的为了赢得盲注而加注。"
    },
    {
        title="持续下注率",
        desc="Cbet即持续下注，是指一个玩家在前一轮主动下注或加注后，在当前这一轮再次主动下注。"
    },
    {
        title="摊牌率",
        desc="WTSD即摊牌率，是指一个玩家看到翻牌圈并玩到摊牌的百分比。"
    },
    {
        title="百手盈利率",
        desc="BB/100（百手盈利率）：BB是Big Blind（大盲注）的简称，BB/100用以衡量玩家每玩100手牌局的盈亏。"
    },
}

L.HELP.PLAYER_TYPE_DESC = {
    {
        title="跟注站",
        desc="只会被动的跟注"
    },
    {
        title="疯子",
        desc="疯狂的玩家，热衷于诈唬，非常激进"
    },
    {
        title="紧凶型（鲨鱼）",
        desc="玩的很紧且具有一定的攻击性。"
    },
    {
        title="紧弱型（老鼠）",
        desc="玩的很紧，较胆小，容易被诈唬吓跑的玩家"
    },
    {
        title="岩石型",
        desc="非常紧且被动。你不会在这种对手身上得到太多行动"
    },
    {
        title="黄色警报",
        desc="玩太多牌，而且容易高估自己的牌力。"
    },
    {
        title="松弱鱼",
        desc="玩太多牌，而翻牌后打法又很被动"
    },
}

--UPDATE
L.UPDATE.TITLE = "发现新版本"
L.UPDATE.DO_LATER = "以后再说"
L.UPDATE.UPDATE_NOW = "立即升级"
L.UPDATE.HAD_UPDATED = "您已经安装了最新版本"

--ABOUT
L.ABOUT.TITLE = "关于"
L.ABOUT.UID = "当前玩家ID: {1}"
L.ABOUT.VERSION = "版本号: V{1}" 
L.ABOUT.FANS = "官方粉丝页:\n" .. appconfig.FANS_URL
L.ABOUT.SERVICE = "服务条款与隐私策略"
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "任务"
L.DAILY_TASK.SIGN = "签到"
L.DAILY_TASK.GO_TO = "去完成"
L.DAILY_TASK.GET_REWARD = "领取奖励"
L.DAILY_TASK.HAD_FINISH = "已完成"
L.DAILY_TASK.TAB_TEXT = {
    "任务",
    "成就"
}

-- count down box
L.COUNTDOWNBOX.TITLE = "倒计时宝箱"
L.COUNTDOWNBOX.SITDOWN = "坐下才可以继续计时。"
L.COUNTDOWNBOX.FINISHED = "您今天的宝箱已经全部领取，明天还有哦。"
L.COUNTDOWNBOX.NEEDTIME = "再玩{1}分{2}秒，您将获得{3}。"
L.COUNTDOWNBOX.REWARD = "恭喜您获得宝箱奖励{1}"
L.COUNTDOWNBOX.TIPS = "成功邀请好友进游戏\n可以得到翻倍奖励"

-- act
L.NEWESTACT.NO_ACT = "暂无活动"
L.NEWESTACT.LOADING = "请您稍安勿躁,图片正在加载中..."
L.NEWESTACT.TITLE = "活动"
L.NEWESTACT.PLAY_CARD_TIME = "活动时间:{1}"
L.NEWESTACT.PLAY_CARD_TITLE = "玩越多 送越多"
L.NEWESTACT.PLAY_CARD_TIPS_1 = "你还差{1}局,就可以领取{2}筹码,确认站起吗?"
L.NEWESTACT.PLAY_CARD_TIPS_2 = "你还差{1}局,就可以领取{2}筹码,确认要离开吗"
L.NEWESTACT.PLAY_CARD_LIST_TITLE = {
    "盲注",
    "时间",
    "局数",
    "奖励"
}
L.NEWESTACT.PAY_TIPS = "活动结束后，系统会把奖励直接发送到您的信息栏"
L.NEWESTACT.PAY_COUNT = "已充值"
L.NEWESTACT.PAY_TIPS_1 = "充值总金额满"
L.NEWESTACT.PAY_TIPS_2 = "，可获赠"
L.NEWESTACT.HOLIDAY_TAB_TEXT = {
    "领取处",
    "兑换处"
}
L.NEWESTACT.HOLIDAY_REWARD_LIMIT = "可兑换{1}/{2}次"
L.NEWESTACT.HOLIDAY_NO_LIMIT = "无限制"
L.NEWESTACT.HOLIDAY_SHAKE_TAB_TEXT = {
    "送筹码",
    "摇一摇"
}
L.NEWESTACT.HOLIDAY_SHAKE_TIPS = "{1} 颗心 = {2} 次"
L.NEWESTACT.HOLIDAY_SHAKE_PLAY_TIPS = "活动期间每天可以免费摇一次"
L.NEWESTACT.HOLIDAY_SHAKE_TIMES = "摇一摇{1}次"
L.NEWESTACT.HOLIDAY_SHAKE_BTN = "摇一摇"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_BTN = "赠送"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TITLE = {
    "排名",
    "牛郎",
    "赠送筹码",
    "织女"
}
L.NEWESTACT.HOLIDAY_SHAKE_RANKING = "排行榜"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TIPS = "今日赠送筹码排行,明天重新排行"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_RECORD = "赠送记录"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FRIEND = "好友列表"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_1 = "织女ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_2 = "赠送筹码"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_1 = "选择好友或者输入ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_2 = "最低赠送{1}"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_3 = "请输入玩家ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_4 = "请输入赠送的筹码数量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_5 = "不能给自己赠送筹码"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_6 = "赠送筹码不能超过身上携带的数量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_7 = "你携带的筹码不足{1}"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_1 = "赠送失败,请重试"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_2 = "玩家ID无效,请重新赠送"

--feed
L.FEED.SHARE_SUCCESS = "分享成功"
L.FEED.SHARE_FAILED = "分享失败"
L.FEED.NO_CLIENT_TIPS = "您没有安装{1}应用,请使用其他方式邀请"
L.FEED.COPY_TIPS = "分享内容已复制,您可以直接粘贴到其他应用发送给好友"
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
    name = "我在开源德州扑克的幸运转转转获得了{1}的奖励，快来和我一起玩吧！",
    caption = "开心转转转100%中奖",
    link = L.FEED.SHARE_LINK .. "&feed=1",
    picture = appconfig.FEED_PIC_URL.."1.jpg",
    message = "",
}
L.FEED.WHEEL_ACT = {
    name = "快来和我一起玩开心转转转吧，每天登录就有三次机会！",
    caption = "开心转转转100%中奖", 
    link = L.FEED.SHARE_LINK .. "&feed=2",
    picture = appconfig.FEED_PIC_URL.."2.jpg",
    message = "",
}
L.FEED.LOGIN_REWARD = {
    name = "太棒了!我在开源德州扑克领取了{1}筹码的奖励，快来和我一起玩吧！",
    caption = "登录奖励天天送不停",
    link = L.FEED.SHARE_LINK .. "&feed=3",
    picture = appconfig.FEED_PIC_URL.."3.jpg",
    message = "",
}
L.FEED.INVITE_FRIEND = {
    name = "开源德州扑克，最新最火爆的德扑游戏，小伙伴们都在玩，快来加入我们一起玩吧！",
    caption = "聪明人的游戏-开源德州扑克",
    link = L.FEED.SHARE_LINK .. "&feed=4",
    picture = appconfig.FEED_PIC_URL.."4.jpg",
    message = "",
}
L.FEED.EXCHANGE_CODE = {
    name = "我用开源德州扑克粉丝页的兑换码换到了{1}的奖励，快来和我一起玩吧！",
    caption = "粉丝奖励兑换有礼",
    link = L.FEED.SHARE_LINK .. "&feed=5",
    picture = appconfig.FEED_PIC_URL.."5.jpg",
    message = "",
}
L.FEED.COUNT = {
    name = "太强了！我在开源德州扑克赢得了{1}的筹码，忍不住炫耀一下！",
    caption = "赢了好多啊",
    link = L.FEED.SHARE_LINK .. "&feed=6",
    picture = appconfig.FEED_PIC_URL.."6.jpg",
    message = "",
}
L.FEED.ACTIVE = {
    name = "太棒了，赶紧和我一起加入开源德州扑克吧，精彩活动天天有！",
    caption = "{1}活动",
    link = L.FEED.SHARE_LINK .. "&feed=7",
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.ACTIVE_DONE = {
    name = "我在开源德州扑克中获得了{1}的奖励，赶快来加入一起玩吧！ ",
    caption = "{1}活动",
    link = L.FEED.SHARE_LINK .. "&feed=8",
    picture = appconfig.FEED_PIC_URL.."8.jpg",
    message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
    name = "我在开源德州扑克完成了{1}的成就，获得了{2}的奖励，快来和我一起玩吧！ ",
    caption = "{1}",
    link = L.FEED.SHARE_LINK .. "&feed=9",
    picture = appconfig.FEED_PIC_URL.."9.jpg",
    message = "",
}
L.FEED.UPGRADE_REWARD = {
    name = "太棒了，我刚刚在开源德州扑克成功升到了{1}级，领取了{2}的奖励，快来膜拜吧！",
    caption = "升级领取大礼",
    link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
    picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
    message = "",
}
L.FEED.MATCH_COMPLETE = {
    name = "我在开源德州扑克{1}中获得第{2}名，赶快来一起玩吧！",
    caption = "一起来比赛！",
    link = L.FEED.SHARE_LINK .. "&feed=11",
    picture = appconfig.FEED_PIC_URL.."11.jpg",
    message = "",
}
L.FEED.RANK_REWARD = {
    name = "太棒了!我昨天在开源德州扑克里赢得了{1}筹码，快来和我一起玩吧!",
    caption = "又赢钱了！",
    link = L.FEED.SHARE_LINK .. "&feed=12",
    picture = appconfig.FEED_PIC_URL.."12.jpg",
    message = "",
}
L.FEED.BIG_POKER = {
    name = "手气真好!我在开源德州扑克拿到{1}，聪明人的游戏，快来加入一起玩吧！",
    caption = "{1}",--牌型
    link = L.FEED.SHARE_LINK .. "&feed=13",
    picture = appconfig.FEED_PIC_URL.."13.jpg",
    message = "",
}
L.FEED.PRIVATE_ROOM = {
    name = "我在开源德州扑克开好私人房等你来战，房间号{1}，密码{2}，点击立即加入！",
    caption = "开房打牌了",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
    name = "我在开源德州扑克开好私人房等你来战，房间号:{1}，点击立即加入！",
    caption = "开房打牌了",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name = "我在{1}房间{2}打牌,速速来战！",
    caption = "打牌啦",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.INVITE_CODE = {
    name = "发现一个目前最好玩的德州扑克游戏，推荐你和我一起玩，下载游戏输入我的邀请码{1}就有特别大奖领取.",
    caption = "",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE_REWARD = {
    name = "太感谢好友{1}！我在开源德州获得了{2}筹码的邀请礼包，快来加入我们一起玩吧",
    caption = "开源德州扑克-免费的邀请大礼包",
    link = L.FEED.SHARE_LINK .. "&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}

-- message
L.MESSAGE.TITLE = "消息"
L.MESSAGE.TAB_TEXT = {
    "好友消息", 
    "系统消息"
}
L.MESSAGE.EMPTY_PROMPT = "您现在没有消息记录"
L.MESSAGE.SEND_CHIP = "回赠"
L.MESSAGE.ONE_KEY_GET = "一键领取"
L.MESSAGE.ONE_KEY_GET_AND_SEND = "一键领取并回赠"
L.MESSAGE.GET_REWARD_TIPS = "恭喜您获得了{1},成功给好友赠送了{2}"

--奖励兑换码
L.ECODE.TITLE = {
    "我的邀请码",
    "奖励兑换"
}
L.ECODE.EDITDEFAULT = "请输入6位兑换码或8位邀请码"--"请输入6-8位数字奖励兑换码"
L.ECODE.FANS_DESC = "关注粉丝页可免费领取奖励兑换码,我们还会不定期在官方粉丝页推出各种精彩活动,谢谢关注。"
L.ECODE.FANS = "粉丝页地址"
L.ECODE.EXCHANGE = "兑  奖"
L.ECODE.ERROR_FAILED = "兑换码输入错误，请重新输入！"
L.ECODE.ERROR_INVALID="兑奖失败，您的兑换码已经失效。"
L.ECODE.ERROR_USED = "兑奖失败，每个兑换码只能兑换一次。"
L.ECODE.ERROR_END= "领取失败，本次奖励已经全部领光了，关注我们下次早点来哦"
L.ECODE.FAILED_TIPS = "兑奖失败，请重试！"
L.ECODE.NO_INPUT_SELF_CODE = "您不能输入自己的邀请码,请确认后重新输入"
L.ECODE.MAX_REWARD_TIPS = "最大获取"
L.ECODE.INVITE_REWARD_TIPS = [[
1.发送您的邀请码给您的好友
2.通知好友在新注册游戏三天内输入您的邀请码,过期无效
输入后好友可获得{2}新人礼包,同时您将获得{1}筹码邀请奖励;好友再邀请其他人,每邀请一位您还可再获得{3}筹码。
]]
L.ECODE.INVITE_REWARD_RECORD = "您已邀请了{1}位好友,获得了{2}筹码的邀请奖励"
L.ECODE.MY_CODE = "我的邀请码"
L.ECODE.COPY_CODE = "点击复制"
L.ECODE.INVITE_REWARD_TIPS_1 = "太棒了,领取成功"
L.ECODE.INVITE_REWARD_TIPS_2 = "您获得了{1}筹码的好友邀请奖励\n您的好友{2},也获得了{3}的邀请奖励"
L.ECODE.INVITE_BTN_NAME = "我也要去邀请"
L.ECODE.INVITE_TIPS = "您可以点击按钮通过以下方式发送邀请码"
L.ECODE.INVITE_TITLES = {
    "关注粉丝页获取兑换码",
    "发送我的邀请码获取邀请奖励"
}

--大转盘
L.LUCKTURN.RULE_TEXT =[[
1.每{1}个小时还可以免费转一次
2.你也可以花费1颗钻石转一次
3.100%中奖,天天大量免费筹码等你拿
]]
L.LUCKTURN.COST_DIAMOND = "花费1个颗钻石"
L.LUCKTURN.BUY_DIAMOND = "购买钻石"
L.LUCKTURN.COUNTDOWN_TIPS = "您今天的免费次数已用完\n您可以等待{1}再来\n您也可以花费一颗钻石转一次"
L.LUCKTURN.LOTTERY_FAILED = "抽奖失败，请检查网络连接断开后重试"
L.LUCKTURN.CHIP_REWARD_TIPS = "{1}中了:筹码 {2}"
L.LUCKTURN.PROPS_REWARD_TIPS = "{1}中了:道具 {2}"
L.LUCKTURN.VIP_REWARD = "{1}天{2}VIP特权"

--老虎机
L.SLOT.NOT_ENOUGH_MONEY = "老虎机购买失败,你的筹码不足"
L.SLOT.NOT_ENOUGH_MIN_MONEY = "您的总筹码数不足5000，暂时无法下注老虎机，请充值后重试。"
L.SLOT.BUY_FAILED = "老虎机购买失败，请重试"
L.SLOT.PLAY_WIN = "你赢得了{1}筹码"
L.SLOT.TOP_PRIZE = "玩家 {1} 玩老虎机抽中大奖，获得筹码{2}"
L.SLOT.FLASH_TIP = "头奖：{1}"
L.SLOT.FLASH_WIN = "你赢了：{1}"
L.SLOT.AUTO = "自动"
L.SLOT.HELP_TIPS = "奖金=下注筹码*回报率\n下注越多,奖励越高.最高{1}"

--GIFT
L.GIFT.TITLE = "礼物"
L.GIFT.SET_SELF_BUTTON_LABEL = "设为我的礼物"
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "买给牌桌x{1}"
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "你当前选择的礼物"
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "赠送"
L.GIFT.DATA_LABEL = "天"
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "请选择礼物"
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "购买礼物成功"
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "购买礼物失败"
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "设置礼物成功"
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "设置礼物失败"
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "赠送礼物成功"
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "赠送礼物失败"
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "赠送牌桌礼物成功"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "赠送牌桌礼物失败"
L.GIFT.NO_GIFT_TIP = "暂时没有礼物"
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "点击选中既可在牌桌上展示才礼物"
L.GIFT.BUY_GIFT_FAIL_TIPS = "您的场外筹码不足,购买礼物失败"
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "您的场外筹码不足,赠送礼物失败"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "您的场外筹码不足,赠送牌桌礼物失败"
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
    "精品", 
    "食物",
    "跑车",
    "鲜花"
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
    "自己购买", 
    "牌友赠送",
    "特别赠送"
}

L.GIFT.MAIN_TAB_TEXT = {
    "商城礼物", 
    "VIP礼物",
    "我的礼物"
}

-- 破产
L.CRASH.PROMPT_LABEL = "您获得了{1}筹码的破产救济金，同时获得限时破产优惠充值一次，您也可以立即邀请好友获取免费筹码。"
L.CRASH.THIRD_TIME_LABEL = "您获得最后一次{1}筹码的破产救济金，同时获得当日限时充值优惠一次，您也可以立即邀请好友获取免费筹码。"
L.CRASH.OTHER_TIME_LABEL = "您已经领完所有破产救济金了，输赢只是转瞬的事，限时特惠机会难得，立即充值重振雄风！"
L.CRASH.TITLE = "你破产了！" 
L.CRASH.REWARD_TIPS = "破产没有关系，还有救济金可以领取"
L.CRASH.CHIPS = "{1}筹码"
L.CRASH.GET = "领取"
L.CRASH.GET_REWARD = "获得{1}筹码"
L.CRASH.GET_REWARD_FAIL = "领取筹码失败"
L.CRASH.RE_SIT_DOWN = "重新坐下"
L.CRASH.PROMPT_LABEL_1 = "不要灰心,系统为您准备了{1}筹码的破产救济"
L.CRASH.PROMPT_LABEL_2 = "同时您还获得当日充值优惠一次立即充值重振雄风"
L.CRASH.PROMPT_LABEL_3 = "您也可以邀请好友或者明天再来领取大量免费筹码"
L.CRASH.PROMPT_LABEL_4 = "我们赠送您当日限时充值优惠大礼包一次，机不可失"
L.CRASH.PROMPT_LABEL_5 = "您已经领完了所有的破产礼包 输赢乃兵家常事,不要灰心"

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "短信已发送成功,正在充值 请稍等."
L.E2P_TIPS.NOT_SUPPORT = "你的手机暂时无法完成easy2pay充值,请选择其他渠道充值"
L.E2P_TIPS.NOT_OPERATORCODE = "easy2pay暂时不支持你的手机运营商,请选择其他渠道充值"
L.E2P_TIPS.SMS_SENT_FAIL = "短信发送失败,请检查你的手机余额是否足额扣取"
L.E2P_TIPS.SMS_TEXT_EMPTY = "短信内容为空,请选择其他渠道充值并联系官方"
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "没有发送目标,请选择其他渠道充值并联系官方"
L.E2P_TIPS.SMS_NOSIM = "没有SIM卡,无法使用easy2pay渠道充值,请选择其他渠道充值"
L.E2P_TIPS.SMS_NO_PRICEPOINT = "没有发送目标,请选择其他渠道充值并联系官方"
L.E2P_TIPS.PURCHASE_TIPS = "您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的话费里扣除"
L.E2P_TIPS.BANK_PURCHASE_TIPS = "您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的银行卡里扣除"

-- 比赛场
L.MATCH.MONEY = "筹码"
L.MATCH.JOINMATCHTIPS = "您报名参赛的比赛已经开始准备，是否现在进入房间进行比赛"
L.MATCH.JOIN_MATCH_FAIL = "加入比赛失败，请参加其他比赛吧！"
L.MATCH.MATCH_END_TIPS = "当前比赛已经结束，请参加其他比赛吧！"
L.MATCH.MATCHTIPSCANCEL = "不再提示"
L.MATCH.CHANGING_ROOM_MSG = "正在等待其他桌子结束"
L.MATCH.MATCH_NAME = "比赛名称"
L.MATCH.MATCH_REWARD = "奖励内容"
L.MATCH.MATCH_PLAYER = "参赛人数"
L.MATCH.MATCH_COST = "报名费+服务费"
L.MATCH.REGISTER = "报名"
L.MATCH.REGISTERING = "正在\n报名"
L.MATCH.REGISTERING_2 = "正在报名"
L.MATCH.UNREGISTER = "取消\n报名"
L.MATCH.UNREGISTER_2 = "取消报名"
L.MATCH.RANKING = "您的排名"
L.MATCH.REGISTER_COST = "参数费:"
L.MATCH.SERVER_COST = "服务费:"
L.MATCH.TOTAL_MONEY = "您的总资产:"
L.MATCH.MATCH_INFO = "本场赛况"
L.MATCH.START_CHIPS = "初始筹码:"
L.MATCH.START_BLIND = "初始盲注:{1}/{2}"
L.MATCH.MATCH_TIME = "参赛时间:{1}"
L.MATCH.RANKING_TITLE = "名次"
L.MATCH.REWARD_TITLE = "奖励"
L.MATCH.LEVEL_TITLE = "级别"
L.MATCH.BLIND_TITLE = "盲注"
L.MATCH.PRE_BLIND_TITLE = "前注"
L.MATCH.ADD_BLIND_TITLE = "涨盲时间"
L.MATCH.RANKING_INFO = "当前排名第{1}名"
L.MATCH.SNG_HELP_TITLE = "SNG比赛规则"
L.MATCH.MTT_HELP_TITLE = "MTT比赛规则"
L.MATCH.SNG_RANKING_INFO = "均筹: {1}"
L.MATCH.MTT_RANKING_INFO = "{1}/{2} 均筹: {3}"
L.MATCH.ADD_BLIND_TIME = "涨盲时间: {1}"
L.MATCH.WAIT_MATCH = "等待开赛"
L.MATCH.ADD_BLIND_TIPS_1 = "将在下一局涨盲"
L.MATCH.ADD_BLIND_TIPS_2 = "下一局将升盲至{1}/{2}"
L.MATCH.BACK_HALL = "返回大厅"
L.MATCH.PLAY_AGAIN = "再来一局"
L.MATCH.LEFT_LOOK = "留下旁观"
L.MATCH.CLOSE = "关闭"
L.MATCH.REWARD_TIPS = "您获得了{1}的奖励\n{2}"
L.MATCH.REWARD_PLAYER = "奖励人数"
L.MATCH.MATCH_CUR_TIME = "比赛用时"
L.MATCH.CUR_LEVEL_TITLE = "当前级别:{1}/{2}"
L.MATCH.NEXT_LEVEL_TITLE = "下一级别"
L.MATCH.AVERAGE_CHIPS_TITLE = "平均筹码"
L.MATCH.FORMAT_BLIND = "{1}/{2}"
L.MATCH.EXPECT_TIPS = "敬请期待"
L.MATCH.NOT_ENOUGH_MONEY = "您的筹码不足报名，请去商城补充筹码后重试"
L.MATCH.PLAYER_NUM_TIPS = "等待开赛中，还差{1}人"
L.MATCH.PLAYER_NUM_TIPS_1 = "等待开赛中，还差 "
L.MATCH.PLAYER_NUM_TIPS_2 = " 人"
L.MATCH.MAINTAIN = "当前比赛正在维护"
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
    "你太棒了！立即分享炫耀下吧!",
    "没想到你这么强！呼朋唤友告诉小伙伴们吧！",
    "太牛了，再来一局吧！",
}
L.MATCH.NO_REWARD_TEXT = {
    "再接再厉，继续加油！",
    "失败是成功之母，继续努力！",
    "就差一点点，下次多点耐心！",
}
L.MATCH.SNG_RULE = {
    {
        title = "什么是SNG-坐满即玩?",
        content = "SNG全称Sit and Go，中文指坐满即玩，坐满即玩是德州扑克的一种单桌比赛玩法。在SNG中，每场玩家会获得用来计数的筹码，这个筹码与金币无关，只用于本场计数。"
    },
    {
        title = "SNG比赛规则:",
        content = [[
1.报名人数满9人(或6人)立即开赛
2.每场比赛玩家会获得用来计数的筹码(本筹码不等于金币),该筹码只 用于本场比赛的计数
3.坐满即玩中途不能增加筹码，筹码输完后则退出比赛
4.按照玩家退出比赛顺序取名次，第一个筹码输完的玩家即是最后一名， 依此类推
5.当牌局里只剩下最后_名玩家时比赛结束，最后一名玩家即是冠军
6.为提高比赛激烈程度，坐满即玩比赛过程中盲注会逐步提升
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title = "什么是MTT-多桌锦标赛?",
        content = "MTT是Multi-Table Tournament的缩写，中文全称为多桌锦标赛，指的是在多张桌上参赛玩家以同样的筹码量开始比赛。在多桌锦标赛中，桌子会随着选手的不断淘汰进行合并。最终，锦标赛会减少到一张桌子而进行决赛。"
    },
    {
        title = "MTT比赛规则:",
        content = [[
1.固定时间开始比赛，当参赛人数小于最低开赛人数时，比赛将被取消
2.每场比赛玩家会获得用来计数的筹码只用于本场比赛的计数
3.前注：比赛进行过程中，每局开始前强制每位玩家自动下注若干筹码，即为前注
4.重买筹码：在配置了可重买的比赛开始后的某个盲注级别前，当玩家手里筹码s初始 筹码时，玩家可点击重购筹码按钮花费报名费再次买入初始的筹码值，不同的比赛可重 买的次数不定，当玩家手里筹码为0即将被淘汰出比赛时，也可通过重买复活
5.増购筹码：在配置了可増购的比赛的某个盲注级别时间段内，玩家可点击增购筹码按钮花费报名费再次买入若干筹码值，不同的比赛可增购的次数不定，当玩家手里筹码为0 即将被淘汰出比赛时，也可通过增购复活
6.按照玩家退出比赛顺序取名次，第一个筹码输完的玩家即是最后一名，依此类推，如果有2位以上参赛者于同一局牌被淘汰，则将依次按照牌力、开始时筹码定位名次，牌力大者排名在前，开始时筹码多者排名在前
7.当比赛里只剩下最后一名玩家时比赛结束，最后一名玩家即是冠军
8.为提高比赛激烈程度，锦标赛比赛过程中盲注会逐步提升
]]
    }
}
L.MATCH.TAB_TEXT= {
    "概述",
    "排名",
    "盲注",
    "奖励",
}
L.MATCH.ROOM_TAB_TEXT_1= {
    "概述",
    "赛况",
    "排名",
    "盲注",
    "奖励",
}
L.MATCH.ROOM_TAB_TEXT_2= {
    "赛况",
    "排名",
    "盲注",
    "奖励",
}

-- 输赢统计
L.WINORLOSE.TITLE = "太棒了"
L.WINORLOSE.YING = "你赢了"
L.WINORLOSE.CHOUMA = "{1}筹码"
L.WINORLOSE.INFO_1 = "局数:{1}"
L.WINORLOSE.INFO_2 = "单局最大赢得:{1}"
L.WINORLOSE.RATE5 = "喜欢我们的游戏给5星好评，您的鼓励是我们持续优化的最大动力"
L.WINORLOSE.NOW = "立即支持"
L.WINORLOSE.LATER = "以后再说"
L.WINORLOSE.SHARE = "分享"
L.WINORLOSE.CONTINUE = "继续游戏"

-- 私人房
L.PRIVTE.ROOM_NAME = "私人房"
L.PRIVTE.FINDTITLE = "查找房间"
L.PRIVTE.CREATTITLE = "创建房间"
L.PRIVTE.INPUTROOMIDTIPS = "请输入房间号"
L.PRIVTE.ENTERROOM = "立即进入"
L.PRIVTE.TYPETIPS = "下注思考时间:\n普通场{1}秒\n快速场{2}秒"
L.PRIVTE.CREATEROOM = "立即开始"
L.PRIVTE.CREATFREE = "限免开局"
L.PRIVTE.INPUTPWDTIPS = "请输入房间密码，留空即无密码"
L.PRIVTE.TIMEHOUR = "{1}小时"
L.PRIVTE.PWDPOPTIPS = "请输入有效密码"
L.PRIVTE.PWDPOPTITLE = "请输入密码"
L.PRIVTE.PWDPOPINPUT = "请输入密码"
L.PRIVTE.NOTIMETIPS = "当前房间所剩时间{1}秒，即将解散，请重新创建！"
L.PRIVTE.TIMEEND = "当前房间时间已用完解散，请返回大厅重新创建！"
L.PRIVTE.ENTERBYID = "输入房间号进入"
L.PRIVTE.OWNER = "房主"
L.PRIVTE.ROOMID = "房间号:{1}"
L.PRIVTE.LEFTDAY = "{1}天"
L.PRIVTE.LEFTHOUR = "{1}小时"
L.PRIVTE.LEFTMIN = "{1}分钟"
L.PRIVTE.ENTERLOOK = "围观"
L.PRIVTE.ENTERPLAY = "坐下"
L.PRIVTE.ENTEREND = "已结束"
L.PRIVTE.ENTERENDTIPS = "当前房间已解散，请进入其他房间！"
L.PRIVTE.ENTERCHECK = "您要加入此房间么?"
L.PRIVTE.CHECKCREATE = "暂无房间，创建新房间"
L.PRIVTE.ROOMMAXTIPS = "您创建的私人房已经达到上限！"

--活动
L.ACT.CHRISTMAS_HITRATE = "准确率{1}  最多连击{2}"
L.ACT.CHRISTMAS_HITWIN = "手速超快, 您在本活动中击败{1}的人"
L.ACT.CHRISTMAS_FEED = {
    name = "我以超快手速获得了{1}筹码，击败了{2}的人，敢来和我拼手速吗？",
    caption = "点礼物得筹码100%中奖",
    link = L.FEED.SHARE_LINK .. "&feed=14",
    picture = appconfig.FEED_PIC_URL.."14.jpg",
    message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "圣诞节快乐，摇晃手机点礼物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "新年快乐，摇晃手机点礼物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "礼物即将降落，准备好点击了吗？"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "明天再来吧"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 = "春节快乐，摇晃手机点礼物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_6 = "七夕快乐，摇一摇，点击礼物有大惊喜哦。"

--红黑大战
L.REDBLACK.BET_DOUBLE = "加倍"
L.REDBLACK.BET_LAST = "重复上局"
L.REDBLACK.SELECTED_BET_TIPS = "请选择幸运区域"
L.REDBLACK.SELECTED_BET_END_TIPS = "选择完毕"
L.REDBLACK.START_GAME_TIPS = "游戏即将开始({1})"
L.REDBLACK.BET_FAILD = "您的游戏币不足,下注失败"
L.REDBLACK.BET_FAILD_2 = "您的游戏币不足当前所选的下注额度{1}，已经自动切换到{2}"
L.REDBLACK.BET_FAILD_TIMES_OUT = "下注时间已到,下注失败"
L.REDBLACK.BET_LIMIT_TIPS = "下注失败，当局下注不能超过{1}"
L.REDBLACK.ALL_PLAYER = "当前房间共有 {1} 人"
L.REDBLACK.RECENT_TREND = "近期走势:"
L.REDBLACK.TODAY_COUNT = "今日统计:"
L.REDBLACK.WIN_LOSE = "胜 负"
L.REDBLACK.HAND_CARD = "手 牌"
L.REDBLACK.WIN_CARD_TYPE = "获胜牌型"
L.REDBLACK.COUNT_TIPS_1 = "金象胜利:{1}"
L.REDBLACK.COUNT_TIPS_2 = "银象胜利:{1}"
L.REDBLACK.COUNT_TIPS_3 = "平局:{1}"
L.REDBLACK.COUNT_TIPS_4 = "同花连牌:{1}"
L.REDBLACK.COUNT_TIPS_5 = "对A:{1}"
L.REDBLACK.COUNT_TIPS_6 = "葫芦:{1}"
L.REDBLACK.COUNT_TIPS_7 = "金刚/皇家/同花顺:{1}"
L.REDBLACK.SUB_TAB_TEXT = {
    "胜负走势",
    "游戏规则"
}
L.REDBLACK.RULE = [[
选择你支持的选手, 赢得更多奖励吧!


基本规则：
1.每局比赛将给金象和銀象各发一副手牌, 再发5张公共牌, 并亮出其中一张.

2.玩家可根据公开的信息支持任何阵营和区域.

3.公共牌和手牌亮出, 根据结果, 按区域内倍数奖励支持的玩家.


每日投入有上限.设计合理的策略支持喜爱的选手吧!
]]

--新手引导
L.TUTORIAL.SETTING_TITLE = "新手教学"
L.TUTORIAL.FIRST_IN_TIPS = [[
欢迎来到开源德州扑克
下面将由小爱教你来玩这款风靡全球的棋牌游戏，如果你已经了解德扑的基本玩法，可以点击跳过引导，直接进入游戏；如果没有的话，点击开始教学，让我们一起来学习吧！

首次完成教程还可以领取8000筹码奖励哦!
]]
L.TUTORIAL.FIRST_IN_BTN1 = "跳过引导"
L.TUTORIAL.FIRST_IN_BTN2 = "开始教学"
L.TUTORIAL.END_AWARD_TIPS = "完成教程领取筹码"
L.TUTORIAL.FINISH_AWARD_TIPS = "恭喜你，您获得了{1}筹码的新手教学礼包，您可以选择再来一遍或者立即开始"
L.TUTORIAL.FINISH_NOAWARD_TIPS = "您已经是德州扑克高手啦，您可以选择再来一遍或者立即开始"
L.TUTORIAL.FINISH_FIRST_BTN = "重新学习"
L.TUTORIAL.FINISH_SECOND_BTN = "快速开始"
L.TUTORIAL.SKIP = "跳 过"
L.TUTORIAL.NEXT_STEP = "下一步"
L.TUTORIAL.GUESS_TRUE_13 = "答对了,你现在有一对A，挺大的\n\n点击任意位置进入下一轮下注"
L.TUTORIAL.GUESS_TRUE_22 = "答对了,你现在有两对(1对A和1对9)\n\n点击任意位置进入下一轮下注"
L.TUTORIAL.GUESS_TRUE_27 = "答对了,你现在是葫芦(3条9和1对A)\n\n点击任意位置进入下一轮下注"
L.TUTORIAL.GUESS_FLASE = "错啦，再仔细想想..."
L.TUTORIAL.RE_SELECT = "重选"
L.TUTORIAL.TIPS = {
    "退出菜单",
    "购买筹码",
    "点击查看他人信息 赠送筹码 使用互动道具",
    "公共牌",
    "滑出或者点击打开老虎机",
    "我的头像",
    "我的手牌",
    "操作按钮",
    "点击聊天 发送表情"
}
L.TUTORIAL.ROOM_STEP_1 = "欢迎来到开源德州扑克！首次完成教程可获取{1}筹码的奖励哦，下面让我们一起开始游戏吧!\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_2 = "我是你们美女荷官，游戏开始我会给每位玩家发放2张手牌，这2张手牌仅玩家自己可见。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_3 = "之后会陆续发出5张公牌，这5张公牌所有玩家可见。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_4 = "最后玩家的成牌是从公牌和手牌中选取5张组成的最大的牌型；牌型大小如左图所示：皇家同花顺-同花顺-四条-葫芦-同花-顺子-三条-对子-高牌"
L.TUTORIAL.ROOM_STEP_5 = "当前你组成的最大牌型是皇家同花顺(5张同花色顺子10-J-Q-K-A), 光标闪烁处就是选中的最大牌组。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_6 = "都掌握了吗？\n下面我们正式开始一局吧！\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_7 = "此处是玩牌操作区域，轮到你操作时，可以根据自己的牌选择相应操作。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_8 = "现在轮到你了，你当前的牌还不错! \n\n点击按钮选择跟注"
L.TUTORIAL.ROOM_STEP_11= "其他两个玩家都选择了CALL，看来也没什么好牌，现在开始发前3张公牌。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_13= "前3张公牌已经发完了，你组成了新的牌型，猜猜你现在的牌型是什么？"
L.TUTORIAL.ROOM_STEP_14= "又轮到你了，先想想下一步怎么操作，其他玩家有可能是同花(梅花)，先选择一把看牌。"
L.TUTORIAL.ROOM_STEP_16= "玩家{1}选择了加注，加注一般有比较强的牌力，要小心，先静观其变吧！"
L.TUTORIAL.ROOM_STEP_18= "玩家{1}选择了弃牌，弃牌就意味着这一局输掉所有已经下注的筹码，一般情况下牌力不够的时候选择弃牌比较明智。"
L.TUTORIAL.ROOM_STEP_19= "又轮到你了，当前牌力不错（1对A)，可以CALL ，看第4张公牌。"
L.TUTORIAL.ROOM_STEP_22= "4张公牌已经发完了，你又组成了新的牌型，猜猜你现在的牌型是什么？"
L.TUTORIAL.ROOM_STEP_23= "游戏只剩2个玩家了，你现在有2对(1对A和1对9)，牌力不错，可以加注{1}试试。"
L.TUTORIAL.ROOM_STEP_25= "{1}也选择跟住，荷官将发出最后1张公牌。"
L.TUTORIAL.ROOM_STEP_27= "5张公牌都发完啦，你的最终牌型也确定了，你的最终牌型是什么？"
L.TUTORIAL.ROOM_STEP_29= "{1}，ALL_IN了，预测牌力不小，但你葫芦也很大，跟了!"
L.TUTORIAL.ROOM_STEP_32= "最后亮牌了，{1}是同花，你是葫芦，你赢了(葫芦>同花)！你获得了底池所有的筹码！"
L.TUTORIAL.ROOM_STEP_34= "这是游戏的其他元素，需要你自己去探索啦！"

--保险箱
L.SAFE.TITLE = "保险箱"
L.SAFE.TAB_TEXT = {
    "游戏币",
    "钻石"
}
L.SAFE.SAVE_MONEY = "存入"
L.SAFE.GET_MONEY = "取出"
L.SAFE.SET_PASSWORD = "设置密码"
L.SAFE.CHANGE_PASSWORD = "修改密码"
L.SAFE.MY_SAFE = "我的保险箱"
L.SAFE.MY_PURSE = "我的携带"
L.SAFE.SET_PASSWORD_TIPS_1 = "请输入新密码"
L.SAFE.SET_PASSWORD_TIPS_2 = "请再次新输入密码"
L.SAFE.SET_PASSWORD_TIPS_3 = "两次输入密码不一致,请重新输入"
L.SAFE.SET_PASSWORD_TIPS_4 = "密码不能为空,请重新输入！"
L.SAFE.SET_PASSWORD_TIPS_5 = "请输入密码,打开保险箱"
L.SAFE.FORGET_PASSWORD = "忘记密码"
L.SAFE.VIP_TIPS_1 = "您还不是VIP用户,暂时无法使用,是否立即成为VIP,还有超多优惠和特权."
L.SAFE.VIP_TIPS_2 = "您的VIP已经过期,暂时无法存入,是否立即成为VIP,还有超多优惠和特权."
L.SAFE.SET_PASSWORD_SUCCESS = "设置密码成功!"
L.SAFE.SET_PASSWORD_FAILED = "设置密码失败,请重试!"
L.SAFE.CHANGE_PASSWORD_SUCCESS = "修改密码成功!"
L.SAFE.CHANGE_PASSWORD_FAILED = "修改密码失败,请重试!"
L.SAFE.CHECK_PASSWORD_ERROR = "输入的密码错误,请重新输入!"
L.SAFE.CHECK_PASSWORD_FAILED = "验证密码失败,请重试!"
L.SAFE.SAVE_MONEY_FAILED = "存钱失败,请重试!"
L.SAFE.GET_MONEY_FAILED = "取钱失败,请重试!"
L.SAFE.INPUT_MONEY_TIPS = "请输入大于0的数值,进行存取."
L.SAFE.SET_EMAIL = "设置安全邮箱"
L.SAFE.SET_EMAIL_BTN = "点击设置"
L.SAFE.CHANGE_EMAIL_BTN = "修改邮箱"
L.SAFE.SET_EMAIL_TIPS_1 = "为了更好的保护您的财产,请绑定常用邮箱,以确保收到邮件.邮件可以用于重置密码等操作.\n首次绑定还可以奖励20K游戏币."
L.SAFE.SET_EMAIL_TIPS_2 = "您已经成功绑定邮箱!"
L.SAFE.SET_EMAIL_TIPS_3 = "电子邮箱,例如openpokerxxx@gmail.com"
L.SAFE.SET_EMAIL_TIPS_4 = "请输入正确的邮箱格式!"
L.SAFE.SET_EMAIL_TIPS_5 = "你还没有设置安全邮箱,设置后可通过邮箱找回密码"
L.SAFE.SET_EMAIL_TIPS_6 = "您已经设置了安全邮箱:{1}"
L.SAFE.SET_EMAIL_SUCCESS = "绑定邮箱成功!"
L.SAFE.SET_EMAIL_TIPS_FAILED = "绑定邮箱失败,请重试!"
L.SAFE.RESET_PASSWORD_TIPS_1 = "重置信息已提交,请立即登录邮箱点击链接验证."
L.SAFE.RESET_PASSWORD_TIPS_2 = "设置新的密码,点击确定,系统将发送验证链接到您的安全邮箱,5分钟内点击链接激活即可重置成功."
L.SAFE.RESET_PASSWORD_TIPS_3 = "对不起,由于您没有绑定邮箱,所以无法此功能.请您联系客服."
L.SAFE.RESET_PASSWORD_TIPS_4 = "重置信息提交失败,请重试."
L.SAFE.RESET_PASSWORD = "重置密码"
L.SAFE.CLEAN_PASSWORD = "清空密码"
L.SAFE.CLEAN_PASSWORD_SUCCESS = "清空密码成功!"
L.SAFE.CLEAN_PASSWORD_FAILED = "清空密码失败,请重试!"

--夺金岛
L.GOLDISLAND.TITLE = "夺金岛"
L.GOLDISLAND.RULE_BTN = "详细规则"
L.GOLDISLAND.BUY_BTN = "购买下局"
L.GOLDISLAND.ALREADY_BUY = "已购买"
L.GOLDISLAND.PRICE = "{1}筹码/次"
L.GOLDISLAND.AUTO_BUY = "自动购买"
L.GOLDISLAND.BUY_SUCCESS = "买入下一局夺金岛成功"
L.GOLDISLAND.BUY_FAILED = "您身上的筹码不足以购买下一局的夺金岛了"
L.GOLDISLAND.BUY_TIPS = "必须坐下,才能购买下一局的夺金岛"
L.GOLDISLAND.RULE_TITLE = "夺金岛规则说明"
L.GOLDISLAND.RULE_POOL = "奖池:"
L.GOLDISLAND.RULE_DESC = [[
1.盲注大于3000的场坐下才能才加夺金岛,每局参赛费为2000筹码(牌局开始时从带入筹码中扣除).该筹码会进入夺金岛奖池.

2.参加夺金岛后,每局结束时持有特定牌型,即可从夺金岛奖池中赢取大量筹码!
皇家同花顺:赢得80%奖池
同花顺:赢得30%奖池 
四条:赢得10%奖池

3.必须5张公共牌全部翻出后牌型才生效.玩家主动弃牌或者其他玩家全部弃牌导致牌局提前结束,则牌型无效;玩家必须坚持到比牌环节(不需要获胜)才可赢得本局夺金岛.    

4.领奖:系统会自动把赢得的筹码加入压中玩家的账户.

5.参加:可以点击夺金岛图标之后进入夺金岛购买窗口,按要求买入夺金岛.可以选择自动买入或者购买1次.
]]
L.GOLDISLAND.REWARD_TITLE = "恭喜赢得夺金岛"
L.GOLDISLAND.REWARD_BTN = "我知道了"
L.GOLDISLAND.CARD_TYPE = "您的牌型为:{1}"
L.GOLDISLAND.REWARD_NUM = "获得夺金岛{1}%的奖池:"
L.GOLDISLAND.REWARD_TIPS = "奖金已发送至您的个人账户中"
L.GOLDISLAND.BROADCAST_REWARD_TIPS = "恭喜玩家{1}在夺金岛压中{2}获得{3}筹码的奖金!"

--支付引导
L.CHECKOUTGUIDE.BTN_TITLE = "วิธีชำระค่าโทรผ่าน\nGoogle Play"
L.CHECKOUTGUIDE.TITLE = "谷歌官方支付教程"
L.CHECKOUTGUIDE.TAB_TEXT = {
    "话费支付",
    "银行卡支付"
}
L.CHECKOUTGUIDE.SMS_TITLE = "用话费支付(仅支持AIS/DTAC的电话卡)"
L.CHECKOUTGUIDE.SMS_STEP = {
    "进入游戏->选择GooglePlay->点击购买需要的商品->出现下图所示弹框->点击红框中的下拉箭头",
    "点击dtac账户或ais账户(根据您的电话卡而定)",
    "输入谷歌邮箱密码后点击确认",
    "付款成功",
}
L.CHECKOUTGUIDE.CARD_TITLE = "用银行卡付款"
L.CHECKOUTGUIDE.CARD_STEP = {
    "进入游戏->选择GooglePlay->点击购买需要的商品->出现下图所示弹框->点击红框中的下拉箭头",
    "点击添加信用卡或借记卡",
    "添加信用卡或借记卡信息",
    "绑定好银行信息之后，购买筹码时系统会显示确认购买弹框-＞点击购买",
    "输入谷歌邮箱密码后点击确认",
    "付款成功",
}
L.CHECKOUTGUIDE.TRUE_WALLET_TITLE = "用虚拟信用卡付款"
L.CHECKOUTGUIDE.TRUE_WALLET_STEP = "1.下载true wallet\n2.点击we card,开通虚拟信用卡"
L.CHECKOUTGUIDE.TRUE_WALLET_MORE = "更多true wallet信息请看"

--绑定账号
L.BIND.BTN_TITLE = "升级安全账户+{1}"
L.BIND.TITLE = "免费升级安全账户"
L.BIND.BTN_TITLE_2 = {
    "绑定Facebook账号",
    "绑定Line账号",
    "绑定VK账号"
}
L.BIND.ACCOUNT = {
    "Facebook账号",
    "Line账号",
    "VK账号"
}
L.BIND.SUCCESS_TITLE = "绑定成功"
L.BIND.FAILED_TITLE = "绑定失败"
L.BIND.GET_REWARD = "立即领取"
L.BIND.GET_REWARD_FAILED = "领取奖励失败,请重试"
L.BIND.GET_REWARD_TIPS = "您已经成功将游客账号绑定到{1}，以后您可以选择任意方式登录，并获得{2}筹码的安全账号奖励。"
L.BIND.FAILED_TIPS = "对不起，此账号已注册过游戏\n您可以选择其他账号重新绑定或者直接登录已存在的账号"
L.BIND.FAILED_TIPS_2 = "账号绑定失败,请重试"
L.BIND.GOTO_LOGIN = "直接登录"
L.BIND.RETRY = "重新绑定"
L.BIND.CANCELED = "取消绑定"

--支付引导
L.PAYGUIDE.FIRST_GOODS_DESC = {
    "送VIP",
    "送动态头像",
}
L.PAYGUIDE.FIRST_GOODS_DESC_2 = {
    "7天 VIP1",
    "动态头像",
    "最高3倍筹码"
}
L.PAYGUIDE.GOTO_STORE = "前往商城充值"
L.PAYGUIDE.GET_CARSH_REWARD = "领取{1}救济金"
L.PAYGUIDE.FIRST_PAY_TIPS = "购买商城任意筹码可以获赠以上礼品"
L.PAYGUIDE.BUY_PRICE_1 = "{1}抢购"
L.PAYGUIDE.BUY_PRICE_2 = "原价{1}"
L.PAYGUIDE.ROOM_FIRST_PAY_TIPS = "首冲仅有一次机会"
return L
