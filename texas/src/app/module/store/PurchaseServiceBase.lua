local PurchaseServiceBase = class("PurchaseServiceBase")

function PurchaseServiceBase:ctor(name)
    self.logger = sa.Logger.new(name or "PurchaseServiceBase")
    self.schedulerPool_ = sa.SchedulerPool.new()
end

function PurchaseServiceBase:autoDispose()
    self.products_ = nil
    self.loadCallback_ = nil
    self.loadRequested_ = false
    self.purchaseCallback_ = nil
end

--callback(payType, isComplete, data)
-- function PurchaseServiceBase:setLoadedProductCallBack(callback)
--     callback(self.config_, true, sa.LangUtil.getText("STORE", "NO_PRODUCT_HINT")) 
-- end

function PurchaseServiceBase:setLoadedProductCallBack(callback)
    self.loadCallback_ = callback
    self.loadRequested_ = true
    self:loadProcess_()
end

function PurchaseServiceBase:createJavaMethodInvoker(javaClassName)
    if device.platform ~= "android" then
        self.logger:debugf("call %s failed, not in android platform", javaMethodName)
        return function()
            return false, nil
        end
    end
    return function(javaMethodName, javaParams, javaMethodSig)
        local ok, ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        if not ok then
            -- or math.abs(ret)
            local error_info = {
                [-1] = "-1 不支持的参数类型或返回值类型",
                [-2] = "-2 无效的签名"                ,
                [-3] = "-3 没有找到指定的方法"        ,
                [-4] = "-4 Java 方法执行时抛出了异常" ,
                [-5] = "-5 Java 虚拟机出错"           ,
                [-6] = "-6 Java 虚拟机出错"           ,
            }
            local e = error_info[ret] or 'unknown'
            self.logger:errorf('call %s failed, ' .. e, javaMethodName)
        end
        return ok, ret
    end
end

function PurchaseServiceBase:createOcMethodInvoker(className)
    if device.platform ~= "ios" then
        self.logger:debugf("call %s failed, not in ios platform", methodName)
        return function()
            return false, nil
        end
    end
    return function(methodName, params)
        local ok, ret = luaoc.callStaticMethod(className,methodName,params)
        if not ok then
            local error_info = {
                [-1] = "-1 INVALID PARAMETERS",
                [-2] = "-2 CLASS NOT FOUND"                ,
                [-3] = "-3 METHOD NOT FOUND"        ,
                [-4] = "-4 EXCEPTION OCCURRED" ,
                [-5] = "-5 INVALID METHOD SIGNATURE"           ,
            }
            local e = error_info[ret] or 'UNKNOWN'
            self.logger:errorf('call %s failed, ' .. e, methodName)
        end
        return ok, ret
    end
end

function PurchaseServiceBase:toptip(msg)
    tx.TopTipManager:showToast(msg)
end

return PurchaseServiceBase
