local LinePluginAndroid = class("LinePluginAndroid")
local logger = sa.Logger.new("LinePluginAndroid")

function LinePluginAndroid:ctor()
    self.loginResultHandler_ = handler(self, self.onLoginResult_)
    self.shareResultHandler_ = handler(self, self.onShareResult_)

    self:call_("setLoginCallback", {self.loginResultHandler_}, "(I)V")
    self:call_("setShareResultCallback", {self.shareResultHandler_}, "(I)V")
end

function LinePluginAndroid:bindGuest(callback)
    self:login(callback)
end

function LinePluginAndroid:login(callback)
    self.loginCallback_ = callback
    self:call_("login", {}, "()V")
end

function LinePluginAndroid:logout()
    self:call_("logout", {}, "()V")
end

function LinePluginAndroid:share(params, callback)
    self.shareCallback_ = callback
    self:call_("share", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function LinePluginAndroid:onShareResult_(result)
    local success = (result ~= "failed" and result ~= "canceled")
    if result=="NoLineClient" then
        success = false
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "Line"))
    else
        if success then
            tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_SUCCESS"))
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
        end
    end
    if self.shareCallback_ then
        self.shareCallback_(success, result)
    end
    self.shareCallback_ = nil
end

function LinePluginAndroid:onLoginResult_(jsonData)
    logger:debugf("onLoginResult_ %s", jsonData)
    if self.loginCallback_ then
        local ret = json.decode(jsonData)
        local accessToken,userID,displayName,statusMessage,pictureUrl = nil,nil,nil,nil,nil
        self.pictureUrl = nil -- 头像PHP只会存一次
        if ret and ret.accessToken then
            accessToken,userID,displayName,statusMessage,pictureUrl = ret.accessToken,ret.userID,ret.displayName,ret.statusMessage,ret.pictureUrl
            self.pictureUrl = pictureUrl
            if self.pictureUrl and string.trim(self.pictureUrl)=="" then
                self.pictureUrl = nil
            end
        end
        local success = (accessToken ~= nil)
        self.loginCallback_(success, accessToken)
    end
    self.loginCallback_ = nil
end

function LinePluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" and appconfig.OPEN_LINE_LOGIN~=0 then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/line/LineBridge", javaMethodName, javaParams, javaMethodSig)
        if not ok then
            if ret == -1 then
                logger:errorf("call %s failed, -1 不支持的参数类型或返回值类型", javaMethodName)
            elseif ret == -2 then
                logger:errorf("call %s failed, -2 无效的签名", javaMethodName)
            elseif ret == -3 then
                logger:errorf("call %s failed, -3 没有找到指定的方法", javaMethodName)
            elseif ret == -4 then
                logger:errorf("call %s failed, -4 Java 方法执行时抛出了异常", javaMethodName)
            elseif ret == -5 then
                logger:errorf("call %s failed, -5 Java 虚拟机出错", javaMethodName)
            elseif ret == -6 then
                logger:errorf("call %s failed, -6 Java 虚拟机出错", javaMethodName)
            end
        end
        return ok, ret
    else
        logger:debugf("call %s failed, not in android platform", javaMethodName)
        if javaMethodName=="login" then
            self:onLoginResult_("")
        elseif javaMethodName=="share" then
            self:onShareResult_("NoLineClient")
        end
        return false, nil
    end
end

return LinePluginAndroid
