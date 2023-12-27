-- 越南

local L = {}
local T, T1

L.COMMON       = {}
L.LOGIN        = {}
L.HALL         = {}
L.ROOM         = {}
L.STORE        = {}
L.USERINFO     = {}
L.FRIEND       = {}
L.RANKING      = {}
L.MESSAGE      = {}
L.SETTING      = {}
L.LOGINREWARD  = {}
L.HELP         = {}
L.UPDATE       = {}
L.ABOUT        = {}
L.DAILY_TASK   = {}
L.COUNTDOWNBOX = {}
L.NEWESTACT    = {}
L.FEED         = {}
L.ECODE        = {}
L.LUCKTURN     = {}
L.SLOT         = {}
L.GIFT         = {}
L.CRASH        = {}
L.MATCH        = {}
L.E2P_TIPS     = {}
L.VIP = {}
L.WINORLOSE = {}
L.PRIVTE = {}
L.ACT = {}
L.REDBLACK = {}
L.TUTORIAL = {}
L.TIPS = {}
L.SAFE = {}
L.GOLDISLAND = {}

-- tips
L.TIPS.ERROR_INVITE_FRIEND = "Mời bạn bè thất bại"
L.TIPS.ERROR_TASK_REWARD = "Nhận thưởng nhiệm vụ thất bại"
L.TIPS.ERROR_SEND_FRIEND_CHIP = "Tặng Chips thất bại"
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "Nhận Chips tặng thất bại"
L.TIPS.ERROR_BUY_GIFT = "Tặng quà thất bại"
L.TIPS.ERROR_LOTTER_DRAW = "Nhận quà thần bí thất bại"
L.TIPS.EXCEPTION_LOTTER_DRAW = "Số lần đập trứng không đủ"
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "Vào phòng thất bại"
L.TIPS.ERROR_LOGIN_FACEBOOK = "FaceBook đăng nhập thất bại"
L.TIPS.ERROR_LOGIN_FAILED = "Đăng nhập thất bại"
L.TIPS.ERROR_QUICK_IN = "Tải thông tin phòng thất bại"
L.TIPS.EXCEPTION_QUICK_IN = "Tải thông tin phòng lỗi"
L.TIPS.ERROR_SEND_FEEDBACK = "Server lỗi hoặc kết nối thất bại, gửi phản hồi thất bại"
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "Server lỗi, gửi phản hồi thất bại"
L.TIPS.ERROR_MATCH_FEEDBACK = "Phản hồi lỗi đấu trường thất bại"
L.TIPS.EXCEPTION_ACT_LIST = "Server lỗi, tải dữ liệu hoạt động thất bại"
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "Kiểm chứng mật khẩu: Server lỗi"
L.TIPS.ERROR_BACK_CHECK_PWD = "Server lỗi hoặc kết nối thất bại, kiểm chứng mật khẩu thất bại"
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "Phản hồi tải ảnh lên thất bại"
L.TIPS.ERROR_LEVEL_UP_REWARD = "Server lỗi hoặc kết nối thất bại, nhận quà tăng cấp thất bại"
L.TIPS.WARN_NO_PERMISSION = "Bạn chưa thể dùng chức năng này, hãy vào cài đặt ủy quyền hệ thống"
L.TIPS.VIP_GIFT = "VIP mới mua được vật phẩm này"

-- COMMON MODULE
L.COMMON.LEVEL = "Level: " 
L.COMMON.ASSETS = "${1}"
L.COMMON.CONFIRM = "OK"
L.COMMON.CANCEL = "HỦY"
L.COMMON.AGREE = "ĐỒNG Ý"
L.COMMON.REJECT = "TỰ CHỐI"
L.COMMON.RETRY = "KẾT NỐI LẠI"
L.COMMON.NOTICE = "NHẮC NHỜ"
L.COMMON.BUY = "MUA"
L.COMMON.SEND = "GỬI"
L.COMMON.BAD_NETWORK = "Mạng lỗi, hãy kiểm tra lại"
L.COMMON.REQUEST_DATA_FAIL = "Mạng lỗi, hãy nhấp nút kết nối lại."
L.COMMON.ROOM_FULL = "Bàn này quá đông, hãy đổi bàn"
L.COMMON.USER_BANNED = "Tài khoản bạn đã bị khóa, hãy liên hệ CSKH"
L.COMMON.SHARE = "Chia Sẻ"
L.COMMON.GET_REWARD = "Nhận thưởng"
L.COMMON.BUY_CHAIP = "Mua"
L.COMMON.SYSTEM_BILLBOARD = "Thông báo"
L.COMMON.DELETE = "Xóa"
L.COMMON.CHECK = " Xem"
L.COMMON.CONGRATULATIONS = "Chúc mừng bạn"
L.COMMON.REWARD_TIPS = "Chúc mừng bạn nhận được {1}"
L.COMMON.GET = "NHẬN"
L.COMMON.CLICK_GET = "NHẬN"
L.COMMON.ALREADY_GET = "ĐÃ NHẬN"
L.COMMON.NEXT_GET = "LẦN SAU"
L.COMMON.LOGOUT = "THOÁT"
L.COMMON.LOGOUT_DIALOG_TITLE = "Xác nhận thoát game"
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "Chips không đủ,tối thiểu phải mang vào {1}，hãy thử lại sau bổ sung Chips"
L.COMMON.USER_SILENCED_MSG = "Tài khoản bạn đã bị cấm phát ngôn,hãy liên hệ admin để được giải quyết trong mục trợ giúp "
L.COMMON.USER_NEED_RELOGIN = "Thao tác thất bại,hãy đăng nhập lại hoặc liên hệ CSKH"
L.COMMON.BLIND_BIG_SMALL = "Small Blinds:{1}/{2}"
L.COMMON.NOT_ENOUGH_DIAMONDS = "Xin lỗi,Diamond không đủ"
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "Chips không đủ,hãy thử lại sau nạp"

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE = "Xác nhận thoát khỏi"
L.COMMON.QUIT_DIALOG_MSG = "Bạn có chắc muốn thoát không?Người ta không chịu đâu ~\\(≧▽≦)/~"
L.COMMON.QUIT_DIALOG_MSG_A = "Nhất định phải thoát rồi hả? \n Ngày mai đăng nhập nhận nhiều phần thưởng nhé"
L.COMMON.QUIT_DIALOG_CONFIRM = "Thoát"
L.COMMON.QUIT_DIALOG_CANCEL = "Tôi bấm sai "
L.COMMON.GAME_NAMES = {
	[1] = "TEXAS POKER",
	[2] = "SÒNG GIẢI ĐẤU",
	[3] = "OMAHA",
	[4] = "德州百人场",
    [5] = "德州必下场",
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "Ba lần đầu đăng nhập của người chơi mới ,có thể nhận phần thưởng hấp dẫn miễn phí.\nĐăng nhập FaceBook nhận thêm quà hấp dẫn!"
L.LOGIN.FB_LOGIN = "Login FB"
L.LOGIN.GU_LOGIN = "Guest"
L.LOGIN.REWARD_SUCCEED = "Nhận thành công"
L.LOGIN.REWARD_FAIL = "Nhận thất bại"
L.LOGIN.LOGINING_MSG = "Đang đăng nhập..."
L.LOGIN.CANCELLED_MSG = "Hủy đăng nhập"
L.LOGIN.DOUBLE_LOGIN_MSG = "Tài khoản bạn đăng nhập tại thiết bị khác"
L.LOGIN.LOGIN_DEALING = "Đang đăng nhập, xin chờ"
L.LOGIN.INIT_SDK = "Đang khởi động game, xin chờ..."

-- HALL MODULE
L.HALL.USER_ONLINE = "Online:{1} "
L.HALL.INVITE_TITLE = "Mời bạn bè"
L.HALL.INVITE_FAIL_SESSION = " Đọc thông tin Facebook thất bại,hãy thử lại "
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "Số bàn sai"
L.HALL.MATCH_NOT_OPEN = "Sòng giải đấu sắp ra mắt"
L.HALL.NOT_TRACK_TIPS = "Không online,không thể truy hỏi"
L.HALL.TEXAS_LIMIT_LEVEL = "Level của bạn không đủ {1},hãy chơi bài để tăng level nhé"
L.HALL.TEXAS_GUIDE_TIPS_1 = "Bạn đã là cao thủ, đừng bắt nạt tân thủ nữa"
L.HALL.TEXAS_GUIDE_TIPS_2 = "Bạn đã là cao thủ, hãy vào phòng cao hơn để thắng nhiều hơn"
L.HALL.TEXAS_GUIDE_TIPS_3 = "Chúc mừng ! Bạn đã thắng được số Chips cao hơn cấp bàn này, có muốn qua chơi phòng cấp cao hơn ?"
L.HALL.TEXAS_UPGRADE = "Tăng ngay"
L.HALL.TEXAS_STILL_ENTER = "Vẫn vào"
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
	"SÒNG SƠ CẤP",
	"SÒNG TRUNG CẤP",
	"SÒNG CAO CẤP",
}
L.HALL.PLAYER_LIMIT_TEXT = {
	"9\n người",
	"6\n người"
}
L.HALL.CHOOSE_ROOM_TYPE = {
	"SÒNG THƯỜNG", 
	"CHƠI NGAY",
}
L.HALL.CHOOSE_ROOM_CITY_NAME = {
	"BANGKOK",
	"HUA HIN",
	"PATTAYA",
	"AYUTAYA", 
	"SUKHOTHAI",
	"PHUKET",

	"SEOUL",
	"SINGAPORE",
	"KUALA LUMPUR",
	"THƯỢNG HẢI",
	"MILANO",
	"PARIS",

	"TOKYO",
	"LONDON",
	"NEW YORK",
	"MACAU",
	"DUBAI",
	"LAS VEGAS",

	"HAWAII",
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "Min {1}/Max {2}"
L.HALL.CHOOSE_ROOM_BLIND = "Blinds: {1}/{2}" 
L.HALL.GIRL_SHORT_CHAT = {
	"Hi, mình là dealer, mình tên Angela",
	"Chờ bạn trong phòng game nhé", 
	"Game này rất hay, nhớ ghé chơi thường xuyên nhé", 
	"Ghét quá đi, bạn đang làm gì đó", 
	"Honey mau vào chơi nào",
	"Thích thì vào Like fanpage nhé",
	"Bạn thật dễ thương, chúc may mắn",
	"Yêuuu~ ~(￣3￣)|~",
	"Đừng quên nhấp mời bạn bè mỗi ngày nhé ! Tặng nhiều Chips miễn phí !",
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "Level của bạn chưa đủ {1},hãy chơi sau sòng Poker đến level {2} nhé!"
L.HALL.OMAHA_HELP_TITLE = "Hướng dẫn OMAHA"
L.HALL.OMAHA_RULE = [[
Mỗi người chơi được chia đến 4 lá bài nhưng chỉ sử dụng được 2 lá của mình kết hợp với những lá bài chung để tạo thành  bộ bài lớn nhất
Loại bài cuối bao gồm 5 lá bài mạnh nhất được tạo ,sự mạnh yêu loại bài giống Poker,hãy tìm hiểu loại bài dưới góc trai giao diện.

OMAHA quan tâm về số điểm bai tay hơn,Trong sòng OMAHA,số điểm bài tay rất quan trọng,bởi vị bài tay tốt thường được thắng cả ván.  

Sự khác biệt giữa OMAHA và Poker
1. Khi bắt đầu OMAHA,mỗi người chơi được chia 4 lá bài tay,nhưng Poker chia cho mỗi người chơi 2 lá bài tay.
2.Trong OMAHA,mỗi người chơi nhất định phải sử dụng 2 lá bài trong 4 lá kết hợp với 3 lá bài chung được tạo thành một bộ bài tốt nhất.
3.Số người chơi Poker nhiều nhất là 22 người,nhưng OMAHA là 11 người.
]]
L.HALL.TRACE_LIMIT_LEVEL = "Theo thất bại, cần đạt cấp {1} mới có thể vào phòng"
L.HALL.TRACE_LIMIT_ANTE = "Theo thất bại, cần mang {1} Chips mới có thể vào phòng"

-- ROOM MODULE
L.ROOM.OPR_TYPE = {
	"Xem bài", 
	"Bỏ bài",
	"Theo",
	"Cược thêm",
}
L.ROOM.MY_MONEY = "My money {1} {2}"
L.ROOM.INFO_UID = "ID {1}"
L.ROOM.INFO_LEVEL = "Lv.{1}"
L.ROOM.INFO_WIN_RATE = "Tỷ lệ thắng: {1}%" 
L.ROOM.INFO_SEND_CHIPS = "Tặng Chips free"
L.ROOM.ADD_FRIEND = "Theo dõi"
L.ROOM.DEL_FRIEND = "Hủy theo dõi"
L.ROOM.FORBID_CHAT = "Chặn"
L.ROOM.CANCEL_FORBID_CHAT = "Đã chặn"
L.ROOM.NO_SEND_CHIP_TIPS = "Không thể tặng"
L.ROOM.ADD_FRIEND_SUCC_MSG = "Kết bạn thành công"
L.ROOM.ADD_FRIEND_FAILED_MSG = "Kết bạn thất bại"
L.ROOM.DELE_FRIEND_SUCCESS_MSG = "Xóa bạn thành công"
L.ROOM.DELE_FRIEND_FAIL_MSG = "Xóa bạn thất bại"
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "Chỉ tặng được Chips trong sòng thường"
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "Chips cuả bạn không đủ chi trả tiền típ cho Dealer"
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "Ngồi xuống mới tặng được Chips"
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "Chips không đủ"
L.ROOM.SEND_CHIP_TOO_OFTEN = "Bạn tặng quá nhanh"
L.ROOM.SEND_CHIP_TOO_MANY = "Tặng quá nhiều rồi"
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "Sòng giải đấu không thể gửi đạo cụ giao lưu"
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = "Ngồi xuống mới gửi được đạo cụ giao lưu"
L.ROOM.SEND_HDDJ_NOT_ENOUGH = "Đạo cụ giao lưu của bạn không đủ,hãy mua trong shop nhé"
L.ROOM.SEND_HDDJ_FAILED = "Gửi đạo cụ tương tác thất bại"
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = "Ngồi xuống mới gửi được stickers "
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "Bạn chưa ngồi xuống,hãy thử lại sau ngồi xuống"
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2}người)  Số bàn:{3} Blinds:{4}/{5}" 
L.ROOM.PRIVATE_ROOM_INFO = "Bàn VIP({1}người)  Số bàn:{2}  Blinds:{3}/{4}"
L.ROOM.PRIVTE_INFO = "Thời gian còn lại trong bàn: {1}"
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "Gửi tin nhắn loa thất bại" 
L.ROOM.NOT_ENOUGH_LABA = "Loa của bạn không đủ"
L.ROOM.CHAT_MAIN_TAB_TEXT = {
	"Tin" ,
	"Lịch sử tin nhắn" 
}
L.	ROOM.USER_CARSH_REWARD_DESC = "Bạn nhận được cứu trợ phá san với {1} Chips,mỗi tài khoản chỉ nhận được 3 lần ,hãy quý trọng nhé " 
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "Bạn có thể mua ngay,sự thua thắng chỉ là chuyện trong giây phút"
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = "Bạn đã nhận hết cứu trợ phá sản,bạn có thể mua Chips trong shop,đăng nhập mỗi ngày nhận Chips miễn phí nhé!"
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = "Thắng thua lẽ thường,đừng nản lòng,mua Chips ngay ,dồn hết sức để làm lại"
L.ROOM.WAIT_NEXT_ROUND = "Hãy đợi ván sau"
L.ROOM.LOGIN_ROOM_FAIL_MSG = "Đăng nhập vào bàn thất bại"
L.ROOM.BUYIN_ALL_POT= "Pot"
L.ROOM.BUYIN_3QUOT_POT = "3/4 pot"
L.ROOM.BUYIN_HALF_POT = "1/2 pot"
L.ROOM.BUYIN_TRIPLE = "Gấp 3"
L.ROOM.CHAT_TAB_SHORTCUT = "Chat nhanh"
L.ROOM.CHAT_TAB_HISTORY = "Lịch sử chat"
L.ROOM.INPUT_HINT_MSG = "Nhập nội dung chat"
L.ROOM.INPUT_ALERT = "Hãy nhập nội dụng có hiệu quả"
L.ROOM.CHAT_SHIELD = "Bạn đã chặn thành công tin nhắn của {1}"
L.ROOM.CHAT_SHORTCUT = {
	"Chào các bạn !", 
	"Nhanh lên nào !", 
	"ALL IN！！", 
	"Bình tĩnh lại nào !",
	"Hay quá !",  
	"Ai dám chơi không ?", 
	"Cảm ơn đã tặng Chips cho mình !", 
	"Chơi với bạn thật thú vị !", 
	"Có tiền là có quyền !",
	"Hôm nay đen quá !",
	"Đừng cãi nhau nữa !",
	"Bạn có bồ chưa ?",
	"Bài xui quá, đổi phòng thôi !",
	"Mình làm quen nhé !",
	"Hôm nay đỏ phết !",
	"Cho xin ít tiền với !",
	"Hãy theo và ALL IN !",
	"Mua ít Chips rồi chiến tiếp !",
	"Cho xem bài nào !",
	"Mình phải đi đây !"
}
L.ROOM.VOICE_TOOSHORT = "Thời gian ghi âm quá ngắn"
L.ROOM.VOICE_TOOLONG = "Thời gian ghi âm quá dài"
L.ROOM.VOICE_RECORDING = "Đang ghi âm,kéo lên để hủy"
L.ROOM.VOICE_CANCELED = "Đã hủy ghi âm"
L.ROOM.VOICE_TOOFAST = "Thao tác bạn quá nhiều "
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
	"Cảm ơn bạn{1}！Bạn sẽ thường gặp may mắn！",
	"Cảm ơn bạn{1}！Vận may sẽ đến với bạn！",
	"Cảm ơn sự tốt bụng của bạn",
}
--买入弹框
L.ROOM.BUY_IN_TITLE = "Mua Chips"
L.ROOM.BUY_IN_BALANCE_TITLE = "Chips dư tài khoản bạn"
L.ROOM.BUY_IN_MIN = "Mua tối thiểu "
L.ROOM.BUY_IN_MAX = "Mua tối đa"
L.ROOM.BUY_IN_AUTO = "Mụa tự động khi ít hơn Big Blinds"
L.ROOM.BUY_IN_AUTO_MIN = "Mua tự động khi ít hơn số mua tối thiểu"
L.ROOM.BUY_IN_BTN_LABEL = "Mua và ngồi xuống"
L.ROOM.ADD_IN_TITLE = "Tăng Chips"
L.ROOM.ADD_IN_BTN_LABEL = "Mua"
L.ROOM.ADD_IN_BTN_TIPS = "Ngồi xuống mới tăng được Chips"
L.ROOM.ADD_IN_BTN_TIPS_2 = "Không còn Chips,không thể tăng Chips"
L.ROOM.ADD_IN_BTN_TIPS_3 = "Chips của bạn đã là giới hạn lớn nhất,không thể tăng Chips"
L.ROOM.ADD_IN_SUC_TIPS = "Tăng Chips thành công,sẽ tự đông tăng {1} Chips khi bắt đầu ván tiếp theo"
L.ROOM.BACK_TO_HALL = "Thoát"
L.ROOM.CHANGE_ROOM = "Đổi bàn"
L.ROOM.SETTING = "Cài đặt "
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "Chips bạn không đủ Chips yêu cầu tối thiểu,bạn có thể đổi bàn để hệ thống chọn bàn hoặc ngồi xuống lại sau bổ sung thêm Chips "
L.ROOM.AUTO_CHANGE_ROOM = "Đổi bàn"
L.ROOM.USER_INFO_ROOM = "Thông tin "
L.ROOM.CHARGE_CHIPS = "Bổ sung thêm Chips"
L.ROOM.ENTERING_MSG = "Đang vào bàn, xin chờ...\nCó kiến thức và một ít liều lĩnh mới thắng được" 
L.ROOM.OUT_MSG = " Đang thoát ,xin chờ..."
L.ROOM.CHANGING_ROOM_MSG = "Đang đổi bàn..."
L.ROOM.CHANGE_ROOM_FAIL = "Đổi bàn thất bại,có thử lại không?"
L.ROOM.STAND_UP_IN_GAME_MSG = "Bạn đang trong ván chơi,chắc chắn đứng lên không?"
L.ROOM.LEAVE_IN_GAME_MSG = "Bạn đang trong ván chơi,chắc chắn thoát khỏi không?"
L.ROOM.RECONNECT_MSG = "Đang kết nối lại..."
L.ROOM.OPR_STATUS = {
	"Úp bài",
	"ALL_IN", 
	"Theo",
	"Theo {1}",
	"Small Blinds",
	"Big Blinds",
	"Xem ",
	"Thêm cược {1}",
	"Thêm cược",
}
L.ROOM.AUTO_CHECK = "Auto xem"
L.ROOM.AUTO_CHECK_OR_FOLD = "Xem/Bỏ"
L.ROOM.AUTO_FOLD = "Auto bỏ"
L.ROOM.AUTO_CALL_ANY = "Theo hết"
L.ROOM.FOLD = "Bỏ bài"
L.ROOM.ALL_IN = "ALL IN"
L.ROOM.CALL = "Theo "
L.ROOM.CALL_NUM = "Theo {1}"
L.ROOM.SMALL_BLIND = "Small Blinds"
L.ROOM.BIG_BLIND = "Big Blinds"
L.ROOM.RAISE = "Cược thêm"
L.ROOM.RAISE_NUM = "Cược thêm {1}"
L.ROOM.CHECK = "Xem"
L.ROOM.BLIND3 = "Big Blinds X3"
L.ROOM.BLIND4 = "Big Blinds X4"
L.ROOM.TABLECHIPS = "Pot X1" 
L.ROOM.TIPS = {
	"Guest có thể đổi Avatar và giới tính tại giao diện nhân vật",
	"Khi bài của bạn nhỏ hơn đối thủ, bạn sẽ thua hết số tiền đã cược",
	"Bất cứ ai trước khi trở thành cao thủ đều đã từng là tân thủ",
	"Cầm bài ngon phải nắm bắt cơ hội chủ động thêm cược",
	"Chú ý quan sát đối thủ, đừng để bị lừa qua mặt", 
	"Phải có khí thế át địch, để họ sợ bạn",
	"Khống chế cảm xúc, thắng những ván cần thắng",
	"Người chơi Guest có thể đổi Avatar của mình",
	"Có thể cài đặt tự động mua Chips và ngồi xuống trong giao diện cài đặt",
	"Có thể cải đặt rung trong giao diện cài đặt",
	"Nhịn nhục là vì để cho lần sau ALL IN",
	"Nóng vội là thua cuộc, hãy bình tĩnh",
	"Khi phong thủy không tốt, hãy thử đổi chỗ ngồi",
	"Thua bài không đáng sợ bằng việc thua mất niềm tin",
	"Bạn không thể khống chế thắng thua, nhưng có thể khống chế việc thua ít hay nhiều",
	"Hãy dùng đạo cụ tương tác để ném các người chơi AFK",
	"Vận may có lúc không ở bên bạn, nhưng kiến thức là thứ sẽ theo bạn suốt đời",	
	"Hù dọa có chọn lọc là nghệ thuật của chiến thắng",
	"Lúc đặt cược phải có stính toán và quan sát tinh tế",
	"ALL IN là một loại chiến thuật, và không dễ để sử dụng thành thạo",  










}
L.ROOM.SHOW_HANDCARD = "Mở bài tay"
L.ROOM.SERVER_UPGRADE_MSG = "Máy chủ đang cập nhật,xin chờ..."
L.ROOM.KICKED_BY_ADMIN_MSG = "Bạn đã bị admin đuổi khỏi bàn"
L.ROOM.KICKED_BY_USER_MSG = "Bạn đã bị {1} đuổi khỏi bàn"
L.ROOM.TO_BE_KICKED_BY_USER_MSG = "Bạn đã bị {1} đuổi khỏi bàn, tự động thoát sau khi ván kết thúc"
L.ROOM.BET_LIMIT = "Cược thêm thất bại,Số cược thêm một ván không thể vượt quá 100M"
L.ROOM.BET_LIMIT_1 = "Cược thêm thất bại,Số tốc một ván không thể vượt quá {1}"
L.ROOM.NO_BET_STAND_UP = "Bạn đã 3 ván không thao tác, tự động rời bàn"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "Ngồi xuống thất bại,không thể ngồi xuống cùng một IP"
T["SEAT_NOT_EMPTY"] = "Ngồi xuống thất bại,chỗ này đã có người chơi ngồi"
T["TOO_RICH"] = "Ngồi xuống thất bại,Chips nhiều vậy mà vào sòng tân thủ để ăn hiếp người chơi hả?"
T["TOO_POOR"] = "Ngồi xuống thất bại,Chips không đủ không thể vào bàn ngoài bàn tân thủ"
T["NO_OPER"] = "Bạn đã không thao tác vượt quá ba ván,đã tự động đứng lên,ngồi xuống lại có thể bắt đầu lại"
L.ROOM.SERVER_STOPPED_MSG = "Hệ thống đang bảo trì,xin chờ"
L.ROOM.GUIDEHEIGHT = "Vào sòng {1} thắng nhiều Chips "
L.ROOM.GUIDELOW = "Vào sòng {1} thua ít Chips "
L.ROOM.CARD_POWER_DESC = [[
Chỉ thị gợi ý chỉ đưa ra tỷ lệ thắng tham khảo cho người chơi

Phòng sư cấp dùng miễn phí, trở thành VIP có thể dùng ở phòng bất kỳ

Mặc định mở bạn có thể đóng thủ công, sau khi đóng có thể mở lại trong mục cài đặt
]]

--STORE
L.STORE.TOP_LIST = {
	"Chips",
	"Diamond",
	"Đạo cụ",
	"VIP"
}
L.STORE.NOT_SUPPORT_MSG = "Tài khoản của bạn tạm không hỗ trợ thanh toán" 
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "Thanh toán thành công,đang gửi hàng hóa,xin chờ..."
L.STORE.PURCHASE_CANCELED_MSG = "Hủy thanh toán"
L.STORE.PURCHASE_FAILED_MSG = "Thanh toán thất bại,hãy thử lại"
L.STORE.PURCHASE_FAILED_MSG_2 = "Hãy nhập số Seri và mã PIN chính xác"
L.STORE.PURCHASE_FAILED_MSG_3 = "Thẻ này đã dùng qua rồi"
L.STORE.PURCHASE_FAILED_MSG_4 = "Thẻ vô hiệu"
L.STORE.DELIVERY_FAILED_MSG = "Mạng lỗi,hệ thống sẽ thử lại khi mở shop lần sau"
L.STORE.DELIVERY_SUCC_MSG = "Gửi hàng thành công,Cảm ơn bạn"
L.STORE.TITLE_STORE = "Shop"
L.STORE.TITLE_CHIP = "Chips"
L.STORE.TITLE_PROP = "Đạo cụ giao lưu"
L.STORE.TITLE_MY_PROP = "Đạo cụ tôi"
L.STORE.TITLE_HISTORY = "Lịch sử mua hàng"
L.STORE.RATE_DIAMONDS = "1{2}={1}Diamond"
L.STORE.RATE_CHIP = "1{2}={1}Chips"
L.STORE.RATE_PROP = "1{2}={1}Đạo cụ"
L.STORE.FORMAT_DIAMONDS = "{1} Diamond"
L.STORE.FORMAT_CHIP = "{1}Chips"
L.STORE.FORMAT_PROP = "{1}Đạo cụ"
L.STORE.FORMAT_HDDJ = "{1}Đạo cụ giao lưu"
L.STORE.FORMAT_DLB = "{1} Loa"
L.STORE.FORMAT_LPQ = "{1} Thẻ quà"
L.STORE.FORMAT_DHQ = "{1} Thẻ đổi"
L.STORE.FORMAT_MYB = "{1} Tiền đổi"
L.STORE.HDDJ_DESC = "Có thể sử dụng đạo cụ giao lưu {1} lần với người chơi trong bàn"
L.STORE.DLB_DESC = "Có thể gửi {1} lần tin nhắn đối với tất cả người chơi cùng máy chủ trong giao diện cửa sổ trong bàn" 
L.STORE.BUY = "Mua"
L.STORE.USE = "Sử dụng"
L.STORE.BUY_DESC = "Mua {1}"
L.STORE.RECORD_STATUS = {
	"Đã đặt hàng",
	"Đã gửi hàng",
	"Đã hoàn trả"
}
L.STORE.NO_PRODUCT_HINT = "Chưa có hàng hóa"
L.STORE.NO_BUY_HISTORY_HINT = "Chưa có lịch sử giao dịch"
L.STORE.BUSY_PURCHASING_MSG = "Đang mua,xin chờ..."
L.STORE.CARD_INPUT_SUBMIT = "TOP UP"
L.STORE.BLUEPAY_CHECK = "Bạn có chắc mua {2} với {1} không?"
L.STORE.GENERATE_ORDERID_FAIL = "Đặt hàng thất bại,hãy thử lại"
L.STORE.INPUT_NUM_EMPTY = "Số seri không thể để trống,hãy nhập lại!"
L.STORE.INPUT_PASSWORD_EMPTY = "Số pin không thể để trống,hãy nhập lại!"
L.STORE.INPUT_NUM_PASSWORD_EMPTY = "Số seri hoặc số pin không thể để trống,hãy nhập lại!"
L.STORE.INPUT_CRAD_NUM = "Hãy nhập số seri"
L.STORE.INPUT_CRAD_PASSWORD = "Hãy nhập số pin"
L.STORE.QUICK_MORE = "Xem thêm"
L.STORE.REAL_TAB_LIST = {
	"Thẻ quà",
	"Thẻ đổi",
	"Tiền đổi",
}
L.STORE.REAL_ADDRESS_BTN = "Địa chỉ"
L.STORE.REAL_EXCHANGE_BTN = "Đổi"
L.STORE.ADDRESS_POP_TITLE = "Địa chỉ nhận quà"
L.STORE.REAL_TIPS = "Hãy điền tên thật và thông tin liên hệ chính xác, để tiện nhận thưởng"
L.STORE.REAL_TIPS_2 = "Hãy điền đầy đủ thông tin"
L.STORE.REAL_SAVE = "OK"
L.STORE.REAL_TITLES = {
	"Người nhận:",
	"SĐT:",
	"Địa chỉ:",
	"Postal Code:",
	"Email:"
}
L.STORE.REAL_PLACEHOLDER = {
	"Tên",
	"SĐT",
	"Hãy điền thông tin tỉnh thành địa chỉ nhà chính xác",
	"Postal Code",
	"Email"
}
L.STORE.EXCHANGE_REAL_SUCCESS = "Chúc mừng, đổi {1} thành công, chúng tôi sẽ gửi quà cho bạn trong thời gian sớm nhất"
L.STORE.EXCHANGE_REAL_FAILED_1 = "Số lượng {1} không đủ, đổi {2} cần {3}"
L.STORE.EXCHANGE_REAL_FAILED_2 = "Đổi thất bại, hãy thử lại !"
L.STORE.TAB_LIST = {
	"SHOP",
	"Đổi Quà"
}
L.STORE.CASH_CARD_TITLE = "Đổi Thẻ Cào"
L.STORE.CASH_CARD_TIPS_1 = "Hãy nhập số điện thoại chính xác.\nChúng tôi sẽ gửi mã thẻ cào đến SĐT của bạn."
L.STORE.CASH_CARD_TIPS_2 = "Hãy nhập số điện thoại"
L.STORE.CASH_CARD_TIPS_3 = "Hãy nhập số điện thoại gồm 10-11 số"
L.STORE.CASH_CARD_TIPS_4 = "SĐT bạn nhập là {1}-{2}-{3}, chúng tôi sẽ gửi mã thẻ cào đến số này."--"您输入的电话号码是{1}-{2}-{3},我们将向此号码发送充值卡的信息."

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "Chips của bạn không đủ 5000, không thể dùng biểu cảm VIP"
L.VIP.SEND_EXPRESSIONS_TIPS = "Bạn không phải VIP, dùng biểu cảm VIP sẽ bị trừ Chips, hãy trở thành VIP để được dùng miễn phí"
L.VIP.BUY_PROP = "Mua đạo cụ"
L.VIP.OPEN_VIP = "Trở thành VIP"
L.VIP.COST_CHIPS = "Tốn {1} Chips"
L.VIP.LIST_TITLE = {
	"Giá",
	-- "Thẻ đá người",
	"VIP gợi ý chỉ thị",
	"VIP lễ vật",
	"VIP đạo cụ",
	"VIP biểu cảm",
	-- "Chiết khấu phòng riêng",
	-- "Ưu đãi phá sản",
	-- "EXP",
	"Đăng nhập mỗi ngày",
	"Tặng ngay Chips",
}
L.VIP.NOT_VIP = "Chưa mua"
L.VIP.AVAILABLE_DAYS = "Còn {1} ngày"
L.VIP.OPEN_BTN = "Mở {1} Diamond"
L.VIP.AGAIN_BTN = "Gia hạn {1} Diamond"
L.VIP.CONTINUE_BUY = "Mua tiếp"
L.VIP.BROKE_REWARD = "Tặng thêm {1}%  Mỗi ngày {2} lần"
L.VIP.LOGINREWARD = "{1}*31 ngày"
L.VIP.PRIVATE_SALE = "Ưu đãi {1}%"
L.VIP.SEND_PROPS_TIPS_1 = "VIP được dùng miễn phí đạo cụ tương tác"
L.VIP.SEND_PROPS_TIPS_2 = "Đạo cụ tương tác đã dùng hết, có thể dùng Chips để mua thêm, hoặc trở thành VIP để được dùng miễn phí, và nhiều đặc quyền khác"
-- L.VIP.KICK_CARD = "Thẻ đá người"
-- L.VIP.KICK_SUCC = "Đá người thành công, người chơi sẽ bị đá ra khỏi bàn sau ván này"
-- L.VIP.KICK_FAILED = "Đá người thất bại, hãy thử lại"
-- L.VIP.KICKED_TIP = "Rất tiếc, bạn đạ bị {1} đá khỏi bàn, sau ván này sẽ phải thoát ra"
-- L.VIP.KICKER_TOO_MUCH = "Đã dùng hết số lần đá người hôm nay, xin hãy bình tĩnh"
-- L.VIP.KICKED_ENTER_AGAIN = "Bạn đã bị đá khỏi phòng này, trong vòng 20 phút không thể vào lại, hãy chọn phòng chơi khác"
L.VIP.BUY_SUCCESS = "Chúc mừng, mua VIP thành công !"
L.VIP.BUY_FAILED = "VIP mua thất bại, hãy thử lại"
L.VIP.BUY_FAILED_TIPS = "Diamond không đủ, hay mua thêm Diamond !"
L.VIP.BUY_TIPS_1 = "Bạn mua {1}, cần tốn {2} Diamond"
L.VIP.BUY_TIPS_2 = "Bạn đang là {1} VIP vẫn chưa hết hạn, nếu muốn mua tiếp, sẽ từ bỏ {2} VIP hiện tại và trở thành {3} VIP, xác nhận ?"
L.VIP.BUY_TIPS_3 = "Bạn đang là {1} VIP, nếu gia hạn cho cấp VIP này, thời hạn sẽ tăng thêm {2} ngày, cần tốn {3} Diamond"
L.VIP.LEVEL_NAME = {
	"Lãnh Chủ",
	"Quý Tộc",
	"Vương Tộc",
	"Hoàng Tộc"
}
L.VIP.NO_VIP_TIPS = "Bạn chưa phải VIP, hãy trở thành VIP để hưởng nhiều đặc quyền hấp dẫn"
L.VIP.CARD_POWER_TIPS = "Bạn không phải VIP, có muốn"
L.VIP.CARD_POWER_OPEN_VIP = "Mở ngay"
L.VIP.VIP_AVATAR = "VIP Avatar Động"
L.VIP.NOR_AVATAR = "Avatar Thường"
L.VIP.SET_AVATAR_SUCCESS = "Cài đặt Avatar thành công !"
L.VIP.SET_AVATAR_FAILED_1 = "Cài đặt Avatar thất bại, hãy thử lại !"
L.VIP.SET_AVATAR_FAILED_2 = "Cấp VIP không đủ, hãy chọn Avatar khác"
L.VIP.SET_AVATAR_TIPS = [[
Bạn không phải VIP, chỉ có thể xem hiệu ứng, trở thành VIP mới có thể sử dụng, trờ thành VIP nhận nhiều Chips miễn phí, nạp thẻ ưu đãi và nhiều quyền lợi khác.

Có muốn trở thành VIP ?
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "Facebook đăng nhập nhận"
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}"
L.LOGINREWARD.REWARD_BTN        = "Nhận {1}"
L.LOGINREWARD.GET_REWARD_FAILED = "Điểm danh thất bại,hãy thử lại!"
L.LOGINREWARD.VIP_REWARD_TIPS   = "Quà đăng nhập VIP"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2}" --EXP
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
	"Sòng thường",
	"SNG",
	"MTT"
}
L.USERINFO.BOARD_SORT = {
	"Thời gian",
	"Thắng thua"
}
L.USERINFO.NO_RECORD = "Chưa có"
L.USERINFO.LAST_GAME = "Ván trước"
L.USERINFO.NEXT_GAME = "Ván sau"
L.USERINFO.PLAY_TOTOAL_COUNT = "Ván: "
L.USERINFO.PLAY_START_RATE = "Vào ván: "
L.USERINFO.WIN_TOTAL_RATE = "Thắng ván: "
L.USERINFO.SHOW_CARD_RATE = "Lật bài: "
L.USERINFO.MAX_CARD_TYPE = "Bài lớn nhất"
L.USERINFO.JOIN_MATCH_NUM = "Dự giải"
L.USERINFO.GET_REWARD_NUM = "Giành giải"
L.USERINFO.MATCH_BEST_SCORE = "MTT tốt nhất"
L.USERINFO.MY_CUP = "MY CUP"
L.USERINFO.NO_CHECK_LINE = "Chưa viết"
L.USERINFO.BOARD = "Lịch sử"
L.USERINFO.MY_PACK = "Túi"
L.USERINFO.ACHIEVEMENT_TITLE = "Thành tựu"
L.USERINFO.REAL_STORE = "Đổi quà"
L.USERINFO.LINE_CHECK_NO_EMPTY = "Tài khoản Line không thể để trống,hãy nhập lại"
L.USERINFO.NICK_NO_EMPTY = "Tên không thể để trống,hãy nhập lại"
L.USERINFO.LINE_CHECK_ONECE = "Một ngày chỉ có thể xác nhận Line 1 lần"
L.USERINFO.LINE_CHECK_FAIL = "Gửi xác nhận thất bại,hãy thử lại!"
L.USERINFO.LINE_CHECK_SUCCESS = "Gửi xác nhận thành công"
L.USERINFO.GET_BOARD_RECORD_FAIL = "Đọc tin thành tích cá nhân thất bại,hãy đóng cửa và thử lại!"
L.USERINFO.PACKAGE_INFO = {
	{
		title = "Đạo cụ tương tác",
		desc = "Có thể sử dụng đạo cụ tương tác đối với người chơi khác"
	},
	{
		title = "Loa",
		desc = "Có thể gửi thông tin cho tất cả người chơi cùng máy chủ lúc bạn đang chơi ván"
	},
	{
		title = "Thẻ đổi",
		desc = "Dùng để đổi quà tặng"
	},
	{
		title = "Thẻ quà",
		desc = "Có thể đổi quà tương ứng ghi trên thẻ"
	},
	{
		title = "Tiền tệ",
		desc = "Tiền có giá trị"
	},
}
L.USERINFO.MARK_TEXT = {
	"Theo cược",
	"Crazy",
	"Hung dữ",
	"Yếu đuối",
	"Nham thạch",
	"Cảnh báo",
	"Nhu nhược",
	"Tự chọn"
}
L.USERINFO.MARK_TITLE = "Phân loại"
L.USERINFO.MARK_TIPS = "Nhấp để phân loại"
L.USERINFO.MARK_SUCCESS = "Phân loại thành công"
L.USERINFO.MARK_FAIL = "Phân loại thất bại,hãy thử lại"
L.USERINFO.MARK_NO_EMPTY = "Nội dung phân loại không thể để trống,hãy nhập lại"
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "Máy bạn không có thẻ nhớ(SD),không thể chọn ảnh"
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "Đọc ảnh thất bại"
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "Đổi avatar thất bại,hãy thử lại sau"
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "Đang đổi avatar,vui lòng chờ..."
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "Đổi avatar thành công"

-- FRIEND MODULE
L.FRIEND.TITLE = "Bạn bè"
L.FRIEND.NO_FRIEND_TIP = "Chưa có"
L.FRIEND.SEND_CHIP = "Tặng Chips"
L.FRIEND.RECALL_CHIP = "Kêu gọi +{1}"
L.FRIEND.ONE_KEY_SEND_CHIP = "Tặng nhanh"
L.FRIEND.ONE_KEY_RECALL = "Gọi nhanh"
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "Nửa Chips của bạn đang có không đủ để tặng hết,hãy thử lại sau bổ sung thêm Chips."
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "Chắc chắn tặng {2} Chips cho {1} người bạn không?"
L.FRIEND.ADD_FULL_TIPS = "Số bạn đã đạt giới hạn {1},hệ thống sẽ xóa những bạn không chơi ván trong thời gian quá lâu theo tình trạng thực tế."
L.FRIEND.SEND_CHIP_WITH_NUM = "Tặng {1} Chips"
L.FRIEND.SEND_CHIP_SUCCESS = "Bạn đã tặng thành công {1} Chips cho bạn."
L.FRIEND.SEND_CHIP_PUSH = "{1} tặng 10K Chips cho bạn, mau nhận nào !"
L.FRIEND.SEND_CHIP_TOO_POOR = "Chips không đủ,hãy thử lại sau mua Chips tại shop."
L.FRIEND.SEND_CHIP_COUNT_OUT = "Hôm nay bạn đã tặng Chips cho bạn này,hãy thử ngày mai."
L.FRIEND.SELECT_ALL = "Chọn hết"
L.FRIEND.SELECT_NUM = "Chọn {1} người"
L.FRIEND.DESELECT_ALL = "Hủy chọn"
L.FRIEND.SEND_INVITE = "Mời"
L.FRIEND.INVITE_SENDED = "Đã mời"
L.FRIEND.INVITE_SUBJECT = "Bạn nhất định thích luôn"
L.FRIEND.CALL_FRIEND_TO_GAME = "Cùng chơi đi!Game rất thú vị đây"
L.FRIEND.INVITE_CONTENT =  "Giới thiệu một game poker thú vị lại phấn khởi cho bạn.Tôi tặng cho bạn gói quà 150K Chips,đăng ký để nhận ngay,hãy cùng chơi với tôi đi!"..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP = "Bạn đã chọn {1} người bạn,gửi lời mời sẽ nhận được {2} Chips" 
L.FRIEND.INVITE_SELECT_TIP_1 = "Bạn đã chọn"
L.FRIEND.INVITE_SELECT_TIP_2 = "người bạn,gửi lời mời thì nhận ngay"
L.FRIEND.INVITE_SELECT_TIP_3 = "Phần thưởng Chips"
L.FRIEND.INVITE_SUCC_TIP = "Gửi lời mời thành công,nhận được {1} Chips!"
L.FRIEND.INVITE_SUCC_FULL_TIP = "Gửi lời mời thành công,hôm nay đã nhận được {1} quà thưởng mời bạn!"
L.FRIEND.INVITE_FULL_TIP = "Số người bạn mời của hôm này quá nhiều,hãy gửi lại ngày mai"
L.FRIEND.RECALL_SUCC_TIP = "Gửi thành công nhận thưởng {1}, nhận ngay {2} Chips sau bạn đăng nhập ."
L.FRIEND.RECALL_FAILED_TIP = "Gửi thất bại,hãy thử lại sau."
L.FRIEND.INVITE_LEFT_TIP = "Hôm nay còn có thể mời {1} người bạn!"
L.FRIEND.CANNOT_SEND_MAIL = "Bạn chưa kết nối email,hãy kết nối ngay."
L.FRIEND.CANNOT_SEND_SMS = "Xin lỗi,không thể sử dụng SMS!"
L.FRIEND.MAIN_TAB_TEXT = {
	"Tôi theo dõi", 
	"Theo dõi tôi",
	"Thêm bạn bè"
}
L.FRIEND.INVITE_EMPTY_TIP = "Hãy chọn bạn trước"
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "Bạn bè của bạn đã đạt giới hạn {1},hãy kết bạn lại sau xóa ít bạn nhé"
L.FRIEND.SEARCH_FRIEND = "Hãy nhập tên Facebook của bạn"
L.FRIEND.INVITE_REWARD_TIPS_1 = "Mời"
L.FRIEND.INVITE_REWARD_TIPS_2 = "người bạn có thể nhận được"
L.FRIEND.INVITE_REWARD_TIPS_3 = "Bạn bè càng nhiều,phần thưởng càng nhiều,nhận thường lần nữa sau bạn đăng nhập"
L.FRIEND.SEARCH = "Tìm"
L.FRIEND.CLEAR = "Xoá"
L.FRIEND.INPUT_USER_ID = "Hãy nhập ID "
L.FRIEND.INPUT_USER_ID_NO_EXIST = "ID bạn nhập không có,hãy nhập lại sau kiểm tra "
L.FRIEND.NO_SEARCH_SELF = "Không thể nhập ID mình,hãy nhập lại"
L.FRIEND.NO_LINE_APP = "Bạn chưa lắp Line,hãy mời bạn bằng cách khác"
L.FRIEND.INVITE_REWARD_TIPS = "Nhận gói quà siêu giá trị sau số người đã mời đạt yêu câu ,nhấp gói quà để xem chi tiết\n,Bạn đã mời thành công {1} người bạn,nhận thưởng {2} Chips"
L.FRIEND.INVITE_FB_FRIEND_TITLE = "Mời bạn FB"
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "Gửi tin thì nhận {1}\n,nhận thêm {2} Chips sau thành công"
L.FRIEND.INVITE_CODE_TITLE = "Mã mời"
L.FRIEND.INVITE_CODE_CONTENT = "Thành công thì nhận{1}\n  bạn của bạn nhận thêm {2}"
L.FRIEND.GET_REWARD_TIPS_1 = "Chúc mừng bạn nhận được quà thưởng mời"
L.FRIEND.GET_REWARD_TIPS_2 = "Nhận thưởng sau mời thêm {1} người,nhấp nút để tiếp tục mời bạn nhé!"
L.FRIEND.ROOM_INVITE_TITLE = "Mời bạn"
L.FRIEND.ROOM_INVITE_SUCCTIPS = "Đã mời,vui lòng chờ"
L.FRIEND.ROOM_INVITE_TAB = {
	"Online",
	"Bạn bè"
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1}mời bạn vào {2}{3} cùng chơi bài" 
L.FRIEND.ROOM_INVITE_PLAY_DES = "Chơi chung với bạn sẽ vui hơn.Bạn hãy nhấp nút dưới đây để gửi Line cho bạn hoặc gửi trong nhóm để mời bạn cùng chơi bài. \n\n nhấp hoặc tải lại trang web sẽ vào bàn ngay sau download game."

-- RANKING MODULE
L.RANKING.TITLE = "BXH"
L.RANKING.TRACE_PLAYER = "Theo dõi"
L.RANKING.GET_REWARD_BTN = "Nhận"
L.RANKING.NOT_DATA_TIPS = "Chưa có dữ liệu"
L.RANKING.NOT_IN_CHIP_RANKING = "Xếp hạng bạn :>20,bạn chưa vào bảng xếp hạng,hãy cố gắng nhé"
L.RANKING.IN_RANKING = "Xếp hạng bạn: giải 1,hãy cố gắng nhé"
L.RANKING.IN_RANKING_NO_1 = "Xếp hạng bạn: giải 1,bạn thật là tuyệt vời!"
L.RANKING.MAIN_TAB_TEXT = {
	"BXH Bạn Bè",
	"BXH Thế Giới"
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
	"Hôm qua",
	"Tài sản",
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
	"Hôm qua",
	"Tài sản",
}

-- SETTING MODULE
L.SETTING.TITLE = "Cài đặt"
L.SETTING.NICK = "Tên"
L.SETTING.LANGUAGE = "Ngôn ngữ"
L.SETTING.EXCHANGE = "Code"
L.SETTING.LOGOUT = "Thoát"
L.SETTING.FB_LOGIN = "Đăng nhập +19999"
L.SETTING.SOUND_VIBRATE = "Âm nhạc và rung"
L.SETTING.SOUND = "Âm nhạc"
L.SETTING.BG_SOUND = "Âm thanh nền"
L.SETTING.CHATVOICE = "Âm thanh chat"
L.SETTING.VIBRATE = "Rung"
L.SETTING.AUTO_SIT = "Tự động ngồi xuống lúc vào bàn"
L.SETTING.AUTO_BUYIN = "Tự động mua thêm lúc Chips ít hơn Big Blinds"
L.SETTING.CARD_POWER = "Gợi ý độ mạnh bài"
L.SETTING.APP_STORE_GRADE = "Like và Vote cho game"
L.SETTING.CHECK_VERSION = "Kiểm tra cập nhật"
L.SETTING.CURRENT_VERSION = "Phiên bản ：V{1}"
L.SETTING.ABOUT = "Thông tin"
L.SETTING.PUSH_NOTIFY = "Thông báo"
L.SETTING.PUSH_TIPS = [[
Hệ thống mỗi ngày sẽ tặng Chips miễn phí, ai đến trước sẽ được tặng trước đến khi hết quà thì ngừng
Sau khi mở hãy nhấn mở nhận tiền ngay nhé.

Nhấn xác nhận, đến Quản lý Thông báo-Mở Thông báo, sẽ nhận được Giftcode đổi quà
]]

--HELP Hỗ Trợ
L.HELP.TITLE = "Trung tâm trợ giúp"
L.HELP.FANS = "Fanpage"
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
	"Giới thiệu cách chơi",
	"Giải thích thuật ngữ",
	"Thuyết minh cấp độ",
	"Vấn đề thường gặp",
	"Báo lỗi góp ý",
}

L.HELP.PLAY_SUB_TAB_TEXT = {
	"Cách chơi",
	"So bài",
	"Thao tác",
	"Các nút",
}

L.HELP.LEVEL_RULE = "Chơi bài thì nhận được kinh nghiệm, thắng một lần +2,thua +1 trong sòng thường,sòng đặc biệt không có kinh nghiệm như sòng giải đấu"
L.HELP.LEVEL_TITLES = {
	"LV",
	"Danh hiệu",
	"EXP",
	"Phần thưởng"
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
	"Nạp thẻ",
	"Tài khoản",
	"BUG game",
	"Góp ý",
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
	"Thuyết minh về dữ liêu người chơi",
	"Đánh dấu loại hình người chơi",
}

L.HELP.FEED_BACK_SUCCESS = "Phản hồi thành công!"
L.HELP.FEED_BACK_FIAL = "Phản hồi thất bại!Hãy thử lại"
L.HELP.UPLOADING_PIC_MSG = "Đang gửi ảnh,xin chờ..."
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "Hãy nhập nội dung phản hồi"
L.HELP.MATCH_QUESTION = "Vấn đề giải đấu"
L.HELP.FAQ = {
	{
		"Chips tôi hết rồi,nhưng muốn chơi tiếp,làm sao đây?",
		"Nhấp nút shop bên phải avatar mua Chips để chơi tiếp nhé."
	},
	{
		"Tại sao tôi không thể tặng Chips?",
		"Mỗi người một ngày chỉ tặng được 5000 trong bàn chơi,mỗi người một ngày chỉ tặng được 500 trong danh bạ bạn bè."
	},
	{
		"Nhận Chips free ở đâu?",
		"Có phần thưởng đăng nhập,online,nhiệm vu,fans và mời bạn vân vân,còn các sự kiện hấp dẫn."
	},
	{
		"Mua Chips như thế nào?",
		"Nhấp nút shop,chọn Chips bạn cần để mua."
	},
	{
		"Trở thành fans như thế nào?",
		"Nhấp nút cài đặt, có nút để vào trang fans ở bên dưới giao diện hoặc nhấp link https://www.facebook.com/openpokergame/ \n hệ thống sẽ thường xuyên tặng quà cho fans nhé~"  
	},
	{
		"Thoát game như thế nào?",
		"Nhấp nút cài đặt,chọn nút thoát là được."
	},
	{
		"Đổi tên,avatar và giới tính như thế nào?",
		"Nhấp avatar của mình,chọn chức năng bạn cần là được."
	},
	{
		"Xác nhận Line là gì",
		"Kết bạn với tài khoản line:OpenPoker,sau đó hệ thông sẽ xác nhận cho bạn để hiện thị tài khoản line của bạn trong giao diện game,tiện cho việc kết bạn"
	}
}

L.HELP.PLAY_DESC = {
	"Bài tay",
	"Bài chung",
	"Thành bài",
	"Player A",
	"Player B",
	"Flop",
	"Turn",
	"River",
	"CÙ LŨ thắng",
	"THÚ thua",
}

L.HELP.PLAY_DESC_2 = "Khi bắt đầu ván chơi, mỗi người chơi được chia hai lá bài làm “bài tay”,Dealer sẽ chia 5 lá bài chung trong 3 vòng.Mỗi người chơi sẽ tạo bộ bài mạnh nhất qua sự kết hợp bài tay và bài chung để so bài với người chơi khác,quyết định thắng thua."

L.HELP.RULE_DESC = {
	"THÙNG PHÁ SẢNH THƯỢNG",
	"THÙNG PHÁ SẢNH",
	"TỨ QUÝ",
	"CÙ LŨ",
	"THÙNG",
	"SẢNH",
	"XÁM",
	"THÚ",
	"ĐÔI",
	"MẬU",
}
L.COMMON.CARD_TIPS = "TIẾN CỬ"
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
	"Sảnh cùng chất lớn nhất",
	"Sảnh cùng chất",
	"Tứ quý + bài rác",
	"Xám + đôi",
	"5 lá bài cùng chất",
	"Sảnh không cùng chất",
	"Xám + 2 lá bài rác",
	"2 đôi + bài rác",
	"Đôi + 3 lá bài rác",
	"5 lá bài rác",
}
L.HELP.OPERATING_DESC = {
	"MENU",
	"Mua Chips",
	"Pot chính+phụ", 
	"Dealer",
	"Bài chung",
	"Bài tay",
	"Loại bài",
	"Thao tác",
	"Chips",
	"Độ mạnh bài và tỷ lệ",
	"THÚ",
	"Cược thêm",
	"Theo",
	"Úp bỏ",
}

L.HELP.FEED_BACK_HINT = {
	"Hãy cung cấp thông xin chi tiết về thanh toán để tiện cho việc giải quyết vấn đề với một cách nhanh chóng",
	"Hãy cung cấp ID của bạn để chúng tôi kiểm tra, ID là dãy số hiện dưới avatar",
	"Rất xin lỗi về sự bất tiện này, chúng tôi sẽ kiểm tra và khắc phục lỗi nhanh chóng",
	"Cảm ơn bạn đã góp ý,sự phản hồi của bạn là động lực để chúng tôi tiếp tục hoàn thiện game",
}

L.HELP.PLAY_BTN_DESC = {
	{
		title="Xem bài",
		desc="Khi không muốn cược thêm thì “nhường” quyền quyết định cho người khác",
		type = 1
	},
	{
		title="Úp bỏ",
		desc="Bỏ cơ hội chơi tiếp ván chơi",
		type = 1
	},
	{
		title="Theo",
		desc="Theo số cược thêm của người khác ",
		type = 1
	},
	{
		title="Cược thêm",
		desc="Cược thêm số Chips cao hơn hiện nay",
		type = 1
	},
	{
		title="ALL IN",
		desc="Một lần cược hết tất cả Chips của mình",
		type = 1
	},
	{
		title="Xem/Bỏ",
		desc="Tự động chọn xem bài, nếu có cược thêm thì chọn bỏ bài",
		type = 2
	},
	{
		title="Úp bỏ",
		desc="Tự động úp bỏ khi tới lượt mình",
		type = 2
	},
	{
		title="Theo hết",
		desc="Tự động theo số cược bất kỳ",
		type = 2
	},
}

L.HELP.PLAY_DATA_DESC = {
	{
		title="VP",
		desc="VPIP(thường viết tắt là VP, là tỷ lệ Chips mà người chợi chủ động đặc cược"
	},
	{
		title="PFR",
		desc="PFR là cược thêm trước mở bài, chỉ tỷ lệ cược thêm trước khi mở bài của người chơi"
	},
	{
		title="AF",
		desc="AF là một trị số để đánh giá sự cấp tiến khi chơi bài của người chơi"
	},
	{
		title="3-bet",
		desc="Là cược thêm lần nữa sau khi đã có 2 người trước cược thêm, cược thêm đến lần thứ 3 nên được gọi là 3-bet"
	},
		{
		title="Stealing Blinds",
		desc="Stealing Blinds là ăn Blinds,chỉ một người chơi cố tình cược thêm chỉ để thắng tiền Blinds"
	},
	{
		title="C bet",
		desc="C bet là cược thêm liên tục, người chơi chủ động cược thêm lần nữa sau khi đã cược thêm ở vòng trước"
	},
	{
		title="WTSD",
		desc="WTSD là tỷ lệ lật bài, tức tỷ lệ chơi từ lúc phát 3 lá hết 5 lá"
	},
	{
		title="BB/100",
		desc="BB/100（Tỷ lệ thắng trong 100 ván): BB là viết tắt của Big Blinds,là tỷ lệ thắng trong 100 ván của người chơi"
	},
}

L.HELP.PLAYER_TYPE_DESC = {
	{
		title="Theo cược",
		desc="Chỉ biết cược thêm theo người chơi khác"
	},
	{
		title="Crazy",
		desc="Người chơi điên khùng,thường đe dọa người chơi khác,rất cấp tiến"
	},
	{
		title="Hung dữ (cá mập)",
		desc="Cách chơi rất mạnh mẽ và có tính chất tấn công."
	},
	{
		title="Yếu đuối(con chuột)",
		desc="Cách chơi cẩn thận,nhát như chuột,là người chơi dễ bị đe dọa rồi bỏ ván chơi"
	},
	{
		title="Nham thạch",
		desc="Cách chơi cẩn thận và bị động.Thông thườn người chơi này ít có hành động gì"
	},
	{
		title="Cảnh báo",
		desc="Chơi nhiều ván, luôn tự cap tự đại"
	},
	{
		title="Yếu đuối",
		desc="Chơi nhiều vòng,nhưng lại bị động sau ngả bài ra"
	},
}

--UPDATE
L.UPDATE.TITLE = "Phát hiện phiên bản mới"
L.UPDATE.DO_LATER = "Lần sau"
L.UPDATE.UPDATE_NOW = "Cập nhật"
L.UPDATE.HAD_UPDATED = "Bạn đã cài đặt phiên bản mới nhất"

--ABOUT
L.ABOUT.TITLE = "Liên quan"
L.ABOUT.UID = "ID người chơi: {1}" 
L.ABOUT.VERSION = "Phiên bản：V{1}"
L.ABOUT.FANS = "Fanpage:\n" .. appconfig.FANS_URL
L.ABOUT.SERVICE = "Điều khoản sử dụng"
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "Nhiệm vụ"
L.DAILY_TASK.SIGN = "Điểm danh"
L.DAILY_TASK.GO_TO = "Đến"
L.DAILY_TASK.GET_REWARD = "Nhận thưởng"
L.DAILY_TASK.HAD_FINISH = "Đã hoàn thành"
L.DAILY_TASK.TAB_TEXT = {
	"Nhiệm vụ",
	"Thành tựu"
}

-- count down box
L.COUNTDOWNBOX.TITLE = "Đếm ngược thời gian rương quà"
L.COUNTDOWNBOX.SITDOWN = "Ngồi xuống mới tính vào thời gian."
L.COUNTDOWNBOX.FINISHED = "Hôm nay bạn đã nhận hết rương quà,ngay mai nhận tiếp nhé."
L.COUNTDOWNBOX.NEEDTIME = "Chơi tiếp{1}phút{2}giây,bạn sẽ nhận được {3}." 
L.COUNTDOWNBOX.REWARD = "Chúc mừng bạn nhận được rương quà{1}"
L.COUNTDOWNBOX.TIPS = "Mời bạn bè vào ván chơi thành công,phần thưởng sẽ nhân đôi nhé"

-- act
L.NEWESTACT.NO_ACT = "Chưa có sự kiện"
L.NEWESTACT.LOADING = "Đang tải ảnh,vui lòng chờ..."
L.NEWESTACT.TITLE = "Sự kiện"

--feed
L.FEED.SHARE_SUCCESS = "Chia sẻ thành công"
L.FEED.SHARE_FAILED = "Chia sẻ thất bại"
L.FEED.NO_CLIENT_TIPS = "Bạn chưa lắp {1},hãy mời bằng cách khác"
L.FEED.COPY_TIPS = "Copy nội dung chia sẽ,bạn hãy dán vào phần mềm khác gửi cho bạn bè nhé"
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
	name = "Tôi nhận được {1} trong vòng quan may mắn của open poker,hãy cùng chơi đi！", 
	caption = "Quay vòng quay vui vẻ,100% trúng thưởng",
	link = L.FEED.SHARE_LINK .. "&feed=1",
	picture = appconfig.FEED_PIC_URL.."1.jpg",
	message = "",
}
L.FEED.WHEEL_ACT = {
	name = "Cùng quay vòng quay may mắn với tôi đi,đăng nhập mỗi ngày sẽ được quay ba lần !",
	caption = "Quay vòng quay vui vẻ,100% trúng thưởng",
	link = L.FEED.SHARE_LINK .. "&feed=2",
	picture = appconfig.FEED_PIC_URL.."2.jpg",
	message = "",
}
L.FEED.LOGIN_REWARD = {
	name = "Hay quá!Tôi nhận được {1} trong vòng quan may mắn của open poker,hãy cùng chơi đi ！",
	caption = "Đăng nhập nhận quà mỗi ngày", 
	link = L.FEED.SHARE_LINK .. "&feed=3",
	picture = appconfig.FEED_PIC_URL.."3.jpg",
	message = "",
}
L.FEED.INVITE_FRIEND = {
	name = "Open poker,poker mới nhất ,hot nhất, bạn bè đều chơi poker này,hãy cùng chơi đi ！",
	caption = "Trò chơi của người thông minh-open poker",
	link = L.FEED.SHARE_LINK .. "&feed=4",
	picture = appconfig.FEED_PIC_URL.."4.jpg",
	message = "",
}
L.FEED.EXCHANGE_CODE = {
	name = "Tôi nhận được {1} với code fanpage open poker,bạn hãy cùng chơi đi！", 
	caption = "Phần thưởng fans, đổi quà hấp dẫn",
	link = L.FEED.SHARE_LINK .. "&feed=5",
	picture = appconfig.FEED_PIC_URL.."5.jpg",
	message = "",
}
L.FEED.COUNT = {
	name = "Qúa tuyệt vời! Tôi nhận được Chips {1} với open poker,muốn khoe chút nào!",
	caption = "Thắng nhiều quá đây",
	link = L.FEED.SHARE_LINK .. "&feed=6",
	picture = appconfig.FEED_PIC_URL.."6.jpg",
	message = "",
}
L.FEED.ACTIVE = {
	name = "Hay quá,mau cùng chơi open poker đi, ngày nào cũng có sự kiện hấp dẫn đây!",
	caption = "Sự kiện {1}",
	link = L.FEED.SHARE_LINK .. "&feed=7",
	picture = appconfig.FEED_PIC_URL.."7.jpg",
	message = "",
}
L.FEED.ACTIVE_DONE = {
	name = "Tôi nhận được {1} trong game open poker,hãy cùng chơi đi！ ", 
	caption = "Sự kiện {1}",
	link = L.FEED.SHARE_LINK .. "&feed=8",
	picture = appconfig.FEED_PIC_URL.."8.jpg",
	message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
	name = "Tôi đã đạt thành tựu{1} trong game open poker,nhận được {2} ,hãy cùng chơi đi ！ ",  
	caption = "{1}",
	link = L.FEED.SHARE_LINK .. "&feed=9",
	picture = appconfig.FEED_PIC_URL.."9.jpg",
	message = "",
}
L.FEED.UPGRADE_REWARD = {
	name = "Hay quá! Tôi mới lên level {1} trong game open poker,nhận được {2} ,mau khâm phục tôi đi！", 
	caption = "Cập nhật nhập thưởng hấp dẫn",
	link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
	picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
	message = "",
}
L.FEED.MATCH_COMPLETE = {
	name = "Tôi giành được giải {2}trong game super poke{1} ,hãy cùng chơi đi！", 
	caption = "Cùng giải đấu đi !",
	link = L.FEED.SHARE_LINK .. "&feed=11",
	picture = appconfig.FEED_PIC_URL.."11.jpg",
	message = "",
}
L.FEED.RANK_REWARD = {
	name = "Hay quá! Hôm qua tôi nhận được {1} trong game open poker,hãy cùng chơi đi",
	caption = "Lại thắng Chips rồi!",
	link = L.FEED.SHARE_LINK .. "&feed=12",
	picture = appconfig.FEED_PIC_URL.."12.jpg",
	message = "",
}
L.FEED.BIG_POKER = {
	name = "Thật may mắn! Tôi chia được lá bài {1} trong game open poker,game của người thông minh,mau cùng chơi nào!",
	caption = "{1}",--Loại bài
	link = L.FEED.SHARE_LINK .. "&feed=13",
	picture = appconfig.FEED_PIC_URL.."13.jpg",
	message = "",
}
L.FEED.PRIVATE_ROOM = {
	name = "Tôi đã tạo bàn VIP đợi bạn vào chơi trong open poker ,số bàn{1}，mật khẩu{2}，nhấp để vào bàn nhé!",
	caption = "Tạo bàn đánh bài đi",
	link = L.FEED.SHARE_LINK,
	picture = appconfig.FEED_PIC_URL.."7.jpg",
	message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
	name = "Tôi đã tạo bàn VIP đợi bạn vào chơi trong open poker ,mật khẩu{2}，nhấp để vào bàn nhé!",
	caption = "Tạo bàn đánh bài đi",
	link = L.FEED.SHARE_LINK,
	picture = appconfig.FEED_PIC_URL.."7.jpg",
	message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
	name = "Mình đang ở {1} phòng {2} đánh bài, mau đến chiến nào", 
	caption = "Chơi bài nào",
	link = L.FEED.SHARE_LINK,
	picture = appconfig.FEED_PIC_URL.."7.jpg",
	message = "",
}
L.FEED.INVITE_CODE = {
	name =  "Phát hiện một game Poker hay nhất bây giờ,giới thiệu để bạn cùng chơi nào,dowload game ,hãy nhập mã mời {1} của tôi  lúc vào game,sẽ nhận được phần thưởng siêu giá trị.",
	caption = "",
	link = appconfig.INVITE_GIFT_URL,
	picture = appconfig.FEED_PIC_URL.."gift.jpg",
	message = "",
}
L.FEED.INVITE_CODE_REWARD = {
	name = "Rất cảm bạn {1}！Tôi nhận được quà mời bạn với Chips {2} trong open poker,mau cùng chơi bài đi.",
	caption = "Open poker-quà mời bạn miễn phí",
	link = L.FEED.SHARE_LINK .. "&feed=gift",
	picture = appconfig.FEED_PIC_URL.."gift.jpg",
	message = "",
}

-- message
L.MESSAGE.TITLE = "Tin"
L.MESSAGE.TAB_TEXT = {
	"Bạn bè",
	"Hệ thống"
}
L.MESSAGE.EMPTY_PROMPT = "Bạn chưa có lịch sử tin nhắn"
L.MESSAGE.SEND_CHIP = "Tặng lại"
L.MESSAGE.ONE_KEY_GET = "Nhận ngay"
L.MESSAGE.ONE_KEY_GET_AND_SEND = "Nhận ngay và tặng lại"
L.MESSAGE.GET_REWARD_TIPS = "Chúc mừng bạn nhận được{1},tặng {2} cho bạn  thành công"

--奖励兑换码
L.ECODE.TITLE = {
	"Mã mời",
	"Gift Code"
}
L.ECODE.EDITDEFAULT = "Hãy nhập mã Code 6-8 số"
L.ECODE.FANS_DESC = "Theo dõi fanpage có thể nhận code miễn phí để đổi thưởng,chúng tôi sẽ thường xuyên ra mắt các sự kiện hấp dẫn,cảm ơn sử quan tâm của bạn."
L.ECODE.FANS = "Địa chỉ fanpage"
L.ECODE.EXCHANGE = "Đổi thưởng"
L.ECODE.ERROR_FAILED = "Nhập sai code,hãy nhập lại!"
L.ECODE.ERROR_INVALID= "Đổi thưởng thất bại,code của bạn đã mất hiệu quả." 
L.ECODE.ERROR_USED = "Đổi thưởng thất bại, một code chỉ đổi được một lần"
L.ECODE.ERROR_END= "Nhận thưởng thất bại,phần thưởng đã nhận hết,hãy quan tâm chúng tôi để lần sau nhận thưởng sớm nhé"
L.ECODE.FAILED_TIPS = "Đổi thưởng thất bại,hãy thử lại!"
L.ECODE.NO_INPUT_SELF_CODE = "Bạn không thể nhập code của mình,hãy nhập lại sau xác nhận"
L.ECODE.MAX_REWARD_TIPS = "Nhận tối đa"
L.ECODE.INVITE_REWARD_TIPS = [[
1.Gửi mã mời cho bạn bè
2.Bạn bè đăng ký và nhập mã mời của bạn trong 3 ngày, quá hạn sẽ vô hiệu
3.Bạn bè nhận được {2} Quà Tân Thủ, bạn cũng nhận được {1} Chips; Bạn bè mời tiếp người khác bạn lại được {3} Chips
]]
L.ECODE.INVITE_REWARD_RECORD = "Bạn đã mời {1} bạn, nhận được {1} Chips"
L.ECODE.MY_CODE = "Code"
L.ECODE.COPY_CODE = "Copy"
L.ECODE.INVITE_REWARD_TIPS_1 = "Hay quá,nhận thành công"
L.ECODE.INVITE_REWARD_TIPS_2 = "Bạn nhận được phần thường mời bạn với {1}Chips\n Bạn bè của bạn {2},cũng nhận được phần thưởng mời bạn với {3} Chips"
L.ECODE.INVITE_BTN_NAME = "Tôi cũng muốn đi mời bạn"
L.ECODE.INVITE_TIPS = "Chia sẻ mã mời qua các cách dưới đây"
L.ECODE.INVITE_TITLES = {
	"Like Fanpage nhận Gift Code",
	"Gửi mã mời nhận quà tặng"
}

--大转盘 Vòng Quay
L.LUCKTURN.RULE_TEXT = [[
1.Cách một tiếng đồng hồ có thể quay một lần miễn phí
2.Bạn có thể quay một lần với 1 Diamond
3.100% trúng thưởng,ngày nào cũng có Chips miễn phí cho bạn"
]]
L.LUCKTURN.COST_DIAMOND = "Tiêu 1 Diamond"
L.LUCKTURN.BUY_DIAMOND = "Mua Diamond"
L.LUCKTURN.COUNTDOWN_TIPS = "Số lần miễn phí của hôm này đã hết\n bạn có thể quay lại sau {1}  bạn có thể tiêu 1 Diamond để quay một lần"
L.LUCKTURN.LOTTERY_FAILED = "Rút thưởng thất bại,hãy thử lại sau kiểm tra kết nối "
L.LUCKTURN.CHIP_REWARD_TIPS = "{1} trúng:Chips {2}"
L.LUCKTURN.PROPS_REWARD_TIPS = "{1} trúng:Chips {2}"
L.LUCKTURN.VIP_REWARD = "{1} ngày {2} VIP đặc quyền"

--老虎机 Slot
L.SLOT.NOT_ENOUGH_MONEY = "Mua slot thất bại,Chips bạn không đủ"
L.SLOT.NOT_ENOUGH_MIN_MONEY = "Chips bạn không đủ 5000,không thể đặt cược slot,hãy thử lại sau nạp Chips."
L.SLOT.BUY_FAILED = "Mua slot thất bại,hãy thử lại"
L.SLOT.PLAY_WIN = "Bạn thắng {1} Chips"
L.SLOT.TOP_PRIZE = "Player {1} đã trúng thưởng lớn trong slot,nhận được {2} Chips"
L.SLOT.FLASH_TIP = "Jackpot：{1}"
L.SLOT.FLASH_WIN = "Bạn thắng：{1}" 
L.SLOT.AUTO = "Tự động" 
L.SLOT.HELP_TIPS = "Thưởng=Chips cược*Tỷ lệ\nCược càng nhiều thưởng càng cao. Tối đa {1}"

--GIFT
L.GIFT.TITLE = "Quà"
L.GIFT.SET_SELF_BUTTON_LABEL = "Cài đặt thành quà tôi"
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "Mua cho bàn bài x{1}"
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "Quà mà bạn đã chọn"
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "Tặng"
L.GIFT.DATA_LABEL = "Trời"
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "Hãy chọn quà"
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "Mua quà thành công"
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "Mua quà thất bại"
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "Cài đặt quà thành công"
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "Cài đặt quà thất bại"
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "Tặng quà thành công"
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "Tặng quà thất bại"
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "Tặng quà trong ván chơi thành công"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "Tặng quà trong ván chơi thất bại"
L.GIFT.NO_GIFT_TIP = "Chua có quà"
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "Nhấp chọn thì hiện thị quà trong ván chơi"
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "Chips của bạn không đủ, tặng quà thất bại"
L.GIFT.BUY_GIFT_FAIL_TIPS = "Chips của bạn không đủ, mua quà thất bại"
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "Chips của bạn không đủ, tặng quà trong bàn thất bại"
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
	"Hàng hiếm",
	"Thực phẩm" ,
	"Xe đẹp",
	"Bông hoa"
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
	"Tự mua",
	"Player tặng",
	"Tặng đặc biệt",
}

L.GIFT.MAIN_TAB_TEXT = {
	"Quà Shop", 
	"Quà VIP",
	"Quà tôi"
}

-- 破产 Phá Sản
L.CRASH.PROMPT_LABEL = "Bạn nhận được cứu trợ phá sản với {1} Chips,đồng thời nhận được một ưu đãi nạp Chips ,bạn cũng có thể mời bạn để nhận Chips miễn phí."
L.CRASH.THIRD_TIME_LABEL = "Bạn nhận được cứu trợ phá sản lần cuối với {1} Chips,đồng thời nhận được một ưu đãi nạp Chips trong ngày ,bạn cũng có thể mời bạn để nhận Chips miễn phí."
L.CRASH.OTHER_TIME_LABEL = "Bạn đã nhận hết cứu trợ phá sản,sự thắng thua chỉ là chuyện giây phút thôi,cơ hội ưu đãi hiếm đây,hãy nạp ngay để chơi tiếp nhé!"
L.CRASH.TITLE = "Bạn phá sản rồi!"
L.CRASH.REWARD_TIPS = "Phá sản không có vấn đề gì,còn nhận được cứu trơ đây"
L.CRASH.CHIPS = "{1}Chips"
L.CRASH.GET = "Nhận"
L.CRASH.GET_REWARD = "Nhận được {1}Chips"
L.CRASH.GET_REWARD_FAIL = "Nhận Chips thất bại"
L.CRASH.RE_SIT_DOWN = "Ngồi xuống lại"
L.CRASH.PROMPT_LABEL_1 = "Hệ thống tặng bạn cứu trợ phá sản {1} Chips"
L.CRASH.PROMPT_LABEL_2 = "Ưu đãi nạp Chips trong ngày, hãy nạp ngay nhé!"
L.CRASH.PROMPT_LABEL_3 = "Bạn cũng có thể mời bạn bè hoặc ngày mai đăng nhập để nhận nhiều Chips miễn phí nhé"
L.CRASH.PROMPT_LABEL_4 = "Cúng tôi tặng bạn gói quà ưu đãi nạp trong ngày,đừng bỏ lỡ cơ hội nhé"
L.CRASH.PROMPT_LABEL_5 = "Bạn đã nhận hết gói quà phá sản,thắng bại lẽ thường,đừng nản lòng nhé"

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "Đã gửi SMS thành công,đang nạp,xin chờ."
L.E2P_TIPS.NOT_SUPPORT = "Máy bạn không thể thanh toán với easy2pay,hãy nạp bằng cách khác"
L.E2P_TIPS.NOT_OPERATORCODE = "easy2pay tạm không hỗ trợ nhà mạng máy bạn,hãy nạp bằng cách khác nhé"
L.E2P_TIPS.SMS_SENT_FAIL = "Gửi SMS thất bại,hãy kiểm tra số tiền còn lại tài khoản có đủ thanh toán hay không"
L.E2P_TIPS.SMS_TEXT_EMPTY = "Nội dung SMS là trống,hãy nạp cách khác và liên hệ CSKH"
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "Không có người nhận,hãy nạp cách khác và liên hệ CSKH"
L.E2P_TIPS.SMS_NOSIM = "Không có SIM,không thể thanh toán với easy2pay,hãy nạp cách khác "
L.E2P_TIPS.SMS_NO_PRICEPOINT = "Không có người nhận,hãy nạp cách khác và liên hệ CSKH"
L.E2P_TIPS.PURCHASE_TIPS = "Bãn sẽ mua {1},tổng là {2} đồng(không bao gồm 7% VAT),sẽ trừ tiền từ tài khoản điện thoại bạn"
L.E2P_TIPS.BANK_PURCHASE_TIPS = "Bãn sẽ mua {1},tổng là {2} đồng(không bao gồm 7% VAT),sẽ trừ tiền từ thẻ ATM bạn"

-- 比赛场
L.MATCH.MONEY = "Chips"
L.MATCH.JOINMATCHTIPS = "Trận giải đấu mà bạn đã đăng ký sắp bắt đàu,có vào bàn ngay để bắt đầu giải đấu không?"
L.MATCH.JOIN_MATCH_FAIL = "Đăng ký giải đấu thất bạn,hãy đăng ký giải đấu khác đi"
L.MATCH.MATCH_END_TIPS = "Trận giải đấu đã kết thúc,hãy tham gia giải đấu khác nhé!"
L.MATCH.MATCHTIPSCANCEL = "Không hiện thị"
L.MATCH.CHANGING_ROOM_MSG = "Đang đợi bàn khác kết thúc ván"
L.MATCH.MATCH_NAME = "Tên giải đấu"
L.MATCH.MATCH_REWARD = "Phần thưởng"
L.MATCH.MATCH_PLAYER = "Số người"
L.MATCH.MATCH_COST = "Phí đăng ký + dịch vụ"
L.MATCH.REGISTER = "Đăng ký"
L.MATCH.REGISTERING = "Đang \nđăng ký"
L.MATCH.REGISTERING_2 = "Đang đăng ký"
L.MATCH.UNREGISTER = "Hủy \nđăng ký"
L.MATCH.UNREGISTER_2 = "Hủy đăng ký"
L.MATCH.RANKING = "Xếp hạng của bạn"
L.MATCH.REGISTER_COST = "Phí tham số:"
L.MATCH.SERVER_COST = "Phí dịch vụ:"
L.MATCH.TOTAL_MONEY = "Tồng Chips của bạn:"
L.MATCH.MATCH_INFO = "Kết quả ván này"
L.MATCH.START_CHIPS = "Chips bắt đầu:"
L.MATCH.START_BLIND = "Small Blinds bắt đầu :{1}/{2}"
L.MATCH.MATCH_TIME = "Thời gian tham gia giải đấu :{1}"
L.MATCH.RANKING_TITLE = "Thứ tự"
L.MATCH.REWARD_TITLE = "Phần thưởng"
L.MATCH.LEVEL_TITLE = "Cấp bậc"
L.MATCH.BLIND_TITLE = "Bline"
L.MATCH.PRE_BLIND_TITLE = "Đặt cược"
L.MATCH.ADD_BLIND_TITLE = "Thời gian tăng Blinds:{1}"
L.MATCH.RANKING_INFO = "Xếp hạng hiện này {1}"
L.MATCH.SNG_HELP_TITLE = "Quy tắc giải đấu SNG"
L.MATCH.MTT_HELP_TITLE = "Quy tắc giải đấu MTT"
L.MATCH.SNG_RANKING_INFO = "Chips binh quân"
L.MATCH.MTT_RANKING_INFO = "{1}/{2} Chips binh quân : {3}"
L.MATCH.ADD_BLIND_TIME = "Thời gian tăng Blinds:{1}"
L.MATCH.WAIT_MATCH = "Xin chờ bắt đầu"
L.MATCH.ADD_BLIND_TIPS_1 = "Tăng Blinds ván sau"
L.MATCH.ADD_BLIND_TIPS_2 = "Tăng Blinds ván sau đến mức {1}/{2} "
L.MATCH.BACK_HALL = "Thoát"
L.MATCH.PLAY_AGAIN = "Chơi tiếp"
L.MATCH.LEFT_LOOK = "Xem"
L.MATCH.CLOSE = "Tắt"
L.MATCH.REWARD_TIPS = "Bạn nhận được phần thưởng \n{2} của{1}"
L.MATCH.REWARD_PLAYER = "Số người được thưởng"
L.MATCH.MATCH_CUR_TIME = "Thời gian giải đấu"
L.MATCH.CUR_LEVEL_TITLE = "Cấp bậc hiện này :{1}/{2}"
L.MATCH.NEXT_LEVEL_TITLE = "Cấp bậc tiếp theo"
L.MATCH.AVERAGE_CHIPS_TITLE = "Chips binh quân"
L.MATCH.FORMAT_BLIND = "{1}/{2}"
L.MATCH.EXPECT_TIPS = "Coming soon..."
L.MATCH.NOT_ENOUGH_MONEY = "Chips bạn không đủ,hãy thử lại sau mua Chips tại shop"
L.MATCH.PLAYER_NUM_TIPS = "Đợi giải đấu bắt đầu,thiếu {1} người"
L.MATCH.MAINTAIN = "Trận giải đấu đang bảo trì"
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.PLAYER_NUM_TIPS_1 = "Đang chờ bắt đầu, còn thiếu "
L.MATCH.PLAYER_NUM_TIPS_2 = " người"

L.MATCH.REWARD_TEXT = {
	"Bạn hãy quá nhỉ! Hãy chia sẻ để khoe chút đi !", 
	"Không ngờ bạn giỏi đến mức này,hãy chia sẻ cho bạn bè được biết nhé !", 
	"Hay quá,chơi tiếp đi!", 
}
L.MATCH.NO_REWARD_TEXT = {
	"Hãy tiếp tục tiến lên đi!",
	"Thất bại là người mẹ thành công,hãy cố gắng tiếp đi!",
	"Còn chút xíu nữa, lần sau hãy kiên nhẫn thêm chút đi!", 
}
L.MATCH.SNG_RULE = {
	{
		title = "SNG-đủ người thì chơi ngay là gì ?", 
		content = "SNG là Sit and Go,tiếng việt là ngồi đủ người thì bắt đầu ván chơi ngay,đây là chơi chơi giải đấu trong ván của Poker.Trong SNG,người chơi sẽ nhận được Chips để tính toán mà không liên quan đến gold,chỉ được dùng cho ván đang chơi."
	},
	{
		title = "Quy tắc giải đấu SNG:", 
		content = [[
1.Số người tham gia đủ 9 người (hoặc 6 người)thì bắt đầu ván chơi.
2.Người chơi sẽ nhận được Chips để tính toán mà không liên quan đến gold,chỉ được dùng cho trận đang chơi.
3.Trong quá trình chơi SNG không thể tăng gold,thua hết gold thì thoát ra giải đấu
4.Xếp hạng theo thứ tự mà người chơi thoát ra giải đấu,người đầu tiên thua hết gold chính là giải cuối cùng ,cứ tính theo cách này
5.Lúc trong giải đấu chỉ còn lại một người chơi,thì ngưới đó chính là giải nhất 
6.Để nâng cao mức phấn khởi của giải đấu,mức Blinds sẽ được tăng dần trong quá trình giải đấu
]]
	}
}
L.MATCH.MTT_RULE = {
	{
		title = "MTT-trận giải đấu nhiều bàn là gì?", 
		content = "MTT là viết tắt của Multi-Table Tournament,tiếng việt trận giải đấu nhiều bàn, bắt đầu giải đấu với người chơi trong nhiều bàn cùng một số Chips.Theo sự thoát ra của người chơi,số bạn sẽ ngày càng ít. Cuối cùng,chỉ để lại một bàn để tiến hành chung kết." 
	},
	{
		title = "Quy tắc giải đấu MTT:", 
		content = [[
1.Thời gian bắt đầu giải đấu được quy định,khi số người đăng ký ít hơn số người quy định tham gia giải đấu,giải đấu sẽ hủy
2.Người chơi sẽ nhận được Chips để tính toán và chỉ được dùng cho trận đang chơi
3.Đặt cược: trong quá trình giải đấu,sẽ bắt buộc người chơi đặt cược nhất định trước khi bắt đầu mỗi ván,đó chính là đặt cược
4.Mua lại Chips: Sau khi bắt đầu giải đấu với điều kiện được cho phép mua lại Chips ,Trươc cấp bậc blind nào đó,lúc Chips bắt đầu của người chơi là S,người chơi có thể ấn nút mua lại Chips với phí đăng ký để mua số Chips lúc bắt đầu,số lần cho phép mua lại khác nhau trong giải đấu khác nhau.lúc Chips của người chơi là 0 và bị thoát ra giải đấu,cũng cho phép mua lại Chips để chơi lại
5.Mua thêm Chips: Sau khi bắt đầu giải đấu với điều kiện được cho phép mua thêm Chips ,trong thời gian cấp bậc blind nào đó,người chơi có thể ấn nút mua thêm Chips với phí đăng ký để mua số Chips bất kỳ,số lần cho phép mua thêmi khác nhau trong giải đấu khác nhau.lúc Chips của người chơi là 0 và bị thoát ra giải đấu,cũng cho phép mua thêm Chips để chơi lại
6.Xếp hạng theo thứ tự mà người chơi thoát ra giải đấu,người đầu tiên thua hết gold chính là giải cuối cùng ,cứ tính theo cách này.Nếu có 2 người trở lên bị thoát ra cùng một ván thì xếp theo sự mạnh yếu bộ bài ,Chips lúc bắt đầu,bộ bài mạnh được đứng trước,Chips lúc bắt đầu nhiều đước đứng trước
7.Lúc trong giải đấu  chỉ còn lại một người chơi,thì ngưới đó chính là giải nhất 
8.Để nâng cao mức phấn khởi của giải đấu,mức Blinds sẽ được tăng dần trong quá trình giải đấu
]]
	}
}
L.MATCH.TAB_TEXT= {
	"Tóm tắt",
	"Xếp hạng",
	"Blinds",
	"Phần thưởng",
}
L.MATCH.ROOM_TAB_TEXT_1= {
	"Tóm tắt",
	"Tình trạng",
	"Xếp hạng",
	"Blinds",
	"Phần thưởng",
}
L.MATCH.ROOM_TAB_TEXT_2= {
	"Tình trạng",
	"Xếp hạng",
	"Blinds",
	"Phần thưởng",
}

-- 输赢统计
L.WINORLOSE.TITLE = "Chúc Mừng !"
L.WINORLOSE.YING = "Bạn đã thắng"
L.WINORLOSE.CHOUMA = "{1} Chips"
L.WINORLOSE.INFO_1 = "Số ván: {1}"
L.WINORLOSE.INFO_2 = "Ván thắng cao nhất: {1}"
L.WINORLOSE.RATE5 = "Nếu thấy game hay thì hãy Vote cho chúng tôi 5 sao, cảm ơn bạn đã ủng hộ !"
L.WINORLOSE.NOW = "Ủng hộ"
L.WINORLOSE.LATER = "Để sau"
L.WINORLOSE.SHARE = "Chia sẻ"

-- 私人房 
L.PRIVTE.ROOM_NAME = "Bàn VIP "
L.PRIVTE.FINDTITLE = "Tìm bàn"
L.PRIVTE.CREATTITLE = "Tạo bàn"
L.PRIVTE.INPUTROOMIDTIPS = "Hãy nhập số bàn"
L.PRIVTE.ENTERROOM = "Vào ngay"
L.PRIVTE.TYPETIPS = "Sòng thường {1}s/Chơi ngay {2}s"
L.PRIVTE.CREATEROOM = "Chơi ngay"
L.PRIVTE.CREATFREE = "Bắt đầu ván miễn phí"
L.PRIVTE.INPUTPWDTIPS = "Hãy nhập mật khẩu bàn,để trống là không có mật khẩu"
L.PRIVTE.TIMEHOUR = "{1}tiếng"
L.PRIVTE.PWDPOPTIPS = "Hãy nhập mật khẩu có hiệu quả"
L.PRIVTE.PWDPOPTITLE = "Hãy nhập mật khẩu"
L.PRIVTE.PWDPOPINPUT = "Hãy nhập mật khẩu"
L.PRIVTE.NOTIMETIPS = "Thời gian bàn bây giờ còn lại {1}s,sắp giải tán,hãy tạo lại bàn!"
L.PRIVTE.TIMEEND = "Bàn hiện này đã kết thúc và giải tán,hãy trở về đại sảnh để tạo lại bàn nhé!"
L.PRIVTE.ENTERBYID = "Hãy nhập số bàn"
L.PRIVTE.OWNER = "Chủ bàn"
L.PRIVTE.ROOMID = "Số bàn:{1}"
L.PRIVTE.LEFTDAY = "{1} ngày"
L.PRIVTE.LEFTHOUR = "{1} giờ"
L.PRIVTE.LEFTMIN = "{1} phút"
L.PRIVTE.ENTERLOOK =  "Xem"
L.PRIVTE.ENTERPLAY = "VÀO"
L.PRIVTE.ENTEREND = "Đã kết thúc" 
L.PRIVTE.ENTERENDTIPS = "Bàn này đã giải tán,hãy vào bàn khác!"
L.PRIVTE.ENTERCHECK =  "Bạn muốn vào bàn này không ?"
L.PRIVTE.CHECKCREATE = "Chưa có bàn,hãy tạo bàn mới"
L.PRIVTE.ROOMMAXTIPS = "Số bàn bạn tạo đã đến mức giới hạn!"

--活动 
L.ACT.CHRISTMAS_HITRATE = "Tỷ lệ chính xác {1},nhấp liên tục {2}"
L.ACT.CHRISTMAS_HITWIN = "Tốc độ cực nhanh,bạn đã chiến thắng {1} người trong sự kiện"
L.ACT.CHRISTMAS_FEED = {
	name = "Tôi nhận được {1} Chips với tốc độc cực nhanh ,chiến thắng {2} người,có dám đọ sức với tôi không?", 
	caption = "Nhấp quà nhận Chips,100% trúng trưởng",
	link = L.FEED.SHARE_LINK .. "&feed=14",
	picture = appconfig.FEED_PIC_URL.."14.jpg",
	message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "Merry christmas, hãy lắc điện thoại nhận quà đây"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "Happy new year, hãy lắc điện thoại nhận quà đây"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "Phần quà sắp rơi xuống,bạn sẵn sàng để nhấp chưa?"
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "Ngày mai chơi tiếp nhé"

--红黑大战
L.REDBLACK.BET_DOUBLE = "Gấp đôi"
L.REDBLACK.BET_LAST = "Đặt lại"
L.REDBLACK.SELECTED_BET_TIPS = "Hãy đặt cược bên thắng"
L.REDBLACK.SELECTED_BET_END_TIPS = "Cược xong"
L.REDBLACK.START_GAME_TIPS =  "Ván chơi bắt đầu ({1})"
L.REDBLACK.BET_FAILD = "Chips không đủ,đặt cược thất bại"
L.REDBLACK.BET_FAILD_2 = "Chips của bạn không đủ để đặt cược {1}, tự động chuyển đến {2}"
L.REDBLACK.BET_FAILD_TIMES_OUT = "Thời gian cược đã hết, cược thất bại"
L.REDBLACK.BET_LIMIT_TIPS = "Cược thất bại, cược trong ván không vượt quá {1}"
L.REDBLACK.ALL_PLAYER = "Phòng hiện có {1} người"
L.REDBLACK.RECENT_TREND = "Xu hướng: "
L.REDBLACK.TODAY_COUNT = "Hôm nay: "
L.REDBLACK.WIN_LOSE = "Thắng thua"
L.REDBLACK.HAND_CARD = "Hands"
L.REDBLACK.WIN_CARD_TYPE = "Bài thắng"
L.REDBLACK.COUNT_TIPS_1 = "Tượng Vàng: {1}"
L.REDBLACK.COUNT_TIPS_2 = "Tượng Bạc: {1}"
L.REDBLACK.COUNT_TIPS_3 = "Hòa: {1}"
L.REDBLACK.COUNT_TIPS_4 = "Thùng: {1}"
L.REDBLACK.COUNT_TIPS_5 = "Đôi A: {1}"
L.REDBLACK.COUNT_TIPS_6 = "Cù Lũ: {1}"
L.REDBLACK.COUNT_TIPS_7 = "Tứ Quý/Thùng Phá Sảnh Thượng/Thùng Phá Sảnh: {1}"
L.REDBLACK.SUB_TAB_TEXT = {
	"Thắng thua",
	"Quy tắc"
}
L.REDBLACK.RULE = [[
Chọn một bên để cược,  thắng thật nhiều phần thưởng !


Quy Tắc：
1. Mỗi ván sẽ phát bài cho Tượng Vàng và Tượng Bạc, rồi phát 5 lá bài chung, lật ra 1 lá.

2. Người chơi dựa vào thông tin công khai để tiếp tục chọn ủng hộ bên nào.

3. Khi bài chung và bài tay lật ra, dựa vào kết quả, tùy theo số lần thưởng phát thưởng. 


Mỗi ngày đặt cược có giới hạn. Hãy đặt cược một cách hợp lý !
]]

--新手引导
L.TUTORIAL.SETTING_TITLE = "Hướng dẫn tân thủ"
L.TUTORIAL.FIRST_IN_TIPS = [[
Chào mừng đến với Open Poker
Sau đây hãy để Angela hướng dận bạn cách chơi game hot nhất toàn cầu này, nếu bạn đã hiểu luật chơi, hãy bỏ qua hướng dẫn, chưa hiểu thì hãy nhấn để bắt đầu được hướng dẫn nhé.

Hoàn thành hướng dẫn lần đầu còn nhận được 8000 Chips đó!
]]
L.TUTORIAL.FIRST_IN_BTN1 = "Bỏ qua"
L.TUTORIAL.FIRST_IN_BTN2 = "Bắt đầu"  
L.TUTORIAL.END_AWARD_TIPS = "Hoàn thành hướng dẫn nhận Chips" 
L.TUTORIAL.FINISH_AWARD_TIPS = "Chức mừng bạn nhận được gói quà tân thủ với{1}Chips，bạn có thể chọn học lại hoặc bắt đầu ngay"
L.TUTORIAL.FINISH_NOAWARD_TIPS = "Bạn đã là cao thủ chơi Poker rồi đó,bạn có thể chọn học lại hoặc bắt đầu ngay"
L.TUTORIAL.FINISH_FIRST_BTN = "Học lại" 
L.TUTORIAL.FINISH_SECOND_BTN = "Chơi ngay" 
L.TUTORIAL.SKIP = "Bỏ qua" 
L.TUTORIAL.NEXT_STEP = "Tiếp tục"
L.TUTORIAL.GUESS_TRUE_13 = "Bạn đúng rồi,hiện bạn có một đôi(A)，hơi mạnh đó,\n\nnhấp chỗ bất kỳ để tiến hành cược thêm vòng sau"
L.TUTORIAL.GUESS_TRUE_22 = " Bạn đúng rồi đó! Hiện bạn có THÚ(9/A).\n\nnhấp chỗ bất kỳ để tiến hành cược thêm vòng sau"
L.TUTORIAL.GUESS_TRUE_27 = "Bạn đúng rồi,hiện bạn là CÙ LŨ(9/A).\n\nnhấp vị trí bất kỳ để tiến hành cược thêm vòng sau"
L.TUTORIAL.GUESS_FLASE = " Bạn sai rồi,hãy nghĩ kỹ xem nào "
L.TUTORIAL.RE_SELECT = "Chọn lại"
L.TUTORIAL.TIPS = {
	"Thoát menu", 
	"Mua Chips", 
	"Nhấp để xem thông tin người chơi,tặng Chips và sử dụng đạo cụ giao lưu", 
	"Bài chung ", 
	"Bỏ qua hoặc nhấp để mở slot", 
	"Avatar", 
	"Bài tay", 
	"Thao tác", 
	"Nhấp chat gửi stickers" 
}
L.TUTORIAL.ROOM_STEP_1 = "Hoan nghênh đến với Open Poker,lần đầu hoàn thành hướng dẫn sẽ nhận ngay {1} Chips. \n\nnhấp vị trí bất kỳ để tiếp tục nhé" 
L.TUTORIAL.ROOM_STEP_2 = "Ván chơi bắt đầu,Dealer sẽ chia cho mỗi người 2 lá bá bài tay,chỉ có mỗi mình xem được bài.\n\n nhấp vị trí bất kỳ để tiếp tục "
L.TUTORIAL.ROOM_STEP_3 = "Sau đó sẽ lần lượt chia 5 lá bài chung,bài chung là tất cả người chơi đều xem được.\n\nnhấp vị trí bất kỳ để tiếp tục bước tiếp theo"
L.TUTORIAL.ROOM_STEP_4 = "Bộ bài cuối cùng là sự kết hớp bài tay và bài chung được tạo 5 lá bài mạnh nhất,loại bài như sau ( THÙNG PHÁ SẢNH THƯỢNG mạnh nhất -> MẬU yếu nhất)"
L.TUTORIAL.ROOM_STEP_5 = "Bộ bài được tạo mạnh nhất hiện nay là THÙNG PHÁ SẢNH THƯỢNG( 5 lá bài cùng chất 10 J Q K A),chọn bộ bài mạnh nhất.\n\nnhấp vị trí bất kỳ để tiếp tục bước tiếp theo"
L.TUTORIAL.ROOM_STEP_6 = "Bạn đã nắm hết cách chơi chưa?\n Bây giờ hãy bắt đầu ván chơi thực tế nào!\n\nnhấp vị trí bất kỳ để tiếp tục nhé"
L.TUTORIAL.ROOM_STEP_7 = "Đây là khu thao tác để chơi bài,đến lượt bạn,bạn hãy chọn thao tác tương ứng theo nhu cầu.\n\nnhấp vị trí bất kỳ để tiếp tục nhé"
L.TUTORIAL.ROOM_STEP_8 = "Đến lượt bạn đây,bộ bài của bạn cũng được đó!\n\nnhấp nút để cược thêm theo"
L.TUTORIAL.ROOM_STEP_11= "Hai người chơi đó đều là cược thêm theo,chắc bộ bài không tốt đâu,hiện này chia 3 lá bài chung trước nhé.\n\nnhấp vị trí bất kỳ để tiếp tục nhé"
L.TUTORIAL.ROOM_STEP_13= "3 lá bài chung đã chia xong,bạn tạo được bộ bài mới,bạn hãy đoán xem bộ bài của bạn nào?"
L.TUTORIAL.ROOM_STEP_14= "Đến lượt bạn đây,hãy nghĩ xem bước tiếp theo thao tác thế nào,người chơi khác có lẽ là THÙNG (chất nhép),hãy chọn xem bài đi"
L.TUTORIAL.ROOM_STEP_16= "Người chơi {1} chọn cược thêm,chọn cược thêm chắc bộ bài tương đối mạnh ,phải cẩn thận nhé ,hãy đợi xem thôi"
L.TUTORIAL.ROOM_STEP_18= "Người chơi{1} đã chọn úp bỏ,chính là đã thua hết tất cả Chips đã cược thêm, chọn úp bỏ vào lúc bộ bài yếu là hợp lý đó"
L.TUTORIAL.ROOM_STEP_19= "Đến lượt bạn đây,hiện bại cũng mạnh với đôi(A),hay cược thêm để xem lá bài chung thứ 4 nhé"
L.TUTORIAL.ROOM_STEP_22= "4 lá bài chung đã chia xong,bạn đã tạo được bộ bài mới,hãy đoán xem bộ bài bạn là gì?"
L.TUTORIAL.ROOM_STEP_23= "Trong ván chỉ còn lại 2 người chơi,hiện bạn đang có THÚ (A/9),cũng mạnh đó,hãy cược thêm {1} để xem nào"
L.TUTORIAL.ROOM_STEP_25= "{1} chọn cược thêm theo,hiện chia lá bài chung thứ 5 nhé"
L.TUTORIAL.ROOM_STEP_27= "5 lá bài chung đã chia xong,bộ bài cuối cúng của bạn đây,bộ bài cuối cùng là gì nhỉ?"
L.TUTORIAL.ROOM_STEP_29= "{1}tất tay rồi,dự toán bộ bài hơi mạnh đó，nhựng CÙ LŨ(9/A)của bạn cũng tương đối mạnh,theo đi!"
L.TUTORIAL.ROOM_STEP_32= "Mở bài lần cuối đây, {1}là THÙNG，bạn là CÙ LŨ，bạn thắng rồi(CÙ LŨ>THÙNG)！Bạn thắng hết tất cả Chips trong pot！" 
L.TUTORIAL.ROOM_STEP_34= "Đây là yếu tố khác của game ,bạn hãy tự khám phá nhé"

--保险箱
L.SAFE.TITLE = "Két Sắt"
L.SAFE.TAB_TEXT = {
	"Chips",
	"Diamond"
}
L.SAFE.SAVE_MONEY = "Nạp vào"
L.SAFE.GET_MONEY = "Rút ra"
L.SAFE.SET_PASSWORD = "Cài mật khẩu"
L.SAFE.CHANGE_PASSWORD = "Đổi mật khẩu"
L.SAFE.MY_SAFE = "Két sắt của tôi"
L.SAFE.MY_PURSE = "Tiền mang theo"
L.SAFE.SET_PASSWORD_TIPS_1 = "Nhập mật khẩu mới"
L.SAFE.SET_PASSWORD_TIPS_2 = "Nhập lại mật khẩu mới"
L.SAFE.SET_PASSWORD_TIPS_3 = "Hai lần nhập không đồng nhất, hãy thử lại"
L.SAFE.SET_PASSWORD_TIPS_4 = "Mật khẩu không thể để trống"
L.SAFE.SET_PASSWORD_TIPS_5 = "Hãy nhập mật khẩu để mở két"
L.SAFE.FORGET_PASSWORD = "Quên mật khẩu"
L.SAFE.VIP_TIPS_1 = "Bạn không phải VIP, hiện không thể dùng, có muốn trở thành VIP, để được hưởng nhiều quyền lợi."
L.SAFE.VIP_TIPS_2 = "VIP của bạn đã quá hạn, hiện không thể cho vào, có muốn trở thành VIP, để được hưởng nhiều quyền lợi."
L.SAFE.SET_PASSWORD_SUCCESS = "Cài đặt mật khẩu thành công"
L.SAFE.SET_PASSWORD_FAILED = "Cài đặt mật khẩu thất bại, hãy thử lại"
L.SAFE.CHANGE_PASSWORD_SUCCESS = "Đổi mật khẩu thành công"
L.SAFE.CHANGE_PASSWORD_FAILED = "Đổi mật khẩu thất bại, hãy thử lại"
L.SAFE.CHECK_PASSWORD_ERROR = "Mật khẩu sai, hãy thử lại"
L.SAFE.CHECK_PASSWORD_FAILED = "Kiểm chứng mật khẩu thất bại, hãy thử lại"
L.SAFE.SAVE_MONEY_FAILED = "Nạp vào thất bại, hãy thử lãi"
L.SAFE.GET_MONEY_FAILED = "Rút ra thất bại, hãy thử lại"
L.SAFE.INPUT_MONEY_TIPS = "Hãy nhập số lớn hơn 0 để nạp vào"
L.SAFE.SET_EMAIL = "Cài đặt Email bảo mật"
L.SAFE.SET_EMAIL_BTN = "Cài đặt"
L.SAFE.CHANGE_EMAIL_BTN = "Đổi Email"
L.SAFE.SET_EMAIL_TIPS_1 = "Để bảo đảm an toàn cho tài khoản, hãy cố định email hay dùng để chắc chắn nhận được mail. Email có thể dùng để Reset mật khẩu và các thao tác khác.\nLần đầu cố định được tặng 20K Chips."
L.SAFE.SET_EMAIL_TIPS_2 = "Cố định Email thành công"
L.SAFE.SET_EMAIL_TIPS_3 = "Email ví dụ như openpokerxxx@gmail.com"
L.SAFE.SET_EMAIL_TIPS_4 = "Hãy nhập định dạng email chứ xác"
L.SAFE.SET_EMAIL_TIPS_5 = "Bạn chưa cài đặt Email an toàn, sau khi cố định có thể tìm lại mật khẩu qua Email"
L.SAFE.SET_EMAIL_TIPS_6 = "Bạn đã cố định Email: {1}"
L.SAFE.SET_EMAIL_SUCCESS = "Cố định Email thành công"
L.SAFE.SET_EMAIL_TIPS_FAILED = "Cố định Email thất bại, hãy thử lại"
L.SAFE.RESET_PASSWORD_TIPS_1 = "Yêu cầu Reset đã gửi, hãy vào Email để nhấp Link xác thực"
L.SAFE.RESET_PASSWORD_TIPS_2 = "Cài đặt mật khẩu mới, nhấp xác định, hệ thống sẽ gửi Link xác thực đến Email cố định của bạn, trong vòng 5 phút nhấp Link kích hoạt sẽ Reset thành công."
L.SAFE.RESET_PASSWORD_TIPS_3 = "Bạn chưa cố định Email nên không thể dùng chức năng này"
L.SAFE.RESET_PASSWORD_TIPS_4 = "Yêu cầu Reset gửi thất bại, hãy thử lại"
L.SAFE.RESET_PASSWORD = "Reset mật khẩu"
L.SAFE.CLEAN_PASSWORD = "Xóa mật khẩu"
L.SAFE.CLEAN_PASSWORD_SUCCESS = "Xóa mật khẩu thành công"
L.SAFE.CLEAN_PASSWORD_FAILED = "Xóa mật khẩu thất bại, hãy thử lại"

--夺金岛
L.GOLDISLAND.TITLE = "GOLD ISLAND"
L.GOLDISLAND.RULE_BTN = "Quy tắc"
L.GOLDISLAND.BUY_BTN = "Mua vào"
L.GOLDISLAND.ALREADY_BUY = "Đã mua"
L.GOLDISLAND.PRICE = "{1} Chips/lần"
L.GOLDISLAND.AUTO_BUY = "Tự động"
L.GOLDISLAND.BUY_SUCCESS = "Mua vào ván sau thành công"
L.GOLDISLAND.BUY_FAILED = "Chips của bạn không đủ để mua vào ván sau"
L.GOLDISLAND.BUY_TIPS = "Phải ngồi vào bàn rồi mới mua vào ván sau"
L.GOLDISLAND.RULE_TITLE = "Quy tắc Gold Island"
L.GOLDISLAND.RULE_POOL = "Hũ thưởng:"
L.GOLDISLAND.RULE_DESC = [[
1.Ván có Big Blinds lớn hơn 3000 phải ngồi vào bàn mới có thể tham gia Gold Island, phí tham dự mỗi ván là 2000 Chips (Sẽ trừ khi ván bài bắt đầu), số Chips này sẽ dồn vào hũ thưỡng Gold Island.

2.Khi mỗi ván kết thúc, nếu mang loại bài quy định thì sẽ nhận được lượng lớn Chips trong hũ thưởng !

Thùng Phá Sảnh Thượng: Thắng 80% Chips
Thùng Phá Sảnh: Thắng 30% Chips
Tứ Quý: Thắng 10% Chips
   
3.Phải đến lúc 5 lá bài chung lật hết thì mới tính, nếu ai bỏ bài trước hoặc tất cả đều bỏ bài thì ván đó sẽ không tính, người chơi phải chờ đến khi so bài mới được tính thưởng.

4.Nhận thưởng: Hệ thống sẽ tự động thêm Chips thắng cho người chơi.

5.Tham gia: Nhấp vào biểu tưởng Gold Island, sau đó mua vào để tham dự, có thể chọn mua tự động hoặc mua 1 lần.
]]
L.GOLDISLAND.REWARD_TITLE = "Chúc mừng thắng Gold Island"
L.GOLDISLAND.REWARD_BTN = "OK"
L.GOLDISLAND.CARD_TYPE = "Bài của bạn:{1}"
L.GOLDISLAND.REWARD_NUM = "Nhận thưởng {1}% Gold Island:"
L.GOLDISLAND.REWARD_TIPS = "Tiền thưởng đã được phát"
L.GOLDISLAND.BROADCAST_REWARD_TIPS = "Chúc mừng {1} trong Gold Island thắng {2} nhận {3} Chips thưởng !"

return L
