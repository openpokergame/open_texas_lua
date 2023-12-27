local HuaWeiGamePluginAndroid = class("HuaWeiGamePluginAndroid")
local logger = sa.Logger.new("HuaWeiGamePluginAndroid")

function HuaWeiGamePluginAndroid:ctor()
    self:call_("setLoginCallback", {handler(self, self.onLoginResult_)}, "(I)V")
    self:call_("setGameResumeOrExitCallback", {handler(self, self.onGameResumeOrExitResult_)}, "(I)V")
end

function HuaWeiGamePluginAndroid:login(callback)
    self.loginCallback_ = callback
    self:call_("login", {}, "()V")
end

function HuaWeiGamePluginAndroid:logout()
    self:call_("logout", {}, "()V")
end

function HuaWeiGamePluginAndroid:gameResumeOrExit()
    self:call_("gameResumeOrExit", {}, "()V")
end

function HuaWeiGamePluginAndroid:onLoginResult_(result)
    logger:debugf("onLoginResult_ %s", result)
    local success = (result ~= "canceled" and result ~= "failed")
    if self.loginCallback_ then
        self.loginCallback_(success, result)
    end
    self.loginCallback_ = nil
end

function HuaWeiGamePluginAndroid:onGameResumeOrExitResult_()
    tx.app:exit()
end

function HuaWeiGamePluginAndroid:isInitComplete()
    local success, ret = self:call_("isInitComplete", {}, "()Z")

    if success then
        return ret
    end
    
    return false
end

function HuaWeiGamePluginAndroid:setDebugMode(enable)
    self:call_("setDebugMode", {enable}, "(Z)V")
end

function HuaWeiGamePluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/hwgame/HuaWeiGameBridge", javaMethodName, javaParams, javaMethodSig)
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

return HuaWeiGamePluginAndroid
