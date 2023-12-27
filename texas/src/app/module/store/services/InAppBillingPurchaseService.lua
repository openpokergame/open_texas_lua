local PurchaseHelper = import("..PurchaseHelper")
local InAppBillingPurchaseService = class("InAppBillingPurchaseService", import("..PurchaseServiceBase"))

function InAppBillingPurchaseService:ctor()
    InAppBillingPurchaseService.super.ctor(self, "InAppBillingPurchaseService")

    self.helper_ = PurchaseHelper.new("InAppBillingPurchaseService")

    if device.platform == "android" then
        self.invokeJavaMethod_ = self:createJavaMethodInvoker("com/opentexas/cocoslib/iab/InAppBillingBridge")
        self.invokeJavaMethod_("setSetupCompleteCallback", {handler(self, self.onSetupComplete_)}, "(I)V")
        self.invokeJavaMethod_("setLoadProductsCompleteCallback", {handler(self, self.onLoadProductsComplete_)}, "(I)V")
        self.invokeJavaMethod_("setPurchaseCompleteCallback", {handler(self, self.onPurchaseComplete_)}, "(I)V")
        self.invokeJavaMethod_("setDeliveryMethod", {handler(self, self.doDelivery_)}, "(I)V")
        self.invokeJavaMethod_("setConsumeCompleteCallback", {handler(self, self.onConsumeComplete_)}, "(I)V")
    else
        self.invokeJavaMethod_ = function(method, param, sig)
            if method == "setup" then
                self.schedulerPool_:delayCall(function()
                    self:onSetupComplete_("true")
                end, 1)
            elseif method == "makePurchase" then
                self.schedulerPool_:delayCall(function()
                    self:onPurchaseComplete_([[{"sku":"com.openpoker.chips340k", "originalJson":"{}", "signature":"fakesignature"}]])
                end, 1)
            elseif method == "loadProductList" then
                self.schedulerPool_:delayCall(function()
                    self:onLoadProductsComplete_([[ [{"description":"ไอเทมใช้ได้120ครั้ง\n","price":"THB65.16","sku":"com.openpoker.chips340k","title":"ไอเทม120ครั้ง (เก้าเกไทย)","type":"inapp","priceDollar":"฿"},{"description":"ไอเทมใช้ได้50ครั้ง\n","price":"THB32.00","com.openpoker.chips3.8m":"114999","title":"ไอเทม50ครั้ง  (เก้าเกไทย)","type":"inapp","priceDollar":"฿"},{"description":"40M ชิป\n","price":"THB1,684.64","sku":"com.openpoker.chips8m","title":"40M ชิป (เก้าเกไทย)","type":"inapp","priceDollar":"฿"},{"description":"600K ชิป\n","price":"THB32.00","sku":"com.openpoker.chips30m","title":"600K ชิป (เก้าเกไทย)","type":"inapp","priceDollar":"฿"},{"description":"3.2M ชิป\n","price":"THB165.14","sku":"com.openpoker.chips60m","title":"3.2M ชิป (เก้าเกไทย)","type":"inapp","priceDollar":"฿"}] ]])
                end, 1)
            end
        end
    end
end

function InAppBillingPurchaseService:init(config)
    self.config_ = config
    local success, ret = self.invokeJavaMethod_("isSetupComplete", {}, "()Z")
    if success then
        self.isSetupComplete_ = ret
    end
    success, ret = self.invokeJavaMethod_("isSupported", {}, "()Z")
    if success then
        self.isSupported_ = ret
    end
    if not self.isSetupComplete_ then
        self.isSetuping_ = true
        self.logger:debug("start setup..")
        self.invokeJavaMethod_("setup", {}, "()V")
    end

    if not self.products_ then
        self.logger:debug("remote config is loading..")
        self:configLoadHandler_(self.config_.goods)
    end
end

function InAppBillingPurchaseService:autoDispose()
    InAppBillingPurchaseService.super.autoDispose(self)

    self.isProductPriceLoaded_ = false  --确保每次重新load价格，触发发货检查
    self.isProductRequesting_ = false
    self.invokeJavaMethod_("delayDispose", {60}, "(I)V")
end

function InAppBillingPurchaseService:makePurchase(callback, goods)
    self.purchaseCallback_ = callback
    local params = {}
    self.helper_:generateOrderId(goods, params, function(succ, orderId, msg, orderData)
            if succ then
                local uid = tostring(tx.userData.uid) or ""
                local channel = tostring(tx.userData.channel) or ""
                self.invokeJavaMethod_("makePurchase", {orderId, goods.skus, uid, channel}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
            else
                if msg and msg ~= "" then
                    self:toptip(msg)
                end
            end
        end)
end

--加载商品信息流程
function InAppBillingPurchaseService:loadProcess_()
    if not self.products_ then
        self.logger:debug("remote config is loading..")
        self:configLoadHandler_(self.config_.goods)
    end
    if self.isSetupComplete_ then
        if self.isSupported_ then
            if self.loadCallback_ then
                if self.products_ then
                    if self.isProductPriceLoaded_ then
                        --更新折扣
                        self.helper_:updateDiscount(self.products_)
                        self:invokeCallback_(true, self.products_)
                    elseif not self.isProductRequesting_ then
                        self.isProductRequesting_ = true
                        local joinedSkuList = table.concat(self.products_.skus, ",")
                        self.logger:debug("start loading price...")
                        -- not check from gp
                        -- self:invokeCallback_(false)
                        -- self.invokeJavaMethod_("loadProductList", {joinedSkuList}, "(Ljava/lang/String;)V")
                        self.isProductPriceLoaded_ = true
                        self:loadProcess_()            
                    else
                        self:invokeCallback_(false)
                    end
                else
                    self:invokeCallback_(false)
                end
            end
        else
            self.logger:debug("iab not supported")
            self:invokeCallback_(true, sa.LangUtil.getText("STORE", "NOT_SUPPORT_MSG"))
        end
    elseif self.isSetuping_ then
        self.logger:debug("setuping ...")
        self:invokeCallback_(false)
    else
        self.isSetuping_ = true
        self.logger:debug("start setup..")
        self:invokeCallback_(false)
        self.invokeJavaMethod_("setup", {}, "()V")
    end
end

--Java call lua
function InAppBillingPurchaseService:onSetupComplete_(isSupported)
    self.logger:debug("setup complete.")
    self.isSetuping_ = false
    self.isSetupComplete_ = true
    self.isSupported_ = (isSupported == "true")
    self.logger:debug("isSupported raw:", isSupported)
    self:loadProcess_()
end

--Java call lua
function InAppBillingPurchaseService:onLoadProductsComplete_(jsonString)
    self.logger:debug("price load complete -> " .. jsonString)
    local success = (jsonString ~= "fail")
    self.isProductRequesting_ = false
    if success then
        local products = json.decode(jsonString)
        --更新价格
        if products and self.products_ then
            for i, prd in ipairs(products) do
                if self.products_.all then
                    for j, goods in ipairs(self.products_.all) do
                        if prd.sku == goods.skus then
                            -- 测试 可以再次下单
                            -- if DEBUG >= 5 then
                            --     self.invokeJavaMethod_("consume", {prd.sku}, "(Ljava/lang/String;)V")
                            -- end
                            goods.priceLabel = prd.price
                            if prd.priceNum and prd.priceDollar then
                                goods.priceNum = prd.priceNum
                                goods.priceDollar = prd.priceDollar
                            end
                        end
                    end
                end
            end
            self.isProductPriceLoaded_ = true
            self:loadProcess_()
            return
        end
    end
    self:invokeCallback_(true, sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
end

--Java call lua
function InAppBillingPurchaseService:onPurchaseComplete_(jsonString)
    self.logger:debug("purchase complete -> ", jsonString)
    local success = (string.sub(jsonString, 1, 4) ~= "fail")
    if success then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "PURCHASE_SUCC_AND_DELIVERING"))
        local json = json.decode(jsonString)
        self:delivery(json.sku, json.token, json.originalJson, json.signature, true)
    elseif string.sub(jsonString, 6) == "canceled" then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "PURCHASE_CANCELED_MSG"))
        if self.purchaseCallback_ then
            self.purchaseCallback_(false, "canceled")
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "PURCHASE_FAILED_MSG"))
        if self.purchaseCallback_ then
            self.purchaseCallback_(false, "error")
        end
    end
end

--Java call lua
function InAppBillingPurchaseService:doDelivery_(jsonString)
    self.logger:debug("doDelivery_ ", jsonString)
    local json = json.decode(jsonString)
    self:delivery(json.sku, json.token, json.originalJson, json.signature, false)
    tx.userData.marketData.showCheckout = 0
end

--Java call lua
function InAppBillingPurchaseService:onConsumeComplete_(jsonString)
    self.logger:debug("onConsumeComplete_", jsonString)
end

function InAppBillingPurchaseService:invokeCallback_(isComplete, data)
    if self.loadRequested_ and self.loadCallback_ then
        self.loadCallback_(self.config_, isComplete, data)
    end
end

function InAppBillingPurchaseService:configLoadHandler_(content)
    self.logger:debug("remote config file loaded.")
    self.products_ = self.helper_:parseGoods(content, function(category, product)
    end)
    self.isProductPriceLoaded_ = false
    self:loadProcess_()
end

function InAppBillingPurchaseService:delivery(sku, token, receipt, signature, showMsg)
    local retryLimit = 6
    local deliveryFunc
    local params = {}
    params.mod = "Payment"
    params.act = "success"
    params.channel = self.config_.id
    -- params.pmode = "12"
    params.siteuid = tx.userData.siteuid or ""
    params.uid = tx.userData.uid or ""
    params.signedData = crypto.encodeBase64(receipt)
    params.signature = signature
    -- 新加密流程防刷
    local receiptJson = json.decode(receipt)
    local orderId = (receiptJson and receiptJson.developerPayload)
    if not orderId then orderId="" end
    params.orderId = orderId
    params.time = os.time()
    local sign = crypto.md5(tx.userData.uid.."@2018@"..orderId.."@"..params.time.."&^%")
    params.sign = sign
    deliveryFunc = function()
        sa.HttpService.POST(params, function(data)
                local json = json.decode(data)
                if json and json.code == 1 then
                    -- -- 检查是否为首充 场景需要关闭显示  关闭破产倒计时优惠  保留，现在充值成功server会通知  重新拉取配置
                    -- local brokenData = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
                    -- if self.products_ and self.products_.all then
                    --     for j, goods in ipairs(self.products_.all) do
                    --         if sku == goods.skus then
                    --             -- 首充成功
                    --             if goods.gtype == "4" then
                    --                 tx.userData.payinfo.boughtFirstPayGoods = 1
                    --                 sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
                    --             end
                    --             -- 倒计时商品充值成功
                    --             if brokenData and tonumber(goods.gid)==tonumber(brokenData.gid) then
                    --                 tx.userData.payinfo.brokesalegoods=nil
                    --                 sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
                    --             end
                    --         end
                    --     end
                    -- end
                    self.logger:debug("dilivery success, consume it")
                    self.invokeJavaMethod_("consume", {token}, "(Ljava/lang/String;)V")
                    -- 统计
                    local payGoods = nil
                    if self.products_.all then
                        for j, goods in ipairs(self.products_.all) do
                            if sku == goods.skus then
                                payGoods = goods
                                break
                            end
                        end
                    end

                    if showMsg then
                        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "DELIVERY_SUCC_MSG"))
                        if self.purchaseCallback_ then
                            self.purchaseCallback_(true,nil,payGoods)
                        end
                    end
                else
                    self.logger:debug("delivery failed => " .. data)
                    retryLimit = retryLimit - 1
                    if retryLimit > 0 then
                        self.schedulerPool_:delayCall(function()
                            deliveryFunc()
                        end, 10)
                    else
                        if showMsg then
                            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "DELIVERY_FAILED_MSG"))
                            if self.purchaseCallback_ then
                                self.purchaseCallback_(false, "error")
                            end
                        end
                    end
                end
            end, function() 
                retryLimit = retryLimit - 1
                if retryLimit > 0 then
                    self.schedulerPool_:delayCall(function()
                        deliveryFunc()
                    end, 10)
                else
                    if showMsg then
                        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "DELIVERY_FAILED_MSG"))
                        if self.purchaseCallback_ then
                            self.purchaseCallback_(false, "error")
                        end
                    end
                end
            end)
    end
    deliveryFunc()
end

return InAppBillingPurchaseService
