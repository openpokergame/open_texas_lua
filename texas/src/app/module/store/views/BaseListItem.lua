local BaseListItem = class("BaseListItem", sa.ui.ListItem)
local NetworkSprite = import("openpoker.ui.NetworkSprite")
local PURCHASE_TYPE = import("..PURCHASE_TYPE")

local ITEM_W, ITEM_H = display.width - 346, 350
local ITEM_NUM = 3

function BaseListItem:ctor()
	BaseListItem.super.ctor(self, ITEM_W, ITEM_H)

	self.items_ = {}
	self.title_ = {}
	self.icon_ = {}
	self.buyBtns_ = {}
	self.price_ = {}
	self.ratio_ = {}
	self.iconHot_ = {}
	self.sale_ = {}

	local w, h = 300, ITEM_H - 20 --每个子item宽高
	local dir = ITEM_W/ITEM_NUM
	local x = w*0.5
	
	local sx = dir*0.5
	for i = 1, ITEM_NUM do
		local bg = display.newScale9Sprite("#store/item_bg_1.png", 0, 0, cc.size(w, h))
			:pos(sx + dir * (i - 1), ITEM_H*0.5)
			:addTo(self)
		self.items_[i] = bg

		self.iconHot_[i] = display.newSprite("#store/icon_hot.png")
            :align(display.LEFT_TOP, -4, h + 4)
            :addTo(bg, 1)
            :hide()

        local icon_y = h*0.5 + 75
        display.newSprite("#store/item_bg_2.png")
            :pos(x, icon_y)
            :addTo(bg)

        self.icon_[i] = display.newSprite()
            :pos(x, icon_y + 5)
            :addTo(bg)

        self.sale_[i] = ui.newBMFontLabel({text = "", font = "fonts/shangcheng3.fnt"})
            :align(display.LEFT_CENTER, x + 30, 200)
            :addTo(bg)

        self.title_[i] = ui.newTTFLabel({text = "", size = 30})
            :pos(x,  165)
            :addTo(bg)
        sa.fitSprteWidth(self.title_[i], 260)

        self.ratio_[i] = ui.newTTFLabel({text = "", size = 26, color = cc.c3b(0x6f, 0xec, 0xff)})
            :pos(x,  110)
            :addTo(bg)
        sa.fitSprteWidth(self.ratio_[i], 260)

	    self.buyBtns_[i] = cc.ui.UIPushButton.new({normal = "#store/btn_buy.png", pressed = "#store/btn_buy_down.png"}, {scale9 = true})
	    	:setButtonSize(w, 80)
	    	:setButtonLabel(ui.newTTFLabel({text = "", size = 36}))
	        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
	        :pos(x, 40)
	        :addTo(bg, 1)
	    self.buyBtns_[i]:setTag(i)
        self.buyBtns_[i]:setTouchSwallowEnabled(false)

	    self.price_[i] = ui.newBMFontLabel({text = "", font = "fonts/shangcheng2.fnt"})
            :pos(x, 40)
            :addTo(bg)
            :hide()
	end
end

function BaseListItem:hideAllItems()
	for _, v in ipairs(self.items_) do
		v:hide()
	end
end

function BaseListItem:setGoodsImage()
	for i, v in ipairs(self.data_) do
		if v.gimg then
            local s = display.newSprite("#common/"..v.gimg)
            if not s then
                s = display.newSprite("#common/chips_1.png")
            end
            self.icon_[i]:setSpriteFrame(s:getSpriteFrame())
        end
	end
end

function BaseListItem:setGoodsImageOffset(offsetx, offsety)
	for _, v in ipairs(self.icon_) do
		local x, y = v:getPosition()
		v:pos(x + offsetx, y + offsety)
	end
end

function BaseListItem:setGoodsPrice(index, price, gchannel)
	self.buyBtns_[index]:setButtonLabelString("normal", price)
    self.price_[index]:setString(price)

    --显示按钮还是纯价格
    if self:isPayByCashcard_(tonumber(gchannel)) then
        self.buyBtns_[index]:hide()
        self.price_[index]:show()
    else
        self.buyBtns_[index]:show()
        self.price_[index]:hide()
    end
end

function BaseListItem:isPayByCashcard_(payType)
    return false
end

function BaseListItem:onBuyClicked_(event)
	local tag = event.target:getTag()
	local owner = self:getOwner()
    if owner.onItemClick then
        owner.onItemClick(self.data_[tag])
    end
end

return BaseListItem