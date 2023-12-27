local PayPopupController = class("PayPopupController")
local StoreController = import("app.module.store.StoreController")
local MessageData = import("app.module.message.MessageData")

function PayPopupController:ctor(view)
    self.view_ = view
    self.storeController_ = StoreController.new(self)
    self.storeController_:init()
end

function PayPopupController:getFirstGoodsConfig()
    self.view_:setLoading(true)

    if tx.userData.firstPayGoods then
        self:onGetGoodsCallback_({tx.userData.firstPayGoods}, 0)
        return
    end

    local requestGoods
    local retrytimes = 3
    requestGoods = function()
        sa.HttpService.CANCEL(self.requestFirstGoodsId_)
        self.requestFirstGoodsId_ = sa.HttpService.POST(
            {
                mod = "Goods",
                act = "getFirstPayGoods",
            },
            function (data)
                local retData = json.decode(data)
                if retData and retData.code == 1 and retData.goodsInfo then
                    tx.userData.firstPayGoods = retData.goodsInfo
                    self:onGetGoodsCallback_({retData.goodsInfo}, 0)
                else
                    retrytimes = retrytimes - 1
                    if retrytimes > 0 then
                        requestGoods()
                    end
                end
            end,
            function()
                retrytimes = retrytimes - 1
                if retrytimes > 0 then
                    requestGoods()
                end
            end
        )
    end
    requestGoods()
end

function PayPopupController:getFastGoodsConfig(gameId, blind)
    self.view_:setLoading(true)

    local requestGoods
    local retrytimes = 3
    requestGoods = function()
        sa.HttpService.CANCEL(self.requestGoodsId_)
        self.requestGoodsId_ = sa.HttpService.POST(
            {
                mod = "Goods",
                act = "getFastGoods",
                gameId = gameId,
                blind = blind,
            },
            function (data)
                local retData = json.decode(data)
                if retData and retData.code == 1 and retData.goodsList then
                    self:onGetGoodsCallback_({retData.goodsList}, 0)
                else
                    retrytimes = retrytimes - 1
                    if retrytimes > 0 then
                        requestGoods()
                    end
                end
            end,
            function()
                retrytimes = retrytimes - 1
                if retrytimes > 0 then
                    requestGoods()
                end
            end
        )
    end
    requestGoods()
end

function PayPopupController:checkUserCrash(gameId, blind)
    self.view_:setLoading(true)

    local requestBroken
    local maxretry = 6
    requestBroken = function()
        sa.HttpService.CANCEL(self.checkBrokeId_)
        self.checkBrokeId_ = sa.HttpService.POST(
            {
                mod = "Broke",
                act = "check",
                gameId = gameId,
                blind = blind
            },
            function (data)
                local retData = json.decode(data)
                if retData then
                    -- 破产模拟红点
                    local times = retData.times or 0
                    local money = retData.money or 0
                    if times > 0 and money > 0 then
                        -- 全局设置破产
                        MessageData.resetBroken()

                        tx.setBroken(os.time())-- 破产时间写入缓存
                        MessageData.prevHasNewMessage = MessageData.hasNewMessage
                        MessageData.hasNewMessage = true
                        sa.DataProxy:setData(tx.dataKeys.NEW_MESSAGE, MessageData.hasNewMessage)
                    end
                    -- 更新破产
                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})

                    self:onGetGoodsCallback_({retData.goodsInfo}, money, retData.isSponsorChips)
                else
                    maxretry = maxretry - 1
                    if maxretry > 0 then
                        requestBroken()
                    end
                end
            end,
            function()
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestBroken()
                end
            end
        )
    end
    requestBroken()
end

function PayPopupController:onGetGoodsCallback_(goods, crashMoney, isSponsorChips)
    self.payListGoods_ = goods
    self.crashMoney_ = crashMoney
    self.isSponsorChips_ = isSponsorChips
    self:showGoodsView_()
end

function PayPopupController:showGoodsView_()
    if self.showGoods_ then return end
    if not self.payListGoods_ then return end
    if not self.storeController_.loadedGoods then return end
    local showGoods
    for kkk,vvv in pairs(self.payListGoods_) do
        for kk,vv in pairs(self.storeController_.loadedGoods) do
            local isFind = false
            if vv.all then
                for k,v in pairs(vv.all) do
                    if tonumber(vvv.gid)==tonumber(v.gid) then
                        isFind = true
                        local goods = clone(v)
                        if vvv.sale then --破产商品
                            goods.gaddPro = vvv.sale
                            local reward = json.decode(vvv.reward)
                            goods.baseMoney_ = tonumber(reward.money)
                            goods.riseMoney_ = tonumber(string.format("%d", goods.baseMoney_*(1+goods.gaddPro/100)))
                        end
                        showGoods = goods
                        break
                    end
                end

                local ogid = vvv.ogid
                if showGoods and ogid and tonumber(ogid) > 0 then --首冲
                    for k,v in pairs(vv.all) do
                        if tonumber(ogid)==tonumber(v.gid) then
                            showGoods.originalPriceNum = v.priceNum
                            break
                        end
                    end

                    if vvv.reward then
                        local baseReward = json.decode(vvv.reward)
                        showGoods.riseMoney_ = baseReward.money
                    elseif vvv.gbaseReward then
                        local baseReward = json.decode(vvv.gbaseReward)
                        showGoods.riseMoney_ = baseReward.money
                    end
                end
            end

            if isFind then
                break
            end
        end
    end

    if showGoods then
        self.showGoods_ = showGoods

        if self.addMainUI then
            self:addMainUI(showGoods, self.crashMoney_, self.isSponsorChips_)   
        end
    end
end

function PayPopupController:addMainUI(data, crashMoney, isSponsorChips)
    if self.view_ then
        self.view_:setLoading(false)
        display.addSpriteFrames("aboutpay_texture.plist", "aboutpay_texture.png", function ()
            if self.view_ then
                self.view_:addMainUI(data, crashMoney, isSponsorChips)
            end
        end)
    end
end

function PayPopupController:setChannelGoods()
    self:showGoodsView_()
end

function PayPopupController:getUserCrashReward(isSponsorChips)
    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.getBrokeRewardId_)
    self.getBrokeRewardId_ = sa.HttpService.POST({
            mod = "Broke",
            act = "reward",
            isSponsorChips = isSponsorChips,
        },
        function(data)
            local jsonData = json.decode(data)
            if jsonData and jsonData.code == 1 then
                MessageData.resetBroken()
                tx.userData.money = tx.userData.money+tonumber(jsonData.money)
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=jsonData.money}})
                tx.TopTipManager:showGoldTips(sa.LangUtil.getText("CRASH", "GET_REWARD", jsonData.money))
                
                if self.view_ then
                    self.view_:setLoading(false)
                    self.view_:updateCrashView(true)
                end
            else
                if self.view_ then
                    self.view_:updateCrashView(false)
                end
                tx.TopTipManager:showToast(sa.LangUtil.getText("CRASH", "GET_REWARD_FAIL"))
            end
        end,
        function(data)
            if self.view_ then
                self.view_:updateCrashView(false)
            end
            tx.TopTipManager:showToast(sa.LangUtil.getText("CRASH", "GET_REWARD_FAIL"))
        end)
end

function PayPopupController:makePurchase(goods)
    self.storeController_:makePurchase(goods)
end

function PayPopupController:dispose()
    sa.HttpService.CANCEL(self.requestFirstGoodsId_)
    sa.HttpService.CANCEL(self.requestGoodsId_)
    sa.HttpService.CANCEL(self.getBrokeRewardId_)
    sa.HttpService.CANCEL(self.checkBrokeId_)

    self.storeController_:dispose()
end

return PayPopupController
