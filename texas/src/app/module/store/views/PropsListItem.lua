local BaseListItem = import(".BaseListItem")
local PropsListItem = class("PropsListItem", BaseListItem)

function PropsListItem:ctor()
	PropsListItem.super.ctor(self)

    self.desc_ = {}
    for i, bg in ipairs(self.items_) do
        local size = bg:getContentSize()
        self.desc_[i] = ui.newTTFLabel({text = "", size = 18, color = cc.c3b(0x6f, 0xec, 0xff), align=ui.TEXT_ALIGN_CENTER, dimensions=cc.size(280, 0)})
            :align(display.TOP_CENTER, size.width*0.5,  135)
            :addTo(bg)
    end

    self:setGoodsImageOffset(0, -10)
end

function PropsListItem:onDataSet(dataChanged, data)
    self.data_ = data

    if dataChanged then
        self:hideAllItems()

        for i, v in ipairs(data) do
            self.items_[i]:show()

            self:setGoodsPrice(i, v.priceLabel, v.gchannel)

            local title = v.gname
            local desc = v.gdesc
            if v.gtype == "3" then  --互动道具
                local startIdx,endIdx = string.find(v.gbaseReward,"[0-9]+",1)
                if startIdx and endIdx then
                    local count = string.sub(v.gbaseReward,startIdx,endIdx)
                    title = sa.LangUtil.getText("STORE","FORMAT_HDDJ",count)
                    desc = sa.LangUtil.getText("STORE","HDDJ_DESC",count)
                end
            elseif v.gtype == "5" then  --喇叭
                local startIdx,endIdx = string.find(v.gbaseReward,"[0-9]+",1)
                if startIdx and endIdx then
                    local count = string.sub(v.gbaseReward,startIdx,endIdx)
                    title = sa.LangUtil.getText("STORE","FORMAT_DLB",count)
                    desc = sa.LangUtil.getText("STORE","DLB_DESC",count)
                end
            end

            self.title_[i]:setString(title)
            self.desc_[i]:setString(desc)

            self.title_[i]:setPositionY(155)
            self.icon_[i]:setPositionY(250)
        end

        self:setGoodsImage()
    end
end

return PropsListItem