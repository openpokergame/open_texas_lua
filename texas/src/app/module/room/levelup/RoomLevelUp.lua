local RoomLevelUpUI = class("RoomLevelUpUI", function() return display.newNode() end)

local checkLevelHaveAward__ = function(level)
    local haveAward,awardInfo = tx.Level:checkLevelAward(level)
    if haveAward and awardInfo then
        local retData = {
            desc = awardInfo,
            curRewardLevel = level,
        }
        RoomLevelUpUI.new(retData):showPanel()
    end
end

RoomLevelUpUI.ELEMENTS = {
    "bg",
    "labelTitle",
    "labelLevel",
    "labelAward",
    "btnShare.label",
    "btnClose",
}

function RoomLevelUpUI:ctor(data)
	self.retData_ = data
	self:setNodeEventEnabled(true)
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_room_upgrade.csb")
    local size = self.bg:getContentSize()
    self.width_,self.height_ = size.width,size.height
    self.labelTitle:setString(sa.LangUtil.getText("COMMON","CONGRATULATIONS"))
    -- self.btnShare.label:setString(sa.LangUtil.getText("COMMON", "SHARE"))
    self.btnShare.label:setString(sa.LangUtil.getText("COMMON", "GET"))
    sa.fitSprteWidth(self.btnShare.label, 156)
   	self.labelAward:setString(data.desc)
   	self.labelLevel:setString(sa.LangUtil.getText("COMMON","LEVEL")..data.curRewardLevel)
    ImgButton(self.btnClose,"#common/btn_close.png","#common/btn_close_down.png")
    	:onButtonClicked(buttontHandler(self, function(obj)
    		self:hidePanel()
    	end))
    ImgButton(self.btnShare,"#common/btn_small_green.png","#common/btn_small_green_down.png")
        :onButtonClicked(buttontHandler(self, function(obj)
            if self.isRequesting_ then return; end
            self.isRequesting_ = true
            self:setLoading(true)
            local requestLevelAwardFun
            local maxretry = 3
            requestLevelAwardFun = function()
                sa.HttpService.CANCEL(self.rewardHttpId_)
                self.rewardHttpId_ = sa.HttpService.POST({
                        mod = "Level",
                        act = "levelUpReward",
                        level = self.retData_.curRewardLevel,
                    }, 
                    function (data)
                        local retData = json.decode(data)
                        if retData.code == 1 then
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
                            tx.TopTipManager:showGoldTips(self.retData_.desc)
                            self.nextRewardLevel__ = tonumber(retData.nextRewardLevel)
                            self:hidePanel()
                        else
                            self.nextRewardLevel__ = nil
                        end
                    end, 
                    function ()
                        self.nextRewardLevel__ = nil
                        maxretry = maxretry - 1
                        if maxretry > 0 then
                            requestLevelAwardFun()
                        end
                    end
                )
            end
            requestLevelAwardFun()
            -- self:hidePanel()
            -- local feedData = clone(sa.LangUtil.getText("FEED", "UPGRADE_REWARD"))
            -- feedData.name = sa.LangUtil.formatString(feedData.name, data.curRewardLevel, data.desc)
            -- feedData.picture = sa.LangUtil.formatString(feedData.picture, data.curRewardLevel)
            -- feedData.link = sa.LangUtil.formatString(feedData.link, data.curRewardLevel)
            -- tx.ShareSDK:shareFeed(feedData, function(success, result)
                
            -- end)
        end))
end

function RoomLevelUpUI:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0,0)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function RoomLevelUpUI:showPanel()
    tx.PopupManager:addPopup(self, false, false, true, false)
end

function RoomLevelUpUI:hidePanel()
    tx.PopupManager:removePopup(self)
end

function RoomLevelUpUI:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=(-self.width_ * 0.5), easing="OUT", onComplete=function()
        -- 下一等级的奖励哦
        if self.nextRewardLevel__ and self.nextRewardLevel__>0 then
            checkLevelHaveAward__(self.nextRewardLevel__)
        end
        removeFunc()
    end})
end

function RoomLevelUpUI:onShowPopup()
    self:stopAllActions()
    self:setPositionY(display.cy)
    transition.moveTo(self, {time=0.2, x=(self.width_ * 0.5 - 28), easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
        self:stopAllActions()
        -- self:performWithDelay(function()
        -- 	self:hidePanel()
        -- end,3)
    end})
end

function RoomLevelUpUI:onCleanup()
    sa.HttpService.CANCEL(self.rewardHttpId_)
end

---------------------------------------------------------------------------------------------------
local RoomLevelUp = class("RoomLevelUp")
function RoomLevelUp:ctor()--level,awardInfo)
    sa.HttpService.POST(
        {
            mod = "User",
            act = "checkPlayer",
            cuid = tx.userData.uid,
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 and retData.info and retData.info.nextRewardLevel and retData.info.level then
                local level = tonumber(retData.info.level)
                local nextRewardLevel = tonumber(retData.info.nextRewardLevel)
                if level>=nextRewardLevel and nextRewardLevel>0 then  --当前已经到达领奖要求
                    checkLevelHaveAward__(nextRewardLevel)
                else

                end
            end
        end,
        function()

        end
    )
end

return RoomLevelUp