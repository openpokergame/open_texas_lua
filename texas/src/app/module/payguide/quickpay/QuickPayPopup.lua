--破产商品推荐弹窗
local QuickPayPopup = class("QuickPayPopup", tx.ui.Panel)

local PayPopupController = import("..PayPopupController")
local UserCrash = import("..usercrash.UserCrash")
-- local SponsorChipsPopup = import("..usercrash.SponsorChipsPopup")

local WIDTH, HEIGHT = 1066, 685
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5

function QuickPayPopup:ctor(isCarsh, gameId, blind)
    QuickPayPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:addCloseBtn()
    self:setCloseBtnOffset(5, 5)

    display.newSprite("img/quick_pay_bg.jpg")
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self.background_)

    self.isCarsh_ = isCarsh
    self.gameId_ = gameId
    self.blind_ = blind
    self.isShowCarsh_ = true

    self.controller_ = PayPopupController.new(self)

    if isCarsh then
        self.controller_:checkUserCrash(gameId, blind)
    else
        self.controller_:getFastGoodsConfig(gameId, blind)
    end

    self.paySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_SUCCESS, handler(self, self.onPaySuccessCallback_))
end

function QuickPayPopup:addMainUI(goods, carshChips, isSponsorChips)
    self.goodsData_ = goods
    if carshChips <= 0 then
        self.isShowCarsh_ = false
    end

    if isSponsorChips == 1 then
        self.isSponsorChips_ = true
    end

    local bg = self.background_
    local label_y = 320
    local label = ui.newBMFontLabel({text = sa.formatNumberWithSplit(goods.riseMoney_), font = "fonts/shouchong3.fnt"})
        :pos(C_X, label_y)
        :addTo(bg)

    if tonumber(goods.gaddPro) > 0 then
        local y = label_y + 55
        local label = ui.newTTFLabel({text = sa.formatNumberWithSplit(goods.baseMoney_), size = 50})
            :pos(C_X, y)
            :addTo(bg)

        local labelSize = label:getContentSize()
        display.newScale9Sprite("#common/chips_sale_line.png", 0, 0, cc.size(labelSize.width + 20, 6))
            :rotation(2)
            :pos(C_X, y)
            :addTo(bg)

        local size = label:getContentSize()
        local frame = display.newSprite("#dialogs/aboutpay/crash_goods_sale.png")
            :pos(C_X + 200, y + 70)
            :addTo(bg)

        ui.newBMFontLabel({text = "+"..goods.gaddPro.."%", font = "fonts/shangcheng4.fnt"})
            :rotation(-45)
            :pos(80, 70)
            :addTo(frame)
    end

    local btn_x, btn_y = C_X, 110
    local dir = 225

    self.buyBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_yellow.png", pressed = "#common/btn_big_yellow_down.png", disabled = "#common/btn_big_disabled.png"}, {scale9 = true})
        :setButtonSize(350, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("PAYGUIDE","BUY_PRICE_1", goods.priceLabel), size = 32}))
        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)
end

function QuickPayPopup:onBuyClicked_()
    if self.isCarsh_ then
        _G.buyFromScene = 2
    else
        _G.buyFromScene = 3
    end

    self.buyBtn_:setButtonEnabled(false)
    self:schedule(function()
        self.buyBtn_:setButtonEnabled(true)
    end, 5)
    self.controller_:makePurchase(self.goodsData_)
end

function QuickPayPopup:onPaySuccessCallback_()
    self.isShowCarsh_ = false
    if self.isCarsh_ then
        self:hidePanel()
    end
end

function QuickPayPopup:onRemovePopup(removeFunc)
    if self.isCarsh_ and self.isShowCarsh_ then
        -- if self.isSponsorChips_ then
        --     SponsorChipsPopup.new():showPanel()
        -- else
        --     UserCrash.new(self.gameId_, self.blind_):showPanel()
        -- end
        UserCrash.new(self.gameId_, self.blind_):showPanel()
    end

    removeFunc()
end

function QuickPayPopup:onCleanup()
    self.controller_:dispose()

    sa.EventCenter:removeEventListener(self.paySuccessId_)

    if not self.isCarsh_ or not self.isShowCarsh_ then
        display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
    end
end

return QuickPayPopup