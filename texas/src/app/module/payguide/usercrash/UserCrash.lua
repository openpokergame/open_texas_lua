--破产弹窗，显示破产商品

local UserCrash = class("UserCrash", tx.ui.Panel)

local PayPopupController = import("..PayPopupController")

local WIDTH, HEIGHT = 984, 570
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5

local FONT = {
    "fonts/shangcheng3.fnt",
    "fonts/shouchong6.fnt",
    "fonts/shouchong5.fnt"
}
local OFFSET_X = {-15, 0, -5}

function UserCrash:ctor(gameId, blind)
    UserCrash.super.ctor(self, {WIDTH, HEIGHT})
    self:addCloseBtn()
    self:setCloseBtnOffset(5, 5)

    local bg = self.background_
    display.newSprite("img/crash_bg.jpg")
        :pos(C_X, C_Y)
        :addTo(bg)

    self.controller_ = PayPopupController.new(self)
    self.controller_:checkUserCrash(gameId, blind)

    self.paySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_SUCCESS, handler(self, self.onPaySuccessCallback_))
end

function UserCrash:addMainUI(goods, carshChips)
    goods.userCrashMoney = carshChips
    self.goodsData_ = goods

    if carshChips > 0 then
        local bg = self.background_
        local x = 210
        display.newSprite("#dialogs/aboutpay/crash_chip_bg.png")
            :pos(x, C_Y - 5)
            :addTo(bg)

        display.newSprite("#dialogs/aboutpay/crash_chip.png")
            :pos(x, C_Y + 30)
            :addTo(bg)

        local str = sa.formatBigNumber(carshChips)
        local label = ui.newTTFLabel({text = sa.LangUtil.getText("CRASH","PROMPT_LABEL_1",str), size = 24, align = ui.TEXT_ALIGN_LEFT, dimensions=cc.size(330, 0)})
            :pos(x, 190)
            :addTo(bg)

        self.carshBtn_ = cc.ui.UIPushButton.new({normal = "#dialogs/aboutpay/crash_btn_normal.png", pressed = "#dialogs/aboutpay/crash_btn_pressed.png", disabled = "#dialogs/aboutpay/crash_btn_disabled.png"}, {scale9 = true})
            :setButtonSize(252, 70)
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON","GET"), size = 28}))
            :onButtonClicked(buttontHandler(self, self.onGetCarshRewardClicked_))
            :pos(195, 85)
            :addTo(bg)
    end

    self:addQuickPayGoods_(goods)
end

function UserCrash:addQuickPayGoods_(goods)
    local bg = self.background_

    local x = C_X + 200
    display.newSprite("#dialogs/aboutpay/quick_pay_chip.png")
        :pos(x, C_Y + 100)
        :addTo(bg)

    local label_x, label_y = WIDTH - 80, C_Y + 110
    if tonumber(goods.gaddPro) > 0 then
        self:createPriceNode_(1, label_x, label_y + 35, "+"..goods.gaddPro.."%")
    end
    self:createPriceNode_(2, label_x, label_y, sa.formatNumberWithSplit(goods.baseMoney_))
    self:createPriceNode_(3, label_x, label_y - 70, sa.formatNumberWithSplit(goods.riseMoney_))

    ui.newTTFLabel({text=sa.LangUtil.getText("CRASH","PROMPT_LABEL_2"), size=24, align = ui.TEXT_ALIGN_LEFT, dimensions=cc.size(500, 0)})
        :pos(x, 190)
        :addTo(bg)
    
    self.buyBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png", disabled = "#common/btn_big_disabled.png"}, {scale9 = true})
        :setButtonSize(350, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("PAYGUIDE","BUY_PRICE_1", goods.priceLabel), size = 32}))
        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
        :pos(x, 90)
        :addTo(bg)
end

function UserCrash:createPriceNode_(index, x, y, str)
    local node = display.newNode()
        :rotation(-5)
        :pos(x, y)
        :addTo(self.background_)

    local label = ui.newBMFontLabel({text = str, font = FONT[index]})
        :align(display.RIGHT_BOTTOM, OFFSET_X[index], 0)
        :addTo(node)

    local size = label:getContentSize()
    local w = size.width
    if index == 2 then
        display.newScale9Sprite("#common/chips_sale_line_2.png", 0, 0, cc.size(w+20, 6))
            :pos(-w*0.5, 15)
            :addTo(node)
    end
end

function UserCrash:onGetCarshRewardClicked_()
    self.carshBtn_:setButtonEnabled(false)
    self.controller_:getUserCrashReward()
end

function UserCrash:updateCrashView(isSuccess)
    if isSuccess then
        self.carshBtn_:hide()
    else
        self.carshBtn_:setButtonEnabled(true)
    end
end

function UserCrash:onBuyClicked_()
    _G.buyFromScene = 2

    self.buyBtn_:setButtonEnabled(false)
    self:schedule(function()
        self.buyBtn_:setButtonEnabled(true)
    end, 5)
    self.controller_:makePurchase(self.goodsData_)
end

function UserCrash:onPaySuccessCallback_()
    self.buyBtn_:hide()
end

function UserCrash:onCleanup()
    self.controller_:dispose()

    sa.EventCenter:removeEventListener(self.paySuccessId_)

    display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
end

return UserCrash
