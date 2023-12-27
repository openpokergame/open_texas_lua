-- 好友列表视图
local TexasListView = class("TexasListView", function()
    return display.newNode()
end)

local TexasChooseItem = import(".TexasChooseItem")

local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
    {"c_9", "c_6"},--普通场
    {"q_9", "q_6"},--快速场
}

function TexasListView:ctor(delegate)
    self:setNodeEventEnabled(true)

    self.delegate_ = delegate

    self.isRecommend_ = false

    local list_w, list_h = display.width - 40, 510
    TexasChooseItem.WIDTH = list_w/3.5
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
            direction=sa.ui.ListView.DIRECTION_HORIZONTAL
        }, 
        TexasChooseItem
    )
    :hideScrollBar()
    :addTo(self)

    self.list_.onItemClickListener = handler(self, self.onItemClick_)

    self:initTableConfig_()
end

function TexasListView:initTableConfig_()
    if not tx.userData.tableConfig then
        self.delegate_:setLoading(true)
        tx.TableConfigManager:getTexasTableConfig(function()
            if self.delegate_ then
                self.delegate_:setLoading(false)
                self:initData_()
            end
        end)
    else
        self:initData_()
    end
end

function TexasListView:initData_()
    self.data_ = tx.userData.tableConfig[1][ROOM_TYPE_KEY[QUICK_PLAY][NUM_6]]

    self:getRecommendLevel_()

    self.delegate_:showList()
end

function TexasListView:onItemClick_(data, askUpLevel)
    local smallblind = data.smallblind
    if tx.userData.level > 2 and askUpLevel then
        if smallblind == 50 and tx.userData.money > (smallblind * tx.userData.newPlayerMultiple) then
            tx.ui.Dialog.new({
                closeWhenTouchModel = true,
                messageText = sa.LangUtil.getText("HALL", "TEXAS_GUIDE_TIPS_1"),
                firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
                secondBtnText = sa.LangUtil.getText("HALL", "TEXAS_UPGRADE"),
                callback = function (btnType)
                    if btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
                        self.delegate_:quickStart()
                    end
                end
            }):show()
        elseif smallblind ~= 50 and smallblind <= tx.userData.maxGuideBlind and tx.userData.money > (smallblind * tx.userData.guideMultiple) then
            tx.ui.Dialog.new({
                closeWhenTouchModel = true,
                messageText = sa.LangUtil.getText("HALL", "TEXAS_GUIDE_TIPS_2"),
                firstBtnText = sa.LangUtil.getText("HALL", "TEXAS_STILL_ENTER"),
                secondBtnText = sa.LangUtil.getText("HALL", "TEXAS_UPGRADE"),
                callback = function (btnType)
                    if btnType == tx.ui.Dialog.FIRST_BTN_CLICK then
                        self:enterRoom_(data)
                    elseif btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
                        self.delegate_:quickStart()
                    end
                end
            }):show()
        else
            self:enterRoom_(data)
        end
    else
        self:enterRoom_(data)
    end
end

function TexasListView:enterRoom_(data)
    self.delegate_:enterRoom(data, 101)
end

function TexasListView:showList()
    if not self.data_ then
        self:initTableConfig_()
    else
        self:show()
        self.list_:setData(self.data_,true)
        self:showRecommendLight_()
    end
end

function TexasListView:hideList()
    self:hide()

    return self
end

function TexasListView:showRecommendLight_()
    if self.recommendLevel_ and self.recommendLevel_ > 0  then
        if self.isRecommend_ then
            return
        end
        self.isRecommend_ = true

        local item = self.list_:getListItem(self.recommendLevel_)
        item:showRecommendLight()

        self.list_:update() --先重置currentPlace_的值，否则会一直累加，而不是滚动指定位置

        --推荐场次居中,把item坐标移到0的位置,需要再原始坐标上加上偏移place,因为contentNode已经整体偏移了
        local place = self.list_:getContentPlace()
        local item_x = item:getPositionX()
        local x = -(item_x + place + TexasChooseItem.WIDTH*0.5)
        self.list_:scrollTo(x)
    end
end

--获取推荐房间等级
function TexasListView:getRecommendLevel_()
    local money = tx.userData.money
    local recommendTable = tx.userData.recommendTable

    --找到推荐房间
    for _, v in ipairs(recommendTable) do
        if money >= v.range[1] and money <= v.range[2] then
            self.recommendMinAnte_ = v.minAnte
            break
        end
    end

    --推荐房间等级
    local recommendLevel = 1
    for i, v in ipairs(self.data_) do
        if self.recommendMinAnte_ == v.min_ante then
            recommendLevel = i
            flag = true
            break
        end
    end

    --玩家等级可以进入的最大房间等级
    local level = tx.userData.level
    local flag = false
    local maxLevelType = 1
    for i, v in ipairs(tx.userData.tableLevelLimit) do
        if level < v then
            break
        end
        maxLevelType = i
    end

    if recommendLevel > maxLevelType then
        recommendLevel = maxLevelType
    end

    self.recommendLevel_ = recommendLevel
end

function TexasListView:onCleanup()
end

return TexasListView