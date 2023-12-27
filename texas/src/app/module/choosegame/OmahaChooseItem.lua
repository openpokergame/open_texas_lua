local TexasChooseItem = import(".TexasChooseItem")
local OmahaChooseItem = class("OmahaChooseItem", TexasChooseItem)
OmahaChooseItem.WIDTH = 80
OmahaChooseItem.HEIGHT = 420
OmahaChooseItem.ELEMENTS = {
	"img",
	"bg",
	"labelBlind",
	"iconPeaple",
	"labelPeaple",
	"labelTakeIn",
	"labelPlace",
	"labelName",
	"labelTips",
}

function OmahaChooseItem:ctor()
	local w, h = OmahaChooseItem.WIDTH, OmahaChooseItem.HEIGHT
	OmahaChooseItem.super.ctor(self, w, h)

	self.cityName_ = sa.LangUtil.getText("HALL", "OMAHA_ROOM_CITY_NAME")
	self.cityImgPre_ = "omaha_city_"
	self.maxIndex_ = 4
	self.levelLimit_ = tx.userData.omahaLevelLimit
end

return OmahaChooseItem