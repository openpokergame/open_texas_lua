local appconfig = {}
-- 设置语言
appconfig.setLang = function()
	-- 获取完整语言 带地区hant hans
	local wholeLang = nil
	if device.platform == "android" then
		local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/core/functions/GetSysLanguageFunction", "apply", {}, "()Ljava/lang/String;")
		wholeLang = ret
	elseif device.platform == "ios" then
		local ok, ret = luaoc.callStaticMethod("LuaOCBridge", "getSysLanguage")
		wholeLang = ret
	end

	if wholeLang and wholeLang~="" then
		appconfig.COUNTRY = string.split(wholeLang, ",")[2]
	end

	local lang = "th"
	local catchL = cc.UserDefault:getInstance():getStringForKey("CUR_LANGUAGE", "")
	if catchL and catchL~="" then
		lang = catchL
	else
		lang = cc.Application:getInstance():getCurrentLanguageCode()
		lang = string.lower(lang)
		
		if lang=="zh" and wholeLang and wholeLang~="" then
			wholeLang = string.lower(wholeLang)
			if string.find(wholeLang,"hant") or string.find(wholeLang,"tw") or string.find(wholeLang,"hk") or string.find(wholeLang,"mo") then
				lang = "tw"
				-- 设置地区
				local region = nil
				if string.find(wholeLang,"tw") then
					region = "tw"
				elseif string.find(wholeLang,"hk") then
					region = "hk"
				elseif string.find(wholeLang,"mo") then
					region = "mo"
				end
				if region then
					cc.UserDefault:getInstance():setStringForKey("CUR_LANGUAGE_REGION", region)
				end
			end
		end
	end
	if lang then
		lang = string.lower(lang)
	end

	if lang=="th" then
		appconfig.LANG               = "th"
		appconfig.LANG_FILE_NAME     = "lang_th"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang_th"
	elseif lang=="tw" then
		appconfig.LANG               = "tw"
		appconfig.LANG_FILE_NAME     = "lang_tw"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang_tw"
	elseif lang=="id" then
		appconfig.LANG               = "id"
		appconfig.LANG_FILE_NAME     = "lang_id"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang_id"
	elseif lang=="zh" then
		appconfig.LANG               = "zh"
		appconfig.LANG_FILE_NAME     = "lang"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang"
	elseif lang=="ru" then
		appconfig.LANG               = "ru"
		appconfig.LANG_FILE_NAME     = "lang_ru"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang_ru"
	else
		appconfig.LANG               = "en"
		appconfig.LANG_FILE_NAME     = "lang_en"
		appconfig.UPD_LANG_FILE_NAME = "update.updateLang_en"
	end
	-- 资源图片搜索路径
	if _G.autoSearchPath then
		cc.FileUtils:getInstance():setSearchPaths(_G.autoSearchPath)
		cc.FileUtils:getInstance():addSearchPath("res/"..appconfig.LANG.."/")
		cc.FileUtils:getInstance():addSearchPath("res/")
	end
end
appconfig.all_lang = {
	{index = 5, icon = "dialogs/setting/language_5.png", lang = "English", langCode="en"},
	{index = 4, icon = "dialogs/setting/language_4.png", lang = "ภาษาไทย", langCode="th"},
	{index = 2, icon = "dialogs/setting/language_2.png", lang = "繁體香港", langCode="tw", region="hk"},
	{index = 7, icon = "dialogs/setting/language_7.png", lang = "繁體台灣", langCode="tw", region="tw"},
	{index = 8, icon = "dialogs/setting/language_8.png", lang = "繁體澳門", langCode="tw", region="mo"},
	{index = 9, icon = "dialogs/setting/language_10.png", lang = "Indonesia", langCode="id"},
	{index = 10, icon = "dialogs/setting/language_11.png", lang = "Россия", langCode="ru"},
	{index = 1, icon = "dialogs/setting/language_1.png", lang = "简体中文", langCode="zh"},
}
appconfig.setLang()

appconfig.SID                = {ANDROID  = 3, IOS = 4, WINDOWS = 3}
-- 登录
appconfig.LOGIN_SERVER_URL            = "http://api.110x.com:10086/api/login.php?demo=1"
appconfig.LOGIN_SERVER_URL            = "http://api.110x.com:10086/api/login.php"
-- 反馈
appconfig.FEEDBACK_IMG_URL            = "http://api.110x.com:10086/api/userfeedback.php"
appconfig.FEEDBACK_CONTENT_URL        = "http://api.110x.com:10086/api/feedback.php"
-- 更新
appconfig.VERSION_CHECK_URL           = "http://api.110x.com:10086/api/compareversion.php"
appconfig.UPDATE_RESOURCE_URL_IOS     = "http://api.110x.com:10086/static/hotFixIOS/"
appconfig.UPDATE_RESOURCE_URL_ANDROID = "http://api.110x.com:10086/static/hotFix/"
appconfig.UMENG_APPKEY_ANDROID        = "654e5664b2f6fa00ba7c6241"
appconfig.UMENG_APPKEY_IOS            = "654e57ba58a9eb5b0a068ec5"
-- 破产
appconfig.CRASHMONEY            	  = 10000

--RTChat
appconfig.RTCHAT_APPID				  = "2699273700b7c842"
appconfig.RTCHAT_APPKEY				  = "d0aa22ec04659331882d1f5b56998986f91fe1afef23a3739178835f84199a52"

--分享
appconfig.SAHRE_URL					  = "http://api.110x.com:10086/m/share.php?lang=tw&gameName=texas"
appconfig.INVITE_GIFT_URL			  = "http://api.110x.com:10086/m/gift.php?lang=tw&gameName=texas"
appconfig.FEED_PIC_URL			  	  = "http://api.110x.com:10086/img/feed/"
--粉丝页
appconfig.FANS_URL					  = "https://www.facebook.com/openpokergame"
appconfig.APP_FANS_URL				  = "fb://page/166437253218042"
--游戏隐私权政策
appconfig.POLICY_URL				  = "http://www.openpokergame.net/privacy.html"
return appconfig
