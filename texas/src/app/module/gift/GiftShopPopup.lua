-- 礼物商店

local GiftShopPopup = class("GiftShopPopup", tx.ui.Panel)
local GiftListItem = import(".GiftListItem")
local GiftPopupController = import(".GiftPopupController")
local GiftListView = import(".GiftListView")
local WIDTH, HEIGHT = 1136, 746 
local RIGHT_FRAME_W, RIGHT_FRAME_H = 820, 590
local GIFT_SHOP_TAB = 1 --礼物商城
local GIFT_VIP_TAB = 2 --VIP礼物商城
local MY_GIFT_TAB = 3 --我的礼物

function GiftShopPopup:ctor(defaultTab)
    GiftShopPopup.super.ctor(self,{WIDTH,HEIGHT})

    self:setImgTitleStyle("#lang/pop_title_gift.png")

    self:setNodeEventEnabled(true)

    self.controller_ = GiftPopupController.new(self)
    
    self.onHideGiftListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.HIDE_GIFT_POPUP, handler(self, self.hidePopup))
    
    self.selected_ = defaultTab or GIFT_SHOP_TAB

    self:setMainTabStyle(sa.LangUtil.getText("GIFT", "MAIN_TAB_TEXT"), self.selected_, handler(self, self.onMainTabChange))

    self:addRightNodes_()
end

function GiftShopPopup:addRightNodes_()
    local bg_w, bg_h = RIGHT_FRAME_W, RIGHT_FRAME_H
    local bg = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(bg_w, bg_h))
        :align(display.RIGHT_BOTTOM, WIDTH - 28, 30)
        :addTo(self.background_)

    --添加数据到列表
    local list_w, list_h = 810, 400
    self.giftList_ = GiftListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
            direction = sa.ui.ListView.DIRECTION_VERTICAL
        }, 
        GiftListItem
    )
    :pos(bg_w/2, bg_h/2 + 10)
    :addTo(bg)

    self.giftList_.controller_ = self.controller_ 

    local btn_w, btn_h = 280, 104
    local btn_y = 50
    self.buyGiftButton_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png",pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("COMMON","BUY"), size=26}))
        :pos(bg_w/2, btn_y)
        :onButtonClicked(buttontHandler(self, self.onBuyGiftClicked_))
        :addTo(bg)
        :hide()

    self.buyOtherFriendButton_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png",pressed = "#common/btn_small_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("GIFT","BUY_TO_TABLE_GIFT_BUTTON_LABEL"), size=26}))
        :pos(bg_w/2 - 220, btn_y)
        :onButtonClicked(buttontHandler(self, self.onBuyGiftToOtherClicked_))
        :addTo(bg)
        :hide()

    self.curSelectGiftName_ = ui.newTTFLabel({text = sa.LangUtil.getText("GIFT","MY_GIFT_MESSAGE_PROMPT_LABEL") , size=24, color=cc.c3b(0xb2, 0xdc, 0xff)})
        :pos(bg_w/2, btn_y)
        :addTo(bg)
        :hide()

    self.noDataTip_ = self:createNoDataTips(sa.LangUtil.getText("GIFT", "NO_GIFT_TIP")):hide()

    self.subTabBarShopGift_ = self:createSubTabBar_(bg, sa.LangUtil.getText("GIFT", "SUB_TAB_TEXT_SHOP_GIFT"), 700)
    self.subTabBarMyGift_ = self:createSubTabBar_(bg, sa.LangUtil.getText("GIFT", "SUB_TAB_TEXT_MY_GIFT"), 525)
end

function GiftShopPopup:createSubTabBar_(parent, text, w)
    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        text,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
        }, true, true)
        :setTabBarSize(w, 52, 0, -4)
        :onTabChange(handler(self, self.onSubTabChange_))
        :pos(RIGHT_FRAME_W/2, RIGHT_FRAME_H - 40)
        :addTo(parent)
        :gotoTab(1, true)
        :hide()

    return tab
end

function GiftShopPopup:onMainTabChange(evt)
    self:onMainTabChange_(evt.selected)
end

function GiftShopPopup:onMainTabChange_(selected)
    self.selected_ = selected

    self.controller_:onMainTabChange(selected)
    self.controller_:getTableUseUid(self.useId_, self.useIdArray_, self.toUidArr_, self.toInfoArr_)

    if selected == GIFT_SHOP_TAB then
        self:showShopGiftView_()
    elseif selected == GIFT_VIP_TAB then
        self:showShopGiftView_()
    elseif selected == MY_GIFT_TAB then
        self:showMyGiftView_()
        self.controller_:updateGiftIdHandler(0)
    end
end

function GiftShopPopup:showShopGiftView_()
    self.subTabBarMyGift_:hide()
    self.subTabBarShopGift_:show()
    local lastIndex = self.subTabBarShopGift_:getSelectedTab() or 1
    self.subTabBarShopGift_:gotoTab(lastIndex, true)
end

function GiftShopPopup:showMyGiftView_()
    self.subTabBarShopGift_:hide()
    self.subTabBarMyGift_:show()
    local lastIndex = self.subTabBarMyGift_:getSelectedTab() or 1
    self.subTabBarMyGift_:gotoTab(lastIndex, true)
end

function GiftShopPopup:onSubTabChange_(selectedTab)
    self.controller_:onSubTabChange(selectedTab)
end

function GiftShopPopup:show(isRoom,uid,allTableId,tableNum,toUidArr,toInfoArr)
    self.isRoom = isRoom
    self.useId_ = uid
    self.useIdArray_ = allTableId
    self.toUidArr_ = toUidArr
    self.toInfoArr_ = toInfoArr
    self:showPanel_()
    if self.useId_ == tx.userData.uid then
        if self.isRoom then
            self.buyGiftButton_:setButtonLabelString(sa.LangUtil.getText("COMMON", "BUY"))
        end
    else
        if self.isRoom then
            self.buyGiftButton_:setButtonLabelString(sa.LangUtil.getText("GIFT", "PRESENT_GIFT_BUTTON_LABEL"))
        end
    end
    
    if self.isRoom then
        self.buyOtherFriendButton_:setButtonLabelString(sa.LangUtil.getText("GIFT", "BUY_TO_TABLE_GIFT_BUTTON_LABEL", tableNum))
    end
end  

function GiftShopPopup:hidePopup()
    tx.PopupManager:removePopup(self)
end

function GiftShopPopup:onRemovePopup(removeFunc)
    if self.selected_ == MY_GIFT_TAB then
        self.controller_:useBuyGiftRequest(self.isRoom)
    end
    removeFunc()
end

function GiftShopPopup:setListData(data, selectedId)
    if self.giftList_ then
        self.data_ = data or {}
        self.giftList_:setListData(self.data_, nil)
        if selectedId then
            self.giftList_:selectGiftById(selectedId)
        else
            self.giftList_:selectGiftByIndex(1)
        end

        self:updateBuyBtnState_()
    end
end

function GiftShopPopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(132, 0)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function GiftShopPopup:setNoDataTip(noData)
    if noData then
        self.noDataTip_:show()
    else
        self.noDataTip_:hide()
    end
end

function GiftShopPopup:onShowed()
    self:onMainTabChange_(self.selected_)--主动调用一次，刷新状态

    self.giftList_:setScrollContentTouchRect()
end

function GiftShopPopup:updateBuyBtnState_()
    if #self.data_ == 0 then
        self.buyGiftButton_:hide()
        self.buyOtherFriendButton_:hide()
        self.curSelectGiftName_:hide()
    else
        local selected = self.selected_
        if selected == GIFT_SHOP_TAB or selected == GIFT_VIP_TAB then
            self.buyGiftButton_:show()
            if self.isRoom then
                self.buyOtherFriendButton_:show()
                self.buyGiftButton_:setPositionX(RIGHT_FRAME_W/2 + 220)
            else
                self.buyGiftButton_:setPositionX(RIGHT_FRAME_W/2)
            end
            self.curSelectGiftName_:hide()
        else
            self.buyGiftButton_:hide()
            if self.isRoom then
                self.buyOtherFriendButton_:hide()
                self.buyGiftButton_:setPositionX(RIGHT_FRAME_W/2 + 220)
            else 
                self.buyGiftButton_:setPositionX(RIGHT_FRAME_W/2)
            end
            self.curSelectGiftName_:show()
        end
    end
end

function GiftShopPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.onHideGiftListenerId_)
    self.controller_:dispose()
end

function GiftShopPopup:onBuyGiftClicked_()
    if self.isRoom then
        if self.useId_ == tx.userData.uid then
            self.controller_:buyGiftRequest(self.isRoom)
        else
            self.controller_:requestPresentGiftData(self.isRoom)
        end
    else
        self.controller_:buyGiftRequest(self.isRoom)
    end
end

function GiftShopPopup:onBuyGiftToOtherClicked_()
    self.controller_:requestPresentTableGift(self.isRoom)
end

return GiftShopPopup