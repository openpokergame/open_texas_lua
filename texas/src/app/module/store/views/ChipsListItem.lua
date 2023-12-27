local BaseListItem = import(".BaseListItem")
local ChipsListItem = class("ChipsListItem", BaseListItem)

function ChipsListItem:ctor()
    ChipsListItem.super.ctor(self)

    for _, v in ipairs(self.title_) do
        v:removeFromParent()
    end

    self.title_ = {}
    self.originalTitle_ = {}
    self.line_ = {}
    for i, bg in ipairs(self.items_) do
        local size = bg:getContentSize()
        local x = size.width*0.5
        self.title_[i] = ui.newBMFontLabel({text = "", font = "fonts/shangcheng.fnt"})
            :pos(x, 130)
            :addTo(bg)

        self.ratio_[i]:hide()

        local label_y = 160
        self.originalTitle_[i] = ui.newBMFontLabel({text = "", font = "fonts/shangcheng6.fnt"})
            :pos(x, label_y)
            :addTo(bg)
            :hide()

        self.line_[i] = display.newScale9Sprite("#common/chips_sale_line.png")
            :pos(x, label_y + 5)
            :addTo(bg)
            :hide()
    end
end

function ChipsListItem:onDataSet(dataChanged, data)
    self.data_ = data
    if dataChanged then
        self:hideAllItems()

        for i, v in ipairs(data) do
            self.items_[i]:show()

            self:setGoodsPrice(i, v.priceLabel, v.gchannel)

            self.ratio_[i]:setString(sa.LangUtil.getText("STORE", "RATE_CHIP", sa.formatBigNumber(v.perPrice_), v.priceDollar))

            self.title_[i]:setString(sa.formatBigNumber(v.riseMoney_))
            sa.fitSprteWidth(self.title_[i], 270)

            if tonumber(v.ghot) == 1 then
                self.iconHot_[i]:show()
            else
                self.iconHot_[i]:hide()
            end

            self.sale_[i]:hide()
            self.originalTitle_[i]:hide()
            self.line_[i]:hide()

            local goods = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
            if goods and tonumber(goods.gid)==tonumber(v.gid) then
                self:showDiscount_(i, goods.sale)
            elseif v.sale and v.sale ~= 0 then
                self:showDiscount_(i, v.sale)
            elseif v.gaddPro and tonumber(v.gaddPro) ~= 0 then
                self:showDiscount_(i, v.gaddPro)
                self:showOriginalTitle_(i, v.baseMoney_)
            end
        end

        self:setGoodsImage()
    end
end

function ChipsListItem:showDiscount_(index, sale)
    self.sale_[index]:show():setString("+"..sale.."%")
end

function ChipsListItem:showOriginalTitle_(index, original)
    local title = self.originalTitle_[index]
    title:show()
    title:setString(sa.formatBigNumber(original))

    local size = title:getContentSize()
    self.line_[index]:size(size.width + 20, 6):show()

    self.title_[index]:setPositionY(120)
end

-- function ChipsListItem:showDiscount_(data)
    -- self.nodeDiscount:show()
    -- local addMoney = math.floor(data.riseMoney_*tonumber(data.sale)/100)
    -- local nowMoney = data.riseMoney_ + addMoney
    -- local perPrice = tonumber(string.format("%d", nowMoney/tonumber(data.gpriceThb)))
    -- self.ratio_[i]:setString(sa.LangUtil.getText("STORE", "RATE_CHIP", sa.formatNumberWithSplit(perPrice), data.priceDollar))
    -- self.nodeDiscount.labelDiscount:setString("+"..data.sale.."%")
    -- self.labelCur:setString(sa.formatBigNumber(data.riseMoney_) .. "+"..sa.formatNumberWithSplit(addMoney))

    -- self.time_ = data.countdown + 1
    -- local fun = function()
    --     local runTime = os.time() - data.clientTime
    --     if runTime>=self.time_ then
    --         self.nodeDiscount:hide()
    --         self.nodeDiscount:stopAllActions()
    --         self.ratio_[i]:setString(sa.LangUtil.getText("STORE", "RATE_CHIP", sa.formatNumberWithSplit(data.perPrice_), data.priceDollar))
    --         return
    --     end
    --     self.nodeDiscount.labelTime:setString(sa.TimeUtil:getTimeString1(self.time_-runTime))
    -- end

    -- self.nodeDiscount:schedule(fun, 1)

    -- fun()
-- end

return ChipsListItem