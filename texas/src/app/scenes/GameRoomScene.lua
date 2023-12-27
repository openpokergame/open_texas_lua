-- 所有游戏房间场景基类,主要添加socket回调逻辑
local GameRoomScene = class("GameRoomScene", function()
    return display.newScene("GameRoomScene")
end)

local HallController = import("app.module.hall.HallController")
local FirstPayButton = require("app.module.firstpay.FirstPayButton")
local RoomViewPosition = import("app.games.texas.room.views.RoomViewPosition")

--房间内桌子资源index
local ROOM_IMG_INDEX = {
    [131] = 1,
    [132] = 1,
    [133] = 2,
    [134] = 2,

    [231] = 3,
    [232] = 3,
    [233] = 4,
    [234] = 4,

    [501] = 3,
    [502] = 3,
    [503] = 4,
    [504] = 4,
}

function GameRoomScene:ctor(gameId)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    tx.socket.HallSocket.isInMatch = false
    tx.socket.HallSocket.isInRoom = true
	self:setNodeEventEnabled(true)
	self.gameId = gameId or -1  --当前游戏ID
    _G.curInGameId = self.gameId --全局的gameID
    if tx.userData then
        tx.userData.lastGameOverMoney = nil
    end
end

-- 创建房间背景
function GameRoomScene:createRoomBg_()
    local index = self:getImageIndex_()
    local img = "img/room_bg_" .. index .. ".jpg"

    local bg = display.newSprite(img)
        :scale(tx.bgScale)
        :pos(display.cx, display.cy)
        :addTo(self.nodes.backgroundNode)

    self.imageIndex_ = index
end

-- 创建房间桌子
function GameRoomScene:createRoomTable_()
    local tableNode = display.newNode():addTo(self.nodes.backgroundNode)
    local index = self:getImageIndex_()
    local img = "img/room_table_" .. index .. ".png"

    display.newSprite(img)
        :align(display.RIGHT_TOP, display.cx, RoomViewPosition.TablePosition.y)
        :addTo(tableNode)

    display.newSprite(img)
        :align(display.RIGHT_TOP, display.cx, RoomViewPosition.TablePosition.y)
        :addTo(tableNode)
        :setScaleX(-1)

    display.newSprite("#texas/room/super_poker.png")
        :pos(display.cx, RoomViewPosition.TablePosition.y - 215)
        :addTo(tableNode)
end

function GameRoomScene:getImageIndex_()
    local curGameLevel = tx.socket.HallSocket.curGameLevel or 6 --新手教程没有level
    local level = curGameLevel % 10
    local index = 1
    if ROOM_IMG_INDEX[curGameLevel] then
        index = ROOM_IMG_INDEX[curGameLevel]
    elseif level == 1 or level == 2 then
        index = 1
    elseif curGameLevel == tx.config.TEXAS_PRI_ROOM_LEVEL or level == 3 or level == 4 then
        index = 2
    elseif level == 5 then
        index = 3
    elseif level == 6 then
        index = 4
    end

    return index
end

-- 获取新房间流程，选场或者快速开始最终调用这个接口（当房间链接断开时走的是大厅）
function GameRoomScene:getNewRoom(msg)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    msg = msg or sa.LangUtil.getText("ROOM", "CHANGING_ROOM_MSG")
    self.roomLoading_ = tx.ui.RoomLoading.new(msg)
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    tx.socket.HallSocket:sendEnterGame({gameLevel=tx.socket.HallSocket.curGameLevel,gameId=tx.socket.HallSocket.curGameId})
end

--获取新房间流程，房间内换房间
function GameRoomScene:getNewRoom2_(msg)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "CHANGING_ROOM_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    tx.socket.HallSocket:changeGameRoom()
end

--房间内坐下失败(钱不够等原因)，重新获取房间数据
function GameRoomScene:changeRoomFromQuickStart(param)
    if self.isSendingQuickStart_ then return; end
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    self:requestOutRoom()

    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "CHANGING_ROOM_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    self.isSendingQuickStart_ = true
    sa.HttpService.CANCEL(self.quickStartId_)
    self.quickStartId_ = sa.HttpService.POST(
        {
            mod = "Quickstart",
            act = "qstart",
        },
        function (data)
            self.isSendingQuickStart_ = nil
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                tx.socket.HallSocket.curGameLevel = retData.level
                tx.socket.HallSocket.curGameId = retData.gameid
                if retData.tid and tonumber(retData.tid)>0 then
                    local roomData = {serverGameid = retData.gameid, serverLevel = retData.level, serverTid = retData.tid}
                    sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = roomData})
                else
                    self:getNewRoom()
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

--退出房间
function GameRoomScene:doBackToHall(msg)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    msg = msg or sa.LangUtil.getText("ROOM", "OUT_MSG")
    self.roomLoading_ = tx.ui.RoomLoading.new(msg)
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    -- 进入大厅
    if _G.From_Hall_Type==1 or not self.gameId or self.gameId<=0 then
        app:enterMainHall({HallController.MAIN_HALL_VIEW})
    else
        app:enterGameHall(self.gameId)
    end
end

--登录房间失败
function GameRoomScene:onLoginRoomFail_(evt)
	if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    if not evt or not evt.silent then
        tx.ui.Dialog.new({
            hasCloseButton = false,
            messageText = sa.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"),
            secondBtnText = sa.LangUtil.getText("COMMON", "RETRY"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                  	self:getNewRoom(sa.LangUtil.getText("ROOM", "RECONNECT_MSG"))
                elseif type == tx.ui.Dialog.FIRST_BTN_CLICK or type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                    self:doBackToHall()
                end
            end
        }):show()
    end
end

--停服提示
function GameRoomScene:onServerStop_(evt)
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

--登录房间成功
function GameRoomScene:onLoginRoomSucc_(evt)
	if self.gameId==tx.socket.HallSocket.gameId then
		if self.roomLoading_ then
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
	else  -- 进入其他游戏场景
        self.unDispose = true
        evt:stop()
		app:enterGameRoom(tx.socket.HallSocket.gameId)
	end
end

--重复登录
function GameRoomScene:doubleLoginOut_(evt)
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

--服务器连接失败
function GameRoomScene:onServerFail_(evt)
    -- --连接失败
    -- if evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE then

    -- --心跳包超时
    -- elseif evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT then

    -- --登录超时
    -- elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then
        
    -- --未连接发送数据
    -- elseif evt.data == consts.SVR_ERROR.ERROR_SEND_NOT_CON then

    -- end
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    -- 这种状态自己回去连接
    if evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT or 
        evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE or 
        evt.data == consts.SVR_ERROR.ERROR_SEND_NOT_CON then
        tx.ui.Dialog.new({
            hasCloseButton = false,
            closeWhenTouchModel = false,
            messageText = sa.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"),
            secondBtnText = sa.LangUtil.getText("COMMON", "RETRY"),
            firstBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
                        :pos(display.cx, display.cy)
                        :addTo(self, 100)
                    tx.socket.HallSocket:disconnect()
                    local ip, port = string.match(tx.userData.HallServer[1], "([%d%.]+):(%d+)")
                    tx.socket.HallSocket:connectDirect(ip, port, false) -- 不能自动重连 必须要显示 否则失败了没有事件出来
                elseif type == tx.ui.Dialog.FIRST_BTN_CLICK or type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
                        :pos(display.cx, display.cy)
                        :addTo(self, 100)
                    app:enterMainHall({HallController.MAIN_HALL_VIEW})
                end
            end
        }):show()
    elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then
        
    end
end

-- 提示比赛开始，是否要退出当前玩牌
function GameRoomScene:onMatchStartLogin_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    tx.ui.Dialog.new({
        messageText = sa.LangUtil.getText("MATCH", "JOINMATCHTIPS"),
        callback = function (type)
            if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                -- 退出当前房间
                self:requestOutRoom()
                -- loading
                local msg = sa.LangUtil.getText("ROOM", "ENTERING_MSG")
                self.roomLoading_ = tx.ui.RoomLoading.new(msg)
                    :pos(display.cx, display.cy)
                    :addTo(self, 100)
                local pack=evt.data
                tx.matchProxy:sendEnterMatch(pack.level,pack.matchid)
            elseif type == tx.ui.Dialog.FIRST_BTN_CLICK or type == tx.ui.Dialog.CLOSE_BTN_CLICK then
                -- self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
                --     :pos(display.cx, display.cy)
                --     :addTo(self, 100)
                -- app:enterMainHall({HallController.MAIN_HALL_VIEW})
            end
        end
    }):show()
end

--登录比赛房间失败
function GameRoomScene:onLoginMatchRoomFail_(evt)
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    -- 提示
    tx.ui.Dialog.new({
        closeWhenTouchModel = true,
        messageText = sa.LangUtil.getText("MATCH", "JOIN_MATCH_FAIL"),
        callback = function (type)

        end
    }):show()
end

--登录比赛房间成功
function GameRoomScene:onLoginMatchRoomSucc_(evt)
    self.unDispose = true
    evt:stop()
    app:enterGameRoom(tx.socket.MatchSocket.gameId)
end

function GameRoomScene:onMatchServerFail_(evt)
end

--登录大厅成功
function GameRoomScene:onLoginHallSvrSucc_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    local msg = sa.LangUtil.getText("ROOM", "RECONNECT_MSG")
    self.roomLoading_ = tx.ui.RoomLoading.new(msg)
        :pos(display.cx, display.cy)
        :addTo(self, 100)

    local pack = evt.data
    if pack and pack.tid and pack.tid>0 then   -- 在GameSocket自动去请求连接

    else  -- 否则默认重新去获取新房间 || 当前房间
        if self.ctx and self.ctx.model and self.ctx.model.reset then
            self.ctx.model:reset()
        end
        if tx.socket.HallSocket.curTid then
            tx.socket.HallSocket:sendEnterGame({gameLevel=tx.socket.HallSocket.curGameLevel,gameId=tx.socket.HallSocket.curGameId,prevTid=tx.socket.HallSocket.curTid})
        else
            self:doBackToHall()
        end
    end
end

function GameRoomScene:onLoginMatchHallSvrSucc_(evt)
end

--大厅登出成功
function GameRoomScene:handleLogoutSucc_(evt)
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "OUT_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    app:enterMainHall({HallController.LOGIN_GAME_VIEW, "logout"})
end

function GameRoomScene:handleEnterRoomWithData_(evt)
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    local data = evt.data
    if not data or not data.serverGameid or not data.serverTid or tonumber(data.serverGameid)<1 or tonumber(data.serverTid)<1 then
        return
    end
    self:requestOutRoom()  -- 必须登出当前房间
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "CHANGING_ROOM_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)
    -- 避免当前房间还未退出 因为两个房间是不同的gameserver 异步处理
    tx.schedulerPool:delayCall(function()
        if data.serverLevel then--快速进入
            
            tx.socket.HallSocket:fastEnterRoom(data.serverGameid,data.serverLevel,data.serverTid,data.pwd)
        else--验证桌子 获取serverLevel
            tx.socket.HallSocket:searchRoom(data.serverGameid,data.serverTid,data.pwd)
        end
    end, 0.3)
end

function GameRoomScene:requestOutRoom()
end

function GameRoomScene:onMenuClick_()
end

-- 坐下失败处理
function GameRoomScene:sitFailHandler(min)
    if tx.userData.money < tx.userData.limitMin then
        self:sitFailHandler_(tx.userData.limitMin)
    elseif min and min>0 then
        self:sitFailHandler_(min)
    else  --快速开始
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("ROOM", "SIT_DOWN_NOT_ENOUGH_MONEY"), 
            firstBtnText = sa.LangUtil.getText("ROOM", "AUTO_CHANGE_ROOM"),
            secondBtnText = sa.LangUtil.getText("ROOM", "CHARGE_CHIPS"), 
            callback = function (type)
                if type == tx.ui.Dialog.FIRST_BTN_CLICK then
                    self:changeRoomFromQuickStart()
                elseif type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    self:openStore()
                end
            end
        }):show()
    end
end

function GameRoomScene:sitFailHandler_(chips)
    tx.ui.Dialog.new({
        messageText = sa.LangUtil.getText("COMMON", "NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG", sa.formatBigNumber(chips)), 
        callback = function (type)
            if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                self:openStore()
            end
        end
    }):show()
end

function GameRoomScene:updateShopIcon_(evt)
    local goods = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
    if goods and goods.gid then
        local now = os.time()
        if (now-goods.clientTime)>=tonumber(goods.countdown) then
            tx.userData.payinfo.brokesalegoods = nil
        end
    end
end

-- 处理商城显示
function GameRoomScene:dealShopShow(shopBtn,offX,offY)
    if not shopBtn or not shopBtn:getParent() then return; end
    if not offX then offX=0 end
    if not offY then offY=0 end
    local xx,yy = shopBtn:getPosition()
    xx = xx
    yy = yy
    local parent_ = shopBtn:getParent()
    shopBtn:hide()
    if self.firstPayBtn_ then
        self.firstPayBtn_:hide()
    end

    if not self.discountTips_ then
        local DiscountTips = require("app.pokerUI.DiscountTips")
        self.discountTips_ = DiscountTips.new()
            :pos(xx-45+offX,yy+20+offY)
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

function GameRoomScene:showDiscount_(data)
    local time = tonumber(data.countdown) - (os.time()-data.clientTime)
    self.discountTips_:setInfo(time,"+"..data.sale.."%")
end

function GameRoomScene:onPlayPropertyChangeAnim(evt)
end

function GameRoomScene:playPropertyChangeAnim_(data, x, y)
    for k, v in pairs(data) do
        if k=="money" then
            app:tip(1, v, x, y)
        elseif k=="diamonds" then
            app:tip(2, v, x, y)
        elseif k=="props" then
            app:tip(3, v, x, y)
        elseif k=="exp" then
            app:tip(4, v, x, y)
        elseif k=="speakers" then
            app:tip(5, v, x, y)
        end
    end
end

--语音聊天
function GameRoomScene:checkPlayVoice(pack)
    if tx.VoiceSDK and tx.VoiceSDK.isPlaying then--正在播放另一个录音
        if not self.cacheVoicePack_ then self.cacheVoicePack_ = {} end
        table.insert(self.cacheVoicePack_,pack)
        return false
    end
    return true
end
-- 历史聊天记录  url为语音聊天
function GameRoomScene:setLatestChatMsg(nick, msg, id, url)
    local chatHistory = sa.DataProxy:getData(tx.dataKeys.ROOM_CHAT_HISTORY)
    if not chatHistory then
        chatHistory = {}
    end
    local msg1 = sa.LangUtil.getText("ROOM", "CHAT_FORMAT", nick or "", msg or "")
    chatHistory[#chatHistory + 1] = {messageContent = msg1, time = sa.getTime(), mtype = 2, id = id, url = url}
    -- 最多50条
    if #chatHistory>50 then
        while(true) do
            table.remove(chatHistory,1)
            if #chatHistory<=50 then
                break;
            end
        end
    end
    sa.DataProxy:setData(tx.dataKeys.ROOM_CHAT_HISTORY, chatHistory)
end
--录制语音结束
function GameRoomScene:onRecordVoiceEnd(evt)
    local data = evt.data
    -- 记录聊天 自己？
    -- 发送出去
    tx.socket.HallSocket:sendVoice(data)
end
--播放语音结束 检测缓存中有没有 同时只能播放一个哦
function GameRoomScene:onPlayVoiceEnd(evt)
    if self.cacheVoicePack_ and #self.cacheVoicePack_>0 and self.controller and self.controller.processPacket_ then
        -- 延迟一点是因为动画也会监听PLAY_VOICE_COMPLETE事件，在某些手机上会只有声音，没有动画展示
        tx.schedulerPool:delayCall(function()
            local pack = table.remove(self.cacheVoicePack_, 1)
            self.controller:processPacket_(pack)
        end,0.2)
    end
end

function GameRoomScene:addMicrophoneBtn(x,y,parent)
    if not tx.VoiceSDK or not tx.VoiceSDK.open then return; end
    if not self.microphoneBtn_ then
        self.microphoneBtn_ = display.newSprite("#common/microphone_btn.png")
            :pos(x,y)
            :addTo(parent)
        ImgButton(self.microphoneBtn_,"#common/microphone_btn.png","#common/microphone_btn_down.png")
            :onButtonPressed(function(evt)
                self.microphoneBtn_:stopAllActions()
                self.microphoneBtn_:setOpacity(255)
                self.microphoneBtn_:runAction(
                    cc.RepeatForever:create(
                        transition.sequence({
                            cc.DelayTime:create(0.2),
                            cc.FadeTo:create(0.4, 100),
                            cc.DelayTime:create(0.2),
                            cc.FadeTo:create(0.4, 255),
                    })))
                self.microphoneIsTouching_ = true
                self.microphoneTouchY_ = evt.y
                tx.VoiceSDK:startRecordVoice()
            end)
            :onButtonMove(function(evt)
                if self.microphoneIsTouching_ then
                    local y = evt.y
                    if y<self.microphoneTouchY_ then --往下移动
                        self.microphoneTouchY_ = y
                        return
                    end
                    if y-self.microphoneTouchY_>40 then
                        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_CANCELED"))
                        self.microphoneBtn_:stopAllActions()
                        self.microphoneBtn_:setOpacity(255)
                        self.microphoneIsTouching_ = nil
                        tx.voiceRecordAnim:hide()
                        tx.VoiceSDK:cancelRecordedVoice()
                    end
                end
            end)
            :onButtonRelease(function(evt)
                self.microphoneBtn_:stopAllActions()
                self.microphoneBtn_:setOpacity(255)
                tx.voiceRecordAnim:hide()
                tx.VoiceSDK:stopRecordVoice()
                self.microphoneIsTouching_ = nil
            end)
    end
    self.microphoneBtn_:pos(x,y)
end

function GameRoomScene:onBrokeShow(param)
    tx.PayGuideManager:userCrashGuide(param or {})
end

function GameRoomScene:openStore()
    tx.PayGuideManager:quickPayGuide()
end

function GameRoomScene:showQuickPayPopup()
    local blind = 50
    if self.ctx.model and self.ctx.model.roomInfo then
        blind = self.ctx.model.roomInfo.blind
    end

    local RoomQuickPayPopup = require("app.module.payguide.quickpay.RoomQuickPayPopup")
    RoomQuickPayPopup.new(self.gameId, blind):showPanel()
end

function GameRoomScene:showFirstPayPopup()
end

--------------------------Node事件-------------------------
-- 子类必须调用
function GameRoomScene:onEnter()
    self:__addSocketEvt__()
    tx.socket.HallSocket:resume()
    tx.socket.MatchSocket:resume()
    --清空房间聊天记录
    sa.DataProxy:clearData(tx.dataKeys.ROOM_CHAT_HISTORY)
end

function GameRoomScene:onEnterTransitionFinish()
    -- Android的右键和菜单事件
    if device.platform == "android" and not self.virtualKeyLayer_ then
        self.virtualKeyLayer_ = display.newLayer()
        self.virtualKeyLayer_:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
            if event.key == "back" then
                if not tx.PopupManager:removeTopPopupIf() then
                    self:onMenuClick_()
                end
            elseif event.key == "menu" then
                self:onMenuClick_()
            end
        end)
        self.virtualKeyLayer_:setKeypadEnabled(true)
        self:addChild(self.virtualKeyLayer_,-1)
    end
    self.unDispose = nil
end

-- 子类必须调用
function GameRoomScene:onExitTransitionStart()
    self:__removeSocketEvt__()
    -- tx.socket.HallSocket:pause()
    -- tx.socket.MatchSocket:pause() 
end

function GameRoomScene:onExit()
    --清空房间聊天记录
    sa.DataProxy:clearData(tx.dataKeys.ROOM_CHAT_HISTORY)
    --清空不用的资源
    tx.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

-- 子类必须调用 
function GameRoomScene:onCleanup(notReleaseRes)
	self:__removeSocketEvt__()
    if not notReleaseRes then
        local releaseList = app.GAMES[self.gameId] and app.GAMES[self.gameId].roomtex
        if releaseList then
            for k,v in pairs(releaseList) do
                display.removeSpriteFramesWithFile(v[1], v[2])
            end
        end
    end
end

function GameRoomScene:__addSocketEvt__()
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
    -- 其他进入房间
    self.enterRoomWithDataId_ = sa.EventCenter:addEventListener(tx.eventNames.ENTER_ROOM_WITH_DATA,handler(self, self.handleEnterRoomWithData_))
    -- 玩家支付信息变化
    self.payInfoChangeId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_INFO_CHANGE,handler(self, self.updateShopIcon_))
    -- 玩家资产变化  动画播放
    self.propertyChangeId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PROPERTY_CHANGE,handler(self, self.onPlayPropertyChangeAnim))
    -- 录音结束
    self.recordVoiceEnd_ = sa.EventCenter:addEventListener("RECORD_VOICE_COMPLETE",handler(self, self.onRecordVoiceEnd))
    -- 播放录音完毕
    self.playVoiceEnd_ = sa.EventCenter:addEventListener("PLAY_VOICE_COMPLETE",handler(self, self.onPlayVoiceEnd))
end

function GameRoomScene:__removeSocketEvt__()
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
    sa.EventCenter:removeEventListener(self.enterRoomWithDataId_)
    sa.EventCenter:removeEventListener(self.payInfoChangeId_)
    sa.EventCenter:removeEventListener(self.propertyChangeId_)
    sa.EventCenter:removeEventListener(self.recordVoiceEnd_)
    sa.EventCenter:removeEventListener(self.playVoiceEnd_)
end

-----------切后台相关-----------
function GameRoomScene:onEnterBackground()
end
function GameRoomScene:onEnterForeground(startType)
    self:parsePushData()
end
function GameRoomScene:parsePushData()
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
function GameRoomScene:checkPushData(data,delay)
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
                local ExchangeCodePopup = require("app.module.exchangecode.ExchangeCodePopup")
                ExchangeCodePopup.new(pushData.code,2):showPanel()
                self.pushData = nil
            elseif pushData.type==consts.PUSH_TYPE.LUCKTURN then
                display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
                    local LuckturnPopup = require("app.module.luckturn.LuckturnPopup")
                    LuckturnPopup.new():showPanel()
                end)
                self.pushData = nil
            end
        end
    end
end

return GameRoomScene