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
L.MATCH        = {} -- 比赛场
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
L.CHECKOUTGUIDE = {}
L.BIND = {}

-- tips
L.TIPS.ERROR_INVITE_FRIEND ="दोस्त को आमंत्रित भेजने पर विफल है।"--邀请好友失败
L.TIPS.ERROR_TASK_REWARD ="रिवार्ड को प्राप्त करने पर विफल है।"--领取任务奖励失败
L.TIPS.ERROR_SEND_FRIEND_CHIP ="दोस्त को चिप्स देने पर विफल है।"--送筹码给朋友失败
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP ="असाधारण रूप से दोस्त को चिप्स दिया।"--送朋友给筹码异常
L.TIPS.ERROR_BUY_GIFT ="उपहार भेजने पर विफल है"--赠送礼物失败
L.TIPS.ERROR_LOTTER_DRAW ="रहस्य उपहार डिब्बा प्राप्त करने पर विफल है।"--神秘礼盒领奖失败
L.TIPS.EXCEPTION_LOTTER_DRAW ="सोने के अंडे को डाका की बाकी बार पर्याप्त नहीं है।"--砸金蛋剩余次数不够
L.TIPS.ERROR_LOGIN_ROOM_FAIL ="कमरे में लॉगिन पर विफल है।"--登录房间失败
L.TIPS.ERROR_LOGIN_FACEBOOK ="फेसबुक लॉगिन पर विफल है।"--FaceBook登录失败
L.TIPS.ERROR_LOGIN_FAILED ="लॉगिन पर विफल है।"--登录失败
L.TIPS.ERROR_QUICK_IN ="कमरे के संदेश को प्राप्त पर विफल है।"--获取房间信息失败
L.TIPS.EXCEPTION_QUICK_IN ="असाधारण रूप से कमले के संदेश को प्राप्त किया।"--获取房间信息异常
L.TIPS.ERROR_SEND_FEEDBACK ="सर्वर त्रुटि या नेटवर्क लिंक टाइमआउट से फ़ीडबैक भेजने में विफल है!"--服务器错误或网络链接超时，发送反馈失败！
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR ="सर्वर त्रुटि है और प्रतिपुष्टि भेजने में विफल है।"--服务器错误,发送反馈失败
L.TIPS.ERROR_MATCH_FEEDBACK ="प्रतियोगिता क्षेत्र के त्रुटि प्रतिपुष्टि करने पर विफल है।"--反馈比赛场错误失败
L.TIPS.EXCEPTION_ACT_LIST ="सर्वर त्रुटिसे इवेंट डेटा लोड करना विफल है।"--服务器错误，加载活动数据失败
L.TIPS.EXCEPTION_BACK_CHECK_PWD ="सत्यापन संकेत शब्द: सर्वर त्रुटि है।"--校验密码：服务器错误
L.TIPS.ERROR_BACK_CHECK_PWD ="सर्वर त्रुटि या नेटवर्क लिंक टाइमआउट से सत्यापन है, सत्यापन संकेत शब्द में विफल है।"--服务器错误或网络链接超时，校验密码失败
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED ="जानकारी देने चित्र के अपलोड करने पर विफल है।"--反馈图片上传失败！
L.TIPS.ERROR_LEVEL_UP_REWARD ="सर्वर त्रुटि या नेटवर्क लिंक टाइमआउट से स्तर उन्नति इनाम प्राप्त पर विफल है।"--服务器错误或网络超时，领取升级奖励失败
L.TIPS.WARN_NO_PERMISSION = "आप अभी तक सबफ़ंक्शन का उपयोग नहीं कर सकते हैं। पहले सिस्टम प्राधिकरण पर जाएं"--您还不能使用次功能，请先到系统授权
L.TIPS.VIP_GIFT = "वीआईपी उपयोगकर्ता इस उपहार को खरीद सकते हैं"
L.TIPS.KAOPU_TIPS = "The game failed to initialize. Please try again"

-- COMMON MODULE
L.COMMON.LEVEL ="स्तर:"--等级:
L.COMMON.ASSETS ="${1}"--
L.COMMON.CONFIRM ="निश्चित करेंगे"--确定
L.COMMON.CANCEL ="रद्द करेंगे"--取消
L.COMMON.AGREE ="स्वीकार करेंगे"--同意
L.COMMON.REJECT ="इन्कार करेंगे"--拒绝
L.COMMON.RETRY ="फिर से कोशिश करेंगे"--重连
L.COMMON.NOTICE ="सूचना"--温馨提示
L.COMMON.BUY ="ख़रीदेंगे"--购买
L.COMMON.SEND ="भेजेंगे"--发送
L.COMMON.BAD_NETWORK ="नेटवर्क कनेक्शन टूट गया है, कृपया अपने नेटवर्क कनेक्शन की जांच कीजिये।"--网络连接中断，请检查您的网络连接是否正常.
L.COMMON.REQUEST_DATA_FAIL ="नेटवर्क कनेक्शन टूट गया है, कृपया अपने नेटवर्क कनेक्शन की जांच कीजिये, पुन: कनेक्ट करने के लिए पुन: कनेक्ट बटन पर क्लिक करेंगे।"--网络连接中断，请检查您的网络连接是否正常，点击重连按钮重新连接。
L.COMMON.ROOM_FULL ="अब इस कमरे में देखनेवाले बहुत हैं, कृपया आप दूसरे कमरे को परिवर्तन कीजिये।"--现在该房间旁观人数过多，请换一个房间
L.COMMON.USER_BANNED ="आपका खाता जमे हुए है, कृपया प्रतिपुष्टि दीजिये या खेल मैनेजर को  सम्पर्क कीजिये।"--您的账户被冻结了，请你反馈或联系管理员
L.COMMON.SHARE ="शेयर"--分  享
L.COMMON.GET_REWARD ="इनाम प्राप्त करेंगे"--领取奖励
L.COMMON.BUY_CHAIP ="खरीदेंगे"--购买
L.COMMON.SYSTEM_BILLBOARD ="घोषणा"--官方公告
L.COMMON.DELETE ="हटाएंगे"--删除
L.COMMON.CHECK ="देखेंगे"--查看
L.COMMON.CONGRATULATIONS ="बधाई"--恭喜你
L.COMMON.REWARD_TIPS ="{1} को प्राप्त करने के लिये बधाई देता है।"--恭喜您获得了{1}
L.COMMON.GET ="लेंगे"--领取
L.COMMON.CLICK_GET ="लेने लिये क्लिक कीजिये"--点击领取
L.COMMON.ALREADY_GET ="लिया"--已领取
L.COMMON.NEXT_GET ="अगली बार लेंगे"--下次领取
L.COMMON.LOGOUT ="लोग आउट"--登出
L.COMMON.LOGOUT_DIALOG_TITLE ="लॉगआउट की पुष्टि करेंगे"--确认退出登录
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG ="आपकी चिप्स न्यूनतम खरीदनेवाले {1} से कम है! कृपया कुछ खरीदने के बाद दोबारा कोशिश करेंगे।"--您的筹码不足最小买入{1},请补充筹码后重试。
L.COMMON.USER_SILENCED_MSG ="आप बातचित पर प्रतिबंध लगा दिया है। आप सेवा- जानकारी में खेल मैनेजर को सम्पर्क कर सकते हैं।"--您的帐号已被禁言，您可以在帮助-反馈里联系管理员处理
L.COMMON.USER_NEED_RELOGIN ="संचालन विफल है। कृपया फिर से लॉगइन कीजिये या खेल मैनेजर को सम्पर्क कीजिये।"--操作失败，请重新登录再试，或者联系客服
L.COMMON.BLIND_BIG_SMALL ="बहाना:{1}/{2}"--盲注:{1}/{2}
L.COMMON.NOT_ENOUGH_DIAMONDS ="क्षमा करेंगे, आप के पास इतने हीरे नहीं हैं।"--对不起，您的钻石不足!
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY ="आप के पास चिप्स अपर्याप्त हैं।कृपया खरीदकर दूबारी कोशिश करेंगे।"--您的筹码不足，请充值后重试

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE ="बाहर निकलने की पुष्टि करेंगे"--确认退出
L.COMMON.QUIT_DIALOG_MSG ="बाहर निकलना सचि है?  मुझे आप को बहुत  कमी लगता है।~\\(≧▽≦)/~"--真的确认退出游戏吗？人家好舍不得滴啦~\\(≧▽≦)/~
L.COMMON.QUIT_DIALOG_MSG_A ="बाहर निकलना पक्का है? \n अगले दिन लॉगइन आप और ईनाम प्राप्त सकते हैं।"--确定要退出了吗?\n明天登录还可以领取更多奖励哦。
L.COMMON.QUIT_DIALOG_CONFIRM ="पक्का लोगइन करेंगे"--忍痛退出
L.COMMON.QUIT_DIALOG_CANCEL ="नहीं"--我点错了
L.COMMON.GAME_NAMES = {
    [1] ="टेक्सास होल्डम",--德州扑克,
    [2] ="प्रतियोगिता क्षेत्र",--比赛场,
    [3] ="ओमाहा"--奥马哈
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS ="नए खिलाड़ी के पहले 3 बारों लॉगइन के लिए लकी पैक देता है।\nफेसबुक खाता से लॉगइन तो अधिक इनाम प्राप्त पाते हैं।"--新用户前三次登录,可以免费领取超值幸运注册大礼包.\nFaceBook登录用户领取更高奖励哦!
L.LOGIN.FB_LOGIN ="फेसबुक खाता से लॉगइन"-- FB账户登录
L.LOGIN.GU_LOGIN ="अतिथि खाता से लॉगइन"--游客账户登录
L.LOGIN.REWARD_SUCCEED ="इनाम प्राप्त पर सफलता है।"--领取奖励成功
L.LOGIN.REWARD_FAIL ="प्राप्त पर विफल है।"--领取失败
L.LOGIN.LOGINING_MSG ="लॉगइन कर रहा है।"--正在登录游戏...
L.LOGIN.CANCELLED_MSG ="लॉगइन रछ किया।"--登录已经取消
L.LOGIN.DOUBLE_LOGIN_MSG ="आप का खाता दूसरी जगह में लॉगइन किया ।"--您的账户在其他地方登录
L.LOGIN.LOGIN_DEALING = "लॉगिन प्रसंस्करण, कृपया धैर्यपूर्वक प्रतीक्षा कीजिये।"--正在处理登陆，请耐心等待
L.LOGIN.INIT_SDK = "The game is initializing.Please wait."--"游戏正在初始化,请耐心等待."

-- HALL MODULE
L.HALL.USER_ONLINE ="ऑनलाइन खिलड़ियाँ : {1}"--当前在线人数: {1}
L.HALL.INVITE_TITLE ="दोस्त को आमंत्रित भेजेंगे।"--邀请好友
L.HALL.INVITE_FAIL_SESSION ="फेसबुक की जानकारी प्राप्त करने में विफल था। कृपया पुन: प्रयास कीजिये।"--获取Facebook信息失败，请重试
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR ="कमरा संख्या गलत है।"--你输入的房间号码有误
L.HALL.MATCH_NOT_OPEN ="प्रतियोगिता क्षेत्र जल्द ही आ रहा है"--比赛场将尽快开放
L.HALL.NOT_TRACK_TIPS ="अब ऑफ़लाइन है।अनुकरण नहीं सक रहा है।"--暂不在线,无法追踪
L.HALL.TEXAS_LIMIT_LEVEL ="आप का स्तर {1} से कम है। कृपया पदोन्नति कीजिये।"--您的等级不足{1}级，请先玩牌升级后再来!
L.HALL.TEXAS_GUIDE_TIPS_1 = "आप एक मास्टर हैं, नौसिखिए क्षेत्र में नवाचारों का दुरुपयोग मत करें!"--您已经是高手了,不要在新手场虐菜了!
L.HALL.TEXAS_GUIDE_TIPS_2 = "आप एक मास्टर हैं, अधिक जीतने के लिए अपने बड़े मेज में जा सकते हैं।"--您已经是高手了,可以去适合您的大场赢钱更多.
L.HALL.TEXAS_GUIDE_TIPS_3 = "बधाई! आपके चिप्स एक नई ऊंचाई तक पहुंच गए हैं और आप तुरंत और अधिक उन्नत गेम पर स्विच करेंगे या नहीं?"--恭喜您!您的筹码已经上升到一个新的高度,是否立即换到更高级的场玩牌?
L.HALL.TEXAS_UPGRADE = "अभी उन्नत करेंगे"--立即提升
L.HALL.TEXAS_STILL_ENTER = "यह मेज में खेलेंगे"--依旧进入
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
     "आर्डिनरी", --初级场
     "एक्सपर्ट", --中级场
     "मास्टर"--高级场
}
L.HALL.PLAYER_LIMIT_TEXT = {
     "9\n खिलाड़ियां",--9\n人
     "6\n खिलाड़ियां"--6\n人
}
L.HALL.CHOOSE_ROOM_TYPE = {
     "सामान्य",--普通场,
     "जल्दी"--快速场,
}
L.HALL.CHOOSE_ROOM_CITY_NAME = {
     "बैंकाक",--曼谷,
     "हुआहिन",--华欣,
     "पटाया",--芭堤雅,
     "अयूथया",--大城,
     "सुखोथाय",--素可泰,
     "फुकेत",--普吉,

     "सियोल",--首尔,
     "सिंगापुर",--新加坡,
     "कुआलालंपुर",--吉隆坡,
     "शांघाई",--上海,
     "मिलान",--米兰,
     "पेरिस",--巴黎,

     "टोक्यो",--东京,
     "लंदन",--伦敦,
     "न्यूयॉर्क",--纽约,
     "मकाओ",--澳门,
     "दुबई",--迪拜,
     "लासवेगास",--拉斯维加斯,
     
     "हवाई"--夏威夷,
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE ="न्यूनतम{1}/अधिकतम{2}"--最小{1}/最大{2}
L.HALL.CHOOSE_ROOM_BLIND ="बहाना:{1}/{2}"--盲注:{1}/{2}
L.HALL.GIRL_SHORT_CHAT = {
     "नमस्कार मैं डीलर प्यार जी हूँ।",--你好，我是荷官，我叫小爱。,
     "मैं कमरे में आप को इंतज़ार रही हूँ।",--我在游戏房间等你哦~,
     "हमारे खेल बहुत मज़ा है। आशा है कि आप हमेशा खेलिये।",--我们的游戏很好玩的，经常来玩吧。,
     "रूको। आप क्या कर रहा हैं？",--讨~厌~啦~你在做什么？,
     "प्यारा, ज्लदि से खेलेंगे।",--亲爱的快去打牌吧。,
     "प्यार हैं？तो हमें फेसबुक में पसंद दीजिये।",--,喜欢吗？那就去粉丝页点个赞。
     "तुम बहुत प्यारा।सौभाग्य!",-- 你好可爱，祝你好运。,
     "लो मेरा प्यार~ ~(￣3￣)|",--~么么哒~ ~(￣3￣)|~,
     "याद रखते हैं कि हर दिन दोस्त को आमंत्रित करेंगे। इस से अधइक मुफ्त चिप्स ले सकते हैं।"--别忘了每天点击邀请好友一起来捧场哦！大量免费筹码赠送！,
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL ="आफ का स्तर {1} से कम है। कृपया टेक्सस में {2} स्तर होकर यहां आएँगे।"--您的等级不足{1}级，请先在德州场玩到{2}级后再来！
L.HALL.OMAHA_HELP_TITLE ="ओमाहा नियम"--奥马哈规则说明    
L.HALL.OMAHA_RULE = [[
जहां प्रत्येक खिलाड़ी के पास चार छेद कार्ड हैं। और उन्हें अपने दो हाथों का उपयोग करके (सिर्फ दो हाथों का )साथ ही पांच सामुदायिक कार्डों में से तीन।
ओमाहा में क्रैड रैंकिंग टेक्सास के लिए ही है। कृपया तालिका के निचले बाएं कोने में संदर्भ देखें।

हालांकि नियम समान हैं, ओमाहा में छेद कार्ड टेक्सास की तुलना में अधिक महत्वपूर्ण हैं।

ओमाहा और टेक्सास होल्डम के बीच अंतर
1. ओमाहा खेल प्रत्येक खिलाड़ी को 4 छेद कार्ड देना शुरू कर देता है, जबकि टेक्सास होल्डम गेम प्रत्येक खिलाड़ी को 2 छेद कार्ड देता है।
2. प्रत्येक खिलाड़ी को सबसे अच्छा हाथ बनाने के लिए चार छेद कार्ड और तीन सामुदायिक कार्डों में से दो का उपयोग करना चाहिए।
3. टेक्सास होल्डम की तुलना में 22 खिलाड़ियों के लिए, ओमाहा खेल की अधिकतम संख्या 11 खिलाड़ी हैं।
]]
L.HALL.TRACE_LIMIT_LEVEL = "Failed to track.You need to reach level {1} before entering the room"--"追踪失败,需要等级达到{1}级,才可以进入房间"
L.HALL.TRACE_LIMIT_ANTE = "Failed to track.You need to bring {1} chips to enter the room."--"追踪失败,需要携带{1}筹码,才可以进入房间"


-- ROOM MODULE
L.ROOM.OPR_TYPE = {
     "देखेंगे",--看  牌,
     "पैक",--弃  牌,
     "चाल",--跟  注,
     "उठाएँ"--加  注,
}
L.ROOM.MY_MONEY ="मेरे पैसे {1} {2"--}My money {1} {2}
L.ROOM.INFO_UID ="ID {1}"
L.ROOM.INFO_LEVEL ="Lv.{1}"
L.ROOM.INFO_WIN_RATE ="जीत की दर:  {1}%"--胜率:  {1}%
L.ROOM.INFO_SEND_CHIPS ="चिप्स को भेजेंगे।"--赠送筹码
L.ROOM.ADD_FRIEND ="अनुकरण करेंगे"-- 关注
L.ROOM.DEL_FRIEND ="अनुकरण को रद्द करेंगे।"--取消关注
L.ROOM.FORBID_CHAT ="बंद करेंगे"--屏蔽
L.ROOM.CANCEL_FORBID_CHAT ="बंद किया"--已屏蔽
L.ROOM.NO_SEND_CHIP_TIPS = "भेज नहीं सकता है।"--不可赠送
L.ROOM.ADD_FRIEND_SUCC_MSG ="दोस्त जोड़ने में सफलता है।"--添加好友成功
L.ROOM.ADD_FRIEND_FAILED_MSG ="दोस्त जोड़ने में विफल है।"--添加好友失败
L.ROOM.DELE_FRIEND_SUCCESS_MSG ="दोस्त हटाने में सफलता है।"--删除好友成功
L.ROOM.DELE_FRIEND_FAIL_MSG ="दोस्त हटाने में विफल है।"--删除好友失败
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG ="सिर्फ़ सामान्य में चिप्स को भेज सकते हैं।"--只有普通场才可以赠送筹码
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR ="आप के चिप्स डीलर टिप के लिये पर्याप्त नहीं है।"--你的筹码不够多，不足给荷官小费
L.ROOM.SEND_CHIP_NOT_IN_SEAT ="पैठते ही चिप्स को भेज सकते हैं।"--坐下才可以赠送筹码
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS ="पैसे पर्याप्त नहीं हैं।"--钱不够啊
L.ROOM.SEND_CHIP_TOO_OFTEN ="भेजने बहुत जल्दि हैं।"--赠送的太频繁了
L.ROOM.SEND_CHIP_TOO_MANY ="भेजना बहुत अधिक हैं।"--赠送的太多了
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG ="प्रतियोगिता क्षेत्र में आपस वस्तुएं उपयोग नहीं पाते हैं।"--比赛场不能发送互动道具
L.ROOM.SEND_HDDJ_NOT_IN_SEAT ="पैठते हि आपस वस्तुएं उपयोग कर सकते हैं।"--坐下才能发送互动道具
L.ROOM.SEND_HDDJ_NOT_ENOUGH ="आप के आपस वस्तुएं पर्याप्त नहीं हैं।जल्दी से बाज़ार में खरीदें।"--您的互动道具数量不足，赶快去商城购买吧
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT ="पैठते ही इमोजी भेज सकते हैं।"--坐下才可以发送表情
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT ="आप नहीं पैठे। कृपया पैठकर पुनः प्रयास करेंगे।"--您还未坐下，请坐下后重试
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "Sit down to try again."--您还未坐下，请坐下后重试
L.ROOM.CHAT_FORMAT ="{1}: {2}"
L.ROOM.ROOM_INFO ="{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO ="{1}({2 }आदमी)  कमरा संख्या:{3}  बहाना:{4}/{5}"--{1}({2}人)  房间号:{3}  盲注:{4}/{5}
L.ROOM.PRIVATE_ROOM_INFO ="निजी कमरा ({1} आदमी )  कमरा संख्या:{2}  बहाना:{3}/{4}"--私人房({1}人)  房间号:{2}  盲注:{3}/{4}
L.ROOM.PRIVTE_INFO ="कमरे की उपलब्ध समय：{1}"--房间剩余时间：{1}
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL ="लाउडस्पीकर संदेश भेजने में विफल है।"--发送大喇叭消息失败
L.ROOM.NOT_ENOUGH_LABA ="आप के पास लाउडस्पीकर पर्याप्त नहीं है।"--您的大喇叭不足
L.ROOM.CHAT_MAIN_TAB_TEXT = {
     "संदेश",--消息, 
     "संदेश रिकॉर्ड"--消息记录
}
L.ROOM.USER_CARSH_REWARD_DESC ="आप {1} चिप्स दिवालियापन राहत प्राप्त करते हैं। सावधान रहें क्योंकि आप जीवन में केवल 3 बार प्राप्त कर सकते हैं।"--您获得了{1}筹码的破产补助，终身只有三次机会获得，且用且珍惜
L.ROOM.USER_CARSH_BUY_CHIP_DESC ="फिर जीतने के लिए चिप खरीदें।"--您也可以立即购买，输赢只是转瞬的事
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC ="कोई और दिवालिएपन राहत नहीं है। आप मुफ्त चिप्स पाने के लिए दुकान में चिप्स खरीद सकते हैं या कल प्रवेश कर सकते हैं।"--您已经领完所有破产补助，您可以去商城购买筹码，每天登录还有免费筹码赠送哦！
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC ="जीतना आगे इंतजार कर रही है, हार न दें! दोबारा जीतने लिए चिप्स खरीदें।"--输赢乃兵家常事，不要灰心，立即购买筹码，重整旗鼓。
L.ROOM.WAIT_NEXT_ROUND ="अगले खेल करने लिये इन्दज़ार रहा है।"--请等待下一局开始
L.ROOM.LOGIN_ROOM_FAIL_MSG ="कमरे में लोगइन पर विफल था।"--登录房间失败
L.ROOM.BUYIN_ALL_POT="कीमत पूल"--全部奖池
L.ROOM.BUYIN_3QUOT_POT ="3/4कीमत पूल"-- 3/4奖池
L.ROOM.BUYIN_HALF_POT ="1/2कीमत पूल"-- 1/2奖池
L.ROOM.BUYIN_TRIPLE ="तिहरा उठाना"-- 3倍反加
L.ROOM.CHAT_TAB_SHORTCUT ="जल्दी बातचीत"--快捷聊天
L.ROOM.CHAT_TAB_HISTORY ="बातचीत रिकॉर्ड"--聊天记录
L.ROOM.INPUT_HINT_MSG ="संदेश दर्ज करने लिये क्लिक कीजिये"--点击输入聊天内容
L.ROOM.INPUT_ALERT ="कृपया वैध संदेश लिखदर्ज कीजिये"--请输入有效内容
L.ROOM.CHAT_SHIELD ="आप {1} की बात सफलता से बंद किया।"--您已成功屏蔽{1}的发言
L.ROOM.CHAT_SHORTCUT = {
     "नमस्ते",--你们好!,
     "जल्दी से, मुझे बहुत समय इन्दज़ार किया गया था।",--快点，等不了了,
     "ALL IN！！",
     "आराम से।",--冲动是魔鬼，淡定,
     "बहुत अच्छा।",--好厉害,
     "औऱ कौन?",--谁敢来比比,
     "चिप्स के लिए धन्यवाद!",--谢谢你送我筹码,
     "आप के साथ खेलना बहुत रुचि है।",--和你玩牌真有意思,
     "अमीर तो शक्ति।",--有筹码任性,
     "खराब किस्मत!",-- खराब किस्मत!,
     "मत बातें।",--不要吵架,
     "क्या आप के पास लड़का या लड़की दोस्त है?",--有女/男朋友了吗,
     "बुरा हाथ.एक और कमरे में जाउँगा",--牌不好，换房间试试,
     "आपसे मिलकर अच्छे लगे।",--多多关照,
     "सौभाग्य।",--今天手气不错,
     "कृपया मुझे कुछ चिप्स दीजिये",--送点钱吧,
     "चाल! ALL-IN!",--求跟注，求ALL-IN！,
     "मैं चिप्स खरीदूँगा और जल्द ही वापस आ जाऊँगा।",--买点筹码再战！,
     "क्या आप के कार्ड देख सकते हैं?",--可以看看牌吗,
     "माफ़ कीजिय,आब मैं जाऊँगा"--不好意思，先走了
}
L.ROOM.VOICE_TOOSHORT ="समय बहुत छोटा है।"--录音时间太短了
L.ROOM.VOICE_TOOLONG ="समय बहुत बड़ा है।"--录音时间太长了
L.ROOM.VOICE_RECORDING ="रद्द करने के लिए ऊपर ढक्केंगे।"--正在录音，上滑取消
L.ROOM.VOICE_CANCELED ="रद्द किया"--录音已取消
L.ROOM.VOICE_TOOFAST ="आप के संचालन बहुधा है।"--您操作太频繁啦
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
     "{1} धन्यवाद! आप के पास भगवान हमेशा रहते है।",--感谢你{1}！幸运必将常伴你左右！,
     "{1} धन्यवाद! सौभाग्य आ रहा है।",--感谢你{1}！好运即将到来！,
     "अचछा आदमी {1} को धन्यवाद देते हैं।"--感谢好心的{1},
}
--买入弹框
L.ROOM.BUY_IN_TITLE ="चिप्स खरीदेंगे"--买入筹码
L.ROOM.BUY_IN_BALANCE_TITLE ="आपकी पूंजी:"--您的账户余额:
L.ROOM.BUY_IN_MIN ="न्यूनतम खरीदना"--最低买入
L.ROOM.BUY_IN_MAX ="अधिकतम खरीदना"--最高买入
L.ROOM.BUY_IN_AUTO ="जब पैसे बड़ा बहाने से कम है तब स्वचालित खरीदेंगे।"--小于大盲时自动买入
L.ROOM.BUY_IN_AUTO_MIN ="जब पैसे कम से कम  खरीदने से कम हैं तब स्वचालित खरीदेंगे।"--小于最小买入时自动买入
L.ROOM.BUY_IN_BTN_LABEL ="खरीदकर पैठेंगे।"--买入坐下
L.ROOM.ADD_IN_TITLE ="चिप्स को बढ़ाएंगे"--增加筹码
L.ROOM.ADD_IN_BTN_LABEL ="खरीदेंगे"--买 入
L.ROOM.ADD_IN_BTN_TIPS ="पैठते ही चिप्स बढ़ा सकते हैं।"--坐下才能增加筹码
L.ROOM.ADD_IN_BTN_TIPS_2 ="चिप्स को बढ़ाने लिये बाकी चिप्स नहीं है। बढा नहीं सकता है।"--没有多余的筹码，无法增加
L.ROOM.ADD_IN_BTN_TIPS_3 ="आप के चिप्स अधिकतम हैं। और बढ़ा नहीं पाता है।"--您的筹码已经达到场次上限，无法增加更多
L.ROOM.ADD_IN_SUC_TIPS ="बढाने में सफलता है। अगले खेल में और {1} चिप्स बढ़ाएंगे।"--增加成功，将在下局开始为您自动增加{1}筹码
L.ROOM.BACK_TO_HALL ="लॉबी"--返回大厅
L.ROOM.CHANGE_ROOM ="मेज़ बदलेंगे।"--换  桌
L.ROOM.SETTING ="सेटिंग्स"--设  置
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY ="न्यूनतम खरीदारी के लिए पर्याप्त चिप्स नहीं हैं, कमरा बदलिये या चिप्स खरिदिये।"--您的筹码不足当前房间的最小携带，您可以点击换桌系统帮你选择房间或者补足筹码重新坐下。
L.ROOM.AUTO_CHANGE_ROOM ="मेज़ बदलेंगे"--换  桌
L.ROOM.USER_INFO_ROOM ="अपनी जानकारी"--个人信息
L.ROOM.CHARGE_CHIPS ="चिप्स जोड़ेंगे।"--补充筹码
L.ROOM.ENTERING_MSG ="आ रहा है...\nजीतने के लिए आपको साहस और रणनीति दोनों की आवश्यकता है!"--正在进入，请稍候...\n有识尚需有胆方可成赢家
L.ROOM.OUT_MSG ="लोग आउट कर रहा है..."--正在退出，请稍候...
L.ROOM.CHANGING_ROOM_MSG ="कमरा बदल रहा है..."--正在更换房间..
L.ROOM.CHANGE_ROOM_FAIL ="कमरे बदलने में विफल है। पुन: प्रयास करेंगे या नहीं?"--更换房间失败，是否重试？
L.ROOM.STAND_UP_IN_GAME_MSG ="आप अभी भी गोल में हैं, खड़े होगे?"--您还在当前牌局中，确认站起吗？
L.ROOM.LEAVE_IN_GAME_MSG ="आप अभी भी गोल में हैं,छोड़ेंगे?"--您还在当前牌局中，确认要离开吗？
L.ROOM.RECONNECT_MSG ="पुन: कनेक्ट कर रहा है।"--正在重新连接..
L.ROOM.OPR_STATUS = {
     "पैक",--,弃  牌
     "ALL_IN",
     "चाल",--跟  注,
     "{1} चाल",--跟注 {1},
     "छोटा बहाना",--小  盲,
     "बड़ा बहाना",--大  盲,
     "देखना",--看  牌,
     "{1} उठाएँगे",--加注 {1},
     "उठाएँगे"--加  注,
}
L.ROOM.AUTO_CHECK ="स्वचालित देखेंगे"--自动看牌
L.ROOM.AUTO_CHECK_OR_FOLD ="देखना या छोड़ेंगे"--看或弃
L.ROOM.AUTO_FOLD ="स्वचालित छोड़ेंगे"--自动弃牌
L.ROOM.AUTO_CALL_ANY ="सब चाल करेंगे"--跟任何注
L.ROOM.FOLD ="छोड़ेंगे"--弃  牌
L.ROOM.ALL_IN ="ALL IN"
L.ROOM.CALL ="चाल"--跟  注
L.ROOM.CALL_NUM ="{1} चाल"--跟注 {1}
L.ROOM.SMALL_BLIND ="छोटा बहाना"--小盲
L.ROOM.BIG_BLIND ="बड़ा बहाना"--大盲
L.ROOM.RAISE ="उठाएँगे"--加  注
L.ROOM.RAISE_NUM ="{1} उठाएँगे"--加注 {1}
L.ROOM.CHECK ="देखना"--看  牌
L.ROOM.BLIND3 ="3xबड़ा बहाना"--3x大盲
L.ROOM.BLIND4 ="4xबड़ा बहाना"--4x大盲
L.ROOM.TABLECHIPS ="1xपॉट"--1x底池
L.ROOM.TIPS = {
     "केत：अतिथि खाता आपने चित्र या लिंग को परिवर्तन करने लिये आपने चित्र या लिंग को क्लिक करेंगे।",--小提示：游客用户点击自己的头像弹框或者性别标志可更换头像和性别哦,
     "संकेत：यदि आपके हाथ छोटे हैं तो आप चिप्स खो देंगे, पहले से ही जैकपॉट में शर्त लगा लेंगे",--小经验：当你牌比对方小的时候，你会输掉已经押上的所有筹码,
     "सभी व्हेल मछली से आते हैं! सफलता आगे रह रही है, हार न दें!",--高手养成：所有的高手，在他会德州游戏之前，一定是一个德州游戏的菜鸟,
     "अगर आप के पास अच्छे ताश हो तो लोभ कमाने के लिये उठाएँ।",--有了好牌要加注，要掌握优势，主动进攻,
     "आप विरोधियों को ध्यान देते हैं। उन के धोखा मत खाएंगे।",--留意观察对手，不要被对手的某些伎俩所欺骗,
     "अपने विरोधियों को आप से डरते रहो!",--要打出气势，让别人怕你,
     "अपनी भावनाओं को नियंत्रित जीत दौर पर प्राप्त करें।",--控制情绪，赢下该赢的牌,
     "ग्राहस्थ खिलाड़ी अपने चित्र परिवर्तन कर सकता है।",--游客玩家可以自定义自己的头像,
     "संकेत：समय बचाने के लिए सेटिंग में ऑटो खरीद-इन सेट करेंगे",--小提示：设置页可以设置进入房间是否自动买入坐下,
     "संकेत：सेटिंग में  स्पन्दन से अनुस्मारक कर सकता है।",--小提示：设置页可以设置是否震动提醒,
     "ऑल-इन करने के लिये धैर्य आवश्यकता है।",--忍是为了下一次All In,
     "उत्तेजनाओ असुर है। आराम से तो सौभाग्य आ रहा है।",--冲动是魔鬼，心态好，好运自然来,
     "समय आप के पास नहीं है तो स्थिती बदलें।",-- 风水不好时，尝试换个位置,
     "एक बार खोया सही गुमराह नहीं है। आगर आत्मविश्वास खोए तो सहीं खोए।",--输牌并不可怕，输掉信心才是最可怕的,
     "आप नियंत्रिण नहीं है कि जीत है या हार है। पर कितनी बार जीत या हार तो नियंत्रण है।",--你不能控制输赢，但可以控制输赢的多少,
     "ल्मबा समय कार्य नहीं वाले को आप के आपस वस्तु उपोग कर सकता है।",--用互动道具砸醒长时间不反应的玩家,
     "सौभाग्य दृढ़ नहीं है। पर  ज्ञान हमेशा आप के पास रहते हैं।",--运气有时好有时坏，知识将伴随你一生,
     "धोखा जीत के एक तरीका है।अच्छी से उपयोग करेंगे",--诈唬是胜利的一大手段，要有选择性的诈唬,
     "उठाएं में पैसे के अलावा तालाब भी ध्यान देंगे।",--下注要结合池底，不要看绝对数字,
     "सही खइलाड़ी चतुर से ऑल-इन उपयोग कर सकता है।",--All In是一种战术，用好并不容易
    








    
}
L.ROOM.SHOW_HANDCARD ="हाथ कार्ड दिखाएंगे"--亮出手牌
L.ROOM.SERVER_UPGRADE_MSG ="सर्वर उन्नयन कर रहा है, कृपया प्रतीक्षा करेंगे।"--服务器正在升级中，请稍候..
L.ROOM.KICKED_BY_ADMIN_MSG ="आप को मैनेजर से बाहर निकला दिया गया है।"--您已被管理员踢出该房间
L.ROOM.KICKED_BY_USER_MSG ="आप को {1} से बाहर निकला दिया गया है।"--您被用户{1}踢出了房间
L.ROOM.TO_BE_KICKED_BY_USER_MSG ="आप को {1} से बाहर निकला दिया गया है। ईस बार के बाद आप स्वचालित लौट आएंगे"--您被用户{1}踢出房间，本局结束之后将自动返回大厅
L.ROOM.BET_LIMIT ="कॉल करने में विफल।एक दौर आप के कॉल ज़्यादातर 100M है।"--下注失败，您单局下注不能超过最大下注100M限制
L.ROOM.BET_LIMIT_1 ="कॉल करने में विफल।एक दौर आप के कॉल ज़्यादातर {1} है।"--下注失败，您单局下注不能超过最大下注{1}限制。
L.ROOM.NO_BET_STAND_UP = "आप स्वचालित रूप से खड़े हो जाए, क्योंकि आप तीन दौर में कोई काम नहीं करते हैं।"--你三局未操作,已自动站起

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "समान IP पैठ नहीं पाता है।"--坐下失败，同一IP不能坐下
T["SEAT_NOT_EMPTY"] = "इस मेज पर खिलाड़ी पैठा है। आप पैठ नहीं पाते हैं।"--坐下失败，该桌位已经有玩家坐下。
T["TOO_RICH"] ="ईतना चिप्स लेकर नए कमरे में खेल नहीं पाते हैं।"--坐下失败，这么多筹码还来新手场虐人？
T["TOO_POOR"] ="रहने के लिए आप के पास पर्याप्त चिप्स नहीं हैं।"--坐下失败，筹码不足无法进入非新手场房间。
T["NO_OPER"] ="आप 3 बार कोई संचालन नहीं किए। ईसलिये स्वचालित रूप से खड़े था। फिर से शुरू करने के लिए नीचे बैठेंगे।"--您超过三次没有操作，已被自动站起，重新坐下即可重新开始
L.ROOM.SERVER_STOPPED_MSG ="व्यवस्था को रखरखाव के लिए रोका जा रहा है कृपया धैर्य रखिये।"--系统正在停服维护, 请耐心等候
L.ROOM.GUIDEHEIGHT ="ज़्यादा पैसे जीत करने के लिये {1}कमरे जाना चाहिये।"--去{1}场可赢更多钱
L.ROOM.GUIDELOW ="कम पैसे खोने लिये {1}कमरे जाना चाहिये।"--去{1}场可以较少损失
L.ROOM.CARD_POWER_DESC =[[
हाथ कार्ड ताकत मीटर पर जीत दर सिर्फ़ हाथ कार्ड और सामुदायिक कार्ड में आधार है।केवल संदर्भ के लिये है।

निशुल्क उपयोग समय वर्तमान में सीमित है, डिफ़ॉल्ट रूप से खुला।

आप बंद सकते हैं।आगर दुबाला खोलेंगे तो सेटिंग में से खोलेंगे।
]]

--STORE
L.STORE.TOP_LIST = {
"चिप्स",--筹码
"हीरा",--钻石
"वस्तु"--道具
}
L.STORE.NOT_SUPPORT_MSG ="आपका खाता भुगतान का समर्थन नहीं करता है।"--您的账户暂不支持支付
L.STORE.PURCHASE_SUCC_AND_DELIVERING ="भुगतान हो गया। माल भेज रहा है।"--已支付成功，正在进行发货，请稍候..
L.STORE.PURCHASE_CANCELED_MSG ="भुगतान रद्द किया गया।"--支付已经取消
L.STORE.PURCHASE_FAILED_MSG ="भुगतान विफल है।कृपया पुन: प्रयास कीजिये।"--支付失败，请重试
L.STORE.PURCHASE_FAILED_MSG_2 = "请输入正确卡号和密码"
L.STORE.PURCHASE_FAILED_MSG_3 = "此卡已经使用过"
L.STORE.PURCHASE_FAILED_MSG_4 = "此卡无效"
L.STORE.DELIVERY_FAILED_MSG ="नेटवर्क त्रुटि है। जब आप स्टोर में जाते हैं तो सिस्टम अगली बार पुन: प्रयास करेगी"--网络故障，系统将在您下次打开商城时重试。
L.STORE.DELIVERY_SUCC_MSG ="सामान सफलता से भेजे, धन्यवाद।"--发货成功，感谢您的购买。
L.STORE.TITLE_STORE ="बाज़ार"--商城
L.STORE.TITLE_CHIP ="चिप्स"--筹码
L.STORE.TITLE_PROP ="आपस वस्तुएं"--互动道具
L.STORE.TITLE_MY_PROP ="मेरे वस्तुएं"--我的道具
L.STORE.TITLE_HISTORY ="खरीद रिकॉर्ड"--购买记录
L.STORE.RATE_DIAMONDS ="1{2}={1}हीरा"--1{2}={1}钻石
L.STORE.RATE_CHIP ="1{2}={1}चिप्स"--1{2}={1}筹码
L.STORE.RATE_PROP ="1{2}={1}वस्तुएं"--1{2}={1}个道具
L.STORE.FORMAT_DIAMONDS ="{1} हीरा"--{1} 钻石
L.STORE.FORMAT_CHIP ="{1} चिप्स"--{1} 筹码
L.STORE.FORMAT_PROP ="{1} वस्तु"--{1} 道具
L.STORE.FORMAT_HDDJ ="{1}आपस वस्तु"--{1}互动道具
L.STORE.FORMAT_DLB ="{1} ध्वनि विस्तारक"--{1} 大喇叭
L.STORE.FORMAT_LPQ = "{1} Gift Voucher"
L.STORE.FORMAT_DHQ = "{1} Redeem Voucher"
L.STORE.FORMAT_MYB = "{1} Ant Coins"
L.STORE.HDDJ_DESC ="मेज पर खिलाड़ियों के लिए {1} बार आपस वस्तुएं में उपयोग कर सकते हैं।"--可在牌桌上对玩家使用{1}次互动道具
L.STORE.DLB_DESC ="गेम के सभी खिलाड़ियों को {1} बार के लिए प्रसारित कर सकते हैं।"--可在牌桌聊天弹框对全服的玩家发送{1}次广播
L.STORE.BUY ="खरीदेंगे"--购买
L.STORE.USE ="उपयोग करेंगे"--使用
L.STORE.BUY_DESC ="खरीदेंगे {1}"--购买 
L.STORE.RECORD_STATUS = {
"भुगतान किया है",--已下单
"माल भेजा है",--已发货
"वापस किया है"
}
L.STORE.NO_PRODUCT_HINT ="यह माल अभी नहीं है।"--暂无商品
L.STORE.NO_BUY_HISTORY_HINT ="कोई भेजने रिकॉट नहीं है।"--暂无支付记录
L.STORE.BUSY_PURCHASING_MSG ="खरीद रहा है। कृपया इंतज़ार कीजिये।"--正在购买，请稍候..
L.STORE.CARD_INPUT_SUBMIT ="TOP UP"
L.STORE.BLUEPAY_CHECK ="क्या आप तय किया कि {2} के लिये {1} का भुगतान करेंगे?"--你确定要花{1}购{2}吗?
L.STORE.GENERATE_ORDERID_FAIL ="ऑर्डर करने में विफल है।कृपया पुन: प्रयास कीजिये!"--下单失败，请重试！
L.STORE.INPUT_NUM_EMPTY ="क्रमांक खाली! कृपया पुन: प्रयास कीजिये।"--卡号输入不能为空，请重新输入！
L.STORE.INPUT_PASSWORD_EMPTY ="संकेत शब्द खाली! कृपया पुन: प्रयास कीजिये।"--密码输入不能为空，请重新输入！
L.STORE.INPUT_NUM_PASSWORD_EMPTY ="क्रमांक या संकेत शब्द खाली! कृपया पुन: प्रयास कीजिये ।"--卡号或密码输入为空，请重新输入！"
L.STORE.INPUT_CRAD_NUM ="क्रमांक दर्ज कीजिये।"--请输入卡号
L.STORE.INPUT_CRAD_PASSWORD ="संकेत शब्द दर्ज कीजिये।"--请输入密码
L.STORE.QUICK_MORE ="और कुछ देखेंगे।"--查看更多
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
L.VIP.SEND_EXPRESSIONS_FAILED ="आपकी ऑफ-चिप चिप 5,000 से कम है, अस्थायी रूप से VIP अभिव्यक्ति का उपयोग करने में असमर्थ है।"--您的场外筹码不足5000，暂时无法使用VIP表情
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
L.LOGINREWARD.FB_REWARD_TIPS    = "Facebook लॉगइन करके प्राप्त करता है।"--Facebook登录领取
L.LOGINREWARD.FB_REWARD         ="Facebook से लॉगइन और 100%  लेंगे।"--Facebook登录签到多送100%
L.LOGINREWARD.REWARD_BTN        ="लॉगिन इनाम"--签到领奖
L.LOGINREWARD.GET_REWARD_FAILED ="लॉगिन विफल है, कृपया पुन: प्रयास कीजिये।"--签到失败，请重试!
L.LOGINREWARD.VIP_REWARD_TIPS   = "Log in bonus VIP"--"VIP登录奖励"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES ="X{1}"
L.USERINFO.EXPERIENCE_VALUE ="{1}/{2} EXP"--经验值
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
"सामान्य कमरा",--常规场,
"SNG",--坐满即玩,
"सर्वोपरित्व"--锦标赛
}
L.USERINFO.BOARD_SORT = {
"समय",--时间排序, 
"जीत"--输赢排序
}
L.USERINFO.NO_RECORD ="रिकॉट नहीं है।"--暂无记录
L.USERINFO.LAST_GAME ="पिछला दौर"--上一局
L.USERINFO.NEXT_GAME ="अगेले दौर"--下一局
L.USERINFO.PLAY_TOTOAL_COUNT ="दौर:"--牌局:
L.USERINFO.PLAY_START_RATE ="भागीदार दर:"--入局率:
L.USERINFO.WIN_TOTAL_RATE ="जीत दर:"--胜率:
L.USERINFO.SHOW_CARD_RATE ="अंतिम दौर में शामिल दर:"--摊牌率:
L.USERINFO.MAX_CARD_TYPE ="सर्वश्रेष्ठ हाथ"--最大牌型
L.USERINFO.JOIN_MATCH_NUM ="शामिल बार"--参赛次数
L.USERINFO.GET_REWARD_NUM ="ईनाम बार"--获奖次数
L.USERINFO.MATCH_BEST_SCORE ="सर्वोपरित्व के सर्वश्रेष्ठ परिणाम"--锦标赛最好成绩
L.USERINFO.MY_CUP ="मेरे विजय के स्मारक"--我的奖杯
L.USERINFO.NO_CHECK_LINE ="खाली"--未填写
L.USERINFO.BOARD ="खेल रिकॉट"--牌局记录
L.USERINFO.MY_PACK ="मेरा धैली"--我的背包
L.USERINFO.ACHIEVEMENT_TITLE ="उपलब्धियां"--成就
L.USERINFO.REAL_STORE = "उपहार लेन-देन"--礼品兑换
L.USERINFO.LINE_CHECK_NO_EMPTY ="Line खाता खाली नहीं हो सकता है। कृपया फिर से दर्ज कीजिये।"-- Line号不能为空！请重新输入
L.USERINFO.NICK_NO_EMPTY ="नाम खाली नहीं हो पाता है। कृपया फिर से दर्ज कीजिये।"--名字不能为空！请重新输入
L.USERINFO.LINE_CHECK_ONECE ="Line खाता की पहचान करना हर दिन सिर्फ़ एक बार ही है।"--一天只能提交一次Line认证
L.USERINFO.LINE_CHECK_FAIL ="पहचान में विफल है।कृपया पुन: प्रयास कीजिये।"--提交认证失败，请重试!
L.USERINFO.LINE_CHECK_SUCCESS ="पहचान में सफलता है।"--提交认证成功
L.USERINFO.GET_BOARD_RECORD_FAIL ="अपनी रिकॉर्ड जानकारी प्राप्त करने में विफल है। कृपया पॉपअप को बंद करके पुनः प्रयास कीजिये!"--获取个人战绩信息失败，请关闭弹窗重试！
L.USERINFO.PACKAGE_INFO = {
    {
        title ="आपस वस्तु",--互动道具,
        desc ="मेज़ पर खिलाड़ियों के लिए आपस वस्तु में उपयोग कर सकते हैं।"--可以在牌桌上对其他玩家释放的互动道具
    },
    {
        title ="ध्वनि विस्तारक",--,大喇叭
        desc ="गेम के सभी खिलाड़ियों के लिए प्रसारित कर सकते हैं।"--可以在牌桌上对全服的玩家进行广播
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
"चाल स्टेशन",--跟注站,
"सनकी",--疯子,
"शार्क",--紧凶型,
"मूस",--紧弱型,
"रॉक",--岩石型,
"पीला चेतावनी",--黄色警报,
"मछली",--松弱鱼,
"रिवाज"--自定义
}
L.USERINFO.MARK_TITLE ="खिलाड़ि को निशान करेंगे।"--标记玩家
L.USERINFO.MARK_TIPS ="जाँचने निशान पर क्लिक करेंगे।"--点击选中标记
L.USERINFO.MARK_SUCCESS ="खिलाड़ि को निशान करने में सफलता है।"--标记玩家成功
L.USERINFO.MARK_FAIL ="खिलाड़ि को निशान करने में विफल है, कृपया पुनः प्रयास कीजिये।"--标记玩家失败，请重试
L.USERINFO.MARK_NO_EMPTY ="खिलाड़ि के निशान खाली नहीं हो पाता है, कृपया पुनः प्रयास कीजिये।"--玩家标记输入不能为空，请重新输入
L.USERINFO.UPLOAD_PIC_NO_SDCARD ="चित्र अपलोड करने के लिये SD कार्ड की आवश्यकता है।"--没有安装SD卡，无法使用头像上传功能
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL ="चित्र की प्राप्त पर विफल है।"--获取图像失败
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL ="चित्र अपलोड पर विफल है,कृपया पुनः प्रयास कीजिये।"--上传头像失败，请稍后重试
L.USERINFO.UPLOAD_PIC_IS_UPLOADING ="चित्र अपलोड कर रहा है। कृपया इंतज़ार कीजिये।"--正在上传头像，请稍候...
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS ="चित्र की प्राप्त पर सफलता है।"--上传头像成功

-- FRIEND MODULE
L.FRIEND.TITLE ="दोस्त"--好友
L.FRIEND.NO_FRIEND_TIP ="अभी कोई दोस्त भी नहीं है।"--暂无好友
L.FRIEND.SEND_CHIP ="चिप्स भेजेंगे"--赠送筹码
L.FRIEND.RECALL_CHIP ="+{1} को वापस करेंगे"--召回+{1}
L.FRIEND.ONE_KEY_SEND_CHIP ="सब भेजेंगे"--一键赠送
L.FRIEND.ONE_KEY_RECALL ="सब वापस करेंगे"--一键召回
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR ="सब को भेजेने के लिये आप के पास साढ़े चिप्स अपर्याप्त है। कृपया खरीदकर प्रयास कीजिये।"--您的携带筹码的一半不足全部送出，请先补充筹码后重试。
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM ="क्या आप तय किया कि {1}दोसतों को {2}चिप्स भेजेंगे？"--确定要赠你给您的{1}位好友总计{2}筹码吗？
L.FRIEND.ADD_FULL_TIPS ="आपके दोस्त संख्या {1} तक पहुंच गया है। सिस्टम कुछ ऐसे दोोस्तों को निकाल देगा जो लंबे समय तक कार्ड नहीं खेलते हैं।"--您的好友已达到{1}的上限，系统将根据玩牌情况删除长久不玩牌的好友。
L.FRIEND.SEND_CHIP_WITH_NUM ="{1}चिप्स भेजेंगे"--赠送{1}筹码
L.FRIEND.SEND_CHIP_SUCCESS ="आपने दोस्तों को {1} चिप्स भेजने पर सफलता है।"--您成功给好友赠送了{1}筹码。
L.FRIEND.SEND_CHIP_PUSH = "{1} send 10K chips to you. Receive now! "--赠送了10K筹码给你，快来领取吧！
L.FRIEND.SEND_CHIP_TOO_POOR ="आप के पास चिप्स अपर्याप्त है। कृपया खरीदकर प्रयास कीजिये।"--您的筹码太少了，请去商城购买筹码后重试。
L.FRIEND.SEND_CHIP_COUNT_OUT ="एक दिन एक दोस्त को सिर्फ एक बार चिपस भेज सकते हैं।"--您今天已经给该好友赠送过筹码了，请明天再试。
L.FRIEND.SELECT_ALL ="सब को चुनना"--全选
L.FRIEND.SELECT_NUM ="{1 }आदमी को चुनना"--选择{1}人
L.FRIEND.DESELECT_ALL ="चुनने को रद्द करेंगे"--取消选择
L.FRIEND.SEND_INVITE ="आमंत्रित करेंगे"--邀请
L.FRIEND.INVITE_SENDED ="आमंत्रित किया गया।"--已邀请
L.FRIEND.INVITE_SUBJECT ="आप ज़रूरत पसंदीदा हैं।"--您绝对会喜欢
L.FRIEND.CALL_FRIEND_TO_GAME ="यह खेल बहुत अच्छा है। मेरे साथ खेलो।"--来玩牌吧！很好玩的游戏
L.FRIEND.INVITE_CONTENT ="ताश खेलिये, जो रोमांचक औरसुखदायक खेल है।मैं आप को एक 15लाख चिप्स आप को इंतज़ार रहा है। लॉगइन करेंगे और मेरे साथ खेलो"--为您推荐一个既刺激又有趣的扑克游戏，我给你赠送了15万的筹码礼包，注册即可领取，快来和我一起玩吧！..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP ="आप {1} दोस्तों को जुना है।आमंत्रित करके {2}चिप्स लेंगे।"--您已选择了{1}位好友，发送邀请即可获得{2}筹码的奖励
L.FRIEND.INVITE_SELECT_TIP_1 ="आप जुाना है कि"--您已选择了
L.FRIEND.INVITE_SELECT_TIP_2 ="दोस्त, आमंत्रित करते हैं तो "--位好友，发送邀请即可获得
L.FRIEND.INVITE_SELECT_TIP_3 ="चिप्स लेंगे।"--筹码的奖励
L.FRIEND.INVITE_SUCC_TIP ="आमंत्रित करने पर सफलता है। {1}चिप्स प्राप्त है।"--成功发送了邀请，获得{1}筹码的奖励！
L.FRIEND.INVITE_SUCC_FULL_TIP ="आमंत्रित करने पर सफलता है। आज {1}चिप्स प्राप्त है।"--成功发送邀请，今日已获得{1}邀请发送奖励。
L.FRIEND.INVITE_FULL_TIP ="आज के आमंत्रित चिप्स इतना ही है।कृपया कल फिर भी आमंत्रित कीजिये।"--您今日已达邀请上限，请明日再发送
L.FRIEND.RECALL_SUCC_TIP ="आमंत्रित में सपलता है। दोस्त लॉगइन करके आप और {2} चिप्स प्राप्त कर सकते हैं।"--发送成功奖励{1}，好友上线后即可获赠{2}筹码奖励。
L.FRIEND.RECALL_FAILED_TIP ="आमंत्रित करने पर विफल है।कृपया बाद में फिर से प्रयास कीजिये।"--发送失败，请稍后重试.
L.FRIEND.INVITE_LEFT_TIP ="आज आप और {1} दोस्तों को आमंत्रित सकते हैं।"--今天还可以邀请{1}个好友！
L.FRIEND.CANNOT_SEND_MAIL ="आपने ई-मेल खाता सेट नहीं किया था। अब सेट करेंगे?"--您还没有设置邮箱账户，现在去设置吗？
L.FRIEND.CANNOT_SEND_SMS ="क्षमा करें, SMS लोड करना विफल रहा।"--对不起，无法调用发送短信功能！
L.FRIEND.MAIN_TAB_TEXT = {
"मेरे पसंदीदा",--我关注的,
"मुझ को पसंदीदा",--关注我的,
"और कुछ दोस्त"--更多好友
}
L.FRIEND.INVITE_EMPTY_TIP ="कृपया दोस्त को चुनिये।"--请先选择好友
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG ="आप के दोस्तों संख्या {1} तक हैं। कृपया कुछ दोस्तों को हटाकर  पुनः प्रयास कीजिये।"--您的好友已达到{1}上限，请删除部分后重新添加
L.FRIEND.SEARCH_FRIEND ="FB दोस्त का नाम दर्ज कीजिये।"--请输入FB好友名称
L.FRIEND.INVITE_REWARD_TIPS_1 ="आप आमंत्रित भेज सकता है।"--邀请
L.FRIEND.INVITE_REWARD_TIPS_2 ="दोस्त आमंत्रित करके वह प्राप्त हो सकता है जो"--位好友可获得
L.FRIEND.INVITE_REWARD_TIPS_3 =",ज़्यादा दोस्त को आमंत्रण भेजते तो ज़्यादा ईनाम प्राप्त हैं,आगर दोस्त सफलता लॉगइन करें तो और कुछ प्राप्त हो।"--,好友越多奖励越多,每位好友成功登录游戏还可以再获得
L.FRIEND.SEARCH ="तलाश करेंगे"--查找
L.FRIEND.CLEAR ="हटाएंगे"--清除
L.FRIEND.INPUT_USER_ID ="खिलाड़ी ID दर्ज करने के लिए क्लिक कीजिये"--点击输入玩家ID
L.FRIEND.INPUT_USER_ID_NO_EXIST ="दर्ज किया ID मौजूद नहीं है,कृपया पुष्टि करके पुनः प्रयास कीजिये।"--您输入的ID不存在，请确认后重新输入
L.FRIEND.NO_SEARCH_SELF ="आपने ID तलाश नहीं कर सकता है, कृपया पुनः प्रयास कीजिये।"--无法查找自己的ID，请重新输入
L.FRIEND.NO_LINE_APP ="आप Line app स्थापित नहीं किया है,कृपया अन्य तरीके से आमंत्रित भेजिये।"--您没有安装Line应用,请使用其他方式邀请
L.FRIEND.INVITE_REWARD_TIPS ="आमंत्रित संख्या तक और बड़ा इनाम भेजेंगे।इनाम का विवरण देखने लिये यहां क्रिक्ट कीजिये।\nआपने कुल {1} दोस्त को आमंत्रित करने पर सफलता था, इसलिये {2} चिप्स के इनाम प्राप्त है।"--达成邀请人数还有超级大礼包赠送，可点击礼包查看详情\n您累计成功邀请了{1}位好友，获得了{2}的筹码奖励
L.FRIEND.INVITE_FB_FRIEND_TITLE ="FB दोस्त को आमंत्रित भेजेंगे।"--邀请FB好友
L.FRIEND.INVITE_FB_FRIEND_CONTENT ="प्रतिदिन भेजता तो {1} प्राप्त है। \n सफलता हो गया तो और {2} चिप्स प्राप्त है।"--每天发送就送{1}\n成功一个再送{2}筹码
L.FRIEND.INVITE_CODE_TITLE ="आमंत्रित संख्या"--邀请码
L.FRIEND.INVITE_CODE_CONTENT ="सफलता हो तो और {1} प्राप्त हो।\nदोस्त के दोस्त और {2} प्राप्त हो।"--成功就送{1}\n好友的好友再送{2}
L.FRIEND.GET_REWARD_TIPS_1 ="बधाई दे! जो आप आमंत्रित इनाम प्राप्त है।"--恭喜您获得了邀请奖励!
L.FRIEND.GET_REWARD_TIPS_2 ="आज आप और {1} आमंत्रित भेजकर इनाम प्राप्त सकता है!"--您还差{1}人才能领取奖励，点击邀请按钮继续邀请您的好友吧!
L.FRIEND.ROOM_INVITE_TITLE ="आमंत्रित"--邀请打牌
L.FRIEND.ROOM_INVITE_SUCCTIPS ="आमंत्रित भेजा है। कृपया इंतज़ार कीजिये।"--邀请已发出，请耐心等待
L.FRIEND.ROOM_INVITE_TAB = {
"ऑनलाइन",--当前在线,
"दोस्त"--好友
}
L.FRIEND.ROOM_INVITE_TIPS_CON ="{1} आप को आमंत्रित भेजा कि {2} {3} के साथ कॉड खेलो।"--{1}邀请您去{2}{3}一起玩牌
L.FRIEND.ROOM_INVITE_PLAY_DES ="लोग मज़ा तो सचि मज़ा है। दोस्त को आमंत्रित भेजने के लिए बटंस पर क्लिक करेंगे।\n\nस्थापना के बाद, सीधे क्लिक करने के लिए लिंक पर क्लिक करें या रीफ्रेश करेंगे।"--独乐乐不如与众乐乐，您可以点击下面的按钮发送链接发送给好友或者群里邀请大家一起来玩。\n\n好友安装后点击或者刷新页面即可直接进入房间。

-- RANKING MODULE
L.RANKING.TITLE ="ज्येष्ठता"--排行榜
L.RANKING.TRACE_PLAYER ="ट्रैक करेंगे"--追踪玩家
L.RANKING.GET_REWARD_BTN ="लेना"--领取
L.RANKING.NOT_DATA_TIPS ="अभी कोई भी नहीं है"--暂无数据
L.RANKING.NOT_IN_CHIP_RANKING ="आप की ज्येष्ठता:>20,ज्येष्ठता में नहीं है। कृपया प्रयास कर रहेंगे।"--您的排名:>20名,您暂时未进入排行榜，请继续加油!
L.RANKING.IN_RANKING ="आप की ज्येष्ठता:{1}, कृपया प्रयास कर रहेंगे।"--您的排名:第{1}名，再接再厉！
L.RANKING.IN_RANKING_NO_1 ="आप की ज्येष्ठता:1, कितना शक्ति है!"--您的排名：第1名，无敌是多么寂寞！
L.RANKING.MAIN_TAB_TEXT = {
"दोस्तों की ज्येष्ठता",--好友排行,
"संसार की ज्येष्ठता"--世界排行,
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
"पिछले दिन कमाने की ज्येष्ठता",--昨日盈利榜,
"लाभ की  ज्येष्ठता"--财富榜,
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
"पिछले दिन कमाने की ज्येष्ठता",--昨日盈利榜,
"लाभ की  ज्येष्ठता"--财富榜,
}

-- SETTING MODULE
L.SETTING.TITLE ="सेटिंग"--设置
L.SETTING.NICK ="नाम"--昵称
L.SETTING.LANGUAGE ="भाषा"--语言
L.SETTING.EXCHANGE ="उपहार संख्या"--兑换码
L.SETTING.LOGOUT ="लॉगआउट"--登出
L.SETTING.FB_LOGIN ="लॉगइन  +19999"--登录 +19999
L.SETTING.SOUND_VIBRATE ="आवाज़ और झटका"--声音和震动
L.SETTING.SOUND ="आवाज़"--声音
L.SETTING.BG_SOUND ="पृष्ठभूमि ध्वनि"--背景音效
L.SETTING.CHATVOICE ="बातजीत ध्वनि"--聊天音效
L.SETTING.VIBRATE ="झटका"--震动
L.SETTING.AUTO_SIT ="कमरे जाने समय स्वचालित नीचे बैठेंगे।"--进入房间自动坐下
L.SETTING.AUTO_BUYIN ="अगर चिप्स बड़ा बहाना से कम है तो स्वचालित खरीदेंगे।"--小于大盲时自动买入
L.SETTING.CARD_POWER ="हाथ कार्ड ताकत मीटर"--牌力指示器
L.SETTING.APP_STORE_GRADE ="इस खेल को प्यार लगते हैं? अब 5 सितारे दीजिये!"--喜欢我们，打分鼓励
L.SETTING.CHECK_VERSION ="अपडेट जांचेंगे"--检测更新
L.SETTING.CURRENT_VERSION ="वर्तमान संस्करण : V{1}"--当前版本号：V{1}
L.SETTING.ABOUT ="संबंधित"--关于
L.SETTING.PUSH_NOTIFY = "सूचना"--推送通知
L.SETTING.PUSH_TIPS = [[
प्रणाली हर दिन बेतरतीब ढंग से बड़ा मुफ्त चिप्स भेजेगा। यह पहली आती-पहली सेवा के आधार पर की जाएगी।
यह खोलने के बाद, आप तेज़ से धन प्राप्त कर सकते हैं।

निश्चित करेंगे क्लिक से सूचना प्रबंध-सूचना खोलकर मुफ्त चिप्स प्राप्त सकते हैं।
]]

--HELP
L.HELP.TITLE ="मदद केंद्र"--帮助中心
L.HELP.FANS ="आधिकारिक फैन पेज"--官方粉丝页
L.HELP.LINE ="OpenPoker"--
L.HELP.MAIN_TAB_TEXT = {
"खेलने के परिचय",--玩法介绍,
"नाम का मतलब",--名词解释,
"स्तर  के संचालन",--等级说明,
"सामान्य प्रश्न",--常见问题,
"प्रश्र प्रतिपुष्टि"--问题反馈,
}

L.HELP.PLAY_SUB_TAB_TEXT = {
"खेलने के अनुदेश",--玩法说明,
"ताश के अनुदेश",--比牌规则,
"संचालन के अनुदेश",--操作说明,
"बटन अनुदेश"--按钮说明,
}

L.HELP.LEVEL_RULE ="कार्ड खेलने तो अनुभव प्राप्त कर सकते हैं।सामान्य में एक बार जीत+2, हार +1, विशेष खेल प्रतियोगिता जैसे में अनुभव नहीं है।"--玩牌即可获得经验,普通场入局一次赢钱+2, 输钱+1,特殊场次玩牌不加经验,如比赛场
L.HELP.LEVEL_TITLES = {
"स्तर",--等级,
"शीर्षक",--称号,
"अनुदेश",--经验,
"इनाम"--奖励
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
"वेतन समस्या",--支付问题,
"खाता समस्या",--账号问题,
"Bugs",--游戏BUG,
"सुझाव"--游戏建议,
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
"खेल के डेटा",--玩法数据说明,
"खिलाड़ी भेद दिखाना"--玩家类型标注,
}

L.HELP.FEED_BACK_SUCCESS ="प्रतिपुष्टि में सफलता है!"--反馈成功!
L.HELP.FEED_BACK_FIAL ="प्रतिपुष्टि पर विफल है! कृपया पुनःप्रयास कीजिये!"--反馈失败!请重试!"-
L.HELP.UPLOADING_PIC_MSG ="चित्र अपलोड कर रहा है। कृपया इंदज़ार कीजिये।"--正在上传图片，请稍候..
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG ="कृपया प्रतिपुष्टि की सामग्री दर्ज कीजिये।"--请输入反馈内容
L.HELP.MATCH_QUESTION ="प्रतियोगिता समस्या"--比赛问题
L.HELP.FAQ = {
    {
   "मेरे पास चिप्स नहीं है, पर मैं कैसे खेलेंगे ?",--我的筹码用完了，但是还想玩，要怎么办？,
   "बाजार में चिप्स खरीद सकते है। जो चित्र के दायाँ ओर का।"--点击头像右侧的商城购买筹码即可。
    },
    {
   "क्यों मैं चिप्स भेज नहीं सकता？",--为什么我赠送不了游戏币？,
   "आप तालिका में प्रति सिर्फ़ खिलाड़ी 5K चिप्स भेजते हैं, मित्र सूची में 500 चिप्स भेज सकते हैं।"--在牌桌上每人每天只能赠送五千，在好友列表里每人每天只能赠送五百。
    },
    {
   "मुफ्त चिप्स कहां प्राप्त हैं？",--在哪里领取免费筹码？,
   "जैसे लॉगइन इनाम, ऑनलाइन इनाम, काम इनाम, प्रशंसक इनाम आमंत्रित इनाम आदि इनाम है।"--有登录奖励、在线奖励、任务奖励、粉丝奖励、邀请好友奖励等，还有不同的活动。
    },
      {
   "चिप्स कैसे खरीदता है？",--怎样购买筹码？,
   "बाज़ार में बहुत भेद चिप्स खरीद सकते हैं।"--点击商城按钮，然后选择您需要的筹码。
    },
     {
   "प्रशंसक कैसे बनता है？",--怎样成为粉丝？,
   "सेटिंग बटन पर क्लिक करके, प्रशंसक पृष्ठ नीचे दिखाई देगा या लिंक पर क्लिक करता है या"..appconfig.FANS_URL.."क्लिक करता है।/ \nसिस्टम प्रशंसक से उपहार हमेशा भेजते हैं।"
    },
     {
   "कैसे लॉगआउट करता है？",--怎样登出？,
   "सेटिंग बटन पर क्लिक करके, लॉगआउट क्लिक करता है।"--点击设置按钮，再选择登出即可。
    },
     {
   "नाम चित्र और लिंग कैसे बदलता है？",--怎样改变名字、头像和性别？,
   "अपने चि्त्र क्लिक करके नाम चित्र और लिंग क्लिक करता है।"--点击自己的头像，点击不同功能按钮即可。
    },
     {
   "Line खाता की पहचान  क्या है？",-- line认证是什么？,
   "आधिकारिक line खाता के साथ मित्र जोड़ेंगे: OpenPoker। कर्मचारी द्वारा पहचान के बाद और मित्र प्राप्त करने के लिए गेम में अपना सही line खाता दिखाएंगे।"--添加官方Line号:OpenPoker，经过工作人员认证后，在游戏里显示您正确的line号，方便交到更多朋友
    }
}

L.HELP.PLAY_DESC = {
"हाथ कार्ड",--手牌,
"जाति कार्ड",--公共牌,
"हो गया कार्ड",--成牌,
"खिलाड़ीA",--玩家A,
"खिलाड़ीB",--玩家B,
"फ्लॉप",--翻牌,
"मोड़",--转牌,
"नदी",--河牌,
"फूल हाउस जीत",--葫芦 WIN,
"द्विपदी हीर"--两对 LOSE,
}

L.HELP.PLAY_DESC_2 ="दौर के पहले, हर खिलाड़ी के हाथ में 2 कार्ड है,डीलर 3बार में 5  जाति कार्ड देता है।अपने हाथ कार्ड और  जाति कार्ड में ज़्यादातर 5  कार्ड और दूसरे कार्ड के साथ तुलता है। इस से तय किया कि कौन जीत है।"--在牌局开始的时候，每个玩家分的两张牌作为"--底牌"--，荷官会分三次连续发出五张公共牌。由每个玩家的底牌和公共牌中选出组合成最大牌型的五张与其他玩家比较，判定胜负。

L.HELP.RULE_DESC = {
"रोयल फ्लुश",--皇家同花顺,
"स्त्रैघ्त२ फ्लुश",--同花顺,
"चारों",--四条,
"फूल हाउस",--葫芦,
"सब एक प्रकार",--同花,
"फ्लुश",--顺子,
"तीनों",--三条,
"दो जोड़ा",--两对,
"जोड़ा",--一对,
"उच्च कार्ड"--高牌,
}
L.COMMON.CARD_TIPS ="कार्ड प्रकार सुचना"--牌型提示
L.COMMON.TEXAS_CARD_TYPE = L.HELP.RULE_DESC
T = {}
L.COMMON.CARD_TYPE = T
T[1] =""
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
"ज़्यादातर अनुक्रम जो एक प्रकार का",--同一花色最大的顺子,
"एक प्रकार का अनुक्रम",--同一花色的顺子,
"चार समान संख्या कार्ड और कोई एक कार्ड",--4张相同+1单张,
"तीन समान संख्या कार्ड और एक जोड़ा",--3张相同+1对,
"एक सूट के पांच कार्ड",--5张牌花色相同,
"अलग सूट का फ्लुश",--花色不同的顺子,
"तीन समान संख्या कार्ड और कोई दो कार्ड",--3张相同+2单张,
"दो जोड़ा औऱ कोई एक कार्ड",--2对+1单张,
"एक जोड़ा और कोई तीन कार्ड",--1对+3单张,
"कोई पांच कार्ड"--5个单张牌
}
L.HELP.OPERATING_DESC = {
"व्यंजन सूची",--主菜单,
"चिप्स खरीदेंगे",--购买筹码,
"तालाब और उन के पार",--池底+边池,
"बैंकर",--庄家,
"जाति कार्ड",--公共牌,
"हाथ कार्ड",--底牌,
"कार्ड प्रकार सुचना",--牌型提示,
"ऑपरेशन इंटरफ़ेस",--操作界面,
"चिप्स लेता",--带入筹码, 
"कार्ड प्रकार और संभावना",--牌型大小和成牌概率,
"दो जोड़ा",--两对,
"उठाएँगे",--加注,
"चाल",--跟注,
"छोड़ेंगे"--弃牌,
}

L.HELP.FEED_BACK_HINT = {
"जल्दी से सम्सया दूर करने के लिये कृपया विस्तृत भुगतान जानकारी ज़्यादातर दीजिये।",--请尽可能提供详细的支付信息以方便我们的客服人员快速为您解决问题,
"सम्सया दूर करने के लिये अपने खाता ID दिखाइये। जो चित्र के निचे है।",--请提供您的用户ID以便我们为您解决问题，用户ID一般位于头像下方,
"माफ़ कीजिये। समस्य के जवाब हम आप को जल्दी से बताएंगे।",--非常抱歉，您提出的任何问题我们都会第一时间给出反馈,
"कृपया जब तक समस्या या सूझाव मिलते है। तब तक हमें बताएंगे। इन से हमें बहुत स्वागत है।"--非常欢迎您对我们提出的任何建议或者意见，您的反馈是我们持续优化的动力,
}

L.HELP.PLAY_BTN_DESC = {
    {
        title="देखेंगे",--看牌,
        desc="अगर कोई भी नहीं उठाया तो अगले लोग तय कीजिये।",--在无人下注的情况下选择把决定"让"给下一位。,
        type = 1
    },
    {
        title="छोड़ेंगे",--弃牌,
        desc="खेल को जारी रखने का मौका छोड़ देंगे।",--放弃继续牌局的机会。
        type = 1
    },
    {
        title="चाल करेंगे",--跟注,
        desc="दूसरे लोग के साथ सामान्य चिप्स देंगें।",--跟随众人押上同等的注额,
        type = 1
    },
    {
        title="ज़्यादा उठाएंगे",--加注,
        desc="आब के चिप्स से ज़्यादा उठाएंगे।",--把现有的注金抬高,
        type = 1
    },
    {
        title="सब उठाएंगे",--全下,
        desc="एक बार सब चिप्स उठाएंगे",--一次把手上的筹码全部押上。,
        type = 1
    },
    {
        title="देखेंगे या छोड़ेंगे",--看或弃牌,
        desc="पहले से देखेंगे। अगर उठाएं हो तो छोड़ेंगे।",--首先看牌，如果需要下注则选择弃牌,
        type = 2
    },
    {
        title="छोड़ेंगे",--弃牌,
        desc="अपने आप छोड़ेंगे",--自动弃牌,
        type = 2
    },
    {
        title="सब चाल करेंगे",--跟任何注,
        desc="इतना में अपने आप चाल करेंगे",--字段选择跟任何注,
        type = 2
    },
}

L.HELP.PLAY_DATA_DESC = {
     {
        title="VPIP",--入池率/入局率,
        desc="VPIP(VP)का मतलब है कि खिलाड़ी  पहलकदमी से चाल करने के अंश हैं।"--VPIP（通常缩写为VP）是玩家主动向底池中投入筹码的比率。    
     },
     {
        title="PFR",--翻牌前加注率,
        desc="PFR का मतलब है कि खिलाड़ी फ्लॉप के पहले उठाने के अंश है।"--PFR即翻牌前加注，指的是一个玩家翻牌前加注的比率。    },
     },
     {
        title="AF",--激进度,
        desc="AF का मतलब है कि खिलाड़ी खेल समय में लड़ाका के स्तर हैं।"--AF即是用来衡量一个玩家打牌激进程度的数值。    },
     },
     {
        title="बार से उठाने अंश",--再次加注率,
        desc="बार से उठाने अंश का मतलब है कि एक खिलाड़ी उठाकर और दीसरे खिलाड़ी उठाकर फिर से वह उठाता है।"--即在他人下注，有人加注之后的再加注，由于是一轮下注中的第三次加注，故称3bet。    },
     },
     {
        title="शुद्ध उठाने अंश",--偷盲率,
        desc="शुद्ध उठाने अंश का मतलब सिर्फ़ जीत करने लिये उठाने अंश है।"--Stealing Blinds即偷盲,是指一个玩家单纯的为了赢得盲注而加注。    },
     },
     {
        title="जारी से उठाने अंश",--持续下注率,
        desc="जारी से उठाने अंश का मतलब है कि पीछले बार में तो उठाया है इस बार में फिर भी उठाता है।"--Cbet即持续下注，是指一个玩家在前一轮主动下注或加注后，在当前这一轮再次主动下注。    },
     },
     {
        title="WTSD",--摊牌率,
        desc="WTSD का मतलब है कि कितने अंश में जहां खिलाड़ी ने दूसरे सट्टेबाजी के दौर को देखता है, वह भी तसलीम के पास करता है।"--WTSD即摊牌率，是指一个玩家看到翻牌圈并玩到摊牌的百分比。    },
     },
     {
        title="सौ में जीत अंश",--百手盈利率,
        desc="सौ में जीत अंश का मतलब सौ दौर में कितने अंश जीत है।"--BB/100（百手盈利率）：BB是Big Blind（大盲注）的简称，BB/100用以衡量玩家每玩100手牌局的盈亏。    },
     },
}

L.HELP.PLAYER_TYPE_DESC = {
     {
        title="चाल स्टेशन",--跟注站,
        desc="सिर्फ चाल कर आता है।"--只会被动的跟注
     },
     {
        title="सनकी",--疯子,
        desc="वह अति-आक्रामक उठाता है, सट्टेबाजी और बुलबुले के बहुत सारे करता है।"--疯狂的玩家，热衷于诈唬，非常激进    },
     },
     {
        title="शार्क",--紧凶型（鲨鱼）,
        desc="वह सावधानी और आक्रामक रूप से खेलता।"--玩的很紧且具有一定的攻击性。
     },
     {
        title="मूस",--紧弱型（老鼠）,
        desc="वह ज़्यादा सावधानी है। सरल से भागता है।"--玩的很紧，较胆小，容易被诈唬吓跑的玩家
     },
     {
        title="रॉक",--岩石型,
        desc="बहुत सावधानी है। कम कार्य करता है।"--非常紧且被动。你不会在这种对手身上得到太多行动
     },
     {
        title="पीला चेतावनी",--黄色警报,
        desc="उसने बहुत बार कार्ड खेला।वह हमेशा अपने कार्ड को उच्च देखता है।"--玩太多牌，而且容易高估自己的牌力。
     },
     {
        title="मछली",--松弱鱼,
        desc="उसने बहुत बार कार्ड खेला।पर आक्रामक बहुत कमी है।"--玩太多牌，而翻牌后打法又很被动
     },
}

--UPDATE
L.UPDATE.TITLE ="नया संस्करण पता चला।"--发现新版本
L.UPDATE.DO_LATER ="बाद में"--以后再说
L.UPDATE.UPDATE_NOW ="अभी अद्यतन करेंगे"--立即升级
L.UPDATE.HAD_UPDATED ="आप नवीनतम संस्करण में खेल रहे हैं।"--您已经安装了最新版本

--ABOUT
L.ABOUT.TITLE ="संबंधित"--关于
L.ABOUT.UID ="खिलाड़ी खाता: {1}"--当前玩家ID: {1}
L.ABOUT.VERSION ="संस्करण:V{1}"--版本号：V{1}
L.ABOUT.FANS ="प्रशंसक पृष्ठ :\n"--官方粉丝页:\n .. appconfig.FANS_URL
L.ABOUT.SERVICE ="गोपनीयता और सेवा खंड"--服务条款与隐私策略
L.ABOUT.COPY_RIGHT ="Copyright ©  2024 OpenPoker Technology CO., LTD All Rights Reserved."--

--DAILY_TASK
L.DAILY_TASK.TITLE ="काम"--任务
L.DAILY_TASK.SIGN ="लॉगइन"--签到
L.DAILY_TASK.GO_TO ="प्राप्त करेंगे।"--去完成
L.DAILY_TASK.GET_REWARD ="इनाम की प्राप्त है।"--领取奖励
L.DAILY_TASK.HAD_FINISH ="हो गया"--已完成
L.DAILY_TASK.TAB_TEXT = {
"काम",--任务,
"उपलब्धियां"--成就
}

-- count down box
L.COUNTDOWNBOX.TITLE ="उलटी गिनती उपहार डिब्बा"--倒计时宝箱
L.COUNTDOWNBOX.SITDOWN ="पैठते ही साम गिन सकता है।"--坐下才可以继续计时。
L.COUNTDOWNBOX.FINISHED ="आज आप के डिब्बा सब प्राप्त है। कल और प्राप्त होगे।"--您今天的宝箱已经全部领取，明天还有哦。
L.COUNTDOWNBOX.NEEDTIME ="{1}:{2}मिनट के पाद आप {3} प्राप्त होगे।"--再玩{1}分{2}秒，您将获得{3}。
L.COUNTDOWNBOX.REWARD ="बधाई! आप डिब्बा प्राप्त है।"--恭喜您获得宝箱奖励{1}
L.COUNTDOWNBOX.TIPS ="दोहरा इनाम प्राप्त हो सकते हैं।\nजो दोस्त सफलता से आमंत्रित करता है।"--成功邀请好友进游戏\n可以得到翻倍奖励

-- act
L.NEWESTACT.NO_ACT ="कोई गतिविधि नहीं है।"--暂无活动
L.NEWESTACT.LOADING ="चित्र लोड कर रहा है।"--请您稍安勿躁,图片正在加载中...
L.NEWESTACT.TITLE ="गतिविधि"--活动
L.NEWESTACT.PLAY_CARD_BLIND = "Blind {1} of playing Texas poker"
L.NEWESTACT.PLAY_CARD_TIPS_1 = "Play"
L.NEWESTACT.PLAY_CARD_TIPS_2 = " hand, Get "
L.NEWESTACT.PLAY_CARD_TIPS_3 = "chips"
L.NEWESTACT.PAY_TIPS = "After the activity，The system will send the reward directly to your information box."--"活动结束后，系统会把奖励直接发送到您的信息栏"
L.NEWESTACT.PAY_TIPS_1 = "The total amount of recharge is over"
L.NEWESTACT.PAY_TIPS_2 = "，Get"

--feed
L.FEED.SHARE_SUCCESS ="शयर करने पर सफलता है।"--分享成功
L.FEED.SHARE_FAILED ="शयर करने पर विफल है।"--分享失败
L.FEED.NO_CLIENT_TIPS ="आप {1} app स्थापित नहीं किया है,कृपया अन्य तरीके से आमंत्रित भेजिये।"--您没有安装{1}应用,请使用其他方式邀请
L.FEED.COPY_TIPS ="साझा की गई सामग्री को कॉपी कर दिया गया है और आप दोस्तों को भेजने के लिए अन्य एप्लिकेशन पेस्ट कर सकते हैं।"--分享内容已复制,您可以直接粘贴到其他应用发送给好友
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
    name ="मैंने सुपर टेक्सास होल्डम के लकी चक्र में {1} का इनाम जीता था। आओ और मेरे साथ खेलो।",--我在开源德州扑克的幸运转转转获得了{1}的奖励，快来和我一起玩吧！,
    caption ="खुशी चक्र, इनारत ज़रीरत जीत है।",--开心转转转100%中奖,
    link = L.FEED.SHARE_LINK .."&feed=1",
    picture = appconfig.FEED_PIC_URL.."1.jpg",
    message ="",
}
L.FEED.WHEEL_ACT = {
    name ="मेरे साथ खुशी चक्र खेलो। रोज़ दिन लॉगइन और तीन मौका दें।",--快来和我一起玩开心转转转吧，每天登录就有三次机会！,
    caption ="खुशी चक्र, इनारत ज़रीरत जीत है।",--开心转转转100%中奖, 
    link = L.FEED.SHARE_LINK .."&feed=2",
    picture = appconfig.FEED_PIC_URL.."2.jpg",
    message ="",
}
L.FEED.LOGIN_REWARD = {
    name ="बहुत अच्छा! मैंने ओपन सोर्स टेक्सास होल्डम में {1} चिप्स का इनाम प्राप्त किया है। जारी रखें!",--太棒了!我在开源德州扑克领取了{1}筹码的奖励，快来和我一起玩吧！,
    caption ="दिन दिन लॉगइन,दिन दिन इनाम लें।",--登录奖励天天送不停,
    link = L.FEED.SHARE_LINK .."&feed=3",
    picture = appconfig.FEED_PIC_URL.."3.jpg",
    message ="",
}
L.FEED.INVITE_FRIEND = {
    name ="ओपन सोर्स टेक्सास होल्डम, सबसे नया और सबसे भीड़ वाला खेल है। सभी दोस्त इसे खेल रहे हैं। आओ, हमारे साथ खेलो।",--开源德州扑克，最新最火爆的德扑游戏，小伙伴们都在玩，快来加入我们一起玩吧！,
    caption ="चतुरवाले का खेल- ओपन सोर्स टेक्सास होल्डम",--聪明人的游戏-开源德州扑克,
    link = L.FEED.SHARE_LINK .."&feed=4",
    picture = appconfig.FEED_PIC_URL.."4.jpg",
    message ="",
}
L.FEED.EXCHANGE_CODE = {
    name ="मैंने {1} इनाम प्राप्त किया था। यह उपहार संख्या ओपन सोर्स टेक्सास होल्डम के प्रशंसक पेज में उपलब्ध थी। आओ, हमारे साथ खेलें।",--我用开源德州扑克粉丝页的兑换码换到了{1}的奖励，快来和我一起玩吧！,
    caption ="प्रशंसक उपहार संख्या प्राप्त कर उपहार प्राप्त हो।",--粉丝奖励兑换有礼,
    link = L.FEED.SHARE_LINK .."&feed=5",
    picture = appconfig.FEED_PIC_URL.."5.jpg",
    message ="",
}
L.FEED.COUNT = {
    name ="वाह वाह! मैंने ओपन सोर्स टेक्सास होल्डम में {1} चिप्स जीते हैं।",--太强了！我在开源德州扑克赢得了{1}的筹码，忍不住炫耀一下！,
    caption ="कितना जीत है!",--赢了好多啊,
    link = L.FEED.SHARE_LINK .."&feed=6",
    picture = appconfig.FEED_PIC_URL.."--6.jpg",
    message ="",
}
L.FEED.ACTIVE = {
    name ="वाह वाह! जल्दी से मेरे साथ ओपन सोर्स टेक्सास होल्डम खेलें। दिन-प्रतिदिन गतिविधियों का व्यवस्थित किया जाता है।",--太棒了，赶紧和我一起加入开源德州扑克吧，精彩活动天天有！,
    caption ="{1} गतिविधि",--{1}活动,
    link = L.FEED.SHARE_LINK .."&feed=7",
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message ="",
}
L.FEED.ACTIVE_DONE = {
    name ="मैंने ओपन सोर्स टेक्सास होल्डम में {1} का इनाम प्राप्त किया था। जल्दी से मेरे साथ खेलें।",--我在开源德州扑克中获得了{1}的奖励，赶快来加入一起玩吧！,
    caption ="{1} गतिविधि",--{1}活动,
    link = L.FEED.SHARE_LINK .."&feed=8",
    picture = appconfig.FEED_PIC_URL.."8.jpg",
    message ="",
}
L.FEED.ACHIEVEMENT_REWARD = {
    name ="मैंने ओपन सोर्स टेक्सास होल्डम में {1} का उपलब्धता और {2} का इनाम प्राप्त किया था। जल्दी से मेरे साथ खेलो।",--我在开源德州扑克完成了{1}的成就，获得了{2}的奖励，快来和我一起玩吧！,
    caption ="{1}",
    link = L.FEED.SHARE_LINK .."&feed=9",
    picture = appconfig.FEED_PIC_URL.."9.jpg",
    message ="",
}
L.FEED.UPGRADE_REWARD = {
    name ="देखो देखो! एक मिनट पहले मैंने ओपन सोर्स टेक्सास होल्डम में {1} स्तरों का उन्नयन किया और {2} का इनाम प्राप्त किया है।",--太棒了，我刚刚在开源德州扑克成功升到了{1}级，领取了{2}的奖励，快来膜拜吧！,
    caption ="पदोन्नति से बड़ा इनाम प्राप्त करता है।",--升级领取大礼,
    link = L.FEED.SHARE_LINK .."&feed=LV{1}",
    picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
    message ="",
}
L.FEED.MATCH_COMPLETE = {
    name ="मैं ओपन सोर्स टेक्सास होल्डम में {1} में सीनियरिटी के {2} जीत है। आओ, साथ में खेलें।",-- 我在开源德州扑克{1}中获得第{2}名，赶快来一起玩吧！,
    caption ="एक साथ खेलो",--一起来比赛！,
    link = L.FEED.SHARE_LINK .."&feed=11",
    picture = appconfig.FEED_PIC_URL.."11.jpg",
    message ="",
}
L.FEED.RANK_REWARD = {
    name ="वाह! कल मैंने ओपन सोर्स टेक्सास होल्डम में {1} चिप्स जीता था। एक साथ खेलें।",-- 太棒了!我昨天在开源德州扑克里赢得了{1}筹码，快来和我一起玩吧!,
    caption ="पैसे जीत हो गया!",--又赢钱了！,
    link = L.FEED.SHARE_LINK .."&feed=12",
    picture = appconfig.FEED_PIC_URL.."12.jpg",
    message ="",
}
L.FEED.BIG_POKER = {
    name ="सौभाग्य! मैंने ओपन सोर्स टेक्सास होल्डम में {1} प्राप्त किया है। यह चतुर व्यक्ति का खेल है, चतुरता का खेल।",--手气真好!我在开源德州扑克拿到{1}，聪明人的游戏，快来加入一起玩吧！,
    caption ="{1}",--牌型
    link = L.FEED.SHARE_LINK .."&feed=13",
    picture = appconfig.FEED_PIC_URL.."13.jpg",
    message ="",
}
L.FEED.PRIVATE_ROOM = {
    name ="मैंने ओपन सोर्स टेक्सास होल्डम के एक निजी कमरे में आप को इंतज़ार रहा है। कमरा संख्या {1}, संकेत शब्द {2}। खेलने के लिए क्लिक करें।",--我在开源德州扑克开好私人房等你来战，房间号{1}，密码{2}，点击立即加入！,
    caption ="निजी कमरे में  खेलेंगे।",--开房打牌了,
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message ="",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
    name ="मैंने ओपन सोर्स टेक्सास होल्डम के एक निजी कमरे में आप को इंतज़ार रहा है। कमरा संख्या {1}，खेलने के लिए क्लिक करें।",--我在开源德州扑克开好私人房等你来战，房间号:{1}，点击立即加入！,
    caption ="निजी कमरे में  खेलेंगे।",--开房打牌了,
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message ="",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name ="मैंने कमरे {1} में {2} के पोकर खेल रहा है।जल्दी से आऔ।",--我在{1}房间{2}打牌,速速来战！,
    caption ="आओ,पोकर खेलो।",--打牌啦,
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message ="",
}
L.FEED.INVITE_CODE = {
    name ="मैंने एक टेक्सस पोकर दिखाया। जो आज तक सब से अच्छा है। मेरे साथ खोलो। खेल डाउनलोड कर आमंत्रित संख्या{1} दर्ज करके विशेष उपहार लेंगे।",--发现一个目前最好玩的德州扑克游戏，推荐你和我一起玩，下载游戏输入我的邀请码{1}就有特别大奖领取.,
    caption ="",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message ="",
}
L.FEED.INVITE_CODE_REWARD = {
    name ="{1} को बहुत धन्यवाद देता हूं। मैंने ओपन सोर्स टेक्सास होल्डम में {2} चिप्स के रूप में एक आमंत्रित इनाम प्राप्त किया था। एक साथ खेलो।",--太感谢好友{1}！我在开源德州获得了{2}筹码的邀请礼包，快来加入我们一起玩吧,
    caption ="ओपन सोर्स टेक्सास होल्डम - मुक्त आमंत्रित इनाम।",--开源德州扑克-免费的邀请大礼包,
    link = L.FEED.SHARE_LINK .."&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message ="",
}

-- message
L.MESSAGE.TITLE ="संदेश"--消息
L.MESSAGE.TAB_TEXT = {
     "दोस्त के संदेश",--好友消息, 
     "सिस्टम के संदेश"--系统消息
}
L.MESSAGE.EMPTY_PROMPT ="अब कोई संदेश नहीं है।"--您现在没有消息记录
L.MESSAGE.SEND_CHIP ="वापस भेजेंगे"--回赠
L.MESSAGE.ONE_KEY_GET ="सब लेंगे"--一键领取
L.MESSAGE.ONE_KEY_GET_AND_SEND ="सब लेंगे और वापस भेजेंगे।"--一键领取并回赠
L.MESSAGE.GET_REWARD_TIPS ="आप {1} प्राप्त पर बधाई देता है। दोस्त को {2} सफलता से भेजा।"--恭喜您获得了{1},成功给好友赠送了{2}

--奖励兑换码
L.ECODE.TITLE = {
     "मेरा आमंत्रित संख्या",--我的邀请码,
     "इनाम विनिमय"--奖励兑换
}
L.ECODE.EDITDEFAULT ="6 उपहासर संख्या या 8 आमंत्रित संख्या को दर्ज कीजिये।"--请输入6-8位数字奖励兑换码"
L.ECODE.FANS_DESC ="हर दिन मुफ्त चिप्स प्राप्त करने के लिए हमारे प्रशंसक पृष्ठ का पालन करेंगे!"--关注粉丝页可免费领取奖励兑换码,我们还会不定期在官方粉丝页推出各种精彩活动,谢谢关注。
L.ECODE.FANS ="प्रशंसक पृष्ठ का पता"--粉丝页地址
L.ECODE.EXCHANGE ="इनाम विनिमय"--兑  奖
L.ECODE.ERROR_FAILED ="उपहार संख्या कलत है।कृपया दूबारा दर्ज कीजिये।"--兑换码输入错误，请重新输入！
L.ECODE.ERROR_INVALID="उपहार ले नहीं पाया। आपका मुक्ति कोड समाप्त हो गया है।"--兑奖失败，您的兑换码已经失效。
L.ECODE.ERROR_USED ="उपहार ले नहीं पाया। प्रति संख्या सिर्फ़ एक बार उपयोग कर सकता है।"--兑奖失败，每个兑换码只能兑换一次。
L.ECODE.ERROR_END="उपहार ले नहीं पाया।इस बार के उपहार सब दिये।अगेले बार का इंतज़ार करते हैं।"--领取失败，本次奖励已经全部领光了，关注我们下次早点来哦
L.ECODE.FAILED_TIPS ="उपहार ले नहीं पाया।कृपया पुन: प्रयास कीजिये।"--兑奖失败，请重试！
L.ECODE.NO_INPUT_SELF_CODE ="आप अपने आमंत्रित संख्या उपयोग कर नहीं पाता है।कृपयापुन: प्रयास कीजिये।"--您不能输入自己的邀请码,请确认后重新输入
L.ECODE.MAX_REWARD_TIPS ="ज़यादातर प्राप्त"--最大获取
L.ECODE.INVITE_REWARD_TIPS = [[
1. आमंत्रित से आनेवाला आप के आमंत्रित को सिर्फ़ पहले 3 दिन में उपयोग कर सकता है।
2.आप {1} चिप्स प्राप्त करेंगे, दोस्त {2} चिप्स प्राप्त करेंगे।
3.दोस्त और नया खिलाड़ी को आमंत्रित भेजेंगे,तो आप {3} चिप्स प्राप्त होगे।
]]
L.ECODE.INVITE_REWARD_RECORD ="आपने {1} दोस्तों को आमंत्रित भेजा, {2} चिप्स का इनाम प्राप्त है।"--您已邀请了{1}位好友,获得了{2}筹码的邀请奖励
L.ECODE.MY_CODE ="मेरी आमंत्रित संख्या"--我的邀请码
L.ECODE.COPY_CODE ="क्लिक से  नक़ल करेंगे"--点击复制
L.ECODE.INVITE_REWARD_TIPS_1 ="वाह, प्राप्त सफलता है।"--太棒了,领取成功
L.ECODE.INVITE_REWARD_TIPS_2 ="आप {1} चिप्स का आमंत्रित इनाम प्राप्त है।\nआपका दोस्त {2} {3} का आमंत्रित इनाम भी प्राप्त है।"--您获得了{1}筹码的好友邀请奖励\n您的好友{2},也获得了{3}的邀请奖励
L.ECODE.INVITE_BTN_NAME ="मैं भी आमंत्रित भेजना चाहिय।"--我也要去邀请
L.ECODE.INVITE_TIPS ="आप क्लिक से आमंत्रित संख्या भेजेंगे।"--您可以点击按钮通过以下方式发送邀请码
L.ECODE.INVITE_TITLES = {
"मोचन कोड प्राप्त करने के लिए प्रशंसक पृष्ठ का पालन करेंगे।",--关注粉丝页获取兑换码,
"आमंत्रित इनाम प्राप्त के लिये मेरा आमंत्रित संख्या भेजेंगे।"--发送我的邀请码获取邀请奖励
}

--大转盘
L.LUCKTURN.RULE_TEXT =[[
1.हर {1} घटे फिर से एक बार मुफ्त चालू करा सकते हैं
2.आप भी एक हीरा खर्च करके एक बार चालू करा सकते हैं
3.100%जीतना, हर दिन बहुत मुफ्त चिप्स आपको ले ने का इतज़ार करेंगें।
]]
L.LUCKTURN.COST_DIAMOND ="एक हीरा खर्च किया"--花费1个颗钻石
L.LUCKTURN.BUY_DIAMOND ="हीरे खरीदेंगे"--购买钻石
L.LUCKTURN.COUNTDOWN_TIPS ="आज आप के मुफ्त बार का उपयोग किया गया था\n आप इतज़ार कर सकते हैं{1}फिर से आएंगे\n आप भी एक हीरा खर्च करके एक बार चालू करा सकते हैं।"--您今天的免费次数已用完\n您可以等待{1}再来\n您也可以花费一颗钻石转一次
L.LUCKTURN.LOTTERY_FAILED ="लाटरी पर विफल है, कृपया नेटवर्क कनेक्शन डिस्कनेक्ट करने के बाद फिर से जांचेंगे।"--抽奖失败，请检查网络连接断开后重试
L.LUCKTURN.CHIP_REWARD_TIPS ="{1}प्राप्त ：{2}चिप्स"--{1}中了:筹码 {2}
L.LUCKTURN.PROPS_REWARD_TIPS ="{1}प्राप्त ：{2}वस्तु"--{1}中了:道具 {2}"--
L.LUCKTURN.VIP_REWARD = "{1}day{2}VIP"--"{1}天{2}VIP特权"

--老虎机
L.SLOT.NOT_ENOUGH_MONEY ="स्लांट मशीन खरीदने पर विफल है, आप के पास इतने चिप्स नहीं हैं।"--老虎机购买失败,你的筹码不足
L.SLOT.NOT_ENOUGH_MIN_MONEY ="आप का कुल चिप्स 5000 से कम है, अभी स्लांट मशीन का कॉल कर नहीं पाते, कृपया खरीदकर पुन: प्रयास कीजिये।"--您的总筹码数不足5000，暂时无法下注老虎机，请充值后重试。
L.SLOT.BUY_FAILED ="स्लांट मशीन खरीदने पर विफल है, कृपया और एक बार कोशिश करेंगे।"--老虎机购买失败，请重试
L.SLOT.PLAY_WIN ="आप ने {1} चिप्स जीता।"--你赢得了{1}筹码
L.SLOT.TOP_PRIZE ="खिलड़ी {1} स्लांट मशीन खेलने में बड़ा लाडरी डाल गये, चिप्स {2} प्राप्त करेंगे।"--玩家 {1} 玩老虎机抽中大奖，获得筹码{2}
L.SLOT.FLASH_TIP ="शीर्ष पुरस्कार：{1}"--头奖：{1}
L.SLOT.FLASH_WIN ="आप जीते：{1}"--你赢了：{1}
L.SLOT.AUTO ="स्वचालित"--自动
L.SLOT.HELP_TIPS ="बोनस=चिप्स कॉल*वापसी दर\n जितना कॉल करते हैं उतना ही इनाम है। सबसे उच्चा{1}।"--奖金=下注筹码*回报率\n下注越多,奖励越高.最高{1}

--GIFT
L.GIFT.TITLE ="उपहार"--礼物
L.GIFT.SET_SELF_BUTTON_LABEL = "इसे मेरा उपहार बनाएगा"
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL ="x{1}मेंज लिये खरीदेंगे"--买给牌桌x{1}
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL ="आप के चयन किया उपहार"--你当前选择的礼物
L.GIFT.PRESENT_GIFT_BUTTON_LABEL ="भेजेंगे"--赠送
L.GIFT.DATA_LABEL ="दिन"--天
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP ="कृपया उपहार चयन कीजिये"--请选择礼物
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP ="उपहार खरीदने में सफलता है।"--购买礼物成功
L.GIFT.BUY_GIFT_FAIL_TOP_TIP ="उपहार खरीदने पर विफल है।"--购买礼物失败
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP ="उपहार सिट करने में सफलता है।"--设置礼物成功
L.GIFT.SET_GIFT_FAIL_TOP_TIP ="उपहारसिट करने पर विफल है।"--设置礼物失败
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP ="उपहार भेजने में सफलता है।"--赠送礼物成功
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP ="उपहार भेजने पर विफल है।"--赠送礼物失败
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP ="मेज पर उपहार भेजने में सफलता है।"--赠送牌桌礼物成功
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP ="मेज पर उपहार भेजने पर विफल है।"--赠送牌桌礼物失败
L.GIFT.NO_GIFT_TIP ="अब कोई उपहार नहीं है।"--暂时没有礼物
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL ="क्लिक किया तो मेज पर उपहार दिखाएंगे।"--点击选中既可在牌桌上展示才礼物
L.GIFT.BUY_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to buy gift."
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift."
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "Not enough outside chips.Fail to send gift to all players at the table."
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
"बूटिक",--精品, 
"खाना",--食物,
"स्पोर्ट्स कार",--跑车,
"फूल"--鲜花
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
"अपने खेरीदना",--自己购买, 
"दोस्त भेजना",--牌友赠送,
"विशेष से भेजना"--特别赠送
}

L.GIFT.MAIN_TAB_TEXT = {
"बाज़ार के उपहार",--商城礼物, 
"वीआईपी उपहार",
"मेरे उपहार"--我的礼物
}

-- 破产
L.CRASH.PROMPT_LABEL ="आपको {1} चिप्स का दिवालियापन लाभ मिलता है और समय-सीमित दिवालियापन बोनस रिचार्ज भी मिलता है। आप मुफ्त चिप्स पाने के लिए अपने दोस्तों को आमंत्रित भेज सकते हैं।"--您获得了{1}筹码的破产救济金，同时获得限时破产优惠充值一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.THIRD_TIME_LABEL ="आपको अंतिम {1} चिप्स का दिवालियापन लाभ मिलता है और समय-सीमित आज का बोनस रिचार्ज भी मिलता है। आप मुफ्त चिप्स पाने के लिए अपने दोस्तों को आमंत्रित भेज सकते हैं।"--您获得最后一次{1}筹码的破产救济金，同时获得当日限时充值优惠一次，您也可以立即邀请好友获取免费筹码。
L.CRASH.OTHER_TIME_LABEL ="आप ने सब दिवालियापन लाभ मिल हो गया। जीतना या हारना सिर्फ एक पल का मामला है, सीमित समय के पूर्व अनुग्रह अवसर दुर्लभ हैं, तुरंत अपनी ताकत बहाल करने के लिए रीचार्ज करते हैं!"--您已经领完所有破产救济金了，输赢只是转瞬的事，限时特惠机会难得，立即充值重振雄风！
L.CRASH.TITLE ="आप दिवालियापन है।"--你破产了！
L.CRASH.REWARD_TIPS ="दिवालियापन तो ठीक है। आप और कुछ फिटकरी पैसे ले सकते है।"--破产没有关系，还有救济金可以领取
L.CRASH.CHIPS ="{1} चिप्स"--{1}筹码
L.CRASH.GET ="लेंगे"--领取
L.CRASH.GET_REWARD ="{1} चिप्स प्राप्त है।"--获得{1}筹码
L.CRASH.GET_REWARD_FAIL ="चिप्स प्राप्त पर विफल है।"--领取筹码失败
L.CRASH.RE_SIT_DOWN ="दूबारा पैठेंगे।"--重新坐下
L.CRASH.PROMPT_LABEL_1 ="निराश मत हो, सिस्टम से {1}  चिप्स दिवालिएपन आप को तैयार हो रहा है।"--不要灰心,系统为您准备了{1}筹码的破产救济
L.CRASH.PROMPT_LABEL_2 ="इस समय में आप रीचार्ज मिलता है।"--同时您还获得当日充值优惠一次立即充值重振雄风
L.CRASH.PROMPT_LABEL_3 ="आप दोस्तों को आमंत्रित भेज भी सकते हैं या कल वापस आकर बहुत सारे मुफ्त चिप्स प्राप्त करेंगे।"--您也可以邀请好友或者明天再来领取大量免费筹码
L.CRASH.PROMPT_LABEL_4 ="हम आपको सीमित समय(इस दिन में) उपहार पैकेज दे देंगे।"--我们赠送您当日限时充值优惠大礼包一次，机不可失
L.CRASH.PROMPT_LABEL_5 ="आप सभी दिवालियापन पैकेज प्राप्त है।"--您已经领完了所有的破产礼包 输赢乃兵家常事,不要灰心

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC ="SMS भेजने पर सफलता है, रीचार्ज कर रहा है,कृपया इंतज़ार कीजिये।"--短信已发送成功,正在充值 请稍等.
L.E2P_TIPS.NOT_SUPPORT ="आप का मोबाइल में easy2pay रीचार्ज कर नहीं पाता है।,कृपरा अन्या तरीकों से रीचार्ज कीजिये।"--你的手机暂时无法完成easy2pay充值,请选择其他渠道充值
L.E2P_TIPS.NOT_OPERATORCODE ="Easy2pay आपके मोबाइल कैरी का समर्थन नहीं करता है। कृपया अन्य तरीकों से रीचार्ज कीजिये।"-- easy2pay暂时不支持你的手机运营商,请选择其他渠道充值
L.E2P_TIPS.SMS_SENT_FAIL ="SMS भेजने पर सफलता है,कृपया जांच कीजिये कि आप मोबाइल में रीचार्ज करने के पैसे काफी है या नहीं।"--短信发送失败,请检查你的手机余额是否足额扣取
L.E2P_TIPS.SMS_TEXT_EMPTY ="SMS खाली है। कृपया अन्य तरीकों से रीचार्ज कीजिये और हमें बताइये।"--短信内容为空,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_ADDRESS_EMPTY ="भेजने का लक्ष्य नहीं है।कृपया अन्य तरीकों से रीचार्ज कीजिये और हमें बताइये।"--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_NOSIM ="easy2pay के माध्यम से रीचार्ज कर नहीं पाता है। क्योंकि SIM नहीं है।।कृपया अन्य तरीकों से रीचार्ज कीजिये।"--没有SIM卡,无法使用easy2pay渠道充值,请选择其他渠道充值
L.E2P_TIPS.SMS_NO_PRICEPOINT ="भेजने का लक्ष्य नहीं है।कृपया अन्य तरीकों से खरीदेंगे रीचार्ज कीजिये और हमें बताइये।"--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.PURCHASE_TIPS ="आप {1} खेरीदेंगे, कुल {2}  रुपए（7% वैट नहीं होते हैं）, आपके क्रेडिट से कटौती की जाएगी"--您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的话费里扣除
L.E2P_TIPS.BANK_PURCHASE_TIPS ="आप {1} खेरीदेंगे, कुल {2}  रुपए（7% वैट नहीं होते हैं）, आपके बैंक कार्ड से कटौती की जाएगी"--您将要购买{1}，共花费{2}铢（不含7%增值税），将会从您的银行卡里扣除

-- 比赛场
L.MATCH.MONEY ="चिप्स"--筹码
L.MATCH.JOINMATCHTIPS ="आप शामिल की प्रतियोगिता तैयर हो रहा है। क्या आप कमरे में प्रवेश करेंगे?"--您报名参赛的比赛已经开始准备，是否现在进入房间进行比赛
L.MATCH.JOIN_MATCH_FAIL ="प्रतियोगिता में शामिल पर विफल है। कृपया अन्य प्रतियोगिता में शामिल कीजिये।"--加入比赛失败，请参加其他比赛吧！
L.MATCH.MATCH_END_TIPS ="यह प्रतियोगिता समाप्त हो गया। कृपया अन्य प्रतियोगिता में शामिल कीजिये।"--当前比赛已经结束，请参加其他比赛吧！
L.MATCH.MATCHTIPSCANCEL ="संकेत नहीं देंगे।"--不再提示
L.MATCH.CHANGING_ROOM_MSG ="अन्या मेज समाप्त होने लिये इंतज़ार रहा है।"--正在等待其他桌子结束
L.MATCH.MATCH_NAME ="प्रतियोगिता का नाम"--比赛名称
L.MATCH.MATCH_REWARD ="इनाम"--奖励内容
L.MATCH.MATCH_PLAYER ="खिलाड़ियां संख्या"--参赛人数
L.MATCH.MATCH_COST ="पंजीकरण शुल्क + सेवा शुल्क"--报名费+服务费
L.MATCH.REGISTER ="पंजीकरण"--报名
L.MATCH.REGISTERING ="रहा है\nपंजीकरण"--正在\n报名
L.MATCH.REGISTERING_2 ="पंजीकरण रहा है।"--正在报名
L.MATCH.UNREGISTER ="रद्द करेंगे\nपंजीकरण"--取消\n报名
L.MATCH.UNREGISTER_2 ="पंजीकरण रद्द करेंगे।"--取消报名
L.MATCH.RANKING ="आप की ज्येष्ठता"--您的排名
L.MATCH.REGISTER_COST ="पंजीकरण शुल्क"--参数费:
L.MATCH.SERVER_COST ="सेवा शुल्क"--服务费:
L.MATCH.TOTAL_MONEY ="आप के संपत्ति"--您的总资产:
L.MATCH.MATCH_INFO ="खेल की हालत"--本场赛况
L.MATCH.START_CHIPS ="आरंभिक चिप्स"--初始筹码:
L.MATCH.START_BLIND ="आरंभिक बहाना:{1}/{2}"--初始盲注:{1}/{2}
L.MATCH.MATCH_TIME ="प्रतियोगिता करने समय:{1}"--参赛时间:{1}
L.MATCH.RANKING_TITLE ="ज्येष्ठता"--名次
L.MATCH.REWARD_TITLE ="इनाम"--奖励
L.MATCH.LEVEL_TITLE ="स्तर"--级别
L.MATCH.BLIND_TITLE ="बहाना"--盲注
L.MATCH.PRE_BLIND_TITLE ="अग्रिम बहाना"--前注
L.MATCH.ADD_BLIND_TITLE ="बहाना बढ़ाने समय"--涨盲时间
L.MATCH.RANKING_INFO ="आप की ज्येष्ठता:{1}"--当前排名第{1}名
L.MATCH.SNG_HELP_TITLE ="SNG प्रतियोगिता नियम"-- SNG比赛规则
L.MATCH.MTT_HELP_TITLE ="MTT प्रतियोगिता नियम"-- MTT比赛规则
L.MATCH.SNG_RANKING_INFO ="सामान्य चिप्स: {1}"--均筹: {1}
L.MATCH.MTT_RANKING_INFO ="{1}/{2} सामान्य चिप्स: {3}"--{1}/{2} 均筹: {3}
L.MATCH.ADD_BLIND_TIME ="बहाना बढ़ाने समय: {1}"--涨盲时间: {1}
L.MATCH.WAIT_MATCH ="प्रतियोगिता की प्रतीक्षा कर रहा है"--等待开赛
L.MATCH.ADD_BLIND_TIPS_1 ="अगरी बार में बहाना बढ़ाएगा।"--将在下一局涨盲
L.MATCH.ADD_BLIND_TIPS_2 ="अगरी बार बहाना {1}/{2} तक बढ़ाएगा।"--下一局将升盲至{1}/{2}
L.MATCH.BACK_HALL ="लॉबी"--返回大厅
L.MATCH.PLAY_AGAIN ="और एक बार"--再来一局
L.MATCH.LEFT_LOOK ="खेल देखेंगे"--留下旁观
L.MATCH.CLOSE ="बंद करेंगे"-- 关闭
L.MATCH.REWARD_TIPS ="आप {1} का इनाम प्राप्त है।"--您获得了{1}的奖励\n{2}
L.MATCH.REWARD_PLAYER ="इनाम प्राप्त की लोग संख्या"--奖励人数
L.MATCH.MATCH_CUR_TIME ="प्रतियोगिता की समय"--比赛用时
L.MATCH.CUR_LEVEL_TITLE ="स्तर:{1}/{2}"--当前级别:{1}/{2}
L.MATCH.NEXT_LEVEL_TITLE ="अगरा स्तर"--下一级别
L.MATCH.AVERAGE_CHIPS_TITLE ="सामान्य चिप्स"--平均筹码
L.MATCH.FORMAT_BLIND ="{1}/{2}"
L.MATCH.EXPECT_TIPS ="आ रहा है।"--敬请期待
L.MATCH.NOT_ENOUGH_MONEY ="आपके पास पर्याप्त चिप्स नहीं हैं। कृपया स्टोर में चिप खरीदें और पुनः प्रयास करेंगे।"--您的筹码不足报名，请去商城补充筹码后重试
L.MATCH.PLAYER_NUM_TIPS ="प्रतियोगिता करने लिये {1} लोग का इंतज़ार रहा है।"--等待开赛中，还差{1}人
L.MATCH.PLAYER_NUM_TIPS_1 = "प्रतियोगिता करने लिये "--等待开赛中，还差 
L.MATCH.PLAYER_NUM_TIPS_2 = " लोग का इंतज़ार रहा है।"-- 人
L.MATCH.MAINTAIN ="प्रतियोगिता का रखरखाव चल रहा है"--当前比赛正在维护
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
"वाह! मित्रों के साथ शयर करेंगे!",--你太棒了！立即分享炫耀下吧!,
"अच्छा काम! अपने दोस्तों को अब जाने के लिए इसे साझा करेंगे!",--没想到你这么强！呼朋唤友告诉小伙伴们吧！,
"अच्छा हाथ! और एक बार खेलेंगे!"--太牛了，再来一局吧！,
}
L.MATCH.NO_REWARD_TEXT = {
"किसी भी विफलता पर दिल खो मत करो, लेकिन फिर से कोशिश करो!",--再接再厉，继续加油！,
"असफलता सफलता की मां है। कृपया प्रयास करें!",--失败是成功之母，继续努力！,
"खुश हो जाओ! आपको अगली बार और धैर्य की आवश्यकता है!",--就差一点点，下次多点耐心！,
}
L.MATCH.SNG_RULE = {
    {
        title ="SNG क्या है?",--什么是SNG-坐满即玩?,
        content ="SNG（sit and go） का मतलब है कि लोग आते हि खेलेंगे। SNG में प्रत्येक खिलाड़ी को गिनती के लिए चिप्स मिल जाएगी (यह चिप सोने के मुद्रा नहीं है), इस चिप्स  केवल इस गेम की गिनती के लिए उपयोग किया जाता है।"-- SNG全称Sit and Go，中文指坐满即玩，坐满即玩是德州扑克的一种单桌比赛玩法。在SNG中，每场玩家会获得用来计数的筹码，这个筹码与金币无关，只用于本场计数。
    },
    {
        title ="SNG प्रतियोगिता नियम",-- SNG比赛规则:,
        content = [[
1. प्रतिभागियों की संख्या 9 या 6 है।
2. प्रत्येक खिलाड़ी को गिनती के लिए चिप्स मिल जाएगी (यह चिप सोने के मुद्रा नहीं है), इस चिप्स  केवल इस गेम की गिनती के लिए उपयोग किया जाता है।
3. जब आप पूर्ण हो जाएं तब गेम के मध्य में चिप्स की संख्या में वृद्धि नहीं की जा सकती है, और फिर चिप्स खो जाने पर गेम से बाहर निकलें।
4. खिलाड़ी के खेल के बाहर निकलने के दौर से ज्येष्ठता तय करती है, जो खिलाड़ी पहले भागता है वह आखिरी है, और इसी तरह।
5. जब अंतिम _ खिलाड़ी के हाथ में छोड़ दिया जाता है, तो खेल खत्म हो गया है और अंतिम खिलाड़ी चैंपियन है
6. प्रतियोगिता की तीव्रता को बढ़ाने के लिए, बहाना समय-समय पर पूर्ण-प्ले गेम के दौरान बढ़ेंगे
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title ="MTT क्या है?",--什么是MTT-多桌锦标赛?,
        content ="MTT (Multi-Table Tournament) का मतलब है कि कई मेंज पर खिलाड़ी चिप्स की एक ही राशि के साथ खेल शुरू करते हैं। MTT में, तालिकाओं को विलय कर दिया जाएगा क्योंकि खिलाड़ियों को समाप्त किया जाना जारी है। अंत में, टूर्नामेंट फाइनल के लिए एक मेज पर कम हो जाएगा।"-- MTT是Multi-Table Tournament的缩写，中文全称为多桌锦标赛，指的是在多张桌上参赛玩家以同样的筹码量开始比赛。在多桌锦标赛中，桌子会随着选手的不断淘汰进行合并。最终，锦标赛会减少到一张桌子而进行决赛。
    },
    {
        title ="MTT प्रतियोगिता नियम",-- MTT比赛规则:,
        content = [[
1. एक निश्चित समय पर खेल शुरू करता है, जब प्रतिभागियों की संख्या शुरू की न्यूनतम संख्या से कम है, खेल को रद्द कर दिया जाएगा।
2. प्रत्येक गेम प्लेयर को केवल गेम की गिनती में उपयोग के लिए चिप्स की संख्या प्राप्त होगी।
3. पूर्व नोट: गेम के दौरान, प्रत्येक खिलाड़ी को प्रत्येक गेम की शुरुआत से पहले कई चिप्स पर शर्त लगाने के लिए मजबूर किया जाएगा।
4. Rebuy चिप्स: एक निश्चित अंधा स्तर कॉन्फ़िगर करने के बाद Rebuy टूर्नामेंट शुरू किया, खिलाड़ी रों चिप शुरू कर ढेर के हाथ, खिलाड़ियों बटन पर क्लिक कर सकते हैं जब से पहले Rebuy चिप्स चिप्स फिर से खरीदने के लिए प्रारंभिक पंजीकरण शुल्क लेता है मूल्य, अलग-अलग खेलों में रिवाइज़ की संख्या वैरिएबल हो सकती है। जब खिलाड़ी के पास हाथ में 0 होता है और खेल से समाप्त होने वाला है, तब इसे रीब्यूइंग द्वारा फिर से शुरू किया जा सकता है।
5. चिप्स खरीदना: एक अंधे स्तर के विन्यास खेल अवधि खरीद सकते हैं, खिलाड़ियों को कुछ चिप्स मूल्य फिर से खरीदने के लिए चिप्स लागत प्रवेश शुल्क खरीद करने के लिए बटन क्लिक कर सकते हैं, विभिन्न खेलों की संख्या अनिश्चित खरीद सकते हैं , खिलाड़ी के हाथ में 0 है और खेल से बाहर खटखटाया जा रहा है, तो यह भी एक अतिरिक्त खरीद के माध्यम से पुनर्जीवित किया जा सकता है।
6. क्रम को के अनुसार दौड़ से बाहर खिलाड़ियों ले, खिलाड़ियों पिछले एक है, और की पहली चिप हारे इतने पर, वहाँ दो या अधिक प्रतियोगियों, ताश के पत्तों की एक ही खेल में बाहर हो गया यह ब्रांड शक्ति के अनुसार पालन किया जाएगा रहे हैं, शुरूआत में स्थिति निर्धारण की चिप्स, शीर्ष खिलाड़ियों ने पहले स्थान दिया, और अधिक चिप्स को शुरुआत में स्थान दिया गया।
7. जब खेल में शेष एकमात्र खिलाड़ी खेल का अंत है, तो अंतिम खिलाड़ी चैंपियन है।
8. प्रतियोगिता की तीव्रता बढ़ाने के लिए, अंधा कर रही हैं टूर्नामेंट के दौरान धीरे धीरे वृद्धि होगी।
]]
    }
}
L.MATCH.TAB_TEXT= {
"रेखांकित",--概述,
"ज्येष्ठता",--排名,
"बहाना",--盲注,
"इनाम"--奖励,
}
L.MATCH.ROOM_TAB_TEXT_1= {
"रेखांकित",--概述,
"हालत",--赛况,
"ज्येष्ठता",--排名,
"बहाना",--盲注,
"इनाम"--奖励,
}
L.MATCH.ROOM_TAB_TEXT_2= {
"हालत",--赛况,
"ज्येष्ठता",--排名,
"बहाना",--盲注,
"इनाम"--奖励,
}

-- 输赢统计
L.WINORLOSE.TITLE ="वाह"--太棒了
L.WINORLOSE.YING ="जीत है"--你赢了
L.WINORLOSE.CHOUMA ="{1} चिप्स"--{1}筹码
L.WINORLOSE.INFO_1 ="दौर:"--局数:{1}
L.WINORLOSE.INFO_2 ="एक दौर में ज्यादातर जीत:{1}"--单局最大赢得:{1}
L.WINORLOSE.RATE5 ="इस खेल की तरह? कृपया हमें प्रोत्साहित करने के लिए 5 सितारा उच्च प्रशंसा दें।"--喜欢我们的游戏给5星好评，您的鼓励是我们持续优化的最大动力
L.WINORLOSE.NOW ="तुरंत सहायता करेंगे।"--立即支持
L.WINORLOSE.LATER ="अगली बार"--以后再说
L.WINORLOSE.SHARE ="शयर"--分享

-- 私人房
L.PRIVTE.ROOM_NAME ="निजी कमरा"--私人房
L.PRIVTE.FINDTITLE ="कमरा ढूंढेंगे"--查找房间
L.PRIVTE.CREATTITLE ="कमरा बनाएंगे।"--创建房间
L.PRIVTE.INPUTROOMIDTIPS ="कृपया कमरा संख्या दर्ज कीजिये"--请输入房间号
L.PRIVTE.ENTERROOM ="अभी अंदर जाएंगे।"--立即进入
L.PRIVTE.TYPETIPS ="सामान्य{1}s. जल्दी{2} s"--普通场{1}秒快速场{2}秒
L.PRIVTE.CREATEROOM ="अभी शुरू करेंगे।"--立即开始
L.PRIVTE.CREATFREE ="मुक्त सीमित करेंगे।"--限免开局
L.PRIVTE.INPUTPWDTIPS ="कृपया कमरे की संकेत शब्द दर्ज कीजिये। अगर खालीहै तो संक्त शब्द नहीं है।"--请输入房间密码，留空即无密码
L.PRIVTE.TIMEHOUR ="{1} घंटे"--{1}小时
L.PRIVTE.PWDPOPTIPS ="कृपया प्रभआव संकेत शब्द दर्ज कीजिये।"--请输入有效密码
L.PRIVTE.PWDPOPTITLE ="कृपया संकेत शब्द दर्ज कीजिये।"--请输入密码
L.PRIVTE.PWDPOPINPUT ="कृपया संकेत शब्द दर्ज कीजिये।"--请输入密码
L.PRIVTE.NOTIMETIPS ="कमरे में वर्तमान समय {1} s है। यह विघटित होने वाला है। कृपया पुन: बनाइये!"--当前房间所剩时间{1}秒，即将解散，请重新创建！
L.PRIVTE.TIMEEND ="वर्तमान कमरे का समय समाप्त हो गया है। कृपया लॉबी करके फिर से बनाइये!"--当前房间时间已用完解散，请返回大厅重新创建！
L.PRIVTE.ENTERBYID ="अंदर जाने लिये कमरा संख्या दर्ज कीजिये।"--输入房间号进入
L.PRIVTE.OWNER ="मालिक"--房主
L.PRIVTE.ROOMID ="कमरा संख्या:{1}"--房间号:{1}
L.PRIVTE.LEFTDAY ="{1} दिन"--{1}天
L.PRIVTE.LEFTHOUR ="{1} घंटे"--{1}小时
L.PRIVTE.LEFTMIN ="{1}मिनट"--{1}分钟
L.PRIVTE.ENTERLOOK ="देखेंगे"--围观
L.PRIVTE.ENTERPLAY ="पैठेंगे"--坐下
L.PRIVTE.ENTEREND ="समाप्त हो गया"--已结束
L.PRIVTE.ENTERENDTIPS ="वर्तमान कक्ष भंग कर दिया गया है। कृपया अन्य कमरे में अंदर जाइये!"--当前房间已解散，请进入其他房间！
L.PRIVTE.ENTERCHECK ="क्या आप इस कमरे में अंदर जाइये?"--您要加入此房间么?
L.PRIVTE.CHECKCREATE ="कोई कमरा नहीं है, नया कमरा बनाएंगे।"--暂无房间，创建新房间
L.PRIVTE.ROOMMAXTIPS ="आपके द्वारा बनाया गया निजी कमरा सीमा तक पहुंच गया है!"--您创建的私人房已经达到上限！

--活动
L.ACT.CHRISTMAS_HITRATE ="शुद्ध दर  ज़्यादातर लगातार बार"--准确率{1}  最多连击{2}
L.ACT.CHRISTMAS_HITWIN ="गति बहुत तेज़ है। आपने इस गतिविधि में {1} लोगों को हराया।"--手速超快, 您在本活动中击败{1}的人
L.ACT.CHRISTMAS_FEED = {
    name ="मैंने तेज़ गति से {1} चिप्स प्राप्त था और {2} लोगों को हराया।",--我以超快手速获得了{1}筹码，击败了{2}的人，敢来和我拼手速吗？,
    caption ="उपहार लेते हि चिप्स मिलेंगे।",--点礼物得筹码100%中奖,
    link = L.FEED.SHARE_LINK .."&feed=14",
    picture = appconfig.FEED_PIC_URL.."--14.jpg",
    message ="",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 ="मेरी क्रिसमस, फोन थोड़ा उपहार मिलेंगे।"--圣诞节快乐，摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 ="नया साल शुभ काम नाएं, फोन थोड़ा उपहार मिलेंगे।"--新年快乐，摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 ="उपहार आ रहा है, कया आप तैयार हो गया？"--礼物即将降落，准备好点击了吗？
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 ="कल आएंगे।"--明天再来吧
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 ="वसंत महोत्सव शुभ काम नाएं, फोन थोड़ा उपहार मिलेंगे।"--春节快乐，摇晃手机点礼物

--红黑大战
L.REDBLACK.BET_DOUBLE ="गुणा"--加倍
L.REDBLACK.BET_LAST ="पीछली बार जैसे"--重复上局
L.REDBLACK.SELECTED_BET_TIPS ="कृपया भाग्यशाली क्षेत्र का चयन करेंगे।"--请选择幸运区域
L.REDBLACK.SELECTED_BET_END_TIPS ="चयन हो गया।"--选择完毕
L.REDBLACK.START_GAME_TIPS ="खेल अभी शुरू करेंगे।"--游戏即将开始({1})
L.REDBLACK.BET_FAILD ="आपकी गेम की मुद्रा अपर्याप्त है और शर्त विफल हो गई है।"--您的游戏币不足,下注失败
L.REDBLACK.BET_FAILD_2 ="आपकी गेम की मुद्रा वर्तमान चयनित शर्त सीमा {1} से कम है और स्वचालित रूप से {2} पर स्विच कर दी गई है।"--您的游戏币不足当前所选的下注额度{1}，已经自动切换到{2}
L.REDBLACK.BET_FAILD_TIMES_OUT ="सट्टेबाजी का समय समाप्त हो गया है और शर्त विफल हो गई है।"--下注时间已到,下注失败
L.REDBLACK.BET_LIMIT_TIPS ="शर्त विफल हो गई है और प्राधिकरण {1} से अधिक शर्त नहीं कर पाते।"--下注失败，当局下注不能超过{1}
L.REDBLACK.ALL_PLAYER ="कमरे में {1} लोग"--当前房间共有 {1} 人
L.REDBLACK.RECENT_TREND ="आजकल"--近期走势:
L.REDBLACK.TODAY_COUNT ="आज"--今日统计:
L.REDBLACK.WIN_LOSE ="जीत हार"--胜 负
L.REDBLACK.HAND_CARD ="हाथ कार्ड"--手 牌
L.REDBLACK.WIN_CARD_TYPE ="जीत कार्ड"--获胜牌型
L.REDBLACK.COUNT_TIPS_1 ="सोना जीत"--金象胜利:{1}
L.REDBLACK.COUNT_TIPS_2 ="जांदी जीत"--银象胜利:{1}
L.REDBLACK.COUNT_TIPS_3 ="चाहना"--平局:{1}
L.REDBLACK.COUNT_TIPS_4 ="एक प्रकार का जोड़े"--同花连牌:{1}
L.REDBLACK.COUNT_TIPS_5 ="AA"--对A:{1}
L.REDBLACK.COUNT_TIPS_6 ="फूल हाउस"--葫芦:{1}
L.REDBLACK.COUNT_TIPS_7 ="स्त्रै घ्तर/रोयाल/फ्लूश"--金刚/皇家/同花顺:{1}
L.REDBLACK.SUB_TAB_TEXT = {
"प्रवृत्ति",--胜负走势,
"नियम"--游戏规则
}
L.REDBLACK.RULE = [[
आप का प्यारा खइलाड़ी को जुनकर ज़यादा इनाम जीत करेंगे।
 

बुनियादी नियम:
1. प्रत्येक गेम सोना और जांदी हाथी को प्रत्येक हाथ देगा, फिर पांच सामुदायिक कार्ड और उनमें से एक होगा।

2. खिलाड़ी सार्वजनिक जानकारी के आधार पर किसी भी शिविर और क्षेत्र का समर्थन कर सकते हैं।

3. सामुदायिक कार्ड और हाथ कार्ड दिखाए जाएंगे। परिणाम के अनुसार, खिलाड़ियों को क्षेत्र के गुणकों में पुरस्कृत किया जाएगा।


दैनिक निवेश के लिए ऊपरी सीमा है। एक अच्छी तरह से तैयार की गई रणनीति पसंदीदा खिलाड़ियों का समर्थन करती है!
]]

--新手引导
L.TUTORIAL.SETTING_TITLE ="नौसिखिया शिक्षण"--新手教学
L.TUTORIAL.FIRST_IN_TIPS =[[
सुपर टेक्सास होल्डम आपका स्वागत है! 
तो प्यारा चाँ आप को ये गेम बढ़ाएंगे।यदि आप पहले से ही डिफ्यू के मूल गेमप्ले को  जानते हैं, तो आप गाइड को छोड़ने का विकल्प चुन सकते हैं। अन्यथा शिक्षण शुरू करने का चयन करेंगे।

पहली बार आप नौसिखिया बूट को पूरा है तो आपको 8000 चिप्स प्राप्त होगा।
]]
L.TUTORIAL.FIRST_IN_BTN1 ="मार्गदर्शन छोड़ेंगे"--跳过引导
L.TUTORIAL.FIRST_IN_BTN2 ="शिक्षण प्रारंभ करेंगे"--开始教学
L.TUTORIAL.END_AWARD_TIPS ="शिक्षण पूरा करने से चिप्स लेंगे।"--完成教程领取筹码
L.TUTORIAL.FINISH_AWARD_TIPS ="बधाई हो, आपको {1} चिप्स के लिए नौसिखिया पैक मिला है, आप फिर से आने या तुरंत शुरू करने के लिए चुन सकते हैं।"--恭喜你，您获得了{1}筹码的新手教学礼包，您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_NOAWARD_TIPS ="आप पहले से ही एक टेक्सास होल्डम विशेषज्ञ हैं, आप फिर से आने या तुरंत शुरू करने के लिए चुन सकते हैं।"--您已经是德州扑克高手啦，您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_FIRST_BTN ="फिर से आने बढ़ेंगे।"--重新学习
L.TUTORIAL.FINISH_SECOND_BTN ="शुरू करेंगे।"--快速开始
L.TUTORIAL.SKIP ="उपेक्षा"--跳 过
L.TUTORIAL.NEXT_STEP ="आगे"--下一步
L.TUTORIAL.GUESS_TRUE_13 ="ठीक है, आप के पास AA है, बड़ा कार्ड है।\n\nसट्टेबाजी के अगले दौर में प्रवेश करने के लिए कहीं भी क्लिक करेंगे।"--答对了，您现在有一对(A)，挺大的。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_22 ="ठीक है, आप के पास दो जोड़ (A/9) है।\n\nसट्टेबाजी के अगले दौर में प्रवेश करने के लिए कहीं भी क्लिक करेंगे।"--答对了，您现在有两对(A/9)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_27 ="ठीक है, आप के पास दो फूल होउस (A/9) है।\n\nसट्टेबाजी के अगले दौर में प्रवेश करने के लिए कहीं भी क्लिक करेंगे।"--答对了，您现在是葫芦(9/A)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_FLASE ="गलत है, फिर से सोचिये।"--错啦，再仔细想想...
L.TUTORIAL.RE_SELECT ="पुनर्निर्वाचन"--重选
L.TUTORIAL.TIPS = {
"मेनू से बाहर निकलेंगे",--退出菜单, 
"चिप्स खरीदेंगे",--购买筹码,
"अन्य लोगों की जानकारी देखने के लिए क्लिक करेंगे   चिप्स भेजेंगे  इंटरैक्टिव प्रोप्स का उपयोग करेंगे",--点击查看他人信息 赠送筹码 使用互动道具,
"जाति कार्ड",--公共牌,
"स्लॉट मशीन खोलने के लिए स्लाइड करेंगे या क्लिक करेंगे।",--滑出或者点击打开老虎机,
"मेरी चित्र",--我的头像,
"मेरी कार्ड",--我的手牌,
"ऑपरेशन बटन",--操作按钮,
"स्माइली भेजने के लिए चैट पर क्लिक करेंगे।"--点击聊天 发送表情
}
L.TUTORIAL.ROOM_STEP_1 ="ओपन सोर्स टेक्सास होल्डम में आपका स्वागत है! पहली बार जब आप नौसिखिया बूट को पूरा करेंगे तो आपको {1} प्राप्त होगा।\n\nअगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--欢迎来到开源德州扑克！首次完成新手引导即可获赠{1}筹码。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_2 ="खेल की शुरुआत में, डीलर प्रत्येक खिलाड़ी को दो कार्ड भेजेगा, केवल अपना दिखाई देगा।\n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--游戏开始荷官会给每个人发两张手牌，只有自己可见。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_3 ="इसके बाद, 5 सार्वजनिक कार्ड कदम से कदम जारी किए जाएंगे और सभी सार्वजनिक खिलाड़ी देख सकते हैं। \n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--之后会逐步发出5张公牌，公牌所有玩家都可以看到。\n\n点击任意位置进入下一步"
L.TUTORIAL.ROOM_STEP_4 ="आपका अंतिम कार्ड सार्वजनिक और हाथ से पांच कार्ड वाला सबसे बड़ा कार्ड है। कार्ड का आकार चित्रा (रॉयल फ्लश मैक्स -> हाई कार्ड मिन) में दिखाया गया है।"--你最后成牌是从公牌和手牌中选5张组成的最大牌型构成，牌型大小如图所示(皇家同花顺最大->高牌最小)
L.TUTORIAL.ROOM_STEP_5 ="सबसे बड़ा कार्ड के प्रकार का आपका वर्तमान संरचना एक शाही फ्लश (समान सूट सीधे 10 जम्मू क्यू कश्मीर एक से पांच), निमिष कर्सर पर सबसे बड़ा ब्रांड पोर्टफोलियो का चयन किया जाता है।\n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--您当前组成的最大牌型则是皇家同花顺(5张相同花色顺子10 J Q K A)，光标闪烁处就是选中的最大牌组合。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_6 ="क्या आपके पास कोई नियंत्रण है? \n चलो एक गेम शुरू करें! \n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--都掌握了吗？\n下面我们正式开始一局吧！\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_7 ="ऑपरेटिंग यहाँ क्षेत्र खेल रहा है, जब आप काम करने के लिए बारी है, आप अपने खुद के ब्रांड के अनुसार उचित कार्रवाई का चयन कर सकते हैं। \n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--此处是玩牌操作区域，轮到你操作时，可以根据自己的牌选择相应操作。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_8 ="अब यह तुम्हारी बारी है, आपका वर्तमान हाथ ठीक है! \n\nकॉल चुनने के लिए बटन क्लिक करें"--现在轮到你了，你当前的牌还不错! \n\n点击按钮选择跟注
L.TUTORIAL.ROOM_STEP_11="दो अन्य खिलाड़ियों के कॉल को चुना है, कुछ भी नहीं अच्छा कार्ड अब पहले तीन समुदाय कार्ड जारी की तरह लग रहे है। \n\n अगले चरण पर जाने के लिए कहीं भी क्लिक करेंगे।"--其他两个玩家都选择CALL，看样也没什么好牌，现在发前三张公牌。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_13="जब तीन कार्ड जारी किए गए थे, तो आपने एक नया कार्ड बनाया। लगता है कि आपका वर्तमान कार्ड क्या है? "--三张公牌发完，你组成了新的牌型，猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_14="यह तुम्हारी बारी है, पहले सोचो कि आगे क्या करना है। दूसरों को फ्लश (बेर) हो सकता है, पहले एक कार्ड चुनेंगे।"--又轮到你了，先想想下一步怎么操作，别人有可能会是同花(梅花)，先选择一把看牌
L.TUTORIAL.ROOM_STEP_16="खिलाड़ी {1} ने उठाने के लिए चुना है। उठाने में आम तौर पर एक मजबूत हाथ है। सावधान रहें और प्रतीक्षा करें और देखें कि क्या यह परिवर्तन होता है।"--玩家{1}选择了加注，加注一般有比较强的牌力，要小心，先静观其变吧"
L.TUTORIAL.ROOM_STEP_18="खिलाड़ी {1} को गुना करना चुना गया है। तह का मतलब है कि बोर्ड को सभी दांव खो दिए गए हैं। यह पर्याप्त नहीं है जब बिजली पर्याप्त नहीं है।"--玩家{1}选择了弃牌，弃牌就意味着这一局输掉所有已经下注的筹码，当牌力不够的时候选择弃牌比较合理"
L.TUTORIAL.ROOM_STEP_19="यह फिर से आपकी बारी है, वर्तमान कार्ड अच्छा है (A A), कॉल चौथे कार्ड पर दिखता है।"--又轮到你了，当前牌力不错一对(A)，CALL下看第四张公牌
L.TUTORIAL.ROOM_STEP_22="चार कार्ड जारी किए जाने के बाद, आपने एक नया कार्ड दोबारा बना लिया। लगता है आपका वर्तमान कार्ड क्या है? "--四张公牌发完，你又组成了新的牌型，猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_23="गेम में केवल दो खिलाड़ी शेष हैं। अब आपके पास दो जोड़ी हैं (A / 9) आपके पास अच्छा हाथ है। आप {1} को उठा सकते हैं।"--游戏只剩两个玩家了，你现在有两对(A/9)，牌力不错，可以加注{1}试试
L.TUTORIAL.ROOM_STEP_25="{1} भी चाल है, खेल एक पांचवें सार्वजनिक कार्ड भेज देंगे।"--{1}也选择跟住，游戏将发第五张公牌
L.TUTORIAL.ROOM_STEP_27="पांच सार्वजनिक कार्ड समाप्त हो गए थे। आपका अंतिम हाथ भी पुष्टि हो गया है। आपका अंतिम हाथ क्या है? "--五张公牌都发完啦，你的最终牌型也确定了，你的最终牌型是什么？
L.TUTORIAL.ROOM_STEP_29="{1} ALL_IN, यह भविष्यवाणी की गई है कि शक्ति छोटा नहीं है, लेकिन आपका फूल होउस (9 / A) भी बहुत बड़ा है, का पालन करें।"--{1}ALL_IN了，预测牌力不小，但你葫芦(9/A)也很大，跟了!
L.TUTORIAL.ROOM_STEP_32="अंतिम तसलीम, और (फूल होउस > एक प्रकार) {1} एक प्रकार है, तो आप फूल होउस हैं, तो आप जीतने के लिए! आप पॉट सभी चिप्स जीता! "--最后亮牌了，{1}是同花，你是葫芦，你赢了(葫芦>同花)！您获得了底池所有的筹码！
L.TUTORIAL.ROOM_STEP_34="यह खेल का दूसरा तत्व है और आपको इसे स्वयं खोजना होगा।"--这是游戏的其他元素，需要你自己去探索啦

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
return L
