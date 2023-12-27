--官方商城，只显示官方支付方式的商品
local PURCHASE_TYPE = import(".PURCHASE_TYPE")

local OfficialStorePopup = class("OfficialStorePopup", tx.ui.EditPanel)
local logger = sa.Logger.new("OfficialStorePopup")

local StoreController = import(".StoreController")
local ChannelItem = import(".views.ChannelItem")
local ChipsListItem = import(".views.ChipsListItem")
local DiamondsListItem = import(".views.DiamondsListItem")
local PropsListItem = import(".views.PropsListItem")
local ProductRecordPopup = import(".views.ProductRecordPopup")
local AddressPopup = import(".views.AddressPopup")
local CashCardTipsPopup = import(".views.CashCardTipsPopup")
local ProductVipList = import(".views.ProductVipList")

local TOP_LEFT_H = 314  -- 左上部高度
local LEFT_WIDTH = 346      -- 左边渠道宽度
local RIGHT_WIDTH = display.width - LEFT_WIDTH --右边框宽度
local TOP_HEIGHT = 100      -- 上部高度 不包括输入框
local FIRST_HEIGHT = 166 --首充背景
local LIST_WIDTH = display.width - LEFT_WIDTH
local LIST_HEIGHT = display.height - TOP_HEIGHT
local LIST_HEIGHT_1  = display.height - TOP_HEIGHT - FIRST_HEIGHT

local LIST_X, LIST_Y = LEFT_WIDTH*0.5, -TOP_HEIGHT*0.5

ChannelItem.WIDTH = LEFT_WIDTH

local normalColor = cc.c3b(0x67,0x59,0x94)
local selectColor = cc.c3b(0xff,0xf7,0xb7)

local TAB_CHIPS     = 1  --筹码
local TAB_DIAMONDS  = 2  --钻石
local TAB_PROPS     = 3  --道具
local TAB_VIP       = 4  --VIP

OfficialStorePopup.ELEMENTS = {
    "bg",
    "nodeList",

    "nodeLeft.bg",
    "nodeTop.iconChips.label",
    "nodeTop.iconDiamond.label",

    "nodeTop.bg",
    "nodeTop.btnRecord",
    "nodeTop.btnClose",

    "nodeTop.nodeFirstpay.bg",
    "nodeTop.nodeFirstpay.title",
    "nodeTop.nodeFirstpay.reward1.label",
    "nodeTop.nodeFirstpay.reward2.label",
    "nodeTop.nodeFirstpay.reward3.label",
}

local GOODS_TYPE_IMAGES = {
    {
        on = "#store/chips_icon_on.png",
        off = "#store/chips_icon_off.png"
    },
    {
        on = "#store/diamonds_icon_on.png",
        off = "#store/diamonds_icon_off.png"
    },
    {
        on = "#store/prop_icon_on.png",
        off = "#store/prop_icon_off.png"
    },
    {
        on = "#store/vip_icon_on.png",
        off = "#store/vip_icon_off.png"
    },
}

function OfficialStorePopup:ctor(index)
    OfficialStorePopup.super.ctor(self,"officialstore.csb",true) 

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

    _G.buyFromScene = 1

    self:initPosition_()

    self:initViews_()

    self.controller_:init()
end

function OfficialStorePopup:initPosition_()
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

    self.nodeList:pos(LEFT_WIDTH*0.5,-TOP_HEIGHT*0.5)
end

function OfficialStorePopup:initViews_()
    self:initVirtualViews_()

    self:addGoodsTypeTab_()

    self:addEventListeners_()
end

--虚拟商品
function OfficialStorePopup:initVirtualViews_()
    -- 支付列表
    local list_w,list_h = LEFT_WIDTH - 18, display.height-TOP_LEFT_H
    self.channelList_ = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * list_w, -0.5 * list_h, list_w, list_h),
            direction = sa.ui.ListView.DIRECTION_VERTICAL
        }, ChannelItem)
        :pos(list_w*0.5,-TOP_LEFT_H-list_h*0.5)
        :addTo(self.nodeLeft)
        :hideScrollBar()
    self.channelList_:hide() -- 只有官方支付，强制隐藏
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

    --first
    local firstGoodsDesc = sa.LangUtil.getText("PAYGUIDE", "FIRST_GOODS_DESC_2")
    for i=1,3 do
        local label = self.nodeTop.nodeFirstpay["reward"..i].label
        label:setString(firstGoodsDesc[i])
        sa.fitSprteWidth(label, 130)
    end
    self.nodeTop.nodeFirstpay:hide()

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

function OfficialStorePopup:addGoodsTypeTab_()
    local title = sa.LangUtil.getText("STORE","TOP_LIST")
    title = clone(title)
    if tx.config.SHOW_VIP~=1 then
        table.remove(title, TAB_VIP)
    end

    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    self.titleGroup_ = tabGroup
    local dir = 98
    local x, y = 164,  -155
    local offsetY = {0, 0, 0, -5}
    for i = 1, #title do
        local onNode = self:createGoodsTypeIcon_(GOODS_TYPE_IMAGES[i].on, title[i], cc.c3b(0xff, 0xff, 0xff), offsetY[i])
        local offNode = self:createGoodsTypeIcon_(GOODS_TYPE_IMAGES[i].off, title[i], cc.c3b(0x67, 0x54, 0xc5), offsetY[i])
        local btn = cc.ui.UICheckBoxButton.new({on="#store/tab3.png", off="#store/tab1.png", off_pressed = "#store/tab2.png"})
            :setButtonLabel("on", onNode)
            :setButtonLabel("off", offNode)
            :setButtonLabelOffset(-55, 0)
            :align(display.TOP_CENTER, x, y)
            :addTo(self.nodeLeft)

        tabGroup:addButton(btn)

        y = y - dir
    end

    tabGroup:getButtonAtIndex(self.index_):setButtonSelected(true):updateButtonLable_() --刷新label状态，感觉是引擎bug
    tabGroup:onButtonSelectChanged(handler(self, self.dealViewShow))
end

function OfficialStorePopup:createGoodsTypeIcon_(icon, title, titleColor, offsetY)
    local node = display.newNode()
    local x = -15
    display.newSprite(icon)
        :pos(x, 0)
        :addTo(node)

    ui.newTTFLabel({text = title, size = 36, color = titleColor})
        :align(display.LEFT_CENTER, x + 45, offsetY)
        :addTo(node)

    return node
end

--创建商品列表
function OfficialStorePopup:createGoodsList_(item)
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

function OfficialStorePopup:addEventListeners_()
    -- 数据
    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", function (chips)
        if not chips then return end
        self.nodeTop.iconChips.label:setString(sa.formatNumberWithSplit(chips))
        self.nodeTop.iconDiamond.label:setString(sa.formatNumberWithSplit(tx.userData.diamonds))
    end)

    self.diamondsObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "diamonds", function (diamonds)
        if not diamonds then return end
        self.nodeTop.iconDiamond.label:setString(sa.formatNumberWithSplit(diamonds))
    end)

    self.firstPaySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_FIRST_PAY_SUCCESS, function()
        self:hidePanel()
    end)
end

function OfficialStorePopup:onChannelClick_(data)
    self.curChannel_ = data
    self:dealViewShow()
end

function OfficialStorePopup:dealViewShow()
    logger:debug("dealViewShow x ")
    self:setLoading(true)

    self:hideVirtualLists_()

    local goodsType = self.titleGroup_:getSelectedIndex()
    if self.curChannel_ then
        logger:debug("dealViewShow x "..self.curChannel_.id)
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

function OfficialStorePopup:transformData_(data)
    return sa.transformDataToGroup(data, 3)
end

--显示虚拟商品视图
function OfficialStorePopup:showVirtualView_(index)
    self.nodeTop:show()

    self.titleGroup_:getButtonAtIndex(index):setButtonSelected(true)
end

function OfficialStorePopup:hideVirtualLists_()
    self.chipsList_:hide()
    self.diamondsList_:hide()
    self.propsList_:hide()
    if self.vipList_ then
        self.vipList_:hide()
    end
end

function OfficialStorePopup:showDiamondsGoodsView()
    local channelItem = self.channelList_:getListItem(self.channelSelectedId_)
    if channelItem and channelItem.setSelected then
        channelItem:setSelected(true)
    end
    self:showVirtualView_(TAB_DIAMONDS)
end

function OfficialStorePopup:showInputView_(goodsType)
    local list_x, list_y = LIST_X, LIST_Y
    local list_w, list_h = LIST_WIDTH, LIST_HEIGHT
    local input_x, input_y = 65, -17

    self.nodeTop.nodeFirstpay:hide()
    if tx.userData.payStatus == 0 and goodsType == TAB_CHIPS then
        self.nodeTop.nodeFirstpay:show()
        list_h = LIST_HEIGHT_1
        list_y = -FIRST_HEIGHT*0.5 - TOP_HEIGHT*0.5
    end

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

function OfficialStorePopup:onChipsClick_(data)
    self.controller_:makePurchase(data)
end

function OfficialStorePopup:onDiamondsClick_(data)
    self.controller_:makePurchase(data)
end

function OfficialStorePopup:onPropsClick_(data)
    self.controller_:makePurchase(data)
end

-- controller中回调
function OfficialStorePopup:createMainUI(channels)
    if channels then
        self.channelList_:setData(channels)
        local selectedId = 1
        for i, v in ipairs(channels) do
            if v.id == PURCHASE_TYPE.OFFICIAL_PAY then                
                selectedId = i
                break
            end
        end

        self.channelSelectedId_ = selectedId
        local channelItem = self.channelList_:getListItem(selectedId)
        if channelItem and channelItem.setSelected then
            channelItem:setSelected(true)
        end
    end
end

-- controller中回调
function OfficialStorePopup:setChannelGoods(paytype, isComplete, data)
    logger:debug("setChannelGoodsx ", type(data), isComplete)
    if isComplete and data then
        if type(data)=="table" then
            logger:debug("setChannelGoodsx 1 ")
            self:dealViewShow()
        elseif type(data)=="string" then
            logger:debug("setChannelGoodsx 2 ")
            if self.curChannel_ and self.curChannel_.id==paytype.id then
            end
        end
    end
end

function OfficialStorePopup:setLoading(isLoading)
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

function OfficialStorePopup:show()
    OfficialStorePopup.super.showPanel(self)
    return self
end

function OfficialStorePopup:onShowed()
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
end

function OfficialStorePopup:onCleanup()
    self.curChannel_ = nil
    self.controller_:dispose()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "diamonds", self.diamondsObserverHandle_)

    sa.EventCenter:removeEventListener(self.firstPaySuccessId_)

    display.removeSpriteFramesWithFile("aboutpay_texture.plist", "aboutpay_texture.png")
    display.removeSpriteFramesWithFile("store_texture.plist", "store_texture.png")
end

return OfficialStorePopup
