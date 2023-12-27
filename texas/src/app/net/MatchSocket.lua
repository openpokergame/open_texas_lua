local PROTOCOL = import(".MATCH_SOCKET_PROTOCOL")
local SocketBase = import(".SocketBase")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local MatchSocket = class("MatchSocket", SocketBase)

function MatchSocket:ctor()
    MatchSocket.super.ctor(self,"MatchSocket", PROTOCOL)
    self.isLogin_ = false
end

function MatchSocket:resume()
    MatchSocket.super.resume(self)
    if tx.matchProxy and tx.matchProxy.dealCachePack then
        tx.matchProxy:dealCachePack()
    end
end

function MatchSocket:disconnect(noEvent)
    self.logger_:debugf("disconnect %s", noEvent)
    MatchSocket.super.disconnect(self, noEvent)
    self:clearAllAboutTime()
end

function MatchSocket:clearAllAboutTime()
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    --登录房间超时检测
    if self.loginRoomTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginRoomTimeoutHandle_)
        self.loginRoomTimeoutHandle_ = nil
    end
end

function MatchSocket:login()
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    self.loginTimeoutHandle_ = scheduler.performWithDelayGlobal(function()
        self:disconnect()
        self:onFail_(consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT)
        local ip, port = string.match(tx.userData.MatchServer[1], "([%d%.]+):(%d+)")
        tx.socket.MatchSocket:connectDirect(ip, port, true) 
    end, 6)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_LOGIN)
        :setParameter("uid", tx.userData.uid)
        :setParameter("info","")
        :build()
    self:send(pack)
end

function MatchSocket:onAfterConnected()
    self:login()
end

function MatchSocket:onClosed(evt)
    self.isLogin_ = false
    MatchSocket.super.onClosed(self, evt)
end

function MatchSocket:onClose(evt)
    self:unscheduleHeartBeat()
end

function MatchSocket:buildHeartBeatPack()
    return self:createPacketBuilder(PROTOCOL.HALL_CLI_HEART_BEAT):build()
end

function MatchSocket:onHeartBeatTimeout(timeoutCount)
    sa.DataProxy:setData(tx.dataKeys.SIGNAL_STRENGTH, 0)
    if timeoutCount >= 3 then
        self:disconnect()
        self:clearAllAboutTime()
        self:onFail_(consts.SVR_ERROR.ERROR_HEART_TIME_OUT)
    end
end

function MatchSocket:onHeartBeatReceived(delaySeconds)
    local signalStrength
    if delaySeconds < 0.4 then
        signalStrength = 4
    elseif delaySeconds < 0.8 then
        signalStrength = 3
    elseif delaySeconds < 1.2 then
        signalStrength = 2
    else
        signalStrength = 1
    end
    sa.DataProxy:setData(tx.dataKeys.SIGNAL_STRENGTH, signalStrength)
end

function MatchSocket:onAfterConnectFailure()
    self:onFail_(consts.SVR_ERROR.ERROR_CONNECT_FAILURE)
end

function MatchSocket:isLogin()
    return self.isLogin_
end

function MatchSocket:svrLoginOk(pack)
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    self:scheduleHeartBeat(PROTOCOL.HALL_SVR_HEART_BEAT, 10, 3)
    self.isLogin_ = true
end
function MatchSocket:clearEnterGameTimer()
    --登录房间超时检测
    if self.loginRoomTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginRoomTimeoutHandle_)
        self.loginRoomTimeoutHandle_ = nil
    end
end
function MatchSocket:createNewLoginRoomTimeOut_()
    self:clearEnterGameTimer()
    self.loginRoomTimeoutHandle_ = scheduler.performWithDelayGlobal(function()
        self.logger_:debug("login room timeout..")
        self:clearEnterGameTimer()
        sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_LOGIN_ROOM_FAIL, silent=false})
    end, 6)  --进入房间超过6秒算超时
end
function MatchSocket:sendEnterGame(params)
    self:createNewLoginRoomTimeOut_()
    local pack = self:createPacketBuilder(PROTOCOL.CLI_JOIN_GAME)
        :setParameter("level", params.level)
        :setParameter("matchid", params.matchid)
        :build()
    self:send(pack)
end
function MatchSocket:clearGame()
    self.gameSocket_ = nil
    self.gameId = nil
    self:setExtendProtocol(nil)
end
function MatchSocket:setCurGame(gameId)
    if not gameId or gameId~=2 then return; end
    local GameSocket = require("app.games."..app.GAMES[gameId].name..".net.GameSocket")
    if GameSocket then
        self:clearGame()
        self.gameSocket_ = GameSocket.new(self)
        self.gameId = gameId
        self:setExtendProtocol(self.gameSocket_:getProtocol())
    end
end

function MatchSocket:onProcessPacket(pack)
    pack.gameId = 2 -- 比赛场默认都为2
    local cmd = pack.cmd
    if cmd == PROTOCOL.SVR_LOGIN_OK then  -- 登陆大厅成功
        self.serverTime = pack.time   -- 倒计时
        self.clientTime = os.time()
        self:svrLoginOk(pack)
        self:setCurGame(2)
        -- 在比赛内部重连自己已淘汰
        sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_MATCH_HALL_SVR_SUCC, data=pack})
    elseif cmd==PROTOCOL.SVR_LOGIN_ERROR then
        self:disconnect()
        self:onFail_()
    elseif cmd==PROTOCOL.SVR_JOIN_GAME then
        pack.receiveTime = os.time()
    end
    -- 具体游戏接口
    if self.gameSocket_ then
        -- 进入房间子类一定要实现接口  getSuccessCmd()  getFailCmd()  startLoginRoom()
        if cmd==PROTOCOL.SVR_LOGIN_OK then -- 重连
            if pack.matchid and pack.tid>0 and pack.matchid~="" then
                self.gameSocket_:startLoginRoom({
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                    matchid = pack.matchid,
                })
            end
        elseif cmd==PROTOCOL.SVR_JOIN_GAME_SUCC then -- 正常进入比赛
            if pack.gameId==self.gameSocket_:getProtocol().GAMEID then -- 当前游戏
                self.gameSocket_:startLoginRoom({
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                    matchid = pack.matchid,
                })
            end
        elseif cmd==self.gameSocket_:getSuccessCmd() then
            --登录房间超时检测
            self:clearEnterGameTimer()
            sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_LOGIN_ROOM_SUCC, data=pack})
        elseif cmd==self.gameSocket_:getFailCmd() then
            --登录房间超时检测
            self:clearEnterGameTimer()
            sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_LOGIN_ROOM_FAIL, silent=true})
            -- self:onFail_(consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT)
        end
        self.gameSocket_:onProcessPacket(pack)
    end
end

function MatchSocket:onFail_(errorCode)
    sa.EventCenter:dispatchEvent({name=tx.eventNames.MATCH_SVR_ERROR, data=errorCode})
end
---------------------------------------------------------------------------------------
function MatchSocket:reg(level,info)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_REGISTER)
        :setParameter("level", level)
        :setParameter("info", info)
        :build()
    self:send(pack)
end

function MatchSocket:unReg(level,matchid)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_CANCEL_REGISTER)
        :setParameter("level", level)
        :setParameter("matchid", matchid)
        :build()
    self:send(pack)
end

function MatchSocket:getStatus(level)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_GET_MATCH_STATUS)
        :setParameter("level", level)
        :build()
    self:send(pack)
end

function MatchSocket:getRegCount(level)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_GET_REGED_COUNT)
        :setParameter("level", level)
        :build()
    self:send(pack)
end
---------------------------------------------------------------------------------------
function MatchSocket:sendGameCmd(functionName, ... )
    if self.gameSocket_ and self.gameSocket_[functionName] then
        self.gameSocket_[functionName](self.gameSocket_,...)
    end
end

function MatchSocket:sendExpression(expId,isVip)
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_EXP)
        :setParameter("expId", expId)
        :setParameter("isVip", isVip)
        :build()
    self:send(pack)
end

-- 服务器有没有断开
function MatchSocket:send(pack,isHeartBeat)
    MatchSocket.super.send(self,pack)
    if not self.isConnected_ then
        -- 正在连接断掉
        if isHeartBeat then
            -- self:onFail_(consts.SVR_ERROR.ERROR_HEART_TIME_OUT)
        else
            self:disconnect()
            self:clearAllAboutTime()
            self:onFail_(consts.SVR_ERROR.ERROR_SEND_NOT_CON)
        end
    end
end

return MatchSocket