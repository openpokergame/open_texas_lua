-- add init_ex code
-- 原生桥接
if device.platform == "android" then
	tx.AdvertSDK = import("app.plugins.AdPluginAndroid").new()
	tx.Facebook = import("app.module.login.plugins.FacebookPluginAndroid").new()
    tx.LineSDK = import("app.plugins.LinePluginAndroid").new()
elseif device.platform == "ios" then
	tx.AdvertSDK = import("app.plugins.AdPluginIos").new()
	tx.Facebook = import("app.module.login.plugins.FacebookPluginIos").new()
    tx.LineSDK = import("app.plugins.LinePluginIOS").new()
end
