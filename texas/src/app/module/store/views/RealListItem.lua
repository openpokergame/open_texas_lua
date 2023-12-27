local RealListItem = class("RealListItem", sa.ui.ListItem)
local NetworkSprite = import("openpoker.ui.NetworkSprite")

local ITEM_W, ITEM_H = 980, 404
local ITEM_NUM = 3
local IMAGES = {
	"common/prop_hddj.png",
	"common/prop_laba.png",
	"common/prop_exchange.png",
	"common/prop_gift.png",
	"common/prop_ant.png",
}

RealListItem.ROW_NUM = ITEM_NUM
RealListItem.WIDTH = ITEM_W

function RealListItem:ctor()
	ITEM_W = RealListItem.WIDTH

	RealListItem.super.ctor(self, ITEM_W, ITEM_H)

	self.price_ = sa.LangUtil.getText("STORE","REAL_TAB_LIST")
	self.items_ = {}
	self.title_ = {}
	self.priceLabel_ = {}
	self.icon_ = {}
	self.buyBtns_ = {}

	local w, h = 305, ITEM_H --每个子item宽高
	local dir = ITEM_W/ITEM_NUM
	local x = w*0.5
	
	local sx = dir*0.5
	for i = 1, ITEM_NUM do
		local bg = display.newScale9Sprite("#store/real_item_frame.png", 0, 0, cc.size(w, h))
			:pos(sx + dir * (i - 1), ITEM_H*0.5)
			:addTo(self)
		self.items_[i] = bg

		local label_y = h - 45
	    self.title_[i] = ui.newTTFLabel({text = "", size = 30})
	        :pos(x, label_y)
	        :addTo(bg)

	    self.priceLabel_[i] = ui.newTTFLabel({text = "", size = 24, color = cc.c3b(0xff, 0xe3, 0x62)})
	        :pos(x, label_y - 35)
	        :addTo(bg)

	    local icon_y = h*0.5 + 10
	    display.newSprite("#store/real_light_2.png")
	        :pos(x, icon_y + 10)
	        :addTo(bg)

	    display.newSprite("#store/real_light_1.png")
	        :pos(x, icon_y - 85)
	        :addTo(bg)

	    self.icon_[i] = NetworkSprite.new()
	        :pos(x, icon_y)
	        :addTo(bg)

	    self.buyBtns_[i] = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
	    	:setButtonSize(240, 104)
	        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
	        :setButtonEnabled(false)
	        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("STORE", "REAL_EXCHANGE_BTN"), size = 24}))
	        :pos(x, 64)
	        :addTo(bg)
	    self.buyBtns_[i]:setTag(i)
	    local label = self.buyBtns_[i]:getButtonLabel("normal")
	    sa.fitSprteWidth(label,190)
	end
end

function RealListItem:onDataSet(dataChanged, data)
	self.data_ = data

	local len = #data
	for i = 1, ITEM_NUM do
        self.items_[i]:hide()
    end

    for i, v in ipairs(data) do
    	self.items_[i]:show()
    	self.title_[i]:setString(v.name)
    	v.price = self.price_[v.coupon] .. "x".. v.num
		self.priceLabel_[i]:setString(v.price)
		sa.fitSprteWidth(self.title_[i], 260)
		sa.fitSprteWidth(self.priceLabel_[i], 260)
		self.icon_[i]:loadAndCacheImage(v.img)
		if v.buy == 1 then
			self.buyBtns_[i]:setButtonEnabled(true)
		else
			self.buyBtns_[i]:setButtonEnabled(false)
		end
    end
end

function RealListItem:onBuyClicked_(event)
	local tag = event.target:getTag()
	local owner = self:getOwner()
    if owner.onItemClick then
        owner.onItemClick(self.data_[tag])
    end
end

return RealListItem