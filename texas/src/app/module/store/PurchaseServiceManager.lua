
local InAppBillingPurchaseService   = import(".services.InAppBillingPurchaseService")
local InAppPurchasePurchaseService   = import(".services.InAppPurchasePurchaseService")

local PURCHASE_TYPE = import(".PURCHASE_TYPE")

local PurchaseServiceManager = class("PurchaseServiceManager")

function PurchaseServiceManager:getInstance()
    if not PurchaseServiceManager.instance_ then
        PurchaseServiceManager.instance_ = PurchaseServiceManager.new()
    end
    return PurchaseServiceManager.instance_
end

function PurchaseServiceManager:ctor()
    self.availablePurchaseService_ = {}
    self.purchaseServices_ = {}
    if device.platform == "android" then
        PURCHASE_TYPE.OFFICIAL_PAY = PURCHASE_TYPE.IN_APP_BILLING
        self.availablePurchaseService_[PURCHASE_TYPE.IN_APP_BILLING] = InAppBillingPurchaseService
    elseif device.platform == "ios" then
        PURCHASE_TYPE.OFFICIAL_PAY = PURCHASE_TYPE.IN_APP_PURCHASE
        self.availablePurchaseService_[PURCHASE_TYPE.IN_APP_PURCHASE] = InAppPurchasePurchaseService
    elseif device.platform == "windows" then
        PURCHASE_TYPE.OFFICIAL_PAY = PURCHASE_TYPE.IN_APP_BILLING
        self.availablePurchaseService_[PURCHASE_TYPE.IN_APP_BILLING] = InAppBillingPurchaseService
        self.availablePurchaseService_[PURCHASE_TYPE.IN_APP_PURCHASE] = InAppPurchasePurchaseService
    end
end

function PurchaseServiceManager:isServiceAvailable(serviceId)
    return self.availablePurchaseService_[serviceId]
end

function PurchaseServiceManager:init(payConfig, isLoadData)
    for i, config in ipairs(payConfig) do
        local PurchaseServiceClass = self.availablePurchaseService_[config.id]
        local purchaseServiceInstance_ = self.purchaseServices_[config.id]
        if PurchaseServiceClass then
            if not purchaseServiceInstance_ then
                purchaseServiceInstance_ = PurchaseServiceClass.new()
                self.purchaseServices_[config.id] = purchaseServiceInstance_
            end
            purchaseServiceInstance_:init(config, isLoadData)
        end
    end
end

function PurchaseServiceManager:getPurchaseService(serviceId)
    return self.purchaseServices_[serviceId]
end

function PurchaseServiceManager:autoDispose()
    for id, service in pairs(self.purchaseServices_) do
        service:autoDispose()
        if service.helper_ and service.helper_.autoDispose then
            service.helper_:autoDispose()
        end
    end
end

return PurchaseServiceManager
