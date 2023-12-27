local PropHDDJItem = class("PropHDDJItem", sa.ui.ListItem)
local ITEM_W, ITEM_H = 130, 130
local BG_W, BG_H = ITEM_W - 10, ITEM_H - 10
local ICON_X, ICON_Y = BG_W*0.5, BG_H*0.5

function PropHDDJItem:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	PropHDDJItem.super.ctor(self, ITEM_W, ITEM_H)

	self:setNodeEventEnabled(true)

    local bg = display.newScale9Sprite("#common/pop_list_item_bg.png",0,0,cc.size(BG_W, BG_H))
        :pos(ITEM_W*0.5, ITEM_H*0.5)
        :addTo(self)

    ImgButton(bg, "#common/pop_list_item_bg.png", "#common/pop_list_item_pressed.png")
        :onButtonClicked(buttontHandler(self, self.onSendHDDJClicked_))
    bg:setTouchSwallowEnabled(false)

    self.icon_ = display.newSprite()
        :pos(ICON_X, ICON_Y)
        :addTo(bg)

    self.price_ = ui.newBMFontLabel({text = "", font = "fonts/room_seat_money.fnt"})
        :pos(ICON_X, 7)
        :addTo(bg)

    self.isShowPrice_ = false
    if tx.userData.hddjnum <= 0 and not tx.checkIsVip() then
        self.isShowPrice_ = true
    end
end

function PropHDDJItem:onDataSet(dataChanged, data)
	self.data_ = data
    if self.data_ and dataChanged then
        self.icon_:setSpriteFrame("hddj_" .. data.id .. ".png")

        self.price_:setString(data.price)
        if self.isShowPrice_ then
            self.price_:show()
            self.icon_:scale(0.7):pos(ICON_X, ICON_Y + 15)
        else
            self.price_:hide()
            self.icon_:scale(1):pos(ICON_X, ICON_Y)
        end
    end
end

function PropHDDJItem:onSendHDDJClicked_()
    if self.isShowPrice_ and tx.userData.isShowVipPropTips then
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("VIP", "SEND_PROPS_TIPS_2"),
            firstBtnText =sa.LangUtil.getText("VIP", "COST_CHIPS", self.data_.price),
            secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
            callback = function(param)
                if param == tx.ui.Dialog.FIRST_BTN_CLICK then
                    tx.userData.isShowVipPropTips = false
                    self:sendHddj_()
                elseif param == tx.ui.Dialog.SECOND_BTN_CLICK then
                    tx.PayGuideManager:openStore(4)
                end
            end
        }):show()
    else
        self:sendHddj_()
    end
end

function PropHDDJItem:sendHddj_()
    local list = self:getOwner()
    if list.onPropItemClickListener then
        list.onPropItemClickListener(self.data_.id)
    end
end

function PropHDDJItem:onCleanup()
end

return PropHDDJItem