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
L.TIPS.ERROR_INVITE_FRIEND = "Failed to invite"
L.TIPS.ERROR_TASK_REWARD = "Collect reward failed"
L.TIPS.ERROR_SEND_FRIEND_CHIP = "Failed to send chips"
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "Send chips to friends abnormally"
L.TIPS.ERROR_BUY_GIFT = "Send gift failed"
L.TIPS.ERROR_LOTTER_DRAW = "Collect mystery gift box reward failed"
L.TIPS.EXCEPTION_LOTTER_DRAW = "Run out of times"
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "Login room failed"
L.TIPS.ERROR_LOGIN_FACEBOOK = "Login FaceBook failed"
L.TIPS.ERROR_LOGIN_FAILED = "Login failed"
L.TIPS.ERROR_QUICK_IN = "Failure to obtain room information"
L.TIPS.EXCEPTION_QUICK_IN = "Abnormal room information"
L.TIPS.ERROR_SEND_FEEDBACK = "Server error or network link timeout, sending feedback failed!"
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "Server error, sending feedback failed"
L.TIPS.ERROR_MATCH_FEEDBACK = "Feedback tournament error failed"
L.TIPS.EXCEPTION_ACT_LIST = "Server error, event data loading failed"
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "Verification password: server error"
L.TIPS.ERROR_BACK_CHECK_PWD = "Server error or network link timeout.Password verification failed"
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "Feedback image upload failed"
L.TIPS.ERROR_LEVEL_UP_REWARD = "Server error or network timeout, failed to receive upgrade rewards"
L.TIPS.WARN_NO_PERMISSION = "App is temporarily unable to access the function. Please authorize in setting"
L.TIPS.VIP_GIFT = "Gift for VIP users"
L.TIPS.KAOPU_TIPS = "The game failed to initialize. Please try again"
L.TIPS.INPUT_NUMBER = "Please enter the number"
L.TIPS.INPUT_NO_EMPTY = "Input can not be empty"

-- COMMON MODULE
L.COMMON.LEVEL = "Lv."
L.COMMON.ASSETS = "${1}"
L.COMMON.CONFIRM = "Confirm"        --确定
L.COMMON.CANCEL = "Cancel"          --取消
L.COMMON.AGREE = "Agree"            --同意
L.COMMON.REJECT = "Deny"            --拒绝
L.COMMON.RETRY = "Retry"            --重试
L.COMMON.NOTICE = "Notice"          --温馨提示
L.COMMON.BUY = "Buy"                --购买
L.COMMON.SEND = "Send"              --发送
L.COMMON.BAD_NETWORK = "Network is slow, please try again later!"
L.COMMON.REQUEST_DATA_FAIL = " Network connection interrupt. Please check your network connection and reconnect. "--网络连接中断，请检查您的网络连接是否正常，点击重连按钮重新连接。
L.COMMON.ROOM_FULL = "Audience seats are full, go to another room!"
L.COMMON.USER_BANNED = "Your account was frozen, please contact game manager!"
L.COMMON.SHARE = "Share"      --分享
L.COMMON.GET_REWARD = "Claim"   --领取奖励 
L.COMMON.BUY_CHAIP = "Buy"      --购买
L.COMMON.SYSTEM_BILLBOARD = "Official Announcement"
L.COMMON.DELETE = "Delete"
L.COMMON.CHECK = "View"
L.COMMON.CONGRATULATIONS = "Congratulations"
L.COMMON.REWARD_TIPS = "Congratulations！You get {1}"
L.COMMON.GET = "Receive"--领取
L.COMMON.CLICK_GET = "Click&&Get"--"点击领取"
L.COMMON.ALREADY_GET = " Received "--已领取
L.COMMON.NEXT_GET = "Receive next time"--下次领取
L.COMMON.LOGOUT = "Logout"      --登出
L.COMMON.LOGOUT_DIALOG_TITLE = "Confirm to logout"  --确认退出
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "Your chips  is less than {1}! Why not buy some?"--您的筹码不足最小买入{1}，您需要补充筹码后重试。
L.COMMON.USER_SILENCED_MSG = "You are forbidden to talk, please tap Help->Feedback to contact us." --您的帐号已被禁言，您可以在帮助-反馈里联系管理员处理
L.COMMON.USER_NEED_RELOGIN = " Operation failed. Please login again to retry .Or contact customer service. "--操作失败，请重新登录再试，或者联系客服
L.COMMON.BLIND_BIG_SMALL = "Blind:{1}/{2} "--盲注:{1}/{2}
L.COMMON.NOT_ENOUGH_DIAMONDS = "Sorry, you don’t have enough diamond. "--对不起，您的钻石不足!
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "Not enough chips.Please top up && try again."--"您的筹码不足，请充值后重试"
L.COMMON.NOT_FINISH = "Undone"

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE = "Confirm to logout"
L.COMMON.QUIT_DIALOG_MSG = "Sure to logout the game? We'll miss u! \\(≧▽≦)/~"
L.COMMON.QUIT_DIALOG_MSG_A =  "Make sure to log out? \n Log in tomorrow to get more chips. "--确定要退出了吗?\n明天登录还可以领取更多奖励哦。
L.COMMON.QUIT_DIALOG_CONFIRM = "Still logout!"
L.COMMON.QUIT_DIALOG_CANCEL = "No, I'll stay"
L.COMMON.GAME_NAMES = {
    [1] = "Texas",
    [2] = "Tournament",
    [3] = "Omaha",
    [4] = "Baccarat", --德州百人场
    [5] = "ALL-IN", --德州必下场
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "Lucky packs for new player’s first 3 days. \nLog in Facebook account to get more reward. "--新用户前三次登录，可以免费领取超值幸运大礼包
L.LOGIN.FB_LOGIN = "Facebook login"     --FB账户登录
L.LOGIN.GU_LOGIN = "PLAY AS GUEST"      --游客账户登录
L.LOGIN.REWARD_SUCCEED = "Success to get bonus"   --领取奖励成功
L.LOGIN.REWARD_FAIL = "Failed to get bonus"     --领取失败
L.LOGIN.LOGINING_MSG = "Login..."         --正在登录游戏...
L.LOGIN.CANCELLED_MSG = "Login canceled"      --登录已经取消
L.LOGIN.DOUBLE_LOGIN_MSG = "Your account login in other places"   -- 帐号在其它地方登录
L.LOGIN.LOGIN_DEALING = "Processing login, please be patient"
L.LOGIN.INIT_SDK = "The game is initializing.Please wait."--"游戏正在初始化,请耐心等待."

-- HALL MODULE
L.HALL.USER_ONLINE = "Online players: {1}"
L.HALL.INVITE_TITLE = "Invite friend "--邀请好友
L.HALL.INVITE_FAIL_SESSION = " Failed to get Facebook information. Please try again. "--获取Facebook信息失败，请重试
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "Wrong room ID!"   --你输入的房间号码有误
L.HALL.MATCH_NOT_OPEN = "Coming soon..."--比赛场将尽快开放
L.HALL.NOT_TRACK_TIPS = "Offline now.Unable to follow."--"暂不在线,无法追踪"
L.HALL.TEXAS_LIMIT_LEVEL = "Your Lv is less than {1}.Go upgrade now."--"您的等级不足{1}级，请先玩牌升级后再来!"
L.HALL.TEXAS_GUIDE_TIPS_1 = "You are a good hand now.Go&&challenge a higher room!"--"您已经是高手了,不要在新手场虐菜了!"
L.HALL.TEXAS_GUIDE_TIPS_2 = "You are a good hand now.Play higher blind to win more chips."--"您已经是高手了,可以去适合您的大厂赢钱更多."
L.HALL.TEXAS_GUIDE_TIPS_3 = "Congratulations.Your chip has reached a higher level.Play a higher blind now?"--"恭喜您!您的筹码已经上升到一个新的高度,是否立即换到更高级的场玩牌?"
L.HALL.TEXAS_UPGRADE = "Higher blind"--"立即提升"
L.HALL.TEXAS_STILL_ENTER = "Still in"--"依旧进入"
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
	"ORDINARY", ---初级场
	"EXPERT", ---中级场
	"MASTER",----高级场
}
L.HALL.PLAYER_LIMIT_TEXT = {
	"9P",          --9\n人
	"6P"         --5\n人
}
L.HALL.CHOOSE_ROOM_TYPE = {
	"Classic ",--普通场
	"Fast ",---快速场
}
L.HALL.CHOOSE_ROOM_CITY_NAME = {
	"Bangkok",--曼谷
	"Seoul",--首尔
	"Kuala Lumpur",--吉隆坡
	"Shanghai",--上海

	"Moscow",--莫斯科
	"Tokyo",--东京
	"Milan",--米兰
	"Paris",--巴黎
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "Min {1}/ Max{2} "--最小{1}/最大{2}
L.HALL.CHOOSE_ROOM_BLIND = "Blind {1}/{2} "--盲注:{1}/{2}
L.HALL.GIRL_SHORT_CHAT = {
    "Hello,I'm the dealer Alicia.",--"你好，我是荷官，我叫小爱。",
    "Waiting for you in game room.",--"我在游戏房间等你哦~",
    "Our game is so funny.Hope you can always play with me.",--"我们的游戏很好玩的，经常来玩吧。",
    "Stop it! What are you doing?",--"讨~厌~啦~你在做什么？",
    "Let's play game my dear.",--"亲爱的快去打牌吧。",
    "Do you like it？Like us in Facebook!",--"喜欢吗？那就去粉丝页点个赞。",
    "You’re so cute. Good luck!",--"你好可爱，祝你好运。",
    "Love you~~(￣3￣)~",--"么么哒~ ~(￣3￣)|~",
    "Don't forget to ask your friend to play here.We have lots of free chip for you.",--"别忘了每天点击邀请好友一起来捧场哦！大量免费筹码赠送！",
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "Your level is less than Lv{1}. Please play in Texas until Lv{2}!"
L.HALL.OMAHA_HELP_TITLE = "Omaha Rules"
L.HALL.OMAHA_RULE = [[
Omaha hold 'em (or simply Omaha) is a community card poker game similar to Texas hold 'em, where each player has four hole cards and must make his or her best hand using exactly two of them, plus exactly three of the five common cards. The crad ranking in Omaha is same to Texas hold 'em. Please watch reference in lower left corner of the table.
Though the rules are similar, hole cards in Omaha are more important than in Texas. Because the player MUST use 2 of the 4 hole cards to make the best poker hand. And the player who has the highest hole cards usually win the pot in Omaha.

Differences between Texas hold'em and Omaha
1.Every player gets four cards in Omaha (instead of two in Hold'em)
2.You MUST use two of them to make your best poker hand hand
3.Omaha have 2-11 players at a table when Texas has 2-22.
]]
L.HALL.TRACE_LIMIT_LEVEL = "Failed to track.You need to reach level {1} before entering the room"--"追踪失败,需要等级达到{1}级,才可以进入房间"
L.HALL.TRACE_LIMIT_ANTE = "Failed to track.You need to bring {1} chips to enter the room."--"追踪失败,需要携带{1}筹码,才可以进入房间"
L.HALL.OMAHA_ROOM_CITY_NAME = {
    "Canberra",--堪培拉
    "Sydney",--悉尼
    "Spain",--西班牙
    "Canada",--加拿大
}
L.HALL.TEXAS_MUST_ROOM_CITY_NAME = {
    "Beijing",--北京
    "Mexico",--墨西哥
    "Monte Carlo",--蒙特卡洛
    "Las Vegas",--拉斯维加斯
}
L.HALL.TEXAS_MUST_TITLE = "ALL-IN"
L.HALL.TEXAS_MUST_HELP_TITLE = "Texas ALL-IN Rules"
L.HALL.TEXAS_MUST_RULE = [[
ALL-IN is a new gameplay, each player needs to invest 5 times the big blind bet at the beginning of each game, the pot will expand faster and the gameplay is more exciting.
The chips that the player brings into the game table is a fixed value. When the  player has enough chips before the start of each round, the system will automatically help him.
]]
L.HALL.SMALL_GAME = "More Games"

-- ROOM MODULE
L.ROOM.OPR_TYPE = {
	"Check",--看  牌
	"Fold",--弃  牌
	"Call",--跟  注
	"Raise",--加  注
}
L.ROOM.MY_MONEY = "My money {1} {2}"
L.ROOM.INFO_UID = "ID {1}"
L.ROOM.INFO_LEVEL = "Lv.{1}"
L.ROOM.INFO_WIN_RATE = " Rate of winning {1}% "--胜率:  {1}%
L.ROOM.INFO_SEND_CHIPS = "Give chips"--赠送筹码
L.ROOM.ADD_FRIEND = "Follow" --关注
L.ROOM.DEL_FRIEND = "Unfollow"--取消关注
L.ROOM.FORBID_CHAT = "Block"
L.ROOM.CANCEL_FORBID_CHAT = "Blocked"
L.ROOM.NO_SEND_CHIP_TIPS = "Unable to send"--"不可赠送"
L.ROOM.ADD_FRIEND_SUCC_MSG = " Added friend "--添加好友成功
L.ROOM.ADD_FRIEND_FAILED_MSG = "Fail to add friend"--添加好友失败
L.ROOM.DELE_FRIEND_SUCCESS_MSG = " Deleted friend "--删除好友成功
L.ROOM.DELE_FRIEND_FAIL_MSG = "Fail to delete"--删除好友失败
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "You can only give chips to friends in ordinary room."--只有普通场才可以赠送筹码
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "You don't have enough chips to tip the dealer "--你的筹码不够多，不足给荷官小费
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "Sit down to send chips."--坐下才可以赠送筹码
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "Chip is not enough."--钱不够啊
L.ROOM.SEND_CHIP_TOO_OFTEN = " Too many send request ."--赠送的太频繁了
L.ROOM.SEND_CHIP_TOO_MANY = " You send too much chips. "--赠送的太多了
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "You can't use items here. "--比赛场不能发送互动道具
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = " You must sit down to use items. "--坐下才能发送互动道具
L.ROOM.SEND_HDDJ_NOT_ENOUGH = " Not enough items, buy some in store. "--您的互动道具数量不足，赶快去商城购买吧
L.ROOM.SEND_HDDJ_FAILED = "Send prop failed.Please try again."--"发送互动道具失败,请重试"
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = " Sit down to send meme. "--坐下才可以发送表情
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "Sit down to try again."--您还未坐下，请坐下后重试
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2}P)  Room ID:{3}  Blind:{4}/{5}"
L.ROOM.PRIVATE_ROOM_INFO = "Privte Room({1}P)  Room ID:{2}  Blind:{3}/{4}"
L.ROOM.PRIVTE_INFO = "Available time of room {1}"--房间剩余时间{1}
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "Fail to send loudspeaker message. "--发送大喇叭消息失败
L.ROOM.NOT_ENOUGH_LABA = "Your loudspeaker is not enough"
L.ROOM.CHAT_MAIN_TAB_TEXT = {
	"Message", --消息
	" Message logging "--消息记录
}
L.ROOM.USER_CARSH_REWARD_DESC = " You get {1} chips bankruptcy relief . Be cautious because you can get it only 3 times per day."--您获得了{1}筹码的破产补助，每天只有三次机会获得，且用且珍惜
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "Buy chip now to win back!"--您也可以立即购买，输赢只是转瞬的事
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = " No more bankruptcy relief. You can purchase chips in store or login tomorrow to get free chips ."--您已经领完所有破产补助，您可以去商城购买筹码，每天登录还有免费筹码赠送哦！
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = " Winning is waiting ahead, don't give up! Buy chips to win back"--输赢乃兵家常事，不要灰心，立即购买筹码，重整旗鼓。
L.ROOM.WAIT_NEXT_ROUND = " Please wait for next round"--请等待下一局开始
L.ROOM.LOGIN_ROOM_FAIL_MSG = "Failed to login"--登录房间失败
L.ROOM.BUYIN_ALL_POT= " Jackpot"--全部奖池
L.ROOM.BUYIN_3QUOT_POT = " 3/4\nJackpot"--3/4奖池
L.ROOM.BUYIN_HALF_POT = " 1/2\nJackpot"--1/2奖池
L.ROOM.BUYIN_TRIPLE = " Triple\nRaise"--3倍反加
L.ROOM.CHAT_TAB_SHORTCUT = "Fast chat"--快捷聊天
L.ROOM.CHAT_TAB_HISTORY = "Chating record"--聊天记录
L.ROOM.INPUT_HINT_MSG = "Click to input message"--点击输入聊天内容
L.ROOM.INPUT_ALERT = "Please input valid content "--请输入有效内容
L.ROOM.CHAT_SHIELD = "You masked {1} message"--您已成功屏蔽的发言
L.ROOM.CHAT_SHORTCUT = {
  "Hello, everybody!",         
  "Fast, please!",           
  "ALL IN!!",          
  "Be patient!",        
  "Good hand!",            
  "No one can beat me here!",       
  "Thank you  for the chips!",
  "Call and ALL IN!",        
  "I'm willful cause I'm rich!",
  "Bad luck!",
  "Don't fight!",
  "Are you single now?",
  "Bad hand.Go another room.",
  "Nice to meet you.",
  "So lucky today!",
  "Please give me some chip.",
  "Call and ALL IN!",
  "I'll buy chips and go back soon.",
  "Show your cards.",
  "I have to go now，bye."
}
L.ROOM.VOICE_TOOSHORT = "Message too short"
L.ROOM.VOICE_TOOLONG = "Message too long"
L.ROOM.VOICE_RECORDING = "Slide up to cancel"
L.ROOM.VOICE_CANCELED = "Voice message canceled"
L.ROOM.VOICE_TOOFAST = "Operation too frequent"
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
  " Thank you {1} Good luck! ",--感谢你{1}！幸运必将常伴你左右！
  " Thank you {1}.Have fun. ",--感谢你{1}！好运即将到来！
  " Thank you dear {1}",--感谢好心的{1}
}
--买入弹框
L.ROOM.BUY_IN_TITLE = "Buy in chips"--买入筹码
L.ROOM.BUY_IN_BALANCE_TITLE = "Your Capital:"--您的账户余额
L.ROOM.BUY_IN_MIN = "MIN buy-in "--最低买入
L.ROOM.BUY_IN_MAX = "MAX buy-in "--最高买入
L.ROOM.BUY_IN_AUTO = "Auto buy-in "--筹码不足时自动买入
L.ROOM.BUY_IN_AUTO_MIN = "Auto buy-in when chips＜Min. buy-in"
L.ROOM.BUY_IN_BTN_LABEL = "Buy in"--买入坐下
L.ROOM.ADD_IN_TITLE = "Buy-in Chips"
L.ROOM.ADD_IN_BTN_LABEL = "Buy-in"
L.ROOM.ADD_IN_BTN_TIPS = "Sit to buy-in chips"
L.ROOM.ADD_IN_BTN_TIPS_2 = "Not enough chips to buy-in"
L.ROOM.ADD_IN_BTN_TIPS_3 = "It is already the Max buy-in"
L.ROOM.ADD_IN_SUC_TIPS = "Success to buy-in, system will buy-in {1} chips for you automatically next hand."
L.ROOM.BACK_TO_HALL = "Lobby "--返回大厅
L.ROOM.CHANGE_ROOM = "Change room "--换  桌
L.ROOM.SETTING = "Settings"--设  置
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "Not enough chips for MIN buy-in, change room or buy chips? "--您的筹码不足当前房间的最小携带，您可以点击自动换桌系统帮你选择房间或者补足筹码重新坐下。
L.ROOM.AUTO_CHANGE_ROOM = "Change room"--自动换桌
L.ROOM.USER_INFO_ROOM = "Profile"--个人信息
L.ROOM.CHARGE_CHIPS = "Buy chips"--补充筹码
L.ROOM.ENTERING_MSG = "Loading, please wait...\nYou need both courage and strategy to win!"--正在进入，请稍候...\n有识尚需有胆方可成赢家
L.ROOM.OUT_MSG = "Logout processing ..."--正在退出，请稍候...
L.ROOM.CHANGING_ROOM_MSG = "Changing room..."--正在更换房间..
L.ROOM.CHANGE_ROOM_FAIL = "Failed to change room, retry?"--更换房间失败，是否重试？
L.ROOM.STAND_UP_IN_GAME_MSG = "You are still in round,.Make sure to stand up?"--您还在当前牌局中，确认站起吗？
L.ROOM.LEAVE_IN_GAME_MSG = " You are playing now.Make sure to leave?"--您还在当前牌局中，确认要离开吗？
L.ROOM.RECONNECT_MSG = " Re-connecting... "--正在重新连接..
L.ROOM.OPR_STATUS = {
	" Fold ",--弃  牌
	"ALL_IN",-- ALL_IN
	" Call ",--跟  注
	" Call\n{1} ",--跟注 {1}
	" Small Blind ",--小  盲
	" Big Blind ",--大  盲
	" Check ",--看  牌
	" Raise\n{1} ",--加注 {1}
	" Raise ",--加  注
}
L.ROOM.AUTO_CHECK = " Auto Check "--自动看牌
L.ROOM.AUTO_CHECK_OR_FOLD = " Check/Fold "--看或弃
L.ROOM.AUTO_FOLD = " Auto Fold "--自动弃牌
L.ROOM.AUTO_CALL_ANY = " Call any "--跟任何注
L.ROOM.FOLD = " Fold "--弃  牌
L.ROOM.ALL_IN = "ALL IN"-- ALL IN
L.ROOM.CALL = " Call "--跟  注
L.ROOM.CALL_NUM = " Call{1} "--跟注 {1}
L.ROOM.SMALL_BLIND = " Small Blind "--小盲
L.ROOM.BIG_BLIND = " Big Blind "--大盲
L.ROOM.RAISE = " Raise "--加  注
L.ROOM.RAISE_NUM = " Raise{1} "--加注 {1}
L.ROOM.CHECK = " Check "--看  牌
L.ROOM.BLIND3 = "3xBig\nblind"--3x大盲-
L.ROOM.BLIND4 = "4xBig\nblind"--4x大盲
L.ROOM.TABLECHIPS = "1xpot "--
L.ROOM.TIPS = {
	"Tips: you can change your profile picture by click your photo", --小提示：击自己的头像弹框可更换头像
	"Tips: you will lost chips already bet in jackpot if your hands is smaller",  --小经验：当你牌比对方小的时候，你会输掉已经押上的所有筹码
	"Tips: set auto buy-in in Settings to save time",--小提示：设置页可以设置进入房间是否自动买入坐下。
	"Tips: set Remind by Shake in Settings",  --小提示：设置页可以设置是否震动提醒。
	"Tips：Guest account can change your profile pictures",--游客玩家可以自定义自己的头像。
	"Tips：Throw items to the guy you hate!", --用互动道具砸你讨厌玩家。
	"All whales come from fishes! Success is ahead, never give up!",  --高手养成：所有的高手，在他会游戏之前，一定是一个游戏的菜鸟
	"Raise positively to control the round if you have good hands",  --有了好牌要加注，要掌握优势，主动进攻。
	"Patiently observe your opponents! Don't be cheated by them!",--留意观察对手，不要被对手的某些伎俩所欺骗。
	"Make your opponents be afraid of you!",  --要打出气势，让别人怕你。
	"Control your emotion, win fixed rounds!",  --控制情绪，赢下该赢的牌。
	"Keep patient to wait for chance of All-in", --忍是为了下一次All In。
	"Impulse is demo!", --冲动是魔鬼，心态好，好运自然来。
	"Feel unlucky? Maybe you need change your seat position",--风水不好时，尝试换个位置。
	"Lost of round is affordable, but lost of confidence isn't!", --输牌并不可怕，输掉信心才是最可怕的。
	"You can't control win or lose in a round, but how many chips won/lost in all rounds", --你不能控制输赢，但可以控制输赢的多少。
	"Luck is not stable, but knowledge will stay in your mind",--运气有时好有时坏，知识将伴随你一生。
	"Bluff is a good tool, strategically use bluff to win more!", --诈唬是胜利的一大手段，要有选择性的诈唬。
	"Bet by brain, not by heart",--下注要结合池底，不要看绝对数字。
	"Rare players can professionally use All-in" --All In是一种战术，用好并不容易。
	









}
L.ROOM.SHOW_HANDCARD = "Show hands"--亮出手牌
L.ROOM.SERVER_UPGRADE_MSG = " Server is updating, will be back soon..."--服务器正在升级中，请稍候..
L.ROOM.KICKED_BY_ADMIN_MSG = " You are kicked out by admin "--您已被管理员踢出该房间
L.ROOM.KICKED_BY_USER_MSG = " You are kicked out by player {1} "--您被用户{1}踢出了房间
L.ROOM.TO_BE_KICKED_BY_USER_MSG = " Player {1} kick you out, you will return to lobby after this round" --您被用户{1}踢出房间，本局结束之后将自动返回大厅
L.ROOM.BET_LIMIT = "Fail to call. Max 100M per round. "--下注失败，您单局下注不能超过最大下注100M限制。
L.ROOM.BET_LIMIT_1 = " Fail to call. Max {1} per round."--下注失败，您单局下注不能超过最大下注{1}限制。
L.ROOM.NO_BET_STAND_UP = "You did not operate for 3 hands.Automatically stood up."--"你三局未操作,已自动站起"
L.ROOM.PRE_BLIND = "Ante"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "You can't sit down with same IP address"--坐下失败，同一IP不能坐下
T["SEAT_NOT_EMPTY"] = "The seat is occupied "--坐下失败，该桌位已经有玩家坐下。
T["TOO_RICH"] = "Your chip is too much to play here"--坐下失败，这么多筹码还来新手场虐人？
T["TOO_POOR"] = "Not enough chips to stay"--坐下失败，筹码不足无法进入非新手场房间。
T["NO_OPER"] = "You stand up automatically for not having any operation 3 times. Sit down to start again."--您超过三次没有操作，已被自动站起，重新坐下即可重新开始
L.ROOM.SERVER_STOPPED_MSG = "The system is being stopped for maintenance. Please be patient."--系统正在停服维护, 请耐心等候
L.ROOM.GUIDEHEIGHT = "Play in {1} to win more chips."--去{1}场可赢更多钱
L.ROOM.GUIDELOW = " Play in {1} for less lose."--去{1}场可以较少损失
L.ROOM.CARD_POWER_DESC = [[
The hand strength meter computing winrate based on hole cards and common cards, for reference only.

Free use in ordinary room.

Open by default.You can also close and open it again from the setting.
]]

--STORE
L.STORE.TOP_LIST = {
	"Chips",--筹码
	"Diamond",--钻石
	"Items",--道具
	"VIP"
}
L.STORE.NOT_SUPPORT_MSG = "Your account doesn't support payment "--您的账户暂不支持支付
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "Payed already. Goods are sending to you."--已支付成功，正在进行发货，请稍候..
L.STORE.PURCHASE_CANCELED_MSG = "Payment canceled "--支付已经取消
L.STORE.PURCHASE_FAILED_MSG = "Failed to pay .Please try again later."--支付失败，请重试
L.STORE.PURCHASE_FAILED_MSG_2 = "Please enter the right card number and password."--"请输入正确卡号和密码"
L.STORE.PURCHASE_FAILED_MSG_3 = "Used card"--"此卡已经使用过"
L.STORE.PURCHASE_FAILED_MSG_4 = "Invalid card"--"此卡无效"
L.STORE.DELIVERY_FAILED_MSG = "Network error .System will try again next time when you go in store."--网络故障，系统将在您下次打开商城时重试。
L.STORE.DELIVERY_SUCC_MSG = "Goods sent success. Thanks for the purchase"--发货成功，感谢您的购买。
L.STORE.TITLE_STORE = "Store"--商城
L.STORE.TITLE_CHIP = "Chips"--筹码
L.STORE.TITLE_PROP = "Items"--互动道具
L.STORE.TITLE_MY_PROP = "My items"--我的道具
L.STORE.TITLE_HISTORY = "Shopping record"--购买记录
L.STORE.RATE_DIAMONDS = "1{2}={1} diamond"--1{2}={1}钻石
L.STORE.RATE_CHIP = "1{2}={1}Chips"--1{2}={1}筹码
L.STORE.RATE_PROP = "1{2}={1}Items"--1{2}={1}个道具
L.STORE.FORMAT_DIAMONDS = "{1} Diamond"--{1} 钻石
L.STORE.FORMAT_CHIP = "{1} Chips"--筹码
L.STORE.FORMAT_PROP = "{1} Items"--道具
L.STORE.FORMAT_HDDJ = "{1} Items"--{1} 互动道具
L.STORE.FORMAT_DLB = "{1} Loudspeaker "--{1}大喇叭
L.STORE.FORMAT_LPQ = "{1} Gift Voucher"
L.STORE.FORMAT_DHQ = "{1} Redeem Voucher"
L.STORE.FORMAT_MYB = "{1} Ant Coins"
L.STORE.HDDJ_DESC = "Use item {1} times"
L.STORE.DLB_DESC = "Broadcast to all the players in game for {1} times"
L.STORE.BUY = "Buy "--购买
L.STORE.USE = "Use "--使用
L.STORE.BUY_DESC = "Buy {1}"--购买 {1}
L.STORE.RECORD_STATUS = {
	"Paid",--已下单
	"Goods sent",--已发货
	"Refunded"--已退款
}
L.STORE.NO_PRODUCT_HINT = "No item"--暂无商品
L.STORE.NO_BUY_HISTORY_HINT = "No payment "--暂无支付记录
L.STORE.BUSY_PURCHASING_MSG ="Payment processing, please wait..."--正在购买，请稍候
L.STORE.CARD_INPUT_SUBMIT = "TOP UP"--充值
L.STORE.BLUEPAY_CHECK = "Make sure to pay {1} for {2}"
L.STORE.GENERATE_ORDERID_FAIL = "Fail to order. Please try again! "--下单失败，请重试！
L.STORE.INPUT_NUM_EMPTY = "Serial number empty! Please enter again!"--卡号输入不能为空，请重新输入！
L.STORE.INPUT_PASSWORD_EMPTY = "Password empty. Please enter again!"--密码输入不能为空，请重新输入！
L.STORE.INPUT_NUM_PASSWORD_EMPTY = " Serial number or password empty! Please enter again!"--卡号或密码输入为空，请重新输入！
L.STORE.INPUT_CRAD_NUM = "Enter the Serial number"--请输入卡号
L.STORE.INPUT_CRAD_PASSWORD = "Enter the password" --请输入密码
L.STORE.QUICK_MORE = "More"
L.STORE.REAL_TAB_LIST = {
    "Gift Voucher",--礼品券
    "Redeem Voucher",--兑换券
    "Ant Coins",--开源币
}
L.STORE.REAL_ADDRESS_BTN = "Shipping\nAddress"--收货地址
L.STORE.REAL_EXCHANGE_BTN = "Redeem"--兑换
L.STORE.ADDRESS_POP_TITLE = "Edit shipping address"--编辑收货地址
L.STORE.REAL_TIPS = "Please fill in the real name and contact information."--请务必填写真实姓名和联系方式,以便获奖后联系
L.STORE.REAL_TIPS_2 = "Please fill in the information."--请把信息填写完整
L.STORE.REAL_SAVE = "Save"--保存
L.STORE.REAL_TITLES = {
    "Full name:",--收货人:
    "Phone\nnumber:",--手机号码:
    "Shipping\naddress:",--收货地址:
    "Postcode:",--邮编
    "E-mail:"--电子邮箱:
}
L.STORE.REAL_PLACEHOLDER = {
    "Name",--姓名
    "Phone number",--手机号码
    "Please be sure to fill in the detailed province, city, district (county), street and house number information.",--请务必填写详细的省.市.区(县)及街道门牌信息
    "Postcode",--邮编
    "E-mail"--邮箱地址
}
L.STORE.EXCHANGE_REAL_SUCCESS = "Wonderful！You redeemed {1}！We will do the delivery soon."--"恭喜您,兑换{1}成功,我们会尽快给您发货!"
L.STORE.EXCHANGE_REAL_FAILED_1 = "Not enough {1}.Use {3} to redeem {2}."--"你的{1}数量不足,兑换{2}需要{3}"
L.STORE.EXCHANGE_REAL_FAILED_2 = "Redeem failed. Please try again."--"兑换失败,请重试!"
L.STORE.TAB_LIST = {
    "Store",--"商城"
    "Redeem gift"--礼品兑换
}
L.STORE.CASH_CARD_TITLE = "Redeem recharge card"--"兑换充值卡"
L.STORE.CASH_CARD_TIPS_1 = "Please enter your true and valid phone number.\nWe will send the information of the recharge card to your mobile phone."--"请输入您的手机号码,务必真实有效的.\n我们将把充值卡的信息,发送到您填写的手机上."
L.STORE.CASH_CARD_TIPS_2 = "Please enter your phone number."--"请输入您的手机号码"
L.STORE.CASH_CARD_TIPS_3 = "Please enter a 10 digit number."--"请输入10位由数字组成的电话号码"
L.STORE.CASH_CARD_TIPS_4 = "The number you entered is {1}-{2}-{3}. We will send the information of the recharge card to this number."--"您输入的电话号码是{1}-{2}-{3},我们将向此号码发送充值卡的信息."

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "Your chips is less than 5000.Unable to use VIP emoji." --您的场外筹码不足5000,暂时无法使用VIP表情
L.VIP.SEND_EXPRESSIONS_TIPS = "You are not VIP now.You can cost chips to use VIP emoji or be VIP to use it free and other privileges." --您还不是VIP用户,使用VIP表情需要扣除相应的筹码,成为VIP即可免费使用,还有超多优惠和特权.
L.VIP.BUY_PROP = "Buy prop"--购买道具
L.VIP.OPEN_VIP = "Be VIP"--成为VIP
L.VIP.COST_CHIPS = "Cost {1} chips"--花费{1}筹码
L.VIP.LIST_TITLE = {
    "Price", --价格
    -- "Card kick", --踢人卡
    "VIP Hand strength meter", --VIP牌力指示器
    "VIP Gift", --VIP礼物
    "VIP Prop", --VIP道具
    "VIP Emoji", --VIP表情
    -- "Private room discount", --私人房折扣
    -- "Bankrupt discount", --破产优惠
    -- "EXP", --经验
    "Daily bonus", --每天登录
    "Get chips", --立即赠送筹码
}
L.VIP.NOT_VIP = "Not VIP" --未购买
L.VIP.AVAILABLE_DAYS = "Days left {1}" --剩余{1}天
L.VIP.OPEN_BTN = "{1}diamonds to be VIP" --开通{1}钻石
L.VIP.AGAIN_BTN = "{1}diamonds to renewal" --续费{1}钻石
L.VIP.CONTINUE_BUY = "Buy" --继续购买
L.VIP.BROKE_REWARD = "Get {1}% chips {2} Times per day" --多送{1}% 每天{2}次
L.VIP.LOGINREWARD = "{1}*31 Days" --{1}*31天
L.VIP.PRIVATE_SALE = "{1} off" --{1}折
L.VIP.SEND_PROPS_TIPS_1 = "Props free for VIP"--"互动道具VIP免费任意使用"
L.VIP.SEND_PROPS_TIPS_2 = "No props.You can cost chips to buy some or be VIP to use it free and other privileges."--"您的互动道具已用完,您可以选择花费筹码使用,成为VIP即可免费使用,还有超多优惠和特权."
-- L.VIP.KICK_CARD = "Card kick" --踢人卡
-- L.VIP.KICK_SUCC = "踢人成功，玩家将在本局结束后被提出牌桌." --
-- L.VIP.KICK_FAILED = "踢人失败,请稍后重试" --
-- L.VIP.KICKED_TIP = "抱歉，您被玩家{1}踢出牌局，将在本局结束后离开此牌桌。" --
-- L.VIP.KICKER_TOO_MUCH = "您当天的使用次数已达到上限，请遵守牌桌秩序，严禁恶意踢人。" --
-- L.VIP.KICKED_ENTER_AGAIN = "您已被踢出此房间，20分钟内无法进入，你可以选择其他房间或者重新快速开始" --
L.VIP.BUY_SUCCESS = " Congratulations! You are VIP now!" --恭喜你,购买VIP成功!
L.VIP.BUY_FAILED = "Purchase failed.Please try again." --VIP购买失败,请重试
L.VIP.BUY_FAILED_TIPS = "Not enough diamonds.Please buy some!" --您的钻石不足,请先购买钻石!
L.VIP.BUY_TIPS_1 = "Cost {2} diamonds to be VIP {1}" --您将购买{1},需要花费{2}钻石.
L.VIP.BUY_TIPS_2 = "Your VIP {1} is unexpired.Make sure to give up all the privileges of VIP{2} and be VIP{3}?" --您目前是{1}VIP还未到期,如果您选择继续购买,将放弃现在的{2}VIP的所有特权并立即成为{3}VIP,是否继续?
L.VIP.BUY_TIPS_3 = "You are {1} now and will cost {3} diamondsto renewal this service for {2} days." --您现在是{1}VIP,将对此等级VIP服务进行续费,使用期限延长{2}天,需要花费{3}钻石.
L.VIP.LEVEL_NAME = {
    "Baron", --领主
    "Duke", --贵族
    "King", --王族
    "Emperor" --皇族
}
L.VIP.NO_VIP_TIPS = "You are not VIP. Be VIP to use privileges now."--"您还不是VIP用户,是否立即成为VIP,还有超多优惠和特权."
L.VIP.CARD_POWER_TIPS = "You are not VIP."--"您还不是VIP用户,是否"
L.VIP.CARD_POWER_OPEN_VIP = "Be VIP now."--"立即开通"
L.VIP.VIP_AVATAR = "Dynamic profile VIP"--"VIP动态头像"
L.VIP.NOR_AVATAR = "Ordinary profile"--"普通头像"
L.VIP.SET_AVATAR_SUCCESS = "Set profile success!"--"设置头像成功!"
L.VIP.SET_AVATAR_FAILED_1 = "Set profile failed. Please try again."--"设置头像失败,请重试."
L.VIP.SET_AVATAR_FAILED_2 = "Your VIP level is not enough. Please choose another profile."--"您的VIP等级不够,请选择其他头像."
L.VIP.SET_AVATAR_TIPS = [[
Function available for VIP only. Be VIP to use dynamic profile and privileges.

Be VIP now?
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "Log in with Facebook.Get"--"Facebook登录领取"
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}"
L.LOGINREWARD.REWARD_BTN        = "Get {1}"--领取{1}
L.LOGINREWARD.GET_REWARD_FAILED = "Fail to log in. Please try again later."--签到失败，请重试!
L.LOGINREWARD.VIP_REWARD_TIPS   = "Log in bonus VIP"--"VIP登录奖励"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"--
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2} EXP"  --经验值
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
	"General room",--常规场
	"SNG",--坐满即玩
	"MTT "--锦标赛
}
L.USERINFO.BOARD_SORT = {
    "Time",
    "Win"
}
L.USERINFO.NO_RECORD = "No record"
L.USERINFO.LAST_GAME = "Last hand"
L.USERINFO.NEXT_GAME = "Next hand"
L.USERINFO.PLAY_TOTOAL_COUNT = "Round: "--牌局
L.USERINFO.PLAY_START_RATE = "VPIP: "--入局率
L.USERINFO.WIN_TOTAL_RATE = "Wining rate: "--胜率
L.USERINFO.SHOW_CARD_RATE = "WTSD: "--摊牌率
L.USERINFO.MAX_CARD_TYPE = "Best hand "--最大牌型
L.USERINFO.JOIN_MATCH_NUM = "Round played"--参赛次数
L.USERINFO.GET_REWARD_NUM = "award round"--获奖次数
L.USERINFO.MATCH_BEST_SCORE = "Best results of MTT "--锦标赛最好成绩
L.USERINFO.MY_CUP = "My trophy "--我的奖杯
L.USERINFO.NO_CHECK_LINE = "Did not fill in "--未填写
L.USERINFO.BOARD = "History"--牌局记录
L.USERINFO.MY_PACK = "My bag"--我的背包
L.USERINFO.ACHIEVEMENT_TITLE = "Achievement"--成就
L.USERINFO.REAL_STORE = "Redeem Gift"
L.USERINFO.LINE_CHECK_NO_EMPTY = "Line ID can not be empty! please enter again "-- Line号不能为空！请重新输入
L.USERINFO.NICK_NO_EMPTY = "Name empty! Please input again."--"名字不能为空！请重新输入"
L.USERINFO.LINE_CHECK_ONECE = "Line identification is only allowed once a day "--一天只能提交一次Line认证
L.USERINFO.LINE_CHECK_FAIL = "Fail to submit identification. Please try again. "--提交认证失败，请重试!
L.USERINFO.LINE_CHECK_SUCCESS = "Identification submitted"--提交认证成功
L.USERINFO.GET_BOARD_RECORD_FAIL = "Failed to obtain personal record information. Please close the popup and try again!"--获取个人战绩信息失败，请关闭弹窗重试！
L.USERINFO.PACKAGE_INFO = {
	{
		title = "Item",--互动道具
		desc = "You can interact with others by items"--可以在牌桌上对其他玩家释放的互动道具
	},
	{
		title = "Loudspeaker",--大喇叭
		desc = "Broadcast to all the players in world."--可以在牌桌上对全服的玩家进行广播
	},
    {
        title = "Redeem Voucher",--兑换券
        desc = "Use many vouchers to redeem the corresponding gift."--可花费多张劵兑换相应的礼品
    },
    {
        title = "Gift Voucher",--礼品券
        desc = "Redeem the gift on the gift voucher."--可直接兑换券上相应的礼品
    },
    {
        title = "Ant Coins",--开源币
        desc = "A kind of very valuable digital currency."--非常有价值的一种数字货币
    },
}
L.USERINFO.MARK_TEXT = {
	"Calling\nStations",--跟注站
	"Maniacs",--疯子
	"Shark",--紧凶型
	"Mice",--紧弱型
	"Rock",--岩石型
	"Yellow\nAlert",--黄色警报
	"Fish",--松弱鱼
	"Custom "--自定义
}
L.USERINFO.MARK_TITLE = "Mark player"--标记玩家
L.USERINFO.MARK_TIPS = "Click the check mark "--点击选中标记
L.USERINFO.MARK_SUCCESS = "Marked"--标记玩家成功
L.USERINFO.MARK_FAIL = "Fail to mark.Please try later."--标记玩家失败，请重试
L.USERINFO.MARK_NO_EMPTY = "Mark can not be empty! please enter again "--玩家标记输入不能为空，请重新输入
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "SD card is required to upload photo "--没有安装SD卡，无法使用头像上传功能
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "Failed to get image "--获取图像失败
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "Failed to upload, pls try again later "--上传头像失败，请稍后重试
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "Uploading, please wait... "--正在上传头像，请稍候...
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "Success to upload "--上传头像成功-- FRIEND MODULE
L.USERINFO.CHOOSE_COUNTRY_TITLE = "Select Country"
L.USERINFO.COUNTRY_LIST = {
    {
        title = "Asia",
        list = {
            "United Arab Emirates",
            "Macao",
            "Pakistan",
            "Philippines",
            "Kazakhstan",
            "Korea",
            "Laos",
            "Malaysia",
            "Myanmar",
            "Japan",
            "Taiwan",
            "Thailand",
            "Hong Kong",
            "Singapore",
            "Israel",
            "India",
            "Indonesia",
            "Vietnam",
            "China",
        }
    },
    {
        title = "North America",
        list = {
            "Panama",
            "Costa Rica",
            "Cuba",
            "Canada",
            "United States",
            "Mexico",
        }
    },
    {
        title = "South America",
        list = {
            "Argentina",
            "Paraguay",
            "Brazil",
            "Colombia",
            "Peru",
            "Venezuela",
            "Uruguay",
            "Chile",
        }
    },
    {
        title = "Europe",
        list = {
            "Austria",
            "Belarus",
            "Belgium",
            "Poland",
            "Germany",
            "Russia",
            "France",
            "Finland",
            "Netherlands",
            "Czech Republic",
            "Croatia",
            "Lithuania",
            "Romania",
            "Monaco",
            "Portugal",
            "Sweden",
            "Switzerland",
            "Serbia",
            "Slovenia",
            "Ukraine",
            "Spain",
            "Greece",
            "Hungary",
            "Italy",
            "Britain",
        }
    },
    {
        title = "Oceania",
        list = {
            "Australia",
            "New Zealand",
        }
    },
    {
        title = "Africa",
        list = {
            "Congo",
            "Ghana",
            "Zimbabwe",
            "South Africa",
            "Nigeria",
            "Senegal",
        }
    },
}

-- FRIEND MODULE
L.FRIEND.TITLE = "Friend "--好友
L.FRIEND.NO_FRIEND_TIP = " No friend" --暂无好友
L.FRIEND.SEND_CHIP = "Send chips"--赠送筹码
L.FRIEND.RECALL_CHIP = "Recall"--召回+{1}
L.FRIEND.ONE_KEY_SEND_CHIP = "Send to all"--一键赠送
L.FRIEND.ONE_KEY_RECALL = "Recall all"--一键召回
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "Not enough chips! Buy now and try later."--您的携带筹码的一半不足全部送出，请先补充筹码后重试。
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "Make sure to send friend {1} {2} chips? "--确定要赠你给您的{1}位好友总计{2}筹码吗？
L.FRIEND.ADD_FULL_TIPS = "Your friend has reached the upper limit of {1}. System will remove some friends who do not play cards for long time."--您的好友已达到{1}的上限，系统将根据玩牌情况删除长久不玩牌的好友。
L.FRIEND.SEND_CHIP_WITH_NUM = "Send {1} chips"--赠送{1}筹码
L.FRIEND.SEND_CHIP_SUCCESS = "You have sent {1} chips to friend. "--您成功给好友赠送了{1}筹码。
L.FRIEND.SEND_CHIP_PUSH = "{1} send 10K chips to you. Receive now! "--赠送了10K筹码给你，快来领取吧！
L.FRIEND.SEND_CHIP_TOO_POOR = "Not enough chips! Buy now"--您的筹码太少了，请去商城购买筹码后重试。
L.FRIEND.SEND_CHIP_COUNT_OUT = "You've sent chips to this friend today. Please try tomorrow."--您今天已经给该好友赠送过筹码了，请明天再试。
L.FRIEND.SELECT_ALL = "Choose all"--全选
L.FRIEND.SELECT_NUM = "Choose {1} people"--选择{1}人
L.FRIEND.DESELECT_ALL = "Deselect"--取消选择
L.FRIEND.SEND_INVITE = "Invite"--邀请
L.FRIEND.INVITE_SENDED = "Invited"
L.FRIEND.INVITE_SUBJECT = "You'll love the excitement!" --您绝对会喜欢
L.FRIEND.CALL_FRIEND_TO_GAME = "Good game! Play with me!"
L.FRIEND.INVITE_CONTENT = "Come and play this enjoyable and exciting poker games with me, 150 000 chips are FREE for you here! Super "..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP = "You've selected {1} friend Invite to get {2} chips."--您已选择了{1}位好友，发送邀请即可获得{2}筹码的奖励
L.FRIEND.INVITE_SELECT_TIP_1 = "You've selected"
L.FRIEND.INVITE_SELECT_TIP_2 = "friend Invite to get"
L.FRIEND.INVITE_SELECT_TIP_3 = "chips"
L.FRIEND.INVITE_SUCC_TIP = "Success to invite, get {1} chips bonus!"--成功发送了邀请，获得{1}筹码的奖励！
L.FRIEND.INVITE_SUCC_FULL_TIP = "Success to invite, get {1} chips bonus today!"--成功发送邀请，今日已获得{1}邀请发送奖励。
L.FRIEND.INVITE_FULL_TIP = "The Facebook invitation has reached the limit. You can send your invitation codefor more chips."--您今日已达邀请上限，请明日再发送
L.FRIEND.RECALL_SUCC_TIP = "Reward {1} received. System will send the reward {2} after your friend log in."--发送成功奖励{1}，好友上线后即可获赠{2}筹码奖励。
L.FRIEND.RECALL_FAILED_TIP = "Fail to send. Please try again later."--发送失败，请稍后重试
L.FRIEND.INVITE_LEFT_TIP = "You can invite {1} friend today."--今天还可以邀请{1}个好友！
L.FRIEND.CANNOT_SEND_MAIL = "You didn’t set an e-mail account. Go set now?"--您还没有设置邮箱账户，现在去设置吗？
L.FRIEND.CANNOT_SEND_SMS = "Sorry, SMS loading failed."--对不起，无法调用发送短信功能！
L.FRIEND.MAIN_TAB_TEXT = {
	"I like ",--我关注的
	"Like me",--关注我的
	"More friends"--更多好友
}
L.FRIEND.INVITE_EMPTY_TIP = "Please choose a friend."--请先选择好友
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "You can have MAX {1} friends. Please delete some to add new friends."--您的好友已达到{1}上限，请删除部分后重新添加
L.FRIEND.SEARCH_FRIEND = "Please enter keywords"--请输入FB好友名称
L.FRIEND.INVITE_REWARD_TIPS_1 = "Inviting"
L.FRIEND.INVITE_REWARD_TIPS_2 = "friend to get"
L.FRIEND.INVITE_REWARD_TIPS_3 = ".The more friends the more chips. After friends’login,you can get "
L.FRIEND.SEARCH = "Search"--查找
L.FRIEND.CLEAR = "Delete"--清除
L.FRIEND.INPUT_USER_ID = "Click to enter player ID"--点击输入玩家ID
L.FRIEND.INPUT_USER_ID_NO_EXIST = "The ID you entered do not exist. Please confirm and try again later."--您输入的ID不存在，请确认后重新输入
L.FRIEND.NO_SEARCH_SELF = "Can not search my ID.Please input again. "--无法查找自己的ID，请重新输入
L.FRIEND.NO_LINE_APP = "You did not install the Line app.Please invite by other means. "--您没有安装Line应用,请使用其他方式邀请
L.FRIEND.INVITE_REWARD_TIPS = "Reach the invitation number there are super gift package for you.\nClick on the package for details.You invited {1} friends，and got {2} chips."--达成邀请人数还有超级大礼包赠送，可点击礼包查看详情\n您累计成功邀请了{1}位好友，获得了{2}的筹码奖励
L.FRIEND.INVITE_FB_FRIEND_TITLE = "Invite FB Friends"--邀请FB好友
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "Send 1 invitation get {1}.\nGet {2} if friends join in."--每天发送就送{1}\n成功一个再送{2}筹码
L.FRIEND.INVITE_CODE_TITLE = "Invitation Code"--邀请码
L.FRIEND.INVITE_CODE_CONTENT = "Get {1} if friends join in.\nGet {2} if they invite others!"--成功就送{1}\n好友的好友再送{2}
L.FRIEND.GET_REWARD_TIPS_1 = "Congratulations! You received invitation bonus."--恭喜您获得了邀请奖励!
L.FRIEND.GET_REWARD_TIPS_2 = "Invite {1} more friends to get the bonus.Go invite now！"--您还差{1}人才能领取奖励，点击邀请按钮继续邀请您的好友吧!
L.FRIEND.ROOM_INVITE_TITLE = "Invite"
L.FRIEND.ROOM_INVITE_SUCCTIPS = "Invitation has sent. Please wait a moment."
L.FRIEND.ROOM_INVITE_TAB = {
    "Online",
    "Friends"
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1} is inviting you to play with him/her.{2}{3}"
L.FRIEND.ROOM_INVITE_PLAY_DES = "Don't play alone.Click the buttons to invite friends/groups play together.\n\nAfter installation, click the link or refresh to enter the room directly"

-- RANKING MODULE
L.RANKING.TITLE = "Ranking"--排行榜
L.RANKING.TRACE_PLAYER = "Track "--追踪玩家
L.RANKING.GET_REWARD_BTN = "Receive"--领取
L.RANKING.NOT_DATA_TIPS = "N/A "--暂无数据
L.RANKING.NOT_IN_CHIP_RANKING = "Your ranking :>20. You are not in the rankings for this moment. Continue to strive.. "--您的排名:>20名,您暂时未进入排行榜，请继续加油!
L.RANKING.IN_RANKING = "Your ranking :NO. {1}. Continue to strive. "--您的排名:第{1}名，再接再厉！
L.RANKING.IN_RANKING_NO_1 = " Your ranking : NO.1 "--您的排名：第1名，无敌是多么寂寞！
L.RANKING.MAIN_TAB_TEXT = {
	"Friend ranking",--好友排行
	"World ranking ",--世界排行
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
	"Yesterday profit ranking",--昨日盈利榜
	" Fortune ranking",--财富榜
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
	" Yesterday profit ranking ",--昨日盈利榜
	" Fortune ranking ",--财富榜
}

-- SETTING MODULE
L.SETTING.TITLE = "Setting "--设置
L.SETTING.NICK = "Name"--昵称
L.SETTING.LANGUAGE = "Language "--语言
L.SETTING.EXCHANGE = "Gift code"
L.SETTING.LOGOUT = "Log out "--登出
L.SETTING.FB_LOGIN = "FB Login+19999 "--登录 +19999
L.SETTING.SOUND_VIBRATE = " Sound && vibration "--声音和震动
L.SETTING.SOUND = "Sound "--声音
L.SETTING.BG_SOUND = "Background sound "--背景音效
L.SETTING.CHATVOICE = "Chating sound"--聊天音效
L.SETTING.VIBRATE = "Vibration "--震动
L.SETTING.AUTO_SIT = "Auto sit-down "--进入房间自动坐下
L.SETTING.AUTO_BUYIN = "Auto Buy-in "--自动买入
L.SETTING.CARD_POWER = "Hand strength meter"-- 牌力指示器
L.SETTING.APP_STORE_GRADE = "Give us 5 stars now!"--喜欢我们，打分鼓励
L.SETTING.CHECK_VERSION = "Updates "--检测更新
L.SETTING.CURRENT_VERSION = "Current version: V{1} "--当前版本号：V{1}
L.SETTING.ABOUT = "About"--关于
L.SETTING.PUSH_NOTIFY = "Allow notifications"
L.SETTING.PUSH_TIPS = [[
System will give out lots of free chips every day. First come, first get till all gives out.
Allow notifications then click the push to collect free chips！ 

Cliclk the button –Settings- Allow notifications
]]

--HELP
L.HELP.TITLE = " Help "--帮助中心
L.HELP.FANS = " Fan page "--官方粉丝页
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
	" How to play ",--玩法介绍
	" Herminology ",--名词解释
	" Level guide ",--等级说明
	" FAQ ",--常见问题
	" Contact us",--问题反馈
}

L.HELP.PLAY_SUB_TAB_TEXT = {
	"Rules ",--玩法说明
	"Type of cards ",--比牌规则
	"Introduction ",--操作说明
	"Button",--玩牌按钮说明
}

L.HELP.LEVEL_RULE = "Play game to get EXP, wining EXP+2, lose+1 in ordinary room. No EXP in special room such as competition. "--玩牌即可获得经验,普通场入局一次赢钱 +2, 输钱 +1,特殊场次玩牌不加经验,如比赛场
L.HELP.LEVEL_TITLES = {
	"Lv",--等级
	"Title",--称号
	"EXP",--经验
	"Reward "--奖励
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
	"Payment",--支付问题
	"Account",--账号问题
	"Bugs ",--游戏BUG
	"Suggestions",--游戏建议
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
	"Player data",--玩法数据说明
	"Player type",--玩家类型标注
}

L.HELP.FEED_BACK_SUCCESS = "Feedback sent!"--反馈成功
L.HELP.FEED_BACK_FIAL = "Fail to feedback. Please try again. "--反馈失败!请重试!
L.HELP.UPLOADING_PIC_MSG = "Picture uploading..."--正在上传图片，请稍候..
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "Please input feedback here."--请输入反馈内容
L.HELP.MATCH_QUESTION = "Competition problems"--
L.HELP.FAQ = {
	{
		"I've run out of chips, but I want to play. What should I do? ",--我的筹码用完了，但是还想玩，要怎么办？
		" Click store on the right of profile picture to buy chips. "--点击头像右侧的商城购买筹码即可。
	},
	{
		"Why can’t I send chips？ ",--为什么我赠送不了游戏币？
		"You can send 5K chips to per player in poker table, 500 chips in friendlist. "--在牌桌上每人每天只能赠送五千，在好友列表里每人每天只能赠送五百。
	},
	{
		"Where can I get free chips? ",--在哪里领取免费筹码？
		"We have log in reward, online reward, task reward, fan reward, invitation reward and also lots of activities. "--有登录奖励、在线奖励、任务奖励、粉丝奖励、邀请好友奖励等，还有不同的活动。
	},
	{
		"How to buy chips? ",--怎样购买筹码？
		" Click store then choose the chip you want. "--点击商城按钮，然后选择您需要的筹码。
	},
	{
		"How to be fans? ",--怎样成为粉丝？
		" Click setting button, fan page will appear at the bottom or click link "..appconfig.FANS_URL.."/ \nThere will be lots of fans bonus here. "
	},
	{
		"How to log out? ",--怎样登出？
		" Click setting button then click log out. "--点击设置按钮，再选择登出即可。
	},
	{
		"How to change my name，profile picture and gender? ",--怎样改变名字、头像和性别？
		"Click profile picture then choose different button."--点击自己的头像，点击不同功能按钮即可。
	},
	{
		"What is Line identification? ",-- line认证是什么？
		"Add friend with official Line ID:OpenPoker. Show your correct Line ID in game to get more friends after the identification by staff."--经过认证后，显示您正确的line号，方便交到更多朋友
	}
}

L.HELP.PLAY_DESC = {
	" Hole cards ",--手牌
	" common cards ",--公共牌
	" Board ",--成牌
	" Player A ",--玩家A
	" Player B ",--玩家B
	" Flop ",--翻牌
	" Turn ",--转牌
	" River ",--河牌
	" Full house win ",--葫芦 WIN
	" Two pair lose ",--两对 LOSE
}

L.HELP.PLAY_DESC_2 = "Two cards, known as the hole cards, are dealt face down to each player, and then five common cards are dealt face up in three stages. The stages consist of a series of three cards (the flop), later an additional single card (the turn or fourth street), and a final card (the river ). Each player seeks the best five card poker hand from the combination of the common cards and their own hole cards to win the game. "--在牌局开始的时候，每个玩家分的两张牌作为"底牌”，荷官会分三次连续发出五张公共牌。由每个玩家的底牌和公共牌中选出组合成最大牌型的五张与其他玩家比较，判定胜负。

L.HELP.RULE_DESC = {
	"Royal flush",--皇家同花顺
	"Straight flush",--同花顺
	"4 of a kind",--四条
	"Full house",--葫芦
	"Flush",--同花
	"Straight",--顺子
	"3 of a kind",--三条
	"Two pair",--两对
	"One pair",--一对
	"High card",--高牌
}
L.COMMON.CARD_TIPS = "Card type "--牌型提示
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
	"Straight flush consists of 10-J-Q-K-A",
	"5 numerical order cards in same suit",
	"4 cards of the same rank",  
	"3 cards of the same rank",
	"5 cards of the same suit",
	"5 cards in sequence",
	"3 cards of the same rank",   
	'2 couples of "one pair"',
	"2 cards of a matching rank",
	"Doesn't qualify category listed above"
}
L.HELP.OPERATING_DESC = {
	"Menu ",--主菜单
	"Buy chips",--购买筹码
	"Pot+Side pot ",--池底+边池
	"Dealer",--庄家
	"Common cards",--公共牌
	"Hole cards ",--底牌
	"Card type",--牌型提示
	"Operation",--操作界面
	"Chips",--带入筹码
	"Card type and probability",--牌型大小和成牌概率
	"One pair",--两对
	"Raise ",--加注
	"Call ",--跟注
	"Fold ",--弃牌
}

L.HELP.FEED_BACK_HINT = {
	" Please provide detailed payment information as much as possible to facilitate our customer service staff to solve the problem for you. ",--请尽可能提供详细的支付信息以方便我们的客服人员快速为您解决问题
	" Please provide user ID to let us solve the problem for you. User ID is usually located below the profile picture. ",--请提供您的用户ID以便我们为您解决问题，用户ID一般位于头像下方
	" We are very sorry. We will respond to the problem you pointed at first time ",--非常抱歉，您提出的任何问题我们都会第一时间给出反馈
	" Please feel free to let us know your feedback and suggestions so that we can make great progress.",--非常欢迎您对我们提出的任何建议或者意见，您的反馈是我们持续优化的动力
}

L.HELP.PLAY_BTN_DESC = {
	{
		title="Check ",--看牌
		desc=" To not bet, with the option to call or raise later in the betting round. Equivalent to betting zero dollars. ",--在无人下注的情况下选择把决定“让”给下一位。
		type = 1
	},
	{
		title="Fold",--
		desc=" To forfeit any chance of winning the current pot in poker. ",--放弃继续牌局的机会。
		type = 1
	},
	{
		title="Call ",--跟注
		desc=" To put into the pot an amount of money equal to the most recent bet or raise. ",--跟随众人押上同等的注额
		type = 1
	},
	{
		title="Raise ",--加注
		desc=" To increase the amount of the current bet. ",--把现有的注金抬高
		type = 1
	},
	{
		title="All in",--
		desc=" To run out of chips while betting or calling",--
		type = 1
	},
	{
		title="Check or fold ",--看或弃牌
		desc="Check first. Fold if have to raise. ",--首先看牌，如果需要下注则选择弃牌
		type = 2
	},
	{
		title="Auto Fold ",--弃牌
		desc=" Auto Fold ",--自动弃牌
		type = 2
	},
	{
		title="Call any",--跟任何注
		desc="Call any bet ",--字段选择跟任何注
		type = 2
	},
}

L.HELP.PLAY_DATA_DESC = {
	{
    title=" VPIP ",--入池率/入局率
    desc="VPIP also VP. Voluntarily Put $ In Pot % means the percent (%) of the time that a poker player puts money in preflop."--（通常缩写为VP）是玩家主动向底池中投入筹码的比率。
	},
	{
		title="Pre-Flop Raise ",--翻牌前加注率
		desc="Raise before flop. "-- PFR即翻牌前加注，指的是一个玩家翻牌前加注的比率。
	},
	{
		title="AF ",--激进度
		desc="The AF (Aggression Factor) is a measure of a player's aggression, either in a particular betting round or over all betting rounds.  "-- AF即是用来衡量一个玩家打牌激进程度的数值。
	},
	{
		title="3-bet ",--再次加注率
		desc="A 3-bet is a re-raise following a raise and a bet, making it the third raise in a betting round. "--即在他人下注，有人加注之后的再加注，由于是一轮下注中的第三次加注，故称3bet。
	},
	{
		title=" Stealing Blinds ",--偷盲率
		desc="Stealing Blinds is when a poker player raises pre-flop hoping to win the blinds uncontested.。"-- Stealing Blinds即偷盲,是指一个玩家单纯的为了赢得盲注而加注
	},
	{
		title="C bet",--持续下注率
		desc="A continuation bet is simply a bet that is made on the flop if you were the pre-flop raiser, even if you did not improve your hand on the flop."-- Cbet即持续下注，是指一个玩家在前一轮主动下注或加注后，在当前这一轮再次主动下注。
	},
	{
		title=" WTSD ",--摊牌率
		desc="The WTSD (for Went to Showdown) tells in how many percent of cases where a player saw the second betting round that he also went to the showdown. "--WTSD即摊牌率，是指一个玩家看到翻牌圈并玩到摊牌的百分比。
	},
	{
		title=" BB/100 ",--百手盈利率
		desc=" BB/100 refers to the number of Big Blinds won per 100 hands."-- BB/100（百手盈利率）：BB是Big Blind（大盲注）的简称，BB/100用以衡量玩家每玩100手牌局的盈亏。
	},
}

L.HELP.PLAYER_TYPE_DESC = {
	{
		title="Loose Passive (Calling Stations) ",--跟注站
		desc="A weak-passive player who calls a lot, but doesn't raise or fold much. "--只会被动的跟注
	},
	{
		title="Loose Aggresive (Maniacs)",--疯子
		desc="A player who does a lot of hyper-aggressive raising, betting, and bluffing. "--疯狂的玩家，热衷于诈唬，非常激进
	},
	{
		title="Tight Aggressive (Shark) ",--紧凶型（鲨鱼）
		desc="A style of play where a few carefully selected hands are played aggressively. "--玩的很紧且具有一定的攻击性。
	},
	{
		title="Weak Tight Players (Mice) ",--紧弱型（老鼠）
		desc="Players limp in with a lot of hands and fold a lot on the flop. "--玩的很紧，较胆小，容易被诈唬吓跑的玩家
	},
	{
		title="Tight Passive (Rock) ",--岩石型
		desc="Players play few hands, checks on the flop often and rarely bets or raises. "--非常紧且被动。你不会在这种对手身上得到太多行动
	},
	{
		title="Yellow alert ",--黄色警报
		desc="Players play lots of hands and betting frequently post-flop."--玩太多牌，而且容易高估自己的牌力。
	},
	{
		title="Fish ",--松弱鱼
		desc="Players play lots of hands butseldom raises or bets."--玩太多牌，而翻牌后打法又很被动
	},
}

--UPDATE
L.UPDATE.TITLE = " New version detected "--发现新版本
L.UPDATE.DO_LATER = " Later "--以后再说
L.UPDATE.UPDATE_NOW = " Update now "--立即升级
L.UPDATE.HAD_UPDATED = " You are playing the newest version. "--您已经安装了最新版本

--ABOUT
L.ABOUT.TITLE = " About "--关于
L.ABOUT.UID = "User ID: {1} "--当前玩家ID: {1}
L.ABOUT.VERSION = "Version: V{1} " --版本号：V{1}
L.ABOUT.FANS = "Fan page:\n" .. appconfig.FANS_URL
L.ABOUT.SERVICE = "Terms of Service and Privacy Policy"--服务条款与隐私策略
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "Tasks"--任务
L.DAILY_TASK.SIGN = "Log in"--签到
L.DAILY_TASK.GO_TO = "Do now"--去完成
L.DAILY_TASK.GET_REWARD = "Recieve bonus"--领取奖励
L.DAILY_TASK.HAD_FINISH = "Done "--已完成
L.DAILY_TASK.TAB_TEXT = {
	"Tasks ",--任务
	"Achievements "--成就
}

-- count down box
L.COUNTDOWNBOX.TITLE = "Countdown chest "--倒计时宝箱
L.COUNTDOWNBOX.SITDOWN = "Sit down tocountdown. "--坐下才可以继续计时。
L.COUNTDOWNBOX.FINISHED = "You’ve received all the bonus today. Please try tomorrow. "--您今天的宝箱已经全部领取，明天还有哦。
L.COUNTDOWNBOX.NEEDTIME = "Play {1} {2} more minute. You’ll get {3}."--再玩{1}分{2}秒，您将获得{3}。
L.COUNTDOWNBOX.REWARD = "Congratulations.You get chest bonus {1} "--恭喜您获得宝箱奖励{1}。
L.COUNTDOWNBOX.TIPS = "Invite friend log in game.\n Get double bonus."--成功邀请好友进游戏\n可以得到翻倍奖励

-- act
L.NEWESTACT.NO_ACT = "No activity"--暂无活动
L.NEWESTACT.LOADING = "Loading..."--加载中
L.NEWESTACT.TITLE = "New Activity"--最新活动
L.NEWESTACT.PLAY_CARD_TIME = "Activity time:{1}"
L.NEWESTACT.PLAY_CARD_TITLE = "Play poker to get chips"
L.NEWESTACT.PLAY_CARD_TIPS_1 = "If you play {1} hands more, you can get {2} chips and confirm that you stand up?"
L.NEWESTACT.PLAY_CARD_TIPS_2 = "If you play {1} hands more, you can get {2} chips and confirm that you leave the game?"
L.NEWESTACT.PLAY_CARD_LIST_TITLE = {
    "blind",
    "time",
    "hand",
    "reward"
}
L.NEWESTACT.PAY_TIPS = "The system will send the reward after the activity"
L.NEWESTACT.PAY_COUNT = "Recharged"
L.NEWESTACT.PAY_TIPS_1 = "The total recharge is over"
L.NEWESTACT.PAY_TIPS_2 = "，Get"
L.NEWESTACT.HOLIDAY_TAB_TEXT = {
    "Gift Centre",
    "Gift Exchange"
}
L.NEWESTACT.HOLIDAY_REWARD_LIMIT = "Exchange {1}/{2}"
L.NEWESTACT.HOLIDAY_NO_LIMIT = "Unlimited"
L.NEWESTACT.HOLIDAY_SHAKE_TAB_TEXT = {
    "Give chips",
    "Shake"
}
L.NEWESTACT.HOLIDAY_SHAKE_TIPS = "{1} Heart = {2} Time"
L.NEWESTACT.HOLIDAY_SHAKE_PLAY_TIPS = "Shake it for free once a day"
L.NEWESTACT.HOLIDAY_SHAKE_TIMES = "Shake{1}times"
L.NEWESTACT.HOLIDAY_SHAKE_BTN = "Shake"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_BTN = "Give"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TITLE = {
    "Ranking",
    "Cowherd",
    "Gift chips",
    "Weaver"
}
L.NEWESTACT.HOLIDAY_SHAKE_RANKING = "Ranking"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TIPS = "The Ranking is emptied daily"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_RECORD = "Gift record"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FRIEND = "Friends" 
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_1 = "Weaver ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_2 = "Gift chips"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_1 = "Choose a friend or enter an ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_2 = "give the lowest love chips is{1}"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_3 = "Please enter the player ID you need to give chips."
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_4 = "Please enter chips you need to give "
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_5 = "You can't give yourself chips."
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_6 = "Don’t enter chips you need to give than you own"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_7 = "Your chips is not enough{1}"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_1 = "Gift failed, please try again"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_2 = "Player ID is invalid, please re-gift"

--feed
L.FEED.SHARE_SUCCESS = "shared"--分享成功
L.FEED.SHARE_FAILED = "fail to share"--分享失败
L.FEED.NO_CLIENT_TIPS = "You did not install the {1} app.Please invite by other means."--"您没有安装{1}应用,请使用其他方式邀请"
L.FEED.COPY_TIPS = "Share content has been copied, you can paste to other applications to send to friends."
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
	name = "I won the {1} prize at the Lucky Wheel of Open Texas Poker. Come and play with me ",--我在开源德州扑克的幸运转转转获得了{1}的奖励，快来和我一起玩吧！
	caption = "Happy spin, win prize 100% ",--开心转转转100%中奖
	link = L.FEED.SHARE_LINK .. "&feed=1",
	picture = appconfig.FEED_PIC_URL.."1.jpg",
	message = "",
}
L.FEED.WHEEL_ACT = {
	name = "Come and play with me at Lucky Wheel. Log in to get 3 free chances every day！",--快来和我一起玩开心转转转吧，每天登录就有三次机会
	caption = "Happy spin, win prize 100%", --开心转转转100%中奖
	link = L.FEED.SHARE_LINK .. "&feed=2",
	picture = appconfig.FEED_PIC_URL.."2.jpg",
	message = "",
}
L.FEED.LOGIN_REWARD = {
	name = "Great！I won the {1} prize at Open Texas Poker. Come and play with me" ,--太棒了!我在开源德州扑克领取了{1}筹码的奖励，快来和我一起玩吧
	caption = "Receive login bonus every day ",--登录奖励天天送不停
	link = L.FEED.SHARE_LINK .. "&feed=3",
	picture = appconfig.FEED_PIC_URL.."3.jpg",
	message = "",
}
L.FEED.INVITE_FRIEND = {
	name = "OpenPoker ,the hotest Texas Poker game！We all like it！Come and play with us！",--开源德州扑克，最新最火爆的德扑游戏，小伙伴们都在玩，快来加入我们一起玩吧！
	caption = "OpenPoker, game of the wise ",--聪明人的游戏-开源德州扑克
	link = L.FEED.SHARE_LINK .. "&feed=4",
	picture = appconfig.FEED_PIC_URL.."4.jpg",
	message = "",
}
L.FEED.EXCHANGE_CODE = {
	name = "I got the the {1} reward with redeem code from OpenPoker ‘s fan page. Come and play with me ",--我用开源德州扑克粉丝页的兑换码换到了{1}的奖励，快来和我一起玩吧！
	caption = "Get a redeem code to exchange reward ",--粉丝奖励兑换有礼
	link = L.FEED.SHARE_LINK .. "&feed=5",
	picture = appconfig.FEED_PIC_URL.."5.jpg",
	message = "",
}
L.FEED.COUNT = {
	name = "Good！I can't help showing off the {1} chips i won in OpenPoker ",--我在开源德州扑克赢得了{1}的筹码，忍不住炫耀一下！
	caption = "Win a lot",--赢了好多啊
	link = L.FEED.SHARE_LINK .. "&feed=6",
	picture = appconfig.FEED_PIC_URL.."6.jpg",
	message = "",
}
L.FEED.ACTIVE = {
	name = "Great!Come and play with me in OpenPoker. There are various wonderful activities every day.",--太棒了，赶紧和我一起加入开源德州扑克吧，精彩活动天天有！
	caption = "{1} activity ",--{1}活动
	link = L.FEED.SHARE_LINK .. "&feed=7",
	picture = appconfig.FEED_PIC_URL.."7.jpg",
	message = "",
}
L.FEED.ACTIVE_DONE = {
	name = "Great！I won the {1} prize in OpenPoker. Come and play with me ",--我在开源德州扑克中获得了{1}的奖励，赶快来加入一起玩吧！
	caption = "{1} activity ",--{1}活动
	link = L.FEED.SHARE_LINK .. "&feed=8",
	picture = appconfig.FEED_PIC_URL.."8.jpg",
	message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
	name = "I completed the {1} achievement, won the {2} Award in OpenPoker. Come and play with me. ",--我在开源德州扑克完成了{1}的成就，获得了{2}的奖励，快来和我一起玩吧！
	caption = "{1}",
	link = L.FEED.SHARE_LINK .. "&feed=9",
	picture = appconfig.FEED_PIC_URL.."9.jpg",
	message = "",
}
L.FEED.UPGRADE_REWARD = {
	name = "Great！I went up to the {1} level, received a {2} reward in OpenPoker. Come to worship it!",--太棒了，我刚刚在开源德州扑克成功升到了{1}级，领取了{2}的奖励，快来膜拜吧！
	caption = "Level up gifts",--升级领取大礼
	link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
	picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
	message = "",
}
L.FEED.MATCH_COMPLETE = {
	name = "I got the {2} place in {1} of OpenPoker！Come and play with me.",--我在开源德州扑克中获得第{2}名，赶快来一起玩吧
	caption = "Come and play with me！",--一起来比赛
	link = L.FEED.SHARE_LINK .. "&feed=11",
	picture = appconfig.FEED_PIC_URL.."11.jpg",
	message = "",
}
L.FEED.RANK_REWARD = {
	name = "Awesome！I i won{ 1} chips in OpenPoker. Come and play with me. ",--太棒了!我昨天在开源德州扑克里赢得了{1}筹码，快来和我一起玩吧!
	caption = "Win chips again！",--又赢钱了
	link = L.FEED.SHARE_LINK .. "&feed=12",
	picture = appconfig.FEED_PIC_URL.."12.jpg",
	message = "",
}
L.FEED.BIG_POKER = {
	name = "Good hand! I got {1} in OpenPoker. Come and play with me.",--手气真好!我在开源德州扑克拿到{1}，聪明人的游戏，快来加入一起玩吧！
	caption = "{1}card type",--{1}牌型
	link = L.FEED.SHARE_LINK .. "&feed=13",
	picture = appconfig.FEED_PIC_URL.."13.jpg",
	message = "",
}
L.FEED.PRIVATE_ROOM = {
  name = "I’m waiting for you in private room of OpenPoker. Room NO. {1} Password {2} . Click to start",--我在开源德州扑克开好私人房等你来战，房间号{1}，密码{2}，点击立即加入！
  caption = "Play in private room",--开房打牌了
  link = L.FEED.SHARE_LINK,
  picture = appconfig.FEED_PIC_URL.."7.jpg",
  message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
  name = "I’m waiting for you in private room of OpenPoker. Room NO. {1} Password {2} . Click to start ",--我在开源德州扑克开好私人房等你来战，房间号:{1}，点击立即加入！
  caption = "Play in private room",--开房打牌了
  link = L.FEED.SHARE_LINK,
  picture = appconfig.FEED_PIC_URL.."7.jpg",
  message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name = "{1}room {2}.Come to play with me!",
    caption = "Start to play.",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.INVITE_CODE = {
    name = "The hottest Texas hold’em game. Come to play with me.Download and input my invitation code{1} to get big special bonus immediately!",--"发现一个目前最好玩的德州扑克游戏，推荐你和我一起玩，下载游戏输入我的邀请码{1}就有特别大奖领取.",
    caption = "",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE_REWARD = {
    name = "Thank you so much {1}. I get invitation bonus {2}! Come and join us!",--"太感谢好友XXX！我在开源德州获得了xx筹码的邀请礼包，快来加入我们一起玩吧",
    caption = "Free big invitation bonus  from open poker.",--"开源德州扑克-免费的邀请大礼包",
    link = L.FEED.SHARE_LINK .. "&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}

-- message
L.MESSAGE.TITLE = "Message "--消息
L.MESSAGE.TAB_TEXT = {
  " Friend message ", --邮    件
  " System message "--系统消息
}
L.MESSAGE.EMPTY_PROMPT = "No message now. "--您现在没有消息记录
L.MESSAGE.SEND_CHIP = "Send back"--回赠
L.MESSAGE.ONE_KEY_GET = "Collect All"--一键领取
L.MESSAGE.ONE_KEY_GET_AND_SEND = "Send back&&Collect All"--一键领取并回赠
L.MESSAGE.GET_REWARD_TIPS = "Wow!You got {1} chips and send {2} to friends."--"恭喜您获得了{1},成功给好友赠送了{2}"

--奖励兑换码
L.ECODE.TITLE = {
    "My Invite Code",
    "Redeem bonus"
}
L.ECODE.EDITDEFAULT = "Input 6-digit bonus code/8-digit invite code"--"Please enter 6-8 digit bonus code"--请输入6位数字奖励兑换码
L.ECODE.FANS_DESC = "Follow our fan page to get free chips every day!"--关注粉丝页可免费领取奖励兑换码,我们还会不定期在官方粉丝页推出各种精彩活动,谢谢关注
L.ECODE.FANS = "Fan page"
L.ECODE.EXCHANGE = "Redeem"
L.ECODE.ERROR_FAILED = "Gift code input error, please input again."--兑换码输入错误，请重新输入！
L.ECODE.ERROR_INVALID="Fail to redeem.Your code has expired."--兑奖失败，您的兑换码已经失效。
L.ECODE.ERROR_USED = "Fail to redeem. Each gift code can only be redeemed once "--兑奖失败，每个兑换码只能兑换一次。
L.ECODE.ERROR_END= "Fail to eeceive.This reward has all been led out, follow us and come earlier next time ."--领取失败，本次奖励已经全部领光了，关注我们下次早点来哦
L.ECODE.FAILED_TIPS = "Redeem failed. Please try again!"--"兑奖失败，请重试！"
L.ECODE.NO_INPUT_SELF_CODE = "You can’t use invitation code yourself. Please inter again."--"不能输入自己的邀请码,请重新输入"
L.ECODE.MAX_REWARD_TIPS = "Get highest"--最大获取
L.ECODE.INVITE_REWARD_TIPS = [[
1.Send invitation code to your friend.
2.Ask friend to redeem your code in 3 days after regist.It will be invalid if expired.
After redeem，your friend will get {2} chips.You will get {1} chips.You’ll also get {3} chips per person when your friends use their code to invite others successfully.
]]
L.ECODE.INVITE_REWARD_RECORD = "You've invited {1} friends and received {2} chips for invitation bonus."--"你已邀请了{1}位好友,获得了{2}筹码的邀请奖励"
L.ECODE.MY_CODE = "My Code"--"我的邀请码"
L.ECODE.COPY_CODE = "Copy"--"复制"
L.ECODE.INVITE_REWARD_TIPS_1 = "Great!Collect bonus"--"太棒了,领取成功"
L.ECODE.INVITE_REWARD_TIPS_2 = "You got {1} chips for inviting friend.\nYour friend {2} also get {3} chips."--"您获得了{1}筹码的好友邀请奖励,您的好友{2}也获得了{3}的邀请奖励"
L.ECODE.INVITE_BTN_NAME = "Go && Invite"--"我也要去邀请"
L.ECODE.INVITE_TIPS = "Click button to send your code."--"您可以点击按钮通过以下方式发送邀请码"
L.ECODE.INVITE_TITLES = {
    "Follow us for free chips",--"关注粉丝页获取兑换码"
	"Send my code to get bonus"--"发送我的邀请码获取邀请奖励"
}

--大转盘
L.LUCKTURN.RULE_TEXT = [[
1.You can also play once free every {1} hours
2.Spend 1 diamonds to play once
3.100% win, a lot of free chips waiting for you every day.
]]
L.LUCKTURN.COST_DIAMOND = "Use 1 diamond. "--花费1个颗钻石
L.LUCKTURN.BUY_DIAMOND = "Buy diamond. "--购买钻石
L.LUCKTURN.COUNTDOWN_TIPS = "You’ run out of three free opportunities today,\nYou can also play once free after {1} hours,\nUse 1 diamonds to play once. "--您今天的免费次数已用完\n您可以等待{1}再来\n您也可以花费一颗钻石转一次
L.LUCKTURN.LOTTERY_FAILED = "Fail to raffle. Please try again later. "--抽奖失败，请重试
L.LUCKTURN.CHIP_REWARD_TIPS = " {1} get {2} chips"--{1}中了:筹码{2}
L.LUCKTURN.PROPS_REWARD_TIPS = "{1} get {2} items "--{1}中了:道具{2}
L.LUCKTURN.VIP_REWARD = "{1} day {2} VIP"--"{1}天{2}VIP特权"

--老虎机
L.SLOT.NOT_ENOUGH_MONEY = "Fail to buy in.You don’t have enough chips."--老虎机购买失败,你的筹码不足
L.SLOT.NOT_ENOUGH_MIN_MONEY ="Chip less than 5K.Fail to bet slots. Please try again after top up. "--您的总筹码数不足5000，暂时无法下注老虎机，请充值后重试。
L.SLOT.BUY_FAILED = "Fail to buy in. Please try again latter."--"老虎机购买失败，请重试"  
L.SLOT.PLAY_WIN = "You won {1}chips."--你赢得了{1}筹码
L.SLOT.TOP_PRIZE = "Player {1} win {2} chips in Lucky Slots."--玩家 {1} 玩老虎机抽中大奖，获得筹码{2}
L.SLOT.FLASH_TIP = "First prize: {1}"--头奖：{1}
L.SLOT.FLASH_WIN = "You win {1} "--你赢了：{1}
L.SLOT.AUTO = "Auto"--自动
L.SLOT.HELP_TIPS = "Reward=Bet chips*Reward rate\nThe more bets the more gets.Up to {1}"--"奖励-下注筹码*回报率\n下注越多,奖励越高.最高{1}"

--GIFT
L.GIFT.TITLE = "Gifts"
L.GIFT.SET_SELF_BUTTON_LABEL = "Set as my gift"---设为我的礼物
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "Buy for everyone {1}"---买给牌桌x{1}
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "Gift now "---你当前选择的礼物
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "Send a gift"--赠送
L.GIFT.DATA_LABEL = "Day"--天
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "Please choose a gift."--请选择礼物
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "Gift purchase success"--购买礼物成功
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "Fail to purchase "--购买礼物失败
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "Success to set gift "--设置礼物成功
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "Fail to set gift "--设置礼物失败
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "Success to send"---赠送礼物成功
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "Fail to send "--赠送礼物失败
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "Success to send gift to all players at the table."--赠送牌桌礼物成功
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "Fail to send gift to all players at the table."--赠送牌桌礼物失败
L.GIFT.NO_GIFT_TIP = "No gift"--暂时没有礼物
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "Click on the selected to display gift. "--点击选中即可在牌桌上展示礼物
L.GIFT.BUY_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to buy gift."
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift."
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift to all players at the table."
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
	"Boutique ",--精品 
	"Food ",--食物
	"Roadster ",--跑车
	"Flower "--鲜花
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
	"Gift my own", --自己购买
	"Gift from friends",--牌友赠送
	"Special gift"--特别赠送
}

L.GIFT.MAIN_TAB_TEXT = {
	"Gift in store", --商城礼物
	"VIP gift",
	"My gift"--我的礼物
}

-- 破产
L.CRASH.PROMPT_LABEL = " You get {1} chips bankruptcy relief and a big time limited recharge discount today. You can also invite friends to get free chips."--您获得了{1}筹码的破产救济金，同时获得限时破产优惠充值一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.THIRD_TIME_LABEL = " You get the last {1} chips bankruptcy relief today and a big time limited  recharge discount.You can also invite friends to get free chips."-- 您获得最后一次{1}筹码的破产救济金，同时获得当日限时充值优惠一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.OTHER_TIME_LABEL = " No more bankrupt aid funds. Winning or losing is just a matter of the moment.Winning will come in an instant. Go recharge immediately to play at once."-- 您已经领完所有破产救济金了，输赢只是转瞬的事，限时特惠机会难得，立即充值重振雄风！
L.CRASH.TITLE = "You bankrupted"--你破产了！
L.CRASH.REWARD_TIPS = "Take it easy! We prepared bankruptcy relief for you."---破产没有关系，还有救济金可以领取
L.CRASH.CHIPS = "{1} chips"--{1}筹码
L.CRASH.GET = "Get bonus."--领取
L.CRASH.GET_REWARD = "Received {1} chips"--获得{1}筹码
L.CRASH.GET_REWARD_FAIL = " Fail to received chips "--领取筹码失败
L.CRASH.RE_SIT_DOWN = "Sit again"
L.CRASH.PROMPT_LABEL_1 = "Hold on! We prepared {1} chips bankruptcy relief for you"
L.CRASH.PROMPT_LABEL_2 = "There is a big time limited bankruptcy sale！Go top up now"
L.CRASH.PROMPT_LABEL_3 = "You can also invite friends to get free chips"
L.CRASH.PROMPT_LABEL_4 = "Don’t miss the big sale！Top up immediately to win back at once"
L.CRASH.PROMPT_LABEL_5 = "No more bankrupt aid funds. Winning or losing is just a matter of the moment. Do not be discouraged"

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "Already sent message. Topping up... Please be patient. "--短信已发送成功,正在充值 请稍等.
L.E2P_TIPS.NOT_SUPPORT = "Your phone does not support easy2pay. Please choose other top up methods. "--你的手机暂时无法完成easy2pay充值,请选择其他渠道充值
L.E2P_TIPS.NOT_OPERATORCODE = "Easy2pay does not support your mobile carrie. Please choose other top up methods. "-- easy2pay暂时不支持你的手机运营商,请选择其他渠道充值
L.E2P_TIPS.SMS_SENT_FAIL = "Fail to send SMS.Please check if your balance is enough. "--短信发送失败,请检查你的手机余额是否足额扣取
L.E2P_TIPS.SMS_TEXT_EMPTY = " SMS content empty, please select other channels to recharge and contact the official "--短信内容为空,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "SMS address empty. Please select other channels to recharge and contact the official. "--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_NOSIM = "No SIM card. The easy2pay channel is not available. Please select other channels to recharge and contact the official "--没有SIM卡,无法使用easy2pay渠道充值,请选择其他渠道充值
L.E2P_TIPS.SMS_NO_PRICEPOINT = "No pricepoint. Please select other channels to recharge and contact the official. "--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.PURCHASE_TIPS = "You are going to buy {1}. Cost {2} THB（not include 7%VAT）in your cell phone balance. "--您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的话费里扣除
L.E2P_TIPS.BANK_PURCHASE_TIPS = " You are going to buy {1}. Cost {2} THB（not include 7%VAT）in your bank card balance."--您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的银行卡里扣除

-- 比赛场
L.MATCH.MONEY = "Chips "--筹码
L.MATCH.JOINMATCHTIPS = " You have enlisted in the competition. Will you enter the room for the match now? "--您报名参赛的比赛已经开始准备，是否现在进入房间进行比赛
L.MATCH.JOIN_MATCH_FAIL = "Fail to join the match, please take part in other match!"--加入比赛失败，请参加其他比赛吧！
L.MATCH.MATCH_END_TIPS = "This match has already ended，please take part in other match!"--当前比赛已经结束，请参加其他比赛吧！
L.MATCH.MATCHTIPSCANCEL = "Don't show again"--不再提示
L.MATCH.CHANGING_ROOM_MSG = "Waiting for other games to end"--正在等待其他桌子结束
L.MATCH.MATCH_NAME = "Match name "--比赛名称
L.MATCH.MATCH_REWARD = "Bonus "--奖励内容
L.MATCH.MATCH_PLAYER = "Register player "--参赛人数
L.MATCH.MATCH_COST = "Fees"--报名费+服务费
L.MATCH.REGISTER = "Register"--报名
L.MATCH.REGISTERING = "Registering"--"正在报名"
L.MATCH.REGISTERING_2 = "Registering"--"正在报名"
L.MATCH.UNREGISTER = "Cancel"--取消\n报名
L.MATCH.UNREGISTER_2 = "Cancel"--取消报名
L.MATCH.RANKING = "Your ranking"--"您的排名"
L.MATCH.REGISTER_COST = " Register cost: "--参数费:
L.MATCH.SERVER_COST = "Service cost:" --服务费
L.MATCH.TOTAL_MONEY = "Total chip:" --您的总资产
L.MATCH.MATCH_INFO = "Match information "--本场赛况
L.MATCH.START_CHIPS = "Initial chips:" --初始筹码
L.MATCH.START_BLIND = "Initial blind:{1}/{2}"--初始盲注{1}/{2}
L.MATCH.MATCH_TIME = "Match time :{1}"--参赛时间
L.MATCH.RANKING_TITLE = "Ranking "--名次
L.MATCH.REWARD_TITLE = "Bonus "--奖励
L.MATCH.LEVEL_TITLE = "Level "--级别
L.MATCH.BLIND_TITLE = "Blind "--盲注
L.MATCH.PRE_BLIND_TITLE = "Pre blind "--前注
L.MATCH.ADD_BLIND_TITLE = "Time raise blind "--涨注时间
L.MATCH.RANKING_INFO = "Ranking now {1} "--当前排名第{1}名
L.MATCH.SNG_HELP_TITLE = "SNG Rules" --SNG比赛规则
L.MATCH.MTT_HELP_TITLE = "MTT Rules" --MTT比赛规则
L.MATCH.SNG_RANKING_INFO = "Average chip: {1}"--均筹: {1}
L.MATCH.MTT_RANKING_INFO = "{1}/{2} Average chip: {3}"--{1}/{2} 均筹: {3}
L.MATCH.ADD_BLIND_TIME = "Time raise blind: {1}"--涨盲时间: {1}
L.MATCH.WAIT_MATCH = "Waiting for match"--等待开赛
L.MATCH.ADD_BLIND_TIPS_1 = "Raise blind in next hand"--将在下一局涨盲
L.MATCH.ADD_BLIND_TIPS_2 = "Blind will raise to {1}/{2} "--下一局将升盲至{1}/{2}
L.MATCH.BACK_HALL = "Lobby "--返回大厅
L.MATCH.PLAY_AGAIN = "One more hand "--再来一局
L.MATCH.LEFT_LOOK = "Watch Game"--留下旁观
L.MATCH.CLOSE = "Close "--关闭
L.MATCH.REWARD_TIPS = "Well done！You got {1} bonus.\n{2}"--您获得了{1}的奖励
L.MATCH.REWARD_PLAYER = "Reward Players"--奖励人数
L.MATCH.MATCH_CUR_TIME = "Match Time"--比赛用时
L.MATCH.CUR_LEVEL_TITLE = "Blind Now:{1}/{2}"--当前级别:{1}/{2}
L.MATCH.NEXT_LEVEL_TITLE = "Blind Next"--下一级别
L.MATCH.AVERAGE_CHIPS_TITLE = "Average chip"--平均筹码
L.MATCH.FORMAT_BLIND = "{1}/{2}"
L.MATCH.EXPECT_TIPS = "Coming Soon..."--敬请期待
L.MATCH.NOT_ENOUGH_MONEY = "You don’t have enough chips. Please buy chip in store and retry."--您的筹码不足报名，请去商城补充筹码后重试
L.MATCH.PLAYER_NUM_TIPS = "Wait {1} more players to start."--"等待开赛中，还差{1}人"
L.MATCH.PLAYER_NUM_TIPS_1 = "Wait "
L.MATCH.PLAYER_NUM_TIPS_2 = " more players to start."
L.MATCH.MAINTAIN = "The match is under maintenance"--"当前比赛正在维护"
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
    "Adorable! Share the record with friends.",--你太棒了！立即分享炫耀下吧！
    "Good job! Share it to let your friends now.",--没想到你这么强！呼朋唤友告诉小伙伴们吧！,
    "Nice hand! Play one more hand.",--太牛了，再来一局吧！
}
L.MATCH.NO_REWARD_TEXT = {
    "Don' t lose heart at any failure, but try again.",--再接再厉，继续加油！
    "Failure is the mother of success. Please keep trying.",--失败是成功之母，继续努力！
    "Cheer up! You just need more patience next time.",--就差一点点，下次多点耐心！
}
L.MATCH.SNG_RULE = {
    {
        title = " What is SNG? ",--什么是SNG-坐满即玩?
        content = " The opposite of a multi-table tournament is a single-table tournament, often abbreviated as STT. This method of starting single-table tournaments is also called sit-and-go (SNG) because when the required number of players \"Sit\", the tournament \"Goes\". " --SNG全称Sit and Go，中文指坐满即玩，坐满即玩是德州扑克的一种单桌比赛玩法。在SNG中，每场玩家会获得用来计数的筹码，这个筹码与金币无关，只用于本场计数。
    },
    {
        title = " SNG Rules:", --SNG比赛规则
        content = [[
1. A number of places (typically, six or nine) are allocated at a single table. As soon as the required number of players appears, chips are distributed and the game starts.
2. A player pays a fixed buy-in, and receives a certain quantity of tournament chips at the start of play (not equal to coins, and represents a player's stake in the tournament.)
3. In SNG, blinds do not rise over the duration of the tournament.
4. The winner of the tournament is usually the person who wins all the chips in the game. Other players are awarded places based on their time of elimination.
5. Play continues until one player wins all the chips in play or a deal is made among the remaining players to "chop" the remaining prize pool.
6. To enable this in SNG, blinds rise over the duration of the tournament.
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title = " What is MTT? ",--什么是MTT-多桌锦标赛?
        content = " Multi-table tournaments (MTT) involve many players playing simultaneously at dozens or even hundreds of tables. All MTT players put an equal amount of chips into the pot before the deal begins. Blinds rise over the duration of the tournament. The winner of the tournament is usually the person who wins all the chips in the game. " --MTT是Multi-Table Tournament的缩写，中文全称为多桌锦标赛，指的是在多张桌上参赛玩家以同样的筹码量开始比赛。在多桌锦标赛中，桌子会随着选手的不断淘汰进行合并。最终，锦标赛会减少到一张桌子而进行决赛。
    },
    {
        title = " MTT Rules:",-- MTT比赛规则:
        content = [[
1. The game begins at a fixed time and will be cancelled if the required number of players is not reached.
2. A player pays a fixed buy-in and receives a certain quantity of tournament chips (not equal to coins, and represents a player's stake in the tournament.)
3. Ante: an ante is a forced bet in which all players put an equal amount of chips into the pot before the deal begins.
4. Rebuy: the amount of chips purchased after buy-in. Players can rebuy chips one or multiple times for a limited period after the start of the game, providing that their stack is at or under its initial level. Players are eliminated when they have no chips, or can continue to play by rebuying chips.
5. Add-on: an option to buy more chips than you received at the original buy-in. There is one or more options to 'add-on' during a tournament. Players are eliminated when they have no chips, or can continue playing via add-on.
6. The winner of the tournament is usually the person who wins all the chips in the game. Other players are placed based on the time of their elimination. If two players are eliminated in the same round, they are placed according to their hands.
7. Play proceeds until one player wins all the chips in play or a deal is made among the remaining players to "chop" the remaining prize pool.
8. To facilitate this in MTT, blinds rise over the duration of the tournament.
]]
    }
}
L.MATCH.TAB_TEXT= {
    "Macth Information",--比赛信息
    "Ranking",--排名
    "Blind",--盲注
    "Bonus",--奖励
}
L.MATCH.ROOM_TAB_TEXT= {
    "Overview ",--概述
    "Macth Information",--赛况
    "Ranking",--排名
    "Blind",--盲注
    "Bonus",--奖励
}
L.MATCH.ROOM_TAB_TEXT_2= {
    "Macth Information",--赛况
    "Ranking",--排名
    "Blind",--盲注
    "Bonus",--奖励
}

-- 输赢统计
L.WINORLOSE.TITLE = "So great!"--太棒了
L.WINORLOSE.YING = "You win"--你赢了
L.WINORLOSE.CHOUMA = "{1} chips"--{1}筹码
L.WINORLOSE.INFO_1 = "Hands played:{1}"--局数:{1}
L.WINORLOSE.INFO_2 = "Biggest pot won in a single hand:{1}"--单局最大赢得:
L.WINORLOSE.RATE5 = "Like this game? Please give 5 star high praise to encourage us."--喜欢我们的游戏给5星好评，您的鼓励是我们持续优化的最大动力
L.WINORLOSE.NOW = "Support immediately "--立即支持
L.WINORLOSE.LATER = "Next time"--以后再说
L.WINORLOSE.SHARE = "Share"--分享
L.WINORLOSE.CONTINUE = "Continue"--继续游戏

-- 私人房
L.PRIVTE.ROOM_NAME = "Private room"
L.PRIVTE.FINDTITLE = "Rearch room"--查找房间
L.PRIVTE.CREATTITLE = "Create a room"--创建房间
L.PRIVTE.INPUTROOMIDTIPS = "Please enter room number"--请输入房间号
L.PRIVTE.ENTERROOM = "Enter immediately"--立即进入
L.PRIVTE.TYPETIPS = "Betting Time:\nOrdinary room {1} seconds\nFast room {2} seconds"--普通场{1}秒快速场{2}秒
L.PRIVTE.CREATEROOM = "Start immediately"--立即开始
L.PRIVTE.CREATFREE = "Limited Free"
L.PRIVTE.INPUTPWDTIPS = "Please enter a password, blank means no password "--请输入6位房间密码，留空即无密码
L.PRIVTE.TIMEHOUR = "{1} hours"--{1}小时
L.PRIVTE.PWDPOPTIPS = "Please enter a valid password"--请输入有效密码
L.PRIVTE.PWDPOPTITLE = " Please input a password "--**请输入密码**
L.PRIVTE.PWDPOPINPUT = " Please input a password "--请输入密码
L.PRIVTE.NOTIMETIPS = "The remaining time of the current room is {1} seconds. Please open a new one."--当前房间所剩时间{1}秒，即将解散，请重新创建！
L.PRIVTE.TIMEEND = "Time of this room is running out now. Please go back to the lobby and open a new one.!"--当前房间时间已用完解散，请返回大厅重新创建！
L.PRIVTE.ENTERBYID = "Input room ID && Go"
L.PRIVTE.OWNER = "Room owner"
L.PRIVTE.ROOMID = "Room ID:{1}"
L.PRIVTE.LEFTDAY = "{1}day"
L.PRIVTE.LEFTHOUR = "{1}hour"
L.PRIVTE.LEFTMIN = "{1}minute"
L.PRIVTE.ENTERLOOK = "Look on"
L.PRIVTE.ENTERPLAY = "Sit"
L.PRIVTE.ENTEREND = "End"
L.PRIVTE.ENTERENDTIPS = "This room is time out. Plese go other rooms."
L.PRIVTE.ENTERCHECK = "Enter this room?"
L.PRIVTE.CHECKCREATE = "No room now. Create a room."
L.PRIVTE.ROOMMAXTIPS =" The private rooms you created has reached the maximum limit."--您创建的私人房已经达到上限！

--活动
L.ACT.CHRISTMAS_HITRATE = "Success rate{1} Combo max{2}"
L.ACT.CHRISTMAS_HITWIN = "Great speed.You beat {1} player in the game!"
L.ACT.CHRISTMAS_FEED = {
    name = "I got {1} chips and beat {2} players with my fast hand speed.How is your speed?Come and show it.",
    caption = "Click gifts.100% winning prize",
    link = L.FEED.SHARE_LINK .. "&feed=14",
    picture = appconfig.FEED_PIC_URL.."14.jpg",
    message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "Merry Christmas.Shake your phone and click gifts."
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "Happy new year!Shake your phone and click gifts."
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "Gifts are coming.Ready to click?"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "Times out today.Come back tomorrow."
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 = "Happy Spring Festival.Shake your phone to click gifts"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_6 = "Happy Chinese Valentine's day, pick up your  phone and shake it. Click on the gift to surprise you."

--红黑大战
L.REDBLACK.BET_DOUBLE = "Double"--"加倍"
L.REDBLACK.BET_LAST = "Re-bet"--"重复上局"
L.REDBLACK.SELECTED_BET_TIPS = "Please choose lucky places"--"请选择幸运区域"
L.REDBLACK.SELECTED_BET_END_TIPS = "Choosed"--"选择完毕"
L.REDBLACK.START_GAME_TIPS = "Starting({1})"--"游戏即将开始({1})"
L.REDBLACK.BET_FAILD = "Not enough chips.Betting failed."--"您的游戏币不足,下注失败"
L.REDBLACK.BET_FAILD_2 = "Your chip less than {1}.Auto switch to {2}."--"您的游戏币不足当前所选的下注额度{1}，已经自动切换到{2}"
L.REDBLACK.BET_FAILD_TIMES_OUT = "Out of betting time,betting failed."--"下注时间已到,下注失败"
L.REDBLACK.BET_LIMIT_TIPS = "Bet failed.The upper bet limit is {1}"--"下注失败，当局下注不能超过{1}"
L.REDBLACK.ALL_PLAYER = "{1} people in this room"--"当前房间共有{1}人"
L.REDBLACK.RECENT_TREND = "Trend"--"近期走势"
L.REDBLACK.TODAY_COUNT = "Data Today"--"今日统计"
L.REDBLACK.WIN_LOSE = "Win&&Lose"--"胜负"
L.REDBLACK.HAND_CARD = "Hole Cards"--"手牌"
L.REDBLACK.WIN_CARD_TYPE = "Winner Hand"--"获胜牌型"
L.REDBLACK.COUNT_TIPS_1 = "Gold Win:{1}"--"金象胜利:{1}"
L.REDBLACK.COUNT_TIPS_2 = "Silver Win:{1}"--"银象胜利:{1}"
L.REDBLACK.COUNT_TIPS_3 = "Draw:{1}"--"平局:{1}"
L.REDBLACK.COUNT_TIPS_4 = "Suited Connectors:{1}"--"同花连牌:{1}"
L.REDBLACK.COUNT_TIPS_5 = "AA:{1}"--"对A:{1}"
L.REDBLACK.COUNT_TIPS_6 = "Full House:{1}"--"葫芦:{1}"
L.REDBLACK.COUNT_TIPS_7 = "4 of a Kind/Straight Flush/Royal Flush:{1}"--"金刚/皇家/同花顺:{1}"
L.REDBLACK.SUB_TAB_TEXT = {
    "Win-lose Trend",--"胜负走势",
    "Rules"--"游戏规则"
}
L.REDBLACK.RULE = [[
Pick a player to support and get rewards!


Basic rules:

1. Every match, Golden Elephant and Silver Elephant will each get one hand of cards, and five common cards.

2. You can bet on who will win and on their hands.

3. When the common cards are turned you will be awarded according to the value of your bets.


There is a cap for the daily bet. Work on your strategy and support your favourite player!
]]

--新手引导
L.TUTORIAL.SETTING_TITLE = "Novice tutorial"
L.TUTORIAL.FIRST_IN_TIPS = [[
Welcome to Open poker.
Now Alicia will teach you how to play this game.You can choose to skip the guide if you have already known the basic gameplay or you can start teaching.
Get 8000 bonus when finish your first tutorial.
]]
L.TUTORIAL.FIRST_IN_BTN1 = "Skip"
L.TUTORIAL.FIRST_IN_BTN2 = "Start"
L.TUTORIAL.END_AWARD_TIPS = "Finish tutorial && Get chips"
L.TUTORIAL.FINISH_AWARD_TIPS = "Great! You get {1} chips for completing novice guide.Make a decision to learn again or play game now."
L.TUTORIAL.FINISH_NOAWARD_TIPS = "You’ve already a good hand in Texas hold’em. Make a decision to learn again or play game now."
L.TUTORIAL.FINISH_FIRST_BTN = "Learn again"
L.TUTORIAL.FINISH_SECOND_BTN = "Start now"
L.TUTORIAL.SKIP = "Skip"
L.TUTORIAL.NEXT_STEP = "Next step"
L.TUTORIAL.GUESS_TRUE_13 = "Right answer! You have 1 pair of A. Good hand! \n\nClick on anywhere to next step."
L.TUTORIAL.GUESS_TRUE_22 = "You’re right.Now you have 2 pair.\n\nClick on anywhere to next step."
L.TUTORIAL.GUESS_TRUE_27 = "Yes. You have full house now.Good hand.\n\nClick on anywhere to next step."
L.TUTORIAL.GUESS_FLASE = "Wrong. Think carefully."
L.TUTORIAL.RE_SELECT = "Choose again"
L.TUTORIAL.TIPS = {
    "Exit the menu",
    "Buy chips",
    "Click to see information, send chips && use items.",
    "Common cards",
    "Slide out or Play slots",
    "My profile",
    "Hole cards",
    "Action button",
    "click to chat && send emoji"
}
L.TUTORIAL.ROOM_STEP_1 = "Welcome to Open poker.Finish this novice tutorial to get {1} chips.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_2 = "At the beginning, the dealer will give each player two hole cards, which only can be seen yourself.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_3 = "Then 5 common cards will be given out gradually. All players can see the common cards.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_4 = "Your final largest hand is made from the common cards and hole cards.The card type as shown (Royal flush ->High card)"
L.TUTORIAL.ROOM_STEP_5 = "Now your final largest hand is Royal flush.The combination of largest hand is where the cursor blinks.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_6 = "Now, let’s start the game.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_7 = "Here is action area.You can choose what to do according to your cards.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_8 = "Now it’s your turn. Not bad cards. \n\nLet’s call first."
L.TUTORIAL.ROOM_STEP_11= "Other players also called.It seems that their cards are not that good. Now we deal the flop.\n\nClick on anywhere to next step."
L.TUTORIAL.ROOM_STEP_13= "What is your current card type after dealing the flop?"
L.TUTORIAL.ROOM_STEP_14= "Your turn again. Think about what to do next. Other players might have flush. You’d better check first."
L.TUTORIAL.ROOM_STEP_16= "Player {1} chooses to raise. Be careful because people will raise when they have a strong hand."
L.TUTORIAL.ROOM_STEP_18= "Player {1} chooses to fold, and the fold means that you’ll lose all chips that have been placed on the pot.It’s better to fold when your hand is not strong enough."
L.TUTORIAL.ROOM_STEP_19= "Your turn again.1 pair of A also not bad.Call to see the turn card."
L.TUTORIAL.ROOM_STEP_22= "What’s your card type now?"
L.TUTORIAL.ROOM_STEP_23= "Now there are only 2 players and you have 2 pair.Nice hand.Try to raise {1} chips."
L.TUTORIAL.ROOM_STEP_25= "Player {1} chooses to call.System will deal the river card."
L.TUTORIAL.ROOM_STEP_27= "5 common cards are here now. So what’s your final hand？"
L.TUTORIAL.ROOM_STEP_29= "Player {1} chooses to All-in.Her hand seems to be good.But your full house is also very strong.All-in!"
L.TUTORIAL.ROOM_STEP_32= "Let’s show hand at last.Wow! Your full house is bigger than {1}’s flush! You win all the chips in the pot."
L.TUTORIAL.ROOM_STEP_34= "These are other functions of game. Try to explore by yourself."

--保险箱
L.SAFE.TITLE = "Safe"
L.SAFE.TAB_TEXT = {
    "Chip",
    "Diamond"
}
L.SAFE.SAVE_MONEY = "Deposit"
L.SAFE.GET_MONEY = "Withdraw"
L.SAFE.SET_PASSWORD = "Set the password"
L.SAFE.CHANGE_PASSWORD = "Modify the password "
L.SAFE.MY_SAFE = "My safe"
L.SAFE.MY_PURSE = "Carry-on money"
L.SAFE.SET_PASSWORD_TIPS_1 = "Enter password"
L.SAFE.SET_PASSWORD_TIPS_2 = "Enter password again"
L.SAFE.SET_PASSWORD_TIPS_3 = "The two password do not agree, please reenter it."
L.SAFE.SET_PASSWORD_TIPS_4 = "You can't leave password empty."
L.SAFE.SET_PASSWORD_TIPS_5 = "Enter password to open the safe."
L.SAFE.FORGET_PASSWORD = "Forget password"
L.SAFE.VIP_TIPS_1 = "Function available for VIP only. Be VIP to use privileges now."
L.SAFE.VIP_TIPS_2 = "Unable to deposit for your VIP has expired. Be VIP to use privileges now."
L.SAFE.SET_PASSWORD_SUCCESS = "Set password success"
L.SAFE.SET_PASSWORD_FAILED = "Failed to set password. Please try again!"
L.SAFE.CHANGE_PASSWORD_SUCCESS = "Change password success."--"修改密码成功!"
L.SAFE.CHANGE_PASSWORD_FAILED = "Change password failed. Please try again."--"修改密码失败,请重试!"
L.SAFE.CHECK_PASSWORD_ERROR = "Wrong password. Please try again!"
L.SAFE.CHECK_PASSWORD_FAILED = "Failed to verify password. Please try again!"
L.SAFE.SAVE_MONEY_FAILED = "Failed to deposit. Please try again!"
L.SAFE.GET_MONEY_FAILED = "Withdraw failed. Please try again!"
L.SAFE.INPUT_MONEY_TIPS = "Please enter a value greater than 0"
L.SAFE.SET_EMAIL = "Set secure email"
L.SAFE.SET_EMAIL_BTN = "Click to Set"--"点击设置"
L.SAFE.CHANGE_EMAIL_BTN = "Change email"--"修改邮箱"
L.SAFE.SET_EMAIL_TIPS_1 = "In order to protect your property, please bind an email receive the email. You can use this email to reset the password and other operations. \nGet 20K chips for first binding."
L.SAFE.SET_EMAIL_TIPS_2 = "Bind email succeed"
L.SAFE.SET_EMAIL_TIPS_3 = "E-mail address e.g. openpokerxxx@gmail.com"
L.SAFE.SET_EMAIL_TIPS_4 = "Please enter the correct email."
L.SAFE.SET_EMAIL_TIPS_5 = "You don't have a secure email.Go set now?"--"你还没有设置安全邮箱,设置后可通过邮箱找回密码"
L.SAFE.SET_EMAIL_TIPS_6 = "Your secure email {1}"--"您已经设置了安全邮箱:{1}"
L.SAFE.SET_EMAIL_SUCCESS = "Bind email success"
L.SAFE.SET_EMAIL_TIPS_FAILED = "Bind email failed. Please try again!"
L.SAFE.RESET_PASSWORD_TIPS_1 = "The reset information has been submitted. Please log in to the email and click the link to verify."
L.SAFE.RESET_PASSWORD_TIPS_2 = "Set a new password. Click OK. The system will send a verification link to your security email. Click on the link within 5 minutes to reset it."--"设置新的密码,点击确定,系统将发送验证链接到您的安全邮箱,5分钟内点击链接激活即可重置成功."
L.SAFE.RESET_PASSWORD_TIPS_3 = "Sorry, this feature is not available because you did not bind a mailbox. Please contact admin."
L.SAFE.RESET_PASSWORD_TIPS_4 = "Reset failed. Please try again."--"重置信息提交失败,请重试."
L.SAFE.RESET_PASSWORD = "Reset Password"--"重置密码"
L.SAFE.CLEAN_PASSWORD = "Cleare Password"--"清空密码"
L.SAFE.CLEAN_PASSWORD_SUCCESS = "Password cleared!"--"清空密码成功!"
L.SAFE.CLEAN_PASSWORD_FAILED = "Cleare Password failed. Please try again."--"清空密码失败,请重试!"

--夺金岛
L.GOLDISLAND.TITLE = "Jackpot"
L.GOLDISLAND.RULE_BTN = "Rules"
L.GOLDISLAND.BUY_BTN = "Buy next hand"
L.GOLDISLAND.ALREADY_BUY = "Bought"
L.GOLDISLAND.PRICE = "{1}chips/time"
L.GOLDISLAND.AUTO_BUY = "Auto buy in"
L.GOLDISLAND.BUY_SUCCESS = "Success to buy jackpot next hand."
L.GOLDISLAND.BUY_FAILED = "Not enough chips to buy next hand."
L.GOLDISLAND.BUY_TIPS = "Sit down to buy next hand."
L.GOLDISLAND.RULE_TITLE = "Rules"
L.GOLDISLAND.RULE_POOL = "Jackpot:"
L.GOLDISLAND.RULE_DESC = [[
1.Game Jackpot is available in room small blind more than 3000 when player sit donw.The fee is 2000 chips per hand（will be deducted from buy-in chips）.This 2000 chips will be part of the pot.

2.The player bought jackpot will be reward if they have the following hand:
Royal Flush : Win 80% jackpot
Straight Flush: Win 30% jackpot
4 of a kind: Win 10% jackpot

3.The player bought jackpot must play until round showdown（No need to win）to get the jackpot. If the player and other plays’ fold make the hand over,the player will not get the jackpot.

4.The system will automatically send the winning chips to the player's account.

5.Click the button jackpot to play.Player can choose to buy once or auto buy.
]]
L.GOLDISLAND.REWARD_TITLE = "Won Jackpot"
L.GOLDISLAND.REWARD_BTN = "OK"
L.GOLDISLAND.CARD_TYPE = "Hand type:{1}"
L.GOLDISLAND.REWARD_NUM = "Won {1}% jackpot:"
L.GOLDISLAND.REWARD_TIPS = "Received the bonus."
L.GOLDISLAND.BROADCAST_REWARD_TIPS = "Congratulations!Player {1} bet on {2} && won {3}chips in Jackpot."

--绑定账号
L.BIND.BTN_TITLE = "Upgrade  account +{1}"
L.BIND.TITLE = "Free upgrade security account"
L.BIND.BTN_TITLE_2 = {
    "Bind Facebook account",
    "Bind line account",
    "Bind VK account"
}
L.BIND.ACCOUNT = {
    "Facebook",
    "Line",
    "VK"
}
L.BIND.SUCCESS_TITLE = "Bind successfully"
L.BIND.FAILED_TITLE = "Binding failed"
L.BIND.GET_REWARD = "Get it immediately"
L.BIND.GET_REWARD_FAILED = "Failed to receive  the reward, please try again"
L.BIND.GET_REWARD_TIPS = "You have successfully bound the guest account to your {1} account,You can choose to log in any way later,And get a safe account reward of {2} chips."
L.BIND.FAILED_TIPS = "Sorry，This account has already been registered for the game\nYou can choose another account to re-bind or log in directly to an existing account"
L.BIND.FAILED_TIPS_2 = "Account binding failed, please try again"
L.BIND.GOTO_LOGIN = "Direct Login"
L.BIND.RETRY = "Rebind"
L.BIND.CANCELED = "Unbind"

--支付引导
L.PAYGUIDE.FIRST_GOODS_DESC = {
    "Receive VIP",
    "Dynamic avatar",
}
L.PAYGUIDE.FIRST_GOODS_DESC_2 = {
    "7 days VIP1",
    "Dynamic avatar",
    "Up to 3 times"
}
L.PAYGUIDE.GOTO_STORE = "Go store"
L.PAYGUIDE.GET_CARSH_REWARD = "Receive{1}alms"
L.PAYGUIDE.FIRST_PAY_TIPS = "Buy chips in the store,get the above gift"
L.PAYGUIDE.BUY_PRICE_1 = "{1} Buy"
L.PAYGUIDE.BUY_PRICE_2 = "Original Price {1}"
L.PAYGUIDE.ROOM_FIRST_PAY_TIPS = "Everyone only can buy once"
return L
