local KaoPuPluginAndroid = class("KaoPuPluginAndroid")
local logger = sa.Logger.new("KaoPuPluginAndroid")

function KaoPuPluginAndroid:ctor()
    self:call_("setLoginCallback", {handler(self, self.onLoginResult_)}, "(I)V")
    self:call_("setExitGameCallback", {handler(self, self.onExitGameResult_)}, "(I)V")
end

function KaoPuPluginAndroid:initSDK()
    self:call_("initSDK", {}, "()V")
end

function KaoPuPluginAndroid:login(callback)
    self.loginCallback_ = callback
    self:call_("login", {}, "()V")
end

function KaoPuPluginAndroid:logout()
    self:call_("logout", {}, "()V")
end

function KaoPuPluginAndroid:exitGame()
    self:call_("exitGame", {}, "()V")
end

function KaoPuPluginAndroid:collectUserData(data, upLoadType)
    self:call_("collectUserData", {json.encode(data), upLoadType}, "(Ljava/lang/String;I)V")
end

function KaoPuPluginAndroid:onLoginResult_(result)
    logger:debugf("onLoginResult_ %s", result)
    local success = (result ~= "canceled" and result ~= "failed" and result ~= "AuthFailed")
    if self.loginCallback_ then
        self.loginCallback_(success, result)
    end
    self.loginCallback_ = nil
end

function KaoPuPluginAndroid:onExitGameResult_()
    tx.app:exit()
end

function KaoPuPluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/kaopu/KaoPuBridge", javaMethodName, javaParams, javaMethodSig)
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
        end
        return false, nil
    end
end

return KaoPuPluginAndroid
