local AdPluginIos = class("AdPluginIos")
local logger = sa.Logger.new("AdPluginIos")
function AdPluginIos:ctor()
    -- luaoc.callStaticMethod("AdjustBridge", "initSDK", {appid=appconfig.RTCHAT_APPID,key=appconfig.RTCHAT_APPKEY,xunfei=XUNFEIID,url=UploadUrl})
    -- luaoc.callStaticMethod("AdjustBridge", "setStartRecordVoiceCallback", {listener = handler(self, self.onStartRecordVoiceResult_)})
    -- luaoc.callStaticMethod("AdjustBridge", "setStartPlayVoiceCallback", {listener = handler(self, self.onStartPlayVoiceResult_)})
    -- luaoc.callStaticMethod("AdjustBridge", "setStopPlayVoiceCallback", {listener = handler(self, self.onStopPlayVoiceResult_)})
    -- luaoc.callStaticMethod("AdjustBridge", "setRecordVoiceCompleteCallback", {listener = handler(self, self.onRecordVoiceCompleteResult_)})
end

function AdPluginIos:trackRevenue(revenue,currency)
	-- 一定要带上eventToken哦，唯一性 不能是事件名
	luaoc.callStaticMethod("AdjustBridge", "trackRevenue", {revenue=revenue,currency=currency,eventToken="5xs4z1"})
end

return AdPluginIos
