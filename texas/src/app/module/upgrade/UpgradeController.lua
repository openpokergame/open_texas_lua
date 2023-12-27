local UpgradeController = class("UpgradeController")

function UpgradeController:ctor(view_)
    self.view_ = view_
    self.getLevelRewardRetryTimes_ = 3
end

-- 领奖
function UpgradeController:getReward()
    self.view_:setLoading(true)
    self.rewardHttpId = sa.HttpService.POST(
        {
            mod = "Level", 
            act = "levelUpReward",
            level = tx.userData.nextRewardLevel
        }, 
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                retData.curRewardLevel = tx.userData.nextRewardLevel
                tx.userData.nextRewardLevel = retData.nextRewardLevel
                -- 动画
                local evtData = {}
                if retData.money then
                    tx.userData.money = tx.userData.money + tonumber(retData.money)
                    evtData.money = retData.money
                end
                if retData.diamond then
                    tx.userData.diamonds = tx.userData.diamonds +tonumber(retData.diamond)
                    evtData.diamonds = retData.diamond
                end
                if retData.props then
                    evtData.props = retData.props
                end
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
                self.view_:setLoading(false)
                self.view_:addMainUI(retData)
            end
        end, 
        function ()
            if self.getLevelRewardRetryTimes_ > 0 then
                self:getReward()
                self.getLevelRewardRetryTimes_ = self.getLevelRewardRetryTimes_ - 1
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_LEVEL_UP_REWARD"))
                self.view_:setLoading(false)
            end
        end
    )
end

function UpgradeController:dispose()
    if self.rewardHttpId then
        sa.HttpService.CANCEL(self.rewardHttpId)
    end
end

return UpgradeController
