local HallController = class("HallController")

local logger                = sa.Logger.new("HallController")
local RegisterRewardPopup   = import("app.module.register.RegisterRewardPopup")
local LoginRewardView       = import("app.module.loginreward.LoginRewardView")
local ActivityCenterPopup   = import("app.module.newestact.ActivityCenterPopup")
local MessageData           = import("app.module.message.MessageData")
local FriendData            = import("app.module.friend.FriendData")
local LoadGiftControl       = import("app.module.gift.LoadGiftControl")
local SlotPopup             = import("app.module.slot.SlotPopup")
local DailyTask             = import("app.module.dailytasks.DailyTask")
local Achieve               = import("app.module.dailytasks.Achieve")

-- 视图类型
HallController.FIRST_OPEN      = 0
HallController.LOGIN_GAME_VIEW = 1
HallController.MAIN_HALL_VIEW  = 2

-- 动画时间
HallController.ANIM_TIME = 0.5

JSON_PARSE_ERROR_KEY = "JSON_PARSE_ERROR_KEY"
reportJsonData = {}

function HallController:ctor(scene)
    -- 自动买入缓存BUG
    local flush = tx.userDefault:getIntegerForKey("FLASH_DELETE",0)
    if flush~=1 then
        tx.userDefault:setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
        tx.userDefault:setIntegerForKey("FLASH_DELETE",1)
        tx.userDefault:flush()
    end

    self.scene_ = scene

    --登陆后的弹框需要一个一个的弹，此处先缓冲要弹的框
    self.PendingPopup = {}
end

function HallController:checkAutoLogin()
    self:getJsonTab()
    
    self:reportJsonTab()
    
    self.view_:checkAutoLogin()
end

function HallController:onAfterLoginSucc_()
    local ip, port = string.match(tx.userData.HallServer[1], "([%d%.]+):(%d+)")
    tx.socket.HallSocket:connectDirect(ip, port, true)

    -- if tx.config.MATCH_ENABLED then
    --     tx.userData.MatchServer = {tx.userData.matchIpPort}
    --     local ip, port = string.match(tx.userData.MatchServer[1], "([%d%.]+):(%d+)")
    --     tx.socket.MatchSocket:connectDirect(ip, port, true)
    -- end
end

function HallController:onLoginSucc_(data)
    -- logger:debugf("HallController:onLoginSucc_: %s", data)
    self.view_.isLoginInProgress_ = 2
    local retData = json.decode(data)
    if type(retData) == "table" and retData.uid and tonumber(retData.uid) > 0 then
        self.isEnteringRoom_ = false
        self:processUserData(retData)

        local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
        -- 设置为全局数据
        sa.DataProxy:setData(tx.dataKeys.USER_DATA, retData, true)
        -- 设置玩家登陆时等级
        tx.userDefault:setStringForKey(tx.cookieKeys.LOGIN_USER_LEVEL, tx.userData.level)
        tx.userDefault:flush()

        -- 设置http请求的默认参数
        sa.HttpService.setDefaultURL(retData.CGI_ROOT)

        sa.HttpService.setDefaultParameter("mtkey", retData.mtkey)
        sa.HttpService.setDefaultParameter("skey", retData.skey)
        sa.HttpService.setDefaultParameter("uid", retData.uid)
        sa.HttpService.setDefaultParameter("macid",tx.Native:getMacAddr() or "")
        sa.HttpService.setDefaultParameter("version", SA_UPDATE and SA_UPDATE.VERSION or tx.Native:getAppVersion())
        sa.HttpService.setDefaultParameter("device", (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform))
        sa.HttpService.setDefaultParameter("channel", retData.channel)
        sa.HttpService.setDefaultParameter("sid", appconfig.SID[string.upper(device.platform)] or 1)
        sa.HttpService.setDefaultParameter("udid", crypto.md5(tx.Native:getIDFA()) or "")
        sa.HttpService.setDefaultParameter("channel_id", string.split(tx.Native:getChannelId(),"-")[1] or "")
        sa.HttpService.setDefaultParameter("lang",appconfig.LANG)

        tx.userData.limitMin = 1000  -- 最小房间买入筹码数

        -- 加载开关
        self:removeOnOffLoadListener()
        self.onOffLoadId_ = sa.EventCenter:addEventListener("OnOff_Load", handler(self, self.onOffLoadCallback_))
        tx.OnOff.isFirst = true
        app:loadOnOffData()

        self.view_:setUserDataByLoginType(lastLoginType)
        
        -- 设置视图
        _G.hallRankingData = nil
        self.scene_:onLoginSucc()

        -- 派发登录成功事件
        sa.EventCenter:dispatchEvent(tx.eventNames.HALL_LOGIN_SUCC)

        self:proLoginedPopup_()

        -- 第一次登录上报注册信息
        if tx.userData.firstin ~= nil and tx.userData.firstin == 1 then
            tx.userData.gameCount = 0
            if device.platform == "android" or device.platform == "ios" then
                cc.analytics:doCommand{
                    command = "eventCustom",
                    args = {
                        eventId = "new_game_login_success",
                        attributes = "count",
                        counter = 1
                    }
                }
            end
        end
        if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand{
                command = "eventCustom",
                args = {
                    eventId = "game_login_success",
                    attributes = "count",
                    counter = 1
                }
            }
        end

        -- 超过7天没有登录 上报召回信息
        if tonumber(tx.userData.today) ~= nil and tonumber(tx.userData.lasttime) ~= nil and
            (tonumber(tx.userData.today) - tonumber(tx.userData.lasttime)  > 604800 ) then
        end

        local proxyList = self:getProxyListFromUserData_(retData)

        --设置代理
        tx.socket.ProxySelector.setProxyList(proxyList)
        -- 获取游戏静态配置
        self:getAppStaticConf_()

	    self:onAfterLoginSucc_()

        -- 拉取消息
        self:onGetMessage()

        self:getTableConfig_()

        --预拉取商城数据
        self:preGetMarketData()

        --获取玩家支付信息  首充 破产支付倒计时
        self:getUserPayInfo()

        --缓存等级
        tx.Level:loadConfig(retData.levelJsonDomain)

        --缓存礼物
        LoadGiftControl:getInstance():loadConfig(retData.giftJsonDomain)

        -- 上报设备登录账号数
        self:reportLoginAccountCount_(retData.uid)

        --友盟上报用户等级
        self:reporttUserLevel_()

        -- 推送注册
        if tx.Push then
            tx.Push:register(function(success, result)
                if success then
                    sa.HttpService.POST({
                        mod="User", act="pushToken", token=result
                    })
                end
            end)
            self.scene_:parsePushData() -- 基类实现
        end
    else
        if not retData then
            if #reportJsonData < 10 then
                table.insert(reportJsonData,{errordata = data})
            end
            self:reportJsonTab()
            self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "1", "json parse error")
            local deviceInfo = tx.Native:getDeviceInfo()
            sa.HttpService.POST_URL(appconfig.LOGIN_SERVER_URL, {
                report = "true",
                cli_err_type = "json parse error",
                cli_receive_pack = data,
                version = SA_UPDATE and SA_UPDATE.VERSION or tx.Native:getAppVersion(),
                deviceId = deviceInfo.deviceId,
                deviceName = deviceInfo.deviceName,
                deviceModel = deviceInfo.deviceModel,
                installInfo = deviceInfo.installInfo,
                cpuInfo = deviceInfo.cpuInfo,
                ramSize = deviceInfo.ramSize,
                simNum = deviceInfo.simNum,
                macAddr = tx.Native:getMacAddr(),
                idfa = tx.Native:getIDFA(),
				udid = crypto.md5(tx.Native:getIDFA()) or "",
				channel_id = string.split(tx.Native:getChannelId(),"-")[1] or "",
                device = (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform),
            })
        elseif retData.ret == -100 then
            --被封号
            self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "7", "user banned")
            tx.ui.Dialog.new({
                messageText = retData.msg,
                closeWhenTouchModel = false,
                hasFirstButton = false,
                hasCloseButton = false,
            }):show()
            self.view_.isLoginInProgress_ = -1
            self.view_:playLoginFailAnim()
        elseif retData.ret == -9999 then
            self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "2", "server stopped")
            --停服处理
            tx.ui.Dialog.new({
                messageText = retData.msg,
                closeWhenTouchModel = false,
                hasFirstButton = false,
                hasCloseButton = false,
            }):show()
            self.view_.isLoginInProgress_ = -1
            self.view_:playLoginFailAnim()
            return
        elseif retData.uid and retData.uid <= 0 then
            logger:error("uid is", retData.uid)
            local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
            self:reportLoginResult_(lastLoginType, "3", "uid<0;" .. data)
            if lastLoginType ==  "FACEBOOK" then
                if tx.Facebook then
                    tx.Facebook:logout()
                end
            end
        end
        self:onLoginError_("noReportError")
    end
end

function HallController:getTableConfig_()
    --获取德州选场数据
    tx.TableConfigManager:getTexasTableConfig(nil, true)

    --获取比赛SNG选场数据
    -- if tx.config.MATCH_ENABLED then
    --     tx.TableConfigManager:getSNGTableConfig(nil, true)
    -- end

    --获取奥马哈选场数据
    tx.TableConfigManager:getOmahaTableConfig(nil, true)

    --获取德州必下选场数据
    tx.TableConfigManager:getTexasMustTableConfig(nil, true)
end

function HallController:getProxyListFromUserData_(userData)
    local ret = {}
    if userData.proxyAddr_array then
        for _, proxyAddr in ipairs(userData.proxyAddr_array) do
            local proxyArr = string.split(proxyAddr, ":")
            local proxyIp = proxyArr[1]
            local proxyPort = checkint(proxyArr[2])
            if proxyIp and string.len(proxyIp) > 0 and proxyPort > 0 then
                table.insert(ret, {ip=proxyIp, port=proxyPort})
            end
        end
    end
    return ret
end

function HallController:processUserData(userData)
    if userData then
        for k,v in pairs(userData) do
            local value = v
            if type(value)=="string" then
                value = tonumber(value) or value
            end
            userData[k] = value
        end
    end
    --未返回的数字初始化一个值
    userData.safe_money = userData.safe_money or 0 --保险箱里的筹码
    userData.safe_diamonds = userData.safe_diamonds or 0 --保险箱里的钻石
    userData.safe_password = userData.safe_password or 0 --是否有保险箱密码
    userData.safe_email = userData.safe_email or "" --绑定邮箱
    userData.nick = (userData.nick and userData.nick.."")
    userData.win = userData.wintimes or 0
    userData.lose = userData.losetimes or 0
    userData.maxmoney = userData.maxmoney or 0
    userData.s_picture = userData.s_picture or userData.uimg or ""
    userData.diamonds = userData.diamonds or 0
    userData.level = userData.level or 1
    userData.line = userData.line or 0
    userData.lineaccount = userData.lineaccount or ""
    userData.switch_match = userData.switch_match or 0
    userData.inviteSendChips = userData.inviteSendChips or 500 --发送FB邀请奖励
    userData.inviteSuccessReward = userData.inviteSuccessReward or 60000 --FB邀请成功奖励
    userData.vipinfo = userData.vipinfo or {level=0, expression={dog=1000,ant=2000}} -- vip
    userData.hddjnum = userData.hddjnum or 0

    userData.switch_aomaha = userData.switch_aomaha or 0
    userData.switch_honghei = userData.switch_honghei or 0
    userData.switch_allin = userData.switch_allin or 0
    userData.aomahLevelLimit = userData.aomahLevelLimit or 2
    userData.hongheiLevelLimit = userData.hongheiLevelLimit or 3
    userData.allinLevelLimit = userData.allinLevelLimit or 4

    -- 新手教程
    userData.tutorial_getted = 1 -- 是否已经领取了新手奖励
    userData.tutorial_award = 8000 -- 新手教程奖励

    -- 加载远程动画
    userData.isUseAnimation = 1

    userData.isShowVipExpTips = true --非VIP使用表情,每次登录弹出一次提示框

    userData.isShowVipPropTips = true --非VIP使用道具,每次登录弹出一次提示框

    tx.config.MATCH_ENABLED = false
    --  (tonumber(userData.switch_match) == 1)
    if userData.win_share then  -- 赢牌分享开关
        tx.config.WIN_SHARE = tonumber(userData.win_share)
    end

    if userData.code_invite then
        tx.config.CODE_INVITE = tonumber(userData.code_invite)
    end

    if userData.lose_open_firstpay then
       tx.config.LOSE_OPEN_FIRSTPAY = tonumber(userData.lose_open_firstpay)
    end

    if userData.is_show_fb_tips then
       tx.config.IS_SHOW_FB_TIPS = tonumber(userData.is_show_fb_tips)
    end

    tx.config.SHOW_SHARE = tonumber(userData.show_share) or 0 --分享开关
    tx.config.SHOW_SMS = tonumber(userData.show_sms) or 0 --俄语版强制关闭
    tx.config.SHOW_VIP = tonumber(userData.show_vip) or 0
    tx.config.SHOW_INVITE_AWARD = tonumber(userData.show_invite_award) or tx.config.SHOW_VIP
    tx.config.SHOW_GUIDE_RATE = tonumber(userData.show_guide_rate) or 0

    -- 新手教程 德州输牌弹出引导
    if tonumber(userData.losetimes)==0 then
        userData.needTutorial = 1
    end

    userData.isShowActPoint = 1

    userData.autoBuyGoldIsland = false --默认不自动购买夺金岛
    userData.isBuyGoldIsland = false --是否已经买了下局夺金岛
    userData.isJoinGoldIsland = false --是否参与本局夺金岛
    userData.goldIslandPool = 10000 --夺金岛奖池

    userData.goldIslandConfig = userData.goldIslandConfig or {reward = {80, 30, 10},minBlind = 3000,betChips=5000}

    userData.canBindGuest = userData.canBindGuest or 0 --游客绑定状态，0此功能未开启，1可以绑定，2已经绑定
    userData.isGuestBindReward = userData.isGuestBindReward or 1 --是否领取游客绑定奖励，默认1领取了
    userData.guestBindReward = userData.guestBindReward or 50000 --游客绑定奖励
    -- IS_WEB_BLUEPAY = false
    -- if device.platform == "android" and userData.is_web_bluepay == 1 then
    --     IS_WEB_BLUEPAY = true
    -- end
    -- -- 强制Web支付 IOS 和 越南包
    -- if device.platform == "ios" or appconfig.SID[string.upper(device.platform)]==3 then
    --     IS_WEB_BLUEPAY = true
    -- end

    userData.isHolidayShakeSendChips = 0 --摇一摇活动是否可以筹码，如果用摇完免费次数，然后送了筹码有摇的次数，但是不会播放动画

    userData.isThailand = userData.isThailand or 0 --是否是泰国地区

    userData.countryId = userData.countryId or 101 --国籍
end

function HallController:reporttUserLevel_()
    if device.platform == "android" then-- or device.platform == "ios"
        local isInit = tx.userDefault:getBoolForKey("IS_INIT_USER_LEVEL", false)
        if not isInit then
            -- cc.analytics:doCommand{
            --     command = "setUserLevel",
            --     args = {level = tx.userData.level}
            -- }
            tx.Native:reporttUserLevel(tx.userData.level)

            tx.userDefault:setBoolForKey("IS_INIT_USER_LEVEL", true)
        end
    end
end

function HallController:onLoginError_(errorData)
    -- logger:debugf("HallController:onLoginError_: %s", errorData)
    if errorData~="noReportError" then
        self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "4", "connection problem")
    end
    
    tx.userDefault:setStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE, "")
    tx.userDefault:flush()

    self.view_.isLoginInProgress_ = -1
    -- 视图处理登录失败
    self.view_:playLoginFailAnim()
    -- 通知网络错误
    tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
end

function HallController:doBackFromRoom()
    self.scene_:performWithDelay(handler(self, self.handleBackFromRoom), 1.0)
end

function HallController:handleBackFromRoom()
    
end

-- 设置当前视图
function HallController:setDisplayView(view)
    self.view_ = view
    --登录是否正在处理 -1 未登陆，1 正在登陆  2 已经登陆
    self.view_.isLoginInProgress_ = -1
end

-- 获取背景缩放系数
function HallController:getBgScale()
    return self.scene_:getBgScale()
end

-- 获取动画时间
function HallController:getAnimTime()
    return HallController.ANIM_TIME
end

-- 清理实例
function HallController:dispose()
    if self.storeController_ then
        self.storeController_:dispose()
    end
    -- 移除请求
    sa.HttpService.CANCEL(self.luckTurnTimesId_)
    self:removeOnOffLoadListener();
end

function HallController:removeOnOffLoadListener()
    if self.onOffLoadId_ then
        sa.EventCenter:removeEventListener(self.onOffLoadId_);
        self.onOffLoadId_ = nil
    end
end

function HallController:onOffLoadCallback_()
    self:removeOnOffLoadListener()
end

-- 检查接下来的弹框
function HallController:checkPendingPupop()
    self.showPendingPopup = false
    if self.PendingPopup and self.PendingPopup[1] then
        local cb_ = table.remove(self.PendingPopup, 1)
        if cb_ then
            cb_()
            self.showPendingPopup = true
        end
    else
        sa.EventCenter:dispatchEvent({name="PengdingPopup_End"})
    end
end

-- 打开大厅老虎机
function HallController:showSlotPopup()
    display.addSpriteFrames("slot_texture.plist", "slot_texture.png", function()
        SlotPopup.new(false):showPanel()
    end)
end

function HallController:showRegisterReward()
    if tx.userData.registerReward.code == 1 then
        table.insert(self.PendingPopup, function(data)
            local view_ = RegisterRewardPopup.new():setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

-- 显示登陆奖励
function HallController:showLoginReward()
    if tx.userData.loginReward.canReward == 1 then
        table.insert(self.PendingPopup, function(data)
            LoginRewardView.new():setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

function HallController:showActivityCenterPopup()
    if tx.userData.isShowActivity == 1 then
        table.insert(self.PendingPopup, function(data)
            ActivityCenterPopup.new():setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

--显示首充
function HallController:showFirstPayPopup()
    if tx.userData.payStatus == 0 then
        table.insert(self.PendingPopup, function(data)
            local FirstPayPopup = require("app.module.payguide.firstpay.FirstPayPopup")
            FirstPayPopup.new():setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

-- 显示邀请码
function HallController:showInviteCode()
    if tx.config.CODE_INVITE==1 and tx.userData.dailyFirstin==1 then
        table.insert(self.PendingPopup, function(data)
            local ExchangeCodePopup = require("app.module.exchangecode.ExchangeCodePopup")
            ExchangeCodePopup.new():setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

-- 推送兑奖码
function HallController:showExchangeCodePop(code)
    if code then
        table.insert(self.PendingPopup, function(data)
            local ExchangeCodePopup = require("app.module.exchangecode.ExchangeCodePopup")
            ExchangeCodePopup.new(code,2):setCloseCallback(handler(self, self.checkPendingPupop)):showPanel()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

-- 显示新手引导
function HallController:showTutorial()
    local isShow = false
    if tx.userData and tx.userData.win and tx.userData.lose then
        if (tonumber(tx.userData.win)+tonumber(tx.userData.lose))<1 then  -- 新手教程
            isShow = true
        end
    end
    if isShow then
        table.insert(self.PendingPopup, function(data)
            self:openTutorial()
            self.showPendingPopup = true
        end)

        if not self.showPendingPopup then
            self:checkPendingPupop()
        end
    end
end

-- 获取新手教程
function HallController:getTutorialInfo()
    local userData = tx.userData
    if not userData then return end
    local requestTutorial
    local maxretry = 4
    requestTutorial = function()
        sa.HttpService.POST({
                mod="Beginners",
                act="check",
            },
            function(retData)
                local retJson = json.decode(retData)
                if retJson and retJson.code == 1 then
                    if tx.userData then
                        tx.userData.tutorial_getted = tonumber(retJson.guide)
                        tx.userData.tutorial_award = (retJson.reward and retJson.reward.money)
                    end
                else
                    maxretry = maxretry - 1
                    if maxretry > 0 then
                        requestTutorial()
                    end
                end
            end,
            function()
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestTutorial()
                end
            end)
    end
    requestTutorial()
end

-- get message
function HallController:onGetMessage()
    -- MessageData.requestMessageData()
    -- FriendData.new()
end

function HallController:checkLuckturnFreeTimes()
    sa.HttpService.CANCEL(self.luckTurnTimesId_)
    self.luckTurnTimesId_ = sa.HttpService.POST({
        mod = "BigWheel",
        act = "intitBigWheel",
    },
    function(data)
        local retData = json.decode(data)
        if retData.code == 1 then
            sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, freeTimes = retData.freetimes})
        end
    end,
    function()
        self:checkLuckturnFreeTimes()
    end)
end

-- pre get market data
function HallController:preGetMarketData()
    if not self.storeController_ then
        local StoreController = require("app.module.store.StoreController")
        self.storeController_ = StoreController.new()
        self.storeController_:init()
    end
end

-- 登录账号数上报 用于统计一个设备同时玩几个号
function HallController:reportLoginAccountCount_(uid)
    if device.platform == "android" or device.platform == "ios" then
        uid = tostring(uid)
        local uids = tx.userDefault:getStringForKey(tx.cookieKeys.LOGIN_UIDS, "")
        local count = 0
        if uids == "" then
            uids = uids..uid
            tx.userDefault:setStringForKey(tx.cookieKeys.LOGIN_UIDS, uids)
            tx.userDefault:flush()
            count = 1
        else
            local uidsTbl = string.split(uids, "#")
            if table.indexof(uidsTbl, uid) == false then
                uids = uids .. "#" .. uid
                tx.userDefault:setStringForKey(tx.cookieKeys.LOGIN_UIDS, uids)
                tx.userDefault:flush()
                count = #uidsTbl + 1
            end
        end

        cc.analytics:doCommand{
            command = "eventCustom",
            args = {
                eventId = "login_account_count",
                attributes = "type,account",
                counter = count
            }
        }
    end
end

function HallController:getAppStaticConf_()
    local userData = tx.userData
    if not userData then return end
    local requestAppConf
    local maxretry = 4
    requestAppConf = function()
        sa.HttpService.POST({
                mod="LoginSuc",
                act="returnParam",
            },
            function(retData)
                local retJson = json.decode(retData)
                if retJson and retJson.code == 1 and retJson.param then
                    if retJson.param.brokeMoneyLimit and tonumber(retJson.param.brokeMoneyLimit) ~= 0 then
                        if tx.userData then
                            appconfig.CRASHMONEY = tonumber(retJson.param.brokeMoneyLimit)
                            for k,v in pairs(retJson.param) do
                                local value = v
                                if type(value)=="string" then
                                    value = tonumber(value) or value
                                end
                                tx.userData[k] = value
                            end
                        end
                    end
                else
                    maxretry = maxretry - 1
                    if maxretry > 0 then
                        requestAppConf()
                    end
                end
            end,
            function()
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestAppConf()
                end
            end)
    end
    requestAppConf()
end

function HallController:getUserPayInfo()
    local userData = tx.userData
    if not userData then return end
    -- 默认为没有首充
    userData.payinfo = {
        boughtFirstPayGoods = 1,
        brokesalegoods = nil,
        -- brokesalegoods = {
        --     gid = 13,
        --     price = 69,
        --     sale = 30,
        --     reward='{"money":1000000}',
        --     countdown = 1000,
        --     clientTime = os.time(),
        -- },
    }
    -- do return; end--显示破产商品 --test
    local requestPayInfo
    local maxretry = 4
    requestPayInfo = function()
        sa.HttpService.POST({
                mod="LoginSuc",
                act="getUserPayInfo",
            },
            function(retData)
                local retJson = json.decode(retData)
                if retJson and retJson.code == 1 then
                    userData.payinfo = retJson.payinfo
                    if userData.payinfo then
                        if userData.payinfo.brokesalegoods then
                            userData.payinfo.brokesalegoods.clientTime = os.time()
                            userData.payinfo.brokesalegoods = nil -- 清空倒计时
                        end
                    end

                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
                else
                    maxretry = maxretry - 1
                    if maxretry > 0 then
                        requestPayInfo()
                    end
                end
            end,
            function()
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestPayInfo()
                end
            end)
    end
    requestPayInfo()
    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
end

function HallController:umengEnterHallTimeUsage()
    if device.platform ~= "android" and device.platform ~= "ios" then
        return
    end

    local g = global_statistics_for_umeng

    -- 一次进程启动只算作一次
    if g.first_enter_hall_checked then return end

    g.first_enter_hall_checked = true

    local delta = math.abs(os.difftime(os.time(), g.run_main_timestamp))

    -- 60秒以上的,只统计为60秒
    if delta > 60 then delta = 60 end

    cc.analytics:doCommand {
        command = 'eventCustom',
        args = {
            eventId    = 'boot_to_hall_time_usage',
            attributes = 'boot_time,' .. delta,
            counter    = 1, -- 自定义属性的数量, 默认为0
        },
    }
end

function HallController:getJsonTab()
    local str = tx.userDefault:getStringForKey(JSON_PARSE_ERROR_KEY, '')
    local data = json.decode(str)
    if data then
        reportJsonData = data
    end
end

function HallController:writeJsonTab()
    tx.userDefault:setStringForKey(JSON_PARSE_ERROR_KEY, json.encode(reportJsonData))
end

function HallController:reportJsonTab()
    if #reportJsonData > 0 then
        local feedBackUrl = SA_UPDATE.FEEDBACK_URL or ""
        if string.len(feedBackUrl) > 5 then
                sa.HttpService.POST_URL(feedBackUrl,
                {
                    mod = "Feedback",
                    act = "LoginError",
                    sid = appconfig.SID[string.upper(device.platform)] or 1,
                    errordata = json.encode(reportJsonData),
                },
                function(data)
                    local jsnData = json.decode(data)
                    if jsnData and jsnData.ret == 0 then
                        reportJsonData = {}
                        self:writeJsonTab()
                    else
                        self:writeJsonTab()
                    end
                end,
                function()
                    self:writeJsonTab()
                end
            )
        end
    end
end

function HallController:proLoginedPopup_()
    self.view_:performWithDelay(function()
        self:showRegisterReward()
        self:showLoginReward()
        self:showActivityCenterPopup()
        self:showInviteCode()
        self:showFirstPayPopup()
        self:getTutorialInfo()
        self:showTutorial()
    end, 0.1)

    -- 检查是否需要重新连入房间
    self.view_:performWithDelay(function()
        --缓存脏话库
        tx.cacheKeyWordFile()
        -- tx.SoundManager:preload("commonSounds")
    end, 2.5)
end

function HallController:checkDailyTasksReward()
    self:getTasksListData_()
    self:getAchieveListData_()
end

function HallController:getTasksListData_()
    sa.HttpService.POST(
        {
            mod = "Task",
            act = "getList"
        },
        function(data)
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                local isReward = false
                for _, v in pairs(retData.list) do
                    local task = DailyTask.new()
                    task:parseTableData(v)
                    if v.goto == 13 then
                        local isFinished = tx.userDefault:getBoolForKey(tx.cookieKeys.IS_FINISHED_PUSH_TASK .. tx.userData.uid .. os.date("%Y%m%d"), false)
                        if isFinished then
                            v.cur = 1
                            task:parseTableData(v)
                        end
                    end

                    if task and task.status == DailyTask.STATUS_CAN_REWARD then
                        isReward = true
                        break
                    end
                end

                tx.userData.canTasksReward = isReward
                sa.EventCenter:dispatchEvent({name=tx.eventNames.TASK_REWARD_POINT})
            end
        end,
        function()
        end
    )
end

function HallController:getAchieveListData_()
    sa.HttpService.POST(
        {
            mod = "Achievement",
            act = "get"
        },
        function(data)
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                local isReward = false

                for _, v in pairs(retData.list) do
                    local achieve = Achieve.new()
                    achieve:parseTableData(v)
                    if achieve and achieve.status == 1 then
                        isReward = true
                        break
                    end
                end

                tx.userData.canAchieveReward = isReward
                sa.EventCenter:dispatchEvent({name=tx.eventNames.TASK_REWARD_POINT})
            end
        end,
        function()
        end
    )
end

function HallController:quickStart()
   self.scene_:quickStart()
end

function HallController:openTutorial()
    self.scene_:openTutorial()
end

function HallController:requestRoom(param,noNewAnim)
    self.scene_:requestRoom(param,noNewAnim)
end

function HallController:doLogout()
    sa.DataProxy:clearData(tx.dataKeys.USER_DATA,true)
    tx.OnOff.onoff_ = {}
    tx.userDefault:setStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE, "")
    tx.userDefault:flush()
    if tx.Facebook then
        tx.Facebook:logout()
        tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_ACCESS_TOKEN, "")
        tx.userDefault:flush()
    end
    tx.socket.HallSocket:disconnect()
    tx.socket.MatchSocket:disconnect()
    sa.HttpService.clearDefaultParameters()
    MessageData.clearAll() -- 清空所有
end

function HallController:reportLoginResult_(loginType, code, detail)
    if device.platform == "android" or device.platform == "ios" then
        local eventName = self.view_:getEventNameByLoginType(loginType)
        if eventName then
            cc.analytics:doCommand{
                command = "event",
                args = {
                    eventId = eventName,
                    label = "[" .. code .. "]" .. detail,
                },
            }
        end
    end
end

return HallController
