--破产弹窗，显示破产商品
local PayPopupController = import("..PayPopupController")

local FirstPayUserCrash = class("FirstPayUserCrash", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 1035, 520
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

function FirstPayUserCrash:ctor(gameId, blind)
    self:setNodeEventEnabled(true)

    local bg = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)
    self.background_ = bg

    display.newSprite("img/first_crash_bg.png")
        :pos(C_X, C_Y)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "img/first_close.png", pressed = "img/first_close_down.png"})
        :onButtonClicked(buttontHandler(self, self.hidePanel))
        :pos(WIDTH - 125, HEIGHT - 45)
        :addTo(bg)

    self.controller_ = PayPopupController.new(self)

    self.controller_:checkUserCrash(gameId, blind)

    self.paySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_SUCCESS, handler(self, self.onPaySuccessCallback_))
end

function FirstPayUserCrash:addMainUI(goods, carshChips)
    goods.userCrashMoney = carshChips
    self.goodsData_ = goods

    if carshChips > 0 then
        local bg = self.background_
        display.newSprite("#dialogs/aboutpay/crash_chip.png")
            :pos(190, C_Y + 80)
            :addTo(bg)

        local str = sa.formatBigNumber(carshChips)
        local label = ui.newTTFLabel({text = sa.LangUtil.getText("CRASH","PROMPT_LABEL_1",str), size = 24, align = ui.TEXT_ALIGN_LEFT, dimensions=cc.size(330, 0)})
            :pos(200, 210)
            :addTo(bg)

        self.carshBtn_ = cc.ui.UIPushButton.new({normal = "#dialogs/aboutpay/crash_btn_normal.png", pressed = "#dialogs/aboutpay/crash_btn_pressed.png", disabled = "#dialogs/aboutpay/crash_btn_disabled.png"}, {scale9 = true})
            :setButtonSize(252, 70)
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON","GET"), size = 28}))
            :onButtonClicked(buttontHandler(self, self.onGetCarshRewardClicked_))
            :pos(185, 85)
            :addTo(bg)
    end

    self:addFirstPayGoods_(goods)
end

function FirstPayUserCrash:addFirstPayGoods_(goods)
    local bg = self.background_
    display.newSprite("#dialogs/aboutpay/first_pay_chip.png")
        :pos(C_X + 50, C_Y + 105)
        :addTo(bg)

    local money = sa.formatNumberWithSplit(goods.riseMoney_)
    ui.newTTFLabel({text = sa.LangUtil.getText("STORE","FORMAT_CHIP", money), size = 36})
        :pos(C_X + 75, C_Y - 25)
        :addTo(bg)

    local label_x, label_y = C_X + 160, C_Y + 105
    self:createPriceNode_(1, label_x, label_y, goods.originalPriceNum)
    self:createPriceNode_(2, label_x, label_y - 100, goods.priceNum)

    ui.newTTFLabel({text=sa.LangUtil.getText("CRASH","PROMPT_LABEL_2"), size=24, align = ui.TEXT_ALIGN_LEFT, dimensions=cc.size(450, 0)})
        :pos(C_X + 110, 165)
        :addTo(bg)
    
    local btn_w, btn_h = 274, 92
    local btn = sp.SkeletonAnimation:create("spine/first_pay_btn.json","spine/first_pay_btn.atlas")
        :scale(0.8)
        :size(btn_w, btn_h)
        :align(display.CENTER, C_X + 75, 80)
        :addTo(bg)
    self.buyBtn_ = btn

    btn:setAnimation(0, 1, true)
    ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onBuyClicked_))

    display.newSprite("#lang/first_pay_price_2.png")
        :pos(btn_w*0.5, btn_h*0.5)
        :addTo(btn)
end

function FirstPayUserCrash:createPriceNode_(index, x, y, priceNum)
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
            :pos(w*0.5, 25)
            :addTo(node)
    end
end

function FirstPayUserCrash:onGetCarshRewardClicked_()
    self.carshBtn_:setButtonEnabled(false)
    self.controller_:getUserCrashReward()
end

function FirstPayUserCrash:updateCrashView(isSuccess)
    if isSuccess then
        self.carshBtn_:hide()
    else
        self.carshBtn_:setButtonEnabled(true)
    end
end

function FirstPayUserCrash:onBuyClicked_()
    _G.buyFromScene = 4

    self.buyBtn_:setButtonEnabled(false)
    self:schedule(function()
        self.buyBtn_:setButtonEnabled(true)
    end, 5)
    self.controller_:makePurchase(self.goodsData_)
end

function FirstPayUserCrash:onPaySuccessCallback_()
    self.buyBtn_:hide()
end

function FirstPayUserCrash:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function FirstPayUserCrash:showPanel()
    tx.PopupManager:addPopup(self)
end

function FirstPayUserCrash:hidePanel()
    tx.PopupManager:removePopup(self)
end

function FirstPayUserCrash:onCleanup()
    self.controller_:dispose()

    sa.EventCenter:removeEventListener(self.paySuccessId_)

    display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
end

return FirstPayUserCrash
