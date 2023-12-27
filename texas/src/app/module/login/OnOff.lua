local OnOff = class("OnOff")
local logger = sa.Logger.new("OnOff")

function OnOff:ctor()
    self.onoff_ = {}
    self.version_ = {}
end

function OnOff:load(callBack)
    -- 添加回调
    self.loadCallback_ = callBack
    self.retryTimes_ = 3
    local loadAppOnOff
    loadAppOnOff = function()
         sa.HttpService.POST({
                mod="LoginSuc",
                act="getSwitchConfig",
            },
            function(retData)
                local retJson = json.decode(retData)
                if retJson and type(retJson)=="table" and retJson.code == 1 then
                    self.onoff_ = retJson.list
                    self.version_ = retJson.versionlist
                else
                    self.retryTimes_ = self.retryTimes_ - 1
                    if self.retryTimes_>0 then
                        loadAppOnOff()
                    elseif self.loadCallback_ then
                        self.loadCallback_()
                        self.loadCallback_ = nil
                    end
                end
            end,
            function()
                self.retryTimes_ = self.retryTimes_ - 1
                if self.retryTimes_>0 then
                    loadAppOnOff()
                elseif self.loadCallback_ then
                    self.loadCallback_()
                    self.loadCallback_ = nil
                end
            end)
    end
   loadAppOnOff()
end

function OnOff:check(name)
    return isset(self.onoff_, name) and tonumber(self.onoff_[name]) == 1
end

function OnOff:getConfig(name)
    local r
    r = self.onoff_[name]
    logger:debugf('getConfig %s = %s from OnOff: ', name, tostring(r))
    return r
end

function OnOff:checkVersion(name, version)
    return isset(self.version_, name) and self.version_[name] == version
end

return OnOff
