local BaseListItem = import(".BaseListItem")
local DiamondsListItem = class("DiamondsListItem", BaseListItem)

function DiamondsListItem:ctor()
    DiamondsListItem.super.ctor(self)
end

function DiamondsListItem:onDataSet(dataChanged, data)
    self.data_ = data

    if dataChanged then
        self:hideAllItems()

        for i, v in ipairs(data) do
            self.items_[i]:show()

            self:setGoodsPrice(i, v.priceLabel, v.gchannel)

            -- self.ratio_[i]:setPositionY(105)
            -- self.ratio_[i]:setString(sa.LangUtil.getText("STORE", "RATE_DIAMONDS", sa.formatNumberWithSplit(v.perPrice_), v.priceDollar))
            self.ratio_[i]:hide()

            self.title_[i]:setPositionY(130)
            self.title_[i]:setString(sa.LangUtil.getText("STORE","FORMAT_DIAMONDS",v.gbaseReward_.diamond))
        end

        self:setGoodsImage()
    end
end

return DiamondsListItem