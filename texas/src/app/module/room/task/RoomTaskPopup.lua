local RoomTaskItem = import(".RoomTaskItem")
local DailyTask = import("app.module.dailytasks.DailyTask")

local RoomTaskPopup = class("RoomTaskPopup", function() return display.newNode() end)
RoomTaskPopup.ELEMENTS = {
    "bg",
    "bottom.labelTime",
    "bottom.labelAward",
    "bottom.btnClock.labelClock",
}

local WIDTH = 400
local HEIGHT = 378
local TEXT_COLOR = cc.c3b(0xEE, 0xEE, 0xEE)

RoomTaskPopup.LOAD_TASK_LIST_ALREAD_EVENT_TAG = 93100
RoomTaskPopup.GET_REWARD_ALREAD_EVENT_TAG = 93101
RoomTaskPopup.ON_REWARD_ALREAD_EVENT_TAG = 93102
RoomTaskPopup.UPDATE_BOX_TASK = 93103

function RoomTaskPopup:ctor()
    self:setNodeEventEnabled(true)
    tx.ui.EditPanel.bindElementsToTarget(self,"dialog_room_task.csb")
    self:pos(display.width + WIDTH * 0.5, HEIGHT * 0.5 + 230)

    ImgButton(self.bottom.btnClock,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        :onButtonClicked(buttontHandler(self, function(obj)
            if self.countDownBox and self.countDownBox.getReward then
                self.countDownBox:getReward()
            end
        end))

    local listWidth,listHeight = 406,350
    RoomTaskItem.WIDTH = listWidth
    RoomTaskItem.HEIGHT = listHeight/3
    self.taskList_ = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * listWidth, -0.5 * listHeight, listWidth, listHeight),
        }, RoomTaskItem)
        :pos(0, 50)
        :addTo(self)
        :hideScrollBar()
    self.taskList_.touchNode_:setTouchEnabled(false)
    self.taskList_.onItemClick = handler(self, self.onItemClick_)
    self.bottom.btnClock.labelClock:setString(sa.LangUtil.getText("COMMON","GET"))

    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.LOAD_TASK_LIST_ALREAD, handler(self, self.loadDataCallback), RoomTaskPopup.LOAD_TASK_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_RWARD, handler(self, self.onGetReward_), RoomTaskPopup.GET_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_RWARD_ALREADY, handler(self, self.loadDataCallback), RoomTaskPopup.ON_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.UPDATE_BOX_TASK, handler(self, self.updateCountDownBox), RoomTaskPopup.UPDATE_BOX_TASK)

    self:getTasksListData()
end

function RoomTaskPopup:onItemClick_(data)
    sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GET_RWARD, data = data})
end

function RoomTaskPopup:onCleanup()
    if self.countDownBox then
        self.countDownBox.popup = nil
        self.countDownBox = nil
    end
    sa.EventCenter:removeEventListenersByTag(RoomTaskPopup.LOAD_TASK_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(RoomTaskPopup.GET_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(RoomTaskPopup.ON_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(RoomTaskPopup.UPDATE_BOX_TASK)
end

function RoomTaskPopup:updateUI(evt)
    local showList = {}
    for k,v in ipairs(self.taskData) do
        table.insert(showList,v)
        if #showList>=3 then
            break
        end
    end
    self.showTaskData_ = showList
    self.taskList_:setData(showList)
    -- 领取完任务直接关闭
    if evt and type(evt)=="table" and evt.name==tx.DailyTasksEventHandler.GET_RWARD_ALREADY then
        self:checkAutoHide()
    end
end

function RoomTaskPopup:getTasksListData()
    self:setLoading(true)
    sa.EventCenter:dispatchEvent(tx.DailyTasksEventHandler.GET_TASK_LIST)
end

function RoomTaskPopup:setCountDownBox(box)
    self.countDownBox = box
    if box then
        self:updateCountDownBox()
    end
end

function RoomTaskPopup:updateCountDownBox(evt)
    local box = self.countDownBox
    if box then
        if box.isFinished then
            self.bottom.labelTime:setString("00:00")
            self.bottom.labelAward:setString(sa.LangUtil.getText("DAILY_TASK", "HAD_FINISH"))
            self.bottom.btnClock:hide()
        else
            local multiple_ = (box.multiple and tonumber(box.multiple) > 1 and box.multiple) or 1
            -- self.getRewardButtonLabel:setString(sa.LangUtil.getText("CRASH", "CHIPS", box.reward * multiple_))
            if box.remainTime and box.remainTime > 0 then
                self.bottom.btnClock:hide()
                local timeStr = sa.TimeUtil:getTimeString(box.remainTime)
                self.bottom.labelTime:setString(timeStr)
                local str = sa.LangUtil.getText("STORE","FORMAT_CHIP",box.reward)
                self.bottom.labelAward:setString(str)
            else
                self.bottom.labelTime:stopAllActions()
                self.bottom.btnClock:show()
                self.bottom.labelTime:setString("00:00")
                self.bottom.labelAward:setString("")
                local str = sa.LangUtil.getText("STORE","FORMAT_CHIP",box.reward)
                self.bottom.labelTime:setString(str)
            end
        end
    end
    -- 刚刚领取了宝箱奖励
    if evt and type(evt)=="table" and evt.data==true then
        self:checkAutoHide()
    end
end

function RoomTaskPopup:checkAutoHide()
    if self.showTaskData_ and self.countDownBox then
        if self.bottom.btnClock:isVisible() then return; end  --宝箱可以领奖
        for k,v in pairs(self.showTaskData_) do
            if v.status ==  DailyTask.STATUS_CAN_REWARD then
                return
            end
        end
        -- 隐藏
        self:hidePanel()
    end
end

function RoomTaskPopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, 0)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function RoomTaskPopup:loadDataCallback(evt)
    self:setLoading(false)
    self.taskData = evt.data
    self:updateUI(evt)
end

function RoomTaskPopup:onGetReward_()
    self:setLoading(true)
end

function RoomTaskPopup:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function RoomTaskPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function RoomTaskPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width + WIDTH * 0.5, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function RoomTaskPopup:onShowPopup()
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width - WIDTH * 0.5+9, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
            if self.taskList_ then
                self.taskList_:setScrollContentTouchRect()
            end
        end
    end})
end

return RoomTaskPopup