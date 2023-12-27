local P = import(".PROTOCOL")
local MatchGameSocket = class("MatchGameSocket")

function MatchGameSocket:ctor(proxySocket)
	self.ps_ = proxySocket
end

function MatchGameSocket:getProtocol()
	return P
end
function MatchGameSocket:getSuccessCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_SUCCESS
end
function MatchGameSocket:getFailCmd()  -- 登陆成功协议号   -- 超时处理
	return P.SVR_LOGIN_FAIL
end
function MatchGameSocket:startLoginRoom(data) -- 开始发送登录
	-- 过滤组装 data
	self:sendLogin(data)
end

function MatchGameSocket:onProcessPacket(pack)
	local cmd = pack.cmd
	if cmd==P.SVR_LOGOUT_SUCCESS then
		
	else

	end 
end

function MatchGameSocket:sendLogin(params)
	local pack = self.ps_:createPacketBuilder(P.CLI_LOGIN)
        :setParameter("tid", params.tid)
        :setParameter("uid", params.uid)
        :setParameter("info", params.info)
        :setParameter("mtkey", params.mtkey)
        :setParameter("matchid", params.matchid)
        :build()
    self.ps_:send(pack)
end
function MatchGameSocket:sendSitDown(seatId, buyIn, auto)
    local pack = self.ps_:createPacketBuilder(P.CLI_SIT_DOWN)
        :setParameter("seatId", seatId)
        :setParameter("buyIn", buyIn)
        :setParameter("auto", auto or 0)
        :build()
    self.ps_:send(pack)
end
function MatchGameSocket:sendLogout()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_LOGOUT):build())
end
function MatchGameSocket:sendStandUp()
    self.ps_:send(self.ps_:createPacketBuilder(P.CLI_STAND_UP):build())
end
function MatchGameSocket:sendBet(betType, betChips)
    local pack = self.ps_:createPacketBuilder(P.CLI_BET)
        :setParameter("betType", betType)
        :setParameter("betChips", betChips)
        :build()
    self.ps_:send(pack)
end
return MatchGameSocket