local ChooseLevelItem = class("ChooseLevelItem", sa.ui.ListItem)
ChooseLevelItem.WIDTH = 312
ChooseLevelItem.HEIGHT = 510
ChooseLevelItem.CURTYPE = 1
ChooseLevelItem.ELEMENTS = {
	"numNode.iconNum",
	"numNode.labelNum",
	"contentNode.bg",
	"contentNode.labelMaxAnte",
	"contentNode.icon",
	"contentNode.labelBlindInfo",
	"contentNode.labelAnteInfo",
	"contentNode.labelPlace",
	"contentNode.labelName",
}
local ICON_IMAGE = {
	"omaha/hall/room_icon_1.png",
	"omaha/hall/room_icon_2.png",
	"omaha/hall/room_icon_3.png",
	"omaha/hall/room_icon_4.png",
	"omaha/hall/room_icon_5.png",
	"omaha/hall/room_icon_6.png",
}
local BG_IMAGE = {
	"omaha/hall/room_item_1.png",
	"omaha/hall/room_item_2.png",
	"omaha/hall/room_item_3.png",
	"omaha/hall/room_item_1.png",
	"omaha/hall/room_item_2.png",
	"omaha/hall/room_item_3.png",
}

function ChooseLevelItem:ctor()
	self:setNodeEventEnabled(true)
	ChooseLevelItem.super.ctor(self, ChooseLevelItem.WIDTH, ChooseLevelItem.HEIGHT)
	tx.ui.EditPanel.bindElementsToTarget(self,"omaha_hall_item.csb",true)

	ScaleButton(self.contentNode,0.95):onButtonClicked(function()
      	tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
      	local list = self:getOwner()
    	if list.onItemClickListener then
        	list.onItemClickListener(self.data_)
    	end
 	end)
 	self.contentNode:setTouchSwallowEnabled(false)
end

function ChooseLevelItem:onDataSet(dataChanged, data)
	self.data_ = data
    if self.data_ then
	  	local idx = data.index or self:getIndex()
	  	if idx > 6 then
	  		idx = 6
	  	end

	  	self.contentNode.bg:setSpriteFrame(BG_IMAGE[idx])
	  	self.contentNode.icon:setSpriteFrame(ICON_IMAGE[idx])

	  	local icon_w = self.numNode.iconNum:getContentSize().width
	  	self.numNode.labelNum:setString(data.online)
	  	local size = self.numNode.labelNum:getContentSize()
	  	local x = -(icon_w + size.width + 5)*0.5

	  	self.numNode.iconNum:setPositionX(x)
	  	self.numNode.labelNum:setPositionX(x + icon_w + 5)

	  	self.contentNode.labelMaxAnte:setString("S" .. sa.formatBigNumber(data.max_ante))

	  	local minBlind = sa.formatBigNumber(data.smallblind)
	  	local maxBlind = sa.formatBigNumber(data.smallblind * 2)
	  	self.contentNode.labelBlindInfo:setString(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_BLIND", minBlind, maxBlind))

	  	local minAnte = sa.formatBigNumber(data.min_ante)
	  	local maxAnte = sa.formatBigNumber(data.max_ante)
	  	self.contentNode.labelAnteInfo:setString(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_MIN_MAX_ANTE", minAnte, maxAnte))
    end
end

function ChooseLevelItem:onCleanup()
end

return ChooseLevelItem