local ActivityCenterPopup = class("ActivityCenterPopup", tx.ui.Panel)
local ActivityContentItem = import(".ActivityContentItem")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local WIDTH, HEIGHT = 1136, 746 --弹窗大小
local CONTENT_X, CONTENT_Y = WIDTH - 28, 30
local TAB_ON_COLOR = styles.FONT_COLOR.MAIN_TAB_ON
local TAB_OFF_COLOR =  styles.FONT_COLOR.MAIN_TAB_OFF
local DIMENSIONS = cc.size(180, 0)
local requestRetryTimes = 3

function ActivityCenterPopup:ctor()
    ActivityCenterPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setImgTitleStyle("#lang/pop_title_activity.png")

    self.selected_ = 1

    requestRetryTimes = 3

    local w, h = 1080, 590
    self.loadingBg_ = display.newSprite("img/activity_loading_bg.jpg")
        :align(display.BOTTOM_CENTER, WIDTH/2, 30)
        :addTo(self.background_)
    local size = self.loadingBg_:getContentSize()
    self.loadingBg_:setScaleX(w/size.width)
    self.loadingBg_:setScaleY(h/size.height)

    self.noActLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "NO_ACT"), size = 26})
        :pos(w/2, h/2 - 30)
        :addTo(self.loadingBg_)
        :hide()

    self.loadingLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "LOADING"), size = 26})
        :pos(w/2, 30)
        :addTo(self.loadingBg_)

    self.onLoadImageCallbackId_ = sa.EventCenter:addEventListener("ACTIVITY_CENTER_LOAD_IMAGE", handler(self, self.onLoadImageCallback_))

    -- if tx.userData.activityConfig then
    --     self:onGetActivityConfig_()
    -- else
    --     self:getActivityConfig_()
    -- end

    self:getActivityConfig_()
end

function ActivityCenterPopup:addMainUI_(data)
    self.contentList_ = {}  -- 最终显示
    self.initContentList_ = {}  -- 初始化的时候
    self.contentNode_ = display.newNode()
        :addTo(self.background_, 1)
        :hide()

    for i, v in ipairs(data) do
        self.initContentList_[i] = ActivityContentItem.new(self, v)
            :align(display.RIGHT_BOTTOM, CONTENT_X, CONTENT_Y)
            :addTo(self.contentNode_)
            :hide()
    end
end

function ActivityCenterPopup:onMainTabChange(evt)
    self:onTabChange_(evt.selected)
end

function ActivityCenterPopup:onTabChange_(selectedTab)
    self.selectedTab = selectedTab
    for _,v in ipairs(self.contentList_) do
        v:hide()
    end
    self.contentList_[selectedTab]:show()
end

function ActivityCenterPopup:getActivityConfig_()
    self:setLoading(true)
    self.getConfigRequestId_ = sa.HttpService.POST(
        {
            mod = "Activity",
            act = "getList",
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                local list = {}
                for i, v in ipairs(retData.list) do           
                    if v.img then --图片地址
                        v.img = tx.userData.activityDomain .. v.img
                    end
                    -- 是玩牌活动时间换算
                    if v.content and type(v.content)=="table" and v.content.list and type(v.content.list)=="table" then
                        local startTime = nil
                        local endTime = nil
                        local startStr = nil
                        local endStr = nil
                        local itemList = v.content.list
                        for k,v in pairs(itemList) do
                            startTime = tonumber(v.startTime)
                            endTime = tonumber(v.endTime)
                            if startTime and endTime then
                                startStr = sa.TimeUtil:getTimeSimpleString(startTime,nil,nil,nil,true)
                                endStr = sa.TimeUtil:getTimeSimpleString(endTime,nil,nil,nil,true)
                                v.time = startStr.."-"..endStr
                            end
                        end
                    end
                    list[i] = v
                end

                -- tx.userData.activityConfig = list

                self:onGetActivityConfig_(list)
            end
        end,
        function ()
            requestRetryTimes = requestRetryTimes - 1
            if requestRetryTimes > 0 then
                self.getConfigScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getActivityConfig_), 1)
            end
        end
    )
end

function ActivityCenterPopup:onGetActivityConfig_(data)
    -- local data = tx.userData.activityConfig
    if #data == 0 then
        self:setLoading(false)
        self.noActLabel_:show()
        self.loadingLabel_:hide()
    else
        self:addMainUI_(data)
    end
end

function ActivityCenterPopup:onLoadImageCallback_(evt)
    self:setLoading(false)
    self.contentNode_:show()
    self.loadingBg_:hide()
    local evtContent = evt.data -- item
    local evtData = evtContent.data_  -- data
    local v = evtData
    -- 创建Item
    if not self.tabGroup_ then
        self.tabGroup_ = tx.ui.CheckBoxButtonGroup.new()
    end
    local curShowActNum = #self.contentList_
    local dir = 98
    local x, y = 158, HEIGHT - 171
    y = y - dir*curShowActNum
    local btn_w, btn_h = 260, 90
    local btn = cc.ui.UICheckBoxButton.new({
            on="#common/pop_left_tab_selected.png",
            off="#common/pop_left_tab_normal.png",
            off_pressed = "#common/pop_left_tab_pressed.png"},
            {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("on", ui.newTTFLabel({text = v.title, size = 24, color = TAB_ON_COLOR, align = ui.TEXT_ALIGN_CENTER, dimensions = DIMENSIONS}))
        :setButtonLabel("off", ui.newTTFLabel({text = v.title, size = 24, color = TAB_OFF_COLOR, align = ui.TEXT_ALIGN_CENTER, dimensions = DIMENSIONS}))
        :setButtonLabelAlignment(display.CENTER)
        :pos(x, y)
        :addTo(self.contentNode_)
    self.tabGroup_:addButton(btn)

    table.insert(self.contentList_,evtContent)
    if #self.contentList_==1 then
        self.tabGroup_:getButtonAtIndex(self.selected_):setButtonSelected(true):updateButtonLable_() --刷新label状态，感觉是引擎bug
        self.tabGroup_:onButtonSelectChanged(handler(self, self.onMainTabChange))
        self:onTabChange_(self.selected_)
    end
end

function ActivityCenterPopup:onCleanup()
    sa.HttpService.CANCEL(self.getConfigRequestId_)

    if self.getConfigScheduleHandle_ then
        scheduler.unscheduleGlobal(self.getConfigScheduleHandle_)
    end

    if self.onLoadImageCallbackId_ then
        sa.EventCenter:removeEventListener(self.onLoadImageCallbackId_)
    end

    display.removeSpriteFramesWithFile("act_holiday_texture.plist", "act_holiday_texture.png")
end

return ActivityCenterPopup