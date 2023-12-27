local RegisterRewardInfo = class("RegisterRewardInfo", function()
	return display.newNode()
end)

local CountLabel = import("openpoker.ui.CountLabel")

local WIDTH, HEIGHT = 277, 379
local BTN_X, BTN_Y = WIDTH*0.5, HEIGHT*0.5
local REWARD_LABEL_X, REWARD_LABEL_Y = WIDTH*0.5, HEIGHT - 55
local REWARD_TIPS_X, REWARD_TIPS_Y = WIDTH*0.5, 55
local ICON_X, ICON_Y = WIDTH*0.5, HEIGHT*0.5 + 20
local CHIP_ANIMATION = "1" --JB金币动画
local BG_IMAGE = {
    "img/register_reward_frame_1.jpg",
    "img/register_reward_frame_2.jpg",
    "img/register_reward_frame_3.jpg"
}

local ICON_IMG = {
    "#dialogs/register/register_reward_icon_1.png",
    "#dialogs/register/register_reward_icon_2.png",
    "#dialogs/register/register_reward_icon_2.png"
}

local GIFT_IMG = {
    "#dialogs/register/register_reward_gift_1.png",
    "#dialogs/register/register_reward_gift_2.png"
}

function RegisterRewardInfo:ctor(data, delegate)
    self:setNodeEventEnabled(true)

    self:size(WIDTH, HEIGHT):align(display.CENTER)

	self.data_ = data
	self.delegate_ = delegate
	self.key_ = "register_reward_" .. tx.userData.uid .. "_" .. data.index

    display.newSprite(BG_IMAGE[data.index])
        :pos(WIDTH/2, HEIGHT/2)
        :addTo(self)

    if data.state == 1 then
        self:addCanRewardInfo_()
    else
        if data.state == 0 then
            self:addAlreadyRewardInfo_()
        elseif data.state == 2 then
            self:addNextRewardInfo_()
        end
    end
end

function RegisterRewardInfo:addCanRewardInfo_()
	local data = self.data_
    local x, y = WIDTH*0.5, HEIGHT*0.5
    self.light_ = sp.SkeletonAnimation:create("spine/zc.json", "spine/zc.atlas")
        :pos(BTN_X, BTN_Y)
        :addTo(self)
    self.light_:setAnimation(0, 1, true)

    self.giftIcon_ = display.newSprite(GIFT_IMG[1])
        :pos(ICON_X, ICON_Y)
        :addTo(self, 2)

    self.rewardIcon_ = display.newSprite(ICON_IMG[self.data_.index])
        :pos(ICON_X - 5, ICON_Y - 15)
        :addTo(self, 2)
        :hide()

	self.btn_ = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(WIDTH, HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
        :pos(BTN_X, BTN_Y)
        :addTo(self)

    self.rewardLabel_ = CountLabel.new({text = "", font = "fonts/xiaohuang.fnt", UILabelType = 1, proportion = 0.15})
        :setMinDifference(4)
        :pos(REWARD_LABEL_X, REWARD_LABEL_Y)
        :addTo(self)

    self.getRewardLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CLICK_GET"), size = 30, color = cc.c3b(0xff, 0xe4, 0x70)})
        :pos(REWARD_TIPS_X, REWARD_TIPS_Y)
        :addTo(self)
end

function RegisterRewardInfo:addAlreadyRewardInfo_()
    self.reward_ = self:getRewardRecord_()

    display.newSprite(ICON_IMG[self.data_.index])
        :pos(ICON_X, ICON_Y)
        :addTo(self)

    local reward = sa.formatNumberWithSplit(self.reward_)
    ui.newBMFontLabel({text = reward, font = "fonts/xiaohuang.fnt"})
    	:pos(REWARD_LABEL_X, REWARD_LABEL_Y)
    	:addTo(self)

    ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "ALREADY_GET"), size = 30})
        :pos(REWARD_TIPS_X, REWARD_TIPS_Y)
        :addTo(self)
end

function RegisterRewardInfo:addNextRewardInfo_()    
    display.newSprite(GIFT_IMG[2])
        :pos(ICON_X, ICON_Y)
        :addTo(self, 2)

    ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "NEXT_GET"), size = 30, color = cc.c3b(0x54, 0x1a, 0x01)})
        :pos(REWARD_TIPS_X, REWARD_TIPS_Y)
        :addTo(self)
end

function RegisterRewardInfo:onGetRewardClicked_()
    local reward = self.delegate_:getRegisterReward()
    self.btn_:setButtonEnabled(false)
    if reward then
        self:onGetRewardSuccess_(reward)
    else
        self:setLoading_(true)
        sa.HttpService.POST(
            {
                mod = "RegisterReward",
                act = "regReward",
                type = self.data_.index
            },
            function(data)
                self:setLoading_(false)
                local callData = json.decode(data)
                if callData.code == 1 then
                    tx.userData.registerReward.code = 0
                    self:onGetRewardSuccess_(callData)
                else
                    self.btn_:setButtonEnabled(true)
                    tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "REWARD_FAIL"))
                end
            end,
            function()
                self:setLoading_(false)
                self.btn_:setButtonEnabled(true)
                tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "REWARD_FAIL"))
            end)
    end
end

function RegisterRewardInfo:onGetRewardSuccess_(data)
    self.reward_ = data.money
    self.diamonds_ = data.diamons or 0
    self.props_ = data.props or 0
    self:saveRewardRecord_(self.reward_)
    self:playGetRewardAnimation_()
end

function RegisterRewardInfo:saveRewardRecord_(reward)
    tx.userDefault:setIntegerForKey(self.key_, reward)
end

function RegisterRewardInfo:playGetRewardAnimation_()
    self.getRewardLabel_:setTextColor(cc.c3b(0xff, 0xff, 0xff))
    self.getRewardLabel_:setString(sa.LangUtil.getText("COMMON", "ALREADY_GET"))
    self.light_:hide()
    self.giftIcon_:fadeOut(0.2)

    transition.scaleTo(self, {time = 0.2, scaleX = 0.1, scaleY = 0.9, onComplete = function()
        self.rewardIcon_:show():scale(0.2):scaleTo(0.1, 1)
        transition.scaleTo(self, {time = 0.1, scale = 1, onComplete = function()
            self.delegate_:playGetRewardAnimation()
            self:playCountRewardAnimation_()
            self:playChipAddAnimation_()
        end})
    end})  
end

function RegisterRewardInfo:playCountRewardAnimation_()
	self.rewardLabel_:startCount(0, self.reward_)
end

function RegisterRewardInfo:playChipAddAnimation_()
    self:performWithDelay(function()
        tx.userData.money = tx.userData.money + self.reward_
        tx.userData.diamonds = tx.userData.diamonds + self.diamonds_
        sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE,data={money=self.reward_, diamonds = self.diamonds_, props = self.props_}})
        tx.schedulerPool:delayCall(function()
            self.delegate_:hidePanel()
        end, 2)
    end, 1.5)
end

function RegisterRewardInfo:getRewardRecord_()
	return tx.userDefault:getIntegerForKey(self.key_, 10000)
end

function RegisterRewardInfo:setLoading_(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(WIDTH/2, HEIGHT/2)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

return RegisterRewardInfo