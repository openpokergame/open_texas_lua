local PurchaseServiceManager = import(".PurchaseServiceManager")
local StoreController = class("StoreController")
local logger = sa.Logger.new("StoreController")
local PURCHASE_TYPE = import(".PURCHASE_TYPE")

local CHANNEL_ICON_CFG = {
    [PURCHASE_TYPE.IN_APP_BILLING]      = "#store/channel_googleplay.png",
    [PURCHASE_TYPE.IN_APP_PURCHASE]     = "#store/channel_appstore.png",
}

function StoreController:ctor(view)
    self.view_ = view
    self.manager_ = PurchaseServiceManager:getInstance()
    self.schedulerPool_ = sa.SchedulerPool.new()
end

function StoreController:loadPayConfig()
    if tx.userData.marketData then
        logger:debug("loadPayConfig .. user preLoad")
        self:onGetedCfg()
        return
    end

    logger:debug("loadPayConfig ..")
    local retryTimes = 3
    local loadPayConfig
    loadPayConfig = function ()
        sa.HttpService.CANCEL(self.loadListConfig_)
        self.loadListConfig_ = sa.HttpService.POST({
            mod = "Goods",
            act = "getGoods",
        },
        function(data)
            local tb = json.decode(data)
            -- tb = {
            --     code = 1,
            --     list = {
            --         [1] = {
            --             goods = {
            --                 {
            --                     gid="1",
            --                     gpid="com.openpoker.chips340k",
            --                     gprice="1",
            --                     gpriceThb="34",
            --                     gname="ชิป340K",
            --                     gdesc="เงินชิป340K",
            --                     gtype="1",
            --                     gbaseReward='{"money":340000}',
            --                     gaddPro="0",
            --                     gactivityReward="0",
            --                     gdiscount="10",
            --                     gchannel="1",
            --                     gsort="10",
            --                     gstatus="1",
            --                     gattribute="1",
            --                     ggameid="1",
            --                     gplatform="1"
            --                 }
            --             }
            --         }
            --     }
            -- }
            if tb and tb.code == 1 then --请求成功
                logger:debug("loadPayConfig complete")
                tx.userData.marketData = tb
                self:onGetedCfg()
            else
                retryTimes = retryTimes - 1 --请求失败后， 重试次数，3次以后还失败，就关闭商城界面
                if retryTimes > 0 then
                    loadPayConfig()
                end
            end
        end,
        function()
            retryTimes = retryTimes - 1
            if retryTimes > 0 then
                loadPayConfig()
            end
        end)
    end
    loadPayConfig()
end
--[[
{
    "code":1,
    "list":{
        "1":{   支付渠道  PURCHASE_TYPE
            "id":1; 渠道ID;
            "payLevel":排序;
            "goods":[   gtype 类型 1:筹码;2:钻石;3:互动道具;4:礼包;5:喇叭;
                {"gtype"},{},
            ]
        }
    }
}
--]]
function StoreController:onGetedCfg()
    -- if not self.view_ then return; end --苹果一进入游戏就让输入苹果账号的密码 略坑  InAppPurchasePurchaseService:restore
    local tb = tx.userData.marketData
    local payTypeAvailable = {}
    for i, p in pairs(tb.list) do
        p.id = tonumber(i)
        p.payLevel = tonumber(i)
        p.show = tonumber(p.show)  -- 是否要展示在主商城 解决玩家升级后就打开了第三方支付问题
        if p and p.goods and type(p.goods)=="table" and p.goods[1] then
            p.payLevel = tonumber(p.goods[1].gchannel_sort) or p.payLevel
        end
        p.img = CHANNEL_ICON_CFG[p.id]
        if self.manager_:isServiceAvailable(p.id) then
            payTypeAvailable[#payTypeAvailable + 1] = p
        end
    end
    
    --在这对支付列表排序
    table.sort(payTypeAvailable, function(a, b)
        return a.payLevel < b.payLevel
    end)
    if self.view_ and self.view_.createMainUI then  -- 主商城才会有
        local showChannels = {}
        for k,v in ipairs(payTypeAvailable) do
            if v.show==1 then
                table.insert(showChannels,v)
            end
        end
        self.view_:createMainUI(showChannels)
    end
    self.loadedGoods = {} -- 第三方验证通过价格本地化完成
    self.manager_:init(payTypeAvailable, true)
    -- 记得一定要dispose
    for k,v in ipairs(payTypeAvailable) do
        self:setLoadedProductListCallBack(v)
    end
end

function StoreController:getPurchaseService_(paytype)
    return self.manager_:getPurchaseService(paytype.id)
end

function StoreController:setLoadedProductListCallBack(paytype)
    local service = self:getPurchaseService_(paytype)
    if service then
        service:setLoadedProductCallBack(handler(self, self.loadProductListResult_))
    end
end

function StoreController:loadProductListResult_(paytype, isComplete, data)
    if self.loadedGoods and isComplete and type(data)=="table" then
        self.loadedGoods[paytype.id] = data
    end

    if self.view_ and self.view_.setChannelGoods then
        logger:debug("loadProductListResult_")
        self.view_:setChannelGoods(paytype, isComplete, data)
    end
end

function StoreController:makePurchase(goods, cardData)
    local service = self.manager_:getPurchaseService(tonumber(goods.gchannel))
    if service then
        service:makePurchase(handler(self, self.purchaseResult_), goods, cardData)
    end
end

function StoreController:purchaseResult_(succ, result, goods)
    if succ then
    else
        if result == "AppPurchaseError" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "PURCHASE_FAILED_MSG"))
        end
    end
end

function StoreController:combineFirstPayData(firstpayData_, marketData_)
    if firstpayData_ and marketData_ then
        for i, p in ipairs(marketData_.payTypes) do
            for j = 1, #firstpayData_ do
                if p.pmode == firstpayData_[j].pmode then
                    p.goods[#p.goods] = firstpayData_[j]
                end
            end
        end
    end
end

function StoreController:removeFirstPayData(firstpayData_, marketData_)
    if firstpayData_ and marketData_ then
        for i, p in ipairs(marketData_.payTypes) do
            for j = 1, #firstpayData_ do
                if p.pmode == firstpayData_[j].pmode then
                    for m = 1, #p.goods do
                        if p.goods[m].id == firstpayData_[j].id then
                            p.goods[m] = nil
                        end
                    end
                end
            end
        end
    end
end

--获取VIP商品配置
function StoreController:loadVipGoodsConfig()
    if tx.userData.vipGoodsData then
        logger:debug("loadVipConfig .. user preLoad")
        self:onGetVipGoodsData_()
        return
    end

    logger:debug("loadVipConfig ..")
    local retryTimes = 3
    local loadVipConfig
    loadVipConfig = function ()
        sa.HttpService.CANCEL(self.loadVipRequestId_)
        self.loadVipRequestId_ = sa.HttpService.POST({
            mod = "Vip",
            act = "getConfig",
        },
        function(data)
            local tb = json.decode(data)
            if tb and tb.code == 1 then
                logger:debug("loadVipConfig complete")
                local list = {}
                for k, v in pairs(tb.list) do
                    list[tonumber(k)] = v
                end
                tx.userData.vipGoodsData = list

                self:onGetVipGoodsData_()
            else
                retryTimes = retryTimes - 1
                if retryTimes > 0 then
                    loadVipConfig()
                end
            end
        end,
        function()
            retryTimes = retryTimes - 1
            if retryTimes > 0 then
                loadVipConfig()
            end
        end)
    end

    loadVipConfig()
end

function StoreController:onGetVipGoodsData_()
    if self.view_ and self.view_.setChannelGoods then
        self.view_:setChannelGoods(nil, true, tx.userData.vipGoodsData)
    end
end

--获取实物兑换配置
function StoreController:loadRealGoodsConfig()
    if tx.userData.realGoodsData then
        logger:debug("getRealConfig .. user preLoad")
        self:onGetRealGoodsData_()
        return
    end

    logger:debug("getRealConfig ..")
    local retryTimes = 3
    local loadRealConfig
    loadRealConfig = function ()
        sa.HttpService.CANCEL(self.loadRealRequestId_)
        self.loadRealRequestId_ = sa.HttpService.POST({
            mod = "Mall",
            act = "getList",
        },
        function(data)
            local tb = json.decode(data)
            if tb and tb.code == 1 then --请求成功
                logger:debug("loadRealConfig complete")

                self:parseRealGoodsData_(tb.list)
            else
                retryTimes = retryTimes - 1 --请求失败后， 重试次数，3次以后还失败，就关闭商城界面
                if retryTimes > 0 then
                    loadRealConfig()
                end
            end
        end,
        function()
            retryTimes = retryTimes - 1
            if retryTimes > 0 then
                loadRealConfig()
            end
        end)
    end

    loadRealConfig()
end

function StoreController:parseRealGoodsData_(data)
    local realLists = {}

    local giftList = {}
    realLists.giftList = giftList

    local exchangeList = {}
    realLists.exchangeList = exchangeList

    local antList = {}
    realLists.antList = antList

    for _, v in ipairs(data) do
        v.img = tx.userData.mallDomain .. v.img
        if v.coupon == 1 then --礼品券
            table.insert(giftList, v)
        elseif v.coupon == 2 then  --兑换券
            table.insert(exchangeList, v)             
        elseif v.coupon == 3 then --开源币
            table.insert(antList, v)
        end
    end

    for _, v in pairs(realLists) do
        self:sortRealGoods_(v)
    end

    tx.userData.realGoodsData = realLists

    self:onGetRealGoodsData_()
end

function StoreController:sortRealGoods_(data)
    table.sort(data, function(a, b) 
        if tonumber(a.sort) == tonumber(b.sort) then
            return tonumber(a.num) < tonumber(b.num)
        else
            return tonumber(a.sort) > tonumber(b.sort)
        end
    end)
end

--兑换实物
function StoreController:exchangeRealGoods(goods)
    sa.HttpService.POST({
        mod = "Mall",
        act = "exchange",
        mid = goods.id
    },
    function(data)
        local ret = json.decode(data)
        if ret.code == 1 then --请求成功
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "EXCHANGE_REAL_SUCCESS", goods.name))
        elseif ret.code == -3 then
            local textList = sa.LangUtil.getText("STORE","REAL_TAB_LIST")
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "EXCHANGE_REAL_FAILED_1", textList[goods.coupon], goods.name, goods.price))
        end
    end,
    function()
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "EXCHANGE_REAL_FAILED_2"))
    end)
end

function StoreController:onGetRealGoodsData_()
    local len = 2  -- 两个外部语言设置
    local dealShowFun = function()
        if len<1 and tx.userData and tx.userData.realGoodsData and self.view_ and self.view_.dealRealViewShow then
            self.view_:dealRealViewShow()
        end
    end
    if tx.userData.mallGoodsNameJsonDomain then
        sa.cacheFile(tx.userData.mallGoodsNameJsonDomain, function(result, content)
            len = len - 1
            if result == "success" then  -- 替换名字
                local data = json.decode(content)
                if data and tx.userData and tx.userData.realGoodsData then
                    for kkk,vvv in pairs(data) do
                        for k,v in pairs(tx.userData.realGoodsData) do
                            local isFinded = false
                            for kk,vv in pairs(v) do
                                if tonumber(vv.id)==tonumber(kkk) then
                                    vv.name = vvv
                                    isFinded = true
                                    break;
                                end
                            end
                            if isFinded then
                                break;
                            end
                        end
                    end
                end
            end
            dealShowFun()
        end, "level")
    else
        len = len - 1
        dealShowFun()
    end
    
    if tx.userData.mallCouponNameJsonDomain then
        sa.cacheFile(tx.userData.mallCouponNameJsonDomain, function(result, content)
            len = len - 1
            if result == "success" then
                local data = json.decode(content)
                if data and tx.userData and tx.userData.realGoodsData then
                    for kkk,vvv in pairs(data) do
                        for k,v in pairs(tx.userData.realGoodsData) do
                            local isFinded = false
                            for kk,vv in pairs(v) do
                                if tonumber(vv.id)==tonumber(kkk) then
                                    vv.couponName = vvv
                                    isFinded = true
                                    break;
                                end
                            end
                            if isFinded then
                                break;
                            end
                        end
                    end
                end
            end
            dealShowFun()
        end, "level")
    else
        len = len - 1
        dealShowFun()
    end
end

function StoreController:init()
    self:loadPayConfig()

    self:loadRealGoodsConfig()

    self:loadVipGoodsConfig()
end

function StoreController:dispose()
    self.loadedGoods = nil
    if self.loadListConfig_ then
        sa.HttpService.CANCEL(self.loadListConfig_)
        self.loadListConfig_ = nil
    end

    if self.loadRealRequestId_ then
        sa.HttpService.CANCEL(self.loadRealRequestId_)
        self.loadRealRequestId_ = nil
    end

    if self.loadVipRequestId_ then
        sa.HttpService.CANCEL(self.loadVipRequestId_)
        self.loadVipRequestId_ = nil
    end

    self.schedulerPool_:clearAll()
    self.manager_:autoDispose()

    self.view_ = nil
end

return StoreController
