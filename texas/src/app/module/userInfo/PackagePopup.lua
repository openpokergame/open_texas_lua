local PackagePopup = class("PackagePopup", tx.ui.Panel)

local PackageListItem = import(".PackageListItem")

local WIDTH, HEIGHT = 1040, 746

function PackagePopup:ctor()
    PackagePopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("USERINFO", "MY_PACK"))

    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(WIDTH - 56, 592))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 30)
        :addTo(self.background_)

    local list_w, list_h = 980, 584
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
        }, 
        PackageListItem
    )
    :hideScrollBar()
    :pos(WIDTH/2, list_h/2 + 30)
    :addTo(self.background_)

    self:getUserProps_()
end

function PackagePopup:getUserProps_()
    self:setLoading(true)
    sa.HttpService.POST({
        mod = "Props",
        act = "getUserProps",
    },
    function(data)
        local retData = json.decode(data)
        if retData.code == 1 then
            self:setLoading(false)

            local list = sa.transformDataToGroup(retData.list, PackageListItem.ROW_NUM)
            self.list_:setData(list)

            for _, v in ipairs(list) do
                if tonumber(v.id) == 1 then --同步道具
                    tx.userData.hddjnum = tonumber(v.count)
                    break
                end
            end
        end
    end,
    function()
    end
    )
end

function PackagePopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function PackagePopup:onShowed()
    if self.list_ then
        self.list_:update()
    end
end

return PackagePopup