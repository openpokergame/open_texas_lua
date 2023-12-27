local PurchaseHelper = class("PurchaseHelper")

local DEFAULT_CACHE_DIR = device.writablePath .. "cache" .. device.directorySeparator .. "remotedata" .. device.directorySeparator
sa.mkdir(DEFAULT_CACHE_DIR)

function PurchaseHelper:ctor(name)
    self.logger = sa.Logger.new(name .. ".PurchaseHelper")
end

function PurchaseHelper:parsePrice(p)
    local s, e = string.find(p, "%d")
    local partDollar
    local partNumber
    local partNumberLen
    if s <= 1 then
        local lastNumIdx = 1
        while true do
            local st, ed = string.find(p, "%d", lastNumIdx + 1)
            if ed then
                lastNumIdx = ed
            else
                partDollar = string.sub(p, lastNumIdx + 1)
                partNumber = string.sub(p, 1, lastNumIdx)
                partNumberLen = string.len(partNumber)
                break
            end
        end
    else
        partDollar = string.sub(p, 1, s - 1)
        partNumber = string.sub(p, s)
        partNumberLen = string.len(partNumber)
    end

    local priceNum = 0
    local split, dot = "", ""
    local s1, e1 = string.find(partNumber, "%p")
    if s1 then
        --找到第一个标点
        local firstP = string.sub(partNumber, s1, e1)
        local s2, e2 = string.find(partNumber, "%p", s1 + 1)
        if s2 then
            --至少2个标点
            local secondP = string.sub(partNumber, s2, e2)
            if firstP == secondP then
                --2个一样的标点肯定分隔符
                split = firstP
                local str = string.gsub(partNumber, "%" .. firstP, "")
                local sdb, sde = string.find(str, "%p")
                if sdb then
                    --去掉分隔符之后的肯定是小数点
                    dot = string.sub(str, sdb, sde)
                    str = string.gsub(str, "%" .. dot, ".")
                end
                priceNum = tonumber(str)
            else
                --2个标点不一样，前面的是分隔符，后面的是小数点
                split = firstP
                dot = secondP
                local str = string.gsub(partNumber, "%" .. split, "")
                str = string.gsub(str, "%" .. dot, ".")
                priceNum = tonumber(str)
            end
        else
            --只有一个标点
            if string.sub(partNumber, 1, s1 - 1) == "0" then
                --标点前面为0，这个标点肯定是小数点
                dot = firstP
                --把这个标点替换为 "."
                local str = string.gsub(partNumber, "%" .. firstP, ".")
                priceNum = tonumber(str)
            elseif partNumberLen == e1 + 3 then
                --标点之后有3位，假定这个标点为分隔符
                split = firstP
                local str = string.gsub(partNumber, "%" .. firstP, "")
                priceNum = tonumber(str)
            elseif partNumberLen <= e1 + 2 then
                --标点之后有2或1位，假定这个标点为小数点
                dot = firstP
                local str = string.gsub(partNumber, "%" .. firstP, ".")
                priceNum = tonumber(str)
            elseif firstP == "," then
                --默认","为分隔符
                split = firstP
                local str = string.gsub(partNumber, "%" .. firstP, "")
                priceNum = tonumber(str)
            elseif firstP == "." then
                --默认"."为小数点
                dot = firstP
                local str = string.gsub(partNumber, "%" .. firstP, ".")
                priceNum = tonumber(str)
            else
                split = firstP
                local str = string.gsub(partNumber, "%" .. firstP, "")
                priceNum = tonumber(str)
            end
        end
    else
        --找不到标点
        priceNum = tonumber(partNumber)
    end

    return partDollar, priceNum, split, dot
end

function PurchaseHelper:parseConfig(jsonString, itemCallback)
end

function PurchaseHelper:parseGoods(goodsTable, itemCallback)
    local jsonGoods = goodsTable
    local result = {}
    result.skus = {}

    local all = {}
    result.all = all

    local chips = {}
    result.chips = chips

    local diamonds = {}
    result.diamonds = diamonds

    local props = {}
    result.props = props
    local needDispatchEvt = false
    local maxSale = tx.userData.maxSale or 0
    for _, goods in pairs(jsonGoods) do
        goods.skus = goods.gpid  -- 不同平台对应的商品ID
        if goods.gbaseReward then
            goods.gbaseReward_ = json.decode(goods.gbaseReward) -- 基础奖励
        end

        if goods.goriginReward then
            goods.goriginReward_ = json.decode(goods.goriginReward) -- 原始奖励
        end

        table.insert(all,goods)
        table.insert(result.skus, goods.gpid)

        if not goods.show or tonumber(goods.show) == 1 then
            if goods.gtype == "1" then --筹码
                if itemCallback then
                    itemCallback("chips", goods)
                end
                local riseRatio = tonumber(goods.gaddPro)
                goods.riseMoney_ = tonumber(goods.gbaseReward_.money)
                goods.baseMoney_ = tonumber(goods.goriginReward_.money)
                goods.perPrice_ = tonumber(string.format("%d", goods.riseMoney_/tonumber(goods.gpriceThb)))

                table.insert(chips,goods)
            elseif goods.gtype == "2" then  --钻石
                if itemCallback then
                    itemCallback("diamonds", goods)
                end

                goods.perPrice_ = tonumber(string.format("%.2f", tonumber(goods.gbaseReward_.diamond)/tonumber(goods.gpriceThb)))

                table.insert(diamonds,goods)               
            elseif goods.gtype == "3" then  --互动道具
                if itemCallback then
                    itemCallback("props", goods)
                end
                table.insert(props,goods)
            elseif goods.gtype == "4" then --首冲礼包商品
                if itemCallback then
                    itemCallback("firstPay", goods)
                end
            elseif goods.gtype == "5" then --喇叭
                if itemCallback then
                    itemCallback("props", goods)
                end
                table.insert(props,goods)
            end

            if goods.sale and goods.sale ~= 0 then
                if not goods.isClientTime then
                    goods.clientTime = os.time()
                    goods.isClientTime = true
                end
                
                if goods.sale > maxSale then
                    needDispatchEvt = true
                    maxSale = goods.sale
                    tx.userData.maxSale = maxSale
                    tx.userData.maxSaleInfo = goods
                end
            end
        end
    end

    if tx.userData.maxSaleInfo and needDispatchEvt==true then
        sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
    end

    table.sort(chips,function(a,b) 
        if tonumber(a.gsort) == tonumber(b.gsort) then
            return tonumber(a.gprice) < tonumber(b.gprice)
        else
            return tonumber(a.gsort) > tonumber(b.gsort)
        end
    end)

    table.sort(diamonds,function(a,b)
        if tonumber(a.gsort) == tonumber(b.gsort) then
            return tonumber(a.gprice) < tonumber(b.gprice)
        else
            return tonumber(a.gsort) > tonumber(b.gsort)
        end
    end)

    table.sort(props,function(a,b) 
        if tonumber(a.gtype) == tonumber(b.gtype) then
            if tonumber(a.gsort) == tonumber(b.gsort) then
                return tonumber(a.gprice) < tonumber(b.gprice)
            else
                return tonumber(a.gsort) > tonumber(b.gsort)
            end
        else
            return tonumber(a.gtype) < tonumber(b.gtype)
        end
    end)

    return result
end

function PurchaseHelper:updateDiscount(products)
    if not products then return end
    if products.all then
        for i, goods in ipairs(products.all) do
            if not goods.priceLabel then
                goods.priceLabel = "THB" .. goods.gpriceThb
            end

            local partDollar, priceNum
            if goods.priceNum and goods.priceDollar then
                partDollar = goods.priceDollar
                priceNum = goods.priceNum
            elseif not goods.priceNum then
                partDollar, priceNum = self:parsePrice(goods.priceLabel)
                goods.priceNum = priceNum
                goods.priceDollar = partDollar
            else
                priceNum = goods.priceNum
                goods.priceDollar = self:parsePrice(goods.priceLabel)
            end

            -- if goods.discount ~= 1 then
            --     goods.rate = goods.pnum * goods.discount / priceNum
            --     goods.numOff = math.floor(goods.pnum * goods.discount)
            --     goods.discountTitle = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatBigNumber(goods.numOff))
            -- else
            --     goods.rate = goods.pnum / priceNum
            --     goods.discountTitle = goods.title
            -- end
            -- goods.rate = tonumber(string.format("%.2f", goods.rate))

            if goods.gbaseReward_ then
                if goods.gbaseReward_.money then
                    goods.perPrice_ = tonumber(string.format("%d", tonumber(goods.gbaseReward_.money)/tonumber(priceNum)))
                elseif goods.gbaseReward_.diamond then
                    goods.perPrice_ = tonumber(string.format("%.2f", tonumber(goods.gbaseReward_.diamond)/tonumber(priceNum)))
                end
            end
        end

        -- if products.chips then
        --     local bestChips = products.chips[1]
        --     for k,v in pairs(products.chips) do
        --         if v.perPrice_>bestChips.perPrice_ then
        --             bestChips = v
        --         end
        --     end
        --     if bestChips then
        --         bestChips.isBest = true
        --     end
        -- end
    end
end

function PurchaseHelper:generateOrderId(goods,params,callback)
    -- TODO: fixed
    local key="$spAnt2017@sz^6688$"
    local uid = tx.userData.uid or ""
    local gid = goods.gid
    local device = ((device.platform == "windows") and tx.TestUtil.simuDevice or device.platform)
    local ggameid = goods.ggameid
    local time = os.time()
    local sign = crypto.md5(uid.."|"..gid.."|"..device.."|"..ggameid.."|"..key)
    local buyFromScene =  _G.buyFromScene or 1

    local orderId = ""
    local orderData = {}
    local postData = {
            mod="Payment",
            act="createOrder",
            uid = uid,
            gid = gid,
            device = device,
            ggameid =ggameid,
            sign = sign,
            time = time,
            flag = buyFromScene,
        }
    if params then
        table.merge(postData,params)
    end
    -- sa.HttpService.CANCEL(self.createOrderId_)
    self.createOrderId_ = sa.HttpService.POST(
        postData,
        function(data)
            local orderData = json.decode(data)
            if orderData and orderData.code == 1 then
                callback(true, orderData.orderId)
            else
                callback(false, "", sa.LangUtil.getText("STORE", "GENERATE_ORDERID_FAIL"))
            end
        end,
        function()
            tx.badNetworkToptip()
            callback(false)
        end)
end

function PurchaseHelper:autoDispose()
    -- 不能删除 否则下单会中断
    -- if self.createOrderId_ then
    --     sa.HttpService.CANCEL(self.createOrderId_)
    --     self.createOrderId_ = nil
    -- end
end

return PurchaseHelper
