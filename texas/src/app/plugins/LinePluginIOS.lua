local LinePluginIOS = class("LinePluginIOS")
local logger = sa.Logger.new("LinePluginIOS")

function LinePluginIOS:ctor()
    luaoc.callStaticMethod("LineBridge", "initSDK")
end

function LinePluginIOS:bindGuest(callback)
    self:login(callback)
end

function LinePluginIOS:login(callback)
    self.loginCallback_ = callback
    luaoc.callStaticMethod("LineBridge", "login", {listener = handler(self, self.onLoginResult_)})
end

function LinePluginIOS:onLoginResult_(jsonData, errorInfo)
    if errorInfo then
        logger:error('Line iOS login errorInfo: ', errorInfo)
    end
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

function LinePluginIOS:logout()
    luaoc.callStaticMethod("LineBridge", "logout")
end

function LinePluginIOS:share(args, callback)
    self.shareCallback_ = callback
    args.listener = handler(self, self.onShareResult_)
    luaoc.callStaticMethod("LineBridge", "share", args);
end


function LinePluginIOS:onShareResult_(result)
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

return LinePluginIOS
