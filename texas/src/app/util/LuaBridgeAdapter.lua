local LuaBridgeAdapter = {}

local mtable = {
    __index = function(table, key)
        if LuaBridgeAdapter[key] then
            return LuaBridgeAdapter[key]
        else
            return function(...)
                local params = {...}
                for i, v in ipairs(params) do
                    params[i] = tostring(v)
                end
                print("CALL FUNCTION " .. key, unpack(params))
            end
        end
    end,
    __newindex = function(table, key, value)
        error("invalid set data to LuaBridgeAdapter")
    end
}

function LuaBridgeAdapter:getFixedWidthText(font, size, text, width)
    return sa.limitNickLength(text, 13)
end

function LuaBridgeAdapter:CheckPackageExist(packageName)
    return true
end

function LuaBridgeAdapter:checkPushEnabled()
    return true
end

function LuaBridgeAdapter:setPushEnabled()
end

function LuaBridgeAdapter:checkPushEnabled()
    return false
end

function LuaBridgeAdapter:setPushEnabled()
end

function LuaBridgeAdapter:requestStoragePermission()
end

function LuaBridgeAdapter:getLoginToken()
    local ok, local_uuid_string = pcall(require, 'app.util.PlayerUUID')
    if not ok then
        local_uuid_string = "1c:87:2c:ab:09:6b"
    end

    return crypto.encodeBase64(local_uuid_string .. "_openpokersec")
end

function LuaBridgeAdapter:pickImage(callback)
    callback(false, "error")
end

function LuaBridgeAdapter:getAppVersion()
    return "1.0.0"
end

function LuaBridgeAdapter:getChannelId()
    return "test"
end

function LuaBridgeAdapter:getDeviceInfo()
    return {
        location = "22.5700847444,113.9277961850",
        deviceId = "deviceId",
        deviceName = "deviceName",
        deviceModel = "deviceModel", 
        installInfo = "installInfo",
        cpuInfo = "cpuInfo",
        ramSize = "ramSize",
        simNum = "simNum",
        networkType = "networkType",
        location = "location"
    }
end

function LuaBridgeAdapter:getMacAddr()
    return "getMacAddr"
end

function LuaBridgeAdapter:getStartType()
    return -1
end
function LuaBridgeAdapter:getPushCode()
    return nil
end

function LuaBridgeAdapter:isAppInstalled(packageName)
    packageName = packageName or ""
    

    local packInfo = {}
    packInfo.flag = "true"
    packInfo.firstInstallTime = "1435561512693"
    packInfo.lastUpdateTime = "1435561512153"
    
    return false, packInfo
    
end

function LuaBridgeAdapter:launchApp(packageName)
    return true
end

function LuaBridgeAdapter:showLineView(content, callback)
    local result = "showLineView test"
    if callback then
        callback(result)
    end
end

return setmetatable({}, mtable)
