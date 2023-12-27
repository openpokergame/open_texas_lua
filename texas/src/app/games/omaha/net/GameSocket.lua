local P = import(".PROTOCOL")
local OmahaGameSocket = class("OmahaGameSocket")

function OmahaGameSocket:ctor(proxySocket)
	self.ps_ = proxySocket
end

function OmahaGameSocket:getProtocol()
	return P
end
function OmahaGameSocket:getSuccessCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_SUCCESS
end
function OmahaGameSocket:getFailCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_FAIL
end
function OmahaGameSocket:startLoginRoom(data) -- 开始发送登录
	-- 过滤组装 data
	self:sendLogin(data)
end

function OmahaGameSocket:onProcessPacket(pack)
	local cmd = pack.cmd
	if cmd==P.SVR_LOGIN_SUCCESS then
		self.loginPack_ = pack
	elseif cmd==P.SVR_STAND_UP then -- 同步玩家金币
		if tx.userData and tx.userData.uid==pack.uid then
			tx.userData.money = pack.chips
			if (tx.userData.money+tx.userData.safe_money)<appconfig.CRASHMONEY and self.loginPack_ then
				local curScene = display.getRunningScene()
			    if not curScene then
			        return
			    end
                local gameId = P.GAMEID
                local blind = self.loginPack_.blind
                curScene:onBrokeShow({gameId=gameId,blind=blind})
            end
		end
	elseif cmd==P.SVR_GAME_OVER then  -- 同步玩家金币
		local playerList = pack.playerList
		if playerList and tx.userData then
			for k,v in pairs(playerList) do
				if v.uid==tx.userData.uid then
					if v.totalWinChips then -- 同步个人金币
						tx.userData.money = v.totalWinChips
					end
					-- tx.userData.money = tx.userData.money + v.changeChips
					break
				end
			end
		end
	elseif cmd==P.SVR_LOGOUT_SUCCESS then
	end 
end

function OmahaGameSocket:sendLogin(params)
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
function OmahaGameSocket:sendSitDown(seatId, buyIn, auto, type)
    local pack = self.ps_:createPacketBuilder(P.CLI_SIT_DOWN)
        :setParameter("seatId", seatId)
        :setParameter("buyIn", buyIn)
        :setParameter("auto", auto or 0)
        :setParameter("type", type or 0)  -- 0 不够时买入， 不够最小买入时买入
        :build()
    self.ps_:send(pack)
end
function OmahaGameSocket:sendLogout()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_LOGOUT):build())
end
function OmahaGameSocket:sendStandUp()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_STAND_UP):build())
end
function OmahaGameSocket:sendBet(betType, betChips)
    local pack = self.ps_:createPacketBuilder(P.CLI_BET)
        :setParameter("betType", betType)
        :setParameter("betChips", betChips)
        :build()
    self.ps_:send(pack)
end
function OmahaGameSocket:addChips(chips)
    local pack = self.ps_:createPacketBuilder(P.CLI_ADD_CHIPS)
        :setParameter("chips", chips)
        :build()
    self.ps_:send(pack)
end
function OmahaGameSocket:setAutoBuy(auto, type)
	local pack = self.ps_:createPacketBuilder(P.CLI_ROOM_SET)
        :setParameter("auto", auto or 0)
        :setParameter("type", type or 0)  -- 0 不够时买入， 不够最小买入时买入
        :build()
    self.ps_:send(pack)
end

return OmahaGameSocket