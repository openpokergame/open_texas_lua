-- 邀请好友奖励记录视图

local InviteRewardRecordView = class("InviteRewardRecordView", function()
    return display.newNode()
end)

local FriendData = import("app.module.friend.FriendData")
local InviteRewardTipsView = import(".InviteRewardTipsView")

local INVITE_NUM --邀请奖励需要达到的人数
local PROGRESS_W, PROGRESS_H = 704, 16 --进度条宽高
local PACK_IMG = {
    "#dialogs/friend/friend_pack_1.png",
    "#dialogs/friend/friend_pack_2.png",
    "#dialogs/friend/friend_pack_3.png",
    "#dialogs/friend/friend_pack_4.png",
    "#dialogs/friend/friend_pack_4.png"
}

local DIR = 140
local POS_X = {0, DIR, DIR * 2, DIR * 3, DIR * 4, DIR * 5}

function InviteRewardRecordView:ctor(controller, data)
    self.controller_ = controller
    self.data_ = data
    self.rewards_ = {2, 2, 2, 2, 2} --奖励状态，0可领取， 1已领取，2不可领取
    self.curInviteNum_ = 0 --当前邀请人数

    self:addMainUI_()
end

function InviteRewardRecordView:addMainUI_()
    self:getRewardRecordConfig_()
    self:addRewardNode_()
end

--转换PHP配置数据结构
function InviteRewardRecordView:getRewardRecordConfig_()
    local data = self.data_
    local invited = data.invited
    local rewarded = data.rewarded
    local configRewardNum = data.configRewardNum
    local index = 0
    for i, v in ipairs(configRewardNum) do
        if invited >= v then
            index = i
        end
    end

    for i = 1, index do
        self.rewards_[i] = rewarded[i]
    end

    self.curInviteNum_ = invited

    INVITE_NUM = clone(configRewardNum)
    table.insert(INVITE_NUM, 1, 0)

    --更新红点状态
    FriendData.hasNewMessage = false
    for i = 1, index do
        if rewarded[i] == 0 then
            FriendData.hasNewMessage = true
            break
        end
    end
    sa.DataProxy:setData(tx.dataKeys.NEW_FRIEND_DATA, FriendData.hasNewMessage)
end

function InviteRewardRecordView:addRewardNode_()
    local bg = display.newScale9Sprite("#dialogs/friend/friend_progress_bg.png", 0, 0, cc.size(PROGRESS_W, PROGRESS_H)):addTo(self)
    self.bg_ = bg
    for i = 1, 4 do
        display.newSprite("#dialogs/friend/friend_progress_line.png")
            :pos(POS_X[i + 1], PROGRESS_H/2)
            :addTo(bg)
    end

    self.progress_ = display.newProgressTimer("#dialogs/friend/friend_progress.png", display.PROGRESS_TIMER_BAR)
        :pos(PROGRESS_W/2, PROGRESS_H/2)
        :addTo(bg, 1)
    self.progress_:setMidpoint(cc.p(0, 0.5))
    self.progress_:setBarChangeRate(cc.p(1, 0))
    self.progress_:setPercentage(50)

    local dir = 202
    local sy = -20
    for i = 1, 6 do
        ui.newTTFLabel({text = INVITE_NUM[i], size = 24})
            :pos(POS_X[i], sy)
            :addTo(bg)
    end

    self.lightList_ = {}
    self.darkList_ = {}
    self.rewardBtns_ = {}

    sy = PROGRESS_H/2 + 50
    for i = 1, 5 do
        local sx = POS_X[i + 1]
        self.lightList_[i] = display.newSprite("#dialogs/friend/friend_light.png")
            :pos(sx, sy)
            :addTo(bg)
            :hide()

        self.rewardBtns_[i] = cc.ui.UIPushButton.new(PACK_IMG[i])
            :onButtonPressed(handler(self, self.showRewardTips_))
            :onButtonRelease(handler(self, self.hideRewardTips_))
            :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
            :pos(sx, sy)
            :addTo(bg, 1, i)

        self.darkList_[i] = display.newSprite("#dialogs/friend/friend_pack_dark.png")
            :pos(sx, sy)
            :addTo(bg, 1)
    end

    self.labelFrame_ = display.newSprite("#dialogs/friend/friend_num_frame.png")
        :addTo(bg, 2)

    self.progressLabel_ = ui.newTTFLabel({text = "", color = cc.c3b(0xff, 0xff, 0xff), size = 20})
        :pos(48, 37)
        :addTo(self.labelFrame_)

    local data = self.data_
    ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "INVITE_REWARD_TIPS", data.invited, data.totalReward), color = styles.FONT_COLOR.CONTENT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
        :pos(PROGRESS_W/2, -90)
        :addTo(bg)

    self:updateProgressValue_(self.curInviteNum_)
end

function InviteRewardRecordView:onGetRewardClicked_(evt)
    local tag = evt.target:getTag()
    if self.rewards_[tag] == 0 then
        self.rewards_[tag] = 1
        self:updateRewardState_(tag)
        
        self.controller_:getInviteReward(tag)
    elseif self.rewards_[tag] == 2 then
        local last = INVITE_NUM[tag + 1] - self.curInviteNum_
        tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "GET_REWARD_TIPS_2", last))
    end
end

function InviteRewardRecordView:showRewardTips_(evt)
    self:hideRewardTips_()

    local tag = evt.target:getTag()
    local x, y = self.rewardBtns_[tag]:getPosition()
    local view = InviteRewardTipsView.new(self.data_.giftBag[tag])
        :align(display.RIGHT_BOTTOM, x + 60, y + 15)
        :addTo(self.bg_, 10)

    self.rewardTipsView_ = view
end

function InviteRewardRecordView:hideRewardTips_()
    if self.rewardTipsView_ then
        self.rewardTipsView_:removeFromParent()
        self.rewardTipsView_ = nil
    end
end

function InviteRewardRecordView:updateProgressValue_(num)
    local value = 0
    local index = 1
    local maxNum = INVITE_NUM[6]
    if num >= maxNum then
        value = 1
    else
        for i, v in ipairs(INVITE_NUM) do
            if num > v then
                index = i
            end
        end

        local value1 = (index - 1) * 0.2
        local last = num - INVITE_NUM[index]
        local total = INVITE_NUM[index + 1] - INVITE_NUM[index]
        local value2 = last / total * 0.2
        value = value1 + value2
        maxNum = INVITE_NUM[index + 1]
    end

    self.progress_:setPercentage(value * 100)

    self.labelFrame_:align(display.BOTTOM_CENTER, PROGRESS_W * value, PROGRESS_H/2)

    self.progressLabel_:setString(num .. "/" .. maxNum)

    for i, v in ipairs(self.rewards_) do
        self:updateRewardState_(i)
    end
end

function InviteRewardRecordView:updateRewardState_(index)
    local state = self.rewards_[index]
    self.lightList_[index]:setVisible(state == 0)
    self.darkList_[index]:setVisible(state == 2)
end

return InviteRewardRecordView