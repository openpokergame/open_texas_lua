local AdPluginAndroid = class("AdPluginAndroid")
local logger = sa.Logger.new("AdPluginAndroid")
function AdPluginAndroid:ctor()
    
end

function AdPluginAndroid:trackRevenue(revenue,currency)
    -- 一定要带上eventToken哦，唯一性 不能是事件名
    self:call_("trackRevenue", {revenue,currency,"5xs4z1"}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
end

-- end public function
function AdPluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/adjust/AdjustBridge", javaMethodName, javaParams, javaMethodSig)
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
        tx.schedulerPool:delayCall(function()
            
        end,0.2)
        return false, nil
    end
end

return AdPluginAndroid
