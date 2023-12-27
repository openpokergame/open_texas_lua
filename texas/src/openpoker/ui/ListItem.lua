local ListItem = class("ListItem", function ()
    return display.newNode()
end)

function ListItem:ctor(w, h)
    self:setContentSize(cc.size(w, h))
end
-- 隐形bug list会使用height_进行判断显示
function ListItem:setContentSize(size)
    if not size then return end
    cc.Node.setContentSize(self,size)
    self.width_ = size.width
    self.height_ = size.height
end

function ListItem:setData(data)
    local dataChanged = (self.data_ ~= data)
    self.data_ = data
    if self.onDataSet then
        self:onDataSet(dataChanged, data)
    end
    return self
end

function ListItem:getData()
    return self.data_
end

function ListItem:setIndex(index)
    self.index_ = index
    return self
end

function ListItem:getIndex()
    return self.index_
end

function ListItem:setOwner(owner)
    self.owner_ = owner
    return self
end

function ListItem:getOwner()
    return self.owner_
end

return ListItem