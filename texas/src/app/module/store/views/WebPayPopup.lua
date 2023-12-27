-- 网页购买弹窗
local WebDialog = require("app.pokerUI.WebDialog")
local WebPayPopup = class("WebPayPopup", WebDialog)

local POPUP_WIDTH = 815+60
local POPUP_HEIGHT = 712+60

-- url  payServices:Android要特殊实现
function WebPayPopup:ctor(url)
    self.url_ = url
	WebPayPopup.super.ctor(self,POPUP_WIDTH,POPUP_HEIGHT,sa.LangUtil.getText("COMMON", "BUY"),self.url_)
    self.paySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_SUCCESS,handler(self, self.onPaySuccess_))
end

function WebPayPopup:onPaySuccess_()
    self:hidePanel()
end

function WebPayPopup:showPanel()
    self:showPanel_(true, true, false, true)
    return self
end

function WebPayPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.paySuccessId_)
    WebPayPopup.super.onCleanup(self)
end

return WebPayPopup
