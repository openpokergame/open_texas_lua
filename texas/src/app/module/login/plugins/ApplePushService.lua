local ApplePushService = class("ApplePushService")

function ApplePushService:ctor()
    self.isSetPushCallBack_ = false
end

--- 注册回调来获取push token
function ApplePushService:register(callback)
    assert(callback, 'callback is nil')
    local ok, pushToken = luaoc.callStaticMethod("LuaOCBridge", "getPushToken")
    if ok then
        if pushToken and pushToken ~= "" then
            pushToken = string.gsub(pushToken, " ", "")
            pushToken = string.gsub(pushToken, "<", "")
            pushToken = string.gsub(pushToken, ">", "")
            callback(true, pushToken)
        else
            print "[LuaOCBridge getPushToken] return ''"
            callback(false, '')
        end
    else
        print('call [LuaOCBridge getPushToken] error')
    end
end

--- 添加本地通知消息
function ApplePushService:addLocalNotification(seconds, message)
    local ok = luaoc.callStaticMethod('LuaOCBridge', 'addLocalNotification', {
        seconds = seconds,
        message = message,
    })
    if not ok then print 'iOS addLocalNotification failed' end
end

-- IOS先回到引擎后才在原生处理推送的回调信息 启动后需要原生回调
function ApplePushService:onHandlerPushData_(pushData)
    local curScene = display.getRunningScene()
    if curScene and curScene.parsePushData then  -- 重新调用一次
        curScene:parsePushData()
    end
end

function ApplePushService:getPushData()
    if self.isSetPushCallBack_==false then
        self.isSetPushCallBack_ = true
        luaoc.callStaticMethod("LuaOCBridge", "setPushCallBack",{listener = handler(self, self.onHandlerPushData_)})
    end
    local ok, ret = luaoc.callStaticMethod("LuaOCBridge", "getPushData")
    if ok then
        return ret
    end
    return nil
end

return ApplePushService
