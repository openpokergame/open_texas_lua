--选场界面基类
local HallController = import("app.module.hall.HallController")
local GameHallScene = class("GameHallScene", function()
    return display.newScene("GameHallScene")
end)

local FirstPayButton = require("app.module.firstpay.FirstPayButton")

function GameHallScene:ctor(gameId)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    tx.socket.HallSocket.isInMatch = false
    tx.socket.HallSocket.isInRoom = nil
	self:setNodeEventEnabled(true)
    _G.From_Hall_Type = 0
    _G.Quick_Play_Now = 0  -- 快速开始进入房间坐下
	self.gameId = gameId or -1  --当前游戏ID
    if tx.userData then
        tx.userData.lastGameOverMoney = nil
    end
end

function GameHallScene:onLoginRoomFail_(evt)
	if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    if not evt or not evt.silent then  -- 超时
        tx.ui.Dialog.new({
            hasCloseButton = false,
            messageText = sa.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"),
            secondBtnText = sa.LangUtil.getText("COMMON", "RETRY"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                  	self:requestRoom()
                -- elseif type == tx.ui.Dialog.FIRST_BTN_CLICK or type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                --     self:doBackToHall()
                end
            end
        }):show()
    elseif evt and evt.data then -- 错误码处理
        if evt.data.code==10 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "CHECK_PASSWORD_ERROR"))
            local EnterRommPwdPop = require("app.module.privateroom.EnterRommPwdPop")
            EnterRommPwdPop.new(function(pwd)
                self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
                    :pos(display.cx, display.cy)
                    :addTo(self, 100)
                tx.socket.HallSocket:enterPrivateRoom(pwd)
            end):showPanel()
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR"))
        end
    end
end

-- 快速开始
function GameHallScene:quickStart(gameId)
    if self.isSendingQuickStart_ then return; end
    _G.Quick_Play_Now = 1  -- 立即坐下
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    self.isSendingQuickStart_ = true
    gameId = gameId or 1 --默认德州
    sa.HttpService.CANCEL(self.quickStartId_)
    self.quickStartId_ = sa.HttpService.POST(
        {
            mod = "Quickstart",
            act = "qstart",
            gameId = gameId,
        },
        function (data)
            self.isSendingQuickStart_ = nil
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                if retData.tid and tonumber(retData.tid)>0 then
                    local roomData = {serverGameid = retData.gameid, serverLevel = retData.level, serverTid = retData.tid}
                    sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = roomData})
                else
                    self:requestRoom({gameId=retData.gameid,level=retData.level}, true)
                end
            else
                if self.roomLoading_ then
                    self.roomLoading_:removeFromParent()
                    self.roomLoading_ = nil
                end
                tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
            end
        end,
        function()
            tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
            if self.roomLoading_ then
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end
            self.isSendingQuickStart_ = nil
        end
    )
end

-- 请求房间登录
function GameHallScene:requestRoom(param,noNewAnim)
    if not noNewAnim then
    	if self.roomLoading_ then 
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end

        local msg = param and param.msg
        if not msg then
            msg = sa.LangUtil.getText("ROOM", "ENTERING_MSG")
        end

        self.roomLoading_ = tx.ui.RoomLoading.new(msg)
            :pos(display.cx, display.cy)
            :addTo(self, 100)
    end
    local level = (param and param.level) and param.level or self.level_
    if not level then
    	level = 0
    end

    local gameId = (param and param.gameId) and param.gameId or self.gameId
    if not gameId or gameId==0 or gameId==-1 then
        gameId = self.preGameId_
    end

    if not gameId or gameId==-1 then
        gameId = 0
    end
    self.preGameId_ = gameId
    self.level_ = level
    tx.socket.HallSocket:sendEnterGame({gameLevel=level,gameId=gameId})
end

-- 进入大厅
function GameHallScene:doBackToHall(msg)
    if self.doBacking_ then
        return
    end

    self.doBacking_ = true

    app:enterMainHall({HallController.MAIN_HALL_VIEW})
end

function GameHallScene:onServerStop_(evt)
	if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    tx.ui.Dialog.new({
        messageText = sa.LangUtil.getText("ROOM", "SERVER_STOPPED_MSG"), 
        secondBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"), 
        closeWhenTouchModel = false,
        hasFirstButton = false,
        hasCloseButton = false,
        callback = function (type)
            if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
                    :pos(display.cx, display.cy)
                    :addTo(self, 100)
                app:enterMainHall({HallController.LOGIN_GAME_VIEW, "logout"})
            end
        end,
    }):show()
end

function GameHallScene:onLoginRoomSucc_(evt)
	evt:stop()   -- 切换场景重复监听到
    -- local data = evt.data
    app:enterGameRoom(tx.socket.HallSocket.gameId)
end

function GameHallScene:doubleLoginOut_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    local msg = sa.LangUtil.getText("ROOM", "OUT_MSG")
    self.roomLoading_ = tx.ui.RoomLoading.new(msg)
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    app:enterMainHall({HallController.LOGIN_GAME_VIEW, "doublelogin"})
end

function GameHallScene:onServerFail_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    -- 这种状态自己回去连接
    if evt.data == consts.SVR_ERROR.ERROR_SEND_NOT_CON then
        tx.ui.Dialog.new({
            -- hasCloseButton = false,
            closeWhenTouchModel = false,
            messageText = sa.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"),
            secondBtnText = sa.LangUtil.getText("COMMON", "RETRY"),
            -- firstBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
                        :pos(display.cx, display.cy)
                        :addTo(self, 100)
                    tx.socket.HallSocket:disconnect()
                    local ip, port = string.match(tx.userData.HallServer[1], "([%d%.]+):(%d+)")
                    tx.socket.HallSocket:connectDirect(ip, port, false) -- 不能自动重连 必须要显示 否则失败了没有事件出来
                -- elseif type == tx.ui.Dialog.FIRST_BTN_CLICK or type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                --     self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
                --         :pos(display.cx, display.cy)
                --         :addTo(self, 100)
                --     app:enterMainHall({HallController.LOGIN_GAME_VIEW, "logout"})
                end
            end
        }):show()
    elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then
        
    elseif evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT or evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE then
        tx.socket.HallSocket:disconnect()
        local ip, port = string.match(tx.userData.HallServer[1], "([%d%.]+):(%d+)")
        tx.socket.HallSocket:connectDirect(ip, port, false) -- 不能自动重连 必须要显示 否则失败了没有事件出来
    end
end

function GameHallScene:onMatchStartLogin_(evt)  --静悄悄的进入比赛
    local pack=evt.data
    tx.matchProxy:sendEnterMatch(pack.level,pack.matchid)
end

function GameHallScene:onLoginMatchRoomFail_(evt)
    
end

function GameHallScene:onLoginMatchRoomSucc_(evt)
    evt:stop()
    app:enterGameRoom(tx.socket.MatchSocket.gameId)
end

function GameHallScene:onMatchServerFail_(evt)
    
end

function GameHallScene:onLoginHallSvrSucc_(evt)
    local pack = evt.data
    if not pack or not pack.tid or pack.tid<1 then
        if self.roomLoading_ then 
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
    end
end

function GameHallScene:onLoginMatchHallSvrSucc_(evt)
end

function GameHallScene:handleLogoutSucc_(evt)
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    app:enterMainHall({HallController.LOGIN_GAME_VIEW, "logout"})
end

function GameHallScene:handleCreateRoom_(evt)
    local data = evt.data
    if data and data.ret==0 then
        -- tx.PopupManager:removeTopPopupIf()
        if self.roomLoading_ then
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
        self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
            :pos(display.cx, display.cy)
            :addTo(self, 100)
    elseif data and data.ret==3 then  -- 创建的房间超过上限
        if self.roomLoading_ then
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
        tx.TopTipManager:showToast(sa.LangUtil.getText("PRIVTE", "ROOMMAXTIPS"))
    else
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("COMMON", "NOT_ENOUGH_DIAMONDS"),
            secondBtnText = sa.LangUtil.getText("COMMON", "BUY"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    tx.PayGuideManager:openStore(2)
                end
            end
        }):show()
    end
end

function GameHallScene:handleSearchRoom_(evt)
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    local data = evt.data
    if data and data.ret==0 then
        -- tx.PopupManager:removeTopPopupIf()
        local fun = function()
            self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
                :pos(display.cx, display.cy)
                :addTo(self, 100)
        end
        if data.needPwd==1 then
            local EnterRommPwdPop = require("app.module.privateroom.EnterRommPwdPop")
            EnterRommPwdPop.new(function(pwd)
                fun()
                tx.socket.HallSocket:enterPrivateRoom(pwd)
            end):showPanel()
        else
            fun()
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR"))
    end
end

function GameHallScene:handleEnterRoomWithData_(evt)
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    local data = evt.data
    if not data or not data.serverGameid or not data.serverTid or tonumber(data.serverGameid)<1 or tonumber(data.serverTid)<1 then
        return
    -- elseif evt.isTrace then
    --     if data.minLevel and tx.userData.level < tonumber(data.minLevel) then
    --         tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "TRACE_LIMIT_LEVEL", data.minLevel))
    --         return
    --     --elseif data.minAnte and tx.userData.money < tonumber(data.minAnte) then
    --     --     tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "TRACE_LIMIT_ANTE", sa.formatBigNumber(data.minAnte)))
    --     --     return
    --     end
    end

    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    if data.serverLevel then--快速进入
        _G.Quick_Play_Now = 1
        tx.socket.HallSocket:fastEnterRoom(data.serverGameid,data.serverLevel,data.serverTid,data.pwd)
    else--验证桌子 获取serverLevel
        tx.socket.HallSocket:searchRoom(data.serverGameid,data.serverTid,data.pwd)
    end
end

function GameHallScene:handlerBackKey()
    self:doBackToHall()
end

function GameHallScene:updateShopIcon_(evt)
    local goods = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
    if goods and goods.gid then
        local now = os.time()
        if (now-goods.clientTime)>=tonumber(goods.countdown) then
            tx.userData.payinfo.brokesalegoods = nil
        end
    end
end

-- 处理商城显示
function GameHallScene:dealShopShow(shopBtn,offX,offY)
    if not shopBtn or not shopBtn:getParent() then return; end
    if not offX then offX=0 end
    if not offY then offY=0 end
    local xx,yy = shopBtn:getPosition()
    local parent_ = shopBtn:getParent()
    shopBtn:hide()
    if self.firstPayBtn_ then
        self.firstPayBtn_:hide()
    end

    if not self.discountTips_ then
        local DiscountTips = require("app.pokerUI.DiscountTips")
        self.discountTips_ = DiscountTips.new()
            :pos(xx-45+offX, yy+21+offY)
            :addTo(parent_)
    end

    self.discountTips_:hide()

    -- 破产
    local brokenData = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
    if brokenData and brokenData.gid then
        shopBtn:show()
        self:showDiscount_(brokenData)
    elseif tx.userData.payStatus == 0 then
        if not self.firstPayBtn_ then
            self.firstPayBtn_ = FirstPayButton.new()
                :pos(xx-5,yy-3)
                :addTo(parent_)
        end
        self.firstPayBtn_:show()
    else
        shopBtn:show()
    end
end

function GameHallScene:showDiscount_(data)
    local time = tonumber(data.countdown) - (os.time()-data.clientTime)
    self.discountTips_:setInfo(time,"+"..data.sale.."%")
end

function GameHallScene:onPlayPropertyChangeAnim(evt)
    local x, y = 220, 70
    if evt and evt.data then
        for k, v in pairs(evt.data) do
            if k=="money" then
                app:tip(1, v, x, y)
            elseif k=="diamonds" then
                app:tip(2, v, x, y)
            elseif k=="props" then
                app:tip(3, v, x, y)
            elseif k=="speakers" then
                app:tip(5, v, x, y)
            end
        end
    end
end

function GameHallScene:onRecordVoiceEnd(evt)
    --大厅暂时不做处理
end

function GameHallScene:onRegStatusChange_(evt)
end

--破产
function GameHallScene:onBrokeShow(param)
    tx.PayGuideManager:userCrashGuide(param or {})
end

function GameHallScene:showQuickPayPopup()
    local QuickPayPopup = require("app.module.payguide.quickpay.QuickPayPopup")
    QuickPayPopup.new():showPanel()
end

function GameHallScene:showFirstPayPopup()
    local FirstPayPopup = require("app.module.payguide.firstpay.FirstPayPopup")
    FirstPayPopup.new():showPanel()
end

--------------------------Node事件-------------------------
function GameHallScene:onEnter()
end

-- 子类必须调用
function GameHallScene:onEnterTransitionFinish()
    self:__addSocketEvt__()
    -- 此时没有场景... 延迟一点点吧
    self:performWithDelay(function( ... )
        tx.socket.HallSocket:resume()
        tx.socket.MatchSocket:resume()
    end,0.01)

    -- -- 输赢统计
    -- _G.PlayStatistics = {
    --     changeChips = 200000,
    --     playNum = 10,
    --     maxWin = 30,
    --     -- type=1
    -- }
    -- tx.config.WIN_SHARE = 1 --test
    if _G.PlayStatistics then
        local statistics = _G.PlayStatistics
        statistics.gameLevel = tx.socket.HallSocket.curGameLevel
        statistics.gameId = _G.curInGameId

        local normalFun = function()  -- 正常赢钱动画
            if tx.config.WIN_SHARE==1 then
                local WinOrLosePopup = require("app.module.winorlose.WinOrLosePopup")
                self:performWithDelay(function( ... )
                    if tx.userData then  -- 账号被踢出
                        WinOrLosePopup.new(statistics):showPanel()
                    end
                end,0.02)
            end
        end
        if statistics.changeChips and statistics.changeChips>=100000 then  -- 走原来的流程 -- 分享评分
            local lastShareTime = tx.userDefault:getIntegerForKey("CUR_SHARE_VER_TIME",0)
            local curTime = os.time()
            --一天弹一次
            if curTime-lastShareTime<24*3600 then
                normalFun()
            else
                local lastShareTime = tx.userDefault:setIntegerForKey("CUR_SHARE_VER_TIME",curTime)
                local nativeVer = tx.Native:getAppVersion()
                local curShareVer = tx.userDefault:getStringForKey("CUR_SHARE_VER","")
                local gradeTimes = tx.userDefault:getIntegerForKey("CUR_SHARE_VER_NUM",3)
                if nativeVer~=curShareVer then
                    tx.userDefault:setStringForKey("CUR_SHARE_VER",nativeVer)
                    tx.userDefault:setIntegerForKey("CUR_SHARE_VER_NUM",0)
                    gradeTimes = 0
                end
                if gradeTimes<3 then
                    statistics.type=1
                end
                tx.userDefault:setIntegerForKey("CUR_SHARE_VER_NUM",(gradeTimes+1))
                local WinOrLosePopup = require("app.module.winorlose.WinOrLosePopup")
                self:performWithDelay(function( ... )
                    if tx.userData then  -- 账号被踢出
                        WinOrLosePopup.new(statistics):showPanel()
                    end
                end,0.02)
            end
        elseif statistics.changeChips and statistics.changeChips>0 then -- 赢钱分享
            normalFun()
        elseif _G.curInGameId==1 and tx.userData and tx.userData.needTutorial==1 and statistics.changeChips and statistics.changeChips<0 then-- 新手引导 在德州第一次输
            tx.userData.needTutorial = nil
            self:performWithDelay(function()
                if tx.userData then  -- 账号被踢出
                    self:openTutorial()
                end
            end,0.02)
        elseif statistics.changeChips and statistics.changeChips<0 then -- 输钱，弹出首冲
            -- if tx.userData and tx.config.LOSE_OPEN_FIRSTPAY==1 and tx.userData.payinfo and tx.userData.payinfo.boughtFirstPayGoods == 0 then
            if tx.userData and tx.config.LOSE_OPEN_FIRSTPAY == 1 and tx.userData.payStatus == 0 then
                self:performWithDelay(function()
                    tx.PayGuideManager:firstPayGuide()
                end,0.02)
            end
        end
    end
    _G.PlayStatistics = nil
    _G.curInGameId = nil

    if device.platform == "android" and not self.virtualKeyLayer_ then
        self.virtualKeyLayer_ = display.newLayer()
        self.virtualKeyLayer_:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
            if event.key == "back" then
                if not tx.PopupManager:removeTopPopupIf() then
                    self:handlerBackKey()
                end
            end
        end)
        self.virtualKeyLayer_:setKeypadEnabled(true)
        self:addChild(self.virtualKeyLayer_,-1)
    end
end

function GameHallScene:openTutorial()
    -- tx.ui.Dialog.new({
    --     hasCloseButton = true,
    --     messageText = sa.LangUtil.getText("TUTORIAL","FIRST_IN_TIPS"),
    --     firstBtnText = sa.LangUtil.getText("TUTORIAL", "FIRST_IN_BTN1"),
    --     secondBtnText = sa.LangUtil.getText("TUTORIAL", "FIRST_IN_BTN2"),
    --     callback = function (type)
    --         if type == tx.ui.Dialog.FIRST_BTN_CLICK then
                
    --         elseif type == tx.ui.Dialog.SECOND_BTN_CLICK then
    --             self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
    --                 :pos(display.cx, display.cy)
    --                 :addTo(self, 100)
    --             app:enterGameRoom(0)
    --         elseif type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                
    --         end
    --     end
    -- }):show()
end

-- 子类必须调用
function GameHallScene:onExitTransitionStart()
    self:__removeSocketEvt__()
    -- tx.socket.HallSocket:pause()
    -- tx.socket.MatchSocket:pause() 
end

function GameHallScene:onExit()  
end

-- 子类必须调用 
function GameHallScene:onCleanup(notReleaseRes)
    self:__removeSocketEvt__()
    if not notReleaseRes then
        local releaseList = app.GAMES[self.gameId] and app.GAMES[self.gameId].halltex
        if releaseList then
            for k,v in pairs(releaseList) do
                display.removeSpriteFramesWithFile(v[1], v[2])
            end
        end
    end
end

function GameHallScene:__addSocketEvt__()
    self:__removeSocketEvt__()
    self.loginRoomFailListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.LOGIN_ROOM_FAIL, handler(self, self.onLoginRoomFail_))
    self.serverStopListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.SERVER_STOPPED, handler(self, self.onServerStop_))
    self.loginRoomSuccListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.LOGIN_ROOM_SUCC, handler(self, self.onLoginRoomSucc_))
    self.logoutByMsg_ = sa.EventCenter:addEventListener(tx.eventNames.DOUBLE_LOGIN_LOGINOUT,handler(self, self.doubleLoginOut_))
    self.svrErrorListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.SVR_ERROR, handler(self, self.onServerFail_))
    -- 比赛相关
    self.matchStartLoginId_ = sa.EventCenter:addEventListener(tx.eventNames.MATCH_START_LOGIN, handler(self, self.onMatchStartLogin_))
    self.loginMatchRoomFailId_ = sa.EventCenter:addEventListener(tx.eventNames.MATCH_LOGIN_ROOM_FAIL, handler(self, self.onLoginMatchRoomFail_))
    self.loginMatchRoomSuccId_ = sa.EventCenter:addEventListener(tx.eventNames.MATCH_LOGIN_ROOM_SUCC, handler(self, self.onLoginMatchRoomSucc_))
    self.matchSvrErrorId_ = sa.EventCenter:addEventListener(tx.eventNames.MATCH_SVR_ERROR, handler(self, self.onMatchServerFail_))
    -- 重连
    self.loginHallSvrSuccId_ = sa.EventCenter:addEventListener(tx.eventNames.LOGIN_HALL_SVR_SUCC, handler(self, self.onLoginHallSvrSucc_))
    self.loginMatchHallSvrSuccId_ = sa.EventCenter:addEventListener(tx.eventNames.LOGIN_MATCH_HALL_SVR_SUCC, handler(self, self.onLoginMatchHallSvrSucc_))
    -- 切换账号
    self.handleLogoutSuccId_ = sa.EventCenter:addEventListener(tx.eventNames.HALL_LOGOUT_SUCC, handler(self, self.handleLogoutSucc_))
    -- 创建私人房
    self.handlerCreateRoomId_ = sa.EventCenter:addEventListener(tx.eventNames.PRIVATE_CREAT_RESULT, handler(self, self.handleCreateRoom_))
    -- 房间查找
    self.handlerSearchRoomId_ = sa.EventCenter:addEventListener(tx.eventNames.SEARCH_ROOM_RESULT, handler(self, self.handleSearchRoom_))
    -- 其他进入房间
    self.enterRoomWithDataId_ = sa.EventCenter:addEventListener(tx.eventNames.ENTER_ROOM_WITH_DATA,handler(self, self.handleEnterRoomWithData_))
    -- 玩家支付信息变化
    self.payInfoChangeId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_INFO_CHANGE,handler(self, self.updateShopIcon_))
    -- 玩家资产变化  动画播放
    self.propertyChangeId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PROPERTY_CHANGE,handler(self, self.onPlayPropertyChangeAnim))
    -- 录音结束
    self.recordVoiceEnd_ = sa.EventCenter:addEventListener("RECORD_VOICE_COMPLETE",handler(self, self.onRecordVoiceEnd))

    --报名过程中不能点击其他按钮报名
    self.regStatusChangeId_ = sa.EventCenter:addEventListener("MATCH_REG_STATUS_CHANGE", handler(self, self.onRegStatusChange_))
end

function GameHallScene:__removeSocketEvt__()
    sa.HttpService.CANCEL(self.quickStartId_)
    if not self.loginRoomFailListenerId_ then
        return;
    end
    sa.EventCenter:removeEventListener(self.loginRoomFailListenerId_)
    sa.EventCenter:removeEventListener(self.serverStopListenerId_)
    sa.EventCenter:removeEventListener(self.loginRoomSuccListenerId_)
    sa.EventCenter:removeEventListener(self.logoutByMsg_)
    sa.EventCenter:removeEventListener(self.svrErrorListenerId_)
    sa.EventCenter:removeEventListener(self.matchStartLoginId_)
    sa.EventCenter:removeEventListener(self.loginMatchRoomFailId_)
    sa.EventCenter:removeEventListener(self.loginMatchRoomSuccId_)
    sa.EventCenter:removeEventListener(self.matchSvrErrorId_)
    sa.EventCenter:removeEventListener(self.loginHallSvrSuccId_)
    sa.EventCenter:removeEventListener(self.loginMatchHallSvrSuccId_)
    sa.EventCenter:removeEventListener(self.handleLogoutSuccId_)
    sa.EventCenter:removeEventListener(self.handlerCreateRoomId_)
    sa.EventCenter:removeEventListener(self.handlerSearchRoomId_)
    sa.EventCenter:removeEventListener(self.enterRoomWithDataId_)
    sa.EventCenter:removeEventListener(self.payInfoChangeId_)
    sa.EventCenter:removeEventListener(self.propertyChangeId_)
    sa.EventCenter:removeEventListener(self.recordVoiceEnd_)
    sa.EventCenter:removeEventListener(self.regStatusChangeId_)
end

-----------切后台相关-----------
function GameHallScene:onEnterBackground()
end
function GameHallScene:onEnterForeground(startType)
    self:parsePushData()
end
function GameHallScene:parsePushData()
    if tx.Push then
        self.pushData = nil
        local pushData = tx.Push:getPushData()
        self.pushData = json.decode(pushData) -- 推送数据
        if self.pushData and type(self.pushData)=="table" then
            for k,v in pairs(self.pushData) do
                local value = tonumber(v)
                if value then
                    self.pushData[k] = value
                end
            end
        elseif pushData and string.len(pushData)>0 then -- 查找字符串
            --手贱 多个了？号....  lang=th?type=1
            local askSymbol = "?"
            if string.find(pushData,askSymbol) then
                local arr=string.split(pushData,askSymbol)
                pushData = arr[2]
            end
            
            self.pushData = {}
            -- 深度链接参数
            local uriSymbol = "&"  --连接号
            local equalSymbol = "=" --等于号
            local keyValueList = string.split(pushData,uriSymbol)
            local oneKeyValue = nil
            for k,v in pairs(keyValueList) do
                oneKeyValue = string.split(v,equalSymbol)
                if oneKeyValue and #oneKeyValue==2 then
                    self.pushData[oneKeyValue[1]] = tonumber(oneKeyValue[2]) or oneKeyValue[2]
                end
            end
        end
        self:checkPushData()
    end
end
function GameHallScene:checkPushData(data,delay)
    local pushData = data or self.pushData
    if pushData and tx.userData then
        if type(pushData)=="table" then
            -- 邀请玩牌
            if pushData.type==consts.PUSH_TYPE.PUSH_INVITE_PLAY then
                if pushData.tid and pushData.gameId then
                    if tx.socket.HallSocket:isLogin() then
                        local info = pushData
                        local roomData = {serverGameid = info.gameId, serverLevel = info.gameLevel, serverTid = info.tid, pwd = info.pwd}
                        sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = roomData, isTrace = false})
                        self.pushData = nil
                    end
                end
            elseif pushData.type==consts.PUSH_TYPE.INVITE_CODE or pushData.type==consts.PUSH_TYPE.EXCHANGE_CODE then
                if self.controller_ and self.controller_.showExchangeCodePop then  -- 队列弹出
                    self.controller_:showExchangeCodePop(pushData.code)
                else
                    local ExchangeCodePopup = require("app.module.exchangecode.ExchangeCodePopup")
                    ExchangeCodePopup.new(pushData.code,2):showPanel()
                end
                self.pushData = nil
            elseif pushData.type==consts.PUSH_TYPE.LUCKTURN then
                local showLuckTurnFun = function(value)
                    display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
                        local LuckturnPopup = require("app.module.luckturn.LuckturnPopup")
                        local luckturn_ = LuckturnPopup.new()
                        if value then
                            luckturn_:setCloseCallback(handler(self.controller_, self.controller_.checkPendingPupop)):showPanel()
                            self.controller_.showPendingPopup = true
                        else
                            luckturn_:showPanel()
                        end
                    end)
                end
                if self.controller_ and self.controller_.checkPendingPupop and self.controller_.PendingPopup then
                    table.insert(self.controller_.PendingPopup, function()
                        showLuckTurnFun(true)
                    end)
                    if not self.controller_.showPendingPopup then
                        self.controller_:checkPendingPupop()
                    end
                else
                    showLuckTurnFun(false)
                end
                self.pushData = nil
            end
        end
    end
end

return GameHallScene