-- 好友列表视图
local TexasMustListView = class("TexasMustListView", function()
    return display.newNode()
end)

local TexasMustChooseItem = import(".TexasMustChooseItem")

local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
    {"c_9", "c_6"},--普通场
    {"q_9", "q_6"},--快速场
}

function TexasMustListView:ctor(delegate)
    self:setNodeEventEnabled(true)

    self.delegate_ = delegate

    local list_w, list_h = display.width - 40, 510
    TexasMustChooseItem.WIDTH = list_w/3.5
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
            direction=sa.ui.ListView.DIRECTION_HORIZONTAL
        }, 
        TexasMustChooseItem
    )
    :hideScrollBar()
    :addTo(self)

    self.list_.onItemClickListener = handler(self, self.onItemClick_)

    self:initTableConfig_()
end

function TexasMustListView:initTableConfig_()
    if not tx.userData.texasMustTableConfig then
        self.delegate_:setLoading(true)
        tx.TableConfigManager:getTexasMustTableConfig(function()
            if self.delegate_ then
                self.delegate_:setLoading(false)
                self:initData_()
            end
        end)
    else
        self:initData_()
    end
end

function TexasMustListView:initData_()
    self.data_ = tx.userData.texasMustTableConfig[1][ROOM_TYPE_KEY[QUICK_PLAY][NUM_6]]

    self.delegate_:showList()
end

function TexasMustListView:onItemClick_(data)
    self.delegate_:enterRoom(data, 701)
end

function TexasMustListView:showList()
    if not self.data_ then
        self:initTableConfig_()
    else
        self:show()
        self.list_:setData(self.data_,true)
    end
end

function TexasMustListView:hideList()
    self:hide()

    return self
end

function TexasMustListView:onCleanup()
end

return TexasMustListView