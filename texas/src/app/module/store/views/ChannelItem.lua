local ChannelItem = class("ChannelItem", sa.ui.ListItem)

local CheckoutGuidePopup  = import(".CheckoutGuidePopup")

ChannelItem.PADDING_LEFT = 2
ChannelItem.PADDING_RIGHT = 2
ChannelItem.WIDTH = 260
ChannelItem.HEIGHT = 98

function ChannelItem:ctor()
    local w, h = ChannelItem.WIDTH, ChannelItem.HEIGHT
    ChannelItem.super.ctor(self, w, h)
    local x, y = w * 0.5, h * 0.5
    self.btn_ = ChkBoxButton(ImgButton(display.newSprite(),"#store/tab1.png","#store/tab2.png","#store/tab3.png"))
        :pos(x, y)
        :onButtonClicked(function(evt)
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            self:setSelected(true,true)
        end)
        :addTo(self)

    self.icon_ = display.newSprite()
        :pos(x, y)
        :addTo(self)

    self.maxSale_ = display.newSprite("#store/channel_discount_icon.png")
        :align(display.LEFT_CENTER, 8, y + 2)
        :addTo(self)
        :hide()

    self.saleLabel_ = ui.newTTFLabel({text = "", size = 20})
        :align(display.LEFT_CENTER, 2, 42)
        :rotation(-50)
        :addTo(self.maxSale_)

    self.btn_:setTouchSwallowEnabled(false)
    self:setTouchSwallowEnabled(false)
end

function ChannelItem:onDataSet(dataChanged, data)
    if dataChanged then
        if data.img then
            self.icon_:setSpriteFrame(display.newSprite(data.img):getSpriteFrame())
        end

        if data.maxSale and data.maxSale > 0 then
            self.maxSale_:show()
            self.saleLabel_:setString("+" .. data.maxSale .. "%")
        else
            self.maxSale_:hide()
        end

        if appconfig.LANG == "th" and data.id == 1 and not self.help_ then
            self.help_ = cc.ui.UIPushButton.new("img/checkout_guide_btn.png")
                :onButtonClicked(buttontHandler(self, self.onCheckoutGuideClicked_))
                :pos(ChannelItem.WIDTH - 40, 63)
                :addTo(self)
        end
    end

    if type(data)=="table" and data.select==true then
        self:setSelected(true)
    end
end

function ChannelItem:setSelected(value,evt)
    local owner = self:getOwner()
    if value then
        if owner.curSelected ~= self then
            if owner.curSelected then
                owner.curSelected:setSelected(false)
            end
            owner.curSelected = self
            self.btn_:setButtonSelected(true)
            if owner.onChannelClick then
                owner.onChannelClick(self:getData())
            end
        end
    else
        self.btn_:setButtonSelected(false)
    end
end

function ChannelItem:onCheckoutGuideClicked_()
    CheckoutGuidePopup.new():showPanel()
end

return ChannelItem