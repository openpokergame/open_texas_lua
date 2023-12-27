local PackageListItem = class("PackageListItem", sa.ui.ListItem)
local PackageDetailView = import(".PackageDetailView")

local BG_W, BG_H = 980, 280
local ITEM_W, ITEM_H = BG_W, BG_H + 8
local ITEM_NUM = 4
local FRAME_DIR = 240
local IMAGES = {
	"common/prop_hddj.png", --道具
	"common/prop_laba.png", --喇叭
	"common/prop_exchange.png", --兑换券
	"common/prop_gift.png", --礼品券
	"common/prop_ant.png", --开源币
}

PackageListItem.ROW_NUM = ITEM_NUM

function PackageListItem:ctor()
	PackageListItem.super.ctor(self, ITEM_W, ITEM_H)

	self.info_ = sa.LangUtil.getText("USERINFO", "PACKAGE_INFO")

	self.items_ = {}
	self.icon_ = {}
	self.numLabel_ = {}
	self.title_ = {}
	self.buyBtn_ = {}

	local w, h = 230, 278 --每个子item宽高
	local x = w*0.5
	
	for i = 1, ITEM_NUM do
		local bg = display.newScale9Sprite("#common/pop_list_item_bg.png", 0, 0, cc.size(w, h))
			:pos(130 + FRAME_DIR * (i - 1), ITEM_H*0.5)
			:addTo(self)
		self.items_[i] = bg

		self.icon_[i] = display.newSprite()
	        :pos(x, 190)
	        :addTo(bg)

	    local frame_w, frame_h = 90, 52
	    local numFrame = display.newScale9Sprite("#common/pop_prop_num_bg.png", 0, 0, cc.size(frame_w, frame_h), cc.rect(26, 25, 1, 1))
	        :pos(80, 140)
	        :addTo(bg)
	    
	    self.numLabel_[i] = ui.newTTFLabel({text = "", size = 24})
	        :pos(frame_w*0.5 - 2, frame_h*0.5 - 2)
	        :addTo(numFrame)

	    self.title_[i] = ui.newTTFLabel({text = "", size = 30})
	        :pos(x, 102)
	        :addTo(bg)

	   	local btn = cc.ui.UIPushButton.new({normal = "#common/prop_detail_normal.png", pressed = "#common/prop_detail_pressed.png"})
	        :onButtonClicked(buttontHandler(self, self.onDetailClicked_))
	        :pos(w - 25, h - 25)
	        :addTo(bg)
	    btn:setTag(i)
	    btn:setTouchSwallowEnabled(false)

	    self.buyBtn_[i] = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
	    	:setButtonSize(200, 104)
	        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
	        :setButtonLabel(ui.newTTFLabel({text = "", size = 24}))
	        :pos(x, 46)
	        :addTo(bg)
	    self.buyBtn_[i]:setTouchSwallowEnabled(false)
	end
end

function PackageListItem:onDataSet(dataChanged, data)
	self.data_ = data

	for i = 1, ITEM_NUM do
        self.items_[i]:hide()
    end

    for i, v in ipairs(data) do
    	self.items_[i]:show()

		local id = tonumber(v.id)
		self.icon_[i]:setSpriteFrame(IMAGES[id])

		self.numLabel_[i]:setString(v.count)

		self.title_[i]:setString(self.info_[id].title)
		
		local text = sa.LangUtil.getText("COMMON", "BUY")
		if id > 2 then
			text = sa.LangUtil.getText("STORE", "REAL_EXCHANGE_BTN")
			if not tx.OnOff:check("switch_real_store") then  -- 未开放
				self.items_[i]:hide()
			end
		end
		self.buyBtn_[i]:setButtonLabelString("normal", text)
		self.buyBtn_[i]:setTag(id)
    end
end

function PackageListItem:onDetailClicked_(evt)
	if self.owner_.tips then
        self.owner_.tips:stopAllActions()
        self.owner_.tips:removeFromParent()
        self.owner_.tips = nil
    end

    local tag = evt.target:getTag()
    local x, y = self.items_[tag]:getPosition()
    y = y + 40

    local direction = 2
    if tag == 1 then
    	direction = 1
    	x = x - 75
    elseif tag == ITEM_NUM then
    	direction = 3
    	x = x + 75
    end

    local id = self.data_[tag].id
    local params = {
	    direction = direction,
	    title = self.info_[id].title,
	    desc = self.info_[id].desc
	}
    local tips = PackageDetailView.new(params)
        :pos(x, y)
        :addTo(self)

    tips:runAction(transition.sequence({cc.DelayTime:create(2), cc.CallFunc:create(function() 
            tips:removeFromParent()
            self.owner_.tips = nil
        end)}))
    self.owner_.tips = tips
end

function PackageListItem:onBuyClicked_(event)
	local id = event.target:getTag()
	-- if id > 2 then
	-- 	StorePopup.new(nil, nil, id - 2):show()
	-- else
	-- 	StorePopup.new(3):show()
	-- end
	tx.PayGuideManager:openStore(3)
end

return PackageListItem