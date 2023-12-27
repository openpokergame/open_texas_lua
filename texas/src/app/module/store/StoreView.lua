local PURCHASE_TYPE = import(".PURCHASE_TYPE")

local StoreView = class("StoreView", tx.ui.EditPanel)
local logger = sa.Logger.new("StoreView")

local StoreController = import(".StoreController")
local ChannelItem = import(".views.ChannelItem")
local ChipsListItem = import(".views.ChipsListItem")
local DiamondsListItem = import(".views.DiamondsListItem")
local PropsListItem = import(".views.PropsListItem")
local RealListItem = import(".views.RealListItem")
local ProductRecordPopup = import(".views.ProductRecordPopup")
local AddressPopup = import(".views.AddressPopup")
local CashCardTipsPopup = import(".views.CashCardTipsPopup")
local ProductVipList = import(".views.ProductVipList")
local CheckoutGuidePopup  = import(".views.CheckoutGuidePopup")

local TOP_LEFT_H = 314  -- 左上部高度
local REAL_BTN_H = 62  -- 左边实物兑换按钮高度
local LEFT_WIDTH = 346      -- 左边渠道宽度
local RIGHT_WIDTH = display.width - LEFT_WIDTH --右边框宽度
local TOP_HEIGHT = 100      -- 上部高度 不包括输入框
local INPUT_HEIGHT_1 = 200    -- 上部高度 1个输入框
local INPUT_HEIGHT_2 = 280    -- 上部高度 2个输入框
local FIRST_HEIGHT = 166 --首充背景
local FIRST_HEIGHT_1 = INPUT_HEIGHT_1 + FIRST_HEIGHT --上部高度 包含1个输入框,首充背景
local FIRST_HEIGHT_2 = INPUT_HEIGHT_2 + FIRST_HEIGHT --上部高度 包含2个输入框,首充背景
local LIST_WIDTH = display.width - LEFT_WIDTH
local LIST_HEIGHT = display.height - TOP_HEIGHT
local LIST_HEIGHT_1  = display.height - INPUT_HEIGHT_1
local LIST_HEIGHT_2  = display.height - INPUT_HEIGHT_2
local LIST_HEIGHT_3  = display.height - TOP_HEIGHT - FIRST_HEIGHT
local LIST_HEIGHT_4  = display.height - FIRST_HEIGHT_1
local LIST_HEIGHT_5  = display.height - FIRST_HEIGHT_2
local LIST_X, LIST_Y = LEFT_WIDTH*0.5, -TOP_HEIGHT*0.5

ChannelItem.WIDTH = LEFT_WIDTH

local normalColor = cc.c3b(0x67,0x59,0x94)
local selectColor = cc.c3b(0xff,0xf7,0xb7)

local TAB_CHIPS     = 1  --筹码
local TAB_DIAMONDS  = 2  --钻石
local TAB_PROPS     = 3  --道具
local TAB_VIP       = 4  --VIP

StoreView.ELEMENTS = {
    "bg",
    "nodeList",

    "nodeLeft.bg",
    "nodeLeft.nodeLeftTop.iconChips.label",
    "nodeLeft.nodeLeftTop.iconDiamond.label",
    "nodeLeft.tabRealBg",

    "nodeTop.bg",
    "nodeTop.topBtnBg",
    "nodeTop.btnRecord",
    "nodeTop.btnClose",
    "nodeTop.nodeEdit.bgInput1",
    "nodeTop.nodeEdit.bgInput2",
    "nodeTop.nodeEdit.btnInput.label",
    "nodeTop.nodeEdit.divLine",

    "nodeTop.nodeFirstpay.bg",
    "nodeTop.nodeFirstpay.title",
    "nodeTop.nodeFirstpay.reward1.label",
    "nodeTop.nodeFirstpay.reward2.label",
    "nodeTop.nodeFirstpay.reward3.label",

    "nodeRealTop.bg",
    "nodeRealTop.topBtnBg",
    "nodeRealTop.btnAddress.label",
    "nodeRealTop.btnClose",
}

local CHECK_IMAGES = {
    off = "#common/ui_checkbox_off.png",
    on = "#common/ui_checkbox_on.png"
}

function StoreView:ctor(index, payType, gotoReal)
    StoreView.super.ctor(self,"store.csb",true) 

    self:setNodeEventEnabled(true)
    self.controller_ = StoreController.new(self)

    index = index or TAB_CHIPS
    if index > TAB_VIP then
        index = TAB_CHIPS
    end
    if index>TAB_PROPS and tx.config.SHOW_VIP~=1 then
        index = TAB_CHIPS
    end

    self.index_ = index

    self.payType_ = payType

    self.gotoReal_ = gotoReal or 0

    _G.buyFromScene = 1

    self.isShowReal_ = false

    self.isShowChannel_ = true

    self:initPosition_()

    self:initViews_()

    logger.debug("start controller 1")
    self.controller_:init()
    logger.debug("start controller 2")

end

function StoreView:initPosition_()
    self.bg:setScaleY(tx.heightScale)
    self.bg:setScaleX(tx.widthScale)

    self.nodeLeft:pos(-display.cx,display.cy)
    local size = self.nodeLeft.bg:getContentSize()
    self.nodeLeft.bg:setScaleY(display.height/size.height)

    --虚拟商品顶部
    local nodeTop_x, nodeTop_y = -display.cx+LEFT_WIDTH,display.cy
    local bg_w = display.width-LEFT_WIDTH
    local bg_s = bg_w/(1280-LEFT_WIDTH)

    self.nodeTop:setPosition(nodeTop_x, nodeTop_y)
    self.nodeTop.bg:setScaleX(bg_s)

    local rightDir = 120 --购买记录按钮距离右边间隔
    local btnClose_x = bg_w - 10
    local btnRecord_x = bg_w - rightDir

    self.nodeTop.btnRecord:setPositionX(btnRecord_x)
    self.nodeTop.btnClose:setPositionX(btnClose_x)

    local leftDir = 30 --tab距离左边背景空白间隔
    size = self.nodeTop.btnRecord:getContentSize()
    local topWidth = bg_w - leftDir*2 - rightDir - size.width
    size = self.nodeTop.topBtnBg:getContentSize()
    self.nodeTop.topBtnBg:setContentSize(cc.size(topWidth, size.height))
    self.nodeTop.topBtnBg:setPositionX(leftDir + topWidth*0.5)

    self.nodeTop.nodeEdit.btnInput:setPositionX(LIST_WIDTH-53)
    size = self.nodeTop.nodeEdit.bgInput1:getContentSize()
    self.nodeTop.nodeEdit.bgInput1:setContentSize(cc.size(LIST_WIDTH-350, size.height))
    size = self.nodeTop.nodeEdit.bgInput2:getContentSize()
    self.nodeTop.nodeEdit.bgInput2:setContentSize(cc.size(LIST_WIDTH-350, size.height))
    self.nodeTop.nodeEdit.divLine:setContentSize(cc.size(LIST_WIDTH,3))

    --firstpay
    local s = RIGHT_WIDTH/934
    local px = self.nodeTop.nodeFirstpay.title:getPositionX()
    self.nodeTop.nodeFirstpay.title:setPositionX(px*s)
    self.nodeTop.nodeFirstpay.bg:setScaleX(s)
    for i=1,3 do
        local reward = self.nodeTop.nodeFirstpay["reward"..i]
        px = reward:getPositionX()
        reward:setPositionX(px*s)
    end

    --实物兑换顶部
    self.nodeRealTop:hide()
    self.nodeRealTop:setPosition(nodeTop_x, nodeTop_y)
    self.nodeRealTop.bg:setScaleX(bg_s)

    self.nodeRealTop.btnAddress:setPositionX(btnRecord_x)
    self.nodeRealTop.btnClose:setPositionX(btnClose_x)

    size = self.nodeRealTop.btnAddress:getContentSize()
    topWidth = bg_w - leftDir*2 - rightDir - size.width
    size = self.nodeRealTop.topBtnBg:getContentSize()
    self.nodeRealTop.topBtnBg:setContentSize(cc.size(topWidth, size.height))
    self.nodeRealTop.topBtnBg:setPositionX(leftDir + topWidth*0.5)

    self.nodeList:pos(LEFT_WIDTH*0.5,-TOP_HEIGHT*0.5)
end

function StoreView:initViews_()
    self:addCheckoutGuideNode_()

    self:initVirtualViews_()

    self:initRealViews_()

    self:addEventListeners_()
end

function StoreView:addCheckoutGuideNode_()
    if device.platform == "android" then
        local node = display.newNode()
            :addTo(self.nodeLeft)
            :hide()
        self.checkoutGuideNode_ = node

        local y = -280
        display.newSprite("img/checkout_guide_btn.png")
            :pos(75, y)
            :addTo(node)

        ui.newTTFLabel({text = sa.LangUtil.getText("CHECKOUTGUIDE", "BTN_TITLE"), size = 24})
            :align(display.LEFT_CENTER, 120, y)
            :addTo(node)

        local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
            :setButtonSize(280, 100)
            :onButtonClicked(buttontHandler(self, self.onCheckoutGuideClicked_))
            :pos(180, y)
            :addTo(node)
    end
end

--虚拟商品
function StoreView:initVirtualViews_()
    -- 支付列表
    local list_w,list_h = LEFT_WIDTH - 18, display.height-TOP_LEFT_H--REAL_BTN_H
    self.channelList_ = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * list_w, -0.5 * list_h, list_w, list_h),
            direction = sa.ui.ListView.DIRECTION_VERTICAL
        }, ChannelItem)
        :pos(list_w*0.5,-TOP_LEFT_H-list_h*0.5)
        :addTo(self.nodeLeft)
        :hideScrollBar()
    self.channelList_:hide() -- 默认隐藏 多种支付则打开
    self.channelList_.onChannelClick = handler(self, self.onChannelClick_)

    ImgButton(self.nodeTop.btnRecord,"#store/btn_record.png","#store/btn_record_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        ProductRecordPopup.new():show()
    end)
    ImgButton(self.nodeTop.btnClose,"#store/btn_close.png","#store/btn_close_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        self:onClose()
    end)

    local textList = sa.LangUtil.getText("STORE","TOP_LIST")
    textList = clone(textList)
    if tx.config.SHOW_VIP~=1 then
        table.remove(textList, TAB_VIP)
    end
    local size = self.nodeTop.topBtnBg:getContentSize()
    self.titleGroup_ = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#store/tab_item.png"
        },
        textList,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
        },
        true, true)
        :setTabBarSize(size.width, size.height+4, 0, 0)
        :onTabChange(function(selected)
            self:dealViewShow()
        end)
        :pos(size.width*0.5, size.height*0.5)
        :addTo(self.nodeTop.topBtnBg)

    --first
    local firstGoodsDesc = sa.LangUtil.getText("PAYGUIDE", "FIRST_GOODS_DESC_2")
    for i=1,3 do
        local label = self.nodeTop.nodeFirstpay["reward"..i].label
        label:setString(firstGoodsDesc[i])
        sa.fitSprteWidth(label, 130)
    end
    self.nodeTop.nodeFirstpay:hide()

    -- 输入
    self.nodeTop.nodeEdit.btnInput.label:setString(sa.LangUtil.getText("STORE", "CARD_INPUT_SUBMIT"))
    self.topUpBtn_ = ImgButton(self.nodeTop.nodeEdit.btnInput,"#common/btn_small_green.png","#common/btn_small_green_down.png")
        :onButtonClicked(buttontHandler(self, self.onTopUpClicked_))

    self.numInput_ = EditNumberLabel(self.nodeTop.nodeEdit.bgInput1,
        {
            maxLen = 20,
            tips = sa.LangUtil.getText("STORE", "INPUT_CRAD_NUM"),
            onEnterCallback =  handler(self, self.onNumEnterClicked_)
        })

    self.passInput_ = EditNumberLabel(self.nodeTop.nodeEdit.bgInput2,
        {
            maxLen = 20,
            tips = sa.LangUtil.getText("STORE", "INPUT_CRAD_PASSWORD"),
            onEnterCallback =  handler(self, self.onPwdEnterClicked_)
        })

    self.nodeTop.nodeEdit:hide()

    -- 筹码list
    self.chipsList_ = self:createGoodsList_(ChipsListItem)
    self.chipsList_.onItemClick = handler(self, self.onChipsClick_)

    -- 钻石list
    self.diamondsList_ = self:createGoodsList_(DiamondsListItem)
    self.diamondsList_.onItemClick = handler(self, self.onDiamondsClick_)

    -- 道具list
    self.propsList_ = self:createGoodsList_(PropsListItem)
    self.propsList_.onItemClick = handler(self, self.onPropsClick_)

    --vip list
    if tx.config.SHOW_VIP==1 then
        self.vipList_ = ProductVipList.new(self, LIST_WIDTH, LIST_HEIGHT):addTo(self.nodeList)
        self.vipList_:hide()
    end
end

--实物兑换
function StoreView:initRealViews_()
    local textList = sa.LangUtil.getText("STORE", "TAB_LIST")
    local tabIcons = {
        {
            upRes = "common/virtual_store_icon_normal.png",
            downRes = "common/virtual_store_icon_selected.png",
        },
        {
            upRes = "common/real_store_icon_normal.png",
            downRes = "common/real_store_icon_selected.png",
        },
    }
    local tabSize = self.nodeLeft.tabRealBg:getContentSize()
    self.mainGroup_ = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#store/real_tab_item.png"
        },
        textList,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
        },
        true, true)
        :setTabBarSize(tabSize.width, tabSize.height, -5, -3)
        :setButtonIcons(tabIcons, -50)
        :setLabelsOffset(20, 0)
        :setFitLabelWidth(110)
        :onTabChange(handler(self, self.realTabChanged_))
        :pos(tabSize.width*0.5, tabSize.height*0.5)
        :addTo(self.nodeLeft.tabRealBg)

    if not tx.OnOff:check("switch_real_store") and self.gotoReal_ <=0 then
        self.nodeLeft.tabRealBg:hide()
        self.mainGroup_:hide()
    end

    ImgButton(self.nodeRealTop.btnAddress,"#store/real_address_btn_normal.png","#store/real_address_btn_pressed.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        AddressPopup.new():showPanel()
    end)

    ImgButton(self.nodeRealTop.btnClose,"#store/btn_close.png","#store/btn_close_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        self:onClose()
    end)

    self.nodeRealTop.btnAddress.label:setString(sa.LangUtil.getText("STORE", "REAL_ADDRESS_BTN"))

    local textList = sa.LangUtil.getText("STORE","REAL_TAB_LIST")
    local size = self.nodeRealTop.topBtnBg:getContentSize()
    self.realTitleGroup_ = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#store/tab_item.png"
        },
        textList,
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
        },
        true, true)
        :setTabBarSize(size.width, size.height+4, 0, 0)
        :onTabChange(function(selected)
            self:dealRealViewShow()
        end)
        :pos(size.width*0.5, size.height*0.5)
        :addTo(self.nodeRealTop.topBtnBg)

    -- 礼品券商品
    self.giftList_ = self:createGoodsList_(RealListItem)
    self.giftList_.onItemClick = handler(self, self.onBuyRealClicked_)

    -- 兑换券商品
    self.exchangeList_ = self:createGoodsList_(RealListItem)
    self.exchangeList_.onItemClick = handler(self, self.onBuyRealClicked_)

    -- 开源币商品
    self.antList_ = self:createGoodsList_(RealListItem)
    self.antList_.onItemClick = handler(self, self.onBuyRealClicked_)
end

--创建商品列表
function StoreView:createGoodsList_(item)
    local list_w, list_h = LIST_WIDTH, LIST_HEIGHT
    item.WIDTH = list_w
    local list = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * list_w, -0.5 * list_h, list_w, list_h),
            direction = sa.ui.ListView.DIRECTION_VERTICAL
        }, item)
        :hideScrollBar()
        :addTo(self.nodeList)

    return list
end

function StoreView:onNumEnterClicked_()
    local text = self.numInput_:getText()
    if text == "" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "INPUT_NUM_EMPTY"))
    end
end

function StoreView:onPwdEnterClicked_()
    local text = self.passInput_:getText()
    if text == "" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "INPUT_PASSWORD_EMPTY"))
    end
end

function StoreView:addEventListeners_()
    -- 数据
    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", function (chips)
        if not chips then return end
        self.nodeLeft.nodeLeftTop.iconChips.label:setString(sa.formatNumberWithSplit(chips))
        self.nodeLeft.nodeLeftTop.iconDiamond.label:setString(sa.formatNumberWithSplit(tx.userData.diamonds))
    end)

    self.diamondsObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "diamonds", function (diamonds)
        if not diamonds then return end
        self.nodeLeft.nodeLeftTop.iconDiamond.label:setString(sa.formatNumberWithSplit(diamonds))
    end)

    self.onCashCardPayObserver_ = sa.DataProxy:addDataObserver(tx.dataKeys.STORE_CASH_CARD_PAY, function(enabled)
        self.topUpBtn_:setButtonEnabled(enabled)
    end)

    self.firstPaySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_FIRST_PAY_SUCCESS, function()
        self:hidePanel()
    end)
end

function StoreView:onChannelClick_(data)
    self.curChannel_ = data
    self:dealViewShow()
end

function StoreView:dealViewShow()
    logger:debug("dealViewShow 1 "..self.isShowReal_)
    if self.isShowReal_ then
        return
    end

    self:setLoading(true)

    self:hideVirtualLists_()

    local goodsType = self.titleGroup_:getSelectedTab()
    if self.curChannel_ then
        logger:debug("dealViewShow 2 "..self.curChannel_.id..self.curChannel_)
        self:showInputView_(goodsType)
        local data = {}
        data.chips = {}
        data.diamonds = {}
        data.props = {}
        if self.controller_.loadedGoods and self.controller_.loadedGoods[self.curChannel_.id] then
            data = self.controller_.loadedGoods[self.curChannel_.id]
            self:setLoading(false)
        end

        if goodsType == TAB_CHIPS then
            self.chipsList_:show()
            if data.chips ~= self.chipsList_:getData() then
                self.chipsList_:setData(self:transformData_(data.chips))
            end
        elseif goodsType == TAB_DIAMONDS then
            self.diamondsList_:show()
            if data.diamonds ~= self.diamondsList_:getData() then
                self.diamondsList_:setData(self:transformData_(data.diamonds))
            end
        elseif goodsType == TAB_PROPS then
            self.propsList_:show()
            if data.props ~= self.propsList_:getData() then
                self.propsList_:setData(self:transformData_(data.props))
            end
        end
    end

    --VIP商品不依赖支付渠道
    if goodsType == TAB_VIP then
        self:setLoading(false)
        if self.vipList_ then
            self.vipList_:show()
            local data = tx.userData.vipGoodsData
            if data ~= self.vipList_:getData() then
                self.vipList_:setData(data)
            end
        end
    end
end

function StoreView:dealRealViewShow()
    if not self.isShowReal_ then
        return
    end

    self:setLoading(true)

    self:hideRealLists_()

    local realData = tx.userData.realGoodsData
    if realData then
        local index = self.realTitleGroup_:getSelectedTab()
        if index == 1 then
            self.giftList_:show()
            self.giftList_:setData(self:transformRealData_(realData.giftList))
            self:setLoading(false)
        elseif index == 2 then
            self.exchangeList_:show()
            self.exchangeList_:setData(self:transformRealData_(realData.exchangeList))
            self:setLoading(false)
        elseif index == 3 then
            self.antList_:show()
            self.antList_:setData(self:transformRealData_(realData.antList))
            self:setLoading(false)
        end
    end
end

function StoreView:transformRealData_(data)
    return sa.transformDataToGroup(data, RealListItem.ROW_NUM)
end

function StoreView:transformData_(data)
    return sa.transformDataToGroup(data, 3)
end

function StoreView:realTabChanged_(selected)
    if selected == 1 then
        if self.isShowReal_ then
            self:showVirtualView_(TAB_CHIPS)
        else
            self:showVirtualView_(self.index_)
        end
    else
        self:showRealView_()
        self.realTitleGroup_:gotoTab(self.gotoReal_, true)
    end
end

--显示虚拟商品视图
function StoreView:showVirtualView_(index)
    self.isShowReal_ = false

    self.nodeTop:show()
    self.nodeRealTop:hide()

    self:showChannelList_()

    self:hideRealLists_()

    self.titleGroup_:gotoTab(index, true)
end

function StoreView:hideVirtualLists_()
    self.chipsList_:hide()
    self.diamondsList_:hide()
    self.propsList_:hide()
    if self.vipList_ then
        self.vipList_:hide()
    end
end

function StoreView:showDiamondsGoodsView()
    local channelItem = self.channelList_:getListItem(1)
    if channelItem and channelItem.setSelected then
        channelItem:setSelected(true)
    end
    self:showVirtualView_(TAB_DIAMONDS)
end

--显示实物商品视图
function StoreView:showRealView_()
    self.isShowReal_ = true

    self.nodeRealTop:show()
    self.nodeTop:hide()

    self.channelList_:hide()

    self.channelList_.curSelected = nil
    local items = self.channelList_:getListItems()
    if items then
        for _, v in ipairs(items) do
            v:setSelected(false)
        end
    end

    self:hideVirtualLists_()

    self.nodeList:pos(LEFT_WIDTH*0.5,-TOP_HEIGHT*0.5)

    self.realTitleGroup_:gotoTab(1, true)
end

function StoreView:hideRealLists_()
    self.giftList_:hide()
    self.exchangeList_:hide()
    self.antList_:hide()
end

function StoreView:showInputView_(goodsType)
    local list_x, list_y
    local list_w, list_h
    local input_x, input_y = 65, -17
    self.numInput_:setText(sa.LangUtil.getText("STORE", "INPUT_CRAD_NUM"))
    self.passInput_:setText(sa.LangUtil.getText("STORE", "INPUT_CRAD_PASSWORD"))
    self.nodeTop.nodeEdit:show()

    local temp_list_h_1, temp_list_h_2, temp_list_h_3 = LIST_HEIGHT, LIST_HEIGHT_1, LIST_HEIGHT_2
    local temp_list_y_1, temp_list_y_2, temp_list_y_3 = LIST_Y, -INPUT_HEIGHT_1*0.5, -INPUT_HEIGHT_2*0.5
    self.nodeTop.nodeFirstpay:hide()
    if tx.userData.payStatus == 0 and goodsType == TAB_CHIPS then
        self.nodeTop.nodeFirstpay:show()
        temp_list_h_1, temp_list_h_2, temp_list_h_3 = LIST_HEIGHT_3, LIST_HEIGHT_4, LIST_HEIGHT_5
        temp_list_y_1, temp_list_y_2, temp_list_y_3 = -FIRST_HEIGHT*0.5 - TOP_HEIGHT*0.5, -FIRST_HEIGHT_1*0.5, -FIRST_HEIGHT_2*0.5
        self.nodeTop.nodeEdit:setPositionY(-FIRST_HEIGHT - TOP_HEIGHT)
    end

    local channelId = self.curChannel_.id
    -- TODO: fixme not show other pay
    -- if (channelId == PURCHASE_TYPE.BLUE_PAY_COINS or
    --     channelId == PURCHASE_TYPE.BLUE_PAY_TRUEMONEY or
    --     channelId == PURCHASE_TYPE.BLUE_PAY_12CALL) and goodsType == TAB_CHIPS then

    --     list_w, list_h = LIST_WIDTH, temp_list_h_2
    --     list_x, list_y = LIST_X, temp_list_y_2

    --     self.topUpBtn_:show():setPositionY(input_y + 23)
    --     self.numInput_:show():pos(input_x, input_y)
    --     self.passInput_:hide()
    --     self.nodeTop.nodeEdit.divLine:setPositionY(input_y - 80)
    -- else
        list_w, list_h = LIST_WIDTH, temp_list_h_1
        list_x, list_y = LIST_X, temp_list_y_1

        self.topUpBtn_:hide()
        self.numInput_:hide()
        self.passInput_:hide()

        self.nodeTop.nodeEdit:hide()
    -- end

    local list_rect = cc.rect(-0.5 * list_w, -0.5 * list_h, list_w, list_h)

    if self.chipsList_ then
        self.chipsList_:setViewRect(list_rect)
    end

    if self.diamondsList_ then
        self.diamondsList_:setViewRect(list_rect)
    end

    if self.propsList_ then
        self.propsList_:setViewRect(list_rect)
    end

    self.nodeList:pos(list_x, list_y)
end

--卡密支付购买点击
function StoreView:onTopUpClicked_()
    local num = self.numInput_:getText()
    num = string.trim(num)

    local pass = self.passInput_:getText()
    pass = string.trim(pass)

    local channelId = self.curChannel_.id
    if self:isPayByViCard_(channelId) then
        if num == "" or pass == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "INPUT_NUM_PASSWORD_EMPTY"))
            return
        end
    else
        if num == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "INPUT_NUM_EMPTY"))
            return
        end
    end

    local goodsType = self.titleGroup_:getSelectedTab()
    local data = {}
    if self.curChannel_ then
        if goodsType == TAB_CHIPS then
            data = self.controller_.loadedGoods[channelId].chips
        elseif goodsType == TAB_DIAMONDS then
            data = self.controller_.loadedGoods[channelId].diamonds
        elseif goodsType == TAB_PROPS then
            data = self.controller_.loadedGoods[channelId].props
        end
    end

    local cardData = {
        cardNo = num, 
        serialNo = pass,
    }
    self.controller_:makePurchase(data[1], cardData)
end

function StoreView:isPayByViCard_(channelId)
    -- TODO: fixme
    -- if channelId == PURCHASE_TYPE.VI_VNP_CARD
    --     or channelId == PURCHASE_TYPE.VI_VMS_CARD
    --     or channelId == PURCHASE_TYPE.VI_VTT_CARD
    --     or channelId == PURCHASE_TYPE.VI_BLUE_VINAFONE
    --     or channelId == PURCHASE_TYPE.VI_BLUE_MOBIFONE
    --     or channelId == PURCHASE_TYPE.VI_BLUE_VIETTEL
    --     or channelId == PURCHASE_TYPE.VI_BLUE_VTC then

    --     return true
    -- end

    return false
end

function StoreView:onChipsClick_(data)
    self.controller_:makePurchase(data)
end

function StoreView:onDiamondsClick_(data)
    self.controller_:makePurchase(data)
end

function StoreView:onPropsClick_(data)
    self.controller_:makePurchase(data)
end

function StoreView:onBuyRealClicked_(data)
    self.controller_:exchangeRealGoods(data)
end

function StoreView:onCheckoutGuideClicked_()
    CheckoutGuidePopup.new():showPanel()
end

-- controller中回调
function StoreView:createMainUI(channels)
    if channels then
        if #channels<2 then
            self.isShowChannel_ = false
        end
        self:showChannelList_()
        self.channelList_:setData(channels)
        local selectedId = 1
        if self.payType_ then
            for i, v in ipairs(channels) do
                if v.id == self.payType_ then                
                    selectedId = i
                    break
                end
            end
        end

        local channelItem = self.channelList_:getListItem(selectedId)
        if channelItem and channelItem.setSelected then
            channelItem:setSelected(true)
        end
    end

    if self.gotoReal_ > 0 then
        self.mainGroup_:gotoTab(2, true)
    else
        self.mainGroup_:gotoTab(1, true)
    end
end

function StoreView:showChannelList_()
    if self.isShowChannel_ then
        self.channelList_:show()
    else
        self.channelList_:hide()
        self.channelList_.touchNode_:setTouchEnabled(false)

        if appconfig.LANG == "th" and self.checkoutGuideNode_ then
            self.checkoutGuideNode_:show()
        end
    end
end

-- controller中回调
function StoreView:setChannelGoods(paytype, isComplete, data)
    logger:debug("setChannelGoods "..type(data))
    if isComplete and data then
        if type(data)=="table" then
            logger:debug("setChannelGoods 1")
            self:dealViewShow()
        elseif type(data)=="string" then
            logger:debug("setChannelGoods 2")
            if self.curChannel_ and self.curChannel_.id==paytype.id then
            end
        end
    end
end

function StoreView:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(LEFT_WIDTH*0.5, 0)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function StoreView:show()
    StoreView.super.showPanel(self)
    return self
end

function StoreView:onShowed()
    if self.channelList_ then
        self.channelList_:setScrollContentTouchRect()
    end

    if self.chipsList_ then
        self.chipsList_:setScrollContentTouchRect()
    end

    if self.diamondsList_ then
        self.diamondsList_:setScrollContentTouchRect()
    end

    if self.propsList_ then
        self.propsList_:setScrollContentTouchRect()
    end

    if self.giftList_ then
        self.giftList_:setScrollContentTouchRect()
    end

    if self.exchangeList_ then
        self.exchangeList_:setScrollContentTouchRect()
    end

    if self.antList_ then
        self.antList_:setScrollContentTouchRect()
    end
end

function StoreView:onCleanup()
    self.curChannel_ = nil
    self.controller_:dispose()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "diamonds", self.diamondsObserverHandle_)
    sa.DataProxy:removeDataObserver(tx.dataKeys.STORE_CASH_CARD_PAY, self.onCashCardPayObserver_)

    sa.EventCenter:removeEventListener(self.firstPaySuccessId_)

    display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
    display.removeSpriteFramesWithFile("store_texture.plist", "store_texture.png")
end

return StoreView
