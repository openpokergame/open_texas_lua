-- 礼物列表视图

local ScrollView = import("openpoker.ui.ScrollView")
local  GiftListView = class("GiftListView", sa.ui.ListView)

function GiftListView:ctor(...)
    GiftListView.super.ctor(self, ...)
    self.btnGroup_ = tx.ui.CheckBoxButtonGroup.new()
    self.btnGroup_:onButtonSelectChanged(handler(self, self.onButtonSelectChanged_))
end

--改变选中按钮回调
function GiftListView:onButtonSelectChanged(callback)
    self.onButtonSelectChangedCallback_ = callback
end

--通过ID获取按钮
function GiftListView:selectGiftById(id)
    if id then
        local btn = self.btnGroup_:getButtonById(id)
        if btn then
            btn:setButtonSelected(true)
        end
    end
end

--通过数组下标获取按钮
function GiftListView:selectGiftByIndex(index)
    local btn = self.btnGroup_:getButtonAtIndex(index)
    if btn then
        btn:setButtonSelected(true)
    end
end

function GiftListView:onButtonSelectChanged_(...)
    if self.onButtonSelectChangedCallback_ then
        self.onButtonSelectChangedCallback_(self.btnGroup_, ...)
    end
end

function GiftListView:setListData(data)
    self.data_ = data
    self.btnGroup_:reset()
    self:setData({}) --因为self.btnGroup_:reset() 会删除按钮
    self:setData(data)

    return self
end

return GiftListView