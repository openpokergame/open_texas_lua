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
L.TIPS.ERROR_INVITE_FRIEND = "邀請好友失敗"
L.TIPS.ERROR_TASK_REWARD = "領取任務獎勵失敗"
L.TIPS.ERROR_SEND_FRIEND_CHIP = "給朋友送籌碼失敗"
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "送朋友給籌碼異常"
L.TIPS.ERROR_BUY_GIFT = "贈送禮物失敗"
L.TIPS.ERROR_LOTTER_DRAW = "神秘禮盒領獎失敗"
L.TIPS.EXCEPTION_LOTTER_DRAW = "砸金蛋剩餘次數不夠"
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "登錄房間失敗"
L.TIPS.ERROR_LOGIN_FACEBOOK = "FaceBook登錄失敗"
L.TIPS.ERROR_LOGIN_FAILED = "登錄失敗"
L.TIPS.ERROR_QUICK_IN = "獲取房間資訊失敗"
L.TIPS.EXCEPTION_QUICK_IN = "獲取房間資訊異常"
L.TIPS.ERROR_SEND_FEEDBACK = "伺服器錯誤或網路連結超時，發送回饋失敗！"
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "伺服器錯誤,發送回饋失敗"
L.TIPS.ERROR_MATCH_FEEDBACK = "回饋比賽場錯誤失敗"
L.TIPS.EXCEPTION_ACT_LIST = "伺服器錯誤，載入活動資料失敗"
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "校驗密碼：伺服器錯誤"
L.TIPS.ERROR_BACK_CHECK_PWD = "伺服器錯誤或網路連結超時，校驗密碼失敗"
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "回饋圖片上傳失敗！"
L.TIPS.ERROR_LEVEL_UP_REWARD = "伺服器錯誤或網路超時，領取升級獎勵失敗" 
L.TIPS.WARN_NO_PERMISSION = "你還不能使用此功能，請先到系統授權"
L.TIPS.VIP_GIFT = "VIP用戶才能購買此禮物"
L.TIPS.KAOPU_TIPS = "遊戲初始化失敗，請重試"
L.TIPS.INPUT_NUMBER = "請輸入純數字"
L.TIPS.INPUT_NO_EMPTY = "輸入不能為空"

-- COMMON MODULE
L.COMMON.LEVEL = "等級: "
L.COMMON.ASSETS = "${1}"
L.COMMON.CONFIRM = "確定"
L.COMMON.CANCEL = "取消"
L.COMMON.AGREE = "同意"
L.COMMON.REJECT = "拒絕"
L.COMMON.RETRY = "重連"
L.COMMON.NOTICE = "溫馨提示"
L.COMMON.BUY = "購買"
L.COMMON.SEND = "發送"
L.COMMON.BAD_NETWORK = "網路連接中斷，請檢查你的網路連接是否正常."
L.COMMON.REQUEST_DATA_FAIL = "網路連接中斷，請檢查你的網路連接是否正常，點擊重連按鈕重新連接。"
L.COMMON.ROOM_FULL = "現在該房間旁觀人數過多，請換一個房間"
L.COMMON.USER_BANNED = "你的帳戶被凍結了，請你回饋或聯繫管理員"
L.COMMON.SHARE = "分  享"
L.COMMON.GET_REWARD = "領取獎勵"
L.COMMON.BUY_CHAIP = "購買"
L.COMMON.SYSTEM_BILLBOARD = "官方公告"
L.COMMON.DELETE = "刪除"
L.COMMON.CHECK = "查看"
L.COMMON.CONGRATULATIONS = "恭喜你"
L.COMMON.REWARD_TIPS = "恭喜你獲得了{1}"
L.COMMON.GET = "領取"
L.COMMON.CLICK_GET = "點擊領取"
L.COMMON.ALREADY_GET = "已領取"
L.COMMON.NEXT_GET = "下次領取"
L.COMMON.LOGOUT = "登出"
L.COMMON.LOGOUT_DIALOG_TITLE = "確認退出登錄"
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "你的籌碼不足最小買入{1}，請補充籌碼後重試。"
L.COMMON.USER_SILENCED_MSG = "你的帳號已被禁言，你可以在幫助-回饋裡聯繫管理員處理"
L.COMMON.USER_NEED_RELOGIN = "操作失敗，請重新登錄再試，或者聯繫客服"
L.COMMON.BLIND_BIG_SMALL = "盲注:{1}/{2}"
L.COMMON.NOT_ENOUGH_DIAMONDS = "對不起，你的鑽石不足!"
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "你的籌碼不足，請充值後重試"
L.COMMON.NOT_FINISH = "未完成"

-- android 右鍵退出遊戲提示
L.COMMON.QUIT_DIALOG_TITLE = "確認退出"
L.COMMON.QUIT_DIALOG_MSG = "真的確認退出遊戲嗎？人家好捨不得滴啦~\\(≧▽≦)/~"
L.COMMON.QUIT_DIALOG_MSG_A = "確定要退出了嗎?\n明天登錄還可以領取更多獎勵哦。"
L.COMMON.QUIT_DIALOG_CONFIRM = "忍痛退出"
L.COMMON.QUIT_DIALOG_CANCEL = "我點錯了"
L.COMMON.GAME_NAMES = {
    [1] = "德州撲克",
    [2] = "比賽場",
    [3] = "奧馬哈",
    [4] = "德州百人場",
    [5] = "德州必下場",
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "新用戶前三次登錄，可以免費領取超值幸運註冊大禮包。\nFaceBook登錄用戶領取更高獎勵哦！"
L.LOGIN.FB_LOGIN = "FB帳戶登錄"
L.LOGIN.GU_LOGIN = "遊客帳戶登錄"
L.LOGIN.REWARD_SUCCEED = "領取獎勵成功"
L.LOGIN.REWARD_FAIL = "領取失敗"
L.LOGIN.LOGINING_MSG = "正在登錄遊戲..."
L.LOGIN.CANCELLED_MSG = "登錄已經取消"
L.LOGIN.DOUBLE_LOGIN_MSG = "你的帳戶在其他地方登錄"
L.LOGIN.LOGIN_DEALING = "正在處理登錄,請耐心等待"
L.LOGIN.INIT_SDK = "遊戲正在初始化,請耐心等待"

-- HALL MODULE
L.HALL.USER_ONLINE = "當前線上人數: {1}"
L.HALL.INVITE_TITLE = "邀請好友"
L.HALL.INVITE_FAIL_SESSION = "獲取Facebook資訊失敗，請重試"
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "你輸入的房間號碼有誤"
L.HALL.MATCH_NOT_OPEN = "比賽場將儘快開放"
L.HALL.NOT_TRACK_TIPS = "暫不線上,無法追蹤"
L.HALL.TEXAS_LIMIT_LEVEL = "你的等級不足{1}級，請先玩牌升級後再來!"
L.HALL.TEXAS_GUIDE_TIPS_1 = "你已經是高手了,不要在新手場虐菜了!"
L.HALL.TEXAS_GUIDE_TIPS_2 = "你已經是高手了,可以去適合你的大廠贏錢更多."
L.HALL.TEXAS_GUIDE_TIPS_3 = "恭喜你!你的籌碼已經上升到一個新的高度,是否立即換到更高級的場玩牌?"
L.HALL.TEXAS_UPGRADE = "立即提升"
L.HALL.TEXAS_STILL_ENTER = "依舊進入"
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
    "初級場", ---初級場
    "中級場", ---中級場
    "高級場",----高級場
}
L.HALL.PLAYER_LIMIT_TEXT = {
    "9\n人",
    "6\n人"
}
L.HALL.CHOOSE_ROOM_TYPE = {
    "普通場",
    " 快速場",
}
L.HALL.CHOOSE_ROOM_CITY_NAME = {
    "曼谷",
    "首爾",
    "吉隆坡",
    "上海",

    "莫斯科",
    "東京",
    "米蘭",
    "巴黎",
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "最小{1}/最大{2}"
L.HALL.CHOOSE_ROOM_BLIND = "盲注:{1}/{2}"
L.HALL.GIRL_SHORT_CHAT = {
    "你好，我是荷官，我叫小愛。",
    "我在遊戲房間等你哦~",
    "我們的遊戲很好玩的，經常來玩吧。",
    "討~厭~啦~你在做什麼？",
    "親愛的快去打牌吧。",
    "喜歡嗎？那就去粉絲頁點個贊。",
    "你好可愛，祝你好運。",
    "麼麼噠~ ~(￣3￣)|~",
    "別忘了每天點擊邀請好友一起來捧場哦！大量免費籌碼贈送！",
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "你的等級不足{1}級，請先在德州場玩到{2}級後再來！"
L.HALL.OMAHA_HELP_TITLE = "奧馬哈規則說明"
L.HALL.OMAHA_RULE = [[
玩家每次都會發到4張手牌，玩家必須使用2張且只能用2張手牌與5張公共牌中的3張牌組成最大牌型。
每手牌都包括組成的5張最大的牌型，牌型的大小同德州撲克一樣，詳情可參考牌桌左下角的牌型提示。

奧馬哈更注重手中牌面的數位大小等。在奧馬哈中，手牌值非常重要，因為最可能好的手牌常常勝出。

奧馬哈與德州撲克的不同
1.奧馬哈遊戲開始發給每個玩家第4張底牌，而德州撲克遊戲則是發給每個玩家2張底牌。
2.每一個玩家必須要用4張底牌中的2張底牌與3張公共牌組成一手最好的牌。
3.與德州撲克最多可以加入22個玩家相比，奧馬哈遊戲人數的上限為11個玩家。
]]
L.HALL.TRACE_LIMIT_LEVEL = "追踪失敗,需要等級達到{1}級,才可以進入房間"
L.HALL.TRACE_LIMIT_ANTE = "追踪失敗,需要攜帶{1}籌碼,才可以進入房間"
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
    "拉斯維加斯",
}
L.HALL.TEXAS_MUST_TITLE = ""
L.HALL.TEXAS_MUST_HELP_TITLE = "德州必下場規則"
L.HALL.TEXAS_MUST_RULE = [[
必下場是一種全新的玩法，每位玩家需要在每局遊戲一開始的時候投入5倍大盲的前註，底池將膨脹的更快，玩法更加刺激。

玩家進入遊戲桌時帶入的籌碼為一個固定值。當入座玩家每局開始前籌碼不夠時，系統將自動幫他補充。
]]
L.HALL.SMALL_GAME = "小遊戲"

-- ROOM MODULE
L.ROOM.OPR_TYPE = {
    "看  牌",
    "棄  牌",
    "跟  注",
    "加  注",
}
L.ROOM.MY_MONEY = "My money {1} {2}"
L.ROOM.INFO_UID = "ID {1}"
L.ROOM.INFO_LEVEL = "Lv.{1}"
L.ROOM.INFO_WIN_RATE = "勝率:  {1}%"
L.ROOM.INFO_SEND_CHIPS = "贈送籌碼"
L.ROOM.ADD_FRIEND = "關注" 
L.ROOM.DEL_FRIEND = "取消關注"
L.ROOM.FORBID_CHAT = "屏蔽"
L.ROOM.CANCEL_FORBID_CHAT = "已屏蔽"
L.ROOM.NO_SEND_CHIP_TIPS = "不可贈送"
L.ROOM.ADD_FRIEND_SUCC_MSG = "添加好友成功"
L.ROOM.ADD_FRIEND_FAILED_MSG = "添加好友失敗"
L.ROOM.DELE_FRIEND_SUCCESS_MSG = "刪除好友成功"
L.ROOM.DELE_FRIEND_FAIL_MSG = "刪除好友失敗"
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "只有普通場才可以贈送籌碼"
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "你的籌碼不夠多，不足給荷官小費"
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "坐下才可以贈送籌碼"
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "錢不夠啊"
L.ROOM.SEND_CHIP_TOO_OFTEN = "贈送的太頻繁了"
L.ROOM.SEND_CHIP_TOO_MANY = "贈送的太多了"
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "比賽場不能發送互動道具"
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = "坐下才能發送互動道具"
L.ROOM.SEND_HDDJ_NOT_ENOUGH = "你的互動道具數量不足，趕快去商城購買吧"
L.ROOM.SEND_HDDJ_FAILED = "發送互動道具失敗,請重試"
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = "坐下才可以發送表情"
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "你還未坐下，請坐下後重試"
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2}人)  房間號:{3}  盲注:{4}/{5}"
L.ROOM.PRIVATE_ROOM_INFO = "私人房({1}人)  房間號:{2}  盲注:{3}/{4}"
L.ROOM.PRIVTE_INFO = "房間剩餘時間：{1}"
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "發送大喇叭消息失敗"
L.ROOM.NOT_ENOUGH_LABA = "你的大喇叭不足"
L.ROOM.CHAT_MAIN_TAB_TEXT = {
    "消息", 
    "消息記錄"
}
L.ROOM.USER_CARSH_REWARD_DESC = "你獲得了{1}籌碼的破產補助，終身只有三次機會獲得，且用且珍惜"
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "你也可以立即購買，輸贏只是轉瞬的事"
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = "你已經領完所有破產補助，快點去商場購買籌碼吧，每天登錄還有免費籌碼贈送哦！"
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = "輸贏乃兵家常事，不要灰心，立即購買籌碼，重整旗鼓。"
L.ROOM.WAIT_NEXT_ROUND = "請等待下一局開始"
L.ROOM.LOGIN_ROOM_FAIL_MSG = "登錄房間失敗"
L.ROOM.BUYIN_ALL_POT= "全部獎池"
L.ROOM.BUYIN_3QUOT_POT = "3/4獎池"
L.ROOM.BUYIN_HALF_POT = "1/2獎池"
L.ROOM.BUYIN_TRIPLE = "3倍反加"
L.ROOM.CHAT_TAB_SHORTCUT = "快捷聊天"
L.ROOM.CHAT_TAB_HISTORY = "聊天記錄"
L.ROOM.INPUT_HINT_MSG = "點擊輸入聊天內容"
L.ROOM.INPUT_ALERT = "請輸入有效內容"
L.ROOM.CHAT_SHIELD = "你已成功屏蔽{1}的發言"
L.ROOM.CHAT_SHORTCUT = {
  "你們好! ",
  "快點，等不了了",
  "ALL IN！！",
  "衝動是魔鬼，淡定",
  "好厲害",
  "誰敢來比比",
  "謝謝你送我籌碼",
  "和你玩牌真有意思",
  "有籌碼任性",
  "今天有點背",
  "不要吵架",
  "有女/男朋友了嗎",
  "牌不好，換房間試試",
  "多多關照",
  "今天手氣不錯",
  "送點錢吧",
  "求跟注，求ALL-IN！",
  "買點籌碼再戰！",
  "可以看看牌嗎",
  "不好意思，先走了"
}
L.ROOM.VOICE_TOOSHORT = "錄音時間太短了"
L.ROOM.VOICE_TOOLONG = "錄音時間太長了"
L.ROOM.VOICE_RECORDING = "正在錄音，上滑取消"
L.ROOM.VOICE_CANCELED = "錄音已取消"
L.ROOM.VOICE_TOOFAST = "你操作太頻繁啦"
--荷官回饋
L.ROOM.DEALER_SPEEK_ARRAY = {
    "感謝你{1}！幸運必將常伴你左右！",
    "感謝你{1}！好運即將到來！",
    "感謝好心的{1}",
}
--買入彈框
L.ROOM.BUY_IN_TITLE = "買入籌碼"
L.ROOM.BUY_IN_BALANCE_TITLE = "你的帳戶餘額:"
L.ROOM.BUY_IN_MIN = "最低買入"
L.ROOM.BUY_IN_MAX = "最高買入"
L.ROOM.BUY_IN_AUTO = "小於大盲時自動買入"
L.ROOM.BUY_IN_AUTO_MIN = "小於最小買入時自動買入"
L.ROOM.BUY_IN_BTN_LABEL = "買入坐下"
L.ROOM.ADD_IN_TITLE = "增加籌碼"
L.ROOM.ADD_IN_BTN_LABEL = "買 入"
L.ROOM.ADD_IN_BTN_TIPS = "坐下才能增加籌碼"
L.ROOM.ADD_IN_BTN_TIPS_2 = "沒有多餘的籌碼，無法增加"
L.ROOM.ADD_IN_BTN_TIPS_3 = "你的籌碼已經達到場次上限，無法增加更多"
L.ROOM.ADD_IN_SUC_TIPS = "增加成功，將在下局開始為你自動增加{1}籌碼"
L.ROOM.BACK_TO_HALL = "返回大廳"
L.ROOM.CHANGE_ROOM = "換  桌"
L.ROOM.SETTING = "設  置"
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "你的籌碼不足當前房間的最小攜帶，你可以點擊換桌系統幫你選擇房間或者補足籌碼重新坐下。"
L.ROOM.AUTO_CHANGE_ROOM = "換  桌"
L.ROOM.USER_INFO_ROOM = "個人資訊"
L.ROOM.CHARGE_CHIPS = "補充籌碼"
L.ROOM.ENTERING_MSG = "正在進入，請稍候...\n有識尚需有膽方可成贏家"
L.ROOM.OUT_MSG = "正在退出，請稍候..."
L.ROOM.CHANGING_ROOM_MSG = "正在更換房間.."
L.ROOM.CHANGE_ROOM_FAIL = "更換房間失敗，是否重試？"
L.ROOM.STAND_UP_IN_GAME_MSG = "你還在當前牌局中，確認站起嗎？"
L.ROOM.LEAVE_IN_GAME_MSG = "你還在當前牌局中，確認要離開嗎？"
L.ROOM.RECONNECT_MSG = "正在重新連接.."
L.ROOM.OPR_STATUS = {
    "棄  牌",
    "ALL_IN",
    "跟  注",
    "跟注 {1}",
    "小  盲",
    "大  盲",
    "看  牌",
    "加注 {1}",
    "加  注",
}
L.ROOM.AUTO_CHECK = "自動看牌"
L.ROOM.AUTO_CHECK_OR_FOLD = "看或棄"
L.ROOM.AUTO_FOLD = "自動棄牌"
L.ROOM.AUTO_CALL_ANY = "跟任何注"
L.ROOM.FOLD = "棄  牌"
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
    "小提示：遊客用戶點擊自己的頭像彈框或者性別標誌可更換頭像和性別哦",
    "小經驗：當你牌比對方小的時候，你會輸掉已經押上的所有籌碼",
    "高手養成：所有的高手，在他會德州遊戲之前，一定是一個德州遊戲的菜鳥",
    "有了好牌要加注，要掌握優勢，主動進攻。",
    "留意觀察對手，不要被對手的某些伎倆所欺騙。",
    "要打出氣勢，讓別人怕你。",
    "控制情緒，贏下該贏的牌。",
    "遊客玩家可以自訂自己的頭像。",
    "小提示：設置頁可以設置進入房間是否自動買入坐下。",
    "小提示：設置頁可以設置是否震動提醒。",
    "忍是為了下一次All In。",
    "衝動是魔鬼，心態好，好運自然來。",
    "風水不好時，嘗試換個位置。",
    "輸牌並不可怕，輸掉信心才是最可怕的。",
    "你不能控制輸贏，但可以控制輸贏的多少。",
    "用互動道具砸醒長時間不反應的玩家。",
    "運氣有時好有時壞，知識將伴隨你一生。",
    "詐唬是勝利的一大手段，要有選擇性的詐唬。",
    "下注要結合池底，不要看絕對數字。",
    "All In是一種戰術，用好並不容易。",
    








    
}
L.ROOM.SHOW_HANDCARD = "亮出手牌"
L.ROOM.SERVER_UPGRADE_MSG = "伺服器正在升級中，請稍候.."
L.ROOM.KICKED_BY_ADMIN_MSG = "你已被管理員踢出該房間"
L.ROOM.KICKED_BY_USER_MSG = "你被用戶{1}踢出了房間"
L.ROOM.TO_BE_KICKED_BY_USER_MSG = "你被用戶{1}踢出房間，本局結束之後將自動返回大廳"
L.ROOM.BET_LIMIT = "下注失敗，你單局下注不能超過最大下注100M限制。"
L.ROOM.BET_LIMIT_1 = "下注失敗，你單局下注不能超過最大下注{1}限制。"
L.ROOM.NO_BET_STAND_UP = "你三局未操作，已自動站起"
L.ROOM.PRE_BLIND = "前註"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "坐下失敗，同一IP不能坐下"
T["SEAT_NOT_EMPTY"] = "坐下失敗，該桌位已經有玩家坐下。"
T["TOO_RICH"] = "坐下失敗，這麼多籌碼還來新手場虐人？"
T["TOO_POOR"] = "坐下失敗，籌碼不足無法進入非新手場房間。"
T["NO_OPER"] = "你超過三次沒有操作，已被自動站起，重新坐下即可重新開始"
L.ROOM.SERVER_STOPPED_MSG = "系統正在停服維護, 請耐心等候"
L.ROOM.GUIDEHEIGHT = "去{1}場可贏更多錢"
L.ROOM.GUIDELOW = "去{1}場可以較少損失"
L.ROOM.CARD_POWER_DESC = [[
牌力指示器僅基於玩家手牌和底池綜合計算得出的勝率,僅供參考

初級場免費使用,開通任意VIP即可免費在任意場無限制使用

默認開啟你也可以手動關閉,關閉後還可以從設置裡再次打開
]]

--STORE
L.STORE.TOP_LIST = {
    "籌碼",
    "鑽石",
    "道具",
    "VIP"
}
L.STORE.NOT_SUPPORT_MSG = "你的帳戶暫不支援支付"
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "已支付成功，正在進行發貨，請稍候.."
L.STORE.PURCHASE_CANCELED_MSG = "支付已經取消"
L.STORE.PURCHASE_FAILED_MSG = "支付失敗，請重試"
L.STORE.PURCHASE_FAILED_MSG_2 = "請輸入正確卡號和密碼"
L.STORE.PURCHASE_FAILED_MSG_3 = "此卡已經使用過"
L.STORE.PURCHASE_FAILED_MSG_4 = "此卡無效"
L.STORE.DELIVERY_FAILED_MSG = "網路故障，系統將在你下次打開商城時重試。"
L.STORE.DELIVERY_SUCC_MSG = "發貨成功，感謝你的購買。"
L.STORE.TITLE_STORE = "商城"
L.STORE.TITLE_CHIP = "籌碼"
L.STORE.TITLE_PROP = "互動道具"
L.STORE.TITLE_MY_PROP = "我的道具"
L.STORE.TITLE_HISTORY = "購買記錄"
L.STORE.RATE_DIAMONDS = "1{2}={1}鑽石"
L.STORE.RATE_CHIP = "1{2}={1}籌碼"
L.STORE.RATE_PROP = "1{2}={1}個道具"
L.STORE.FORMAT_DIAMONDS = "{1} 鑽石"
L.STORE.FORMAT_CHIP = "{1} 籌碼"
L.STORE.FORMAT_PROP = "{1} 道具"
L.STORE.FORMAT_HDDJ = "{1} 互動道具"
L.STORE.FORMAT_DLB = "{1} 大喇叭"
L.STORE.FORMAT_LPQ = "{1} 禮品券"
L.STORE.FORMAT_DHQ = "{1} 兌換券"
L.STORE.FORMAT_MYB = "{1} 螞蟻幣"
L.STORE.HDDJ_DESC = "可在牌桌上對玩家使用{1}次互動道具"
L.STORE.DLB_DESC = "可在牌桌聊天彈框對全服的玩家發送{1}次廣播"
L.STORE.BUY = "購買"
L.STORE.USE = "使用"
L.STORE.BUY_DESC = "購買 {1}"
L.STORE.RECORD_STATUS = {
    "已下單",
    "已發貨",
    "已退款"
}
L.STORE.NO_PRODUCT_HINT = "暫無商品"
L.STORE.NO_BUY_HISTORY_HINT = "暫無支付記錄"
L.STORE.BUSY_PURCHASING_MSG = "正在購買，請稍候.."
L.STORE.CARD_INPUT_SUBMIT = "充值"
L.STORE.BLUEPAY_CHECK = "你確定要花{1}購買{2}嗎?"
L.STORE.GENERATE_ORDERID_FAIL = "下單失敗，請重試！"
L.STORE.INPUT_NUM_EMPTY = "卡號輸入不能為空，請重新輸入！"
L.STORE.INPUT_PASSWORD_EMPTY = "密碼輸入不能為空，請重新輸入！"
L.STORE.INPUT_NUM_PASSWORD_EMPTY = "卡號或密碼輸入為空，請重新輸入！"
L.STORE.INPUT_CRAD_NUM = "請輸入卡號"
L.STORE.INPUT_CRAD_PASSWORD = "請輸入密碼"
L.STORE.QUICK_MORE = "查看更多"
L.STORE.REAL_TAB_LIST = {
    "禮品券",
    "兌換券",
    "螞蟻幣",
}
L.STORE.REAL_ADDRESS_BTN = "收貨地址"
L.STORE.REAL_EXCHANGE_BTN = "兌換"
L.STORE.ADDRESS_POP_TITLE = "編輯收貨地址"
L.STORE.REAL_TIPS = "請務必填寫真實姓名和聯繫方式,以便獲獎後聯繫"
L.STORE.REAL_TIPS_2 = "請把資訊填寫完整"
L.STORE.REAL_SAVE = "保存"
L.STORE.REAL_TITLES = {
    "收貨人:",
    "手機號碼:",
    "收貨地址:",
    "郵編:",
    "電子郵箱:"
}
L.STORE.REAL_PLACEHOLDER = {
    "姓名",
    "手機號碼",
    "請務必填寫詳細的省.市.區(縣)及街道門牌信息",
    "郵編",
    "電子郵箱"
}
L.STORE.EXCHANGE_REAL_SUCCESS = "恭喜你,兌換{1}成功,我們會儘快給你發貨!"
L.STORE.EXCHANGE_REAL_FAILED_1 = "你的{1}數量不足,兌換{2}需要{3}"
L.STORE.EXCHANGE_REAL_FAILED_2 = "兌換失敗,請重試!"
L.STORE.TAB_LIST = {
    "商城",
    "禮品兌換"
}
L.STORE.CASH_CARD_TITLE = "兌換充值卡"
L.STORE.CASH_CARD_TIPS_1 = "請輸入你的手機號碼,務必真實有效的.\n我們將把充值卡的信息,發送到你填寫的手機上."
L.STORE.CASH_CARD_TIPS_2 = "請輸入你的手機號碼"
L.STORE.CASH_CARD_TIPS_3 = "請輸入10位由數字組成的電話號碼"
L.STORE.CASH_CARD_TIPS_4 = "你輸入的電話號碼是{1}-{2}-{3},我們將向此號碼發送充值卡的信息."

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "你的場外籌碼不足5000,暫時無法使用VIP表情"
L.VIP.SEND_EXPRESSIONS_TIPS = "你還不是VIP使用者,使用VIP表情需要扣除相應的籌碼,成為VIP即可免費使用,還有超多優惠和特權."
L.VIP.BUY_PROP = "購買道具"
L.VIP.OPEN_VIP = "成為VIP"
L.VIP.COST_CHIPS = "花費{1}籌碼"
L.VIP.LIST_TITLE = {
    "價格",
    -- "踢人卡",
    "VIP牌力指示器",
    "VIP禮物",
    "VIP道具",
    "VIP表情",
    -- "私人房折扣",
    -- "破產優惠",
    -- "經驗",
    "每天登錄",
    "立即贈送籌碼",
} 
L.VIP.NOT_VIP = "未購買"
L.VIP.AVAILABLE_DAYS = "剩餘{1}天"
L.VIP.OPEN_BTN = "開通{1}鑽石"
L.VIP.AGAIN_BTN = "續費{1}鑽石"
L.VIP.CONTINUE_BUY = "繼續購買"
L.VIP.BROKE_REWARD = "多送{1}% 每天{2}次"
L.VIP.LOGINREWARD = "{1}*31天"
L.VIP.PRIVATE_SALE = "優惠{1}%"
L.VIP.SEND_PROPS_TIPS_1 = "互動道具VIP免費任意使用"
L.VIP.SEND_PROPS_TIPS_2 = "你的互動道具已用完,你可以選擇花費籌碼使用,成為VIP即可免費使用,還有超多優惠和特權."
-- L.VIP.KICK_CARD = "踢人卡"
-- L.VIP.KICK_SUCC = "踢人成功，玩家将在本局结束后被提出牌桌。"
-- L.VIP.KICK_FAILED = "踢人失败,请稍后重试"
-- L.VIP.KICKED_TIP = "抱歉，你被玩家{1}踢出牌局，将在本局结束后离开此牌桌。"
-- L.VIP.KICKER_TOO_MUCH = "你当天的使用次数已达到上限，请遵守牌桌秩序，严禁恶意踢人。"
-- L.VIP.KICKED_ENTER_AGAIN = "你已被踢出此房间，20分钟内无法进入，你可以选择其他房间或者重新快速开始"
L.VIP.BUY_SUCCESS = "恭喜你,購買VIP成功!"
L.VIP.BUY_FAILED = "VIP購買失敗,請重試"
L.VIP.BUY_FAILED_TIPS = "你的鑽石不足,請先購買鑽石!"
L.VIP.BUY_TIPS_1 = "你將購買{1},需要花費{2}鑽石."
L.VIP.BUY_TIPS_2 = "你目前是{1}VIP還未到期,如果你選擇繼續購買,將放棄現在的{2}VIP的所有特權並立即成為{3}VIP,是否繼續?"
L.VIP.BUY_TIPS_3 = "你現在是{1},將對此等級VIP服務進行續費,使用期限延長{2}天,需要花費{3}鑽石."
L.VIP.LEVEL_NAME = {
    "領主",
    "貴族",
    "王族",
    "皇族"
}
L.VIP.NO_VIP_TIPS = "你還不是VIP用戶,是否立即成為VIP,還有超多優惠和特權."
L.VIP.CARD_POWER_TIPS = "你還不是VIP用戶,是否"
L.VIP.CARD_POWER_OPEN_VIP = "“立即開通”"
L.VIP.VIP_AVATAR = "VIP動態頭像"
L.VIP.NOR_AVATAR = "普通頭像"
L.VIP.SET_AVATAR_SUCCESS = "設定頭像成功!"
L.VIP.SET_AVATAR_FAILED_1 = "設定頭像失敗,請重試."
L.VIP.SET_AVATAR_FAILED_2 = "你的VIP等級不够,請選擇其他頭像."
L.VIP.SET_AVATAR_TIPS = [[
你還不是VIP用戶,只能預覽頭像效果,需要成為VIP後才可使用VIP專屬頭像,開通VIP可獲贈大量免費籌碼,充值優惠等一系列特權.

是否需要立即開通VIP？
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "Facebook登錄領取"
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}"
L.LOGINREWARD.REWARD_BTN        = "領取{1}"
L.LOGINREWARD.GET_REWARD_FAILED = "簽到失敗，請重試!"
L.LOGINREWARD.VIP_REWARD_TIPS   = "VIP登錄獎勵"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2}" --經驗值
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
    "常規場",
    "坐滿即玩",
    "錦標賽"
}
L.USERINFO.BOARD_SORT = {
    "時間排序",
    "輸贏排序"
}
L.USERINFO.NO_RECORD = "暫無記錄"
L.USERINFO.LAST_GAME = "上一局"
L.USERINFO.NEXT_GAME = "下一局"
L.USERINFO.PLAY_TOTOAL_COUNT = "牌局: "
L.USERINFO.PLAY_START_RATE = "入局率: "
L.USERINFO.WIN_TOTAL_RATE = "勝率: "
L.USERINFO.SHOW_CARD_RATE = "攤牌率: "
L.USERINFO.MAX_CARD_TYPE = "最大牌型"
L.USERINFO.JOIN_MATCH_NUM = "參賽次數"
L.USERINFO.GET_REWARD_NUM = "獲獎次數"
L.USERINFO.MATCH_BEST_SCORE = "錦標賽最好成績"
L.USERINFO.MY_CUP = "我的獎盃"
L.USERINFO.NO_CHECK_LINE = "未填寫"
L.USERINFO.BOARD = "牌局記錄"
L.USERINFO.MY_PACK = "我的背包"
L.USERINFO.ACHIEVEMENT_TITLE = "成就"
L.USERINFO.REAL_STORE = "禮品兌換"
L.USERINFO.LINE_CHECK_NO_EMPTY = "Line號不能為空！請重新輸入"
L.USERINFO.NICK_NO_EMPTY = "名字不能為空！請重新輸入"
L.USERINFO.LINE_CHECK_ONECE = "一天只能提交一次Line認證"
L.USERINFO.LINE_CHECK_FAIL = "提交認證失敗，請重試!"
L.USERINFO.LINE_CHECK_SUCCESS = "提交認證成功"
L.USERINFO.GET_BOARD_RECORD_FAIL = "獲取個人戰績資訊失敗，請關閉彈窗重試！"
L.USERINFO.PACKAGE_INFO = {
    {
        title = "互動道具",
        desc = "可以在牌桌上對其他玩家釋放的互動道具"
    },
    {
        title = "大喇叭",
        desc = "可以在牌桌上對全服的玩家進行廣播"
    },
    {
        title = "兌換券",
        desc = "可花費多張劵兌換相應的禮品"
    },
    {
        title = "禮品券",
        desc = "可直接兌換券上相應的禮品"
    },
    {
        title = "螞蟻幣",
        desc = "非常有價值的一種數字貨幣"
    },
}
L.USERINFO.MARK_TEXT = {
    "跟注站",
    "瘋子",
    "緊凶型",
    "緊弱型",
    "岩石型",
    "黃色警報",
    "松弱魚",
    "自訂"
}
L.USERINFO.MARK_TITLE = "標記玩家"
L.USERINFO.MARK_TIPS = "點擊選中標記"
L.USERINFO.MARK_SUCCESS = "標記玩家成功"
L.USERINFO.MARK_FAIL = "標記玩家失敗，請重試"
L.USERINFO.MARK_NO_EMPTY = "玩家標記輸入不能為空，請重新輸入"
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "沒有安裝SD卡，無法使用頭像上傳功能"
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "獲取圖像失敗"
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "上傳頭像失敗，請稍後重試"
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "正在上傳頭像，請稍候..."
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "上傳頭像成功"
L.USERINFO.CHOOSE_COUNTRY_TITLE = "選擇國家"
L.USERINFO.COUNTRY_LIST = {
    {
        title = "亞洲",
        list = {
            "阿聯酋",
            "澳門",
            "巴基斯坦",
            "菲律賓",
            "哈薩克斯坦",
            "韓國",
            "老撾",
            "馬來西亞",
            "緬甸",
            "日本",
            "台灣",
            "泰國",
            "香港",
            "新加坡",
            "以色列",
            "印度",
            "印度尼西亞",
            "越南",
            "中國",
        }
    },
    {
        title = "北美洲",
        list = {
            "巴拿馬",
            "哥斯達黎加",
            "古巴",
            "加拿大",
            "美國",
            "墨西哥",
        }
    },
    {
        title = "南美洲",
        list = {
            "阿根廷",
            "巴拉圭",
            "巴西",
            "哥倫比亞",
            "秘魯",
            "委內瑞拉",
            "烏拉圭",
            "智利",
        }
    },
    {
        title = "歐洲",
        list = {
            "奧地利",
            "白俄羅斯",
            "比利時",
            "波蘭",
            "德國",
            "俄羅斯",
            "法國",
            "芬蘭",
            "荷蘭",
            "捷克",
            "克羅地亞",
            "立陶宛",
            "羅馬尼亞",
            "摩納哥",
            "葡萄牙",
            "瑞典",
            "瑞士",
            "塞爾維亞",
            "斯洛文尼亞",
            "烏克蘭",
            "西班牙",
            "希臘",
            "匈牙利",
            "意大利",
            "英國",
        }
    },
    {
        title = "大洋洲",
        list = {
            "加拿大",
            "新西蘭",
        }
    },
    {
        title = "非洲",
        list = {
            "剛果",
            "加納",
            "津巴布韋",
            "南非",
            "尼日利亞",
            "塞內加爾",
        }
    },
}

-- FRIEND MODULE
L.FRIEND.TITLE = "好友"
L.FRIEND.NO_FRIEND_TIP = "暫無好友"
L.FRIEND.SEND_CHIP = "贈送籌碼"
L.FRIEND.RECALL_CHIP = "召回+{1}"
L.FRIEND.ONE_KEY_SEND_CHIP = "一鍵贈送"
L.FRIEND.ONE_KEY_RECALL = "一鍵召回"
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "你的攜帶籌碼的一半不足全部送出，請先補充籌碼後重試。"
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "確定要贈你給你的{1}位好友總計{2}籌碼嗎？"
L.FRIEND.ADD_FULL_TIPS = "你的好友已達到{1}的上限，系統將根據玩牌情況刪除長久不玩牌的好友。"
L.FRIEND.SEND_CHIP_WITH_NUM = "贈送{1}籌碼"
L.FRIEND.SEND_CHIP_SUCCESS = "你成功給好友贈送了{1}籌碼。"
L.FRIEND.SEND_CHIP_PUSH = "{1} 贈送了10K籌碼給你，快來領取吧！"
L.FRIEND.SEND_CHIP_TOO_POOR = "你的籌碼太少了，請去商城購買籌碼後重試。"
L.FRIEND.SEND_CHIP_COUNT_OUT = "你今天已經給該好友贈送過籌碼了，請明天再試。"
L.FRIEND.SELECT_ALL = "全選"
L.FRIEND.SELECT_NUM = "選擇{1}人"
L.FRIEND.DESELECT_ALL = "取消選擇"
L.FRIEND.SEND_INVITE = "邀請"
L.FRIEND.INVITE_SENDED = "已邀請"
L.FRIEND.INVITE_SUBJECT = "你絕對會喜歡"
L.FRIEND.CALL_FRIEND_TO_GAME = "來玩牌吧！很好玩的遊戲"
L.FRIEND.INVITE_CONTENT = "為你推薦一個既刺激又有趣的撲克遊戲，我給你贈送了15萬的籌碼禮包，註冊即可領取，快來和我一起玩吧！"..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP = "你已選擇了{1}位好友，發送邀請即可獲得{2}籌碼的獎勵"
L.FRIEND.INVITE_SELECT_TIP_1 = "你已選擇了"
L.FRIEND.INVITE_SELECT_TIP_2 = "位好友，發送邀請即可獲得"
L.FRIEND.INVITE_SELECT_TIP_3 = "籌碼的獎勵"
L.FRIEND.INVITE_SUCC_TIP = "成功發送了邀請，獲得{1}籌碼的獎勵！"
L.FRIEND.INVITE_SUCC_FULL_TIP = "成功發送邀請，今日已獲得{1}邀請發送獎勵。"
L.FRIEND.INVITE_FULL_TIP = "Facebook邀請已達上限，你可以選擇發送邀請碼獲得更多獎勵"
L.FRIEND.RECALL_SUCC_TIP = "發送成功獎勵{1}，好友上線後即可獲贈{2}籌碼獎勵。"
L.FRIEND.RECALL_FAILED_TIP = "發送失敗，請稍後重試."
L.FRIEND.INVITE_LEFT_TIP = "今天還可以邀請{1}個好友！"
L.FRIEND.CANNOT_SEND_MAIL = "你還沒有設置郵箱帳戶，現在去設置嗎？"
L.FRIEND.CANNOT_SEND_SMS = "對不起，無法調用發送短信功能！"
L.FRIEND.MAIN_TAB_TEXT = {
    "我關注的",
    "關注我的",
    "更多好友"
}
L.FRIEND.INVITE_EMPTY_TIP = "請先選擇好友"
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "你的好友已達到{1}上限，請刪除部分後重新添加"
L.FRIEND.SEARCH_FRIEND = "請輸入FB好友名稱"
L.FRIEND.INVITE_REWARD_TIPS_1 = "邀請"
L.FRIEND.INVITE_REWARD_TIPS_2 = "位好友可獲得"
L.FRIEND.INVITE_REWARD_TIPS_3 = ",好友越多獎勵越多,每位好友成功登錄遊戲還可以再獲得"
L.FRIEND.SEARCH = "查找"
L.FRIEND.CLEAR = "清除"
L.FRIEND.INPUT_USER_ID = "點擊輸入玩家ID"
L.FRIEND.INPUT_USER_ID_NO_EXIST = "你輸入的ID不存在，請確認後重新輸入"
L.FRIEND.NO_SEARCH_SELF = "無法查找自己的ID，請重新輸入"
L.FRIEND.NO_LINE_APP = "你沒有安裝Line應用,請使用其他方式邀請"
L.FRIEND.INVITE_REWARD_TIPS = "達成邀請人數還有超級大禮包贈送，可點擊禮包查看詳情\n你累計成功邀請了{1}位好友，獲得了{2}的籌碼獎勵"
L.FRIEND.INVITE_FB_FRIEND_TITLE = "邀請FB好友"
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "每天發送就送{1}\n成功一個再送{2}籌碼"
L.FRIEND.INVITE_CODE_TITLE = "邀請碼"
L.FRIEND.INVITE_CODE_CONTENT = "成功就送{1}\n好友的好友再送{2}"
L.FRIEND.GET_REWARD_TIPS_1 = "恭喜你獲得了邀請獎勵!"
L.FRIEND.GET_REWARD_TIPS_2 = "你還差{1}人才能領取獎勵，點擊邀請按鈕繼續邀請你的好友吧!"
L.FRIEND.ROOM_INVITE_TITLE = "邀請打牌"
L.FRIEND.ROOM_INVITE_SUCCTIPS = "邀請已發出，請耐心等待"
L.FRIEND.ROOM_INVITE_TAB = {
    "當前線上",
    "好友"
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1}邀請你去{2}{3}一起玩牌"
L.FRIEND.ROOM_INVITE_PLAY_DES = "獨樂樂不如与眾樂樂，你可以點擊下面的按鈕發送鏈接發送給好友或者群里邀請大家一起來玩。\n\n好友安裝後點擊或者刷新頁面即可直接進入房間。"

-- RANKING MODULE
L.RANKING.TITLE = "排行榜"
L.RANKING.TRACE_PLAYER = "追蹤玩家"
L.RANKING.GET_REWARD_BTN = "領取"
L.RANKING.NOT_DATA_TIPS = "暫無數據"
L.RANKING.NOT_IN_CHIP_RANKING = "你的排名:>20名,你暫時未進入排行榜，請繼續加油!"
L.RANKING.IN_RANKING = "你的排名:第{1}名，再接再厲！"
L.RANKING.IN_RANKING_NO_1 = "你的排名：第1名，無敵是多麼寂寞！"
L.RANKING.MAIN_TAB_TEXT = {
    "好友排行",
    "世界排行",
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
    "昨日盈利榜",
    "財富榜",
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
    "昨日盈利榜",
    "財富榜",
}

-- SETTING MODULE
L.SETTING.TITLE = "設置"
L.SETTING.NICK = "昵稱"
L.SETTING.LANGUAGE = "語言"
L.SETTING.EXCHANGE = "兌換碼"
L.SETTING.LOGOUT = "登出"
L.SETTING.FB_LOGIN = "登錄 +19999"
L.SETTING.SOUND_VIBRATE = "聲音和震動"
L.SETTING.SOUND = "聲音"
L.SETTING.BG_SOUND = "背景音效"
L.SETTING.CHATVOICE = "聊天音效"
L.SETTING.VIBRATE = "震動"
L.SETTING.AUTO_SIT = "進入房間自動坐下"
L.SETTING.AUTO_BUYIN = "小於大盲時自動買入"
L.SETTING.CARD_POWER = "牌力指示器"
L.SETTING.APP_STORE_GRADE = "喜歡我們，打分鼓勵"
L.SETTING.CHECK_VERSION = "檢測更新"
L.SETTING.CURRENT_VERSION = "當前版本號：V{1}"
L.SETTING.ABOUT = "關於"
L.SETTING.PUSH_NOTIFY = "推送通知"
L.SETTING.PUSH_TIPS = [[
系統每天會隨機贈送大量免費籌碼，先到先得搶完為止，
開啟後可以直接點擊搶錢快人一步。

點擊確定按鈕，找到通知管理-打開通知，即可領取免費兌換碼.
]]

--HELP
L.HELP.TITLE = "幫助中心"
L.HELP.FANS = "官方粉絲頁"
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
    "玩法介紹",
    "名詞解釋",
    "等級說明",
    "常見問題",
    "問題回饋",
}

L.HELP.PLAY_SUB_TAB_TEXT = {
    "玩法說明",
    "比牌規則",
    "操作說明",
    "按鈕說明",
}

L.HELP.LEVEL_RULE = "玩牌即可獲得經驗,普通場入局一次，獲勝經驗+2，失敗經驗+1，特殊場次玩牌不加經驗,如:比賽場"
L.HELP.LEVEL_TITLES = {
    "等級",
    "稱號",
    "經驗",
    "獎勵"
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
    "支付問題",
    "帳號問題",
    "遊戲BUG",
    "遊戲建議",
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
    "玩法資料說明",
    "玩家類型標注",
}

L.HELP.FEED_BACK_SUCCESS = "回饋成功!"
L.HELP.FEED_BACK_FIAL = "回饋失敗!請重試!"
L.HELP.UPLOADING_PIC_MSG = "正在上傳圖片，請稍候.."
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "請輸入回饋內容"
L.HELP.MATCH_QUESTION = "比賽問題"
L.HELP.FAQ = {
    {
        "我的籌碼用完了，但是還想玩，要怎麼辦？",
        "點擊頭像右側的商城購買籌碼即可。"
    },
    {
        "為什麼我贈送不了遊戲幣？",
        "在牌桌上每人每天只能贈送五千，在好友列表裡每人每天只能贈送五百。"
    },
    {
        "在哪裡領取免費籌碼？",
        "登錄獎勵、線上獎勵、任務獎勵、粉絲獎勵、邀請好友獎勵等等,都可以免費領取籌碼，還有不同的活動。"
    },
      {
        "怎樣購買籌碼？",
        "點擊商城按鈕，然後選擇你需要的籌碼。"
    },
	{
        "怎樣成為粉絲？",
        "點擊設置按鈕，下方有粉絲頁面入口，或點選連結"..appconfig.FANS_URL.."/ \n系統會經常給粉絲發福利喲~"
    },
	{
        "怎樣登出？",
        "點擊設置按鈕，再選擇登出即可。"
    },
	{
        "怎樣改變名字、頭像和性別？",
        "點擊自己的頭像，點擊不同功能按鈕即可。"
    },
	{
        "line認證是什麼？",
        "添加官方Line號:OpenPoker，經過工作人員認證後，在遊戲裡会顯示你正確的line號，方便交到更多好友"
    }
}

L.HELP.PLAY_DESC = {
    "手牌",
    "公共牌",
    "成牌",
    "玩家A",
    "玩家B",
    "翻牌",
    "轉牌",
    "河牌",
    "葫蘆 WIN",
    "兩對 LOSE",
}

L.HELP.PLAY_DESC_2 = "在牌局開始時,荷官會給每個玩家發2張牌，稱為“手牌”，桌面上會分三次陸續發出3張、1張、1張（共5張）的公共牌,在經過四輪的“加註”、“跟注”和“棄牌”等押注圈操作後,把自己的2張底牌和5張公共牌挑選出最大的5張組合,按照牌型大小規則分出勝負。"

L.HELP.RULE_DESC = {
    "皇家同花順",
    "同花順",
    "四條",
    "葫蘆",
    "同花",
    "順子",
    "三條",
    "兩對",
    "一對",
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
    "同一花色最大的順子",
    "同一花色的順子",
    "4張相同+1單張",
    "3張相同+1對",
    "5張牌花色相同",
    "花色不同的順子",
    "3張相同+2單張",
    "2對+1單張",
    "1對+3單張",
    "5個單張牌"
}
L.HELP.OPERATING_DESC = {
    "主菜單",
    "購買籌碼",
    "池底+邊池",
    "莊家",
    "公共牌",
    "底牌",
    "牌型提示",
    "操作介面",
    "帶入籌碼",
    "牌型大小和成牌概率",
    "一對",
    "加注",
    "跟注",
    "棄牌",
}

L.HELP.FEED_BACK_HINT = {
    "請盡可能提供詳細的支付資訊以方便我們的客服人員快速為你解決問題",
    "請提供你的用戶ID以便我們為你解決問題，用戶ID一般位於頭像下方",
    "非常抱歉，你提出的任何問題我們都會第一時間給出回饋",
    "非常歡迎你對我們提出的任何建議或者意見，你的回饋是我們持續優化的動力",
}

L.HELP.PLAY_BTN_DESC = {
    {
        title="看牌",
        desc="在無人下注的情況下選擇把決定“讓”給下一位。",
        type = 1
    },
    {
        title="棄牌",
        desc="放棄繼續牌局的機會。",
        type = 1
    },
    {
        title="跟注",
        desc="跟隨眾人押上同等的注額",
        type = 1
    },
    {
        title="加注",
        desc="把現有的注金抬高",
        type = 1
    },
    {
        title="全下",
        desc="一次把手上的籌碼全部押上。",
        type = 1
    },
    {
        title="看或棄牌",
        desc="首先看牌，如果需要下注則選擇棄牌",
        type = 2
    },
    {
        title="棄牌",
        desc="自動棄牌",
        type = 2
    },
    {
        title="跟任何注",
        desc="欄位選擇跟任何注",
        type = 2
    },
}

L.HELP.PLAY_DATA_DESC = {
    {
        title="入池率/入局率",
        desc="VPIP（通常縮寫為VP）是玩家主動向底池中投入籌碼的比率。"
    },
    {
        title="翻牌前加注率",
        desc="PFR即翻牌前加注，指的是一個玩家翻牌前加注的比率。"
    },
    {
        title="激進度",
        desc="AF即是用來衡量一個玩家打牌激進程度的數值。"
    },
    {
        title="再次加注率",
        desc="即在他人下注，有人加注之後的再加注，由於是一輪下注中的第三次加注，故稱3bet。"
    },
    {
        title="偷盲率",
        desc="Stealing Blinds即偷盲,是指一個玩家單純的為了贏得盲注而加注。"
    },
    {
        title="持續下注率",
        desc="Cbet即持續下注，是指一個玩家在前一輪主動下注或加注後，在當前這一輪再次主動下注。"
    },
    {
        title="攤牌率",
        desc="WTSD即攤牌率，是指一個玩家看到翻牌圈並玩到攤牌的百分比。"
    },
    {
        title="百手盈利率",
        desc="BB/100（百手盈利率）：BB是Big Blind（大盲注）的簡稱，BB/100用以衡量玩家每玩100手牌局的盈虧。"
    },
}

L.HELP.PLAYER_TYPE_DESC = {
    {
        title="跟注站",
        desc="只會被動的跟注"
    },
    {
        title="瘋子",
        desc="瘋狂的玩家，熱衷於詐唬，非常激進"
    },
    {
        title="緊凶型（鯊魚）",
        desc="玩的很緊且具有一定的攻擊性。"
    },
    {
        title="緊弱型（老鼠）",
        desc="玩的很緊，較膽小，容易被詐唬嚇跑的玩家"
    },
    {
        title="岩石型",
        desc="非常緊且被動。你不會在這種對手身上得到太多行動"
    },
    {
        title="黃色警報",
        desc="玩太多牌，而且容易高估自己的牌力。"
    },
    {
        title="松弱魚",
        desc="玩太多牌，而翻牌後打法又很被動"
    },
}

--UPDATE
L.UPDATE.TITLE = "發現新版本"
L.UPDATE.DO_LATER = "以後再說"
L.UPDATE.UPDATE_NOW = "立即升級"
L.UPDATE.HAD_UPDATED = "你已經安裝了最新版本"

--ABOUT
L.ABOUT.TITLE = "關於"
L.ABOUT.UID = "當前玩家ID: {1}"
L.ABOUT.VERSION = "版本號: V{1}" 
L.ABOUT.FANS = "官方粉絲頁:\n" .. appconfig.FANS_URL
L.ABOUT.SERVICE = "服務條款與隱私權原則"
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "任務"
L.DAILY_TASK.SIGN = "簽到"
L.DAILY_TASK.GO_TO = "去完成"
L.DAILY_TASK.GET_REWARD = "領取獎勵"
L.DAILY_TASK.HAD_FINISH = "已完成"
L.DAILY_TASK.TAB_TEXT = {
    "任務",
    "成就"
}

-- count down box
L.COUNTDOWNBOX.TITLE = "倒計時寶箱"
L.COUNTDOWNBOX.SITDOWN = "坐下才可以繼續計時。"
L.COUNTDOWNBOX.FINISHED = "你今天的寶箱已經全部領取，明天還有哦。"
L.COUNTDOWNBOX.NEEDTIME = "再玩{1}分{2}秒，你將獲得{3}。"
L.COUNTDOWNBOX.REWARD = "恭喜你獲得寶箱獎勵{1}"
L.COUNTDOWNBOX.TIPS = "成功邀請好友進遊戲\n可以得到翻倍獎勵"

-- act
L.NEWESTACT.NO_ACT = "暫無活動"
L.NEWESTACT.LOADING = "請你稍安勿躁,圖片正在載入中..."
L.NEWESTACT.TITLE = "活動"
L.NEWESTACT.PLAY_CARD_TIME = "活動時間:{1}"
L.NEWESTACT.PLAY_CARD_TITLE = "玩越多 送越多"
L.NEWESTACT.PLAY_CARD_TIPS_1 = "你還差{1}局,就可以領取{2}籌碼,確認站起嗎?"
L.NEWESTACT.PLAY_CARD_TIPS_2 = "你還差{1}局,就可以領取{2}籌碼,確認要離開嗎?"
L.NEWESTACT.PLAY_CARD_LIST_TITLE = {
    "盲注",
    "時間",
    "局數",
    "獎勵"
}
L.NEWESTACT.PAY_TIPS = "活動結束後，系統會把獎勵直接發送到您的信息欄"
L.NEWESTACT.PAY_COUNT = "已充值"
L.NEWESTACT.PAY_TIPS_1 = "充值總金額滿"
L.NEWESTACT.PAY_TIPS_2 = "，可獲贈"
L.NEWESTACT.HOLIDAY_TAB_TEXT = {
    "領取處",
    "兌換處"
}
L.NEWESTACT.HOLIDAY_REWARD_LIMIT = "可兌換{1}/{2}次"
L.NEWESTACT.HOLIDAY_NO_LIMIT = "無限制"
L.NEWESTACT.HOLIDAY_SHAKE_TAB_TEXT = {
    "送籌碼",
    "搖一搖"
}
L.NEWESTACT.HOLIDAY_SHAKE_TIPS = "{1} 顆心 = {2} 次"
L.NEWESTACT.HOLIDAY_SHAKE_PLAY_TIPS = "活動期間每天可以免費搖一次"
L.NEWESTACT.HOLIDAY_SHAKE_TIMES = "搖一搖{1}次"
L.NEWESTACT.HOLIDAY_SHAKE_BTN = "摇一摇"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_BTN = "贈送"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TITLE = {
    "排名",
    "牛郎",
    "贈送籌碼",
    "織女"
}
L.NEWESTACT.HOLIDAY_SHAKE_RANKING = "排行榜"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TIPS = "今日贈送籌碼排行,明天重新排行"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_RECORD = "贈送記錄"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FRIEND = "好友列表"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_1 = "織女ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_2 = "贈送籌碼"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_1 = "選擇好友或者輸入ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_2 = "最低贈送{1}"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_3 = "請輸入贈送的玩家ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_4 = "請輸入贈送的籌碼數量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_5 = "不能給自己贈送籌碼"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_6 = "贈送籌碼不能超過身上攜帶的數量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_7 = "你攜帶的籌碼不足{1}"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_1 = "贈送失敗,請重試"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_2 = "玩家ID無效,請重新贈送"

--feed
L.FEED.SHARE_SUCCESS = "分享成功"
L.FEED.SHARE_FAILED = "分享失敗"
L.FEED.NO_CLIENT_TIPS = "你沒有安裝{1}應用,請使用其他方式邀請"
L.FEED.COPY_TIPS = "分享內容已複製,你可以直接粘貼到其他應用發送給好友"
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
    name = "我在開源德州撲克的幸運轉轉轉獲得了{1}的獎勵，快來和我一起玩吧！",
    caption = "開心轉轉轉100%中獎",
    link = L.FEED.SHARE_LINK .. "&feed=1",
    picture = appconfig.FEED_PIC_URL.."1.jpg",
    message = "",
}
L.FEED.WHEEL_ACT = {
    name = "快來和我一起玩開心轉轉轉吧，每天登錄就有三次機會！",
    caption = "開心轉轉轉100%中獎", 
    link = L.FEED.SHARE_LINK .. "&feed=2",
    picture = appconfig.FEED_PIC_URL.."2.jpg",
    message = "",
}
L.FEED.LOGIN_REWARD = {
    name = "太棒了!我在開源德州撲克領取了{1}籌碼的獎勵，快來和我一起玩吧！",
    caption = "登錄獎勵天天送不停",
    link = L.FEED.SHARE_LINK .. "&feed=3",
    picture = appconfig.FEED_PIC_URL.."3.jpg",
    message = "",
}
L.FEED.INVITE_FRIEND = {
    name = "開源德州撲克，最新最火爆的德撲遊戲，小夥伴們都在玩，快來加入我們一起玩吧！",
    caption = "聰明人的遊戲-開源德州撲克",
    link = L.FEED.SHARE_LINK .. "&feed=4",
    picture = appconfig.FEED_PIC_URL.."4.jpg",
    message = "",
}
L.FEED.EXCHANGE_CODE = {
    name = "我用開源德州撲克粉絲頁的兌換碼換到了{1}的獎勵，快來和我一起玩吧！",
    caption = "粉絲獎勵兌換有禮",
    link = L.FEED.SHARE_LINK .. "&feed=5",
    picture = appconfig.FEED_PIC_URL.."5.jpg",
    message = "",
}
L.FEED.COUNT = {
    name = "太強了！我在開源德州撲克贏得了{1}的籌碼，忍不住炫耀一下！",
    caption = "贏了好多啊",
    link = L.FEED.SHARE_LINK .. "&feed=6",
    picture = appconfig.FEED_PIC_URL.."6.jpg",
    message = "",
}
L.FEED.ACTIVE = {
    name = "太棒了，趕緊和我一起加入開源德州撲克吧，精彩活動天天有！",
    caption = "{1}活動",
    link = L.FEED.SHARE_LINK .. "&feed=7",
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.ACTIVE_DONE = {
    name = "我在開源德州撲克中獲得了{1}的獎勵，趕快來加入一起玩吧！ ",
    caption = "{1}活動",
    link = L.FEED.SHARE_LINK .. "&feed=8",
    picture = appconfig.FEED_PIC_URL.."8.jpg",
    message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
    name = "我在開源德州撲克完成了{1}的成就，獲得了{2}的獎勵，快來和我一起玩吧！ ",
    caption = "{1}",
    link = L.FEED.SHARE_LINK .. "&feed=9",
    picture = appconfig.FEED_PIC_URL.."9.jpg",
    message = "",
}
L.FEED.UPGRADE_REWARD = {
    name = "太棒了，我剛剛在開源德州撲克成功升到了{1}級，領取了{2}的獎勵，快來膜拜吧！",
    caption = "升級領取大禮",
    link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
    picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
    message = "",
}
L.FEED.MATCH_COMPLETE = {
    name = "我在開源德州撲克{1}中獲得第{2}名，趕快來一起玩吧！",
    caption = "一起來比賽！",
    link = L.FEED.SHARE_LINK .. "&feed=11",
    picture = appconfig.FEED_PIC_URL.."11.jpg",
    message = "",
}
L.FEED.RANK_REWARD = {
    name = "太棒了!我昨天在開源德州撲克裡贏得了{1}籌碼，快來和我一起玩吧!",
    caption = "又贏錢了！",
    link = L.FEED.SHARE_LINK .. "&feed=12",
    picture = appconfig.FEED_PIC_URL.."12.jpg",
    message = "",
}
L.FEED.BIG_POKER = {
    name = "手氣真好!我在開源德州撲克拿到{1}，聰明人的遊戲，快來加入一起玩吧！",
    caption = "{1}",--牌型
    link = L.FEED.SHARE_LINK .. "&feed=13",
    picture = appconfig.FEED_PIC_URL.."13.jpg",
    message = "",
}
L.FEED.PRIVATE_ROOM = {
    name = "我在開源德州撲克開好私人房等你來戰，房間號{1}，密碼{2}，點擊立即加入！",
    caption = "開房打牌了",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
    name = "我在開源德州撲克開好私人房等你來戰，房間號:{1}，點擊立即加入！",
    caption = "開房打牌了",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name = "我在{1}房間{2}打牌,速速來戰！",
    caption = "打牌啦",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE = {
    name = "發現一個目前最好玩的德州撲克遊戲，推薦你和我一起玩，下載遊戲輸入我的邀請碼{1}就有特別大獎領取.",
    caption = "",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE_REWARD = {
    name = "太感謝好友{1}！我在開源德州獲得了{2}籌碼的邀請禮包，快來加入我們一起玩吧",
    caption = "開源德州撲克-免費的邀請大禮包",
    link = L.FEED.SHARE_LINK .. "&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}

-- message
L.MESSAGE.TITLE = "消息"
L.MESSAGE.TAB_TEXT = {
    "好友消息", 
    "系統消息"
}
L.MESSAGE.EMPTY_PROMPT = "你現在沒有消息記錄"
L.MESSAGE.SEND_CHIP = "回贈"
L.MESSAGE.ONE_KEY_GET = "一鍵領取"
L.MESSAGE.ONE_KEY_GET_AND_SEND = "一鍵領取並回贈"
L.MESSAGE.GET_REWARD_TIPS = "恭喜你獲得了{1},成功給好友贈送了{2}"

--獎勵兌換碼
L.ECODE.TITLE = {
    "邀請碼",
    "獎勵兌換"
}
L.ECODE.EDITDEFAULT = "請輸入6-8位兌換碼或邀請碼"
L.ECODE.FANS_DESC = "關注粉絲頁可免費領取獎勵兌換碼,我們還會不定期在官方粉絲頁推出各種精彩活動,謝謝關注。"
L.ECODE.FANS = "粉絲頁地址"
L.ECODE.EXCHANGE = "兌  獎"
L.ECODE.ERROR_FAILED = "兌換碼輸入錯誤，請重新輸入！"
L.ECODE.ERROR_INVALID="兌獎失敗，你的兌換碼已經失效。"
L.ECODE.ERROR_USED = "兌獎失敗，每個兌換碼只能兌換一次。"
L.ECODE.ERROR_END= "領取失敗，本次獎勵已經全部領光了，關注我們下次早點來哦"
L.ECODE.FAILED_TIPS = "兌獎失敗，請重試！"
L.ECODE.NO_INPUT_SELF_CODE = "你不能輸入自己的邀請碼,請確認後重新輸入"
L.ECODE.MAX_REWARD_TIPS = "最大獲取 "
L.ECODE.INVITE_REWARD_TIPS = [[
1.把發送你的邀請碼給你的好友
2.通知好友在註冊遊戲三天內輸入你的邀請碼，超過三天無效
3.好友輸入後好友可獲得{2}新人大禮包,同時你可獲得{1}籌碼的邀請獎勵;如果好友再邀請他的好友註冊，每邀請一位，你也可獲得{3}籌碼的獎勵
]]
L.ECODE.INVITE_REWARD_RECORD = "你已邀請了{1}位好友,獲得了{2}籌碼的邀請獎勵"
L.ECODE.MY_CODE = "我的邀請碼"
L.ECODE.COPY_CODE = "點擊複製"
L.ECODE.INVITE_REWARD_TIPS_1 = "太棒了,領取成功"
L.ECODE.INVITE_REWARD_TIPS_2 = "你獲得了{1}籌碼的好友邀請獎勵\n你的好友{2},也獲得了{3}的邀請獎勵"
L.ECODE.INVITE_BTN_NAME = "我也要去邀請"
L.ECODE.INVITE_TIPS = "你可以點擊按鈕通過以下方式發送邀請碼"
L.ECODE.INVITE_TITLES = {
    "关注粉丝页获取兑换码",
    "发送我的邀请码获取邀请奖励"
}

--大轉盤
L.LUCKTURN.RULE_TEXT = [[
1.每{1}個小時還可以免費轉一次
2.你也可以花費1顆鑽石轉一次
3.100%中獎,天天大量免費籌碼等你拿
]]
L.LUCKTURN.COST_DIAMOND = "花費1個顆鑽石"
L.LUCKTURN.BUY_DIAMOND = "購買鑽石"
L.LUCKTURN.COUNTDOWN_TIPS = "你今天的免費次數已用完\n你可以等待{1}再來\n你也可以花費一顆鑽石轉一次"
L.LUCKTURN.LOTTERY_FAILED = "抽獎失敗，請檢查網路連接斷開後重試"
L.LUCKTURN.CHIP_REWARD_TIPS = "{1}中了:籌碼{2}"
L.LUCKTURN.PROPS_REWARD_TIPS = "{1}中了:道具{2}"
L.LUCKTURN.VIP_REWARD = "{1}天{2}VIP特權"

--老虎機
L.SLOT.NOT_ENOUGH_MONEY = "老虎機購買失敗,你的籌碼不足"
L.SLOT.NOT_ENOUGH_MIN_MONEY = "你的總籌碼數不足5000，暫時無法下注老虎機，請充值後重試。"
L.SLOT.BUY_FAILED = "老虎機購買失敗，請重試"
L.SLOT.PLAY_WIN = "你贏得了{1}籌碼"
L.SLOT.TOP_PRIZE = "玩家 {1} 玩老虎機抽中大獎，獲得籌碼{2}"
L.SLOT.FLASH_TIP = "頭獎：{1}"
L.SLOT.FLASH_WIN = "你贏了：{1}"
L.SLOT.AUTO = "自動"
L.SLOT.HELP_TIPS = "獎金=下注籌碼*回報率\n下注越多,獎勵越高.最高{1}"

--GIFT
L.GIFT.TITLE = "禮物"
L.GIFT.SET_SELF_BUTTON_LABEL = "設為我的禮物"
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "買給牌桌x{1}"
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "你當前選擇的禮物"
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "贈送"
L.GIFT.DATA_LABEL = "天"
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "請選擇禮物"
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "購買禮物成功"
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "購買禮物失敗"
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "設置禮物成功"
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "設置禮物失敗"
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "贈送禮物成功"
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "贈送禮物失敗"
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "贈送牌桌禮物成功"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "贈送牌桌禮物失敗"
L.GIFT.NO_GIFT_TIP = "暫時沒有禮物"
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "點擊選中既可在牌桌上展示才禮物"
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "你的場外籌碼不足,贈送禮物失敗"
L.GIFT.BUY_GIFT_FAIL_TIPS = "你的場外籌碼不足,購買禮物失敗"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "你的場外籌碼不足,贈送牌桌禮物失敗"
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
    "精品", 
    "食物",
    "跑車",
    "鮮花"
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
    "自己購買", 
    "牌友贈送",
    "特別贈送"
}

L.GIFT.MAIN_TAB_TEXT = {
    "商城禮物", 
    "VIP禮物", 
    "我的禮物"
}

-- 破產
L.CRASH.PROMPT_LABEL = "你獲得了{1}籌碼的破產救濟金，同時獲得限時破產優惠充值一次，你也可以立即邀請好友獲取免費籌碼。"
L.CRASH.THIRD_TIME_LABEL = "你獲得最後一次{1}籌碼的破產救濟金，同時獲得當日限時充值優惠一次，你也可以立即邀請好友獲取免費籌碼。"
L.CRASH.OTHER_TIME_LABEL = "你已經領完所有破產救濟金了，輸贏只是轉瞬的事，限時特惠機會難得，立即充值重振雄風！"
L.CRASH.TITLE = "你破產了！" 
L.CRASH.REWARD_TIPS = "破產沒有關係，還有救濟金可以領取"
L.CRASH.CHIPS = "{1}籌碼"
L.CRASH.GET = "領取"
L.CRASH.GET_REWARD = "獲得{1}籌碼"
L.CRASH.GET_REWARD_FAIL = "領取籌碼失敗"
L.CRASH.RE_SIT_DOWN = "重新坐下"
L.CRASH.PROMPT_LABEL_1 = "不要灰心，系統為你準備了{1}籌碼的破產救濟"
L.CRASH.PROMPT_LABEL_2 = "同時你還獲得當日充值優惠一次立即充值重振雄風"
L.CRASH.PROMPT_LABEL_3 = "你也可以邀請好友或者明天再來領取大量免費籌碼"
L.CRASH.PROMPT_LABEL_4 = "我們贈送你當日限時充值優惠大禮包一次，機不可失"
L.CRASH.PROMPT_LABEL_5 = "你已經領完了所有的破產禮包 輸贏乃兵家常事，不要灰心"

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "簡訊已發送成功,正在充值 請稍等."
L.E2P_TIPS.NOT_SUPPORT = "你的手機暫時無法完成easy2pay充值,請選擇其他管道充值"
L.E2P_TIPS.NOT_OPERATORCODE = "easy2pay暫時不支持你的手機運營商,請選擇其他管道充值"
L.E2P_TIPS.SMS_SENT_FAIL = "簡訊發送失敗,請檢查你的手機餘額是否足額扣取"
L.E2P_TIPS.SMS_TEXT_EMPTY = "簡訊內容為空,請選擇其他渠道充值並聯繫官方"
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "沒有發送目標,請選擇其他管道充值並聯繫官方"
L.E2P_TIPS.SMS_NOSIM = "沒有SIM卡,無法使用easy2pay管道充值,請選擇其他管道充值"
L.E2P_TIPS.SMS_NO_PRICEPOINT = "沒有發送目標,請選擇其他管道充值並聯繫官方"
L.E2P_TIPS.PURCHASE_TIPS = "你將要購買{1}，共花費{2}（不含7%增值稅），將會從你的話費裡扣除"
L.E2P_TIPS.BANK_PURCHASE_TIPS = "你將要購買{1}，共花費{2}（不含7%增值稅），將會從你的銀行卡裡扣除"

-- 比賽場
L.MATCH.MONEY = "籌碼"
L.MATCH.JOINMATCHTIPS = "你報名參賽的比賽已經開始準備，是否現在進入房間進行比賽"
L.MATCH.JOIN_MATCH_FAIL = "加入比賽失敗，請參加其他比賽吧！"
L.MATCH.MATCH_END_TIPS = "當前比賽已經結束，請參加其他比賽吧！"
L.MATCH.MATCHTIPSCANCEL = "不再提示"
L.MATCH.CHANGING_ROOM_MSG = "正在等待其他桌子結束"
L.MATCH.MATCH_NAME = "比賽名稱"
L.MATCH.MATCH_REWARD = "獎勵內容"
L.MATCH.MATCH_PLAYER = "參賽人數"
L.MATCH.MATCH_COST = "報名費+服務費"
L.MATCH.REGISTER = "報名"
L.MATCH.REGISTERING = "正在報名"
L.MATCH.REGISTERING_2 = "正在\n報名"
L.MATCH.UNREGISTER = "取消\n報名"
L.MATCH.UNREGISTER_2 = "取消報名"
L.MATCH.RANKING = "你的排名"
L.MATCH.REGISTER_COST = "參數費:"
L.MATCH.SERVER_COST = "服務費:"
L.MATCH.TOTAL_MONEY = "你的總資產:"
L.MATCH.MATCH_INFO = "本場賽況"
L.MATCH.START_CHIPS = "初始籌碼:"
L.MATCH.START_BLIND = "初始盲注:{1}/{2}"
L.MATCH.MATCH_TIME = "參賽時間:{1}"
L.MATCH.RANKING_TITLE = "名次"
L.MATCH.REWARD_TITLE = "獎勵"
L.MATCH.LEVEL_TITLE = "級別"
L.MATCH.BLIND_TITLE = "盲注"
L.MATCH.PRE_BLIND_TITLE = "前注"
L.MATCH.ADD_BLIND_TITLE = "漲盲時間"
L.MATCH.RANKING_INFO = "當前排名第{1}名"
L.MATCH.SNG_HELP_TITLE = "SNG比賽規則"
L.MATCH.MTT_HELP_TITLE = "MTT比賽規則"
L.MATCH.SNG_RANKING_INFO = "均籌: {1}"
L.MATCH.MTT_RANKING_INFO = "{1}/{2} 均籌: {3}"
L.MATCH.ADD_BLIND_TIME = "漲盲時間: {1}"
L.MATCH.WAIT_MATCH = "等待開賽"
L.MATCH.ADD_BLIND_TIPS_1 = "將在下一局漲盲"
L.MATCH.ADD_BLIND_TIPS_2 = "下一局將升盲至{1}/{2}"
L.MATCH.BACK_HALL = "返回大廳"
L.MATCH.PLAY_AGAIN = "再來一局"
L.MATCH.LEFT_LOOK = "留下旁觀"
L.MATCH.CLOSE = "關閉"
L.MATCH.REWARD_TIPS = "你獲得了{1}的獎勵\n{2}"
L.MATCH.REWARD_PLAYER = "獎勵人數"
L.MATCH.MATCH_CUR_TIME = "比賽用時"
L.MATCH.CUR_LEVEL_TITLE = "當前級別:{1}/{2}"
L.MATCH.NEXT_LEVEL_TITLE = "下一級別"
L.MATCH.AVERAGE_CHIPS_TITLE = "平均籌碼"
L.MATCH.FORMAT_BLIND = "{1}/{2}"
L.MATCH.EXPECT_TIPS = "敬請期待"
L.MATCH.NOT_ENOUGH_MONEY = "你的籌碼不足報名，請去商城補充籌碼後重試"
L.MATCH.PLAYER_NUM_TIPS = "等待開賽中，還差{1}人"
L.MATCH.PLAYER_NUM_TIPS_1 = "等待開賽中，還差 "
L.MATCH.PLAYER_NUM_TIPS_2 = " 人"
L.MATCH.MAINTAIN = "當前比賽正在維護"
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
    "你太棒了！立即分享炫耀下吧!",
    "沒想到你這麼強！呼朋喚友告訴小夥伴們吧！",
    "太牛了，再來一局吧！",
}
L.MATCH.NO_REWARD_TEXT = {
    "再接再厲，繼續加油！",
    "失敗是成功之母，繼續努力！",
    "就差一點點，下次多點耐心！",
}
L.MATCH.SNG_RULE = {
    {
        title = "什麼是SNG-坐滿即玩?",
        content = "SNG全稱Sit and Go，中文指坐滿即玩，坐滿即玩是德州撲克的一種單桌比賽玩法。在SNG中，每場玩家會獲得用來計數的籌碼，這個籌碼與金幣無關，只用於本場計數。"
    },
    {
        title = "SNG比賽規則:",
        content = [[
1.報名人數滿9人(或6人)立即開賽
2.每場比賽玩家會獲得用來計數的籌碼(本籌碼不等於金幣),該籌碼只 用於本場比賽的計數
3.坐滿即玩中途不能增加籌碼，籌碼輸完後則退出比賽
4.按照玩家退出比賽順序取名次，第一個籌碼輸完的玩家即是最後一名， 依此類推
5.當牌局裡只剩下最後_名玩家時比賽結束，最後一名玩家即是冠軍
6.為提高比賽激烈程度，坐滿即玩比賽過程中盲注會逐步提升
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title = "什麼是MTT-多桌錦標賽?",
        content = "MTT是Multi-Table Tournament的縮寫，中文全稱為多桌錦標賽，指的是在多張桌上參賽玩家以同樣的籌碼量開始比賽。在多桌錦標賽中，桌子會隨著選手的不斷淘汰進行合併。最終，錦標賽會減少到一張桌子而進行決賽。"
    },
    {
        title = "MTT比賽規則:",
        content = [[
1.固定時間開始比賽，當參賽人數小於最低開賽人數時，比賽將被取消
2.每場比賽玩家會獲得用來計數的籌碼只用於本場比賽的計數
3.前注：比賽進行過程中，每局開始前強制每位玩家自動下注若干籌碼，即為前注
4.重買籌碼：在配置了可重買的比賽開始後的某個盲注級別前，當玩家手裡籌碼s初始 籌碼時，玩家可點擊重購籌碼按鈕花費報名費再次買入初始的籌碼值，不同的比賽可重 買的次數不定，當玩家手裡籌碼為0即將被淘汰出比賽時，也可通過重買復活
5.増購籌碼：在配置了可増購的比賽的某個盲注級別時間段內，玩家可點擊增購籌碼按鈕花費報名費再次買入若干籌碼值，不同的比賽可增購的次數不定，當玩家手裡籌碼為0 即將被淘汰出比賽時，也可通過增購復活
6.按照玩家退出比賽順序取名次，第一個籌碼輸完的玩家即是最後一名，依此類推，如果有2位以上參賽者於同一局牌被淘汰，則將依次按照牌力、開始時籌碼定位名次，牌力大者排名在前，開始時籌碼多者排名在前
7.當比賽裡只剩下最後一名玩家時比賽結束，最後一名玩家即是冠軍
8.為提高比賽激烈程度，錦標賽比賽過程中盲注會逐步提升
]]
    }
}
L.MATCH.TAB_TEXT= {
    "概述",
    "排名",
    "盲注",
    "獎勵",
}
L.MATCH.ROOM_TAB_TEXT_1= {
    "概述",
    "賽況",
    "排名",
    "盲注",
    "獎勵",
}
L.MATCH.ROOM_TAB_TEXT_2= {
    "賽況",
    "排名",
    "盲注",
    "獎勵",
}

-- 輸贏統計
L.WINORLOSE.TITLE = "太棒了"
L.WINORLOSE.YING = "你贏了"
L.WINORLOSE.CHOUMA = "{1}籌碼"
L.WINORLOSE.INFO_1 = "局數:{1}"
L.WINORLOSE.INFO_2 = "單局最大贏得:{1}"
L.WINORLOSE.RATE5 = "喜歡我們的遊戲給5星好評，你的鼓勵是我們持續優化的最大動力"
L.WINORLOSE.NOW = "立即支持"
L.WINORLOSE.LATER = "以後再說"
L.WINORLOSE.SHARE = "分享"
L.WINORLOSE.CONTINUE = "繼續遊戲"

-- 私人房
L.PRIVTE.ROOM_NAME = "私人房"
L.PRIVTE.FINDTITLE = "查找房間"
L.PRIVTE.CREATTITLE = "創建房間"
L.PRIVTE.INPUTROOMIDTIPS = "請輸入房間號"
L.PRIVTE.ENTERROOM = "立即進入"
L.PRIVTE.TYPETIPS = "下注思考時間:\n普通場{1}秒\n快速場{2}秒"
L.PRIVTE.CREATEROOM = "立即開始"
L.PRIVTE.CREATFREE = "限免開局"
L.PRIVTE.INPUTPWDTIPS = "請輸入房間密碼，留空即無密碼"
L.PRIVTE.TIMEHOUR = "{1}小時"
L.PRIVTE.PWDPOPTIPS = "請輸入有效密碼"
L.PRIVTE.PWDPOPTITLE = "請輸入密碼"
L.PRIVTE.PWDPOPINPUT = "請輸入密碼"
L.PRIVTE.NOTIMETIPS = "當前房間所剩時間{1}秒，即將解散，請重新創建！"
L.PRIVTE.TIMEEND = "當前房間時間已用完解散，請返回大廳重新創建！"
L.PRIVTE.ENTERBYID = "輸入房間號進入"
L.PRIVTE.OWNER = "房主"
L.PRIVTE.ROOMID = "房間號:{1}"
L.PRIVTE.LEFTDAY = "{1}天"
L.PRIVTE.LEFTHOUR = "{1}小時"
L.PRIVTE.LEFTMIN = "{1}分鐘"
L.PRIVTE.ENTERLOOK = "圍觀"
L.PRIVTE.ENTERPLAY = "坐下"
L.PRIVTE.ENTEREND = "已結束"
L.PRIVTE.ENTERENDTIPS = "當前房間已解散，請進入其他房間！"
L.PRIVTE.ENTERCHECK = "你要加入此房間麼?"
L.PRIVTE.CHECKCREATE = "暫無房間，創建新房間"
L.PRIVTE.ROOMMAXTIPS = "你創建的私人房已經達到上限！"

--活動
L.ACT.CHRISTMAS_HITRATE = "準確率{1}  最多連擊{2}"
L.ACT.CHRISTMAS_HITWIN = "手速超快, 你在本活動中擊敗{1}的人"
L.ACT.CHRISTMAS_FEED = {
    name = "我以超快手速獲得了{1}籌碼，擊敗了{2}的人，敢來和我拼手速嗎？",
    caption = "點禮物得籌碼100%中獎",
    link = L.FEED.SHARE_LINK .. "&feed=14",
    picture = appconfig.FEED_PIC_URL.."14.jpg",
    message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "耶誕節快樂，搖晃手機點禮物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "新年快樂，搖晃手機點禮物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "禮物即將降落，準備好點擊了嗎？"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "明天再來吧"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 = "春節快樂，搖晃手機點禮物"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_6 = "七夕快樂，搖一搖，點擊禮物有大驚喜哦。"

--紅黑大戰
L.REDBLACK.BET_DOUBLE = "加倍"
L.REDBLACK.BET_LAST = "重複上局"
L.REDBLACK.SELECTED_BET_TIPS = "請選擇幸運區域"
L.REDBLACK.SELECTED_BET_END_TIPS = "選擇完畢"
L.REDBLACK.START_GAME_TIPS = "遊戲即將開始({1})"
L.REDBLACK.BET_FAILD = "你的遊戲幣不足,下注失敗"
L.REDBLACK.BET_FAILD_2 = "你的遊戲幣不足當前所選的下注額度{1}，已經自動切換到{2}"
L.REDBLACK.BET_FAILD_TIMES_OUT = "下注時間已到,下注失敗"
L.REDBLACK.BET_LIMIT_TIPS = "下注失败，当局下注不能超过{1}"
L.REDBLACK.ALL_PLAYER = "當前房間共有 {1} 人"
L.REDBLACK.RECENT_TREND = "近期走勢:"
L.REDBLACK.TODAY_COUNT = "今日統計:"
L.REDBLACK.WIN_LOSE = "勝 負"
L.REDBLACK.HAND_CARD = "手 牌"
L.REDBLACK.WIN_CARD_TYPE = "獲勝牌型"
L.REDBLACK.COUNT_TIPS_1 = "金象勝利:{1}"
L.REDBLACK.COUNT_TIPS_2 = "銀象勝利:{1}"
L.REDBLACK.COUNT_TIPS_3 = "平局:{1}"
L.REDBLACK.COUNT_TIPS_4 = "同花連牌:{1}"
L.REDBLACK.COUNT_TIPS_5 = "對A:{1}"
L.REDBLACK.COUNT_TIPS_6 = "葫蘆:{1}"
L.REDBLACK.COUNT_TIPS_7 = "金剛/皇家/同花順:{1}"
L.REDBLACK.SUB_TAB_TEXT = {
    "勝負走勢",
    "遊戲規則"
}
L.REDBLACK.RULE = [[
選擇你支持的選手，贏得更多獎勵吧!


基本規則：
1.每局比賽將給金象和銀象各發一副手牌，再發5張公共牌，並亮出其中一張。

2.玩家可根據公開的資訊支援任何陣營和區域。

3.公共牌和手牌亮出，根據結果，按區域內倍數獎勵支援的玩家。


每日投入有上限。設計合理的策略支持喜愛的選手吧！
]]

--新手引導
L.TUTORIAL.SETTING_TITLE = "新手教學"
L.TUTORIAL.FIRST_IN_TIPS = [[
歡迎來到開源德州撲克
下面將由小愛教你來玩這款風靡全球的棋牌遊戲，如果你已經了解德撲的基本玩法，可以點擊跳過引導，直接進入遊戲；如果沒有的話，點擊開始教學，讓我們一起來學習吧！

首次完成教程還可以領取8000籌碼獎勵哦!
]]
L.TUTORIAL.FIRST_IN_BTN1 = "跳過引導"
L.TUTORIAL.FIRST_IN_BTN2 = "開始教學"
L.TUTORIAL.END_AWARD_TIPS = "完成教程領取籌碼"
L.TUTORIAL.FINISH_AWARD_TIPS = "恭喜你獲得了{1}籌碼的新手教學禮包，現在你可以選擇重新學習或者快速開始"
L.TUTORIAL.FINISH_NOAWARD_TIPS = "你已經是德州撲克高手啦，現在你可以選擇重新學習或者快速開始"
L.TUTORIAL.FINISH_FIRST_BTN = "重新學習"
L.TUTORIAL.FINISH_SECOND_BTN = "快速開始"
L.TUTORIAL.SKIP = "跳 過"
L.TUTORIAL.NEXT_STEP = "下一步"
L.TUTORIAL.GUESS_TRUE_13 = "答對了,你現在有一對A，挺大的\n\n點擊任意位置進入下一輪下注"
L.TUTORIAL.GUESS_TRUE_22 = "答對了,你現在有兩對(1對A和1對9)\n\n點擊任意位置進入下一輪下注"
L.TUTORIAL.GUESS_TRUE_27 = "答對了,你現在是葫蘆(3條9和1對A)\n\n點擊任意位置進入下一輪下注"
L.TUTORIAL.GUESS_FLASE = "錯啦，再仔細想想..."
L.TUTORIAL.RE_SELECT = "重選"
L.TUTORIAL.TIPS = {
    "退出菜單",
    "購買籌碼",
    "點擊查看他人資訊 贈送籌碼 使用互動道具",
    "公共牌",
    "滑出或者點擊打開老虎機",
    "我的頭像",
    "我的手牌",
    "操作按鈕",
    "點擊聊天 發送表情"
}
L.TUTORIAL.ROOM_STEP_1 = "歡迎來到開源德州撲克！首次完成教程可獲取{1}籌碼的獎勵哦，下面讓我們一起開始遊戲吧!\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_2 = "我是你們美女荷官，遊戲開始我會給每位玩家發放2張手牌，這2張手牌僅玩家自己可見。\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_3 = "之後會陸續發出5張公牌，這5張公牌所有玩家可見。\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_4 = "最後玩家的成牌是從公牌和手牌中選取5張組成的最大的牌型；牌型大小如左圖所示：皇家同花順-同花順-四條-葫蘆-同花-順子-三條-對子-高牌"
L.TUTORIAL.ROOM_STEP_5 = "當前你組成的最大牌型是皇家同花順(5張同花色順子10-J-Q-K-A), 光標閃爍處就是選中的最大牌組。\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_6 = "都掌握了嗎？\n下面我們正式開始一局吧！\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_7 = "此處是玩牌操作區域，輪到你操作時，可以根據自己的牌選擇相應操作。\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_8 = "現在輪到你了，你當前的牌還不錯! \n\n點擊按鈕選擇跟注"
L.TUTORIAL.ROOM_STEP_11= "其他两个玩家都选择了CALL，看来也没什么好牌，现在开始发前3张公牌。\n\n點擊任意位置進入下一步"
L.TUTORIAL.ROOM_STEP_13= "前3张公牌已经发完了，你组成了新的牌型，猜猜你现在的牌型是什么？"
L.TUTORIAL.ROOM_STEP_14= "又輪到你了，先想想下一步怎麼操作，其他玩家有可能是同花(梅花)，先選擇一把看牌。"
L.TUTORIAL.ROOM_STEP_16= "玩家{1}選擇了加注，加注一般有比較強的牌力，要小心，先靜觀其變吧！"
L.TUTORIAL.ROOM_STEP_18= "玩家{1}選擇了棄牌，棄牌就意味著這一局輸掉所有已經下注的籌碼，一般情況下牌力不夠的時候選擇棄牌比較明智。"
L.TUTORIAL.ROOM_STEP_19= "又輪到你了，當前牌力不錯（1對A)，可以CALL ，看第4張公牌。"
L.TUTORIAL.ROOM_STEP_22= "4張公牌已經發完了，你又組成了新的牌型，猜猜你現在的牌型是什麼？"
L.TUTORIAL.ROOM_STEP_23= "遊戲只剩2個玩家了，你現在有2對(1對A和1對9)，牌力不錯，可以加注{1}試試。"
L.TUTORIAL.ROOM_STEP_25= "{1}也選擇跟住，荷官將發出最後1張公牌。"
L.TUTORIAL.ROOM_STEP_27= "5張公牌都發完啦，你的最終牌型也確定了，你的最終牌型是什麼？"
L.TUTORIAL.ROOM_STEP_29= "{1}，ALL_IN了，預測牌力不小，但你葫蘆也很大，跟了!"
L.TUTORIAL.ROOM_STEP_32= "最後亮牌了，{1}是同花，你是葫蘆，你贏了(葫蘆>同花)！你獲得了底池所有的籌碼！"
L.TUTORIAL.ROOM_STEP_34= "這是遊戲的其他元素，需要你自己去探索啦！"

--保险箱
L.SAFE.TITLE = "保險箱"
L.SAFE.TAB_TEXT = {
    "遊戲幣",
    "鑽石"
}
L.SAFE.SAVE_MONEY = "存入"
L.SAFE.GET_MONEY = "取出"
L.SAFE.SET_PASSWORD = "設置密碼"
L.SAFE.CHANGE_PASSWORD = "修改密碼"
L.SAFE.MY_SAFE = "我的保險箱"
L.SAFE.MY_PURSE = "我的攜帶"
L.SAFE.SET_PASSWORD_TIPS_1 = "請輸入新密碼"
L.SAFE.SET_PASSWORD_TIPS_2 = "請再次新輸入密碼"
L.SAFE.SET_PASSWORD_TIPS_3 = "兩次輸入密碼不一致,請重新輸入"
L.SAFE.SET_PASSWORD_TIPS_4 = "密碼不能為空,請重新輸入!"
L.SAFE.SET_PASSWORD_TIPS_5 = "請輸入密碼,打開保險箱"
L.SAFE.FORGET_PASSWORD = "忘記密碼"
L.SAFE.VIP_TIPS_1 = "你還不是VIP用戶,暫時無法使用,是否立即成為VIP,還有超多優惠和特權."
L.SAFE.VIP_TIPS_2 = "你的VIP已經過期,暫時無法存入,是否立即成為VIP,還有超多優惠和特權."
L.SAFE.SET_PASSWORD_SUCCESS = "設置密碼成功!"
L.SAFE.SET_PASSWORD_FAILED = "設置密碼失敗,請重試!"
L.SAFE.CHANGE_PASSWORD_SUCCESS = "修改密碼成功!"
L.SAFE.CHANGE_PASSWORD_FAILED = "修改密碼失敗,請重試!"
L.SAFE.CHECK_PASSWORD_ERROR = "輸入的密碼錯誤,請重新輸入!"
L.SAFE.CHECK_PASSWORD_FAILED = "驗證密碼失敗,請重試!"
L.SAFE.SAVE_MONEY_FAILED = "存錢失敗,請重試!"
L.SAFE.GET_MONEY_FAILED = "取錢失敗,請重試!"
L.SAFE.INPUT_MONEY_TIPS = "請輸入大於0的數值,進行存取."
L.SAFE.SET_EMAIL = "設置安全郵箱"
L.SAFE.SET_EMAIL_BTN = "點擊設置"
L.SAFE.CHANGE_EMAIL_BTN = "修改郵箱"
L.SAFE.SET_EMAIL_TIPS_1 = "為了更好的保護你的財產,請綁定常用郵箱,以確保收到郵件.郵件可以用於重置密碼等操作.\n首次綁定還可以獎勵20K遊戲幣."
L.SAFE.SET_EMAIL_TIPS_2 = "你已經成功綁定郵箱!"
L.SAFE.SET_EMAIL_TIPS_3 = "電子郵箱,例如openpokerxxx@gmail.com"
L.SAFE.SET_EMAIL_TIPS_4 = "請輸入正確的郵箱格式!"
L.SAFE.SET_EMAIL_TIPS_5 = "你還沒有設定安全郵箱,設定後可通過郵箱找回密碼"
L.SAFE.SET_EMAIL_TIPS_6 = "你已經設定了安全郵箱:{1}"
L.SAFE.SET_EMAIL_SUCCESS = "綁定郵箱成功!"
L.SAFE.SET_EMAIL_TIPS_FAILED = "綁定郵箱失敗,請重試!"
L.SAFE.RESET_PASSWORD_TIPS_1 = "重置信息已提交,請立即登錄郵箱點選連結驗證."
L.SAFE.RESET_PASSWORD_TIPS_2 = "設定新的密碼,點擊確定,系統將發送驗證連結到你的安全郵箱,5分鐘內點擊連結啟動即可重置成功."
L.SAFE.RESET_PASSWORD_TIPS_3 = "對不起,由於你沒有綁定郵箱,所以無法此功能.請你聯繫客服."
L.SAFE.RESET_PASSWORD_TIPS_4 = "重置信息提交失败,请重试."
L.SAFE.RESET_PASSWORD = "重置密碼"
L.SAFE.CLEAN_PASSWORD = "清空密碼"
L.SAFE.CLEAN_PASSWORD_SUCCESS = "清空密碼成功!"
L.SAFE.CLEAN_PASSWORD_FAILED = "清空密碼失敗,請重試!"

--夺金岛
L.GOLDISLAND.TITLE = "奪金島"
L.GOLDISLAND.RULE_BTN = "詳細規則"
L.GOLDISLAND.BUY_BTN = "購買下局"
L.GOLDISLAND.ALREADY_BUY = "已購買"
L.GOLDISLAND.PRICE = "{1}籌碼/次"
L.GOLDISLAND.AUTO_BUY = "自動購買"
L.GOLDISLAND.BUY_SUCCESS = "買入下一局奪金島成功"
L.GOLDISLAND.BUY_FAILED = "你身上的籌碼不足以購買下一局的奪金島了"
L.GOLDISLAND.BUY_TIPS = "必須坐下,才能購買下一局的奪金島"
L.GOLDISLAND.RULE_TITLE = "奪金島規則說明"
L.GOLDISLAND.RULE_POOL = "獎池:"
L.GOLDISLAND.RULE_DESC = [[
1.盲注大於3000的場坐下才能才加奪金島,每局參賽費為2000籌碼(牌局開始時從帶入籌碼中扣除).該籌碼會進入奪金島獎池.

2.參加奪金島後,每局結束時持有特定牌型,即可從奪金島獎池中贏取大量籌碼!
皇家同花順:贏得80%獎池
同花順:贏得30%獎池
四條:贏得10%獎池

3.必須5張公共牌全部翻出後牌型才生效.玩家主動棄牌或者其他玩家全部棄牌導致牌局提前結束,則牌型無效;玩家必須堅持到比牌環節(不需要獲勝)才可贏得本局奪金島.

4.領獎:系統會自動把贏得的籌碼加入壓中玩家的賬戶.

5.參加:可以點擊奪金島圖標之後進入奪金島購買窗口,按要求買入奪金島.可以選擇自動買入或者購買1次.
]]
L.GOLDISLAND.REWARD_TITLE = "恭喜贏得奪金島"
L.GOLDISLAND.REWARD_BTN = "我知道了"
L.GOLDISLAND.CARD_TYPE = "你的牌型為:{1}"
L.GOLDISLAND.REWARD_NUM = "獲得奪金島{1}%的獎池:"
L.GOLDISLAND.REWARD_TIPS = "獎金已發送至你的個人賬戶中"
L.GOLDISLAND.BROADCAST_REWARD_TIPS = "恭喜玩家{1}在奪金島壓中{2}獲得{3}籌碼的獎金!"

--绑定账号
L.BIND.BTN_TITLE = "升級安全賬戶+{1}"
L.BIND.TITLE = "免費升級安全賬戶"
L.BIND.BTN_TITLE_2 = {
    "綁定Facebook賬號",
    "綁定Line賬號",
    "綁定VK賬號"
}
L.BIND.ACCOUNT = {
    "Facebook賬號",
    "Line賬號",
    "VK賬號"
}
L.BIND.SUCCESS_TITLE = "綁定成功"
L.BIND.FAILED_TITLE = "綁定失敗"
L.BIND.GET_REWARD = "立即領取"
L.BIND.GET_REWARD_FAILED = "領取獎勵失敗,請重試"
L.BIND.GET_REWARD_TIPS = "你已經成功將游客賬號綁定到{1}，以後你可以選擇任意方式登錄，並獲得{2}籌碼的安全賬號獎勵。"
L.BIND.FAILED_TIPS = "對不起，此賬號已註冊過遊戲\n你可以選擇其他賬號重新綁定或者直接登錄已存在的賬號"
L.BIND.FAILED_TIPS_2 = "賬號綁定失敗,請重試"
L.BIND.GOTO_LOGIN = "直接登錄"
L.BIND.RETRY = "重新綁定"
L.BIND.CANCELED = "取消綁定"

--支付引导
L.PAYGUIDE.FIRST_GOODS_DESC = {
    "送VIP",
    "送動態頭像",
}
L.PAYGUIDE.FIRST_GOODS_DESC_2 = {
    "7天 VIP1",
    "動態頭像",
    "最高3倍籌碼"
}
L.PAYGUIDE.GOTO_STORE = "前往商城充值"
L.PAYGUIDE.GET_CARSH_REWARD = "領取{1}救濟金"
L.PAYGUIDE.FIRST_PAY_TIPS = "購買商城任意籌碼可以獲贈以上禮品"
L.PAYGUIDE.BUY_PRICE_1 = "{1}搶購"
L.PAYGUIDE.BUY_PRICE_2 = "原價{1}"
L.PAYGUIDE.ROOM_FIRST_PAY_TIPS = "首衝僅有一次機會"
return L
