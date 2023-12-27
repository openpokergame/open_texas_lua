-- 登录视图
local LoginGameViewBase = import(".LoginGameViewBase")
local LoginGameView = class("LoginGameView", LoginGameViewBase)

local logger = sa.Logger.new("LoginGameView")

local LOGO_POS_X = display.cx - 260
local LOGO_POS_Y = 176
local BTN_NODE_SHOW_Y = -display.cy + 140
local BTN_NODE_HIDE_Y = -display.cy - 250

function LoginGameView:ctor(controller)
    LoginGameView.super.ctor(self, controller)
end

--添加登录按钮
function LoginGameView:addLoginButtons_()
    self.btnNode_ = display.newNode()
        :pos(0, BTN_NODE_HIDE_Y)
        :addTo(self)

    local btn_x, btn_y = 0, 115
    local btn_w, btn_h = 415, 120
    local btn_dir = 230

    --line
    if not appconfig or appconfig.OPEN_LINE_LOGIN~=0 then
        local btn = sp.SkeletonAnimation:create("spine/denglu.json","spine/denglu.atlas")
            :size(cc.size(btn_w, btn_h))
            :align(display.CENTER, btn_x - btn_dir, btn_y)
            :addTo(self.btnNode_)
        btn:setAnimation(0, "4", true)
        ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onLineClicked_))

        local isShow = tx.userDefault:getBoolForKey(tx.cookieKeys.IS_SHOW_LINE_REWARD, true)
        if isShow then
            display.newSprite("#hall/hall_line_login_reward.png")
                :pos(btn_w - 20, btn_h - 5)
                :addTo(btn)
        end
    else
        btn_dir = 0
    end

    --fb
    local btn = sp.SkeletonAnimation:create("spine/denglu.json","spine/denglu.atlas")
        :size(cc.size(btn_w, btn_h))
        :align(display.CENTER, btn_x + btn_dir, btn_y)
        :addTo(self.btnNode_)
    btn:setAnimation(0, "3", true)
    ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onFacebookClicked_))

    --guest
    btn = display.newScale9Sprite("#common/transparent.png", 0, 0, cc.size(btn_w, 60))
        :pos(btn_x, btn_y - 112)
        :addTo(self.btnNode_)
    ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onGuestClicked_))
    
    local x, y = btn_w*0.5, 30
    local label = ui.newTTFLabel({text = sa.LangUtil.getText("LOGIN", "GU_LOGIN"), size = 40})
        :pos(x, y)
        :addTo(btn)
    sa.fitSprteWidth(label, 335)

    local size = label:getContentSize()
    display.newScale9Sprite("#hall/hall_guest_line.png", 0, 0, cc.size(size.width, 3))
        :pos(x, y - 30)
        :addTo(btn)
end

-- Line登录
function LoginGameView:onLineClicked_()    
    self:loginWithLine()
end

-- FB登录
function LoginGameView:onFacebookClicked_()
    self:loginWithFacebook()
end

-- 游客登录
function LoginGameView:onGuestClicked_()    
    self:loginWithGuest()
end

function LoginGameView:quickLogin(loginType)
    if loginType == 1 then
        self:onFacebookClicked_()
    elseif loginType == 2 then
        self:onLineClicked_()
    end
end

function LoginGameView:loginWithGuest()
    if self:isLogining_() then
        return
    end

    self:setLoginType_("GUEST")

    self:playLoginAnim()

    tx.schedulerPool:delayCall(function ()
        self:startGuestLogin_()
    end, 0.5)
end

function LoginGameView:startGuestLogin_()
    local secret = "6FjYn&$miY"
    local params = self:getLoginBaseParams_()
    params.sign = crypto.md5(params.mobile_request..secret)
    params.mtkey = ""
    params.lid = 2
    params.lang = appconfig.LANG

    self:loginGame_(params)
end

function LoginGameView:loginWithLine()
    if self:isLogining_() then
        return
    end

    self:setLoginType_("LINE")

    if tx.LineSDK then
        tx.LineSDK:login(function(success, result)
            logger:debug(success, result)
            if success then
                self:loginLineWithAccessToken_(result)
            else
                self.isLoginInProgress_ = -1
                if result == "canceled" then
                    tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "CANCELLED_MSG"))
                    self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "5", "authorization cancelled")
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_LOGIN_FAILED"))
                    self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "6", "authorization failed")
                end
            end
        end)
    end
end

function LoginGameView:loginLineWithAccessToken_(accessToken,mtkey)
    self:playLoginAnim()

    local params = self:getLoginBaseParams_()
    params.line_request = string.urlencode(accessToken)
    params.mtkey = mtkey or ""
    params.lid = 3

    self:loginGame_(params)
end

function LoginGameView:loginWithFacebook()
    if self:isLogining_() then
        return
    end

    self:setLoginType_("FACEBOOK")

    if tx.Facebook then
        tx.Facebook:login(function(success, result)
            logger:debug(success, result)
            if success then
                self:loginFacebookWithAccessToken_(result)
            else
                self.isLoginInProgress_ = -1
                if result == "canceled" then
                    tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "CANCELLED_MSG"))
                    self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "5", "authorization cancelled")
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_LOGIN_FACEBOOK"))
                    self:reportLoginResult_(tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE), "6", "authorization failed")
                end
            end
        end)
    end
end

function LoginGameView:loginFacebookWithAccessToken_(accessToken)
    self:playLoginAnim()
    tx.Facebook.setAccessToken(accessToken)
    tx.Facebook.getId(function(data)
        local idsTbl = json.decode(data)
        if type(idsTbl) == "table" and idsTbl.id then
            local id = idsTbl.id
            local mtkey = tx.userDefault:getStringForKey(tx.cookieKeys.LOGIN_MTKEY..id, "")
            self:loginFacebookWithAccessTokenAndMtkey_(accessToken, mtkey)
        else
            self:loginFacebookWithAccessTokenAndMtkey_(accessToken, "")
        end
    end, function()
        self:loginFacebookWithAccessTokenAndMtkey_(accessToken, "")
    end)
end

function LoginGameView:loginFacebookWithAccessTokenAndMtkey_(accessToken, mtkey)
    self.facebookAccessToken_ = accessToken
    tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_ACCESS_TOKEN, accessToken.."#"..mtkey)
    tx.userDefault:flush()

    local params = self:getLoginBaseParams_()
    params.signed_request = accessToken
    params.mtkey = mtkey
    params.lid = 1

    self:loginGame_(params)
end

function LoginGameView:checkAutoLogin()
    local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
    if lastLoginType == "GUEST" then
        self:loginWithGuest()
    elseif lastLoginType == "FACEBOOK" then
        local accessToken = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_ACCESS_TOKEN, "")
        if accessToken and accessToken ~= "" then
            local accessTokenTbl = string.split(accessToken, "#")
            if #accessTokenTbl > 1 and accessTokenTbl[2] then
                self:loginFacebookWithAccessTokenAndMtkey_(accessTokenTbl[1], accessTokenTbl[2])
            else
                self:loginFacebookWithAccessToken_(accessToken)
            end
        end
    elseif lastLoginType == "LINE" then
        local accessToken = tx.userDefault:getStringForKey(tx.cookieKeys.LINE_ACCESS_TOKEN, "")
        if accessToken and accessToken~="" then
            self:loginLineWithAccessToken_(accessToken)
        end
    end
end

function LoginGameView:setFacebookFriends_()
    -- 设置FB好友为牌友
    sa.HttpService.POST({mod="friend", act="setFriends", access_token=self.facebookAccessToken_},
        function(ret)
            print("set facebook friends ret -> ", ret)
        end,
        function()
            print("set facebook friends fail")
        end)

    -- update apprequest
    tx.Facebook:updateAppRequest()

    -- 上报能邀请的好友数量
    self:reportInvitableFriends_()

    -- facebook 保存mtkey用于快速登录
    tx.userDefault:setStringForKey(tx.cookieKeys.LOGIN_MTKEY..tx.userData.siteuid, tx.userData.mtkey or "")
    tx.userDefault:flush()
end

function LoginGameView:getEventNameByLoginType(loginType)
    local eventName
    if loginType == "FACEBOOK" then
        eventName = "login_result_facebook"
    elseif loginType == "GUEST" then
        eventName = "login_result_guest"
    elseif loginType == "LINE" then
        eventName = "login_result_line"
    end

    return eventName
end

-- 上报可邀请的好友数量
function LoginGameView:reportInvitableFriends_()
    if device.platform == "android" or device.platform == "ios" then
        local date = tx.userDefault:getStringForKey(tx.cookieKeys.DALIY_REPORT_INVITABLE)
        tx.Facebook:getInvitableFriends(300, function(success, friendData)
            if success then
                if date ~= os.date("%Y%m%d") then
                    local count = #friendData
                    tx.userDefault:setStringForKey(tx.cookieKeys.DALIY_REPORT_INVITABLE, os.date("%Y%m%d"))
                    -- 能够邀请的facebook好友数
                    cc.analytics:doCommand{
                        command = "eventCustom",
                        args = {
                            eventId = "invitable_facebook_friends",
                            attributes = "type,invitable",
                            counter = count
                        }
                    }

                    -- 已不能邀请好友的用户数
                    if count == 0 then
                        cc.analytics:doCommand{
                            command = "event",
                            args = {eventId = "disabled_invite_users",label = "disabled_invite_users"}
                        }
                    end
                end
            end
        end)
    end
end

function LoginGameView:setUserDataByLoginType(lastLoginType)
    self:reportLoginResult_(lastLoginType, "0", "login success")

    if lastLoginType ==  "FACEBOOK" then
        sa.HttpService.setDefaultParameter("lid", 1)
        tx.userData.lid = 1
        tx.userData.showRecall = true

        self:setFacebookFriends_()
    elseif lastLoginType == "GUEST" then
        sa.HttpService.setDefaultParameter("lid", 2)
        tx.userData.lid = 2
        tx.userData.showRecall = false
        tx.userData.canEditAvatar = true
    elseif lastLoginType == "LINE" then
        local vipLevel = 0
        if tx.userData.vipinfo then
            vipLevel = tonumber(tx.userData.vipinfo.level) or 0
        end
        if tx.LineSDK and tx.LineSDK.pictureUrl and vipLevel<1 then
            tx.userData.s_picture = tx.LineSDK.pictureUrl
            tx.userData.b_picture = tx.LineSDK.pictureUrl
            tx.userData.m_picture = tx.LineSDK.pictureUrl
        end
        tx.userDefault:setBoolForKey(tx.cookieKeys.IS_SHOW_LINE_REWARD, false)
        sa.HttpService.setDefaultParameter("lid", 3)
        tx.userData.lid = 3
        tx.userData.showRecall = false
        tx.userData.canEditGender = true  -- 编辑性别
    else
        sa.HttpService.setDefaultParameter("lid", 2)
        tx.userData.lid = 2
        tx.userData.showRecall = false
        tx.userData.canEditAvatar = true
    end
end

return LoginGameView
