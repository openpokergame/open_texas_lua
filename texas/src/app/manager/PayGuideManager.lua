-- 支付引导管理，包含首充，破产，快捷支付等
local PayGuideManager = class("PayGuideManager")

local FirstPayPopup 		= import("app.module.payguide.firstpay.FirstPayPopup")
local QuickPayPopup 		= import("app.module.payguide.quickpay.QuickPayPopup")
local RoomQuickPayPopup 	= import("app.module.payguide.quickpay.RoomQuickPayPopup")
local StorePopup          	= import("app.module.store.StoreView")
local OfficialStorePopup  	= import("app.module.store.OfficialStorePopup")

--tx.userData.payStatus 0未付费 1已付费
function PayGuideManager:ctor()
end

--破产引导
function PayGuideManager:userCrashGuide(param)
	if tx.userData.payStatus == 0 then
		FirstPayPopup.new(true, param.gameId, param.blind):showPanel()
	else
		QuickPayPopup.new(true, param.gameId, param.blind):showPanel()
	end
end

--快捷支付
function PayGuideManager:quickPayGuide(gameId, blind)
	local curScene = display.getRunningScene()
	if tx.userData.payStatus == 0 then
		-- curScene:showFirstPayPopup()
		FirstPayPopup.new():showPanel()
	else
		curScene:showQuickPayPopup()
	end
end

--登录前三天，每天领完注册奖励主动弹首充海报一次，下次登录不再弹
function PayGuideManager:firstPayGuide()
	if tx.userData.payStatus == 0 then
		FirstPayPopup.new():showPanel()
	end
end

function PayGuideManager:openStore(goodsType, payType)
	if tx.userData.isThailand == 0 then
		OfficialStorePopup.new(goodsType):show()
	else
		StorePopup.new(goodsType, payType):show()
	end
end

return PayGuideManager