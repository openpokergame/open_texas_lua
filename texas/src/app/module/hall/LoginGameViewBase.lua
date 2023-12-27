-- 登录视图
local loger = sa.Logger.new("LoginGameViewBase"):enabled(true)

local LoginGameViewBase = class("LoginGameViewBase", function ()
    return display.newNode()
end)

local DebugPopup = import("app.module.debugtools.DebugPopup")

local LOGO_POS_X = display.cx - 260
local LOGO_POS_Y = 176
local BTN_NODE_SHOW_Y = -display.cy + 140
local BTN_NODE_HIDE_Y = -display.cy - 250

function LoginGameViewBase:ctor(controller)
    print("login bgscalue: ", tx.bgScale)
    self.bg_ = display.newNode()
        :scale(tx.bgScale)
        :addTo(self)

    display.newSprite("img/bg_signin_v2.jpg")
        :addTo(self.bg_)

    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self.controller_ = controller
    self.controller_:setDisplayView(self)

    if DEBUG >= 5 then
        cc.ui.UIPushButton.new("debug_icon.png", {scale9 = true})
            :pos(display.cx - 40, display.cy - 40)
            :addTo(self)
            :onButtonClicked(buttontHandler(self, self.onPhpSelector_))
    end

    -- local logo = sp.SkeletonAnimation:create("spine/denglu.json","spine/denglu.atlas")
    --     :pos(display.cx - 260, display.cy - 100 )
    --     :scale(0.6)
    --     :addTo(self)
    -- logo:registerSpineEventHandler(function (event)
    --     tx.SoundManager:playSound(tx.SoundManager.LOGO_ANIMATION)
    -- end, sp.EventType.ANIMATION_START)
    -- logo:setAnimation(0, "1", true)
    -- logo:setAnimation(0, "2", false)

    --添加登录按钮
    self:addLoginButtons_()

    --添加加载显示
    self:addLoadingNode_()
end

function LoginGameViewBase:addLoginButtons_()
    -- 子类实现
end

function LoginGameViewBase:addLoadingNode_()
    self.loadingNode_ = display.newNode()
        :pos(0, -20)
        :addTo(self, 10)
        :hide()

    local x, y = 0, -70

    -- self.loading_frame = sp.SkeletonAnimation:create("spine/dian.json","spine/dian.atlas")
    --     :pos(x, y)
    --     :addTo(self.loadingNode_)

    ui.newTTFLabel({text = sa.LangUtil.getText("LOGIN", "LOGINING_MSG"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 28, align = ui.TEXT_ALIGN_CENTER})
        :pos(x, y - 100)
        :addTo(self.loadingNode_)
end

function LoginGameViewBase:playLoadingAnim_()
    self.loadingNode_:show()
    -- self.loading_frame:setAnimation(0, "1", true)
    self:setLoading(true)
end

function LoginGameViewBase:stopLoadingAnim_()
    self.loadingNode_:hide()
    self:setLoading(false)
end

function LoginGameViewBase:onEnter()
    local g = global_statistics_for_umeng
    g.umeng_view = g.Views.login
end

function LoginGameViewBase:onExit()
    local g = global_statistics_for_umeng
    g.umeng_view = g.Views.other
end

function LoginGameViewBase:playShowAnim()
    local animTime = self.controller_:getAnimTime()

    self.btnNode_:stopAllActions()
    transition.moveTo(self.btnNode_, {
        time = animTime, 
        y = BTN_NODE_SHOW_Y, 
    })

    -- if _G.isFbGuideLogin then
    --     _G.isFbGuideLogin = nil
    --     if device.platform == "android" or device.platform == "ios" then
    --         tx.schedulerPool:delayCall(function()
    --             self:onFacebookClicked_()
    --         end, animTime + 0.5)
    --     end
    -- end

    if _G.isBindGuestLogin then
        _G.isBindGuestLogin = nil
        if device.platform == "android" or device.platform == "ios" then
            tx.schedulerPool:delayCall(function()
                local loginType = tx.userDefault:getIntegerForKey(tx.cookieKeys.GUEST_BIND_TYPE, 1)
                if self.quickLogin then
                    self:quickLogin(loginType)
                end
            end, animTime + 0.5)
        end
    end
end

function LoginGameViewBase:onFacebookClicked_()
    -- 子类实现
end

function LoginGameViewBase:setShowState()
    local animTime = self.controller_:getAnimTime()

    transition.moveTo(self.btnNode_, {
        time = animTime, 
        y = BTN_NODE_SHOW_Y, 
    }) 
end

function LoginGameViewBase:playHideAnim()
    local animTime = self.controller_:getAnimTime()
    self:removeFromParent()
end

function LoginGameViewBase:playLoginAnim()
    self.btnNode_:stopAllActions()
    self:setLoading(true)
    transition.moveTo(self.btnNode_, {
        time = 0.3, 
        y = BTN_NODE_HIDE_Y, 
        onComplete = handler(self, function (obj)
            self:playLoadingAnim_()
        end)
    })
end

function LoginGameViewBase:playLoginFailAnim()
    local animTime = self.controller_:getAnimTime()

    self:stopLoadingAnim_()    

    self.btnNode_:stopAllActions()
    transition.moveTo(self.btnNode_, {
        time = animTime, 
        y = BTN_NODE_SHOW_Y, 
    }) 
end

function LoginGameViewBase:getLoginBaseParams_()
    local deviceInfo = tx.Native:getDeviceInfo()
    local params = {
        mobile_request = tx.Native:getLoginToken(),
        device = (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform),
        pay = (device.platform == "windows" and tx.TestUtil.simuDevice or device.platform),
        osVersion = "1.0.0",
        version = SA_UPDATE and SA_UPDATE.VERSION or tx.Native:getAppVersion(),
        deviceId = deviceInfo.deviceId,
        deviceName = deviceInfo.deviceName,
        deviceModel = deviceInfo.deviceModel,
        installInfo = deviceInfo.installInfo,
        cpuInfo = deviceInfo.cpuInfo,
        ramSize = deviceInfo.ramSize,
        simNum = deviceInfo.simNum,
        networkType = deviceInfo.networkType,
        phoneNumbers = deviceInfo.phoneNumbers,
        location = deviceInfo.location,
        macAddr = tx.Native:getMacAddr(),
        idfa = tx.Native:getIDFA(),
        udid = crypto.md5(tx.Native:getIDFA()) or "",
        channel_id = string.split(tx.Native:getChannelId(),"-")[1] or "",
        sid = appconfig.SID[string.upper(device.platform)],
        lang = appconfig.LANG,
        requestTimeOut = 12,  -- 超时
        country = appconfig.COUNTRY
    }

    return params
end

function LoginGameViewBase:loginGame_(params)
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "eventCustom",
            args = {
                eventId = "request_login",
                attributes = "count",
                counter = 1
            }
        }
    end
    sa.HttpService.POST_URL(
        appconfig.LOGIN_SERVER_URL,
        params,
        handler(self, self.onLoginSucc_),
        handler(self, self.onLoginError_)
    )
end

function LoginGameViewBase:onLoginSucc_(data)
    self.controller_:onLoginSucc_(data)
end

function LoginGameViewBase:onLoginError_(data)
    self.controller_:onLoginError_(data)
end

function LoginGameViewBase:reportLoginResult_(loginType, code, detail)
    self.controller_:reportLoginResult_(loginType, code, detail)
end

function LoginGameViewBase:isLogining_()
    if self.isLoginInProgress_ > 0 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "LOGIN_DEALING"))
        return true
    end

    return false
end

function LoginGameViewBase:setLoginType_(loginType)
    self.isLoginInProgress_ = 1
    self.controller_.showPendingPopup = false
    tx.userDefault:setStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE, loginType)
    tx.userDefault:flush()
end

function LoginGameViewBase:onPhpSelector_()
    DebugPopup.new():show()
end

function LoginGameViewBase:onCleanup()
    self:setLoading(false)
end

function LoginGameViewBase:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, -70)
                :addTo(self.loadingNode_)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

return LoginGameViewBase
