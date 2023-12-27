local ShareSDKPluginAndroid = class("ShareSDKPluginAndroid")
local logger = sa.Logger.new("ShareSDKPluginAndroid")
local SharePlatformPopup = import("app.module.share.SharePlatformPopup")

function ShareSDKPluginAndroid:ctor()
    self.shareFacebookResultHandler_ = handler(self, self.onShareFacebookResult_)
    self.shareTipsResultHandler_ = handler(self, self.onShareTipsResult_)

    self:call_("setShareFacebookCallback", {self.shareFacebookResultHandler_}, "(I)V")
    self:call_("setShareTipsCallback", {self.shareTipsResultHandler_}, "(I)V")
end

function ShareSDKPluginAndroid:shareFeed(params, callback)
    self.shareFeedCallback_ = callback
    self.sharePlatformPopup_ = SharePlatformPopup.new(params):showPanel()
end

function ShareSDKPluginAndroid:ShareBySystem(params)
    if tx.Facebook then
        tx.Facebook:ShareBySystem(params)
    end
end

function ShareSDKPluginAndroid:shareByFacebook(params)
	-- self:call_("shareByFacebook", {json.encode(params)}, "(Ljava/lang/String;)V")
    if tx.Facebook then
        tx.Facebook:shareFeed(params, self.shareFeedCallback_)
    end
end

function ShareSDKPluginAndroid:shareByTwitter(params)
	self:call_("shareByTwitter", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByShortMessage(params)
	self:call_("shareByShortMessage", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByCopy(params)
	self:call_("shareByCopy", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByLine(params)
	self:call_("shareByLine", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByWhatsApp(params)
	self:call_("shareByWhatsApp", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByFacebookMessenger(params)
	self:call_("shareByFacebookMessenger", {json.encode(params)}, "(Ljava/lang/String;)V")
end

function ShareSDKPluginAndroid:shareByVK(params)
    self:onShareTipsResult_("failed")    
end

function ShareSDKPluginAndroid:clearShareFeedCallback()
    self.shareFeedCallback_ = nil
end

function ShareSDKPluginAndroid:onShareFacebookResult_(result)
    logger:debugf("onShareFacebookResult_ %s", result)
    local success = (result ~= "canceled" and result ~= "failed")

    if success then
        sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.REPORT_FB_SHARE})
        -- tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_SUCCESS"))
        self:onSuccessCallback_()
    else
        -- tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    end

    if self.shareFeedCallback_ then
        self.shareFeedCallback_(success, result)
    end
end

function ShareSDKPluginAndroid:onShareTipsResult_(result)
    logger:debugf("onShareTipsResult_ %s", result)
    if result == "NoLineClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "Line"))
    elseif result == "NoInstagramClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "Instagram"))
    elseif result == "NoWhatsAppClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "WhatsApp"))
    elseif result == "NoFacebookMessengerClient" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "NO_CLIENT_TIPS", "FacebookMessenger"))
    elseif result == "shareByCopy" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "COPY_TIPS"))
    elseif result == "success" then
        -- tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_SUCCESS"))
        self:onSuccessCallback_()
    elseif result == "NetConnectFailed" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
    elseif result == "failed" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FEED", "SHARE_FAILED"))
    end
end

function ShareSDKPluginAndroid:onSuccessCallback_()
    if self.sharePlatformPopup_ then
        self.sharePlatformPopup_:hidePanel()
        self.sharePlatformPopup_ = nil
    end
end

function ShareSDKPluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/sharesdk/ShareSDKBridge", javaMethodName, javaParams, javaMethodSig)
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
        return false, nil
    end
end

return ShareSDKPluginAndroid
