local LuckturnController = class("LuckturnController");

function LuckturnController:ctor(view)
	self.view_ = view
    self.failedTips_ = sa.LangUtil.getText("LUCKTURN", "LOTTERY_FAILED")
    self.isPlayChange_ = false
end

--初始化大转盘
function LuckturnController:getLuckturnConfig()
    if tx.userData.luckturnConfig then
        self.view_:updateUI(tx.userData.luckturnConfig, true)
    end

    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.getLuckturnConfigId_)
    self.getLuckturnConfigId_ = sa.HttpService.POST({
        mod = "BigWheel",
        act = "intitBigWheel"
    },
    function(data)
        local retData = json.decode(data)
        if retData.code == 1 then
			if retData and tonumber(retData.nextseconds) then --新版本
				retData.countdown = sa.getTime() + tonumber(retData.nextseconds)
			end
            tx.userData.luckturnConfig = retData
            if self.view_ then
                self.view_:setLoading(false)
                self.view_:updateUI(retData)
                self.freeTimes_ = retData.freetimes
            end
        end
    end,
    function()
    end)
end

--大转盘抽奖
function LuckturnController:playLuckturn()
    self.tempData_ = nil
    self.isPlayChange_ = false
    sa.HttpService.CANCEL(self.playLuckturnId_)
    self.playLuckturnId_ = sa.HttpService.POST(
        {
            mod = "BigWheel",
            act = "playLuckyWheel"
        },
        function(data)
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                self.tempData_ = retData
                self.freeTimes_ = self.freeTimes_ - 1
            	self:updateLuckturnStatus_(true, retData)
            else
                tx.TopTipManager:showToast(self.failedTips_)
            	self:updateLuckturnStatus_(false)
            end
        end,
        function()
        	self:updateLuckturnStatus_(false)
        end
    )
end

--钻石买免费次数
function LuckturnController:buyLuckturnTimes()
    sa.HttpService.CANCEL(self.buyLuckturnTimesId_)
    self.view_:setLoading(true)
    self.buyLuckturnTimesId_ = sa.HttpService.POST(
        {
            mod = "BigWheel",
            act = "buyTimes"
        },
        function(data)
            self.view_:setLoading(false)
            local retData = json.decode(data)
            if retData.code == 1 then
                local diamond = tonumber(retData.diamond) or 0
                tx.userData.diamonds = tx.userData.diamonds - diamond
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={diamonds=(-diamond)}})

                self.freeTimes_ = self.freeTimes_ + 1
                sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, freeTimes = self.freeTimes_})

                self.view_:startTurn()
            else
                tx.TopTipManager:showToast(self.failedTips_)
            end
        end,
        function()
            self.view_:setLoading(false)
            tx.TopTipManager:showToast(self.failedTips_)
        end
    )
end

function LuckturnController:setIsPlayChange(isPlayChange)
    self.isPlayChange_ = isPlayChange
end

function LuckturnController:updateCountdown(count)
    self.view_:updateCountdown(count)
end

function LuckturnController:updateLuckturnStatus_(isSuccess, data)
    if self.view_ then
        self.isSuccess_ = true
        self.view_:updateLuckturnStatus(isSuccess, data)
    else
        self:userPropertyChange_()
    end

    sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, freeTimes = self.freeTimes_})
end

function LuckturnController:userPropertyChange_()
    if self.tempData_ then
        local reward = self.tempData_.reward
        local evtData = {}
        if reward.money then
            evtData.money = reward.money
            tx.userData.money = tx.userData.money + tonumber(reward.money)
        elseif reward.props then
            evtData.props = reward.props
        end
        sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
    end
end

function LuckturnController:dispose()
    sa.HttpService.CANCEL(self.getLuckturnConfigId_)
    sa.HttpService.CANCEL(self.playLuckturnId_)
    sa.HttpService.CANCEL(self.buyLuckturnTimesId_)
    self.view_ = nil
    if self.tempData_ and (not self.isPlayChange_) then--断开连接的时候，还没播放过动画
        self:userPropertyChange_()
    end
end

return LuckturnController