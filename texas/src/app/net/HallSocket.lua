local PROTOCOL = import(".HALL_SOCKET_PROTOCOL")
local SocketBase = import(".SocketBase")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local HallBroadcast = import(".HallBroadcast")
local HallSocket = class("HallSocket", SocketBase)

function HallSocket:ctor()
    HallSocket.super.ctor(self,"HallSocket", PROTOCOL)
    self.isInMatch = false -- 是否在比赛中
    self.isLogin_ = false
    self.isInRoom = nil
    self.hallBroadcast_ = HallBroadcast.new()
end

function HallSocket:disconnect(noEvent)
    self.logger_:debugf("disconnect %s", noEvent)
    HallSocket.super.disconnect(self, noEvent)
    self:clearAllAboutTime()
end

function HallSocket:clearAllAboutTime()
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

function HallSocket:login()
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    self.loginTimeoutHandle_ = scheduler.performWithDelayGlobal(function()
        self:disconnect()
        self:onFail_(consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT)
        local ip, port = string.match(tx.userData.HallServer[1], "([%d%.]+):(%d+)")
        tx.socket.HallSocket:connectDirect(ip, port, true) 
    end, 6)

    local terminal = 0
    local isFB = 0
    if string.upper(device.platform)=="ANDROID" then
        terminal = 0
    elseif string.upper(device.platform)=="IOS" then
        terminal = 1
    end
    if tx.userData.lid == 1 then  -- FB登录成功
        isFB = 1
    elseif tx.userData.lid == 2 then
        isFB = 0
    end
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_LOGIN)
        :setParameter("uid", tx.userData.uid)
        :setParameter("terminal",terminal)
        :setParameter("isFB",isFB)
        :setParameter("ver",1)
        :setParameter("guid","")
        :build()
    self:send(pack)
end

function HallSocket:onAfterConnected()
    self:login()
end

function HallSocket:onClosed(evt)
    self.isLogin_ = false
    HallSocket.super.onClosed(self, evt)
end

function HallSocket:onClose(evt)
    self:unscheduleHeartBeat()
end

function HallSocket:buildHeartBeatPack()
    return self:createPacketBuilder(PROTOCOL.HALL_CLI_HEART_BEAT):build()
end

function HallSocket:onHeartBeatTimeout(timeoutCount)
    sa.DataProxy:setData(tx.dataKeys.SIGNAL_STRENGTH, 0)
    if timeoutCount >= 3 then
        self:disconnect()
        self:clearAllAboutTime()
        self:onFail_(consts.SVR_ERROR.ERROR_HEART_TIME_OUT)
    end
end

function HallSocket:onHeartBeatReceived(delaySeconds)
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

function HallSocket:onAfterConnectFailure()
    self:onFail_(consts.SVR_ERROR.ERROR_CONNECT_FAILURE)
end

function HallSocket:isLogin()
    return self.isLogin_
end

function HallSocket:svrLoginOk(pack)
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    self:scheduleHeartBeat(PROTOCOL.HALL_SVR_HEART_BEAT, 10, 3)
    self.isLogin_ = true
end
function HallSocket:clearEnterGameTimer()
    --登录房间超时检测
    if self.loginRoomTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginRoomTimeoutHandle_)
        self.loginRoomTimeoutHandle_ = nil
    end
end
function HallSocket:createNewLoginRoomTimeOut_()
    self:clearEnterGameTimer()
    self.loginRoomTimeoutHandle_ = scheduler.performWithDelayGlobal(function()
        self.logger_:debug("login room timeout..")
        self:clearEnterGameTimer()
        sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_ROOM_FAIL, silent=false})
    end, 6)  --进入房间超过6秒算超时
end
function HallSocket:sendEnterGame(params)
    self:createNewLoginRoomTimeOut_()
    self.prevTid = params.prevTid -- 房间内重连进原来那个房间
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_GET_GAME_ROOM)
        :setParameter("gameLevel", params.gameLevel)
        :setParameter("gameId", params.gameId)
        :build()
    self:send(pack)
end
function HallSocket:changeGameRoom()
    self:createNewLoginRoomTimeOut_()
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_CHANGE_ROOM)
        :setParameter("gameLevel",self.curGameLevel)
        :setParameter("gameId",self.curGameId)
        :setParameter("tid",self.curTid)
        :build()
    self:send(pack)
end
function HallSocket:clearGame()
    self.gameSocket_ = nil
    self.gameId = nil
    self:setExtendProtocol(nil)
end
function HallSocket:setCurGame(gameId)
    if not gameId or gameId<1 then return; end
    local GameSocket = require("app.games."..app.GAMES[gameId].name..".net.GameSocket")
    if GameSocket then
        self:clearGame()
        self.gameSocket_ = GameSocket.new(self)
        self.gameId = gameId
        self:setExtendProtocol(self.gameSocket_:getProtocol())
    end
end

function HallSocket:onProcessPacket(pack)
    local cmd = pack.cmd
    if cmd == PROTOCOL.HALL_SVR_LOGIN_OK then  -- 登陆大厅成功
        self:svrLoginOk(pack)
        -- 重连  通过gameid 查找子配置
        self:setCurGame(pack.gameId)
        -- 房间内换桌用到
        if pack.tid and pack.tid>0 then
            self.curTid = pack.tid
            self.curGameLevel = pack.gameLevel
            self.curGameId = pack.gameId
        end
        -- 在房间内部重连房间实际已断开  有tid无需关注
        sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_HALL_SVR_SUCC, data=pack})
    elseif cmd == PROTOCOL.HALL_SVR_KICK_OUT then
        self.shouldConnect_ = false
        sa.EventCenter:dispatchEvent({name=tx.eventNames.DOUBLE_LOGIN_LOGINOUT})
    elseif cmd == PROTOCOL.HALL_SVR_ON_GAME_ROOM then
        self:createNewLoginRoomTimeOut_()
        self:setCurGame(pack.gameId)
        -- 房间内重连  房间内换房间
        if self.prevTid then
            pack.tid = self.prevTid
        end
        self.prevTid = nil
        self.curTid = pack.tid
        self.curGameLevel = pack.gameLevel
        self.curGameId = pack.gameId
    elseif cmd == PROTOCOL.HALL_SVR_ON_CREAT_ROOM then
        if pack.ret==0 then
            self.curTid = pack.tid

            self:createNewLoginRoomTimeOut_()
            pack.gameId = self.curGameId
            pack.gameLevel = self.curGameLevel
            pack.pwd = self.curGamePwd
            self:setCurGame(pack.gameId)
            -- 同步玩家钻石
            if pack.fee and pack.fee>0 then
                tx.userData.diamonds = tx.userData.diamonds - pack.fee
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={diamonds=(-pack.fee)}})
            end
        end
        sa.EventCenter:dispatchEvent({name=tx.eventNames.PRIVATE_CREAT_RESULT, data=pack})
    elseif cmd == PROTOCOL.HALL_SVR_ON_SEARCH_ROOM then
        if pack.ret==0 then
            -- 邀请直接带了密码不用再次输入  强制模拟数据  密码错误 房间里会再次过滤 弹出密码输入框
            if self.curGamePwd and self.curGamePwd~="" then
                pack.needPwd = 0 -- 默认不用密码了 有也没有
                pack.pwd = self.curGamePwd
            end

            if pack.needPwd==0 then
                self:createNewLoginRoomTimeOut_()
            end
            self:setCurGame(pack.gameId)

            self.prevTid = nil
            self.curTid = pack.tid
            self.curGameLevel = pack.gameLevel
            self.curGameId = pack.gameId
        end
        sa.EventCenter:dispatchEvent({name=tx.eventNames.SEARCH_ROOM_RESULT, data=pack})
    elseif cmd == PROTOCOL.HALL_SVR_CHANGE_ROOM then
        --换房超时
        self:clearEnterGameTimer()
        sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_ROOM_FAIL})
    elseif cmd == PROTOCOL.HALL_SVR_ON_PRIROOM_LIST then
        -- 私人房列表
        sa.EventCenter:dispatchEvent({name=tx.eventNames.PRIVATE_ROOM_LIST, data=pack})
    elseif cmd == PROTOCOL.HALL_BROADCAST_PERSON or cmd == PROTOCOL.HALL_BROADCAST_SYSTEM then
        self.hallBroadcast_:onProcessPacket(pack)
    elseif cmd == PROTOCOL.HALL_SVR_PRIVATE_ROOM_INFO then  -- 补充私人房客户端收到时间 和剩余时间
        pack.clientRecTime = os.time()
        pack.leftTime = pack.expireTime-pack.now
    elseif cmd == PROTOCOL.SVR_CARD_POWER then  -- 牌力指示器 因为比赛场不提供
        sa.EventCenter:dispatchEvent({name="TEXAS_CARD_POWER",data=pack})
    end
    -- 具体游戏接口
    if self.gameSocket_ then
        -- 进入房间子类一定要实现接口  getSuccessCmd()  getFailCmd()  startLoginRoom()
        if cmd==PROTOCOL.HALL_SVR_LOGIN_OK then -- 重连进入房间
            if pack.inTable>0 and pack.tid>0 then
                self.gameSocket_:startLoginRoom({
                    gameId = pack.gameId,
                    gameLevel = pack.gameLevel,
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                })
            end
        elseif cmd==PROTOCOL.HALL_SVR_ON_GAME_ROOM then -- 正常进入房间
            if pack.gameId==self.gameSocket_:getProtocol().GAMEID then -- 当前游戏
                self.gameSocket_:startLoginRoom({
                    gameId = pack.gameId,
                    gameLevel = pack.gameLevel,
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                })
            end
        elseif cmd==PROTOCOL.HALL_SVR_ON_CREAT_ROOM then --私人房进入房间
            if pack.ret==0 then
                self.gameSocket_:startLoginRoom({
                    gameId = pack.gameId,
                    gameLevel = pack.gameLevel,
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                    pwd = pack.pwd,
                })
            end
        elseif cmd==PROTOCOL.HALL_SVR_ON_SEARCH_ROOM then --查找 跟踪 快速开始进入房间
            if pack.ret==0 and pack.needPwd==0 then
                self.gameSocket_:startLoginRoom({
                    gameId = pack.gameId,
                    gameLevel = pack.gameLevel,
                    tid = pack.tid,
                    uid = tx.userData.uid,
                    info = json.encode(tx.getUserInfo(false)),
                    mtkey = "",
                    pwd = pack.pwd,
                })
            end
        elseif cmd==self.gameSocket_:getSuccessCmd() then  -- 保协议中必须要有tid
            self.curTid = pack.tid or self.curTid
            --登录房间超时检测
            self:clearEnterGameTimer()
            sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_ROOM_SUCC, data=pack})
        elseif cmd==self.gameSocket_:getFailCmd() then
            --登录房间超时检测
            self:clearEnterGameTimer()
            sa.EventCenter:dispatchEvent({name=tx.eventNames.LOGIN_ROOM_FAIL, silent=true, data=pack})
            -- self:onFail_(consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT)
        end
        self.gameSocket_:onProcessPacket(pack)
    end
end

function HallSocket:onFail_(errorCode)
    sa.EventCenter:dispatchEvent({name=tx.eventNames.SVR_ERROR, data=errorCode})
end
-- 私人房
function HallSocket:createRoom(gameId,gameLevel,blind,optTime,pwd,expTime)
    self.curGameId = gameId
    self.curGameLevel = gameLevel
    self.curGamePwd = pwd
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_CREAT_ROOM)
        :setParameter("gameId", gameId)
        :setParameter("gameLevel", gameLevel)
        :setParameter("blind", blind)
        :setParameter("optTime", optTime)
        :setParameter("pwd", pwd)
        :setParameter("expTime", expTime)
        :build()
    self:send(pack)
end
function HallSocket:enterPrivateRoom(pwd)
    self.curGamePwd = pwd
    -- 模拟包数据
    local pack = {
        ret = 0,
        fee = 0,
        cmd = PROTOCOL.HALL_SVR_ON_CREAT_ROOM,
        tid = self.curTid
    }
    self:onProcessPacket(pack)
end
function HallSocket:fastEnterRoom(gameId,gameLevel,tid,pwd)
    if pwd then
        self.curGamePwd = pwd
    else
        self.curGamePwd = ""
    end
    -- 模拟包数据
    local pack = {
        ret = 0,
        gameId = gameId,
        tid = tid,
        gameLevel = gameLevel,
        needPwd = 0,
        cmd = PROTOCOL.HALL_SVR_ON_SEARCH_ROOM,
    }
    self:onProcessPacket(pack)
end
function HallSocket:searchRoom(gameId,tid,pwd)
    if pwd then
        self.curGamePwd = pwd
    else
        self.curGamePwd = ""
    end
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_SEARCH_ROOM)
        :setParameter("gameId", gameId)
        :setParameter("tid", tid)
        :build()
    self:send(pack)
end
function HallSocket:getPriRoomList(page,count,gameId,gameLevel)
    if not page then page=1 end
    if not count then count=5 end
    if not gameId then gameId=1 end
    if not gameLevel then gameLevel=100 end
    local pack = self:createPacketBuilder(PROTOCOL.HALL_CLI_GET_PRIROOM_LIST)
        :setParameter("gameId", gameId)
        :setParameter("gameLevel", gameLevel)
        :setParameter("page", page)
        :setParameter("count", count)
        :build()
    self:send(pack)
end
---------------------------------------------------------------------------------------

function HallSocket:sendGameCmd(functionName, ... )
    if self.isInMatch then
        tx.socket.MatchSocket:sendGameCmd(functionName, ... )
    else
        if self.gameSocket_ and self.gameSocket_[functionName] then
            self.gameSocket_[functionName](self.gameSocket_,...)
        end
    end
end

function HallSocket:sendExpression(expId,isVip)
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_EXP)
        :setParameter("expId", expId)
        :setParameter("isVip", isVip)
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendChatMsg(msg,index)
    if not msg or string.trim(msg)=="" then
        return;
    end
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[1],
        id=tx.userData.uid,
        n=tx.userData.nick,
        i=index or 0,
        m=msg,
        v=tx.userData.vipinfo.level
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendSetGift(giftId,uid)
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[2],
        id=tx.userData.uid,
        gid=giftId
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendPresentGift(giftId,sendUid,toUids)
    if not toUids or #toUids<1 then return; end
    local toUidsStr=""
    for k,v in ipairs(toUids) do
        if k==1 then
            toUidsStr = ""..v
        else
            toUidsStr = toUidsStr..","..v
        end
    end
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[6],
        id=sendUid,
        gid=giftId,
        toids=toUidsStr
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendHddj(hddjId, fromSeatId, toSeatId, extraData)
    if not extraData then extraData = {} end
    local msgInfo = {
        t = PROTOCOL.TABLE_MSG_TYPES[3],
        id = hddjId,
        from = fromSeatId,
        to = toSeatId,
        fromUid = extraData.fromUid,
        toUid = extraData.toUid
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendAddFriend(fromSeatId,toSeatId, extraData)
    if not extraData then extraData = {} end
    local msgInfo = {
        t = PROTOCOL.TABLE_MSG_TYPES[4],
        from = fromSeatId,
        to = toSeatId,
        fromUid = extraData.fromUid,
        toUid = extraData.toUid
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end

function HallSocket:sendChips(chips,fromSeatId,toSeatId,isInTable)
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[5],
        chips=chips,
        from=fromSeatId,
        to=toSeatId,
        isInT=isInTable,
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end
-- 更改桌上其他人信息 同步server 不广播
function HallSocket:sendOtherPlayerInfoChanged(giftId,sendUid,toUids,toInfos)
    if not toUids or #toUids<1 or not toInfos or #toInfos<1 then return; end
    local list = {}
    local item = nil
    for k,v in ipairs(toUids) do
        item = {}
        item.uid = v
        if v==tx.userData.uid then
            tx.userData.user_gift = giftId -- 还是在这里设置吧
            item.info = json.encode(tx.getUserInfo(false))
        else
            local info = toInfos[k]
            if info then
                info = json.decode(info)
                info.giftId = giftId
                info = json.encode(info)
            end
            item.info = info
            table.insert(list,item)
        end
    end
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_SYN_PLAYER_INFO)
        :setParameter("list",list)
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end
-- 更改个人信息  同步server 不广播  客户端自己进行广播  -- 其他玩家看到
function HallSocket:sendUserInfoChanged(isBroadCast)
    local list = {{uid=tx.userData.uid,info=json.encode(tx.getUserInfo(false))}}
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_SYN_PLAYER_INFO)
        :setParameter("list",list)
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
    if isBroadCast then
        local msgInfo = tx.getUserInfo(false)
        msgInfo.t = PROTOCOL.TABLE_MSG_TYPES[7]
        local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
            :setParameter("info", json.encode(msgInfo))
            :build()
        if self.isInMatch then
            tx.socket.MatchSocket:send(pack)
        else
            self:send(pack)
        end
    end
end
-- 德州亮手牌功能
function HallSocket:showTexasHandCards(cardInfo)
    if not cardInfo then return; end
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[8],
    }
    local value = false
    for k,v in pairs(cardInfo) do
        value = true
        msgInfo[k] = v
    end
    if not value then
        return;
    end
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end
-- 发送语音聊天
function HallSocket:sendVoice(ret)
    if not ret or not ret.downloadUrl or ret.downloadUrl=="" then return; end
    local msgInfo = {
        t=PROTOCOL.TABLE_MSG_TYPES[9],
        d=ret.duration or 1,
        url=ret.downloadUrl,
        id=tx.userData.uid,
        n=tx.userData.nick,
    }
    local pack = self:createPacketBuilder(PROTOCOL.TABLE_CLI_MSG)
        :setParameter("info", json.encode(msgInfo))
        :build()
    if self.isInMatch then
        tx.socket.MatchSocket:send(pack)
    else
        self:send(pack)
    end
end
-- 牌力指示器
function HallSocket:getCardPower(num,card1,card2,pubCards)
    local pack = self:createPacketBuilder(PROTOCOL.CLI_CARD_POWER)
        :setParameter("uid",tx.userData.uid)
        :setParameter("num",num)
        :setParameter("card1",card1)
        :setParameter("card2",card2)
        :setParameter("pubCards",pubCards)
        :build()
    self:send(pack)
end

-- 服务器有没有断开
function HallSocket:send(pack,isHeartBeat)
    HallSocket.super.send(self,pack)
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

return HallSocket