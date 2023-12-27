-- 首冲礼包弹窗
local FirstPayPopup = class("FirstPayPopup", function()
    return display.newNode()
end)

local PayPopupController = import("..PayPopupController")
local FirstPayUserCrash = import("..usercrash.FirstPayUserCrash")

local WIDTH, HEIGHT = 912, 454
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5
local FONT = {
    "fonts/shouchong6.fnt",
    "fonts/shouchong5.fnt"
}
local TEXT_COLOR = {
    cc.c3b(0xee, 0xff, 0xff),
    cc.c3b(0xf8, 0xe8, 0x55)
}
local OFFSET_Y = {15, 53}

function FirstPayPopup:ctor(isCarsh, gameId, blind)
    self:setNodeEventEnabled(true)

    self.isCarsh_ = isCarsh
    self.gameId_ = gameId
    self.blind_ = blind
    self.isShowCarsh_ = true

    local bg = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)
    self.background_ = bg

    display.newSprite("img/first_pay_bg.png")
        :pos(C_X, C_Y)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "img/first_close.png", pressed = "img/first_close_down.png"})
        :onButtonClicked(buttontHandler(self, self.hidePanel))
        :pos(WIDTH - 10, HEIGHT - 80)
        :addTo(bg)

    self.controller_ = PayPopupController.new(self)
    if isCarsh then
        self.controller_:checkUserCrash(gameId, blind)
    else
        self.controller_:getFirstGoodsConfig()
    end

    self.firstPaySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_FIRST_PAY_SUCCESS, function()
        self.isShowCarsh_ = false
        self:hidePanel()
    end)
end

function FirstPayPopup:addMainUI(goods, carshChips, isSponsorChips)
    self.goodsData_ = goods
    if carshChips <= 0 then
        self.isShowCarsh_ = false
    end

    -- if isSponsorChips == 1 then
    --     self.isSponsorChips_ = true
    -- end

    local bg = self.background_
    display.newSprite("#dialogs/aboutpay/first_pay_chip.png")
        :pos(C_X - 15, C_Y + 20)
        :addTo(bg)

    local label_x, label_y = C_X + 180, C_Y + 70
    self:createPriceNode_(1, label_x, label_y, goods.originalPriceNum)
    self:createPriceNode_(2, label_x, label_y - 100, goods.priceNum)
    
    local money = sa.formatNumberWithSplit(goods.riseMoney_)
    ui.newTTFLabel({text = sa.LangUtil.getText("STORE","FORMAT_CHIP", money), size = 36})
        :pos(C_X + 275, C_Y - 50)
        :addTo(bg)

    local btn_w, btn_h = 274, 92
    local btn = sp.SkeletonAnimation:create("spine/first_pay_btn.json","spine/first_pay_btn.atlas")
        :size(btn_w, btn_h)
        :align(display.CENTER, C_X + 275, 100)
        :addTo(bg)
    self.buyBtn_ = btn

    btn:setAnimation(0, 1, true)
    ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onBuyClicked_))

    display.newSprite("#lang/first_pay_price_2.png")
        :pos(btn_w*0.5, btn_h*0.5)
        :addTo(btn)
end

function FirstPayPopup:createPriceNode_(index, x, y, priceNum)
    local node = display.newNode()
        :pos(x, y)
        :addTo(self.background_)

    local label = ui.newTTFLabel({text = self.goodsData_.priceDollar, size = 40, color = TEXT_COLOR[index]})
        :align(display.LEFT_BOTTOM, 0, 0)
        :addTo(node)

    local size = label:getContentSize()
    local w = size.width + 5
    label = ui.newBMFontLabel({text = priceNum, font = FONT[index]})
        :align(display.LEFT_BOTTOM, size.width + 5, OFFSET_Y[index])
        :addTo(node)

    size = label:getContentSize()
    w = w + size.width + 20
    if index == 1 then
        display.newScale9Sprite("#common/chips_sale_line_2.png", 0, 0, cc.size(w, 6))
            :rotation(-2)
            :pos(w*0.5, 30)
            :addTo(node)
    end
end

function FirstPayPopup:onBuyClicked_()
    _G.buyFromScene = 4

    self.buyBtn_:setButtonEnabled(false)
    self:schedule(function()
        self.buyBtn_:setButtonEnabled(true)
    end, 5)
    self.controller_:makePurchase(self.goodsData_)
end

function FirstPayPopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(60, 0)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function FirstPayPopup:showPanel()
    tx.PopupManager:addPopup(self, true, true, false)
end

function FirstPayPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function FirstPayPopup:onShowed()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "first_pay_click", label = "first_pay_click"}
        }
    end
end

function FirstPayPopup:onRemovePopup(removeFunc)
    if self.closeCallback_ then
        self.closeCallback_()
    elseif self.isCarsh_ and self.isShowCarsh_ then
        -- if self.isSponsorChips_ then
        --     SponsorChipsPopup.new():showPanel()
        -- else
        --     FirstPayUserCrash.new(self.gameId_, self.blind_):showPanel()
        -- end
        FirstPayUserCrash.new(self.gameId_, self.blind_):showPanel()
    end

    removeFunc()
end

function FirstPayPopup:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function FirstPayPopup:onCleanup()
    self.controller_:dispose()

    sa.EventCenter:removeEventListener(self.firstPaySuccessId_)

    if not self.isCarsh_ or not self.isShowCarsh_ then
        display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
    end
end

return FirstPayPopup