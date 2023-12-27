local DailyTasksPopup = class("DailyTasksPopup", tx.ui.Panel)
local LoginRewardView   = import("app.module.loginreward.LoginRewardView")
local DailyTask = import(".DailyTask")
local DailyTasksListItem = import(".DailyTasksListItem")
local AchievementTasksListItem = import(".AchievementTasksListItem")

local WIDTH, HEIGHT = 1136, 746

local LOAD_TASK_LIST_ALREAD_EVENT_TAG = 99100
local GET_REWARD_ALREAD_EVENT_TAG = 99101
local ON_REWARD_ALREAD_EVENT_TAG = 99102
local GOTO_TASK = 99111

local LOAD_ACHIEVE_LIST_ALREAD_EVENT_TAG = 99200
local GET_ACHIEVE_REWARD_ALREAD_EVENT_TAG = 99201
local ON_ACHIEVE_REWARD_ALREAD_EVENT_TAG = 99202

function DailyTasksPopup:ctor(selected)
    DailyTasksPopup.super.ctor(self, {WIDTH, HEIGHT})
    
    display.addSpriteFrames("dailytasks_texture.plist", "dailytasks_texture.png")

    self.selected_ = selected or 1

    if tx.userData.canTasksReward then
        self.selected_ = 1
    elseif tx.userData.canAchieveReward then
        self.selected_ = 2
    end

    self:addMainUI_()

    self:addEventListeners_()

    sa.DataProxy:setData(tx.dataKeys.NEW_LOGIN_REWARD, tx.userData.loginReward.canReward)

    local curScene = display.getRunningScene()
    if curScene.name == "GameHallScene" then
        if curScene.controller_ then
            self.hall_controller_ = curScene.controller_
        end
    end

    self:setLoading(true)
end

function DailyTasksPopup:addEventListeners_()
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.LOAD_TASK_LIST_ALREAD, handler(self, self.loadDataCallback), LOAD_TASK_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_RWARD, handler(self, self.onGetReward_), GET_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_RWARD_ALREADY, handler(self, self.onGetRewardAlready_), ON_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GOTO_TASK, handler(self, self.goto_), GOTO_TASK)

    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.LOAD_ACHIEVE_LIST_ALREAD, handler(self, self.loadAchieveDataCallback), LOAD_ACHIEVE_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_ACHIEVE_RWARD, handler(self, self.onGetReward_), GET_ACHIEVE_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:addEventListener(tx.DailyTasksEventHandler.GET_ACHIEVE_RWARD_ALREADY, handler(self, self.onGetAchieveRewardAlready_), ON_ACHIEVE_REWARD_ALREAD_EVENT_TAG)

    self.onLoginRewarDataObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_LOGIN_REWARD, handler(self, self.showLoginRewarPoint_))
end

function DailyTasksPopup:addMainUI_()
    self:setImgTitleStyle("#lang/pop_title_task.png")

    self:setMainTabStyle(sa.LangUtil.getText("DAILY_TASK", "TAB_TEXT"), self.selected_, handler(self, self.onMainTabChange))

    local bg = self.background_
    local btn = cc.ui.UIPushButton.new({normal = "#dialogs/dailytasks/dailytasks_loginreward_btn_normal.png", pressed="#dialogs/dailytasks/dailytasks_loginreward_btn_pressed.png"})
        :onButtonClicked(handler(self, self.onLoginRewardClicked_))
        :pos(WIDTH - 170, HEIGHT - 75)
        :addTo(bg)

    self.loginRewarPoint_ = display.newSprite("#common/common_red_point.png")
        :pos(25, 20)
        :addTo(btn)

    local w, h = 820, 590
    local frame = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(w, h))
        :align(display.RIGHT_BOTTOM, WIDTH - 28, 30)
        :addTo(bg)

    --内容列表
    local list_w, list_h = w, h - 10
    self.taskListView_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h)
            }, 
            DailyTasksListItem
        )
        :pos(w/2, h/2)
        :addTo(frame)
        
    self:getTasksListData()

    self.achievementListView_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h), 
            }, 
            AchievementTasksListItem
        )
        :pos(w/2, h/2)
        :addTo(frame)
        :hide()

    self:onTabChange_(self.selected_)
end

function DailyTasksPopup:onShowed()
    if self.taskListData then
        self.taskListView_:setData(self.taskListData)
        self:setLoading(false)
    end

    if self.achievementListData then
        self.achievementListView_:setData(self:transformData(self.achievementListData))
        self:setLoading(false)
    end

    self.isShowed = true

    if self.taskListView_ then
        self.taskListView_:setScrollContentTouchRect()
    end

    if self.achievementListView_ then
        self.achievementListView_:setScrollContentTouchRect()
    end
end

function DailyTasksPopup:transformData(data)
    return sa.transformDataToGroup(data, AchievementTasksListItem.ROW_NUM)
end

function DailyTasksPopup:getTasksListData()
    self:setLoading(true)
    sa.EventCenter:dispatchEvent(tx.DailyTasksEventHandler.GET_TASK_LIST)
end

function DailyTasksPopup:getAchieveListData()
    self:setLoading(true)
    sa.EventCenter:dispatchEvent(tx.DailyTasksEventHandler.GET_ACHIEVE_LIST)
end

function DailyTasksPopup:loadDataCallback(evt)
    self.taskListData = evt.data
    if self.isShowed then
        self.taskListView_:setData(self.taskListData)
        self:setLoading(false)
    end
end

function DailyTasksPopup:showLoginRewarPoint_(isShow)
    if isShow == 1 then
        self.loginRewarPoint_:show()
    else
        self.loginRewarPoint_:hide()
    end
end

function DailyTasksPopup:loadAchieveDataCallback(evt)
    self.achievementListData = evt.data

    if self.isShowed then
        self.achievementListView_:setData(self:transformData(self.achievementListData))
        self:setLoading(false)
    end
end

function DailyTasksPopup:onMainTabChange(evt)
    self:onTabChange_(evt.selected)
end

function DailyTasksPopup:onTabChange_(selectedTab)
    self:setLoading(false)
    self.selectedTab = selectedTab
    if selectedTab == 1 then
        self.taskListView_:show()
        self.achievementListView_:hide()
    else
        if not self.achievementListData then
            self:getAchieveListData()
        end
        self.taskListView_:hide()
        self.achievementListView_:show()
    end
end

function DailyTasksPopup:onLoginRewardClicked_()
    LoginRewardView.new():showPanel()
end

function DailyTasksPopup:onGetReward_()
    self:setLoading(true)
end

--     1 => 初级场对局,
--     2 => 中级场对局,
--     3 => 高级场对局,
--     4 => 比赛场对局,
--     5 => 获胜, 连续胜利, 打赏荷官, ALL IN
--     6 => 赠送好友筹码,
--     7 => 发送邀请
--     8 => 分享到FACEBOOK,
--     9 => 赠送礼物
--     10 => 玩老虎机,
--     11 => 开宝箱,
--     12 => 玩大转盘,
--     13 => 打开推送
--     14 => 
--     15 => 
function DailyTasksPopup:goto_(evt)
    local task = evt.data
    if task.goto == 1 or task.goto == 2 or task.goto == 3 then
        -- app:enterGameHall(1, {task.goto})
        app:enterGameHall(1)
    elseif task.goto == 4 then
        app:enterGameHall(2)
    elseif task.goto == 5 then
        if self.hall_controller_ then
            self.hall_controller_.scene_:quickStart()
        end
    elseif task.goto == 6 then  
        local FriendPopup = import("app.module.friend.FriendPopup")
        FriendPopup.new():showPanel()
    elseif task.goto == 7 then
        local InvitePopup = import("app.module.facebookinvite.InvitePopup")
        InvitePopup.new():showPanel()
    elseif task.goto == 8 then
    elseif task.goto == 9 then
        if self.hall_controller_ then
            self.hall_controller_.scene_:quickStart()
        end
    elseif task.goto == 10 then
        if self.hall_controller_ then
            self.hall_controller_:showSlotPopup()
        end
    elseif task.goto == 11 then
    elseif task.goto == 12 then
        display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
            local LuckturnPopup = import("app.module.luckturn.LuckturnPopup")
            LuckturnPopup.new():showPanel()
        end)
    elseif task.goto == 13 then
        tx.ui.Dialog.new({
            align = ui.TEXT_ALIGN_LEFT,
            messageText = sa.LangUtil.getText("SETTING", "PUSH_TIPS"),
            firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
            secondBtnText = sa.LangUtil.getText("COMMON", "CONFIRM"),
            callback = function (btnType)
                if btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
                    self.appForegroundListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.APP_ENTER_FOREGROUND, handler(self, self.setPushEnabledCallback_))
                    tx.Native:setPushEnabled()
                end
            end
        }):show()
    end

    if task.goto ~= 13 then
        self:hidePanel()
    end
end

function DailyTasksPopup:onGetRewardAlready_(evt)
    self.taskListView_:setData(nil)
    self.taskListView_:setData(evt.data)
    self:setLoading(false)
end

function DailyTasksPopup:onGetAchieveRewardAlready_(evt)
    self.achievementListView_:setData(nil)
    self.achievementListView_:setData(self:transformData(evt.data))
    self:setLoading(false)
end

function DailyTasksPopup:setPushEnabledCallback_()
    if self.appForegroundListenerId_ then
        sa.EventCenter:removeEventListener(self.appForegroundListenerId_)
        self.appForegroundListenerId_ = nil
    end

    self:performWithDelay(function ()
        local isEnabled = tx.Native:checkPushEnabled()
        if isEnabled then
            tx.userData.canTasksReward = true
            sa.EventCenter:dispatchEvent({name=tx.eventNames.TASK_REWARD_POINT})
            tx.userDefault:setBoolForKey(tx.cookieKeys.IS_FINISHED_PUSH_TASK .. tx.userData.uid .. os.date("%Y%m%d"), true)
            self:hidePanel()
        end
    end, 0.1)
end

function DailyTasksPopup:onExit()
    sa.EventCenter:removeEventListenersByTag(LOAD_TASK_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(GET_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(ON_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(GOTO_TASK)
    tx.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)

    sa.EventCenter:removeEventListenersByTag(LOAD_ACHIEVE_LIST_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(GET_ACHIEVE_REWARD_ALREAD_EVENT_TAG)
    sa.EventCenter:removeEventListenersByTag(ON_ACHIEVE_REWARD_ALREAD_EVENT_TAG)

    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_LOGIN_REWARD, self.onLoginRewarDataObserver)
end

function DailyTasksPopup:onCleanup()
    display.removeSpriteFramesWithFile("dailytasks_texture.plist", "dailytasks_texture.png")
end

return DailyTasksPopup