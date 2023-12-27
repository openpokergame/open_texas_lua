-- 游戏玩牌倒计时奖励
local RoomTaskPopup = import(".RoomTaskPopup")
local logger = sa.Logger.new("RoomFastTask")
local RoomFastTask = class("RoomFastTask", function() return display.newNode() end)
local action

function RoomFastTask:ctor(ctx)
    -- 没删除...网络差的惊天大bug
    self.this_ = self
    self:setNodeEventEnabled(true)

    self.ctx = ctx
    local maxretry = 4
    local requestBoxConf
    requestBoxConf = function()
        sa.HttpService.CANCEL(self.requestBoxConfId_)
        self.requestBoxConfId_ = sa.HttpService.POST(
            {
                mod = "TreasureBox",
                act = "get"
            },
            function (data)
                logger:debug("count_down_get:" .. data)
                local callData = json.decode(data)
                if callData and callData.code == 1 then
                    self.isFinished = callData.remainTime<=0 and (tonumber(callData.rewardChip)==nil or tonumber(callData.rewardChip)<=0) --是否倒计时结束，为0
                    self.remainTime = callData.remainTime --倒计时剩余时间
                    self.reward = callData.rewardChip --奖励 钱数
                    self.multiple = callData.multiple --倍数？
                    self:showFunc()
                elseif callData and callData.code==-2 then
                    self:showDefault()
                else
                    maxretry = maxretry - 1
                    if maxretry > 0 then
                        requestBoxConf()
                    else
                        self:showDefault()
                    end
                end
            end,
            function (data)
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestBoxConf()
                else
                    self:showDefault()
                end
            end)
    end
    requestBoxConf()
end

function RoomFastTask:showDefault()
    self.isFinished = true
    self.remainTime = 0
    self.reward = 0
    self.multiple = 1
    self:showFunc()
end

--创建倒计时，判断是否开始倒计时
function RoomFastTask:showFunc()
    if self.this_ then
        self.countStatus = false

        self:showStatus()

        self:bindDataObserver()

        -- 重连
        if self.ctx.model:isSelfInSeat() then
            self:sitDownFunc()
        end
    end
end

--显示不到状态对应的UI
function RoomFastTask:showStatus(isJustGotBoxReward)
    if not self.countButton then
        self.countButton = sp.SkeletonAnimation:create("spine/baoxiang.json","spine/baoxiang.atlas")
            :pos(-43,155)
            :addTo(self)
        display.newScale9Sprite("#common/transparent.png", 0, 0, cc.size(88, 70))
            :addTo(self.countButton)

        self.countButton:setAnimation(0, "2", true)
        ScaleButton(self.countButton,1.05):onButtonClicked(handler(self, self.showRoomTask))
        self.time_ = ui.newTTFLabel({
                text = "",
                size = 24,
                color = cc.c3b(0x77, 0x72, 0xcd),
            })
            :pos(-48,105)
            :addTo(self)
    end
    if self.isFinished then
        self.hasBoxReward_ = false
        self.time_:setString("")
        self:countDownStatus(false)
    elseif not self.isFinished and self.remainTime and self.remainTime <= 0 then
        self.hasBoxReward_ = true
        self.time_:setString("")
        self:countDownStatus(false)
    else
        self.hasBoxReward_ = false
        local timeStr = sa.TimeUtil:getTimeString(self.remainTime)
        self.time_:setString(timeStr)
        self:countDownStatus(self.ctx.model:isSelfInSeat())
    end
    self:onNewRewardTask(self.hasNewRewardTask)
    sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.UPDATE_BOX_TASK, data = isJustGotBoxReward})
    local multipleStr = (self.multiple and tonumber(self.multiple) > 1 and "x" .. tostring(self.multiple)) or ""
    -- self.multipleLabel:setString(multipleStr)
end


--倒计时状态
function RoomFastTask:countDownStatus(status)
    if self.countStatus and not status then
        if action then
            self:stopAction(action)
        end
    end
    if not self.countStatus and status then
        action = self:schedule(function ()
            self:countFunc()
        end, 1)
    end
    self.countStatus = status

end

--倒计时计数
function RoomFastTask:countFunc()
    self.remainTime = self.remainTime - 1
    if self.remainTime <= 0 then
        self:showStatus()
    else
        local timeStr = sa.TimeUtil:getTimeString(self.remainTime)
        self.time_:setString(timeStr)
        if self.popup and self.popup.updateCountDownBox then
            self.popup:updateCountDownBox()
        end
    end
end

function RoomFastTask:showRoomTask()
    self.popup = RoomTaskPopup.new()
    self.popup:setCountDownBox(self)
    self.popup:showPanel()
end

--获取奖励
function RoomFastTask:getReward()
    tx.SoundManager:playSound(tx.SoundManager.BOX_OPEN_REWARD)
    sa.HttpService.CANCEL(self.requestBoxAwardId_)
    self.requestBoxAwardId_ = sa.HttpService.POST(
        {
            mod = "TreasureBox" ,
            act = "reward"
         },
        function (data)
            local callData = json.decode(data)
            if callData and callData.code == 1 then
                local multipleStr = (self.multiple and tonumber(self.multiple) > 1 and "x" .. tostring(self.multiple)) or ""
                local money = tonumber(callData.money) or 0
                if money>0 then
                    tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COUNTDOWNBOX", "REWARD", tostring(self.reward) .. multipleStr))
                    tx.userData.money = tx.userData.money + money
                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=money}})
                end
                self.isFinished = callData.nextRemainTime<=0 and (tonumber(callData.nextRewardChip)==nil or tonumber(callData.nextRewardChip)<=0)
                self.remainTime = callData.nextRemainTime
                self.multiple = callData.multiple
                self.reward = callData.nextRewardChip

                self:showStatus(true)
            elseif callData and callData.code == -2 then
                self:showDefault()
            elseif callData and callData.code == -1 then
                self.remainTime = callData.remainTime
                self.multiple = callData.multiple
                self:showStatus()
            else
                self:showDefault()
            end
        end,
        function (data)
            logger:debug("count_down_reward:" .. data)
        end)
end

--提示再玩多久，可以获得什么样的奖励；坐下才开始计时
function RoomFastTask:promptFunc()
    tx.SoundManager:playSound(tx.SoundManager.BOX_OPEN_NORMAL)
    if self.ctx.model:isSelfInSeat() then
        local multipleStr = (self.multiple and tonumber(self.multiple) > 1 and "x" .. tostring(self.multiple)) or ""
        tx.TopTipManager:showToast(sa.LangUtil.getText("COUNTDOWNBOX", "NEEDTIME",
            sa.TimeUtil:getTimeMinuteString(self.remainTime), sa.TimeUtil:getTimeSecondString(self.remainTime), tostring(self.reward) .. multipleStr))
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("COUNTDOWNBOX", "SITDOWN"))
    end
end

function RoomFastTask:onNewRewardTask(hasNewRewardTask)
    if self.this_ then
        self.hasNewRewardTask = hasNewRewardTask
        if hasNewRewardTask or self.hasBoxReward_ then
            self.countButton:setAnimation(0, "1", true)
        else
            self.countButton:setAnimation(0, "2", false)
        end
    end
end

function RoomFastTask:bindDataObserver()
    --宝箱领取失败的时候事件添加了多次 导致事件再次被添加
    if not self.onDataObserver then
        self.onDataObserver = sa.DataProxy:addDataObserver(tx.dataKeys.SIT_OR_STAND, handler(self, self.sitStatusFunc))
        self.onNewRewardTaskObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_REWARD_TASK, handler(self, self.onNewRewardTask))
    end
end

function RoomFastTask:unbindDataObserver()
    sa.DataProxy:removeDataObserver(tx.dataKeys.SIT_OR_STAND, self.onDataObserver)
    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_REWARD_TASK, self.onNewRewardTaskObserver)
end

function RoomFastTask:sitStatusFunc(isSit)
    if self.this_ then
        if isSit then
            self:sitDownFunc()
        else
            self:standUpFunc()
        end
    end
end

--坐下，发送请求，开始计时
function RoomFastTask:sitDownFunc()
    self:showStatus()
end

--站起，停止倒计时
function RoomFastTask:standUpFunc()
    self:countDownStatus(false)
end

function RoomFastTask:dele()
    sa.HttpService.CANCEL(self.requestBoxConfId_)
    sa.HttpService.CANCEL(self.requestBoxAwardId_)
    self:unbindDataObserver()
    if action then
        self:stopAction(action)
    end
end

function RoomFastTask:onCleanup()
    self:dele()
end

return RoomFastTask
