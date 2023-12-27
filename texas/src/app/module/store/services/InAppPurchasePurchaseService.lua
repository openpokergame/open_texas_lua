local PurchaseHelper = import("..PurchaseHelper")
local Store = import("..Store")

local InAppPurchasePurchaseService = class("InAppPurchasePurchaseService", import("..PurchaseServiceBase"))

function InAppPurchasePurchaseService:ctor()
    self.isRestored_ = false
    InAppPurchasePurchaseService.super.ctor(self, "InAppPurchasePurchaseService")
    self.helper_ = PurchaseHelper.new("InAppBillingPurchaseService")
    self.store_ = Store.new()
    self.store_:addEventListener(Store.LOAD_PRODUCTS_FINISHED, handler(self, self.loadProductFinished_))
    self.store_:addEventListener(Store.TRANSACTION_PURCHASED, handler(self, self.transactionPurchased_))
    self.store_:addEventListener(Store.TRANSACTION_RESTORED, handler(self, self.transactionRestored_))
    self.store_:addEventListener(Store.TRANSACTION_FAILED, handler(self, self.transactionFailed_))
    self.store_:addEventListener(Store.TRANSACTION_UNKNOWN_ERROR, handler(self, self.transactionUnkownError_))
end

function InAppPurchasePurchaseService:init(config)
    self.active_ = true
	self.config_ = config
    self.isPurchasing_ = false
    self.isSupported_ = self.store_:canMakePurchases()
    if not self.products_ then
        self.logger:debug("remote config is loading..")
        self:configLoadHandler_(self.config_.goods)
    end
    if self.isRestored_ then   -- 初次就不用了
        local payInfoStr = tx.userDefault:getStringForKey(tx.cookieKeys.IOS_ORDER_INFO) --危险，还没支付就开始询问支付账号和密码了...
        if payInfoStr and payInfoStr~="" then
            self.store_:restore()  -- 此处会询问输入appaccount and password
        end
    end
    self.isRestored_ = true
end

function InAppPurchasePurchaseService:autoDispose()
    InAppPurchasePurchaseService.super.autoDispose(self)

    self.isProductPriceLoaded_ = false
    self.isProductRequesting_ = false
end

function InAppPurchasePurchaseService:loadProcess_()
    if not self.isSupported_ then
        self.logger:debug("iap not supported")
        self:invokeCallback_(true, sa.LangUtil.getText("STORE", "NOT_SUPPORT_MSG"))
    else
        if not self.products_ then
            self.logger:debug("remote config is loading..")
            self:configLoadHandler_(self.config_.goods)
        end
        if self.loadRequested_ then
            if self.products_ then
                if self.isProductPriceLoaded_ then
                    --更新折扣
                    self.helper_:updateDiscount(self.products_)
                    self:invokeCallback_(true, self.products_)
                elseif not self.isProductRequesting_ then
                    self.isProductRequesting_ = true
                    self.logger:debug("start loading price...")
                    -- self:invokeCallback_(false)
                    -- self.store_:loadProducts(self.products_.skus)
                    self.isProductPriceLoaded_ = true
                    self:loadProcess_()
                else
                    self:invokeCallback_(false)
                end
            else
                self:invokeCallback_(false)
            end
        else
            self:invokeCallback_(false)
        end
    end
end

function InAppPurchasePurchaseService:invokeCallback_(isComplete, data)
    if self.loadRequested_ and self.loadCallback_ then
        self.loadCallback_(self.config_, isComplete, data)
    end
end

function InAppPurchasePurchaseService:configLoadHandler_(content)
    self.logger:debug("remote config file loaded.")
    self.products_ = self.helper_:parseGoods(content, function(category, json, product)
    end)

    self:loadProcess_()
end

function InAppPurchasePurchaseService:makePurchase(callback, goods)
    if self.isPurchasing_ then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "BUSY_PURCHASING_MSG"))
        return
    end

    self.purchaseCallback_ = callback
    local params = {}
    self.isPurchasing_ = true
    self.helper_:generateOrderId(goods, params, function(succ, orderId, msg, orderData)
        if succ then
            self.orderId_ = orderId

            local uid = tostring(tx.userData.uid) or ""
            local channel = tostring(tx.userData.channel) or ""

            local finalPid = goods.skus
            self.store_:purchaseProduct(finalPid)
            self.isPurchasing_ = true
            self:restoreOrderInfo(goods.gid,orderId,"chips")
        else
            self.isPurchasing_ = false
            self:clearOrderInfo()
            if msg and msg ~= "" then
                tx.TopTipManager:showToast(msg)
            end
        end
    end)
end

function InAppPurchasePurchaseService:restoreOrderInfo(gid,orderId,ptype)
    local payInfoStr = gid .. "#" .. orderId .. "#" .. ptype
    tx.userDefault:setStringForKey(tx.cookieKeys.IOS_ORDER_INFO, payInfoStr)
    tx.userDefault:flush()
end

function InAppPurchasePurchaseService:clearOrderInfo()
    tx.userDefault:setStringForKey(tx.cookieKeys.IOS_ORDER_INFO, "")
    tx.userDefault:flush()
end

--OC to lua
function InAppPurchasePurchaseService:loadProductFinished_(evt)
    self.isProductRequesting_ = false
    local function getPriceLabel(prd)
        return luaoc.callStaticMethod(
            "LuaOCBridge", 
            "getPriceLabel", 
            {
                priceLocale = prd.priceLocale, 
                price = prd.price, 
            }
        )
    end
    if evt.products and #evt.products > 0 then
        --更新价格
        for i, prd in ipairs(evt.products) do
            if self.products_.all then
                for j, goods in ipairs(self.products_.all) do
                    if prd.productIdentifier == goods.skus then
                        local ok, price = getPriceLabel(prd)
                        if ok then
                            goods.priceLabel = price
                        else
                            goods.priceLabel = prd.price
                        end
                        goods.priceNum = prd.price
                    end
                end
            end
        end
        self.isProductPriceLoaded_ = true
        self:loadProcess_()
        return
    end
    self:invokeCallback_(true, sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
end

--OC to lua
function InAppPurchasePurchaseService:transactionPurchased_(evt)
    tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "PURCHASE_SUCC_AND_DELIVERING"))
    self:delivery(evt.transaction, true)
end

--OC to lua
function InAppPurchasePurchaseService:transactionRestored_(evt)
    
    local payInfoStr = tx.userDefault:getStringForKey(tx.cookieKeys.IOS_ORDER_INFO)
    if payInfoStr and payInfoStr ~= "" then
        local payTb = string.split(payInfoStr,"#")
        if payTb and payTb[2] then
          self.orderId_ = payTb[2]
        end
    end
    self.isPurchasing_ = true
    self:delivery(evt.transaction, false)
end

--OC to lua
function InAppPurchasePurchaseService:transactionFailed_(evt)
    if self.purchaseCallback_ then
        self.purchaseCallback_(false, "AppPurchaseError")
    end
    self.isPurchasing_ = false
    self:clearOrderInfo()
end

--OC to lua
function InAppPurchasePurchaseService:transactionUnkownError_(evt)
    if self.purchaseCallback_ then
        self.purchaseCallback_(false, "AppPurchaseError")
    end
    self.isPurchasing_ = false
    self:clearOrderInfo()
end

function InAppPurchasePurchaseService:delivery(transaction, showMsg)
    local date = transaction.date
    local errorCode = transaction.errorCode
    local errorString = transaction.errorString
    local productIdentifier = transaction.productIdentifier
    local quantity = transaction.quantity
    local receipt = crypto.encodeBase64(transaction.receipt)
    local receiptVerifyMode = transaction.receiptVerifyMode
    local receiptVerifyStatus = transaction.receiptVerifyStatus
    local state = transaction.state
    local transactionIdentifier = transaction.transactionIdentifier

    local productId = string.gsub(productIdentifier,"%D","")
    productId = string.sub(productId, 2, string.len(productId))

    local params = {}
    params.orderId = self.orderId_ or ""  -- 新流程不需要
    params.pdealno = transactionIdentifier
    params.receipt = receipt
    -- params.pmode = self.config_.pmode
    params.id = productId or ""
    params.mod = "Payment"
    params.act = "success"
    params.channel = self.config_.id
    params.siteuid = tx.userData.siteuid or ""
    params.uid = tx.userData.uid or ""
    -- 新加密流程防刷
    params.time = os.time()
    local sign = crypto.md5(tx.userData.uid.."@2018@"..params.orderId.."@"..params.time.."&^%")
    params.sign = sign


    if IS_SANDBOX then
        params.isSandbox = 1
    end

    local retryLimit = 6
    local deliveryFunc
    deliveryFunc = function()
            sa.HttpService.POST(params, function(data)
                    local jsn = json.decode(data)
                    if jsn then
                        local ErrorCode = tonumber(jsn.code)
                        if ErrorCode == 1 then
                            self.logger:debug("dilivery success, consume it")

                            self.store_:finishTransaction(transaction)
                            -- 统计
                            local payGoods = nil
                            if productIdentifier and self.products_.all then
                                for j, goods in ipairs(self.products_.all) do
                                    if productIdentifier == goods.gpid then
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
                            self.isPurchasing_ = false
                            self:clearOrderInfo()

                        elseif ErrorCode == -1 then
                            --发过货的订单
                            if showMsg then
                                tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "DELIVERY_FAILED_MSG"))
                                if self.purchaseCallback_ then
                                    self.purchaseCallback_(false, "error")
                                end
                            end
                            self.store_:finishTransaction(transaction)
                            self.isPurchasing_ = false
                            self:clearOrderInfo()

                        elseif ErrorCode == 6 then
                            --交易号重复的订单
                            local realPid = jsn.realPid
                            local realStatus = jsn.realStatus
                            if 0 == realStatus then
                                --交易号在其他订单号使用过，但未曾发货
                               
                                if params and realPid and realPid ~= "" then
                                 --获取交易号所在的订单号重新请求发货
                                    params.orderId = realPid

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
                                        self.isPurchasing_ = false
                                        self:clearOrderInfo()
                                    end
                                else
                                    self.store_:finishTransaction(transaction)
                                    if showMsg then
                                        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "DELIVERY_FAILED_MSG"))
                                        if self.purchaseCallback_ then
                                            self.purchaseCallback_(false, "error")
                                        end
                                    end
                                    self.isPurchasing_ = false
                                    self:clearOrderInfo()
                                end
                            elseif 2 == realStatus then
                                --交易号在其他订单号使用过，且已发货,需要清除IAP记录
                                self.store_:finishTransaction(transaction)
                                self.isPurchasing_ = false
                                self:clearOrderInfo()
                            end
                        end
     
                    else
                        self.logger:debug("delivery failed => " .. json.encode(jsn))
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
                            self.isPurchasing_ = false
                            -- self:clearOrderInfo()
                        end
                    end
                end,
                function()
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

return InAppPurchasePurchaseService
