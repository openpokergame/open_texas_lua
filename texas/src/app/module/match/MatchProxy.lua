local logger = sa.Logger.new("MatchProxy")

local MatchProxy = {}

function MatchProxy.new()
	local instance = {}
	local datapool = {}

	local function getData(table, key)
		return MatchProxy[key] or datapool[key]
	end

	local function setData(table, key, value)
		datapool[key] = value
	end

	local function clearData(self)
		local newdatapool = {}
		for k, v in pairs(datapool) do
			if type(v) == "function" then
				newdatapool[k] = v
			end
		end 
		datapool = newdatapool
		return self
	end

	instance.clearData = clearData
	local mtable = {__index = getData, __newindex = setData}
	setmetatable(instance, mtable)
	instance:ctor()

	return instance
end

function MatchProxy:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	-- 事件监听 颁奖延后处理 在大厅scene中resume的
	self.eventProxy_ = cc.EventProxy.new(tx.socket.MatchSocket,nil)
		:addEventListener(tx.socket.MatchSocket.EVT_PACKET_RECEIVED, handler(self, self.onPacketReceived_))
	self:initData()
end

function MatchProxy:initData()
	self.joinTime_ = 0
	self.online = {}
	self.regList = {}
	self.cacheMatchStartPack = {}  -- 比赛开始的缓存包
	self.dealingMatchLevel_ = -1  -- 正在处理的比赛等级
	self.curMatchLevel_ = -1 --当前进入的比赛等级
end

function MatchProxy:getCurMatchLevel()
	return self.curMatchLevel_
end

function MatchProxy:onPacketReceived_(evt)
	self:processPacket_(evt.packet)
end

function MatchProxy:processPacket_(pack)
	local cmd = pack.cmd
	local P = tx.socket.MatchSocket.PROTOCOL
	if cmd==0x1007 then
		if self.dealingMatchLevel_ > 0 then
			self.curMatchLevel_ = self.dealingMatchLevel_
		end
		self.dealingMatchLevel_ = -1
	elseif cmd==P.SVR_LOGIN_OK then
		self:initData()
		if pack.tid>0 then
			self.dealingMatchLevel_ = pack.level
		end
		-- 获取所有场次
		local list = {11}		
		for k,v in ipairs(list) do
			tx.socket.MatchSocket:getStatus(v)
		end
	elseif cmd==P.SVR_GET_COUNT then

	elseif cmd==P.SVR_REGISTER_RET then --报名注册返回的结果
		if pack.ret==0 then
			self.regList[pack.level] = pack.matchid
			self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "REGISTER_SUCCESS", level = pack.level}}) -- 派发事件
			sa.EventCenter:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "REGISTER_SUCCESS"}})
		else
			local isMaintain = false
			if pack.ret==8 then
				tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "NOT_ENOUGH_MONEY"))
			elseif pack.ret==10 then	--10比赛正在维护
				tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "MAINTAIN"))
				isMaintain = true
			end
			self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "REGISTER_FAILED", level = pack.level}})
			sa.EventCenter:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "REGISTER_FAILED", level = pack.level, isMaintain = isMaintain}})
		end
	elseif cmd==P.SVR_CANCEL_REGISTER_RET then --取消报名注册返回的结果
		if pack.ret~=2 then
			if self.dealingMatchLevel_==pack.level then
				self.dealingMatchLevel_ = -1
			end
			self.regList[pack.level] = nil
			self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE"}) -- 派发事件
		end
	elseif cmd==P.SVR_JOIN_GAME then
		local curTime = os.time()
		if pack.joinTime>(curTime-pack.receiveTime) then
			if self.dealingMatchLevel_<=0 then
				self.dealingMatchLevel_ = pack.level
				sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_START_LOGIN, data=pack})
			else
				table.insert(self.cacheMatchStartPack,pack)
			end
		end
	elseif cmd==P.SVR_JOIN_GAME_SUCC then

	elseif cmd==P.SVR_MATCH_STATUS then --服务器通知比赛状态
		--	{ name = "level", type = T.UINT }, -- int(比赛等级)
		--	{ name = "matchid", type = T.STRING },  -- string(比赛ID，定人赛当已经报名、正在入场时为目标ID，定时赛当比赛中，为目标ID，其他为空)
		--	{ name = "status", type = T.INT },  -- int(比赛状态，-1--未报名，0--已经报名；1--正在入场；2--比赛中；3--比赛结束)
		if pack.status==-1 or pack.status==3 then
			self.regList[pack.level] = nil
		else
			self.regList[pack.level] = pack.matchid
		end
		self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE"})
		if self.dealingMatchLevel_<=0 and (pack.status==1 or pack.status==2) and pack.matchid~="" then
			self:sendEnterMatch(pack.level,pack.matchid)    -- 正在比赛的时候 重新进入游戏BUG  重复进入  提示退出比赛
		end
	elseif cmd==P.SVR_REGISTER_COUNT then
		self.online[pack.level] = pack.regCount
		self:dispatchEvent({name="MATCH_REG_COUNT_CHANGE"})
	elseif cmd==P.SVR_AUTO_CANCEL_REGISTER then --server主动取消用户的报名状态
		self.online[pack.level] = 0
		self:dispatchEvent({name="MATCH_REG_COUNT_CHANGE"})
		if self.dealingMatchLevel_==pack.level then
			self.dealingMatchLevel_ = -1
		end
		self.regList[pack.level] = nil
		self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE"})
	elseif cmd==P.UPDATE_USER_PROP then
		-- 同步用户道具
		local propList = pack.propList
		for k,v in pairs(propList) do
			if v.pid==1 then
				tx.userData.money = v.num
			elseif v.pid==8 then
				tx.userData.diamonds = v.num
			end
		end
	elseif cmd==P.SVR_REGED_COUNT then
		self.online[pack.level] = pack.regCount
		self:dispatchEvent({name="MATCH_REG_COUNT_CHANGE"})
	elseif cmd==P.SVR_CMD_USER_MATCH_SCORE then
		if self.dealingMatchLevel_==pack.level then
			self.dealingMatchLevel_ = -1
		end
		-- 开始了全都清空
		self.online[pack.level] = 0
		self.regList[pack.level] = nil
		-- 颁奖
		local PopupAwards = require("app.module.match.views.PopupAwards")
		PopupAwards.new(pack.level, pack.selfRank):showPanel()
	elseif cmd==P.SVR_CMD_USER_MATCH_RISECHIP then

	elseif cmd==P.SVR_CMD_CHANGE_ROOM then

	elseif cmd==P.SVR_CMD_USER_MATCH_RANK then

	end
end

function MatchProxy:dealCachePack()  -- MatchSocket:resume调用
	while #self.cacheMatchStartPack > 0 do
		local curTime = os.time()
	    local pack = table.remove(self.cacheMatchStartPack, 1)
	    if pack.joinTime>(curTime-pack.receiveTime) then
	    	self.dealingMatchLevel_ = pack.level
			sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_START_LOGIN, data=pack})
			break;
		end
	end
end

function MatchProxy:dealReg(level)
	if not level then return end
	if not self.regList[level] then
		self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "START_REGISTER", level = level}})
		sa.EventCenter:dispatchEvent({name="MATCH_REG_STATUS_CHANGE", data = {status = "START_REGISTER"}})
		tx.socket.MatchSocket:reg(level,json.encode(tx.getUserInfo(false)))
	else
		tx.socket.MatchSocket:unReg(level,self.regList[level])
	end
end

function MatchProxy:unCurReg()
	local level = self.curMatchLevel_
	if level > 0 then
		self.curMatchLevel_ = -1
		self.online[level] = 0
		self:dispatchEvent({name = "MATCH_REG_COUNT_CHANGE"}) -- 派发事件
		if self.dealingMatchLevel_ == level then
			self.dealingMatchLevel_ = -1
		end
		self.regList[level] = nil
		self:dispatchEvent({name="MATCH_REG_STATUS_CHANGE"}) -- 派发事件
	end
end

function MatchProxy:playAgainReg(matchLevel)
	self:unCurReg()
	self:dealReg(matchLevel)
end

function MatchProxy:sendEnterMatch(level,matchid)
	self.dealingMatchLevel_ = level
	tx.socket.MatchSocket:sendEnterGame({level=level,matchid=matchid})
end

function MatchProxy:reset()
end

return MatchProxy