local LuckturnView = class("LuckturnView", function()
    return display.newNode()
end)

local NetworkSprite = import("openpoker.ui.NetworkSprite")

local ADD_SPEED = 0.05 --加速度
local MAX_ROTATE_SPEED = 30 --最大旋转速度
local STOP_STATE = 0 --停止状态
local REQUERTING_STATE = 1 --正在发发送请求状态
local REQUERT_END_STATE = 2 --请求结束状态
local TURN_END_DELAY_TIME = 0.2 --PHP请求结束以后的延时，继续旋转的时间
local AUTO_RESTORE_TIME = 6 * 60 * 60 --免费次数自动回复时间

function LuckturnView:ctor(controller)
    self:setNodeEventEnabled(true)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame_))

    self.controller_ = controller

    self.firstFee_ = true

    self.isContent_ = false

    self:addMainUI_()
end

function LuckturnView:updateUI(data, isCache)
    self.data_ = data
    self:init_()
    local config = data.config
    AUTO_RESTORE_TIME = data.countdownTime * 60 * 60

    if #config ~= 0 then
        if isCache then
            self:addRewardContent_(config)
        else
            self.isConfig_ = true
            self:addRewardContent_(config)
            -- self:addLuckturnBtnNode_()
            self:scheduleUpdate()
        end
    end
    
end

function LuckturnView:init_()
    local data = self.data_

    self.freeTimes_ = data.freetimes --免费次数

    self.count_ = 0

    self.currentRotatVal_ = 0 --当前旋转总角度，360取余

    self.isSuccess_ = false --是否抽奖成功

    self.state_ = STOP_STATE --当前状态

    self.curSpeed_ = 0 --当前旋转速度

    self.resultId_ = 0 --抽奖id

    self.turnTime_ = TURN_END_DELAY_TIME

    self.destDegree_ = 0 --最终目标还需要旋转的角度

    self.isTurning_ = false --是否正在旋转

    self.isConfig_ = false
end

function LuckturnView:addMainUI_()
    self.turnNode_ = display.newNode()
        :pos(0, 28)
        :addTo(self)

    --转盘
    local rotate = {0, 90, 180, 270}
    for i = 1, 4 do
        display.newSprite("img/luckturn_frame_1.png")
            :align(display.BOTTOM_RIGHT)
            :rotation(rotate[i])
            :addTo(self.turnNode_)
    end

    display.newSprite("img/luckturn_frame_2.png")
        :align(display.LEFT_CENTER, 0, 27)
        :addTo(self)

    display.newSprite("img/luckturn_frame_2.png")
        :align(display.RIGHT_CENTER, 0, 27)
        :flipX(true)
        :addTo(self)

    --中间亮光
    local x, y = 0, 27
    self.middleNormalLight_ = display.newNode():addTo(self)
    display.newSprite("img/luckturn_middle_light_1.png")
        :align(display.RIGHT_CENTER, x, y)
        :flipX(true)
        :addTo(self.middleNormalLight_)

    display.newSprite("img/luckturn_middle_light_1.png")
        :align(display.LEFT_CENTER, x, y)
        :addTo(self.middleNormalLight_)

    self.middleTurnLight_ = display.newNode():addTo(self)
    display.newSprite("img/luckturn_middle_light_2.png")
        :align(display.RIGHT_CENTER, x, y)
        :flipX(true)
        :addTo(self.middleTurnLight_)

    display.newSprite("img/luckturn_middle_light_2.png")
        :align(display.LEFT_CENTER, x, y)
        :addTo(self.middleTurnLight_)

    self:showMiddleNormalLight_()

    --奖励选中框
    self.selectedFrame_ = display.newSprite("#dialogs/luckturn/luckturn_selected_frame.png")
        :align(display.BOTTOM_CENTER)
        :addTo(self.turnNode_)
        :hide()

    --奖励选中亮光
    local x, y = 0, 37
    self.selectedLight_1 = display.newSprite("#dialogs/luckturn/luckturn_light_1.png")
        :align(display.BOTTOM_CENTER, x, y)
        :addTo(self)
        :hide()

    self.selectedLight_2 = display.newSprite("#dialogs/luckturn/luckturn_light_2.png")
        :align(display.BOTTOM_CENTER, x, y)
        :addTo(self)
        :hide()
end

function LuckturnView:addRewardContent_(data)
    if self.isContent_ then
        return
    end

    self.isContent_ = true

    local radius = 160
    local cnd = tx.userData.bigwheelDomain
    for i = 1, 8 do
        local angle = 90 - 45 * (i - 1)
        local img = cnd .. data[i].url

        NetworkSprite.new()
            :align(display.BOTTOM_CENTER)
            :rotation(90 - angle)
            :addTo(self.turnNode_, 1)
            :loadAndCacheImage(img, tx.ImageLoader.CACHE_TYPE_ACT)
    end
end

function LuckturnView:addLuckturnBtnNode_(data,count)
    if not count then count = 0 end
    if tonumber(data.freetimes)>0 then
        if not self.freeBtnNode_ then
            self:addFreeBtnNode_()
        end
        self.freeLabel_:setString(data.freetimes)
    else
        if not self.feeBtnNode_ then
            self:addFeeBtnNode_()
        end
        self.countdown_:setString(sa.TimeUtil:getTimeString1(count))
        if self.isTurning_ then
            self:updateBtnStatus_(false)
        else
            self:updateBtnStatus_(true)
        end
    end
end

--免费按钮
function LuckturnView:addFreeBtnNode_()
    if self.feeBtnNode_ then
        self.feeBtnNode_:removeFromParent()
        self.feeBtnNode_ = nil
        self.feeBtn_ = nil
    end

    self.freeBtnNode_ = display.newNode():addTo(self)
    local node = self.freeBtnNode_

    self.freeBtn_ = cc.ui.UIPushButton.new({normal = "#dialogs/luckturn/luckturn_free_btn_normal.png", pressed = "#dialogs/luckturn/luckturn_free_btn_pressed.png"})
        :pos(0, 22)
        :onButtonClicked(buttontHandler(self, self.onFreeClicked_))
        :addTo(node)

    local x, y = 30, -15

    self.freeLabel_ = ui.newBMFontLabel({text = "", font = "fonts/luckturn_free.fnt"})
        :pos(0, y - 15)
        :addTo(node)

    local arrow = display.newSprite("#dialogs/luckturn/luckturn_arrow_1.png")
        :pos(-x, y)
        :addTo(node)

    local time, dir = 0.5, 5
    arrow:runAction(cc.RepeatForever:create(transition.sequence({
        cc.MoveBy:create(time, cc.p(dir, 0)),
        cc.MoveBy:create(time, cc.p(-dir, 0))
    })))

    arrow = display.newSprite("#dialogs/luckturn/luckturn_arrow_1.png")
        :pos(x, y)
        :flipX(true)
        :addTo(node)

    arrow:runAction(cc.RepeatForever:create(transition.sequence({
        cc.MoveBy:create(time, cc.p(-dir, 0)),
        cc.MoveBy:create(time, cc.p(dir, 0))
    })))
end

--收费按钮
function LuckturnView:addFeeBtnNode_()
    if self.freeBtnNode_ then
        self.freeBtnNode_:removeFromParent()
        self.freeBtnNode_ = nil
        self.freeBtn_ = nil
    end

    self.feeBtnNode_ = display.newNode():addTo(self)

    local node = self.feeBtnNode_  
    self.feeBtn_ = cc.ui.UIPushButton.new({normal = "#dialogs/luckturn/luckturn_fee_btn_normal.png", pressed = "#dialogs/luckturn/luckturn_fee_btn_pressed.png"})
        :pos(0, 22)
        :onButtonClicked(buttontHandler(self, self.onFeeClicked_))
        :addTo(node)

    self.countdown_ = ui.newBMFontLabel({text = "", font = "fonts/luckturn_fee.fnt"})
        :scale(0.68)
        :pos(0, -25)
        :addTo(node)

    local x, y = -26, 20
    ui.newBMFontLabel({text = "1", font = "fonts/luckturn_fee.fnt"})
        :pos(x, y)
        :addTo(node)

    display.newSprite("#common/common_diamond_icon.png")
        :align(display.LEFT_CENTER, x + 20, y + 2)
        :addTo(node)

    y = y + 5
    local arrow = display.newSprite("#dialogs/luckturn/luckturn_arrow_2.png")
        :pos(x - 40, y)
        :addTo(node)

    local time, dir = 0.5, 5
    arrow:runAction(cc.RepeatForever:create(transition.sequence({
        cc.MoveBy:create(time, cc.p(dir, 0)),
        cc.MoveBy:create(time, cc.p(-dir, 0))
    })))

    arrow = display.newSprite("#dialogs/luckturn/luckturn_arrow_2.png")
        :pos(x + 95, y)
        :flipX(true)
        :addTo(node)

    arrow:runAction(cc.RepeatForever:create(transition.sequence({
        cc.MoveBy:create(time, cc.p(-dir, 0)),
        cc.MoveBy:create(time, cc.p(dir, 0))
    })))
end

function LuckturnView:onFreeClicked_()
    if not self.isConfig_ then
        return
    end

    if not self.isTurning_ then
        self:stopLuckturnEndAnimation_()
        self:startTurn()

        self.controller_.view_:changeOneTime(false)
        -- self.freeTimes_ = self.freeTimes_ - 1
        -- if self.freeTimes_ == 0 then
        --     self:addFeeBtnNode_(AUTO_RESTORE_TIME, false)
        -- else
        --     self.freeLabel_:setString(self.freeTimes_)
        -- end
    end
end

function LuckturnView:onFeeClicked_()
    if not self.isConfig_ then
        return
    end

    self:stopLuckturnEndAnimation_()

    local countStr = "0"
    if self.countdown_ then
        countStr = self.countdown_:getString()
    end
    if tonumber(tx.userData.diamonds) > 0 then
        if self.firstFee_ then
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("LUCKTURN", "COUNTDOWN_TIPS", countStr),
                secondBtnText = sa.LangUtil.getText("LUCKTURN", "COST_DIAMOND"),
                callback = function (btntype)
                    if btntype == tx.ui.Dialog.SECOND_BTN_CLICK then
                        self.firstFee_ = false
                        self.controller_:buyLuckturnTimes()
                    end
                end
            }):show()
        else
            self.controller_:buyLuckturnTimes()
        end    
    else
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("LUCKTURN", "COUNTDOWN_TIPS", countStr),
            secondBtnText = sa.LangUtil.getText("LUCKTURN", "BUY_DIAMOND"),
            callback = function (btntype)
                if btntype == tx.ui.Dialog.SECOND_BTN_CLICK then
                    tx.PayGuideManager:openStore(2)
                end
            end
        }):show()
    end
end

function LuckturnView:updateBtnStatus_(enabled)
    if self.freeBtn_ then
        self.freeBtn_:setButtonEnabled(enabled)
    end
    
    if self.feeBtn_ then
        self.feeBtn_:setButtonEnabled(enabled)
    end
end

--开始旋转
function LuckturnView:startTurn()
    if self.isTurning_ then
        return
    end

    self:updateBtnStatus_(false)

    self.luckturnHandle_ = tx.SoundManager:playSound(tx.SoundManager.LUCKTURN_START)
    self.isTurning_ = true
    self.turnTime_ = TURN_END_DELAY_TIME
    self.state_ = REQUERTING_STATE
    self.controller_:playLuckturn()
    self:showMiddleTurnLight_()
end

function LuckturnView:updateLuckturnStatus(isSuccess, data)
    if isSuccess then
        self.resultId_ = data.rewardId
        self.rewardData_ = data.reward
    end
    self.isSuccess_ = isSuccess
    self.state_ = REQUERT_END_STATE
end

--帧事件
function LuckturnView:onEnterFrame_()
    if self.state_ == STOP_STATE then
        return
    end

    if self.state_ == REQUERTING_STATE then -- 正在请求
        self.curSpeed_ = self.curSpeed_ + ADD_SPEED * 30       
        if self.curSpeed_ > MAX_ROTATE_SPEED then
            self.curSpeed_ = MAX_ROTATE_SPEED
        end
    elseif self.state_ == REQUERT_END_STATE then -- 请求结束 
        self.turnTime_ = self.turnTime_ - ADD_SPEED * 0.1
        self.curSpeed_ = self.curSpeed_ + ADD_SPEED * 30       
        if self.curSpeed_ > MAX_ROTATE_SPEED then
            self.curSpeed_ = MAX_ROTATE_SPEED
        end
    end

    if self.turnTime_ <= 0 then
        self:playLuckturnCallback_()
        return
    end

    self.currentRotatVal_ = (self.currentRotatVal_ + self.curSpeed_) % 360
    self.turnNode_:setRotation(self.currentRotatVal_)
end

--抽奖旋转结束回调
function LuckturnView:playLuckturnCallback_()
    local lastDegree = 360 - self.currentRotatVal_ --一圈剩余的角度
    local failResultId = 7
    self.state_ = STOP_STATE
    self.curSpeed_ = 0
    if self.isSuccess_ then
        self.destDegree_ = lastDegree + 360 - (self.resultId_ - 1) * 45
    else
        self.destDegree_ = lastDegree + 360 - (failResultId - 1) * 45 + 22.5
        -- self.freeTimes_ = self.freeTimes_ + 1
        -- if self.freeTimes_ == 1 then --由0次变成一次
        --     self:addFreeBtnNode_()
        -- else
        --     self.freeLabel_:setString(self.freeTimes_)
        -- end
        self.controller_.view_:changeOneTime(true)
    end

    self:playLuckturnAfterTurn_()
end

--抽奖结束以后继续旋转
function LuckturnView:playLuckturnAfterTurn_()
    local action = cc.RotateBy:create(2.5, self.destDegree_)
    local easeAction = cc.EaseExponentialOut:create(action)
    self.turnNode_:runAction(transition.sequence({
        easeAction,
        cc.CallFunc:create(function()
            if self.isSuccess_ then
                self:playLuckturnEndAnimation_()
                self:showRewardDialog_()
            end

            self.isTurning_ = false

            self:updateBtnStatus_(true)

            tx.SoundManager:stopSound(self.luckturnHandle_)
            tx.SoundManager:playSound(tx.SoundManager.LUCKTURN_END)
        end)
    }))
end

--旋转停止，播放抽奖动画
function LuckturnView:playLuckturnEndAnimation_()
    self:showMiddleNormalLight_()
    self.selectedFrame_:show():rotation((self.resultId_ - 1) * 45)
    self.selectedFrame_:runAction(cc.RepeatForever:create(transition.sequence({
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self.selectedLight_1:show()
            self.selectedLight_2:hide()
        end),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self.selectedLight_1:hide()
            self.selectedLight_2:show()
        end)
    })))
end

function LuckturnView:showMiddleNormalLight_()
    self.middleNormalLight_:show()
    self.middleTurnLight_:hide()
end

function LuckturnView:showMiddleTurnLight_()
    self.middleTurnLight_:show()
    self.middleNormalLight_:hide()
end

function LuckturnView:showRewardDialog_()
    local data = {}
    local reward = self.rewardData_
    local evtData = {} -- 动画
    local desc = ""
    if reward.money then
        data.rewardType = 1
        data.num = reward.money
        evtData.money = reward.money
        tx.userData.money = tx.userData.money + tonumber(reward.money)
        desc = sa.LangUtil.getText("STORE", "FORMAT_CHIP", reward.money)
    elseif reward.props then
        data.rewardType = 2
        data.num = reward.props
        evtData.props = reward.props
        desc = sa.LangUtil.getText("STORE", "FORMAT_PROP", reward.props)
        tx.userData.hddjnum = tx.userData.hddjnum + tonumber(reward.props)
    elseif reward.vip then
        data.rewardType = 3
        data.num = reward.vip
        data.vipLevel = 1
        local vipName = sa.LangUtil.getText("VIP", "LEVEL_NAME")
        desc = sa.LangUtil.getText("LUCKTURN", "VIP_REWARD", reward.vip, vipName[data.vipLevel])
        data.desc = desc

        tx.userData.vipinfo.level = data.vipLevel
        tx.userData.vipinfo.day = tonumber(reward.vip)
    end

    self.controller_:setIsPlayChange(true)
    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})

    if (reward.money and reward.money > 3000) or reward.vip then
        app:playChipsDropAnimation()

        local feedData = clone(sa.LangUtil.getText("FEED", "WHEEL_REWARD"))
        feedData.name = sa.LangUtil.formatString(feedData.name, desc)
        data.feedData = feedData

        tx.ui.RewardDialog.new(data, true):showPanel()
    else
        tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COMMON", "REWARD_TIPS", desc))
    end
end

--结束抽奖动画
function LuckturnView:stopLuckturnEndAnimation_()
    self:showMiddleNormalLight_()
    self.selectedFrame_:stopAllActions()
    self.selectedFrame_:hide()
    self.selectedLight_1:hide()
    self.selectedLight_2:hide()
end

function LuckturnView:onCleanup()
    self:unscheduleUpdate()
    tx.SoundManager:stopSound(self.luckturnHandle_)
end

return LuckturnView