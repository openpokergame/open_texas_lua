local WelcomeScene = require("welcome.WelcomeScene")
local WelcomeController = class("WelcomeController")

function WelcomeController:ctor()
	if (device.platform == "android" or device.platform == "ios") and (ccexp.VideoPlayer) then
        self:showWelcomePage()
    else
        self:enterGame()
    end
end

function WelcomeController:showWelcomePage()
	self.scene_ = WelcomeScene.new(self)
    display.replaceScene(self.scene_)
    self.scene_:showWelcomePage()
end

function WelcomeController:enterGame()
	if not _G.IS_ENTER_APP_UPDATE_VIEW then
		_G.IS_ENTER_APP_UPDATE_VIEW = true
		require("update.UpdateController").new()
	end
end

return WelcomeController