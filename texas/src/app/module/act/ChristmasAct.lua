--摇一摇奖励弹窗
local ChristmasAct = class("ChristmasAct", tx.ui.RewardDialog)

local WIDTH, HEIGHT = 900, 575
local CENTER_X, CENTER_Y = WIDTH*0.5, HEIGHT*0.5

function ChristmasAct:ctor(chips, props, times, num, getNum, notStopNum)
	self:setNodeEventEnabled(true)

	self.this_ = self
   	self.chips_ = chips --获得筹码数量
   	self.props_ = props --获得道具数量
   	self.times_ = times --PHP验证
   	self.num_ = num --下落礼物总次数
   	if self.num_<1 then
   		self.num_ = 1
   	end
   	self.getNum_ = getNum --打败人数
   	self.notStopNum_ = notStopNum --最大连击数
   	self.code_ = "ErtLPB^P%u9X^iMM"

   	local scoreStr, rankingStr = self:getRewardTips_()

   	local feedData = clone(sa.LangUtil.getText("ACT", "CHRISTMAS_FEED"))
    feedData.name = sa.LangUtil.formatString(feedData.name, self.chips_, self.rateStr_ or "1%%")
   	local data = {
	 	rewardList = {
		 	{
	            rewardType = 1,
	            num = chips
	        },
	        {
	            rewardType = 2,
	            num = props
	        }
		},
		score = scoreStr,
		ranking = rankingStr,
		feedData = feedData,
   	}
   	ChristmasAct.super.ctor(self, data, true)

    self:getAward()
end

function ChristmasAct:addRewardInfo(data)
	ChristmasAct.super.addRewardInfo(self, data, 50)

	local node = self.rewardNode_
	local y = -200
	local label = ui.newTTFLabel({text = data.score, color = styles.FONT_COLOR.CHIP_TEXT, size = 30})
        :pos(0, y)
        :addTo(node)

    if data.ranking then
    	y = y + 20
    	label:setPositionY(y)

    	y = y - 50
    	ui.newTTFLabel({text = data.ranking, color = styles.FONT_COLOR.CHIP_TEXT, size = 30})
	        :pos(0, y)
	        :addTo(node)
    end
end

function ChristmasAct:getAward()
	local key = crypto.md5(""..tx.userData.uid..self.chips_..self.props_..self.code_)
	sa.HttpService.CANCEL(self.getAwardReqId_)
	self.getAwardReqId_ = sa.HttpService.POST({
            mod = "Activity",
            act = "updateLuckyDraw",
            chips = self.chips_,
            props = self.props_,
            times = self.times_,
            getNum = self.getNum_,
            totalNum = self.num_,
            key = key
        },
        function(data)
			-- -1 	参数错误
			-- -2 	参数校验不通过
			-- -3 	不在活动期间
			-- -4 	抽奖次数已用完
			-- -5 	领取的筹码超过可领取数
			-- -6 	领取的道具超过可领取数
			if self.this_ then
				self:updateUserData_()
			end
        end,
        function()
        	if self.this_ then
				self:getAward()
			end
            
        end)
end

function ChristmasAct:updateUserData_()
	local evtData = {}  -- 派发数据
    if self.chips_ and self.chips_ > 0 then
        evtData.money = self.chips_
        tx.userData.money = tx.userData.money + self.chips_
    end

    if self.props_ and self.props_>0 then
        evtData.props = self.props_
    end
    
    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
end

function ChristmasAct:getRewardTips_()
	-- 成功率30%-34%，击败了50%+随机数字的人。
	-- 成功率35%-39%，击败了60%+随机数字的人。
	-- 成功率 40%-44%，击败了80%的人
	-- 成功率45%-49%，击败了85%的人
	-- 成功率50%-59%，击败了89%的人
	-- 成功率60%-69%，击败了91%的人
	-- 成功率70%-79%，击败了94%的人
	-- 成功率80%-89%，击败了97%的人
	-- 成功率90%-99%，击败了99%的人
	-- 成功率100%，击败了100%的人

	local rate = self.getNum_ / self.num_
    local rateStr = "0%%"

    if rate==0 then
    	rateStr = ""
    elseif rate<0.2 then
    	rateStr = (10+math.floor(math.random()*10)).."%%"
    elseif rate<0.3 then
		rateStr = (30+math.floor(math.random()*10)).."%%"
    elseif rate<0.35 then
    	rateStr = (40+math.floor(math.random()*10)).."%%"
    elseif rate<0.4 then
    	rateStr = (50+math.floor(math.random()*10)).."%%"
	elseif rate<0.45 then
		rateStr = (60+math.floor(math.random()*15)).."%%"
	elseif rate<0.5 then
		rateStr = (75+math.floor(math.random()*10)).."%%"
	elseif rate<0.6 then
		rateStr = (85+math.floor(math.random()*5)).."%%"
	elseif rate<0.7 then
		rateStr = (90+math.floor(math.random()*4)).."%%"
	elseif rate<0.8 then
		rateStr = (94+math.floor(math.random()*3)).."%%"
	elseif rate<0.9 then
		rateStr = (97+math.floor(math.random()*2)).."%%"
	elseif rate<1 then
		rateStr = "99%%"
	elseif rate==1 then
		rateStr = "100%%"
	end
	rate = math.floor(rate*100).."%%"
	self.rateStr_ = rateStr

	local scoreStr = sa.LangUtil.getText("ACT", "CHRISTMAS_HITRATE", rate, self.notStopNum_)
	local rankingStr = nil
	if rateStr ~= "" then
		rankingStr = sa.LangUtil.getText("ACT", "CHRISTMAS_HITWIN", rateStr)
	end

	return scoreStr, rankingStr
end

function ChristmasAct:onCleanup()
	sa.HttpService.CANCEL(self.getAwardReqId_)
end

return ChristmasAct