local ScrollView = import(".ScrollView")
local ListView = class("ListView", ScrollView)

function ListView:ctor(params, itemClass)
    ListView.super.ctor(self, params)

    -- 滚动容器
    self.content_ = display.newNode()

    self:setScrollContent(self.content_)
    self:setItemClass(itemClass)
end

function ListView:onScrolling()
    if self.items_ and self.viewRectOriginPoint_ then
        if self.direction_ == ScrollView.DIRECTION_VERTICAL then
            for _, item in ipairs(self.items_) do
                local tempWorldPt = self.content_:convertToWorldSpace(cc.p(item:getPosition()))
                if tempWorldPt.y > self.viewRectOriginPoint_.y + self.viewRect_.height or tempWorldPt.y < self.viewRectOriginPoint_.y - item.height_ then
                    item:hide()
                    if item.onItemDeactived then
                        if tempWorldPt.y - (self.viewRectOriginPoint_.y + self.viewRect_.height) > self.viewRect_.height or self.viewRectOriginPoint_.y - item.height_ - tempWorldPt.y > self.viewRect_.height then
                            item:onItemDeactived()
                        end
                    end
                else
                    item:show()
                    if item.lazyCreateContent then
                        item:lazyCreateContent()
                    end
                end
            end
        elseif self.direction_ == ScrollView.DIRECTION_HORIZONTAL then
            for _, item in ipairs(self.items_) do
                local tempWorldPt = self.content_:convertToWorldSpace(cc.p(item:getPosition()))
                if tempWorldPt.x > self.viewRectOriginPoint_.x + self.viewRect_.width or tempWorldPt.x < self.viewRectOriginPoint_.x - item.width_ then
                    item:hide()
                    if item.onItemDeactived then
                        if tempWorldPt.x - (self.viewRectOriginPoint_.x + self.viewRect_.width) > self.viewRect_.width or self.viewRectOriginPoint_.x - item.width_ - tempWorldPt.x > self.viewRect_.width then
                            item:onItemDeactived()
                        end
                    end
                else
                    item:show()
                    if item.lazyCreateContent then
                        item:lazyCreateContent()
                    end
                end
            end
        end
    end
end

-- 设置数据
function ListView:setData(data,scroll)
    local curP = self.currentPlace_
    self.data_ = data
    local oldItemNum = self.itemNum_ or 0
    self.itemNum_ = self.data_ and #self.data_ or 0

    -- 如果已创建items，移除多余的item
    if self.items_ then
        if oldItemNum > self.itemNum_ then
            for i = self.itemNum_ + 1, oldItemNum do
                table.remove(self.items_):removeFromParent()
            end
        end
    else
        self.items_ = {}
    end

    -- 创建item
    if self.direction_ == ScrollView.DIRECTION_VERTICAL then
        self.contentSize_ = 0
        self:dynamicSetVerticalData_(1, self.itemNum_)
    elseif self.direction_ == ScrollView.DIRECTION_HORIZONTAL then
        local contentSize = 0
        local itemResizeHandler = handler(self, self.onItemResize_)
        local itemEventHandler = handler(self, self.onItemEvent_)
        for i = 1, self.itemNum_ do
            if not self.items_[i] then
                self.items_[i] = self.itemClass_.new()
                    :addTo(self.content_)
                if self.items_[i].addEventListener then
                    self.items_[i]:addEventListener("RESIZE", itemResizeHandler)
                    self.items_[i]:addEventListener("ITEM_EVENT", itemEventHandler)
                end
            end
            if self.isNotHide_ then
                self.items_[i]:show()
            end
            self.items_[i]:setIndex(i)
            self.items_[i]:setOwner(self)
            self.items_[i]:setData(self.data_[i])
            contentSize = contentSize + self.items_[i]:getContentSize().width
        end
        
        -- 先定第一个item的位置，再设置其他item位置
        if self.itemNum_ > 0 then
            local size = self.items_[1]:getContentSize()
            self.items_[1]:pos(-contentSize * 0.5, -size.height * 0.5)
            for i = 2, self.itemNum_ do
                local prevSize = size
                size = self.items_[i]:getContentSize()
                self.items_[i]:pos(self.items_[i - 1]:getPositionX() + prevSize.width, -size.height * 0.5)
            end
        end
        self.content_:setContentSize(cc.size(contentSize, self.content_:getCascadeBoundingBox().height))
    end

    -- 更新滚动容器
    self:update()
    if scroll then
        self:scrollTo(curP)
    end
    return self
end

--防止一次数据过多出现卡顿，其实只需要显示前面几条数据，其他的数据延时设置
function ListView:dynamicSetVerticalData_(startIndex, endIndex)
    local itemResizeHandler = handler(self, self.onItemResize_)
    local itemEventHandler = handler(self, self.onItemEvent_)
    for i = startIndex, endIndex do
        if not self.items_[i] then
            self.items_[i] = self.itemClass_.new()
                :addTo(self.content_)
            if self.items_[i].addEventListener then
                self.items_[i]:addEventListener("RESIZE", itemResizeHandler)
                self.items_[i]:addEventListener("ITEM_EVENT", itemEventHandler)
            end
        end
        if self.isNotHide_ then
            self.items_[i]:show()
        end
        self.items_[i]:setIndex(i)
        self.items_[i]:setOwner(self)
        self.items_[i]:setData(self.data_[i])
        self.contentSize_ = self.contentSize_ + self.items_[i]:getContentSize().height
    end

    -- 先定第一个item的位置，再设置其他item位置
    if self.itemNum_ > 0 then
        local size = self.items_[1]:getContentSize()
        self.items_[1]:pos(-size.width * 0.5, self.contentSize_ * 0.5 - size.height)
        for i = 2, endIndex do
            size = self.items_[i]:getContentSize()
            self.items_[i]:pos(-size.width * 0.5, self.items_[i - 1]:getPositionY() - size.height)
        end
    end
    self.content_:setContentSize(cc.size(self.content_:getCascadeBoundingBox().width, self.contentSize_))

    self:update()
end

function ListView:getData()
    return self.data_
end

function ListView:onItemResize_()
    -- 创建item
    local curP = self.currentPlace_
    local contentSize = 0
    if self.direction_ == ScrollView.DIRECTION_VERTICAL then
        for i = 1, self.itemNum_ do
            contentSize = contentSize + self.items_[i]:getContentSize().height
        end
        --self.content_:setContentSize(cc.size(self.content_:getContentSize().width, contentSize))
        -- 先定第一个item的位置，再设置其他item位置
        local size = self.items_[1]:getContentSize()
        self.items_[1]:pos(-size.width * 0.5, contentSize * 0.5 - size.height)
        local pX, pY = -size.width * 0.5, contentSize * 0.5 - size.height
        for i = 2, self.itemNum_ do
            size = self.items_[i]:getContentSize()
            pY = pY - size.height
            self.items_[i]:pos(pX, pY)
        end
        self.content_:setContentSize(cc.size(self.content_:getCascadeBoundingBox().width, contentSize))
    elseif self.direction_ == ScrollView.DIRECTION_HORIZONTAL then
        for i = 1, self.itemNum_ do
            contentSize = contentSize + self.items_[i]:getContentSize().width
        end
        self.content_:setContentSize(cc.size(contentSize, self.content_:getContentSize().height))
        -- 先定第一个item的位置，再设置其他item位置
        local size = self.items_[1]:getContentSize()
        self.items_[1]:pos(-contentSize * 0.5, -size.height * 0.5)
        local pX, pY = -contentSize * 0.5, -size.height * 0.5
        for i = 2, self.itemNum_ do
            size = self.items_[i]:getContentSize()
            pX = pX + size.width
            self.items_[i]:pos(pX, pY)
        end
        self.content_:setContentSize(cc.size(contentSize, self.content_:getCascadeBoundingBox().height))
    end

    -- 更新滚动容器
    self:update()
    self:scrollTo(curP)
    return self
end

function ListView:onItemEvent_(evt)
    self:dispatchEvent(evt)
end

function ListView:getListItem(index)
    if self.items_ then
        return self.items_[index]
    end
end

function ListView:getListItems()
    if self.items_ then
        return self.items_
    end
end

function ListView:setItemClass(class)
    self.itemClass_ = class

    return self
end

--设置所有item深度，在setData之后调用
function ListView:setItemsZorder(isIncrease)
    local len = #self.items_

    --递增
    if isIncrease then
        for i = 1, len do
            self.items_[i]:setLocalZOrder(i)
        end
    else
        local z = 1
        for i = len, 1, -1 do
            self.items_[i]:setLocalZOrder(z)
            z = z + 1
        end
    end

    return self
end

--检测某个item的中心的是否显示在视图中
function ListView:checkItemInViewByIndex(index)
    local item = self.items_[index]
    local x, y = item:getPosition()
    local size = item:getContentSize()
    x = x + size.width*0.5 --因为item左边是左下角的，换算成中心

    local p = self.content_:convertToWorldSpace(cc.p(x, y))

    return self:isTouchInViewRect_(p)
end

--显示指定下标的item，移到到最左边或者最右边 dir 1左边 2右边
function ListView:moveItemByIndex(index, dir)
    local item = self.items_[index]

    local place = self:getContentPlace()
    local curPlace = self.currentPlace_
    local size = item:getContentSize()
    local item_x = item:getPositionX()
    local viewWidth = self.viewRect_.width
    local x = place

    if dir == 1 then --移到最左边,想有滚动
        x = -(viewWidth*0.5 + item_x + place)
        self.scrollDirection_ = ScrollView.DIRECTION_RIGHT
    else
        x = -(viewWidth*0.5 + item_x + place) + (viewWidth - size.width)
        self.scrollDirection_ = ScrollView.DIRECTION_LEFT
    end

    local distance = x - curPlace

    self:moveDistance(distance)
end

-- 简单刷新 数据内部变化 子项必须要有refresh接口
function ListView:refresh()
    if self.items_ then
        if not self.items_[1] or not self.items_[1].refresh then
            return
        end
        for _, item in ipairs(self.items_) do
            if item:isVisible() then
                item:refresh()
            end
        end
    end
end

return ListView