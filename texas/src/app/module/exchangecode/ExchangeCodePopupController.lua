local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ExchangeCodePopupController = class("ExchangeCodePopupController")

function ExchangeCodePopupController:ctor(view)
    self.view_ = view
end

function ExchangeCodePopupController:getExchangeReward(code, len)
    if len == 6 then
        self:getExchangeCodeReward_(code)
    elseif len == 8 then
        self:getInviteCodeReward_(code)
    end
end

--兑换码奖励
function ExchangeCodePopupController:getExchangeCodeReward_(exchangeCode)
    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.getExchangeCodeRewardId_)
    self.getExchangeCodeRewardId_ = sa.HttpService.POST(
    {
        mod = "ExchangeCode", 
        act = "exchange",
        code = exchangeCode
    },
    function (data)
        local callData = json.decode(data)
        self.view_:setLoading(false)
        if callData.code == 1 then
            local reward = json.decode(callData.msg)
            self.view_:showRewardDialog(reward)
            tx.userData.money = tx.userData.money + tonumber(reward.money)
        else
            if callData.code == -6 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "ERROR_USED"))
            elseif callData.code == -4 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "ERROR_INVALID"))
            elseif callData.code == -5 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "ERROR_END"))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "ERROR_FAILED"))
            end
        end
    end,
    function (data)
        self.view_:setLoading(false)
    end)
end

--邀请码奖励
function ExchangeCodePopupController:getInviteCodeReward_(code)
    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.getInviteCodeRewardId_)
    self.getInviteCodeRewardId_ = sa.HttpService.POST(
    {
        mod = "InviteCode", 
        act = "exchange",
        icode = code
    },
    function (data)
        local callData = json.decode(data)
        self.view_:setLoading(false)
        if callData.ret == 1 then
            self.view_:showInviteCodeReward(callData.name, callData.money)
            tx.userData.money = tx.userData.money + tonumber(callData.money)
        elseif callData.ret == -8 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "ERROR_USED"))
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "FAILED_TIPS"))
        end
    end,
    function (data)
        self.view_:setLoading(false)
        tx.TopTipManager:showToast(sa.LangUtil.getText("ECODE", "FAILED_TIPS"))
    end)
end

function ExchangeCodePopupController:getInviteCode()
    if tx.userData.inviteCodeConfig then
        self.view_:updateInviteView(tx.userData.inviteCodeConfig)
    else
        local request
        local retry = 3
        
        request = function()
            self.getInviteCodeId_ = sa.HttpService.POST(
            {
                mod = "InviteCode", 
                act = "getInviteCode",
            },
            function(data)
                local callData = json.decode(data)
                if callData.ret == 1 then
                    tx.userData.inviteCodeConfig = callData
                    if self.view_ then
                        self.view_:updateInviteView(callData)
                    end
                else
                    retry = retry - 1
                    if retry > 0 then
                        request()
                    end
                end
            end,
            function()
                retry = retry - 1
                if retry > 0 then
                    request()
                end
            end)
        end

        request()
    end
end

--邀请好友奖励配置
function ExchangeCodePopupController:getInviteRewardConfig(callback)
    if not self.inviteRewardConfig_ then
        if self.getInviteRewardConfigScheduleHandle_ then
            scheduler.unscheduleGlobal(self.getInviteRewardConfigScheduleHandle_)
        end
        sa.HttpService.CANCEL(self.inviteRewardConfigRequestId_)
        self.inviteRewardConfigRequestId_ = sa.HttpService.POST({
            mod = "Invite",
            act = "initMyGiftBag",
        },
        function(data)
            local retData = json.decode(data)
            if retData.code == 1 then
                self.inviteRewardConfig_ = retData
                callback(retData)
            else
                self.getInviteRewardConfigScheduleHandle_ = scheduler.performWithDelayGlobal(function()
                    self:getInviteRewardConfig(callback)
                end, 2)
            end
        end,
        function ()
            self.getInviteRewardConfigScheduleHandle_ = scheduler.performWithDelayGlobal(function()
                self:getInviteRewardConfig(callback)
            end, 2)
        end
        )
    else
        callback(self.inviteRewardConfig_)
    end
end

--获取邀请好友奖励
function ExchangeCodePopupController:getInviteReward(rewardType)
    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.inviteRewardRequestId_)
    self.inviteRewardRequestId_ = sa.HttpService.POST({
        mod = "Invite",
        act = "rewardGiftBag",
        type = rewardType
    },
    function(data)
        local retData = json.decode(data)
        if retData.code == 1 then
            local evtData = {} -- 动画
            local reward = retData.reward
            if reward.money then
                tx.userData.money = tx.userData.money + tonumber(reward.money)
                evtData.money = reward.money
            end

            if reward.diamond then
                tx.userData.diamonds = tx.userData.diamonds + tonumber(reward.diamond)
                evtData.diamonds = reward.diamond
            end
            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
            self.view_:setLoading(false)
        end
    end,
    function ()
    end
    )
end

--分享邀请码以后，获取奖励
function ExchangeCodePopupController:getShareInviteCodeMoney()
    tx.schedulerPool:delayCall(function ()
        sa.HttpService.POST(
        {
            mod = "InviteCode", 
            act = "shareGetMoney",
        },
        function(data)
            local callData = json.decode(data)
            if callData and callData.code == 1 then
                tx.userData.money = tx.userData.money + callData.money
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=callData.money}})
            end
        end,
        function()
        end)
    end, 5)
end

function ExchangeCodePopupController:dispose()
    sa.HttpService.CANCEL(self.getExchangeCodeRewardId_)
    sa.HttpService.CANCEL(self.getInviteCodeRewardId_)
    sa.HttpService.CANCEL(self.getInviteCodeId_)
    sa.HttpService.CANCEL(self.inviteRewardConfigRequestId_)
    sa.HttpService.CANCEL(self.inviteRewardRequestId_)
    if self.getInviteRewardConfigScheduleHandle_ then
        scheduler.unscheduleGlobal(self.getInviteRewardConfigScheduleHandle_)
    end
end

return ExchangeCodePopupController
