--房间内快捷支付弹窗
local RoomQuickPayPopup = class("RoomQuickPayPopup", tx.ui.Panel)

local PayPopupController = import("..PayPopupController")

local WIDTH, HEIGHT = 370, 548
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5

function RoomQuickPayPopup:ctor(gameId, blind)
    RoomQuickPayPopup.super.ctor(self, {WIDTH, HEIGHT}, "img/room_quick_pay_bg.png")

    self:pos(display.width + C_X, display.cy)

    self.controller_ = PayPopupController.new(self)
    self.controller_:getFastGoodsConfig(gameId, blind)
end

function RoomQuickPayPopup:addMainUI(goods)
    self.goodsData_ = goods

    local bg = self.background_
    local label_y = 265
    local label = ui.newBMFontLabel({text = sa.formatNumberWithSplit(goods.riseMoney_), font = "fonts/shouchong3.fnt"})
        :pos(C_X, label_y)
        :addTo(bg)
    sa.fitSprteWidth(label, 320)

    if tonumber(goods.gaddPro) > 0 then
        local y = label_y + 50
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
            :pos(C_X + 100, y + 80)
            :addTo(bg)

        ui.newBMFontLabel({text = "+"..goods.gaddPro.."%", font = "fonts/shangcheng4.fnt"})
            :rotation(-45)
            :pos(80, 70)
            :addTo(frame)
    end

    local btn_x, btn_y = C_X, 80
    local dir = 225

    self.buyBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_yellow.png", pressed = "#common/btn_big_yellow_down.png", disabled = "#common/btn_big_disabled.png"}, {scale9 = true})
        :setButtonSize(350, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("PAYGUIDE","BUY_PRICE_1", goods.priceLabel), size = 32}))
        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)
end

function RoomQuickPayPopup:onBuyClicked_()
    _G.buyFromScene = 3

    self.buyBtn_:setButtonEnabled(false)
    self:schedule(function()
        self.buyBtn_:setButtonEnabled(true)
    end, 5)
    self.controller_:makePurchase(self.goodsData_)
end

function RoomQuickPayPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width + WIDTH * 0.5, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function RoomQuickPayPopup:onShowPopup()
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width - WIDTH * 0.5 + 8, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
    end})
end

function RoomQuickPayPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function RoomQuickPayPopup:showPanel()    
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function RoomQuickPayPopup:onCleanup()
    self.controller_:dispose()
    display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
end

return RoomQuickPayPopup