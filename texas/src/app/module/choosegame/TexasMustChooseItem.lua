local TexasChooseItem = import(".TexasChooseItem")
local TexasMustChooseItem = class("TexasMustChooseItem", TexasChooseItem)
TexasMustChooseItem.WIDTH = 80
TexasMustChooseItem.HEIGHT = 420
TexasMustChooseItem.ELEMENTS = {
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

function TexasMustChooseItem:ctor()
	local w, h = TexasMustChooseItem.WIDTH, TexasMustChooseItem.HEIGHT
	TexasMustChooseItem.super.ctor(self)

	self.cityName_ = sa.LangUtil.getText("HALL", "TEXAS_MUST_ROOM_CITY_NAME")	
	self.cityImgPre_ = "texas_must_city_"
	self.maxIndex_ = 4
	self.levelLimit_ = tx.userData.texasMustLevelLimit
end

function TexasMustChooseItem:onDataSet(dataChanged, data)
	TexasMustChooseItem.super.onDataSet(self, dataChanged, data)
	self.labelBlind:setString(sa.LangUtil.getText("HALL", "TEXAS_MUST_TITLE"))
	self.labelName:setString(sa.formatBigNumber(data.smallblind * 2))
end

return TexasMustChooseItem