local UniversalPushApi
if device.platform == "android" then
    -- UniversalPushApi = import(".XinGePushAndroid")
    UniversalPushApi = import(".FCMPluginAndroid")
elseif device.platform == "ios" then
    UniversalPushApi = import(".ApplePushService")
end

return UniversalPushApi
