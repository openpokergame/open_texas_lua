local P = import(".PROTOCOL")
local RedBlackGameSocket = class("RedBlackGameSocket")

function RedBlackGameSocket:ctor(proxySocket)
	self.ps_ = proxySocket
end

function RedBlackGameSocket:getProtocol()
	return P
end

function RedBlackGameSocket:getSuccessCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_SUCCESS
end

function RedBlackGameSocket:getFailCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_FAIL
end

function RedBlackGameSocket:startLoginRoom(data) -- 开始发送登录
	-- 过滤组装 data
	self:sendLogin(data)
end

function RedBlackGameSocket:onProcessPacket(pack)
	local cmd = pack.cmd
	local PROTOCOL = self.ps_.PROTOCOL
	if cmd == P.SVR_LOGIN_SUCCESS then
		if pack.allBetList then
			for _, v in ipairs(pack.allBetList) do
				v.betType = self:transformServerBetType_(v.betType)
			end
		end

		if pack.selfBetList then
			for _, v in ipairs(pack.selfBetList) do
				v.betType = self:transformServerBetType_(v.betType)
			end
		end

		local betOddsList = pack.betOddsList
		if betOddsList then
			local list = {}
			for k,v in pairs(betOddsList) do
				local betType = self:transformServerBetType_(v.betType)
				list[betType] = v.odds / 100
			end
			pack.betOddsList = list
		end
	elseif cmd == P.SVR_STAND_UP then -- 同步玩家金币
		if tx.userData and tx.userData.uid==pack.uid then
			tx.userData.money = pack.chips
		end
	elseif cmd == P.SVR_BET_SUCCESS then--下注成功
		for _, v in ipairs(pack.playerList) do
			for _, vv in ipairs(v.betList) do
				vv.betType = self:transformServerBetType_(vv.betType)
			end
		end
	elseif cmd == P.SVR_SELF_BET_FAIL then
		pack.betType = self:transformServerBetType_(pack.betType)
	elseif cmd == P.SVR_GAME_OVER then  -- 同步玩家金币
		for _, v in ipairs(pack.winResult) do
			v.winType = self:transformServerBetType_(v.winType)
		end

		for _,v in ipairs(pack.betResult) do
			v.betType = self:transformServerBetType_(v.betType)
		end

		for _, v in ipairs(pack.playerList) do
			for _, vv in ipairs(v.betResult) do
				vv.betType = self:transformServerBetType_(vv.betType)
			end
		end

		pack.playerChipsList = pack.playerChipsList or {}
		if tx.userData then
			tx.userData.lastGameOverMoney = pack.userChips -- 有时候不同步金币
		end
	elseif cmd == P.SVR_GAME_START then
		local selfInShowSeat = false
		for k,v in pairs(pack.playerList) do
			if v.uid==tx.userData.uid then
				tx.userData.money = v.seatChips
				selfInShowSeat = true
				break
			end
		end
		if not selfInShowSeat and tx.userData.lastGameOverMoney then
			tx.userData.money = tx.userData.lastGameOverMoney
		end
		tx.userData.lastGameOverMoney = nil
	elseif cmd == P.SVR_LOGOUT_SUCCESS then
		tx.userData.money = pack.chips
		tx.userData.lastGameOverMoney = nil
	end 
end

function RedBlackGameSocket:sendLogin(params)
	local pack = self.ps_:createPacketBuilder(P.CLI_LOGIN)
		:setParameter("gameId", params.gameId)
		:setParameter("gameLevel", params.gameLevel)
        :setParameter("tid", params.tid)
        :setParameter("uid", params.uid)
        :setParameter("info", params.info)
        :setParameter("mtkey", params.mtkey)
        :setParameter("pwd", params.pwd)
        :build()
    self.ps_:send(pack)
end

function RedBlackGameSocket:sendSitDown(seatId, buyIn, auto, type)
    local pack = self.ps_:createPacketBuilder(P.CLI_SIT_DOWN)
        :setParameter("seatId", seatId)
        :setParameter("buyIn", buyIn)
        :setParameter("auto", auto or 0)
        :setParameter("type", type or 0)  -- 0 不够时买入， 不够最小买入时买入
        :build()
    self.ps_:send(pack)
end

function RedBlackGameSocket:sendLogout()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_LOGOUT):build())
end

function RedBlackGameSocket:sendStandUp()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_STAND_UP):build())
end

function RedBlackGameSocket:sendBet(betType, betChips)
	--兼容服务器数据
	if betType == 10 then
		betType = 11
	elseif betType == 11 then
		betType = 12
	elseif betType == 12 then
		betType = 15
	elseif betType == 13 then
		betType = 16
	end

    local pack = self.ps_:createPacketBuilder(P.CLI_BET)
        :setParameter("betType", betType)
        :setParameter("betChips", betChips)
        :build()
    self.ps_:send(pack)
end

function RedBlackGameSocket:sendAllUserInfo()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_GET_ALL_USERINFO):build())
end

--转换服务器下注类型
function RedBlackGameSocket:transformServerBetType_(betType)
	if betType >= 9 and betType <= 10 then
		betType = 9
	elseif betType == 11 then
		betType = 10
	elseif betType >= 12 and betType <= 14 then
		betType = 11
	elseif betType == 15 then
		betType = 12
	elseif betType >= 16 and betType <= 18 then
		betType = 13
	end

	return betType
end

return RedBlackGameSocket