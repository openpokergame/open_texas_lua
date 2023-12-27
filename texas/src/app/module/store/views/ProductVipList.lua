local ProductVipList = class("ProductVipList",function()
    return display.newNode()
end)

local FIRST_ITEM_W, FIRST_ITEM_H--第一行宽高
local LAST_ITEM_H--最后一行高度
local ITEM_W, ITEM_H--其他每个item宽高
local POS_Y --每行信息坐标数组
local VIP_INFO_Y --vip开通信息坐标
local LEVEL_NAME

local VIP_NUM = 3
local VIP_ICONS = {
	"common/vip_level_icon_1.png",
	"common/vip_level_icon_2.png",
	"common/vip_level_icon_3.png",
	"common/vip_level_icon_4.png",
}

local VIP_COLOR = {
	cc.c3b(0x5d, 0xff, 0x70),
	cc.c3b(0x42, 0xde, 0xff),
	cc.c3b(0xc5, 0x72, 0xff),
	cc.c3b(0xff, 0x65, 0x3b),
}

function ProductVipList:ctor(delegate, w, h)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	self:setNodeEventEnabled(true)

	self.this_ = self

	self.delegate_ = delegate

	LEVEL_NAME = sa.LangUtil.getText("VIP", "LEVEL_NAME")

	local titleList = sa.LangUtil.getText("VIP", "LIST_TITLE")
	local row_num = #titleList
	FIRST_ITEM_W, FIRST_ITEM_H = w * 0.22, h * 0.13
	LAST_ITEM_H = h * 0.12
	ITEM_W, ITEM_H = (w - FIRST_ITEM_W) / VIP_NUM, (h - FIRST_ITEM_H - LAST_ITEM_H) / (row_num - 1)
	VIP_INFO_Y = h - FIRST_ITEM_H*0.85

	POS_Y = {}
	POS_Y[1] = LAST_ITEM_H*0.5
	for i = 2, row_num do
		POS_Y[i] = LAST_ITEM_H + (i - 1.5) * ITEM_H
	end

	self.isAddVipInfo_ = false

	--购买按钮
	self.buyBtnList_ = {}

	--续费按钮
	self.againBtnList_ = {}

	local bg = display.newNode()
		:size(w, h)
		:align(display.CENTER)
		:addTo(self)
	self.bg_ = bg

	local vipInfoX, vipInfoY = 10, VIP_INFO_Y
	self.openVip_ = display.newSprite()
		:align(display.LEFT_BOTTOM, vipInfoX, vipInfoY)
		:addTo(bg)

	self.vipDay_ = ui.newTTFLabel({text = "", size = 20})
		:align(display.LEFT_BOTTOM, vipInfoX + 65, vipInfoY + 8)
		:addTo(bg)

	local icon_y = h - FIRST_ITEM_H*0.5 + 8
	for i = 1, VIP_NUM do
		local x = FIRST_ITEM_W + ITEM_W * (i - 0.5)
		display.newSprite("#store/vip_light.png")
			:align(display.TOP_CENTER, x, h)
			:addTo(bg)

		display.newSprite("#" .. VIP_ICONS[i])
			:pos(x, icon_y)
			:addTo(bg)

		local label = ui.newTTFLabel({text = LEVEL_NAME[i], size = 18, color = VIP_COLOR[i]})
			:pos(x, icon_y - 43)
			:addTo(bg)
		sa.fitSprteWidth(label, ITEM_W-6)
	end

	local sx = w*0.5
	-- display.newScale9Sprite("#store/vip_item_bg.png", 0, 0, cc.size(w, LAST_ITEM_H))
	-- 	:pos(sx, POS_Y[1])
	-- 	:addTo(bg)
	
	for i = 1, row_num, 2 do
		display.newScale9Sprite("#store/vip_item_bg.png", 0, 0, cc.size(w, ITEM_H))
			:pos(sx, POS_Y[i])
			:addTo(bg)
	end

	for i = 1, VIP_NUM do
		display.newScale9Sprite("#store/line_division.png", FIRST_ITEM_W + ITEM_W * (i - 1), h/2, cc.size(h, 3))
			:rotation(90)
			:addTo(bg)
	end

	local color
	local sx = FIRST_ITEM_W * 0.5
	for i = 1, row_num do
		if i == 1 then
			color = cc.c3b(0xff, 0xff, 0xff)
		else
			color = cc.c3b(0x9b, 0xa9, 0xff)
		end

		local label = ui.newTTFLabel({text = titleList[i], size = 20, color = color})
			:pos(sx, POS_Y[i])
			:addTo(bg)
		sa.fitSprteWidth(label, FIRST_ITEM_W-6)
	end
end

function ProductVipList:addVipGoods_(level, data, x)
	local bg = self.bg_

	--立即开通
	local btn_w, btn_h = 190, 104
	local index = 1
	self.buyBtnList_[level] = cc.ui.UIPushButton.new({normal="#common/btn_small_green.png", pressed="#common/btn_small_green_down.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({size = 20, text = sa.LangUtil.getText("VIP", "OPEN_BTN", data.price)}))
        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
        :pos(x, POS_Y[index])
        :addTo(bg)
    self.buyBtnList_[level]:setTag(level)
    local label = self.buyBtnList_[level]:getButtonLabel("normal")
    sa.fitSprteWidth(label,145)

    --续费
    self.againBtnList_[level] = cc.ui.UIPushButton.new({normal="#common/btn_small_blue.png", pressed="#common/btn_small_blue_down.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({size = 20, text = sa.LangUtil.getText("VIP", "AGAIN_BTN", data.price)}))
        :onButtonClicked(buttontHandler(self, self.onAgainClicked_))
        :pos(x, POS_Y[index])
        :addTo(bg)
        :hide()
    self.againBtnList_[level]:setTag(level)
    local label = self.againBtnList_[level]:getButtonLabel("normal")
    sa.fitSprteWidth(label,145)

	-- --踢人卡
	-- index = index + 1
	-- display.newSprite("#store/vip_kick_card_icon.png")
	-- 	:pos(x - 14, POS_Y[index])
	-- 	:addTo(bg)

	-- local label = ui.newTTFLabel({text = "x" .. data.kickCard, size = 18})
	-- 	:pos(x + 32, POS_Y[index])
	-- 	:addTo(bg)
	-- local label = ui.newTTFLabel({text = sa.LangUtil.getText("MATCH", "EXPECT_TIPS"), size = 18})
	-- 	:pos(x, POS_Y[index])
	-- 	:addTo(bg)
	-- sa.fitSprteWidth(label,ITEM_W-6)

	
	local img = "#store/vip_icon_yes.png"
	for i = 1, 4 do
		index = index + 1
		display.newSprite(img)
			:pos(x, POS_Y[index])
			:addTo(bg)
	end

	-- index = index + 1
	-- local label = ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "PRIVATE_SALE", 100 - data.private*10), size = 18})
	-- 	:pos(x, POS_Y[index])
	-- 	:addTo(bg)
	-- sa.fitSprteWidth(label,ITEM_W-6)

	--破产优惠
	-- index = index + 1
	-- local str = sa.LangUtil.getText("VIP", "BROKE_REWARD", data.brokeSale, data.brokeTimes)
	-- local label = ui.newTTFLabel({text = str, size = 18})
	-- 	:pos(x, POS_Y[index])
	-- 	:addTo(bg)
	-- sa.fitSprteWidth(label,ITEM_W-6)

	--经验
	-- index = index + 1
	-- local label = ui.newTTFLabel({text = data.exp, size = 18})
	-- 	:pos(x, POS_Y[index])
	-- 	:addTo(bg)
	-- sa.fitSprteWidth(label,ITEM_W-6)

    --登录返还
    index = index + 1
    local loginreward = sa.formatBigNumber(data.loginreward)
	local label = ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "LOGINREWARD", loginreward), size = 26})
		:pos(x, POS_Y[index])
		:addTo(bg)
	sa.fitSprteWidth(label,ITEM_W-6)

	--筹码
	index = index + 1
	local label = ui.newTTFLabel({text = sa.formatBigNumber(data.chips), size = 26})
		:pos(x, POS_Y[index])
		:addTo(bg)
	sa.fitSprteWidth(label,ITEM_W-6)
end

--更新VIP是否开通信息
function ProductVipList:updateVipInfo_()
	local vipinfo = tx.userData.vipinfo
	local icon = ""
	local str = ""
	local offsetY = 0
	local color
	if vipinfo.level > 0 then
		icon = VIP_ICONS[vipinfo.level]
		str = sa.LangUtil.getText("VIP", "AVAILABLE_DAYS", vipinfo.day)
		offsetY = 2
		color = cc.c3b(0xfe, 0xe7, 0x80)

		self:updateBtnState_(vipinfo.level)
	else
		icon = "common/vip_level_icon_0.png"
		str = sa.LangUtil.getText("VIP", "NOT_VIP")
		offsetY = 8
		color = cc.c3b(0xc5, 0xc5, 0xc5)

		self.openVip_:scale(1)
	end

	self.openVip_:setSpriteFrame(icon)

	self.vipDay_:setPositionY(VIP_INFO_Y + offsetY)
	self.vipDay_:setTextColor(color)
	self.vipDay_:setString(str)
	sa.fitSprteWidth(self.vipDay_,FIRST_ITEM_W-78)

	local size = self.openVip_:getContentSize()
end

function ProductVipList:updateBtnState_(level)
	for i = 1, #self.data_ do
		if level == i then
			self.againBtnList_[i]:show()
			self.buyBtnList_[i]:hide()
		else
			self.againBtnList_[i]:hide()
			self.buyBtnList_[i]:show()
		end
	end
end

function ProductVipList:setData(data)
	data = data or {}
	if not self.isAddVipInfo_ then
		self.data_ = data
		self.isAddVipInfo_ = true
		for i = 1, #data do
			self:addVipGoods_(i, data[i], FIRST_ITEM_W + ITEM_W * (i - 0.5))
		end

		self:updateVipInfo_()
	end
end

function ProductVipList:getData()
	return self.data_
end

function ProductVipList:onBuyClicked_(event)
	local tag = event.target:getTag()
	local data = self.data_[tag]

	if tx.userData.diamonds < data.price then
		tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "BUY_FAILED_TIPS"))
		self.delegate_:showDiamondsGoodsView()
	else
		local level = tx.userData.vipinfo.level
		if level > 0 and level ~= tag then
			self:showMakePurchaseTips_(tag, sa.LangUtil.getText("VIP", "BUY_TIPS_2", LEVEL_NAME[level], LEVEL_NAME[level], LEVEL_NAME[tag]))
		else
			-- self:showMakePurchaseTips_(tag, sa.LangUtil.getText("VIP", "BUY_TIPS_1", LEVEL_NAME[tag], data.price))
			self:makePurchase_(tag)
		end
	end
end

function ProductVipList:onAgainClicked_(event)
	local tag = event.target:getTag()
	local data = self.data_[tag]

	if tx.userData.diamonds < data.price then
		tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "BUY_FAILED_TIPS"))
	else
		self:makePurchase_(tag)
	end
end

function ProductVipList:showMakePurchaseTips_(level, text)
	tx.ui.Dialog.new({
        messageText = text,
        firstBtnText = sa.LangUtil.getText("VIP", "CONTINUE_BUY"),
		secondBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
        callback = function(param)
            if param == tx.ui.Dialog.FIRST_BTN_CLICK then
                self:makePurchase_(level)
            end
        end
    }):show()
end

function ProductVipList:makePurchase_(level)
    sa.HttpService.POST({
        mod = "Vip",
        act = "buy",
        type=level
    },
    function(data)
        local tb = json.decode(data)
        if tb and tb.code == 1 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "BUY_SUCCESS"))
            local list = tb.list
            tx.userData.diamonds = tx.userData.diamonds - list.diamonds
            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={diamonds=(-list.diamonds)}})
            local vipinfo = tx.userData.vipinfo
            vipinfo.level = list.type
            vipinfo.day = list.day
            if self.this_ then
            	self:updateVipInfo_()
            end
        else
        	tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "BUY_FAILED"))
        end
    end,
    function()
        tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "BUY_FAILED"))
    end)
end

function ProductVipList:onCleanup()
 	self.this_ = nil
end

return ProductVipList