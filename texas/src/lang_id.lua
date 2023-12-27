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
L.TIPS.ERROR_INVITE_FRIEND = "Gagal undang teman" -- 邀请好友失败
L.TIPS.ERROR_TASK_REWARD = "Gagal ambil hadiah tugas" -- 领取任务奖励失败
L.TIPS.ERROR_SEND_FRIEND_CHIP = "Gagal kirim Chips ke teman" -- 送筹码给朋友失败
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "Kirim Chips ke teman error" -- 送朋友给筹码异常
L.TIPS.ERROR_BUY_GIFT = "Gagal kirim hadiah" -- 赠送礼物失败
L.TIPS.ERROR_LOTTER_DRAW = "Gagal ambil hadiah misteri" -- 神秘礼盒领奖失败
L.TIPS.EXCEPTION_LOTTER_DRAW = "Kesempatan Golden Egg tidak cukup" -- 砸金蛋剩余次数不够
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "Gagal masuk room" -- 登录房间失败
L.TIPS.ERROR_LOGIN_FACEBOOK = "Gagal login via FaceBook" -- FaceBook登录失败
L.TIPS.ERROR_LOGIN_FAILED = "Gagal login" -- 登录失败
L.TIPS.ERROR_QUICK_IN = "Gagal dapat info room" -- 获取房间信息失败
L.TIPS.EXCEPTION_QUICK_IN = "Info room error" -- 获取房间信息异常
L.TIPS.ERROR_SEND_FEEDBACK = "Server error atau koneksi lewat waktu, gagal kirim feedback!" -- 服务器错误或网络链接超时，发送反馈失败！
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "Server error, gagal kirim feedback" -- 服务器错误,发送反馈失败
L.TIPS.ERROR_MATCH_FEEDBACK = "Gagal feedback Tournament error" -- 反馈比赛场错误失败
L.TIPS.EXCEPTION_ACT_LIST = "Server error, gagal loading data event" -- 服务器错误，加载活动数据失败
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "Verifikasi sandi : Server error" -- 校验密码：服务器错误
L.TIPS.ERROR_BACK_CHECK_PWD = "Server error atau koneksi lewat waktu, gagal verifikasi sandi" -- 服务器错误或网络链接超时，校验密码失败
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "Gagal upload gambar feedback" -- 反馈图片上传失败！
L.TIPS.ERROR_LEVEL_UP_REWARD = "Server error atau koneksi lewat waktu, gagal ambil hadiah update" -- 服务器错误或网络超时，领取升级奖励失败
L.TIPS.WARN_NO_PERMISSION = "Kamu belum bisa pakai fitur ini, silakan ke otorisasi sistem" -- 您还不能使用此功能，请先到系统授权
L.TIPS.VIP_GIFT = "Pemain VIP baru bisa beli hadiah ini" -- VIP用户才能购买此礼物
L.TIPS.KAOPU_TIPS = "The game failed to initialize. Please try again"
L.TIPS.INPUT_NUMBER = "Please enter the number"
L.TIPS.INPUT_NO_EMPTY = "Input can not be empty"

-- COMMON MODULE
L.COMMON.LEVEL = "Lv: " -- 等级: 
L.COMMON.ASSETS = "${1}" -- ${1}
L.COMMON.CONFIRM = "Yakin" -- 确定
L.COMMON.CANCEL = "Batal" -- 取消
L.COMMON.AGREE = "Setuju" -- 同意
L.COMMON.REJECT = "Tolak" -- 拒绝
L.COMMON.RETRY = "Sambung ulang" -- 重连
L.COMMON.NOTICE = "Tips" -- 温馨提示
L.COMMON.BUY = "Beli" -- 购买
L.COMMON.SEND = "Kirim" -- 发送
L.COMMON.BAD_NETWORK = "Koneksi terputus, silakan periksa koneksi kamu." -- 网络连接中断，请检查您的网络连接是否正常.
L.COMMON.REQUEST_DATA_FAIL = "Koneksi terputus, silakan periksa koneksi kamu, klik tombol untuk sambung ulang." -- 网络连接中断，请检查您的网络连接是否正常，点击重连按钮重新连接。
L.COMMON.ROOM_FULL = "Penonton room ini penuh, silakan ganti room" -- 现在该房间旁观人数过多，请换一个房间
L.COMMON.USER_BANNED = "Akun dibekukan, silakan feedback atau hubungi admin" -- 您的账户被冻结了，请你反馈或联系管理员
L.COMMON.SHARE = "Share" -- 分  享
L.COMMON.GET_REWARD = "Ambil hadiah" -- 领取奖励
L.COMMON.BUY_CHAIP = "Beli" -- 购买
L.COMMON.SYSTEM_BILLBOARD = "Pengumuman Resmi" -- 官方公告
L.COMMON.DELETE = "Hapus" -- 删除
L.COMMON.CHECK = "Cek" -- 查看
L.COMMON.CONGRATULATIONS = "Selamat" -- 恭喜你
L.COMMON.REWARD_TIPS = "Selamat dapat {1}" -- 恭喜您获得了{1}
L.COMMON.GET = "Ambil" -- 领取
L.COMMON.CLICK_GET = "Klik untuk ambil" -- 点击领取
L.COMMON.ALREADY_GET = "Sudah ambil" -- 已领取
L.COMMON.NEXT_GET = "Ambil lain kali" -- 下次领取
L.COMMON.LOGOUT = "Logout" -- 登出
L.COMMON.LOGOUT_DIALOG_TITLE = "Yakin keluar" -- 确认退出登录
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "Chips belum cukup untuk buy in minimal {1}, coba lagi setelah tambah Chips." -- 您的筹码不足最小买入{1},请补充筹码后重试。
L.COMMON.USER_SILENCED_MSG = "Akun dibanned, kamu bisa hubungi admin di Bantuan - Feedback" -- 您的帐号已被禁言，您可以在帮助-反馈里联系管理员处理
L.COMMON.USER_NEED_RELOGIN = "Aksi gagal, coba lagi setelah login ulang, atau hubungi CS" -- 操作失败，请重新登录再试，或者联系客服
L.COMMON.BLIND_BIG_SMALL = "Blind : {1}/{2}" -- 盲注:{1}/{2}
L.COMMON.NOT_ENOUGH_DIAMONDS = "Maaf, Diamond tidak cukup!" -- 对不起，您的钻石不足!
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "Chips tidak cukup, coba lagi setelah isi ulang" -- 您的筹码不足，请充值后重试
L.COMMON.NOT_FINISH = "Undone"

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE = "Yakin keluar" -- 确认退出
L.COMMON.QUIT_DIALOG_MSG = "Yakin keluar game? Aku tidak rela~\\(≧▽≦)/~ " -- 真的确认退出游戏吗？人家好舍不得滴啦~\\(≧▽≦)/~
L.COMMON.QUIT_DIALOG_MSG_A = "Yakin mau keluar game?\n Login besok bisa ambil lebih banyak hadiah lho. " -- 确定要退出了吗?\n明天登录还可以领取更多奖励哦。
L.COMMON.QUIT_DIALOG_CONFIRM = "Tetap keluar" -- 忍痛退出
L.COMMON.QUIT_DIALOG_CANCEL = "Nggak jadi" -- 我点错了
L.COMMON.GAME_NAMES = {
    [1] = "Texas Poker", --德州扑克
    [2] = "Tournament", --比赛场
    [3] = "Omaha", --奥马哈
    [4] = "Baccarat", --德州百人场
    [5] = "ALL-IN", --德州必下场
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "Pemain baru login 3x pertama, bisa dapat hadiah Daftar yang special. \nLogin Facebook dapat hadiah lebih banyak!" -- 新用户前三次登录,可以免费领取超值幸运注册大礼包.\nFaceBook登录用户领取更高奖励哦!
L.LOGIN.FB_LOGIN = "Login akun FB" -- FB账户登录
L.LOGIN.GU_LOGIN = "Login akun game" --游客账户登录
L.LOGIN.REWARD_SUCCEED = "Berhasil ambil hadiah" -- 领取奖励成功
L.LOGIN.REWARD_FAIL = "Gagal ambil" -- 领取失败
L.LOGIN.LOGINING_MSG = "Sedang login game…" -- 正在登录游戏...
L.LOGIN.CANCELLED_MSG = "Login dibatalkan" -- 登录已经取消
L.LOGIN.DOUBLE_LOGIN_MSG = "Akun kamu login di tempat lain" -- 您的账户在其他地方登录
L.LOGIN.LOGIN_DEALING = "Sedang login, mohon tunggu" -- 正在处理登陆,请耐心等待
L.LOGIN.INIT_SDK = "Sedang inisialisasi game, mohon tunggu" -- 游戏正在初始化,请耐心等待

-- HALL MODULE
L.HALL.USER_ONLINE = "Online: {1}" -- 当前在线人数: {1}
L.HALL.INVITE_TITLE = "Undang teman" -- 邀请好友
L.HALL.INVITE_FAIL_SESSION = "Gagal ambil data Facebook, coba lagi" -- 获取Facebook信息失败，请重试
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "Nomor room salah" -- 你输入的房间号码有误
L.HALL.MATCH_NOT_OPEN = "Tournament akan segera dibuka" -- 比赛场将尽快开放
L.HALL.NOT_TRACK_TIPS = "Sedang offline, tidak bisa ikuti" -- 暂不在线,无法追踪
L.HALL.TEXAS_LIMIT_LEVEL = "Belum sampai Lv {1}, naikkan level baru coba lagi!" -- 您的等级不足{1}级，请先玩牌升级后再来!
L.HALL.TEXAS_GUIDE_TIPS_1 = "Kamu sudah Master, jangan main di Arena pemula!" -- 您已经是高手了,不要在新手场虐菜了!
L.HALL.TEXAS_GUIDE_TIPS_2 = "Kamu sudah Master, main di Arena yang sesuai bisa menang lebih banyak." -- 您已经是高手了,可以去适合您的大场赢钱更多.
L.HALL.TEXAS_GUIDE_TIPS_3 = "Selamat! Chips kamu naik tingkat, langsung main di Arena yang lebih tinggi?" -- 恭喜您!您的筹码已经上升到一个新的高度,是否立即换到更高级的场玩牌?
L.HALL.TEXAS_UPGRADE = "Upgrade" -- 立即提升
L.HALL.TEXAS_STILL_ENTER = "Tetap masuk" -- 依旧进入
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
    "Novice", ---初级场
    "Middle", ---中级场
    "Advance",----高级场
}
L.HALL.PLAYER_LIMIT_TEXT = {
    "9\n orang", --9\n人
    "6\n orang" --6\n人
}
L.HALL.CHOOSE_ROOM_TYPE = {
    "Normal", --普通场,
    "Cepat", --快速场
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
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "Min {1} / Max {2}" -- 最小{1}/最大{2}
L.HALL.CHOOSE_ROOM_BLIND = "Blind : {1}/{2}" -- 盲注:{1}/{2}
L.HALL.GIRL_SHORT_CHAT = {
    "Halo, aku Dealer, namaku Ai", -- 你好，我是荷官，我叫小爱。
    "Aku tunggu kamu di room~", -- 我在游戏房间等你哦~
    "Game kami seru, sering main ya.", -- 我们的游戏很好玩的，经常来玩吧。
    "Iih~ sebal~ Kamu ngapain sih?", -- 讨~厌~啦~你在做什么？
    "Say cepat main.", -- 亲爱的快去打牌吧。
    "Suka? Like di Fanpage ya.", -- 喜欢吗？那就去粉丝页点个赞。
    "Kamu lucu, semoga beruntung.", -- 你好可爱，祝你好运。
    "Mmuach~ ~(￣3￣)|~", -- 么么哒~ ~(￣3￣)|~
    "Jangan lupa klik undang teman untuk main! Banyak Chips gratis!", -- 别忘了每天点击邀请好友一起来捧场哦！大量免费筹码赠送！
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "Belum sampai Lv {1}, datang lagi setelah main Texas Poker sampai Lv {2}!" -- 您的等级不足{1}级，请先在德州场玩到{2}级后再来！
L.HALL.OMAHA_HELP_TITLE = "Penjelasan Peraturan Omaha" -- 奥马哈规则说明
L.HALL.OMAHA_RULE = [[
Pemain akan dibagikan 4 kartu Hand, pemain hanya bisa pakai 2 kartu dan menyusun kombinasi kartu terkuat dengan 3 dari 5 Board Card.
Setiap Hand termasuk dalam kombinasi 5 kartu terkuat, besar kecil jenis kartu sama dengan Texas Poker, silakan lihat kiri bawah meja untuk lebih jelas.

Omaha lebih menekankan besar angka di Kartu Hand. Dalam Omaha, nilai Hand sangat penting, Hand bagus sering menang.

Perbedaan Omaha dan Texas Poker
1. Dalam Omaha pemain dibagikan 4 kartu, dalam Texas Poker 2 kartu. 
2. Setiap pemain harus pilih 2 dari 4 kartu dan disusun dengan 3 Board Card untuk membuat kombinasi terbaik. 
3. Pemain Texas Poker maks 22 orang, Omaha maks hanya 11 orang.
]]
L.HALL.TRACE_LIMIT_LEVEL = "Gagal ikuti, bisa masuk room setelah Lv {1}" -- 追踪失败,需要等级达到{1}级,才可以进入房间
L.HALL.TRACE_LIMIT_ANTE = "Gagal ikuti, bisa masuk room dengan bawa {1} Chips" -- 追踪失败,需要携带{1}筹码,才可以进入房间
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
    "Check", -- 看  牌
    "Fold", -- 弃  牌
    "Call", -- 跟  注
    "Raise", -- 加  注
}
L.ROOM.MY_MONEY = "Uangku {1} {2}" -- My money {1} {2}
L.ROOM.INFO_UID = "ID {1}" -- ID {1}
L.ROOM.INFO_LEVEL = "Lv.{1}" -- Lv.{1}
L.ROOM.INFO_WIN_RATE = "Menang: {1}%" -- 胜率:  {1}%
L.ROOM.INFO_SEND_CHIPS = "Gratis Chips" -- 赠送筹码
L.ROOM.ADD_FRIEND = "Follow" -- 关注
L.ROOM.DEL_FRIEND = "Batal Follow" -- 取消关注
L.ROOM.FORBID_CHAT = "Block" -- 屏蔽
L.ROOM.CANCEL_FORBID_CHAT = "Sudah diblock" -- 已屏蔽
L.ROOM.NO_SEND_CHIP_TIPS = "Tidak bisa kirim" -- 不可赠送
L.ROOM.ADD_FRIEND_SUCC_MSG = "Berhasil tambah teman" -- 添加好友成功
L.ROOM.ADD_FRIEND_FAILED_MSG = "Gagal tambah teman "-- 添加好友失败
L.ROOM.DELE_FRIEND_SUCCESS_MSG = "Berhasil hapus teman" -- 删除好友成功
L.ROOM.DELE_FRIEND_FAIL_MSG = "Gagal hapus teman" -- 删除好友失败
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "Hanya bisa kirim Chips di Arena Normal" -- 只有普通场才可以赠送筹码
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "Chipsmu kurang, tidak cukup untuk tips Dealer" -- 你的筹码不够多，不足给荷官小费
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "Duduk dapat kirim Chips" -- 坐下才可以赠送筹码
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "Chips tidak cukup" -- 钱不够啊
L.ROOM.SEND_CHIP_TOO_OFTEN = "Terlalu sering kirim" -- 赠送的太频繁了
L.ROOM.SEND_CHIP_TOO_MANY = "Terlalu banyak kirim" -- 赠送的太多了
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "Tidak bisa kirim item interaktif di Tournament" --比赛场不能发送互动道具
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = "Duduk dapat kirim item interaktif" -- 坐下才能发送互动道具
L.ROOM.SEND_HDDJ_NOT_ENOUGH = "Item tidak cukup, cepat beli ke Toko" -- 您的互动道具数量不足，赶快去商城购买吧
L.ROOM.SEND_HDDJ_FAILED = "Gagal kirim item, coba lagi" -- 发送互动道具失败,请重试
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = "Duduk dapat kirim emo" -- 坐下才可以发送表情
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "Kamu belum duduk, duduk dan coba lagi" -- 您还未坐下，请坐下后重试
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2} orang)  No room : {3}  Blind : {4}/{5}" -- {1}({2}人)  房间号:{3}  盲注:{4}/{5}
L.ROOM.PRIVATE_ROOM_INFO = "Room private ({1} orang)  No room : {2}  Blind : {3}/{4}" -- 私人房({1}人)  房间号:{2}  盲注:{3}/{4}
L.ROOM.PRIVTE_INFO = "Sisa waktu room : {1}" -- 房间剩余时间：{1}
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "Gagal kirim berita Megafon" -- 发送大喇叭消息失败
L.ROOM.NOT_ENOUGH_LABA = "Megafon tidak cukup" -- 您的大喇叭不足
L.ROOM.CHAT_MAIN_TAB_TEXT = {
    "Berita", -- 消息
    "Catatan Berita" -- 消息记录
}
L.ROOM.USER_CARSH_REWARD_DESC = "Kamu dapat subsidi {1} Chips, hanya 3x kesempatan seumur hidup, gunakan dengan baik" -- 您获得了{1}筹码的破产补助，终身只有三次机会获得，且用且珍惜
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "Kamu juga bisa langsung beli, menang kalah hanya soal waktu" -- 您也可以立即购买，输赢只是转瞬的事
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = "Kamu sudah ambil semua subsidi, bisa beli Chips di Toko, login setiap hari juga ada Chips gratis lho! " -- 您已经领完所有破产补助，您可以去商城购买筹码，每天登录还有免费筹码赠送哦！
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = "Menang kalah sudah biasa, jangan putus asa, langsung beli Chips, coba lagi. " -- 输赢乃兵家常事，不要灰心，立即购买筹码，重整旗鼓。
L.ROOM.WAIT_NEXT_ROUND = "Silakan tunggu ronde berikutnya mulai" -- 请等待下一局开始
L.ROOM.LOGIN_ROOM_FAIL_MSG = "Gagal login room" -- 登录房间失败
L.ROOM.BUYIN_ALL_POT= "Semua Pool" -- 全部奖池
L.ROOM.BUYIN_3QUOT_POT = "3/4 Pool" -- 3/4奖池
L.ROOM.BUYIN_HALF_POT = "1/2 Pool" -- 1/2奖池
L.ROOM.BUYIN_TRIPLE = "Triple" -- 3倍反加
L.ROOM.CHAT_TAB_SHORTCUT = "Template" -- 快捷聊天
L.ROOM.CHAT_TAB_HISTORY = "Riwayat chat" -- 聊天记录
L.ROOM.INPUT_HINT_MSG = "Klik untuk ketik pesan" -- 点击输入聊天内容
L.ROOM.INPUT_ALERT = "Silakan ketik pesan" -- 请输入有效内容
L.ROOM.CHAT_SHIELD = "Berhasil block pesan {1}"  -- 您已成功屏蔽{1}的发言
L.ROOM.CHAT_SHORTCUT = {
  "Halo semua!",  -- 你们好! ,
  "Cepat, tidak sabar lagi ", -- 快点，等不了了
  "ALL IN！！",
  "Terburu-buru tidak baik, tenang", -- 冲动是魔鬼，淡定
  "Hebat sekali", -- 好厉害
  "Siapa berani lawan", -- 谁敢来比比
  "Terima kasih Chips nya", -- 谢谢你送我筹码
  "Main sama kamu seru banget", -- 和你玩牌真有意思
  "Ada Chips", -- 有筹码任性 
  "Hari ini kurang beruntung", -- 今天有点背
  "Jangan ribut", -- 不要吵架 
  "Kamu punya pacar? ", -- 有女/男朋友了吗 
  "Kartunya jelek, coba ganti room", -- 牌不好，换房间试试 
  "Mohon bantuannya", -- 多多关照 
  "Hari ini lumayan beruntung", -- 今天手气不错 
  "Kasih chips dong", -- 送点钱吧
  "Call, ALL-IN!", -- 求跟注，求ALL-IN！
  "Beli Chips dulu baru main!", -- 买点筹码再战！
  "Boleh lihat kartu?", -- 可以看看牌吗
  "Maaf, pergi dulu", -- 不好意思，先走了
}
L.ROOM.VOICE_TOOSHORT = "Rekaman terlalu pendek" -- 录音时间太短了
L.ROOM.VOICE_TOOLONG = "Rekaman terlalu panjang" -- 录音时间太长了
L.ROOM.VOICE_RECORDING = "Sedang rekam, geser keatas untuk batalkan" -- 正在录音，上滑取消
L.ROOM.VOICE_CANCELED = "Rekaman dibatalkan" -- 录音已取消
L.ROOM.VOICE_TOOFAST = "Aksi terlalu sering" -- 您操作太频繁啦
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
    "Terima kasih {1}! Semoga keberuntungan bersamamu!", -- 感谢你{1}！幸运必将常伴你左右！
    "Terima kasih {1}! Keberuntungan akan datang!", -- 感谢你{1}！好运即将到来！
    "Terima kasih {1} yang baik", -- 感谢好心的{1}
}
--买入弹框
L.ROOM.BUY_IN_TITLE = "Buy In Chips" -- 买入筹码
L.ROOM.BUY_IN_BALANCE_TITLE = "Saldo akun:" -- 您的账户余额:
L.ROOM.BUY_IN_MIN = "Min Buy In" -- 最低买入
L.ROOM.BUY_IN_MAX = "Maks Buy In" -- 最高买入
L.ROOM.BUY_IN_AUTO = "Saat lebih kecil dari Big Blind otomatis Buy In" -- 小于大盲时自动买入
L.ROOM.BUY_IN_AUTO_MIN = "Saat lebih kecil dari Small Blind otomatis Buy In" -- 小于最小买入时自动买入
L.ROOM.BUY_IN_BTN_LABEL = "Duduk Buy In" -- 买入坐下
L.ROOM.ADD_IN_TITLE = "Tambah Chips" -- 增加筹码
L.ROOM.ADD_IN_BTN_LABEL = "Buy In" -- 买 入
L.ROOM.ADD_IN_BTN_TIPS = "Duduk dapat tambah Chips" -- 坐下才能增加筹码
L.ROOM.ADD_IN_BTN_TIPS_2 = "Tidak ada sisa Chips, tidak bisa tambah" -- 没有多余的筹码，无法增加
L.ROOM.ADD_IN_BTN_TIPS_3 = "Chips sudah mencapai batas room, tidak bisa tambah lagi" -- 您的筹码已经达到场次上限，无法增加更多
L.ROOM.ADD_IN_SUC_TIPS = "Berhasil tambah, Chips akan bertambah {1} di ronde berikutnya" -- 增加成功，将在下局开始为您自动增加{1}筹码
L.ROOM.BACK_TO_HALL = "Kembali ke Lobby" -- 返回大厅
L.ROOM.CHANGE_ROOM = "Ganti meja" -- 换  桌
L.ROOM.SETTING = "Setting" -- 设  置
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "Chips kamu tidak mencukupi minimal room ini, klik ganti meja untuk pindah room atau tambah Chips untuk duduk" -- 您的筹码不足当前房间的最小携带，您可以点击换桌系统帮你选择房间或者补足筹码重新坐下。
L.ROOM.AUTO_CHANGE_ROOM = "Ganti meja" -- 换  桌
L.ROOM.USER_INFO_ROOM = "Info Profil" -- 个人信息
L.ROOM.CHARGE_CHIPS = "Tambah Chips" -- 补充筹码
L.ROOM.ENTERING_MSG = "Sedang masuk, mohon tunggu… \n Perlu keberanian untuk jadi pemenang" -- 正在进入，请稍候...\n有识尚需有胆方可成赢家
L.ROOM.OUT_MSG = "Sedang keluar, mohon tunggu…" -- 正在退出，请稍候...
L.ROOM.CHANGING_ROOM_MSG = "Sedang ganti room.." -- 正在更换房间..
L.ROOM.CHANGE_ROOM_FAIL = "Gagal ganti room, coba lagi?" -- 更换房间失败，是否重试？
L.ROOM.STAND_UP_IN_GAME_MSG = "Kamu masih di ronde ini, yakin berdiri?" -- 您还在当前牌局中，确认站起吗？
L.ROOM.LEAVE_IN_GAME_MSG = "Kamu masih di ronde ini, yakin keluar?" -- 您还在当前牌局中，确认要离开吗？
L.ROOM.RECONNECT_MSG = "Sedang menyambung ulang.." -- 正在重新连接..
L.ROOM.OPR_STATUS = {
    "Fold", -- 弃  牌
    "ALL_IN",
    "Call", -- 跟  注
    "Call {1}", -- 跟注 {1}
    "Small Blind", -- 小  盲
    "Big Blind", -- 大  盲
    "Check", -- 看  牌
    "Raise {1}", -- 加注 {1}
    "Raise", -- 加  注
}
L.ROOM.AUTO_CHECK = "Auto Check" -- 自动看牌
L.ROOM.AUTO_CHECK_OR_FOLD = "Check/Fold" -- 看或弃
L.ROOM.AUTO_FOLD = "Auto Fold" -- 自动弃牌
L.ROOM.AUTO_CALL_ANY = "Call apapun" -- 跟任何注
L.ROOM.FOLD = "Fold" -- 弃  牌
L.ROOM.ALL_IN = "ALL IN"
L.ROOM.CALL = "Call" -- 跟  注
L.ROOM.CALL_NUM = "Call {1}" -- 跟注 {1}
L.ROOM.SMALL_BLIND = "Small Blind" -- 小盲
L.ROOM.BIG_BLIND = "Big Blind" -- 大盲
L.ROOM.RAISE = "Raise" -- 加  注
L.ROOM.RAISE_NUM = "Raise {1}" -- 加注 {1}
L.ROOM.CHECK = "Check" -- 看  牌
L.ROOM.BLIND3 = "3x Big Blind" -- 3x大盲
L.ROOM.BLIND4 = "4x Big Blind" -- 4x大盲
L.ROOM.TABLECHIPS = "1x Pool" -- 1x底池
L.ROOM.TIPS = {
    "Tips : Klik foto profil atau gender akun tamu untuk ubah foto dan gender", -- 小提示：游客用户点击自己的头像弹框或者性别标志可更换头像和性别哦
    "Pengalaman : Saat kartumu lebih kecil dari lawan, kamu akan kehilangan Chips yang dipasang Bet", -- 小经验：当你牌比对方小的时候，你会输掉已经押上的所有筹码
    "Jadi master: Semua master adalah Rookie Texas Poker sebelum jago bermain", -- 高手养成：所有的高手，在他会德州游戏之前，一定是一个德州游戏的菜鸟
    "Punya kartu bagus harus raise, ambil kesempatan, serang duluan.", -- 有了好牌要加注，要掌握优势，主动进攻。
    "Amati lawan, jangan tertipu triknya.", -- 留意观察对手，不要被对手的某些伎俩所欺骗。
    "Ambil inisiatif, supaya kamu ditakuti.", -- 要打出气势，让别人怕你。
    "Kontrol emosi, menangkan kartu yang seharusnya.", -- 控制情绪，赢下该赢的牌。
    "Pemain tamu bisa atur foto profil sesuai keinginan.", -- 游客玩家可以自定义自己的头像。
    "Tips : Bisa setting otomatis duduk saat masuk room di halaman setting.", -- 小提示：设置页可以设置进入房间是否自动买入坐下。
    "Tips : Bisa setting getar di halaman setting.", -- 小提示：设置页可以设置是否震动提醒。
    "Tahan untuk All In berikutnya.", -- 忍是为了下一次All In。
    "Impulsif adalah godaan, mental bagus maka akan beruntung.", -- 冲动是魔鬼，心态好，好运自然来。
    "Saat posisi kurang bagus, coba pindah kursi.", -- 风水不好时，尝试换个位置。
    "Kalah tidak menakutkan, kehilangan percaya diri yang paling menakutkan.", -- 输牌并不可怕，输掉信心才是最可怕的。
    "Kamu tidak bisa mengontrol menang kalah, tapi bisa mengatur menang kalah berapa.", -- 你不能控制输赢，但可以控制输赢的多少。
    "Gunakan item interaktif untuk mengingatkan pemain yang tidak merespon.", -- 用互动道具砸醒长时间不反应的玩家。
    "Nasib tidak selalu beruntung, tapi pengetahuan akan selalu ada seumur hidup.", -- 运气有时好有时坏，知识将伴随你一生。
    "Bluff adalah trik untuk menang, harus bluff dengan cerdas.", -- 诈唬是胜利的一大手段，要有选择性的诈唬。
    "Bet perlu disesuaikan dengan Pool, jangan lihat angka.", -- 下注要结合池底，不要看绝对数字。
    "All In adalah sebuah strategi, tidak mudah menggunakannya.", -- All In是一种战术，用好并不容易。
    








    
}
L.ROOM.SHOW_HANDCARD = "Show Hand" -- 亮出手牌
L.ROOM.SERVER_UPGRADE_MSG = "Sedang update server, mohon tunggu.." -- 服务器正在升级中，请稍候..
L.ROOM.KICKED_BY_ADMIN_MSG = "Kamu sudah dikeluarkan admin dari room ini" -- 您已被管理员踢出该房间
L.ROOM.KICKED_BY_USER_MSG = "Kamu dikeluarkan {1} dari room" -- 您被用户{1}踢出了房间
L.ROOM.TO_BE_KICKED_BY_USER_MSG = "Kamu dikeluarkan {1} dari room, setelah ronde berakhir otomatis kembali ke Lobby" -- 您被用户{1}踢出房间，本局结束之后将自动返回大厅
L.ROOM.BET_LIMIT = "Bet gagal, Bet dalam 1 ronde tidak boleh lebih dari 100M." -- 下注失败，您单局下注不能超过最大下注100M限制。
L.ROOM.BET_LIMIT_1 = "Bet gagal, Bet dalam 1 ronde tidak boleh lebih dari {1}." -- 下注失败，您单局下注不能超过最大下注{1}限制。
L.ROOM.NO_BET_STAND_UP = "Kamu tidak pasang Bet 3 kali, otomatis berdiri" -- 你三局未操作,已自动站起
L.ROOM.PRE_BLIND = "Ante"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "Gagal duduk, IP sama tidak bisa duduk" -- 坐下失败，同一IP不能坐下
T["SEAT_NOT_EMPTY"] = "Gagal duduk, sudah ada pemain lain." -- 坐下失败，该桌位已经有玩家坐下。
T["TOO_RICH"] = "Gagal duduk, banyak Chips masih mau bully pemula?" -- 坐下失败，这么多筹码还来新手场虐人？
T["TOO_POOR"] = "Gagal duduk, Chips kurang untuk masuk room pemula." -- 坐下失败，筹码不足无法进入非新手场房间。
T["NO_OPER"] = "Kamu tidak beraksi lebih dari 3x, otomatis berdiri, duduk lagi untuk mulai ulang" -- 您超过三次没有操作，已被自动站起，重新坐下即可重新开始
L.ROOM.SERVER_STOPPED_MSG = "Sistem sedang maintenance, mohon tunggu" -- 系统正在停服维护, 请耐心等候
L.ROOM.GUIDEHEIGHT = "Ke Arena {1} bisa menang banyak" -- 去{1}场可赢更多钱
L.ROOM.GUIDELOW = "Ke Arena {1} bisa rugi lebih sedikit" -- 去{1}场可以较少损失
L.ROOM.CARD_POWER_DESC = [[
Indikator kartu hanya mengukur menang berdasarkan kartu Hand dan perhitungan Pool, untuk referensi"

Gratis pakai di Arena Pemula, buka VIP apapun bisa pakai di Arena manapun"

Kamu bisa tutup manual, bisa buka lagi di setting"
]]

--STORE
L.STORE.TOP_LIST = {
    "Chips", -- 筹码
    "Diamond", -- 钻石
    "Item", -- 道具
    "VIP"--VIP
}
L.STORE.NOT_SUPPORT_MSG = "Akun kamu tidak mendukung pembayaran" -- 您的账户暂不支持支付
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "Pembayaran berhasil, sedang kirim, mohon tunggu.." -- 已支付成功，正在进行发货，请稍候..
L.STORE.PURCHASE_CANCELED_MSG = "Pembayaran dibatalkan" -- 支付已经取消
L.STORE.PURCHASE_FAILED_MSG = "Pembayaran gagal, coba lagi" -- 支付失败，请重试
L.STORE.PURCHASE_FAILED_MSG_2 = "Masukkan nomor kartu dan sandi yang tepat" -- 请输入正确卡号和密码
L.STORE.PURCHASE_FAILED_MSG_3 = "Kartu ini sudah digunakan" -- 此卡已经使用过
L.STORE.PURCHASE_FAILED_MSG_4 = "Kartu ini tidak berlaku" -- 此卡无效
L.STORE.DELIVERY_FAILED_MSG = "Koneksi gagal, sistem akan coba lagi saat buka Toko berikutnya" --网络故障，系统将在您下次打开商城时重试。
L.STORE.DELIVERY_SUCC_MSG = "Berhasil kirim, terima kasih atas pembeliannya." -- 发货成功，感谢您的购买。
L.STORE.TITLE_STORE = "Toko" -- 商城
L.STORE.TITLE_CHIP = "Chips" -- 筹码
L.STORE.TITLE_PROP = "Item interaktif"-- 互动道具
L.STORE.TITLE_MY_PROP = "Item ku" -- 我的道具
L.STORE.TITLE_HISTORY = "Riwayat beli" -- 购买记录
L.STORE.RATE_DIAMONDS = "1{2}={1} Diamond" -- 1{2}={1}钻石
L.STORE.RATE_CHIP = "1{2}={1} Chips" -- 1{2}={1}筹码
L.STORE.RATE_PROP = "1{2}={1} Item" -- 1{2}={1}个道具
L.STORE.FORMAT_DIAMONDS = "{1}  Diamond" -- {1} 钻石
L.STORE.FORMAT_CHIP = "{1}  Chips" -- {1} 筹码
L.STORE.FORMAT_PROP = "{1}  Item" -- {1} 道具
L.STORE.FORMAT_HDDJ = "{1} Item Interaktif" -- {1}互动道具
L.STORE.FORMAT_DLB = "{1} Megafon" -- {1}大喇叭
L.STORE.FORMAT_LPQ = "{1} 礼品券"
L.STORE.FORMAT_DHQ = "{1} 兑换券"
L.STORE.FORMAT_MYB = "{1} 开源币"
L.STORE.HDDJ_DESC = "Bisa gunakan item interaktif {1} kali di meja" -- 可在牌桌上对玩家使用{1}次互动道具
L.STORE.DLB_DESC = "Bisa broadcast {1} kali ke semua pemain di chat meja" -- 可在牌桌聊天弹框对全服的玩家发送{1}次广播
L.STORE.BUY = "Beli" -- 购买
L.STORE.USE = "Pakai" -- 使用
L.STORE.BUY_DESC = "Beli {1}" -- 购买 {1}
L.STORE.RECORD_STATUS = {
    "Sudah order", -- 已下单
    "Sudah kirim", -- 已发货
    "Dikembalikan" -- 已退款
}
L.STORE.NO_PRODUCT_HINT = "Tidak ada stok" -- 暂无商品
L.STORE.NO_BUY_HISTORY_HINT = "Tidak ada riwayat bayar" -- 暂无支付记录
L.STORE.BUSY_PURCHASING_MSG = "Sedang beli, mohon tunggu" -- 正在购买，请稍候..
L.STORE.CARD_INPUT_SUBMIT = "TOP UP" -- TOP UP
L.STORE.BLUEPAY_CHECK = "Yakin pakai {1} beli {2}?" -- 你确定要花{1}购买{2}吗?
L.STORE.GENERATE_ORDERID_FAIL = "Gagal order, coba lagi!" -- 下单失败，请重试！
L.STORE.INPUT_NUM_EMPTY = "Nomor kartu harus diisi, mohon isi!" -- 卡号输入不能为空，请重新输入！
L.STORE.INPUT_PASSWORD_EMPTY = "Sandi harus diisi, mohon isi!" -- 密码输入不能为空，请重新输入！
L.STORE.INPUT_NUM_PASSWORD_EMPTY = "Nomor kartu atau sandi kosong, mohon isi!" -- 卡号或密码输入为空，请重新输入！
L.STORE.INPUT_CRAD_NUM = "Masukkan nomor kartu" -- 请输入卡号
L.STORE.INPUT_CRAD_PASSWORD = "Masukkan sandi" -- 请输入密码
L.STORE.QUICK_MORE = "Lihat lainnya" -- 查看更多
L.STORE.REAL_TAB_LIST = {
    "Tiket Hadiah", -- 礼品券
    "Tiket Tukar", -- 兑换券
    "Ant Coin", -- 开源币
}
L.STORE.REAL_ADDRESS_BTN = "Alamat penerima" -- 收货地址
L.STORE.REAL_EXCHANGE_BTN = "Tukar" -- 兑换
L.STORE.ADDRESS_POP_TITLE = "Ubah alamat penerima" -- 编辑收货地址
L.STORE.REAL_TIPS = "Mohon masukkan nama dan kontak asli, untuk memudahkan pengiriman hadiah" -- 请务必填写真实姓名和联系方式,以便获奖后联系
L.STORE.REAL_TIPS_2 = "Mohon isi data lengkap" -- 请把信息填写完整
L.STORE.REAL_SAVE = "Simpan" -- 保存
L.STORE.REAL_TITLES = {
    "Nama penerima: ", -- 收货人:
    "No HP: ", -- 手机号码:
    "Alamat: ", -- 收货地址:
    "Kodepos: ", -- 邮编:
    "Email: ", -- 电子邮箱:
}
L.STORE.REAL_PLACEHOLDER = {
    "Nama :", -- 姓名
    "No HP :", -- 手机号码
    "Mohon isi lengkap nama jalan. kota. provinsi", -- 请务必填写详细的省.市.区(县)及街道门牌信息
    "Kodepos", -- 邮编
    "Email", -- 邮箱地址
}
L.STORE.EXCHANGE_REAL_SUCCESS = "Selamat, berhasil tukar {1}, kami akan proses pengiriman! " --恭喜您,兑换{1}成功,我们会尽快给您发货!
L.STORE.EXCHANGE_REAL_FAILED_1 = "Jumlah {1} tidak cukup, tukar {2} butuh {3}" -- 你的{1}数量不足,兑换{2}需要{3}
L.STORE.EXCHANGE_REAL_FAILED_2 = "Gagal tukar, coba lagi!" -- 兑换失败,请重试!
L.STORE.TAB_LIST = {
    "Toko", -- 商城
    "Tukar hadiah" -- 礼品兑换
}
L.STORE.CASH_CARD_TITLE = "Tukar kartu top up" -- 兑换充值卡
L.STORE.CASH_CARD_TIPS_1 = "Masukkan no HP yang berlaku. \n Kami akan mengirimkan info kartu top up ke HP." -- 请输入您的手机号码,务必真实有效的.\n我们将把充值卡的信息,发送到您填写的手机上.
L.STORE.CASH_CARD_TIPS_2 = "Masukkan no HP" -- 请输入您的手机号码
L.STORE.CASH_CARD_TIPS_3 = "Masukkan 10 digit no telepon" -- 请输入10位由数字组成的电话号码
L.STORE.CASH_CARD_TIPS_4 = "Nomor yang kamu masukkan {1}-{2}-{3}, kami akan mengirimkan info kartu top up ke nomor ini. " -- 您输入的电话号码是{1}-{2}-{3},我们将向此号码发送充值卡的信息.

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "Chips diluar Arena kurang dari 5000, tidak bisa pakai Emo VIP" --您的场外筹码不足5000，暂时无法使用VIP表情
L.VIP.SEND_EXPRESSIONS_TIPS = "Kamu belum VIP, pakai emo VIP akan memakai Chips, jadi VIP langsung pakai gratis, dan masih banyak keuntungan lainnya." -- 您还不是VIP用户,使用VIP表情需要扣除相应的筹码,成为VIP即可免费使用,还有超多优惠和特权.
L.VIP.BUY_PROP = "Beli item" -- 购买道具
L.VIP.OPEN_VIP = "Jadi VIP" -- 成为VIP
L.VIP.COST_CHIPS = "Pakai {1} Chips" -- 花费{1}筹码
L.VIP.LIST_TITLE = {
    "Harga", -- 价格
    -- "Kartu kick", -- 踢人卡
    "Indikator kartu VIP", -- VIP牌力指示器
    "Hadiah VIP", -- VIP礼物
    "Item VIP", -- VIP道具
    "Emo VIP", -- VIP表情
    -- "Diskon Room private", -- 私人房折扣
    -- "Bangkrut", -- 破产优惠
    -- "EXP", -- 经验
    "Login tiap hari", -- 每天登录
    "Langsung dapat Chips", -- 立即赠送筹码
}
L.VIP.NOT_VIP = "Belum beli" -- 未购买
L.VIP.AVAILABLE_DAYS = "Tinggal {1} hari" -- 剩余{1}天
L.VIP.OPEN_BTN = "Buka {1} Diamond" -- 开通{1}钻石
L.VIP.AGAIN_BTN = "Lanjut bayar {1} Diamond" -- 续费{1}钻石
L.VIP.CONTINUE_BUY = "Lanjut beli" -- 继续购买
L.VIP.BROKE_REWARD = "Dapat lebih {1}% sehari {2} kali" --多送{1}% 每天{2}次
L.VIP.LOGINREWARD = "{1}*31hari" -- {1}*31天
L.VIP.PRIVATE_SALE = "Diskon {1}%" -- 优惠{1}%
L.VIP.SEND_PROPS_TIPS_1 = "Gratis pakai item interaktif VIP" -- 互动道具VIP免费任意使用
L.VIP.SEND_PROPS_TIPS_2 = "Item interaktif kamu habis, kamu bisa beli dengan Chips, jadi VIP bisa pakai gratis, dan banyak keuntungan lainnya." -- 您的互动道具已用完,您可以选择花费筹码使用,成为VIP即可免费使用,还有超多优惠和特权.
-- L.VIP.KICK_CARD = "Kartu kick" -- 踢人卡
-- L.VIP.KICK_SUCC = "Berhasil kick, pemain akan keluar setelah ronde ini." -- 踢人成功，玩家将在本局结束后被提出牌桌。
-- L.VIP.KICK_FAILED = "Gagal kick, coba lagi nanti" -- 踢人失败,请稍后重试
-- L.VIP.KICKED_TIP = "Maaf, kamu di kick {1} , kamu akan keluar setelah ronde ini." -- 抱歉，您被玩家{1}踢出牌局，将在本局结束后离开此牌桌。
-- L.VIP.KICKER_TOO_MUCH = "Jumlah kick hari ini habis, mohon ikuti aturan, jangan sembarangan kick." -- 您当天的使用次数已达到上限，请遵守牌桌秩序，严禁恶意踢人。
-- L.VIP.KICKED_ENTER_AGAIN = "Kamu dikeluarkan dari room, tidak bisa masuk dalam 20 menit, kamu bisa pilih room lain atau langsung mulai lagi" -- 您已被踢出此房间，20分钟内无法进入，你可以选择其他房间或者重新快速开始
L.VIP.BUY_SUCCESS = "Selamat, beli VIP berhasil!" -- 恭喜你,购买VIP成功!
L.VIP.BUY_FAILED = "Beli VIP gagal, coba lagi" -- VIP购买失败,请重试
L.VIP.BUY_FAILED_TIPS = "Diamond tidak cukup, silakan beli!" -- 您的钻石不足,请先购买钻石!
L.VIP.BUY_TIPS_1 = "Kamu akan beli {1}, pakai {2} Diamond." -- 您将购买{1},需要花费{2}钻石.
L.VIP.BUY_TIPS_2 = "Saat ini VIP {1} masih berlaku, kalau lanjut beli, akan kehilangan fitur VIP {2} dan menjadi VIP {3}, lanjut?" -- 您目前是{1}VIP还未到期,如果您选择继续购买,将放弃现在的{2}VIP的所有特权并立即成为{3}VIP,是否继续?
L.VIP.BUY_TIPS_3 = "Saat ini kamu VIP {1}, akan ada biaya lanjutan VIP ini, masa berlaku diperpanjang {2} hari, pakai {3} Diamond." -- 您现在是{1}VIP,将对此等级VIP服务进行续费,使用期限延长{2}天,需要花费{3}钻石.
L.VIP.LEVEL_NAME = {
    "Lord", -- 领主
    "Noble", -- 贵族
    "King", -- 王族
    "Royal" -- 皇族
}
L.VIP.NO_VIP_TIPS = "Kamu belum VIP, langsung jadi VIP untuk dapat banyak keuntungan?" -- 您还不是VIP用户,是否立即成为VIP,还有超多优惠和特权.
L.VIP.CARD_POWER_TIPS = "Kamu belum VIP," -- 您还不是VIP用户,是否
L.VIP.CARD_POWER_OPEN_VIP = "Langsung aktivasi" -- 立即开通
L.VIP.VIP_AVATAR = "Foto Gerak VIP" -- VIP动态头像
L.VIP.NOR_AVATAR = "Foto biasa" -- 普通头像
L.VIP.SET_AVATAR_SUCCESS = "Berhasil atur foto!" -- 设置头像成功!
L.VIP.SET_AVATAR_FAILED_1 = "Gagal atur foto, coba lagi." -- 设置头像失败,请重试.
L.VIP.SET_AVATAR_FAILED_2 = "Lv VIP belum cukup, pilih foto lain." -- 您的VIP等级不够,请选择其他头像.
L.VIP.SET_AVATAR_TIPS = [[
Kamu belum VIP, hanya bisa lihat tampilan foto, jadi VIP untuk pakai foto khusus VIP, aktivasi VIP bisa dapat banyak Chips, diskon Top up dll.

Langsung aktivasi VIP?
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "Dapat dengan login Facebook" -- Facebook登录领取
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}" -- {1}x200%={2}
L.LOGINREWARD.REWARD_BTN        = "Ambil {1}" -- 领取{1}
L.LOGINREWARD.GET_REWARD_FAILED = "Gagal absen, coba lagi!" -- 签到失败，请重试!
L.LOGINREWARD.VIP_REWARD_TIPS   = "Hadiah login VIP" -- VIP登录奖励

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2} Poin EXP" -- {1}/{2} 经验值
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
    "Arena Reguler", -- 常规场
    "SNG", -- 坐满即玩
    "MTT" -- 锦标赛
}
L.USERINFO.BOARD_SORT = {
    "Urutan waktu", -- 时间排序
    "Urutan menang kalah" -- 输赢排序
}
L.USERINFO.NO_RECORD = "Tidak ada catatan" -- 暂无记录
L.USERINFO.LAST_GAME = "Ronde sebelumnya" -- 上一局
L.USERINFO.NEXT_GAME = "Ronde berikutnya" -- 下一局
L.USERINFO.PLAY_TOTOAL_COUNT = "Ronde :" -- 牌局: 
L.USERINFO.PLAY_START_RATE = "Gabung :" -- 入局率: 
L.USERINFO.WIN_TOTAL_RATE = "Menang :" -- 胜率: 
L.USERINFO.SHOW_CARD_RATE = "Showdown :" -- 摊牌率: 
L.USERINFO.MAX_CARD_TYPE = "Kartu Terkuat :" -- 最大牌型
L.USERINFO.JOIN_MATCH_NUM = "Jumlah Tanding :" -- 参赛次数
L.USERINFO.GET_REWARD_NUM = "Jumlah dapat hadiah :" -- 获奖次数
L.USERINFO.MATCH_BEST_SCORE = "Hasil terbaik MTT :" -- 锦标赛最好成绩
L.USERINFO.MY_CUP = "Pialaku" -- 我的奖杯
L.USERINFO.NO_CHECK_LINE = "Belum isi" -- 未填写
L.USERINFO.BOARD = "Catatan Ronde" -- 牌局记录
L.USERINFO.MY_PACK = "Tasku" -- 我的背包
L.USERINFO.ACHIEVEMENT_TITLE = "Achievement" -- 成就
L.USERINFO.REAL_STORE = "Tiket hadiah" -- 礼品兑换
L.USERINFO.LINE_CHECK_NO_EMPTY = "Line ID harus diisi! Masukkan ulang" -- Line号不能为空！请重新输入
L.USERINFO.NICK_NO_EMPTY = "Nama harus diisi! Masukkan ulang" -- 名字不能为空！请重新输入
L.USERINFO.LINE_CHECK_ONECE = "Hanya bisa otentikasi Line sekali per hari" -- 一天只能提交一次Line认证
L.USERINFO.LINE_CHECK_FAIL = "Otentikasi gagal, coba lagi!" -- 提交认证失败，请重试!
L.USERINFO.LINE_CHECK_SUCCESS = "Otentikasi berhasil" -- 提交认证成功
L.USERINFO.GET_BOARD_RECORD_FAIL = "Gagal dapat info Battle pribadi, tutup jendela dan coba lagi!" -- 获取个人战绩信息失败，请关闭弹窗重试！
L.USERINFO.PACKAGE_INFO = {
    {
        title = "Item interaktif", -- 互动道具
        desc = "Item yang bisa dikirimkan ke pemain lain di meja" -- 可以在牌桌上对其他玩家释放的互动道具
    },
    {
        title = "Megafon", -- 大喇叭
        desc = "Bisa broadcast ke semua pemain di meja" -- 可以在牌桌上对全服的玩家进行广播
    },
    {
        title = "Kupon tukar", -- 兑换券
        desc = "Bisa langsung tukar hadiah tertentu" -- 可直接兑换券上相应的礼品
    },
    {
        title = "Kupon hadiah", -- 礼品券
        desc = "Bisa tukar beberapa kupon dengan hadiah" -- 可花费多张劵兑换相应的礼品
    },
    {
        title = "Ant Coin", -- 开源币
        desc = "Coin digital yang sangat berharga" -- 非常有价值的一种数字货币
    },
}
L.USERINFO.MARK_TEXT = {
    "Call Station", -- 跟注站
    "Crazy", -- 疯子
    "Aggressive Type", -- 紧凶型
    "Weak Type", -- 紧弱型
    "Rock Type", -- 岩石型
    "Yellow Alert", -- 黄色警报
    "Weak Fish", -- 松弱鱼
    "Custom" -- 自定义
}
L.USERINFO.MARK_TITLE = "Tandai pemain" -- 标记玩家
L.USERINFO.MARK_TIPS = "Klik tandai pemain" -- 点击选中标记
L.USERINFO.MARK_SUCCESS = "Berhasil tandai pemain" -- 标记玩家成功
L.USERINFO.MARK_FAIL = "Gagal tandai pemain, coba lagi" -- 标记玩家失败，请重试
L.USERINFO.MARK_NO_EMPTY = "Tanda pemain harus diisi, mohon masukkan" -- 玩家标记输入不能为空，请重新输入
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "Tidak ada SD Card, tidak bisa upload profil" -- 没有安装SD卡，无法使用头像上传功能
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "Gagal ambil gambar" -- 获取图像失败
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "Gagal upload profil, coba lagi" -- 上传头像失败，请稍后重试
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "Sedang upload profil, mohon tunggu…" -- 正在上传头像，请稍候...
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "Berhasil upload profil" -- 上传头像成功
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
L.FRIEND.TITLE = "Teman" -- 好友
L.FRIEND.NO_FRIEND_TIP = "Tidak ada teman" -- 暂无好友
L.FRIEND.SEND_CHIP = "Kirim Chips" -- 赠送筹码
L.FRIEND.RECALL_CHIP = "Recall +{1}" -- 召回+{1}
L.FRIEND.ONE_KEY_SEND_CHIP = "Langsung kirim" -- 一键赠送
L.FRIEND.ONE_KEY_RECALL = "Langsung recall" -- 一键召回
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "Chips tidak cukup untuk dikirim, silakan top up lalu coba lagi." -- 您的携带筹码的一半不足全部送出，请先补充筹码后重试。
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "Yakin kirim {2} Chips ke {1} teman?" -- 确定要赠你给您的{1}位好友总计{2}筹码吗？
L.FRIEND.ADD_FULL_TIPS = "Teman kamu sudah sampai batas {1}, sistem akan otomatis hapus teman yang lama tidak main." -- 您的好友已达到{1}的上限，系统将根据玩牌情况删除长久不玩牌的好友。
L.FRIEND.SEND_CHIP_WITH_NUM = "Kirim {1} Chips" -- 赠送{1}筹码
L.FRIEND.SEND_CHIP_SUCCESS = "Berhasil kirim {1} Chips ke teman." -- 您成功给好友赠送了{1}筹码。
L.FRIEND.SEND_CHIP_PUSH = "{1} kirim 10K Chips ke kamu, cepat ambil!" -- {1} 赠送了10K筹码给你，快来领取吧！
L.FRIEND.SEND_CHIP_TOO_POOR = "Chips terlalu sedikit, beli ke Toko dan coba lagi." -- 您的筹码太少了，请去商城购买筹码后重试。
L.FRIEND.SEND_CHIP_COUNT_OUT = "Hari ini kamu sudah kasih Chips ke teman ini, coba lagi besok." --您今天已经给该好友赠送过筹码了，请明天再试。
L.FRIEND.SELECT_ALL = "Pilih semua" -- 全选
L.FRIEND.SELECT_NUM = "Pilih {1} orang" -- 选择{1}人
L.FRIEND.DESELECT_ALL = "Batal pilih" -- 取消选择
L.FRIEND.SEND_INVITE = "Undang" -- 邀请
L.FRIEND.INVITE_SENDED = "Sudah undang" -- 已邀请
L.FRIEND.INVITE_SUBJECT = "Kamu pasti suka" -- 您绝对会喜欢
L.FRIEND.CALL_FRIEND_TO_GAME = "Ayo main! Game seru" -- 来玩牌吧！很好玩的游戏
L.FRIEND.INVITE_CONTENT = "Aku rekomendasi Poker yang seru dan menegangkan, ada 15K Chips untukmu, daftar untuk ambil, ayo main bersama!" ..appconfig.SAHRE_URL -- 为您推荐一个既刺激又有趣的扑克游戏，我给你赠送了15万的筹码礼包，注册即可领取，快来和我一起玩吧！
L.FRIEND.INVITE_SELECT_TIP = "Kamu sudah pilih {1} teman, kirim undangan langsung dapat {2} Chips" -- 您已选择了{1}位好友，发送邀请即可获得{2}筹码的奖励
L.FRIEND.INVITE_SELECT_TIP_1 = "Sudah pilih" -- 您已选择了
L.FRIEND.INVITE_SELECT_TIP_2 = "Teman, undang langsung dapat" -- 位好友，发送邀请即可获得
L.FRIEND.INVITE_SELECT_TIP_3 = "Hadiah Chips" -- 筹码的奖励
L.FRIEND.INVITE_SUCC_TIP = "Berhasil undang, dapat {1} Chips!" -- 成功发送了邀请，获得{1}筹码的奖励！
L.FRIEND.INVITE_SUCC_FULL_TIP = "Berhasil undang, hari ini dapat {1} hadiah." -- 成功发送邀请，今日已获得{1}邀请发送奖励。
L.FRIEND.INVITE_FULL_TIP = "Undang lewat Facebook mencapai batas, kamu bisa undang dengan kode undangan di samping untuk dapat hadiah" -- Facebook邀请已达上限，您可以选择旁边的邀请码邀请获得更多奖励
L.FRIEND.RECALL_SUCC_TIP = "Berhasil kirim hadiah {1}, dapat {2} Chips saat teman online." --  发送成功奖励{1}，好友上线后即可获赠{2}筹码奖励。
L.FRIEND.RECALL_FAILED_TIP = "Gagal kirim, coba lagi" -- 发送失败，请稍后重试.
L.FRIEND.INVITE_LEFT_TIP = "Hari ini masih bisa undang {1} teman!" -- 今天还可以邀请{1}个好友！
L.FRIEND.CANNOT_SEND_MAIL = "Kamu belum atur email, atur sekarang?" -- 您还没有设置邮箱账户，现在去设置吗？
L.FRIEND.CANNOT_SEND_SMS = "Maaf, tidak bisa masuk fitur kirim pesan!" -- 对不起，无法调用发送短信功能！
L.FRIEND.MAIN_TAB_TEXT = {
    "Mengikuti", -- 我关注的
    "Pengikut", -- 关注我的
    "Teman lainnya" -- 更多好友
}
L.FRIEND.INVITE_EMPTY_TIP = "Pilih teman dulu" -- 请先选择好友
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "Temanmu sudah mencapai batas {1}, hapus beberapa baru tambah lagi" -- 您的好友已达到{1}上限，请删除部分后重新添加
L.FRIEND.SEARCH_FRIEND = "Masukkan nama teman FB" -- 请输入FB好友名称
L.FRIEND.INVITE_REWARD_TIPS_1 = "Undang" -- 邀请
L.FRIEND.INVITE_REWARD_TIPS_2 = "teman bisa dapat" -- 位好友可获得
L.FRIEND.INVITE_REWARD_TIPS_3 = ", banyak teman banyak hadiah, saat teman berhasil login akan dapat" -- ,好友越多奖励越多,每位好友成功登录游戏还可以再获得
L.FRIEND.SEARCH = "Cari" -- 查找
L.FRIEND.CLEAR = "Hapus" -- 清除
L.FRIEND.INPUT_USER_ID = "Klik masukkan ID pemain" -- 点击输入玩家ID
L.FRIEND.INPUT_USER_ID_NO_EXIST = "ID tidak ditemukan, masukkan ulang" -- 您输入的ID不存在，请确认后重新输入
L.FRIEND.NO_SEARCH_SELF = "Tidak bisa cari ID sendiri, masukkan ulang" -- 无法查找自己的ID，请重新输入
L.FRIEND.NO_LINE_APP = "Kamu belum install Line, undang dengan cara lain" -- 您没有安装Line应用,请使用其他方式邀请
L.FRIEND.INVITE_REWARD_TIPS = "Ada hadiah besar bila mencapai jumlah undang teman, klik hadiah untuk detil \n kamu berhasil undang {1} teman, dapat {2} Chips" -- 达成邀请人数还有超级大礼包赠送，可点击礼包查看详情\n您累计成功邀请了{1}位好友，获得了{2}的筹码奖励
L.FRIEND.INVITE_FB_FRIEND_TITLE = "Undang teman FB" -- 邀请FB好友
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "Kirim tiap hari dapat {1} \n Berhasil 1 dapat {2} Chips" -- 每天发送就送{1}\n成功一个再送{2}筹码
L.FRIEND.INVITE_CODE_TITLE = "Kode undang" -- 邀请码
L.FRIEND.INVITE_CODE_CONTENT = "Berhasil akan dapat {1} \n Teman dari teman dapat {2}" -- 成功就送{1}\n好友的好友再送{2}
L.FRIEND.GET_REWARD_TIPS_1 = "Selamat kamu dapat hadiah undang!" -- 恭喜您获得了邀请奖励!
L.FRIEND.GET_REWARD_TIPS_2 = "Masih kurang {1} orang untuk dapat hadiah, klik undang untuk lanjut undang teman!" -- 您还差{1}人才能领取奖励，点击邀请按钮继续邀请您的好友吧!
L.FRIEND.ROOM_INVITE_TITLE = "Undang main" -- 邀请打牌
L.FRIEND.ROOM_INVITE_SUCCTIPS = "Undangan terkirim, mohon tunggu" -- 邀请已发出，请耐心等待
L.FRIEND.ROOM_INVITE_TAB = {
    "Sedang online", -- 当前在线
    "Teman" -- 好友
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1} undang kamu main kartu ke {2}{3}" -- {1}邀请您去{2}{3}一起玩牌
L.FRIEND.ROOM_INVITE_PLAY_DES = "Lebih baik bersenang-senang bersama daripada sendiri, klik tombol di bawah untuk mengirim link bermain ke teman atau grup. \n\n Saat teman klik atau refresh akan langsung masuk room." -- 独乐乐不如与众乐乐，您可以点击下面的按钮发送链接发送给好友或者群里邀请大家一起来玩。\n\n好友安装后点击或者刷新页面即可直接进入房间。

-- RANKING MODULE
L.RANKING.TITLE = "Rank" -- 排行榜
L.RANKING.TRACE_PLAYER = "Ikuti pemain" -- 追踪玩家
L.RANKING.GET_REWARD_BTN = "Ambil" -- 领取
L.RANKING.NOT_DATA_TIPS = "Tidak ada data" -- 暂无数据
L.RANKING.NOT_IN_CHIP_RANKING = "Rank kamu : > 20, kamu belum masuk rank, terus semangat!" --您的排名:>20名,您暂时未进入排行榜，请继续加油!
L.RANKING.IN_RANKING = "Rank kamu : {1}, terus berjuang!" -- 您的排名:第{1}名，再接再厉！
L.RANKING.IN_RANKING_NO_1 = "Rank kamu : 1, tidak terkalahkan juga kesepian!" -- 您的排名：第1名，无敌是多么寂寞！
L.RANKING.MAIN_TAB_TEXT = {
    "Rank teman", -- 好友排行
    "Rank dunia", -- 世界排行
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
    "Rank Profit kemarin", -- 昨日盈利榜
    "Rank Harta", -- 财富榜
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
    "Rank Profit kemarin", -- 昨日盈利榜
    "Rank Harta", -- 财富榜
}

-- SETTING MODULE
L.SETTING.TITLE = "Setting" -- 设置
L.SETTING.NICK = "Nama" -- 昵称
L.SETTING.LANGUAGE = "Bahasa" -- 语言
L.SETTING.EXCHANGE = "Kode tukar" -- 兑换码
L.SETTING.LOGOUT = "Logout" -- 登出
L.SETTING.FB_LOGIN = "Login +19999" -- 登录 +19999
L.SETTING.SOUND_VIBRATE = "Suara dan getar" -- 声音和震动
L.SETTING.SOUND = "Suara" -- 声音
L.SETTING.BG_SOUND = "BGM" -- 背景音效
L.SETTING.CHATVOICE = "Efek chat" -- 聊天音效
L.SETTING.VIBRATE = "Getar" -- 震动
L.SETTING.AUTO_SIT = "Masuk room otomatis duduk" -- 进入房间自动坐下
L.SETTING.AUTO_BUYIN = "Saat lebih kecil dari Big Blind otomatis buy in" -- 小于大盲时自动买入
L.SETTING.CARD_POWER = "Indikator kartu" -- 牌力指示器
L.SETTING.APP_STORE_GRADE = "Suka kami, dukung kami" -- 喜欢我们，打分鼓励
L.SETTING.CHECK_VERSION = "Cek versi" -- 检测更新
L.SETTING.CURRENT_VERSION = "Versi saat ini: V{1}" -- 当前版本号：V{1}
L.SETTING.ABOUT = "Tentang" -- 关于
L.SETTING.PUSH_NOTIFY = "Notifikasi" -- 推送通知
L.SETTING.PUSH_TIPS = [[
Sistem akan kirim banyak Chips gratis setiap hari,
siapa cepat dia dapat, setelah buka bisa langsung klik rebut.

Klik tombol yakin, cari manager informasi- buka pengumuman, langsung ambil kode tukar gratis.
]]

--HELP
L.HELP.TITLE = "Bantuan" -- 帮助中心
L.HELP.FANS = "Fanpage Resmi" -- 官方粉丝页
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
    "Pengenalan cara main", -- 玩法介绍
    "Penjelasan istilah", -- 名词解释
    "Penjelasan level", -- 等级说明
    "Masalah", -- 常见问题
    "Feedback", -- 问题反馈
}

L.HELP.PLAY_SUB_TAB_TEXT = {
    "Cara main", -- 玩法说明
    "Aturan adu kartu", -- 比牌规则
    "Penjelasan aksi", -- 操作说明
    "Penjelasan tombol", -- 按钮说明
}

L.HELP.LEVEL_RULE = "Main langsung dapat EXP, di ronde arena normal menang +2, kalah +1, main di arena khusus tidak dapat EXP, misalnya Tournament" -- 玩牌即可获得经验,普通场入局一次赢钱+2, 输钱+1,特殊场次玩牌不加经验,如比赛场
L.HELP.LEVEL_TITLES = {
    "Lv", -- 等级
    "Title", -- 称号
    "EXP", -- 经验
    "Hadiah" -- 奖励
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
    "Masalah pembayaran", -- 支付问题
    "Masalah akun", -- 账号问题
    "Game BUG", -- 游戏BUG
    "Saran Game", -- 游戏建议
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
    "Penjelasan data cara main", -- 玩法数据说明
    "Tipe pemain", -- 玩家类型标注
}

L.HELP.FEED_BACK_SUCCESS = "Feedback berhasil!" -- 反馈成功!
L.HELP.FEED_BACK_FIAL = "Feedback gagal! Coba lagi!" -- 反馈失败!请重试!
L.HELP.UPLOADING_PIC_MSG = "Sedang upload foto, mohon tunggu.." -- 正在上传图片，请稍候..
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "Masukkan isi feedback" -- 请输入反馈内容
L.HELP.MATCH_QUESTION = "FAQ Pertandingan" -- 比赛问题
L.HELP.FAQ = {
    {
        "Chips habis, tapi masih mau main, bagaimana?", -- 我的筹码用完了，但是还想玩，要怎么办？
        "Klik Toko di kanan profil untuk beli Chips." -- 点击头像右侧的商城购买筹码即可。
    },
    {
        "Kenapa tidak bisa kirim Game Coins?", -- 为什么我赠送不了游戏币？
        "Tiap orang hanya bisa kirim 5K Coins per hari di meja, di daftar teman hanya bisa kirim 500 ke tiap teman per hari." -- 在牌桌上每人每天只能赠送五千，在好友列表里每人每天只能赠送五百。
    },
    {
        "Dimana bisa dapat Chips gratis?", -- 在哪里领取免费筹码？
        "Ada hadiah login, hadiah online, hadiah tugas, hadiah fans, hadiah undang teman dll, dan berbagai Event." -- 有登录奖励、在线奖励、任务奖励、粉丝奖励、邀请好友奖励等，还有不同的活动。
    },
      {
        "Bagaimana cara beli Chips?", -- 怎样购买筹码？
        "Klik Toko, pilih Chips yang kamu perlukan." -- 点击商城按钮，然后选择您需要的筹码。
    },
	{
        "Bagaimana menjadi fans?", -- 怎样成为粉丝？
        "Klik setting, ada pilihan Fanpage di bawah, atau klik link"..appconfig.FANS_URL.."/ \nSistem sering mengirimkan fans keuntungan lho~"
    },
	{
        "Bagaimana cara logout?", -- 怎样登出？
        "Klik Setting, pilih logout." -- 点击设置按钮，再选择登出即可。
    },
	{
        "Bagaimana cara ubah nama, profil, dan gender?", -- 怎样改变名字、头像和性别？
        "Klik profil, klik tombol yag diinginkan." -- 点击自己的头像，点击不同功能按钮即可。
    },
	{
        "Apa itu verifikasi Line?", -- line认证是什么？
        "Tambah Line official : OpenPoker, setelah verifikasi tim kerja, Line ID kamu akan muncul di game, untuk lebih mudah tambah teman" -- 添加官方Line号:OpenPoker，经过工作人员认证后，在游戏里显示您正确的line号，方便交到更多朋友
    }
}

L.HELP.PLAY_DESC = {
    "Hand", -- 手牌
    "Board Card", -- 公共牌
    "Kicker", -- 成牌
    "Pemain A", -- 玩家A
    "Pemain B", -- 玩家B
    "Flop", -- 翻牌
    "Turn", -- 转牌
    "River", -- 河牌
    "Full House WIN", -- 葫芦 WIN
    "Two Pair LOSE", -- 两对 LOSE
}

L.HELP.PLAY_DESC_2 = "Saat ronde dimulai, pemain mendapat 2 “kartu dasar”, Dealer akan 3 kali mengeluarkan 5 Board Card. Dari kartu pemain dan Board Card, akan menyusun kombinasi kartu terkuat lalu mengadu dengan pemain lain, menentukan pemenang." -- 在牌局开始的时候，每个玩家分的两张牌作为“底牌”，荷官会分三次连续发出五张公共牌。由每个玩家的底牌和公共牌中选出组合成最大牌型的五张与其他玩家比较，判定胜负。

L.HELP.RULE_DESC = {
    "Royal Flush", -- 皇家同花顺
    "Straigh Flush", -- 同花顺
    "Four of Kind", -- 四条
    "Full House", -- 葫芦
    "Flush", -- 同花
    "Straight", -- 顺子
    "Three of kind", -- 三条
    "Two Pair", -- 两对
    "One Pair", -- 一对
    "High Card", -- 高牌
}
L.COMMON.CARD_TIPS = "Tips jenis kartu" -- 牌型提示
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
    "Straight terkuat dengan lambang sama", -- 同一花色最大的顺子
    "Straight dengan lambang sama", -- 同一花色的顺子
    "4 kartu sama + 1 kartu biasa", -- 4张相同+1单张
    "3 kartu sama + 1 pair", -- 3张相同+1对
    "5 kartu dengan lambang sama", -- 5张牌花色相同
    "Straight dengan lambang berbeda", -- 花色不同的顺子
    "3 kartu sama + 2 kartu biasa", -- 3张相同+2单张
    "2 pair + 1 kartu biasa", -- 2对+1单张
    "1 pair + 3 kartu biasa" ,-- 1对+3单张
    "5 kartu biasa" -- 5个单张牌
}
L.HELP.OPERATING_DESC = {
    "Menu Utama", -- 主菜单
    "Beli Chips", -- 购买筹码
    "Pool + Side", -- 池底+边池
    "Dealer", -- 庄家
    "Board Card", -- 公共牌
    "Kartu dasar", -- 底牌
    "Tips jenis kartu", -- 牌型提示
    "Halaman aksi", -- 操作界面
    "Chips yang dibawa", -- 带入筹码
    "Jenis kartu dan kemungkinan Kicker", -- 牌型大小和成牌概率
    "One Pair", -- 一对
    "Raise", -- 加注
    "Call", -- 跟注
    "Fold", -- 弃牌
}

L.HELP.FEED_BACK_HINT = {
    "Mohon segera masukkan detail pembayaran agar tim kami segera menyelesaikan masalah kamu", -- 请尽可能提供详细的支付信息以方便我们的客服人员快速为您解决问题
    "Mohon berikan ID akun agar kami segera menyelesaikan masalah kamu, ID akun biasanya di bawah profil", -- 请提供您的用户ID以便我们为您解决问题，用户ID一般位于头像下方",
    "Maaf, semua masalahmu akan segera kami atasi", -- 非常抱歉，您提出的任何问题我们都会第一时间给出反馈
    "Kami menyambut saran dan kritik dari kamu, feedback kamu berguna agar kami lebih baik", -- 非常欢迎您对我们提出的任何建议或者意见，您的反馈是我们持续优化的动力
}

L.HELP.PLAY_BTN_DESC = {
    {
        title="Check", -- 看牌
        desc="Pilih “Check” ke orang berikutnya saat tidak ada Bet.", -- 在无人下注的情况下选择把决定“让”给下一位。
        type = 1
    },
    {
        title="Fold", -- 弃牌
        desc="Melepaskan kesempatan lanjut ronde.", -- 放弃继续牌局的机会。
        type = 1
    },
    {
        title="Call", -- 跟注
        desc="Ikut Bet pemain lain", -- 跟随众人押上同等的注额
        type = 1
    },
    {
        title="Raise", -- 加注
        desc="Tambah Bet", -- 把现有的注金抬高
        type = 1
    },
    {
        title="All in", -- 全下
        desc="Bet semua Chips yang dipunya.", -- 一次把手上的筹码全部押上。
        type = 1
    },
    {
        title="Check/Fold", -- 看或弃牌
        desc="Pertama Check, jika perlu bet lagi pilih Fold.", -- 首先看牌，如果需要下注则选择弃牌
        type = 2
    },
    {
        title="Fold", -- 弃牌
        desc="Auto fold", -- 自动弃牌
        type = 2
    },
    {
        title="Ikut Bet apapun", -- 跟任何注
        desc="Pilih ikut Bet apapun", -- 字段选择跟任何注
        type = 2
    },
}

L.HELP.PLAY_DATA_DESC = {
    {
        title="VP", -- 入池率/入局率
        desc="VPIP (disingkat jadi VP) adalah persentase pemain masukkan Chips ke Pool" -- VPIP（通常缩写为VP）是玩家主动向底池中投入筹码的比率。
    },
    {
        title="PFR", -- 翻牌前加注率
        desc="PFR adalah Raise sebelum Flop, persentase pemain raise sebelum Flop." -- PFR 即翻牌前加注，指的是一个玩家翻牌前加注的比率。
    },
    {
        title="AF", -- 激进度
        desc="AF digunakan untuk mengukur nilai agresifitas pemain." --  AF即是用来衡量一个玩家打牌激进程度的数值。
    },
    {
        title="Tambah Raise", -- 再次加注率
        desc="Saat pasang Bet, ada yang tambah Raise setelah Raise, 3 tambahan raise berurutan disebut 3bet." -- 即在他人下注，有人加注之后的再加注，由于是一轮下注中的第三次加注，故称3bet。
    },
    {
        title="Stealing Blinds", -- 偷盲率
        desc="Stealing Blinds adalah pemain yang murni Raise demi menang Blinds." -- Stealing Blinds即偷盲,是指一个玩家单纯的为了赢得盲注而加注。
    },
    {
        title="Cbet", -- 持续下注率
        desc="Cbet adalah terus ikut bet, menunjukkan pemain selalu ikut Bet, setelah Bet atau Raise." -- Cbet即持续下注，是指一个玩家在前一轮主动下注或加注后，在当前这一轮再次主动下注。
    },
    {
        title="WTSD", -- 摊牌率
        desc="WTSD adalah persentase pemain yang melihat Flop dan terus main hingga selesai" -- WTSD即摊牌率，是指一个玩家看到翻牌圈并玩到摊牌的百分比。
    },
    {
        title="BB/100", -- 百手盈利率
        desc="BB/100 : BB adalah singkatan dari Big Blind, digunakan untuk mengukur untung rugi pemain setiap 100 Hand." -- BB/100（百手盈利率）：BB是Big Blind（大盲注）的简称，BB/100用以衡量玩家每玩100手牌局的盈亏。
    },
}

L.HELP.PLAYER_TYPE_DESC = {
    {
        title="Call Station", -- 跟注站
        desc="Hanya bisa Call pasif" -- 只会被动的跟注
    },
    {
        title="Crazy", -- 疯子
        desc="Pemain gila, sering menggertak, sangat agresif" -- 疯狂的玩家，热衷于诈唬，非常激进
    },
    {
        title="Aggressive (Shark)", -- 紧凶型（鲨鱼）
        desc="Sangat sengit dan suka menyerang." -- 玩的很紧且具有一定的攻击性。
    },
    {
        title="Weak (Rat)", -- 紧弱型（老鼠）
        desc="Bermain sengit, nyali kecil, mudah digertak lari" -- 玩的很紧，较胆小，容易被诈唬吓跑的玩家
    },
    {
        title="Rock Type", -- 岩石型
        desc="Sangat sengit dan pasif. Tidak akan ada aksi dari lawan seperti ini" -- 非常紧且被动。你不会在这种对手身上得到太多行动
    },
    {
        title="Yellow Alert", -- 黄色警报
        desc="Terlalu banyak main, sering menganggap kartu sendiri kuat." -- 玩太多牌，而且容易高估自己的牌力。
    },
    {
        title="Weak Fish", -- 松弱鱼
        desc="Terlalu banyak main, tapi pasif setelah Flop" -- 玩太多牌，而翻牌后打法又很被动
    },
}

--UPDATE
L.UPDATE.TITLE = "Menemukan Versi Baru" -- 发现新版本
L.UPDATE.DO_LATER = "Nanti" -- 以后再说
L.UPDATE.UPDATE_NOW = "Update sekarang" -- 立即升级
L.UPDATE.HAD_UPDATED = "Sudah install versi terbaru" -- 您已经安装了最新版本

--ABOUT
L.ABOUT.TITLE = "Tentang" -- 关于
L.ABOUT.UID = "ID pemain : {1}" -- 当前玩家ID: {1}
L.ABOUT.VERSION = "Versi no: V{1}" -- 版本号: V{1}
L.ABOUT.FANS = "Fanpage resmi: \n" .. appconfig.FANS_URL
L.ABOUT.SERVICE = "Ketentuan layanan dan kebijakan privasi" -- 服务条款与隐私策略
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "Tugas" -- 任务
L.DAILY_TASK.SIGN = "Absen" -- 签到
L.DAILY_TASK.GO_TO = "Selesaikan" -- 去完成
L.DAILY_TASK.GET_REWARD = "Ambil hadiah" -- 领取奖励
L.DAILY_TASK.HAD_FINISH = "Selesai" -- 已完成
L.DAILY_TASK.TAB_TEXT = {
    "Tugas", -- 任务
    "Achievement" -- 成就
}

-- count down box
L.COUNTDOWNBOX.TITLE = "Time Chest" -- 倒计时宝箱
L.COUNTDOWNBOX.SITDOWN = "Duduk untuk lanjut hitung mundur." -- 坐下才可以继续计时。
L.COUNTDOWNBOX.FINISHED = "Chest sudah diambil semua hari ini, besok masih ada lho." -- 您今天的宝箱已经全部领取，明天还有哦。
L.COUNTDOWNBOX.NEEDTIME = "Main lagi {1} menit {2} detik, kamu akan dapat {3}." -- 再玩{1}分{2}秒，您将获得{3}。
L.COUNTDOWNBOX.REWARD = "Selamat kamu dapat Chest {1}" -- 恭喜您获得宝箱奖励{1}
L.COUNTDOWNBOX.TIPS = "Berhasil undang teman main \n bisa dapat hadiah berlipat" -- 成功邀请好友进游戏\n可以得到翻倍奖励

-- act
L.NEWESTACT.NO_ACT = "Tidak ada event" -- 暂无活动
L.NEWESTACT.LOADING = "Jangan khawatir, sedang loading gambar.." -- 请您稍安勿躁,图片正在加载中..."
L.NEWESTACT.TITLE = "Event" -- 活动
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
    "Weaving Maid"
}
L.NEWESTACT.HOLIDAY_SHAKE_RANKING = "Ranking"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TIPS = "The Ranking is emptied daily"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_RECORD = "Gift record"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FRIEND = "Friends" 
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_1 = "Weaving Maid ID "
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
L.FEED.SHARE_SUCCESS = "Berhasil share" -- 分享成功
L.FEED.SHARE_FAILED = "Gagal share" -- 分享失败
L.FEED.NO_CLIENT_TIPS = "Kamu belum install app {1}, undang dengan cara lain" -- 您没有安装{1}应用,请使用其他方式邀请
L.FEED.COPY_TIPS = "Konten share sudah disalin, bisa langsung tempel di app lain dan kirim ke teman" -- 分享内容已复制,您可以直接粘贴到其他应用发送给好友
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
    name = "Aku dapat hadiah {1} di Lucky Wheel Open Texas Poker, ayo main bersama!", -- 我在开源德州扑克的幸运转转转获得了{1}的奖励，快来和我一起玩吧！
    caption = "Happy Wheel 100% dapat hadiah", -- 开心转转转100%中奖
    link = L.FEED.SHARE_LINK .. "&feed=1",
    picture = appconfig.FEED_PIC_URL.."1.jpg",
    message = "",
}
L.FEED.WHEEL_ACT = {
    name = "Ayo main Happy Wheel, login tiap hari dapat 3x kesempatan!", -- 快来和我一起玩开心转转转吧，每天登录就有三次机会！
    caption = "Happy Wheel 100% dapat hadiah", -- 开心转转转100%中奖 
    link = L.FEED.SHARE_LINK .. "&feed=2",
    picture = appconfig.FEED_PIC_URL.."2.jpg",
    message = "",
}
L.FEED.LOGIN_REWARD = {
    name = "Hebat! Aku dapat {1} Chips di Open Texas Poker, ayo main bareng!", -- 太棒了!我在开源德州扑克领取了{1}筹码的奖励，快来和我一起玩吧！
    caption = "Selalu ada hadiah login harian", -- 登录奖励天天送不停,
    link = L.FEED.SHARE_LINK .. "&feed=3",
    picture = appconfig.FEED_PIC_URL.."3.jpg",
    message = "",
}
L.FEED.INVITE_FRIEND = {
    name = "Open Texas Poker, game Poker yang heboh saat ini, semua lagi main, ayo gabung!", --开源德州扑克，最新最火爆的德扑游戏，小伙伴们都在玩，快来加入我们一起玩吧！
    caption = "Game orang pintar- Open Texas Poker", -- 聪明人的游戏-开源德州扑克
    link = L.FEED.SHARE_LINK .. "&feed=4",
    picture = appconfig.FEED_PIC_URL.."4.jpg",
    message = "",
}
L.FEED.EXCHANGE_CODE = {
    name = "Aku dapat {1} dengan tukar kode dari Fanpage Open Texas Poker, ayo main bareng!", -- 我用开源德州扑克粉丝页的兑换码换到了{1}的奖励，快来和我一起玩吧！
    caption = "Tukar kode fans dapat hadiah", -- 粉丝奖励兑换有礼
    link = L.FEED.SHARE_LINK .. "&feed=5",
    picture = appconfig.FEED_PIC_URL.."5.jpg",
    message = "",
}
L.FEED.COUNT = {
    name = "Hebat! Aku menang {1} Chips di Open Texas Poker, mau pamer!", -- 太强了！我在开源德州扑克赢得了{1}的筹码，忍不住炫耀一下！
    caption = "Menang banyak", -- 赢了好多啊
    link = L.FEED.SHARE_LINK .. "&feed=6",
    picture = appconfig.FEED_PIC_URL.."6.jpg",
    message = "",
}
L.FEED.ACTIVE = {
    name = "Hebat, ayo main Open Texas Poker denganku, ada event menarik tiap hari!", -- 太棒了，赶紧和我一起加入开源德州扑克吧，精彩活动天天有！
    caption = "Event {1}", -- {1}活动
    link = L.FEED.SHARE_LINK .. "&feed=7",
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.ACTIVE_DONE = {
    name = "Aku dapat {1} di Open Texas Poker, ayo main bersama!", -- 我在开源德州扑克中获得了{1}的奖励，赶快来加入一起玩吧！ 
    caption = "Event {1}", -- {1}活动
    link = L.FEED.SHARE_LINK .. "&feed=8",
    picture = appconfig.FEED_PIC_URL.."8.jpg",
    message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
    name = "Aku menyelesaikan Achievement {1} di Open Texas Poker, dapat {2}, ayo main bersama!", -- 我在开源德州扑克完成了{1}的成就，获得了{2}的奖励，快来和我一起玩吧！ 
    caption = "{1}", -- {1}
    link = L.FEED.SHARE_LINK .. "&feed=9",
    picture = appconfig.FEED_PIC_URL.."9.jpg",
    message = "",
}
L.FEED.UPGRADE_REWARD = {
    name = "Hebat, aku baru berhasil upgrade ke Lv {1} di Open Texas Poker, dapat {2}, buruan main!", -- 太棒了，我刚刚在开源德州扑克成功升到了{1}级，领取了{2}的奖励，快来膜拜吧！
    caption = "Upgrade dapat hadiah besar", -- 升级领取大礼
    link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
    picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
    message = "",
}
L.FEED.MATCH_COMPLETE = {
    name = "Aku dapat rank {2} di Open Texas Poker, ayo main bersama!", -- 我在开源德州扑克{1}中获得第{2}名，赶快来一起玩吧！
    caption = "Ayo tanding!", -- 一起来比赛！
    link = L.FEED.SHARE_LINK .. "&feed=11",
    picture = appconfig.FEED_PIC_URL.."11.jpg",
    message = "",
}
L.FEED.RANK_REWARD = {
    name = "Hebat! Kemarin aku menang {1} Chips di Open Texas Poker, ayo main bersama!", -- 太棒了!我昨天在开源德州扑克里赢得了{1}筹码，快来和我一起玩吧!
    caption = "Menang lagi!", -- 又赢钱了！
    link = L.FEED.SHARE_LINK .. "&feed=12",
    picture = appconfig.FEED_PIC_URL.."12.jpg",
    message = "",
}
L.FEED.BIG_POKER = {
    name = "Sungguh beruntung! Aku mendapat {1} di Open Texas Poker, game orang pintar, ayo main bersama!", -- 手气真好!我在开源德州扑克拿到{1}，聪明人的游戏，快来加入一起玩吧！
    caption = "{1}", --jenis kartu --牌型
    link = L.FEED.SHARE_LINK .. "&feed=13",
    picture = appconfig.FEED_PIC_URL.."13.jpg",
    message = "",
}
L.FEED.PRIVATE_ROOM = {
    name = "Aku tunggu kamu di Room private di Open Texas Poker, room no {1}, sandi {2}, klik untuk masuk!", -- 我在开源德州扑克开好私人房等你来战，房间号{1}，密码{2}，点击立即加入！
    caption = "Buka room", -- 开房打牌了,--jenis kartu --牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
    name = "Aku tunggu kamu di Room private di Open Texas Poker, room no {1}, klik untuk masuk!", -- 我在开源德州扑克开好私人房等你来战，房间号:{1}，点击立即加入！
    caption = "Sudah buka room", -- 开房打牌了",--牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name = "Aku main di {1} room {2}, ayo gabung!", -- 我在{1}房间{2}打牌,速速来战！
    caption = "Main kartu", -- 打牌啦, --jenis kartu --牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.INVITE_CODE = {
    name = "Temukan game paling seru saat ini Super Texas Poker, mari main bersama, unduh game dan masukkan kode undanganku {1} akan dapat hadiah besar.", -- 发现一个目前最好玩的德州扑克游戏，推荐你和我一起玩，下载游戏输入我的邀请码{1}就有特别大奖领取.
    caption = "",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE_REWARD = {
    name = "Terima kasih teman {1}! Aku dapat hadiah undang {2} di Open Texas Poker, ayo main bersama", -- 太感谢好友{1}！我在开源德州获得了{2}筹码的邀请礼包，快来加入我们一起玩吧
    caption = "Open Texas Poker-hadiah undang", -- 开源德州扑克-免费的邀请大礼包
    link = L.FEED.SHARE_LINK .. "&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}

-- message
L.MESSAGE.TITLE = "Berita" -- 消息
L.MESSAGE.TAB_TEXT = {
    "Berita teman", -- 好友消息
    "Berita sistem" -- 系统消息
}
L.MESSAGE.EMPTY_PROMPT = "Tidak ada catatan berita" -- 您现在没有消息记录
L.MESSAGE.SEND_CHIP = "Rebate" -- 回赠
L.MESSAGE.ONE_KEY_GET = "Ambil semua" -- 一键领取
L.MESSAGE.ONE_KEY_GET_AND_SEND = "Ambil dan rebate semua" -- 一键领取并回赠
L.MESSAGE.GET_REWARD_TIPS = "Selamat dapat {1}, berhasil kirim {2} ke teman" -- 恭喜您获得了{1},成功给好友赠送了{2}

--奖励兑换码
L.ECODE.TITLE = {
    "Kode undanganku", -- 我的邀请码
    "Tukar hadiah" -- 奖励兑换
}
L.ECODE.EDITDEFAULT = "Mohon masukkan 6 digit kode tukar atau 8 digit kode undang" -- 请输入6位兑换码或8位邀请码 "mohon masukkan 6-8 digit kode tukar hadiah" -- 请输入6-8位数字奖励兑换码
L.ECODE.FANS_DESC = "Follow fanpage untuk dapat kode tukar hadiah gratis, kami juga akan mengadakan berbagai event menarik, terima kasih atas perhatiannya." -- 关注粉丝页可免费领取奖励兑换码,我们还会不定期在官方粉丝页推出各种精彩活动,谢谢关注。
L.ECODE.FANS = "Alamat Fanpage" -- 粉丝页地址
L.ECODE.EXCHANGE = "Tukar hadiah" -- 兑  奖
L.ECODE.ERROR_FAILED = "Kode salah, masukkan ulang!" -- 兑换码输入错误，请重新输入！
L.ECODE.ERROR_INVALID="Gagal tukar, kode kamu tidak berlaku lagi." -- 兑奖失败，您的兑换码已经失效。
L.ECODE.ERROR_USED = "Gagal tukar, kode hanya bisa digunakan sekali." -- 兑奖失败，每个兑换码只能兑换一次
L.ECODE.ERROR_END= "Gagal ambil, hadiah sudah habis, follow kami agar lain kali tidak kehabisan" --领取失败，本次奖励已经全部领光了，关注我们下次早点来哦
L.ECODE.FAILED_TIPS = "Gagal tukar, coba lagi!" -- 兑奖失败，请重试！
L.ECODE.NO_INPUT_SELF_CODE = "Kamu tidak bisa memasukkan kode sendiri, coba ulang" -- 您不能输入自己的邀请码,请确认后重新输入
L.ECODE.MAX_REWARD_TIPS = "Hadiah maksimal" -- 最大获取
L.ECODE.INVITE_REWARD_TIPS = [[
1.Kirim kode undangan ke teman
2.Info ke teman yang baru daftar untuk memasukkan kode, tidak berlaku setelah 3 hari
Setelah masukkan kode teman akan dapat hadiah {2}, dan kamu dapat {1} Chips; Saat teman mengundang orang lain, kamu dapat {3} Chips untuk setiap orang yang diundang.
]]
L.ECODE.INVITE_REWARD_RECORD = "Kamu mengundang {1} teman, dapat {2} Chips" -- 您已邀请了{1}位好友,获得了{2}筹码的邀请奖励
L.ECODE.MY_CODE = "Kode undangku" -- 我的邀请码
L.ECODE.COPY_CODE = "Klik untuk salin" -- 点击复制
L.ECODE.INVITE_REWARD_TIPS_1 = "Hebat, berhasil ambil" -- 太棒了,领取成功
L.ECODE.INVITE_REWARD_TIPS_2 = "Kamu dapat {1} Chips karena mengundang teman \n Temanmu {2} juga dapat hadiah {3}" -- 您获得了{1}筹码的好友邀请奖励\n您的好友{2},也获得了{3}的邀请奖励
L.ECODE.INVITE_BTN_NAME = "Aku juga mau undang" -- 我也要去邀请
L.ECODE.INVITE_TIPS = "Kamu bisa klik dan kirim kode dengan cara berikut" -- 您可以点击按钮通过以下方式发送邀请码
L.ECODE.INVITE_TITLES = {
    "Follow Fanpage untuk dapat kode tukar", -- 关注粉丝页获取兑换码
    "Kirim kode undangku dapat hadiah" -- 发送我的邀请码获取邀请奖励
}

--大转盘
L.LUCKTURN.RULE_TEXT = [[
1. Tiap {1} jam gratis putar 1x 
2. Kamu juga bisa pakai 1 Diamond untuk putar 1x 
3. 100% pasti dapat, banyak Chips menantimu tiap hari
]]
L.LUCKTURN.COST_DIAMOND = "Pakai 1 Diamond" -- 花费1个颗钻石
L.LUCKTURN.BUY_DIAMOND = "Beli Diamond" -- 购买钻石
L.LUCKTURN.COUNTDOWN_TIPS = "Kesempatan hari ini sudah habis \n Kamu bisa tunggu {1} lalu datang lagi \n Kamu juga bisa pakai 1 Diamond untuk putar 1x" -- 您今天的免费次数已用完\n您可以等待{1}再来\n您也可以花费一颗钻石转一次
L.LUCKTURN.LOTTERY_FAILED = "Gagal ambil lotere, mohon periksa jaringan" -- 抽奖失败，请检查网络连接断开后重试
L.LUCKTURN.CHIP_REWARD_TIPS = "{1} dapat : Chips {2}" -- {1}中了:筹码 {2}
L.LUCKTURN.PROPS_REWARD_TIPS = "{1} dapat : item {2}" -- {1}中了:道具 {2}
L.LUCKTURN.VIP_REWARD = "{1} hari hak istimewa VIP {2}" -- {1}天{2}VIP特权

--老虎机
L.SLOT.NOT_ENOUGH_MONEY = "Gagal beli Slot, Chips tidak cukup" -- 老虎机购买失败,你的筹码不足
L.SLOT.NOT_ENOUGH_MIN_MONEY = "Chips kurang dari 5000, tidak bisa pakai Slot, coba lagi setelah top up." -- 您的总筹码数不足5000，暂时无法下注老虎机，请充值后重试。
L.SLOT.BUY_FAILED = "Gagal beli Slot, coba lagi" -- 老虎机购买失败，请重试
L.SLOT.PLAY_WIN = "Kamu menang {1} Chips" -- 你赢得了{1}筹码
L.SLOT.TOP_PRIZE = "Pemain {1} dapat hadiah besar di Slot, dapat {2} Chips" -- 玩家 {1} 玩老虎机抽中大奖，获得筹码{2}
L.SLOT.FLASH_TIP = "Hadiah utama : {1}" -- 头奖：{1}
L.SLOT.FLASH_WIN = "Kamu menang : {1}" -- 你赢了：{1}
L.SLOT.AUTO = "Otomatis" -- 自动
L.SLOT.HELP_TIPS = "Hadiah = Bet * cashback \n Semakin banyak bet, semakin besar hadiah. Maksimal {1}" -- 奖金=下注筹码*回报率\n下注越多,奖励越高.最高{1}

--GIFT
L.GIFT.TITLE = "Hadiah" -- 礼物
L.GIFT.SET_SELF_BUTTON_LABEL = "Jadikan hadiahku" -- 设为我的礼物
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "Beli untuk meja x{1}" -- 买给牌桌x{1}
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "Hadiah yang dipilih" -- 你当前选择的礼物
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "Gratis" -- 赠送
L.GIFT.DATA_LABEL = "hari" -- 天
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "Silakan pilih hadiah" -- 请选择礼物
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "Berhasil beli hadiah" -- 购买礼物成功
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "Gagal beli hadiah" -- 购买礼物失败
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "Berhasil atur hadiah" -- 设置礼物成功
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "Gagal atur hadiah" -- 设置礼物失败
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "Berhasil kirim hadiah" -- 赠送礼物成功
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "Gagal kirim hadiah" -- 赠送礼物失败
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "Berhasil kirim hadiah meja" -- 赠送牌桌礼物成功
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "Gagal kirim hadiah meja" -- 赠送牌桌礼物失败"
L.GIFT.NO_GIFT_TIP = "Tidak ada hadiah" -- 暂时没有礼物
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "Klik untuk menampilkan hadiah di meja" -- 点击选中既可在牌桌上展示才礼物
L.GIFT.BUY_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to buy gift."--暂时用英文
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift."--暂时用英文
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift to all players at the table."--暂时用英文
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
    "Spesial", -- 精品
    "Makanan", -- 食物
    "Kendaraan", -- 跑车
    "Bunga", -- 鲜花
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
    "Beli sendiri", -- 自己购买
    "Dari teman", -- 牌友赠送
    "Hadiah khusus" -- 特别赠送
}

L.GIFT.MAIN_TAB_TEXT = {
    "Hadiah Toko", -- 商城礼物
    "Hadiah VIP", -- VIP礼物
    "Hadiahku" -- 我的礼物
}

-- 破产
L.CRASH.PROMPT_LABEL = "Kamu dapat bantuan bangkrut {1} Chips, dapat 1x diskon top up terbatas, kamu juga bisa undang teman untuk dapat Chips gratis." -- 您获得了{1}筹码的破产救济金，同时获得限时破产优惠充值一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.THIRD_TIME_LABEL = "Kamu dapat bantuan bangkrut terakhir {1} Chips, dapat 1x diskon top up terbatas hari ini, kamu juga bisa undang teman untuk dapat Chips gratis." -- 您获得最后一次{1}筹码的破产救济金，同时获得当日限时充值优惠一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.OTHER_TIME_LABEL = "Kamu sudah ambil semua bantuan bangkrut, menang kalah sudah biasa, tawaran terbatas ini jarang ada, segera top up!" -- 您已经领完所有破产救济金了，输赢只是转瞬的事，限时特惠机会难得，立即充值重振雄风！
L.CRASH.TITLE = "Kamu bangkrut!" -- 你破产了！
L.CRASH.REWARD_TIPS = "Bangkrut tidak masalah, masih ada bantuan" -- 破产没有关系，还有救济金可以领取
L.CRASH.CHIPS = "{1} Chips" -- {1}筹码
L.CRASH.GET = "Ambil" -- 领取
L.CRASH.GET_REWARD = "Dapat {1} Chips" -- 获得{1}筹码
L.CRASH.GET_REWARD_FAIL = "Gagal ambil Chips" -- 领取筹码失败
L.CRASH.RE_SIT_DOWN = "Duduk ulang" -- 重新坐下
L.CRASH.PROMPT_LABEL_1 = "Jangan putus asa, sistem menyiapkan {1} Chips bantuan untukmu" -- 不要灰心,系统为您准备了{1}筹码的破产救济
L.CRASH.PROMPT_LABEL_2 = "Kamu juga dapat 1x diskon top up hari ini, segera top up" -- 同时您还获得当日充值优惠一次立即充值重振雄风
L.CRASH.PROMPT_LABEL_3 = "Kamu juga bisa undang teman atau datang lagi besok untuk ambil banyak Chips" -- 您也可以邀请好友或者明天再来领取大量免费筹码
L.CRASH.PROMPT_LABEL_4 = "Jangan lewatkan kesempatan diskon top up hari ini" -- 我们赠送您当日限时充值优惠大礼包一次，机不可失
L.CRASH.PROMPT_LABEL_5 = "Kamu sudah ambil semua paket bangkrut, menang kalah itu biasa, jangan putus asa" -- 您已经领完了所有的破产礼包 输赢乃兵家常事,不要灰心

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "Pesan terkirim, sedang top up, mohon tunggu." -- 短信已发送成功,正在充值 请稍等.
L.E2P_TIPS.NOT_SUPPORT = "Sementara tidak bisa proses top up easy2pay, silakan pilih cara lain" -- 你的手机暂时无法完成easy2pay充值,请选择其他渠道充值
L.E2P_TIPS.NOT_OPERATORCODE = "Easy2pay tidak didukung provider kamu, silakan pilih cara lain" -- easy2pay暂时不支持你的手机运营商,请选择其他渠道充值
L.E2P_TIPS.SMS_SENT_FAIL = "Gagal kirim pesan, silakan cek sisa pulsa kamu" -- 短信发送失败,请检查你的手机余额是否足额扣取
L.E2P_TIPS.SMS_TEXT_EMPTY = "Pesan kosong, silakan pilih cara top up lain dan hubungi admin" -- 短信内容为空,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "Tidak ada tujuan kirim, silakan pilih cara top up lain dan hubungi admin" -- 没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_NOSIM = "Tidak ada kartu SIM, tidak bisa top up via easy2pay, silakan pilih cara lain" --没有SIM卡,无法使用easy2pay渠道充值,请选择其他渠道充值
L.E2P_TIPS.SMS_NO_PRICEPOINT = "Tidak ada tujuan kirim, silakan pilih cara top up lain dan hubungi admin" -- 没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.PURCHASE_TIPS = "Kamu akan beli {1}, total pakai {2} Baht (belum termasuk 7% Ppn), akan dipotong dari pulsa kamu" -- 您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的话费里扣除
L.E2P_TIPS.BANK_PURCHASE_TIPS = "Kamu akan beli {1}, total pakai {2} Baht (belum termasuk 7% Ppn), akan dipotong dari rekening kamu" -- 您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的银行卡里扣除

-- 比赛场
L.MATCH.MONEY = "Chips" -- 筹码
L.MATCH.JOINMATCHTIPS = "Tournament yang kamu daftar akan dimulai, masuk room sekarang?" --您报名参赛的比赛已经开始准备，是否现在进入房间进行比赛
L.MATCH.JOIN_MATCH_FAIL = "Gagal masuk Tournament, silakan ikut Tournament lain!" -- 加入比赛失败，请参加其他比赛吧！
L.MATCH.MATCH_END_TIPS = "Tournament sudah berakhir, silakan ikut Tournament lain!" -- 当前比赛已经结束，请参加其他比赛吧！
L.MATCH.MATCHTIPSCANCEL = "Jangan tampilkan lagi" -- 不再提示
L.MATCH.CHANGING_ROOM_MSG = "Sedang menunggu meja lain selesai" -- 正在等待其他桌子结束
L.MATCH.MATCH_NAME = "Nama Tournament" -- 比赛名称
L.MATCH.MATCH_REWARD = "Isi hadiah" -- 奖励内容
L.MATCH.MATCH_PLAYER = "Jumlah peserta" -- 参赛人数
L.MATCH.MATCH_COST = "Biaya daftar + layanan" -- 报名费+服务费
L.MATCH.REGISTER = "Daftar" -- 报名
L.MATCH.REGISTERING = "Sedang \n daftar" -- 正在\n报名
L.MATCH.REGISTERING_2 = "Sedang daftar" -- 正在报名
L.MATCH.UNREGISTER = "Batal \n daftar" -- 取消\n报名
L.MATCH.UNREGISTER_2 = "Batal daftar" -- 取消报名
L.MATCH.RANKING = "Rank kamu" -- 您的排名
L.MATCH.REGISTER_COST = "Biaya parameter" -- 参数费:
L.MATCH.SERVER_COST = "Biaya layanan" -- 服务费:
L.MATCH.TOTAL_MONEY = "Hartamu:" -- 您的总资产:
L.MATCH.MATCH_INFO = "Info Tournament" -- 本场赛况
L.MATCH.START_CHIPS = "Chips awal:" -- 初始筹码:
L.MATCH.START_BLIND = "Blind awal: {1}{2}"-- 初始盲注:{1}/{2}
L.MATCH.MATCH_TIME = "Waktu tanding: {1}" -- 参赛时间:{1}
L.MATCH.RANKING_TITLE = "Rank" -- 名次
L.MATCH.REWARD_TITLE = "Hadiah" -- 奖励
L.MATCH.LEVEL_TITLE = "Level" -- 级别
L.MATCH.BLIND_TITLE = "Blind" -- 盲注
L.MATCH.PRE_BLIND_TITLE = "Menuju" -- 前注
L.MATCH.ADD_BLIND_TITLE = "Waktu Blind naik" -- 涨盲时间
L.MATCH.RANKING_INFO = "Saat ini Rank {1}" -- 当前排名第{1}名
L.MATCH.SNG_HELP_TITLE = "Peraturan SNG" -- SNG比赛规则
L.MATCH.MTT_HELP_TITLE = "Peraturan MTT" -- MTT比赛规则
L.MATCH.SNG_RANKING_INFO = "Avg Chips: {1}" -- 均筹: {1}
L.MATCH.MTT_RANKING_INFO = "{1}/{2} Avg Chips: {3}" -- {1}/{2} 均筹: {3}
L.MATCH.ADD_BLIND_TIME = "Waktu Blind naik: {1}" -- 涨盲时间: {1}
L.MATCH.WAIT_MATCH = "Tunggu mulai" -- 等待开赛
L.MATCH.ADD_BLIND_TIPS_1 = "Blind naik di ronde berikutnya" -- 将在下一局涨盲
L.MATCH.ADD_BLIND_TIPS_2 = "Blind naik di ronde berikutnya {1}/{2}" -- 下一局将升盲至{1}/{2}
L.MATCH.BACK_HALL = "Kembali ke lobby" -- 返回大厅
L.MATCH.PLAY_AGAIN = "Main lagi" -- 再来一局
L.MATCH.LEFT_LOOK = "Nonton" -- 留下旁观
L.MATCH.CLOSE = "Tutup" -- 关闭
L.MATCH.REWARD_TIPS = "Kamu dapat hadiah {1} \n {2}" -- 您获得了{1}的奖励\n{2}
L.MATCH.REWARD_PLAYER = "Jumlah penerima hadiah" -- 奖励人数
L.MATCH.MATCH_CUR_TIME = "Waktu tournament" -- 比赛用时
L.MATCH.CUR_LEVEL_TITLE = "Level saat ini : {1}/{2}" -- 当前级别:{1}/{2}
L.MATCH.NEXT_LEVEL_TITLE = "Level berikutnya" -- 下一级别
L.MATCH.AVERAGE_CHIPS_TITLE = "Avg Chips" -- 平均筹码
L.MATCH.FORMAT_BLIND = "{1}/{2}" --{1}/{2}
L.MATCH.EXPECT_TIPS = "Mohon tunggu" -- 敬请期待
L.MATCH.NOT_ENOUGH_MONEY = "Chips tidak cukup untuk daftar, silakan top up Chips di Toko dan coba lagi" -- 您的筹码不足报名，请去商城补充筹码后重试
L.MATCH.PLAYER_NUM_TIPS = "Tunggu mulai, masih kurang {1} orang" -- 等待开赛中，还差{1}人
L.MATCH.PLAYER_NUM_TIPS_1 = "Tunggu mulai, masih kurang" -- 等待开赛中，还差 
L.MATCH.PLAYER_NUM_TIPS_2 = " orang" -- 人
L.MATCH.MAINTAIN = "Tournament sedang maintenance" -- 当前比赛正在维护
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
    "Kamu hebat! Pamer dulu!", -- 你太棒了！立即分享炫耀下吧!
    "Ternyata kamu kuat juga! Beritahu temanmu!", -- 没想到你这么强！呼朋唤友告诉小伙伴们吧！
    "Hebat sekali, main lagi yuk!", -- 太牛了，再来一局吧！
}
L.MATCH.NO_REWARD_TEXT = {
    "Terus berusaha, semangat!", -- 再接再厉，继续加油！
    "Kegagalan adalah awal kesuksesan, semangat!", -- 失败是成功之母，继续努力！
    "Cuma kurang sedikit, lain kali lebih sabar!", -- 就差一点点，下次多点耐心！
}
L.MATCH.SNG_RULE = {
    {
        title = "Apa itu SNG - penuh langsung main?",
        content = "SNG singkatan dari Sit and Go, kursi penuh langsung main, salah satu cara main Texas Poker. Dalam SNG, setiap pemain dapat Chips, Chips beda dengan Coins, hanya dipakai di pertandingan itu."
    },
    {
        title = "Peraturan SNG :",
        content = [[
1. Mulai tanding setelah peserta terisi 9 orang (atau 6 orang)
2. Peserta tiap pertandingan dapat Chips (Chips beda dengan Coins), Chips hanya bisa dipakai di pertandingan itu.
3. Selama SNG tidak bisa tambah Chips, Chips habis langsung keluar.
4. Rank berdasarkan urutan keluar pemain, habis Chips pertama jadi rank terakhir, dan seterusnya.
5. Saat tersisa _pemain maka pertandingan selesai, yang paling terakhir keluar adalah pemenang.
6. Agar pertandingan lebih seru, selama SNG Blind akan meningkat.
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title = "Apa itu MTT - Penyisihan banyak meja?",
        content = "MTT adalah singkatan dari Multi-Table Tournament, yaitu penyisihan banyak meja, yang artinya pemain dari beberapa meja mulai pertandingan dengan jumlah Chips sama. Dalam MTT, meja akan menggabungkan peserta yang tereliminasi. Sampai berkurang hingga 1 meja dan memasuki babak final."
    },
    {
        title = "Peraturan MTT :",
        content = [[
1. Waktu mulai tetap, bila peserta kurang dari minimum, pertandingan dibatalkan
2. Peserta tiap pertandingan dapat Chips yang hanya bisa dipakai di pertandingan itu.
3. Maju : Selama pertandingan, sebelum ronde dimulai Chips akan otomatis ditarik dari peserta, sebagai Bet awal
4. Tambah Chips : Setelah mulai konfigurasi tambah Chips dan sebelum Blind level tertentu, saat Chips kurang dari Chips awal, pemain bisa klik beli Chips memakai biaya pendaftaran sebesar Chips awal, jumlah tambah Chips berbeda tiap pertandingan, saat Chips habis pemain langsung tereliminasi, beli Chips bisa main lagi
5. Tambah beli Chips : Saat Blind level tertentu setelah mulai konfigurasi tambah Chips, pemain bisa klik beli Chips memakai biaya pendaftaran sebesar Chips awal, jumlah tambah Chips berbeda tiap pertandingan, saat Chips habis pemain langsung tereliminasi, beli Chips bisa main lagi
6. Rank berdasarkan urutan keluar pemain, habis Chips pertama jadi rank terakhir, dan seterusnya, bila dalam 1 ronde ada lebih dari 2 pemain tereliminasi bersamaan, maka rank berdasarkan kekuatan kartu, Chips awal, pemain dengan kartu lebih kuat dan Chips awal banyak maka rank lebih tinggi
7. Saat tersisa 1 pemain maka pertandingan selesai, yang paling terakhir keluar adalah pemenang
8. Agar pertandingan lebih seru, selama MTT Blind akan meningkat
]]
    }
}
L.MATCH.TAB_TEXT= {
    "Detail", -- 概述
    "Rank", -- 排名
    "Blind", -- 盲注
    "Hadiah", -- 奖励
}
L.MATCH.ROOM_TAB_TEXT_1= {
    "Detail", -- 概述
    "Detail Pertandingan", -- 赛况
    "Rank", -- 排名
    "Blind" ,-- 盲注
    "Hadiah" ,-- 奖励
}
L.MATCH.ROOM_TAB_TEXT_2= {
    "Detail Pertandingan" ,-- 赛况
    "Rank" ,-- 排名
    "Blind" ,-- 盲注
    "Hadiah" ,-- 奖励
}

-- 输赢统计
L.WINORLOSE.TITLE = "Hebat" -- 太棒了
L.WINORLOSE.YING = "Kamu menang" -- 你赢了
L.WINORLOSE.CHOUMA = "{1} Chips" -- {1}筹码
L.WINORLOSE.INFO_1 = "Data Ronde: {1}" -- 局数:{1}
L.WINORLOSE.INFO_2 = "Menang terbesa : {1}" -- 单局最大赢得:{1}
L.WINORLOSE.RATE5 = "Beri bintang 5 kalau suka game kami, dukungan kamu berguna agar kami lebih baik" -- 喜欢我们的游戏给5星好评，您的鼓励是我们持续优化的最大动力
L.WINORLOSE.NOW = "Dukung" -- 立即支持
L.WINORLOSE.LATER = "Nanti saja" -- 以后再说
L.WINORLOSE.SHARE = "Share" -- 分享
L.WINORLOSE.CONTINUE = "Continue"--继续游戏

-- 私人房
L.PRIVTE.ROOM_NAME = "Room private" -- 私人房
L.PRIVTE.FINDTITLE = "Cari room" -- 查找房间
L.PRIVTE.CREATTITLE = "Buat room" -- 创建房间
L.PRIVTE.INPUTROOMIDTIPS = "Masukkan nomor room" -- 请输入房间号
L.PRIVTE.ENTERROOM = "Langsung masuk" -- 立即进入
L.PRIVTE.TYPETIPS = "Waktu pasang Bet:\n Arena normal {1} detik \n Arena cepat {2} detik" -- 下注思考时间:\n普通场{1}秒\n快速场{2}秒
L.PRIVTE.CREATEROOM = "Langsung mulai" -- 立即开始
L.PRIVTE.CREATFREE = "Buka ronde gratis terbatas" -- 限免开局
L.PRIVTE.INPUTPWDTIPS = "Masukkan sandi room, kosong berarti tanpa sandi" -- 请输入房间密码，留空即无密码
L.PRIVTE.TIMEHOUR = "{1} jam" -- {1}小时
L.PRIVTE.PWDPOPTIPS = "Masukkan sandi yang berlaku" -- 请输入有效密码
L.PRIVTE.PWDPOPTITLE = "Masukkan sandi" -- 请输入密码
L.PRIVTE.PWDPOPINPUT = "Masukkan sandi" -- 请输入密码
L.PRIVTE.NOTIMETIPS = "Sisa waktu room ini {1} detik, akan segera tutup, silakan buat baru!" -- 当前房间所剩时间{1}秒，即将解散，请重新创建！
L.PRIVTE.TIMEEND = "Room sudah ditutup, silakan ke lobby buat baru!" -- 当前房间时间已用完解散，请返回大厅重新创建！
L.PRIVTE.ENTERBYID = "Masukkan nomor room untuk masuk" -- 输入房间号进入
L.PRIVTE.OWNER = "Pemilik room" -- 房主
L.PRIVTE.ROOMID = "Nomor room" -- 房间号:{1}
L.PRIVTE.LEFTDAY = "{1} hari" -- {1}天
L.PRIVTE.LEFTHOUR = "{1} jam" -- {1}小时
L.PRIVTE.LEFTMIN = "{1} menit" -- {1}分钟
L.PRIVTE.ENTERLOOK = "Nonton" -- 围观
L.PRIVTE.ENTERPLAY = "Duduk" -- 坐下
L.PRIVTE.ENTEREND = "Selesai" -- 已结束
L.PRIVTE.ENTERENDTIPS = "Room sudah ditutup, silakan masuk room lain!" -- 当前房间已解散，请进入其他房间！
L.PRIVTE.ENTERCHECK = "Masuk room ini?" -- 您要加入此房间么?
L.PRIVTE.CHECKCREATE = "Tidak ada room, buat baru" -- 暂无房间，创建新房间
L.PRIVTE.ROOMMAXTIPS = "Room privatemu sudah mencapai batas!" -- 您创建的私人房已经达到上限！

--活动
L.ACT.CHRISTMAS_HITRATE = "Akurasi {1} Combo terbanyak {2}" -- 准确率{1}  最多连击{2}
L.ACT.CHRISTMAS_HITWIN = "Gesit sekali, kamu mengalahkan {1} orang di event ini" -- 手速超快, 您在本活动中击败{1}的人
L.ACT.CHRISTMAS_FEED = {
    name = "Aku dapat {1} Chips karena cepat, mengalahkan {2} orang, berani melawanku?", -- 我以超快手速获得了{1}筹码，击败了{2}的人，敢来和我拼手速吗？,
    caption = "Klik hadiah 100% pasti dapat Chips", -- 点礼物得筹码100%中奖,
    link = L.FEED.SHARE_LINK .. "&feed=14",
    picture = appconfig.FEED_PIC_URL.."14.jpg",
    message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "Selamat Natal, goyangkan HP ambil hadiah" -- 圣诞节快乐，摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "Selamat Tahun baru, goyangkan HP ambil hadiah" -- 新年快乐，摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "Hadiah akan datang, siap untuk klik?" -- 礼物即将降落，准备好点击了吗？
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "Besok datang lagi" -- 明天再来吧
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 = "Selamat imlek, goyangkan HP ambil hadiah" -- 春节快乐，摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_6 = "Happy Chinese Valentine's day, pick up your  phone and shake it. Click on the gift to surprise you."

--红黑大战
L.REDBLACK.BET_DOUBLE = "Double" -- 加倍
L.REDBLACK.BET_LAST = "Ulang ronde sebelumnya" -- 重复上局
L.REDBLACK.SELECTED_BET_TIPS = "Pilih lucky area" -- 请选择幸运区域
L.REDBLACK.SELECTED_BET_END_TIPS = "Selesai pilih" -- 选择完毕
L.REDBLACK.START_GAME_TIPS = "Game akan mulai ({1})" -- 游戏即将开始({1})
L.REDBLACK.BET_FAILD = " Coins tidak cukup, gagal pasang bet" -- 您的游戏币不足,下注失败
L.REDBLACK.BET_FAILD_2 = "Coins tidak mencukupi bet yang dipilih {1}, otomatis ganti jadi {2}" -- 您的游戏币不足当前所选的下注额度{1}，已经自动切换到{2}
L.REDBLACK.BET_FAILD_TIMES_OUT = "Waktu Bet habis, gagal pasang bet" -- 下注时间已到,下注失败
L.REDBLACK.BET_LIMIT_TIPS = "Gagal pasang bet, tidak boleh lebih dari {1}" -- 下注失败，当局下注不能超过{1}
L.REDBLACK.ALL_PLAYER = "Room sekarang ada {1} orang" -- 当前房间共有 {1} 人
L.REDBLACK.RECENT_TREND = "Tren saat ini :" -- 近期走势:
L.REDBLACK.TODAY_COUNT = "Perhitungan hari ini :" -- 今日统计:
L.REDBLACK.WIN_LOSE = "Menang Kalah" -- 胜 负
L.REDBLACK.HAND_CARD = "Hand" -- 手 牌
L.REDBLACK.WIN_CARD_TYPE = "Jenis kartu yang menang" -- 获胜牌型
L.REDBLACK.COUNT_TIPS_1 = "Gold Menang : {1}" -- 金象胜利:{1}
L.REDBLACK.COUNT_TIPS_2 = "Silver Menang : {1}" -- 银象胜利:{1}
L.REDBLACK.COUNT_TIPS_3 = "Seri : {1}" -- 平局:{1}
L.REDBLACK.COUNT_TIPS_4 = "Straight Flush : {1}" -- 同花连牌:{1}
L.REDBLACK.COUNT_TIPS_5 = "AA : {1}" -- 对A:{1}
L.REDBLACK.COUNT_TIPS_6 = "Full House : {1}" -- 葫芦:{1}
L.REDBLACK.COUNT_TIPS_7 = "4 of a kind/Royal Flush/Straight Flush : {1}" -- 金刚/皇家/同花顺:{1}
L.REDBLACK.SUB_TAB_TEXT = {
    "Tren menang kalah", -- 胜负走势,
    "Aturan Main" -- 游戏规则
}
L.REDBLACK.RULE = [[
Pilih pemain yang didukung, menangkan banyak hadiah!


Peraturan dasar :"
1. Gold dan Silver dibagikan satu Hand tiap ronde, lalu 5 Board Card, lalu dipilih salah satu kartu.

2. Pemain bisa mendukung camp dan area manapun berdasarkan info umum.

3. Board Card dan Hand menyala, menurut hasil, hadiah dibagikan ke pemain pendukung.


Ada batas harian. Dukung pemain dengan strategi yang masuk akal baru untung besar!
]]

--新手引导
L.TUTORIAL.SETTING_TITLE = "Tutorial pemula" -- 新手教学
L.TUTORIAL.FIRST_IN_TIPS = [[
Selamat datang di Super Texas Poker
Berikutnya Ai yang akan mengajari kamu cara bermain game populer ini, kalau sudah mengerti, kamu bisa lewati panduan, atau klik mulai tutorial.

Pertama kali selesai tutorial dapat 8000 Chips lho!
]]
L.TUTORIAL.FIRST_IN_BTN1 = "Lewati panduan" -- 跳过引导
L.TUTORIAL.FIRST_IN_BTN2 = "Mulai tutorial" -- 开始教学
L.TUTORIAL.END_AWARD_TIPS = "Selesai tutorial dapat Chips" -- 完成教程领取筹码
L.TUTORIAL.FINISH_AWARD_TIPS = "Selamat, kamu dapat {1} Chips dari hadiah tutorial pemula, kamu bisa pilih ulang lagi atau langsung mulai" -- 恭喜你，您获得了{1}筹码的新手教学礼包，您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_NOAWARD_TIPS = "Kamu sudah mahir Texas Poker, bisa pilih ulang lagi atau langsung mulai" -- 您已经是德州扑克高手啦，您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_FIRST_BTN = "Tutorial ulang" -- 重新学习
L.TUTORIAL.FINISH_SECOND_BTN = "Mulai segera" -- 快速开始
L.TUTORIAL.SKIP = "Lewati" -- 跳 过
L.TUTORIAL.NEXT_STEP = "Berikutnya" -- 下一步
L.TUTORIAL.GUESS_TRUE_13 = "Benar, kamu punya 1 Pair (A), cukup besar. \n\n Klik dimanapun untuk masuk bet berikutnya" -- 答对了，您现在有一对(A)，挺大的。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_22 = "Benar, kamu punya 2 pasang (A/9), \n\n Klik dimanapun untuk masuk bet berikutnya" -- 答对了，您现在有两对(A/9)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_27 = "Benar, sekarang kamu Full House (9/A). \n\n Klik dimanapun untuk masuk bet berikutnya" -- 答对了，您现在是葫芦(9/A)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_FLASE = "Salah, coba ingat lagi…" -- 错啦，再仔细想想...
L.TUTORIAL.RE_SELECT = "Pilih lagi" -- 重选
L.TUTORIAL.TIPS = {
    "Keluar menu", -- 退出菜单
    "Beli Chips", -- 购买筹码
    "Klik untuk lihat profil orang, kirim Chips, pakai item interaktif", -- 点击查看他人信息 赠送筹码 使用互动道具
    "Board Card", -- 公共牌
    "Geser atau klik untuk buka Mesin Slot", -- 滑出或者点击打开老虎机
    "Foto profilku", -- 我的头像
    "Hand-ku", -- 我的手牌
    "Tombol aksi", -- 操作按钮
    "Klik Chat  kirim emo" -- 点击聊天 发送表情
}
L.TUTORIAL.ROOM_STEP_1 = "Selamat datang di Open Texas Poker! Pertama kali menyelesaikan tutorial dapat {1} Chips. \n\n Klik dimana saja untuk lanjut" -- 欢迎来到开源德州扑克！首次完成新手引导即可获赠{1}筹码。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_2 = "Dealer akan bagi 2 kartu ke tiap orang, hanya bisa dilihat sendiri.\n\n Klik dimana saja untuk lanjut" -- 游戏开始荷官会给每个人发两张手牌，只有自己可见。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_3 = "Lalu bagi 5 Board Card, bisa dilihat semua pemain. \n\n Klik dimana saja untuk lanjut" -- 之后会逐步发出5张公牌，公牌所有玩家都可以看到。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_4 = "Kicker kamu adalah kombinasi 5 kartu terbesar dari Board Card dan Hand, kekuatan kartu seperti di gambar (Royal Flush terkuat -> High Card terlemah)" -- 你最后成牌是从公牌和手牌中选5张组成的最大牌型构成，牌型大小如图所示(皇家同花顺最大->高牌最小)
L.TUTORIAL.ROOM_STEP_5 = "Kombinasi kartu terkuat kamu sekarang adalah Royal Flush (5 kartu lambang sama berurutan 10 J Q K A), bagian menyala adalah kombinasi terkuat yang dipilih. \n\n Klik dimana saja untuk lanjut" -- 您当前组成的最大牌型则是皇家同花顺(5张相同花色顺子10 J Q K A)，光标闪烁处就是选中的最大牌组合。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_6 = "Sudah paham? \n\n Klik dimana saja untuk lanjut" -- 都掌握了吗？\n下面我们正式开始一局吧！\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_7 = "Ini adalah area main, saat giliranmu, kamu bisa pilih kartu mana yang digunakan. \n\n Klik dimana saja untuk lanjut" -- 此处是玩牌操作区域，轮到你操作时，可以根据自己的牌选择相应操作。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_8 = "Sekarang giliranmu, kartumu bagus juga! \n\n Klik tombol Call" -- 现在轮到你了，你当前的牌还不错! \n\n点击按钮选择跟注
L.TUTORIAL.ROOM_STEP_11= "Dua pemain lain pilih CALL, sepertinya tidak ada kartu bagus, sekarang bagi 3 Board Card. \n\n Klik dimana saja untuk lanjut" -- 其他两个玩家都选择CALL，看样也没什么好牌，现在发前三张公牌。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_13= "Setelah bagi 3 kartu, kamu menyusun kombinasi kartu baru, tebak jenis kartu apa sekarang?" -- 三张公牌发完，你组成了新的牌型，猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_14= "Giliranmu, coba pikirkan langkah berikutnya, orang lain mungkin punya Flush, pilih Check" -- 又轮到你了，先想想下一步怎么操作，别人有可能会是同花(梅花)，先选择一把看牌
L.TUTORIAL.ROOM_STEP_16= "Pemain {1} pilih Raise, biasanya karena punya kartu kuat, hati-hati, amati perubahan dulu" -- 玩家{1}选择了加注，加注一般有比较强的牌力，要小心，先静观其变吧
L.TUTORIAL.ROOM_STEP_18= "Pemain {1} pilih Fold, Fold berarti kalah semua Chips yang dipasang Bet, saat kartu kurang bagus lebih baik Fold" -- 玩家{1}选择了弃牌，弃牌就意味着这一局输掉所有已经下注的筹码，当牌力不够的时候选择弃牌比较合理
L.TUTORIAL.ROOM_STEP_19= "Giliranmu, kartunya lumayan 1 Pair (A), CALL untuk lihat Board Card ke-4" -- 又轮到你了，当前牌力不错一对(A)，CALL下看第四张公牌
L.TUTORIAL.ROOM_STEP_22= "4 Board Card sudah dibagi, kamu punya kombinasi baru, coba tebak jenis kartu apa?" -- 四张公牌发完，你又组成了新的牌型，猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_23= "Sisa 2 pemain, kamu punya Double Pair (A/9), cukup kuat, bisa coba Raise {1}" -- 游戏只剩两个玩家了，你现在有两对(A/9)，牌力不错，可以加注{1}试试
L.TUTORIAL.ROOM_STEP_25= "{1} juga Call, Board Card ke-5 dibagikan" -- {1}也选择跟住，游戏将发第五张公牌
L.TUTORIAL.ROOM_STEP_27= "5 Board Card sudah dibagi, kartumu juga sudah dipilih, apa kartu terakhirmu?" -- 五张公牌都发完啦，你的最终牌型也确定了，你的最终牌型是什么？
L.TUTORIAL.ROOM_STEP_29= "{1} ALL IN, kemungkinan kartunya besar, tapi kamu Full House (9/A) juga besar, ikut!" -- {1}ALL_IN了，预测牌力不小，但你葫芦(9/A)也很大，跟了!
L.TUTORIAL.ROOM_STEP_32= "Hasil akhir, {1} Straight, kamu Full House, kamu menang (Full House> Straight)! Kamu dapat semua Chips di Pool!" --  最后亮牌了，{1}是同花，你是葫芦，你赢了(葫芦>同花)！您获得了底池所有的筹码！
L.TUTORIAL.ROOM_STEP_34= "Ini faktor lain permainan, harus kamu cari tahu sendiri" -- 这是游戏的其他元素，需要你自己去探索啦

--保险箱
L.SAFE.TITLE = "Safety Box" -- 保险箱
L.SAFE.TAB_TEXT = {
    "Game Coins", -- 游戏币,
    "Diamond" -- 钻石
}
L.SAFE.SAVE_MONEY = "Simpan" -- 存入
L.SAFE.GET_MONEY = "Tarik" -- 取出
L.SAFE.SET_PASSWORD = "Atur sandi" -- 设置密码
L.SAFE.CHANGE_PASSWORD = "Ubah sandi" -- 修改密码
L.SAFE.MY_SAFE = "Safety Box-ku" -- 我的保险箱
L.SAFE.MY_PURSE = "Dompetku" -- 我的携带
L.SAFE.SET_PASSWORD_TIPS_1 = "Masukkan sandi baru" -- 请输入新密码
L.SAFE.SET_PASSWORD_TIPS_2 = "Masukkan sandi baru lagi" -- 请再次新输入密码
L.SAFE.SET_PASSWORD_TIPS_3 = "Sandi yang dimasukkan beda, masukkan ulang" -- 两次输入密码不一致,请重新输入
L.SAFE.SET_PASSWORD_TIPS_4 = "Sandi harus diisi, masukkan ulang!" -- 密码不能为空,请重新输入！
L.SAFE.SET_PASSWORD_TIPS_5 = "Mohon masukkan sandi, buka safety box" -- 请输入密码,打开保险箱
L.SAFE.FORGET_PASSWORD = "Lupa sandi" -- 忘记密码
L.SAFE.VIP_TIPS_1 = "Kamu belum jadi VIP, tidak bisa pakai, apa mau langsung jadi VIP, banyak diskon dan hak istimewa." --您还不是VIP用户,暂时无法使用,是否立即成为VIP,还有超多优惠和特权.
L.SAFE.VIP_TIPS_2 = "VIP kamu sudah tidak berlaku, tidak bisa simpan, apa mau langsung jadi VIP, banyak diskon dan hak istimewa." -- 您的VIP已经过期,暂时无法存入,是否立即成为VIP,还有超多优惠和特权.
L.SAFE.SET_PASSWORD_SUCCESS = "Berhasil atur sandi!" -- 设置密码成功!
L.SAFE.SET_PASSWORD_FAILED = "Gagal atur sandi, coba lagi!" -- 设置密码失败,请重试!
L.SAFE.CHANGE_PASSWORD_SUCCESS = "Berhasil ubah sandi!" -- 修改密码成功!
L.SAFE.CHANGE_PASSWORD_FAILED = "Gagal ubah sandi, coba lagi!" -- 修改密码失败,请重试!
L.SAFE.CHECK_PASSWORD_ERROR = "Sandi salah, masukkan ulang!" -- 输入的密码错误,请重新输入!
L.SAFE.CHECK_PASSWORD_FAILED = "Gagal verifikasi sandi, coba lagi!" -- 验证密码失败,请重试!
L.SAFE.SAVE_MONEY_FAILED = "Gagal simpan, coba lagi!" -- 存钱失败,请重试!
L.SAFE.GET_MONEY_FAILED = "Gagal tarik, coba lagi!" -- 取钱失败,请重试!
L.SAFE.INPUT_MONEY_TIPS = "Masukkan lebih besar dari 0, untuk simpan." -- 请输入大于0的数值,进行存取.
L.SAFE.SET_EMAIL = "Atur email" -- 设置安全邮箱
L.SAFE.SET_EMAIL_BTN = "Klik atur" -- 点击设置
L.SAFE.CHANGE_EMAIL_BTN = "Ubah email" -- 修改邮箱
L.SAFE.SET_EMAIL_TIPS_1 = "Demi keamanan aset kamu, ikat email yang sering digunakan, agar bisa terima email. Email dipakai untuk reset sandi dan lainnya. \n Ikat email pertama kali bisa dapat 20K Coins." -- 为了更好的保护您的财产,请绑定常用邮箱,以确保收到邮件.邮件可以用于重置密码等操作.\n首次绑定还可以奖励20K游戏币.
L.SAFE.SET_EMAIL_TIPS_2 = "Berhasil ikat email!" -- 您已经成功绑定邮箱!
L.SAFE.SET_EMAIL_TIPS_3 = "Contoh email openpokerxxx@gmail.com" -- 电子邮箱,例如openpokerxxx@gmail.com
L.SAFE.SET_EMAIL_TIPS_4 = "Masukkan format email yang benar!" -- 请输入正确的邮箱格式!
L.SAFE.SET_EMAIL_TIPS_5 = "Kamu belum atur email, setelah atur akan cari kembali sandi lewat email" -- 你还没有设置安全邮箱,设置后可通过邮箱找回密码
L.SAFE.SET_EMAIL_TIPS_6 = "Kamu sudah atur email : {1}" -- 您已经设置了安全邮箱:{1}
L.SAFE.SET_EMAIL_SUCCESS = "Berhasil ikat email!" -- 绑定邮箱成功!
L.SAFE.SET_EMAIL_TIPS_FAILED = "Gagal ikat email, coba lagi!" -- 绑定邮箱失败,请重试!
L.SAFE.RESET_PASSWORD_TIPS_1 = "Info reset sandi sudah dikirim, segera klik link untuk verifikasi."--重置信息已提交,请立即登录邮箱点击链接验证.
L.SAFE.RESET_PASSWORD_TIPS_2 = "Atur sandi baru, klik konfirmasi, sistem akan mengirim link verifikasi ke email kamu, klik link dalam 5 menit lalu berhasil ubah." -- 设置新的密码,点击确定,系统将发送验证链接到您的安全邮箱,5分钟内点击链接激活即可重置成功.
L.SAFE.RESET_PASSWORD_TIPS_3 = "Maaf, kamu belum ikat email, tidak bisa memakai fitur ini. Silakan hubungi CS." -- 对不起,由于您没有绑定邮箱,所以无法此功能.请您联系客服.
L.SAFE.RESET_PASSWORD_TIPS_4 = "Gagal kirim info reset sandi, silakan coba lagi." -- 重置信息提交失败,请重试.
L.SAFE.RESET_PASSWORD = "Reset sandi" -- 重置密码
L.SAFE.CLEAN_PASSWORD = "Hapus sandi" -- 清空密码
L.SAFE.CLEAN_PASSWORD_SUCCESS = "Berhasil hapus sandi!" -- 清空密码成功!
L.SAFE.CLEAN_PASSWORD_FAILED = "Gagal hapus sandi, coba lagi!" -- 清空密码失败,请重试!

--夺金岛 暂时用英文
L.GOLDISLAND.TITLE = "Jackpot"
L.GOLDISLAND.RULE_BTN = "Rules"
L.GOLDISLAND.BUY_BTN = "Buy next hand"
L.GOLDISLAND.ALREADY_BUY = "Bought"
L.GOLDISLAND.PRICE = "{1}chips/time"
L.GOLDISLAND.AUTO_BUY = "Aoto buy in"
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
L.PAYGUIDE.BUY_PRICE_1 = "{1} Buy Now"
L.PAYGUIDE.BUY_PRICE_2 = " Original Price {1}"
L.PAYGUIDE.ROOM_FIRST_PAY_TIPS = "Everyone only can buy once"
return L
