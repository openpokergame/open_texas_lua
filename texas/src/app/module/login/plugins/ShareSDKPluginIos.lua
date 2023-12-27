local ShareSDKPluginIos = class("ShareSDKPluginIos")
local logger = sa.Logger.new("ShareSDKPluginIos")
local SharePlatformPopup = import("app.module.share.SharePlatformPopup")

function ShareSDKPluginIos:ctor()
    self.shareFacebookResultHandler_ = handler(self, self.onShareFacebookResult_)
    self.shareTipsResultHandler_ = handler(self, self.onShareTipsResult_)
end

function ShareSDKPluginIos:shareFeed(params, callback)
    self.shareFeedCallback_ = callback
    self.sharePlatformPopup_ = SharePlatformPopup.new(params):showPanel()
end

function ShareSDKPluginIos:ShareBySystem(params)
    local shareData = params
    shareData = params
    shareData.picture = ""
    shareData.link = sa.LangUtil.getText("COMMON", "CHECK") .. ": " .. sa.LangUtil.getText("FEED", "SHARE_LINK")
    luaoc.callStaticMethod("LuaOCBridge", "shareText", shareData)
    -- tx.Facebook:ShareBySystem(params)
end

function ShareSDKPluginIos:shareByFacebook(params)
    params.listener = self.shareFacebookResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByFacebook", params)
end

function ShareSDKPluginIos:shareByTwitter(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByTwitter", params)
end

function ShareSDKPluginIos:shareByShortMessage(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByShortMessage", params)
end

function ShareSDKPluginIos:shareByCopy(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByCopy", params)
end

function ShareSDKPluginIos:shareByLine(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByLine", params)
end

function ShareSDKPluginIos:shareByWhatsApp(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByWhatsApp", params)
end

function ShareSDKPluginIos:shareByFacebookMessenger(params)
    params.listener = self.shareTipsResultHandler_
    luaoc.callStaticMethod("ShareSDKBridge", "shareByFacebookMessenger", params)
end

function ShareSDKPluginIos:shareByVK(params)
    self:onShareTipsResult_("failed")    
end

function ShareSDKPluginIos:onShareFacebookResult_(result)
    logger:debugf("onShareFacebookResult_ %s", result)
    local success = (result ~= "canceled" and result ~= "failed")

    if success then
        sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.REPORT_FB_SHARE})
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_SUCCESS"))
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    end

    if self.shareFeedCallback_ then
        self.shareFeedCallback_(success, result)
    end
end

function ShareSDKPluginIos:clearShareFeedCallback()
    self.shareFeedCallback_ = nil
end

function ShareSDKPluginIos:onShareTipsResult_(result)
    logger:debugf("onShareTipsResult_ %s", result)
    if result == "NoLineClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "Line"))
    elseif result == "NoInstagramClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "Instagram"))
    elseif result == "NoWhatsAppClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "WhatsApp"))
    elseif result == "NoFacebookMessengerClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "FacebookMessenger"))
    elseif result == "NetConnectFailed" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
    elseif result == "shareByCopy" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "COPY_TIPS"))
    elseif result == "success" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_SUCCESS"))
        self:onSuccessCallback_()
    elseif result == "canceled" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    elseif result == "failed" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    end
end

function ShareSDKPluginIos:onSuccessCallback_()
    if self.sharePlatformPopup_ then
        self.sharePlatformPopup_:hidePanel()
        self.sharePlatformPopup_ = nil
    end
end

return ShareSDKPluginIos
