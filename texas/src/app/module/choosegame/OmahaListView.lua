-- 好友列表视图
local OmahaListView = class("OmahaListView", function()
    return display.newNode()
end)

local OmahaChooseItem = import(".OmahaChooseItem")

local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
    {"c_9", "c_6"},--普通场
    {"q_9", "q_6"},--快速场
}

function OmahaListView:ctor(delegate)
    self:setNodeEventEnabled(true)

    self.delegate_ = delegate

    local list_w, list_h = display.width - 40, 510
    OmahaChooseItem.WIDTH = list_w/3.5
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
            direction=sa.ui.ListView.DIRECTION_HORIZONTAL
        }, 
        OmahaChooseItem
    )
    :hideScrollBar()
    :addTo(self)

    self.list_.onItemClickListener = handler(self, self.onItemClick_)

    self:initTableConfig_()
end

function OmahaListView:initTableConfig_()
    if not tx.userData.omahaTableConfig then
        self.delegate_:setLoading(true)
    else
        self:initData_()
    end

    self:getTableConfig_()
    self:schedule(function()
        self:getTableConfig_()
    end, 10)
end

function OmahaListView:getTableConfig_()
    tx.TableConfigManager:getOmahaTableConfig(function()
        if self.delegate_ then
            self.delegate_:setLoading(false)
            self:initData_()
        end
    end, true)
end

function OmahaListView:initData_()
    self.data_ = tx.userData.omahaTableConfig[1][ROOM_TYPE_KEY[QUICK_PLAY][NUM_9]]

    self.delegate_:showList()
end

function OmahaListView:onItemClick_(data)
    self.delegate_:enterRoom(data, 501)
end

function OmahaListView:showList()
    if not self.data_ then
        self:initTableConfig_()
    else
        self:show()
        self.list_:setData(self.data_,true)
    end
end

function OmahaListView:hideList()
    self:hide()

    return self
end

function OmahaListView:onCleanup()
end

return OmahaListView