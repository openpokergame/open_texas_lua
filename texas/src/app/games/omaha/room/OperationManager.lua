local OperationButton = import("app.games.texas.room.views.OperationButton")
local OperationManager = import("app.games.texas.room.OperationManager")
local OmahaOperationManager = class("OmahaOperationManager", OperationManager)

function OmahaOperationManager:ctor()
    OmahaOperationManager.super.ctor(self)

    self.handCardNum_ = 4

    self.showCardBtnPos_ = {
	    {x = -25-35, y = -39},
	    {x = 15-35, y = -39},
	    {x = 55-35, y = -39},
	    {x = 95-35, y = -39},
	}
end

return OmahaOperationManager