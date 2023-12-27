--[[
	local VARIETY_DIAMOND = 0 -- 梅花
	local VARIETY_CLUB    = 1 -- 方块
	local VARIETY_HEART   = 2 -- 红桃
	local VARIETY_SPADE   = 3 -- 黑桃
	0x01  0x02  0x03  0x04  0x05  0x06  0x07  0x08  0x09  0x0A    0x0B  0x0C  0x0D
	方块A 方块2 方块3 方块4 方块5 方块6 方块7 方块8 方块9 方块10  方块J 方块Q 方块K
	0x11  0x12  0x13  0x14  0x15  0x16  0x17  0x18  0x19  0x1A    0x1B  0x1C  0x1D
	梅花A 梅花2 梅花3 梅花4 梅花5 梅花6 梅花7 梅花8 梅花9 梅花10  梅花J 梅花Q 梅花K
	0x21  0x22  0x23  0x24  0x25  0x26  0x27  0x28  0x29  0x2A    0x2B  0x2C  0x2D
	红桃A 红桃2 红桃3 红桃4 红桃5 红桃6 红桃7 红桃8 红桃9 红桃10  红桃J 红桃Q 红桃K
	0x31  0x32  0x33  0x34  0x35  0x36  0x37  0x38  0x39  0x3A    0x3B  0x3C  0x3D
	黑桃A 黑桃2 黑桃3 黑桃4 黑桃5 黑桃6 黑桃7 黑桃8 黑桃9 黑桃10  黑桃J 黑桃Q 黑桃K
--]]
require("framework.cc.utils.bit")
local PropHandPoker = import(".model.PropHandPoker")
local PropPairKind = import(".model.PropPairKind")
local PropStraightPot = import(".model.PropStraightPot")
local CARD_TYPE = consts.CARD_TYPE

--从大到小排序
local sortByBigValue = function(pk1,pk2)
	return pk1.p_value>pk2.p_value
end

--从小到大排序
local sortBySmallValue = function(pk1,pk2)
	if pk1.p_value<pk2.p_value then
		return true
	elseif pk1.p_value>pk2.p_value then
		return false
	else
		if pk1.p_color>pk2.p_color then
			return true
		else
			return false
		end
	end
end

--花色优先排序
local sortByColorThenValue = function(pk1,pk2)
	if pk1.p_color>pk2.p_color then
		return true
	elseif pk1.p_color<pk2.p_color then
		return false
	else
		if pk1.p_value<pk2.p_value then
			return true
		else
			return false
		end
	end
end

--花色是否一样
local __isSameColor = function(cardList)
	local curColor = cardList[1].p_color
	for i=2,#cardList,1 do
		if curColor~=cardList[i].p_color then
			return false
		end
	end
	return true
end

--是否有顺子
local __haveShunZi = function(cardList,target)
	local valueList = {}  -- key列表
	local sigleList = {}  -- 单牌列表
	for k,v in pairs(cardList) do
		if not valueList[v.p_value] then
			valueList[v.p_value] = true
			table.insert(sigleList,v)
		end
	end
	valueList = nil
	if #sigleList<5 then
		return false
	end
	table.sort(sigleList,sortBySmallValue)

	local num = 1
	local index = 1
	local value = sigleList[1].p_value
	local curCard = nil
	for i=2,#sigleList,1 do
		curCard = sigleList[i]
		if (value+1)==curCard.p_value then
			num = num + 1
			if i==#sigleList then
				if num>=5 then
					if target then
						target.bestCards = {
							sigleList[i-4],
							sigleList[i-3],
							sigleList[i-2],
							sigleList[i-1],
							sigleList[i],
						}
					end
					return true
				end
			end
		else
			if num>=5 then
				if target then
					target.bestCards = {
						sigleList[i-5],
						sigleList[i-4],
						sigleList[i-3],
						sigleList[i-2],
						sigleList[i-1],
					}
				end
				return true
			end
			num = 1
			index = i
		end
		value = curCard.p_value
	end
	if sigleList[1].p_value == 0x02 and sigleList[2].p_value == 0x03 and sigleList[3].p_value == 0x04 and sigleList[4].p_value == 0x05 and sigleList[#sigleList].p_value == 0x0e then
		if target then
			target.bestCards = {
				sigleList[#sigleList],
				sigleList[1],
				sigleList[2],
				sigleList[3],
				sigleList[4],
			}
		end
		return true
	end
	return false
end

--获取最多同一花色数
local getMaxFlushNum = function(cardList)
	local flushbox={0,0,0,0}
	for k,v in pairs(cardList) do
		flushbox[v.p_color] = flushbox[v.p_color] + 1
	end
	table.sort(flushbox)  --从小到大排序
	return flushbox[4]    --取最大值
end

local CardAnalysisManager = class("CardAnalysisManager")

function CardAnalysisManager:ctor()
	-- 测试
	-- self:getProbValue()
end

-- 统计对子(一对两对),三条,四条牌型
function CardAnalysisManager:__statisticsCard__(cardList)
	self.fourPokers_ = {}
	self.threePokers_ = {}
	self.twoPokers_ = {}
	self.onePokers_ = {}
	table.sort(cardList,sortByBigValue)
	local len = #cardList
	local num = 1
	local index = 1
	local value = cardList[1].p_value
	local curCard = nil
	for i=2,len,1 do
		curCard = cardList[i]
		if value~=curCard.p_value then
			if num==4 then
				table.insert(self.fourPokers_,cardList[i-4])
				table.insert(self.fourPokers_,cardList[i-3])
				table.insert(self.fourPokers_,cardList[i-2])
				table.insert(self.fourPokers_,cardList[i-1])
			elseif num==3 then
				table.insert(self.threePokers_,cardList[i-3])
				table.insert(self.threePokers_,cardList[i-2])
				table.insert(self.threePokers_,cardList[i-1])
			elseif num==2 then
				table.insert(self.twoPokers_,cardList[i-2])
				table.insert(self.twoPokers_,cardList[i-1])
			elseif num==1 then
				table.insert(self.onePokers_,cardList[i-1])
			end
			num = 1
			index = i
			value = curCard.p_value
		else
			num = num+1
		end
	end
	if num==4 then
		table.insert(self.fourPokers_,cardList[len-3])
		table.insert(self.fourPokers_,cardList[len-2])
		table.insert(self.fourPokers_,cardList[len-1])
		table.insert(self.fourPokers_,cardList[len])
	elseif num==3 then
		table.insert(self.threePokers_,cardList[len-2])
		table.insert(self.threePokers_,cardList[len-1])
		table.insert(self.threePokers_,cardList[len])
	elseif num==2 then
		table.insert(self.twoPokers_,cardList[len-1])
		table.insert(self.twoPokers_,cardList[len])
	elseif num==1 then
		table.insert(self.onePokers_,cardList[len])
	end
end

-- 是否为皇家同花顺
function CardAnalysisManager:isHuangJia_(cardList)
	if #cardList<5 then return false end
	table.sort(cardList,sortByColorThenValue)
	for i=(#cardList-5+1),1,-1 do
		local tempList = table.slice(cardList,i,i+4)
		if __isSameColor(tempList) then
			if tempList[1].p_value==0x0a and tempList[2].p_value==0x0b and tempList[3].p_value==0x0c and tempList[4].p_value==0x0d and tempList[5].p_value==0x0e then
				self.bestCards = tempList
				return true
			end	
		end
	end
	return false
end

--是否为同花顺
function CardAnalysisManager:isTongHuaShun_(cardList)
	if #cardList<5 then return false end
	table.sort(cardList,sortByColorThenValue)
	local num = 1
	local index = 1
	local color = cardList[1].p_color
	local curCard = nil
	for i=2,#cardList,1 do
		curCard = cardList[i]
		if color~=curCard.p_color then
			if num>=5 then
				break
			end
			num = 1
			index = i
			color = curCard.p_color
		else
			num = num+1
		end
	end
	if num >= 5 then
		local tempList = table.slice(cardList,index,index+num-1)
		if __isSameColor(tempList) and __haveShunZi(tempList,self) then
			return true
		end
	end
	return false
end

--是否为四条
function CardAnalysisManager:isFourTiao_(cardList)
	if #cardList<4 then return false end
	if self.fourPokers_ and #self.fourPokers_>=4 then
		self.bestCards = self.fourPokers_
		return true
	end
	return false
end

--是否为葫芦
function CardAnalysisManager:isHulu_(cardList)
	if #cardList<5 then return false end
	if self.threePokers_ and #self.threePokers_>=3 then
		if not self.twoPokers_ then self.twoPokers_={} end
		if (#self.threePokers_+#self.twoPokers_)>=5 then
			self.bestCards = {}
			self.bestCards[1] = self.threePokers_[1]
			self.bestCards[2] = self.threePokers_[2]
			self.bestCards[3] = self.threePokers_[3]
			if #self.threePokers_>3 then
				if #self.twoPokers_==0 then
					self.bestCards[4] = self.threePokers_[4]
					self.bestCards[5] = self.threePokers_[5]
				else
					if self.twoPokers_[1].p_value>self.threePokers_[4].p_value then
						self.bestCards[4] = self.twoPokers_[1]
						self.bestCards[5] = self.twoPokers_[2]
					else
						self.bestCards[4] = self.threePokers_[4]
						self.bestCards[5] = self.threePokers_[5]
					end
				end
			else
				self.bestCards[4] = self.twoPokers_[1]
				self.bestCards[5] = self.twoPokers_[2]
			end
			return true
		end
	end
	return false
end

--是否为同花
function CardAnalysisManager:isTongHua_(cardList)
	if #cardList<5 then return false end
	table.sort(cardList,sortByColorThenValue)
	for i=(#cardList-5+1),1,-1 do
		local tempList = table.slice(cardList,i,i+4)
		if __isSameColor(tempList) then
			self.bestCards = tempList
			return true
		end
	end
	return false
end

--是否为顺子
function CardAnalysisManager:isShunZi_(cardList)
	if #cardList<5 then return false end
	if __haveShunZi(cardList,self) then
		return true
	end
	return false
end

--是否为三条
function CardAnalysisManager:isThreeTiao_(cardList)
	if #cardList<3 then return false end
	if self.threePokers_ and #self.threePokers_>=3 then
		self.bestCards = self.threePokers_
		return true
	end
	return false
end

--是否为两对
function CardAnalysisManager:isTwoTiao_(cardList)
	if #cardList<4 then return false end
	if self.twoPokers_ and #self.twoPokers_>=4 then
		self.bestCards = table.slice(self.twoPokers_,1,4)
		return true
	end
	return false
end

--是否为一对
function CardAnalysisManager:isOneTiao_(cardList)
	if #cardList<2 then return false end
	if self.twoPokers_ and #self.twoPokers_>=2 then
		self.bestCards = self.twoPokers_
		return true
	end
	return false
end

-- 获取牌的类型
function CardAnalysisManager:__getPokersType__(cardList)
	self.bestCards = {}
	self:__statisticsCard__(cardList)
	local pokerType = CARD_TYPE.HIGH_CARD
	if self:isHuangJia_(cardList) then --皇家同花顺
		pokerType = CARD_TYPE.ROYAL_FLUSH
	elseif self:isTongHuaShun_(cardList) then --同花顺
		pokerType = CARD_TYPE.STRAIGHT_FLUSH
	elseif self:isFourTiao_(cardList) then --四条
		pokerType = CARD_TYPE.FOUR_KIND
	elseif self:isHulu_(cardList) then --葫芦
		pokerType = CARD_TYPE.FULL_HOUSE
	elseif self:isTongHua_(cardList) then --同花
		pokerType = CARD_TYPE.FLUSH
	elseif self:isShunZi_(cardList) then --顺子
		pokerType = CARD_TYPE.STRAIGHT
	elseif self:isThreeTiao_(cardList) then --三条
		pokerType = CARD_TYPE.THREE_KIND
	elseif self:isTwoTiao_(cardList) then --两对
		pokerType = CARD_TYPE.TWO_PAIRS
	elseif self:isOneTiao_(cardList) then --一对
		pokerType = CARD_TYPE.PAIR
	end

	self.bestCards.cardType = pokerType

	if #cardList==7 then --高牌
		self:setProbValue(pokerType)
	end

	-- 外部不关注
	if self.bestCards and #self.bestCards>0 and type(self.bestCards[1])=="table" then
		for k,v in ipairs(self.bestCards) do
			self.bestCards[k] = v.p_card
		end
	end
	return pokerType
end

function CardAnalysisManager:clearCurProp__()
	self.probValue.Win = 0
	self.probValue.High = 0
	self.probValue.OnePairs = 0
	self.probValue.TwoPairs = 0
	self.probValue.Threekind = 0
	self.probValue.Straight = 0
	self.probValue.Flush = 0
	self.probValue.FullHouse = 0
	self.probValue.FourKind = 0
	self.probValue.StraightFlush = 0
	self.probValue.RoyalFlush = 0
	self.bestCards = nil
end

--获取概率值
function CardAnalysisManager:getProbValue(cardList, noEvent)
	local probValue = self.probValue or {}
	self.probValue = probValue
	if not cardList or #cardList<2 then
		self:clearCurProp__()
		if not noEvent then
			sa.EventCenter:dispatchEvent({name="CHANGECARDPROB", data=probValue})
		end
		return probValue
	end

	-- 转义解析
	local trasCardList = {}
	local card = nil
	for k,v in pairs(cardList) do
		card = {}
		card.p_card = v
		card.p_color = math.floor(v / 16)
		card.p_value = (v % 16)
		card.p_color = card.p_color + 1
		if card.p_color>4 then
			card.p_color = 4
		end
		if card.p_value==1 then
			card.p_value = 14
		end
		table.insert(trasCardList,card)
	end

	local flushnum = getMaxFlushNum(trasCardList)
	if #trasCardList==2 then
		--排序
		table.sort(trasCardList,sortByBigValue)
		self:getHandleValue_(trasCardList,flushnum,probValue)
		local cardType = self:__getPokersType__(trasCardList)
		if not noEvent then
			sa.EventCenter:dispatchEvent({name="CHANGECARDPROB", data=probValue})
		end
		return probValue
	end

	if #trasCardList==7 then
		self:clearCurProp__()
		local cardType = self:__getPokersType__(trasCardList)
		if not noEvent then
			sa.EventCenter:dispatchEvent({name="CHANGECARDPROB", data=probValue})
		end
		return probValue
	end

	local cardType = self:__getPokersType__(trasCardList)
	self:getKindValue_(cardType,#trasCardList,probValue)
	self:getFlushValue_(flushnum,#trasCardList,probValue)
	if cardType==CARD_TYPE.STRAIGHT then
		probValue.Straight = 1
	else
		table.sort(trasCardList,sortBySmallValue)
		local key = 0
		local curCard = nil
		for i=1, #trasCardList, 1 do
			curCard = trasCardList[i]
			if not curCard or curCard.p_value==0 then
				break
			end
			key = key + curCard.p_value * math.pow(2,8*(i-1))
		end
		local kindValue = PropStraightPot[key]
		if kindValue then
			probValue.Straight = kindValue[1]
		end
	end

	probValue.Straight = probValue.Straight or 0
	probValue.Flush = probValue.Flush or 0
	probValue.StraightFlush = probValue.Straight * probValue.Flush
	if probValue.StraightFlush>0 and probValue.StraightFlush<1 then
		probValue.StraightFlush = string.format("%.2f",probValue.StraightFlush)
	end

	if not noEvent then
		sa.EventCenter:dispatchEvent({name="CHANGECARDPROB", data=probValue})
	end
	return probValue
end

function CardAnalysisManager:setProbValue(pokerType)
	if pokerType == CARD_TYPE.ROYAL_FLUSH then --皇家同花顺
		self.probValue.RoyalFlush = 1
	elseif pokerType == CARD_TYPE.STRAIGHT_FLUSH then --同花顺
		self.probValue.StraightFlush = 1
	elseif pokerType == CARD_TYPE.FOUR_KIND then --四条
		self.probValue.FourKind = 1
	elseif pokerType == CARD_TYPE.FULL_HOUSE then --葫芦
		self.probValue.FullHouse = 1
	elseif pokerType == CARD_TYPE.FLUSH then --同花
		self.probValue.Flush = 1
	elseif pokerType == CARD_TYPE.STRAIGHT then --顺子
		self.probValue.Straight = 1
	elseif pokerType == CARD_TYPE.THREE_KIND then --三条
		self.probValue.Threekind = 1
	elseif pokerType == CARD_TYPE.TWO_PAIRS then --两对
		self.probValue.TwoPairs = 1
	elseif pokerType == CARD_TYPE.PAIR then --一对
		self.probValue.OnePairs = 1
	else
		self.probValue.High = 1
	end
end

--计算概率
function CardAnalysisManager:getHandleValue_(cardList,flushnum,probValue)
	-- 计算key
	local key = ""
	local buff = nil
	for k,v in pairs(cardList) do
		if v.p_value==10 then
			buff = "T"
		elseif v.p_value==11 then
			buff = "J"
		elseif v.p_value==12 then
			buff = "Q"
		elseif v.p_value==13 then
			buff = "K"
		elseif v.p_value==14 then
			buff = "A"
		else
			buff = ""..v.p_value
		end
		key = key..buff
	end
	if flushnum==2 then
		key = key.."s"
	else
		key = key.."n"
	end
	local kindValue = PropHandPoker[key]
	if kindValue then
		probValue.Win = kindValue[1]/100
		probValue.High = 1
		probValue.OnePairs = 0
		probValue.TwoPairs = kindValue[2]/100
		probValue.Threekind = kindValue[3]/100
		probValue.Straight = kindValue[4]/100
		probValue.Flush = kindValue[5]/100
		probValue.FullHouse = kindValue[6]/100
		probValue.FourKind = kindValue[7]/100
		probValue.StraightFlush = kindValue[8]/100
		probValue.RoyalFlush = 0
	else
		print("getHandleValue_ can not find the key =="..key)
	end
end

function CardAnalysisManager:getKindValue_(type,len,probValue)
	-- --算value	
	local key = (bit.blshift(type, 8))+len
	local kindValue = PropPairKind[""..key]
	if kindValue then
		probValue.TwoPairs = kindValue[1]
		probValue.Threekind = kindValue[2]
		probValue.FullHouse = kindValue[3]
		probValue.FourKind = kindValue[4]
	else
		probValue.TwoPairs = 0
		probValue.Threekind = 0
		probValue.FullHouse = 0
		probValue.FourKind = 0
	end
end

function CardAnalysisManager:getFlushValue_(num,len,probValue)
	probValue.Flush = 0
	if len == 5 then
		if num == 4 then
			probValue.Flush = 0.3497
		elseif num ==3 then
			probValue.Flush = 0.0416
		end
	elseif len == 6 then
		if num == 4 then
			probValue.Flush = 0.1957
		end
	end
end

function CardAnalysisManager:dispose()

end

return CardAnalysisManager