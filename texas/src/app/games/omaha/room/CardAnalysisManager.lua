--拆分手牌，进行牌型查找
local CardAnalysisManager = import("app.games.texas.room.CardAnalysisManager")

local OmahaCardAnalysisManager = class("OmahaCardAnalysisManager")

function OmahaCardAnalysisManager:ctor()
	self.aysManager_ = CardAnalysisManager.new()
end

function OmahaCardAnalysisManager:initCurProp_()
	self.curCardType_ = -1
	self.probValue = {}
	self.bestCards = nil
end

--获取概率值
function OmahaCardAnalysisManager:getProbValue(cardList)
	self:initCurProp_()
	self:sliceHandCards_(cardList)
end

--分割手牌，进行组合
function OmahaCardAnalysisManager:sliceHandCards_(cardList)
	local handCards = table.slice(cardList, 1, 4)
	local pubCards = table.slice(cardList, 5)
	local cardsArr = {}
	local pubCardsArr = {{}}
	for i = 1, 3 do
		local card1 = handCards[i]
		if not card1 then
			break
		end

		for j = i + 1, 4 do
			local card2 = handCards[j]
			table.insert(cardsArr, {card1, card2})
		end
	end

	for i = 1, 3 do
		local card1 = pubCards[i]
		local card2, card3
		if not card1 then
			break
		end

		for j = i + 1, 4 do
			card2 = pubCards[j]
			if not card2 then
				break
			end

			for k = j + 1, 5 do
				card3 = pubCards[k]
				if not card3 then
					break
				end
				
				table.insert(pubCardsArr, {card1, card2, card3})
			end
		end
	end

	if #cardsArr > 0 then
		for _, v in ipairs(cardsArr) do
			for _, vv in ipairs(pubCardsArr) do
				local selectCards = {}
				table.insertto(selectCards, v)
				table.insertto(selectCards, vv)

				self.aysManager_:getProbValue(selectCards)
				
				local cardType = self.aysManager_.bestCards.cardType
				if cardType > self.curCardType_ then
					self.curCardType_ = cardType
					self.probValue = self.aysManager_.probValue
					self.bestCards = self.aysManager_.bestCards
				end
			end
		end

		if #cardList == 9 then
			self.aysManager_:setProbValue(self.curCardType_)
			sa.EventCenter:dispatchEvent({name="CHANGECARDPROB", data=self.probValue})
		end
	end
end

function OmahaCardAnalysisManager:dispose()
end

return OmahaCardAnalysisManager