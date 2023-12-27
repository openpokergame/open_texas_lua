local HallController        = import("app.module.hall.HallController")
local P = import(".net.PROTOCOL")
local GameRoomScene         = import("app.scenes.GameRoomScene")
local RoomController        = import(".room.RoomController")
local RoomViewPosition      = import("app.games.texas.room.views.RoomViewPosition")
local RoomMenuPopup         = import("app.games.texas.room.views.RoomMenuPopup")
local CardTypePopup         = import("app.games.texas.room.views.CardTypePopup")
local PopupRoomDetail       = import("app.module.match.views.PopupRoomDetail")
local RichText = import("openpoker.ui.RichText")

local MatchRoomScene = class("MatchRoomScene", GameRoomScene)
local logger = sa.Logger.new("MatchRoomScene")

MatchRoomScene.EVT_BACKGROUND_CLICK = "EVT_BACKGROUND_CLICK"

function MatchRoomScene:ctor()
    MatchRoomScene.super.ctor(self,P.GAMEID)
    RoomViewPosition.setTexas()

    self:initData_()
    self:createNodes_()
    self:createRoomBg_()
    self:createRoomTable_()

    -- 房间总控
    self.controller = RoomController.new(self)
    self.ctx = self.controller.ctx

    -- 房间信息 (初级场 前注)
    self.roomInfo_ = ui.newTTFLabel({size=26, text="", color=cc.c3b(0x0, 0x0, 0x0)})
        :pos(display.cx, RoomViewPosition.TablePosition.y-300)
        :opacity(40)
        :addTo(self.nodes.backgroundNode)

    -- self.playerNumTips_ = ui.newTTFLabel({size=30, text=""})
    --     :pos(display.cx, RoomViewPosition.TablePosition.y-115)
    --     :addTo(self.nodes.backgroundNode)
    --     :hide()

    self.playerNumTips_ = RichText.new()
        :addElementText({text = sa.LangUtil.getText("MATCH","PLAYER_NUM_TIPS_1"), fontSize = 30})
        :addChangeElementText({color = cc.c3b(0xff, 0xe3, 0x62), text = "", fontSize = 30})
        :addElementText({text = sa.LangUtil.getText("MATCH","PLAYER_NUM_TIPS_2"), fontSize = 30})
        :pos(display.cx, RoomViewPosition.TablePosition.y-115)
        :addTo(self.nodes.backgroundNode)
        :hide()
        

    -- 顶部操作栏
    local marginLeft = 32
    local marginTop = -40

    -- 菜单按钮
    local menuPosX = marginLeft + 10
    local menuPosY = marginTop
    self.menuBtn_ = cc.ui.UIPushButton.new({normal = {"#commonroom/menu.png"},pressed = {"#commonroom/menu_down.png"}})
        :onButtonClicked(buttontHandler(self, self.onMenuClick_))
        :pos(menuPosX, menuPosY)
        :addTo(self.topNode_)

    self:createAddBlindTips_()

    -- 牌型按钮
    self:addCardTypeButton_()

    self:addMicrophoneBtn(display.right-50, display.bottom+155,self.nodes.lampNode)
    -- 创建其他元素
    self.controller:createNodes()
    self.controller:changeDealer(4)

    self:addPropertyObservers()
end

function MatchRoomScene:initData_()
    tx.socket.HallSocket.isInMatch = true
    tx.userData.isMatchLook = false --是否在旁观
    tx.userData.isMatchEnd = false --是否比赛结束
end

--涨盲提示
function MatchRoomScene:createAddBlindTips_()
    local w, h = 300, 80
    local frame = display.newScale9Sprite("#match/room/match_blind_tips_bg.png", 0, 0, cc.size(w, h))
        :align(display.RIGHT_CENTER, display.right - 55, -h/2)
        :addTo(self.topNode_)

    cc.ui.UIPushButton.new({normal="#match/room/match_ranking_btn_normal.png", pressed="#match/room/match_ranking_btn_pressed.png"}, {scale9 = true})
        :onButtonClicked(buttontHandler(self, self.onMatchInfoClicked_))
        :pos(w, h/2)
        :addTo(frame)

    self.rankingLabel_ = ui.newBMFontLabel({text = "1", font = "fonts/match_ranking.fnt"})
        :pos(w, h/2)
        :addTo(frame)

    self.avgChipLabel_ = ui.newTTFLabel({size=22, text=""})
        :align(display.LEFT_CENTER, 5, 55)
        :addTo(frame)

    self.blindTimeLabel_ = ui.newTTFLabel({size=22, text=""})
        :align(display.LEFT_CENTER, 5, 20)
        :addTo(frame)
        :hide()

    self.addBlindTips_ = ui.newTTFLabel({size=22, text=""})
        :align(display.LEFT_CENTER, 5, 20)
        :addTo(frame)
end

function MatchRoomScene:onMatchInfoClicked_()
    local curMatchLevel = tx.matchProxy:getCurMatchLevel()
    if self.roomData_ then
        self.roomData_.blindTime = self.blindTime_
    end

    PopupRoomDetail.new(curMatchLevel, self.roomData_):showPanel()
end

function MatchRoomScene:updateRankingInfo(rankList, count)
    local curRank = 1
    local roomData = {}
    for _, v in ipairs(rankList) do
        if tx.userData.uid == v.uid then
            curRank = v.rank
            break
        end
    end

    local rankArr = {}
    table.sort(rankList, function(a, b)
        return a.rank < b.rank
    end)
    for i, v in ipairs(rankList) do
        local data = {}
        local info = json.decode(v.info)
        data.name = info.nick
        data.img = info.img
        data.chip = v.money
        data.rank = v.rank

        rankArr[i] = data
    end

    roomData.curRank = curRank
    roomData.rankList = rankArr
    roomData.curCount = count
    roomData.avgChip = self.avgChip_
    roomData.curBlindLevel = self.curBlindLevel_

    self.roomData_ = roomData

    self.rankingLabel_:setString(curRank)

    self.avgChipLabel_:show():setString(sa.LangUtil.getText("MATCH", "SNG_RANKING_INFO", self.avgChip_))
end

--未开赛前涨盲提示
function MatchRoomScene:initBlindTips()
    self.addBlindTips_:show():setString(sa.LangUtil.getText("MATCH", "WAIT_MATCH"))
end

--涨盲时间
function MatchRoomScene:updateBlindTime(data)
    self.avgChip_ = data.avgChip
    self.blindTime_ = data.leftTime
    self.curBlindLevel_ = data.times + 1
    self.blindTimeLabel_:stopAllActions()
    self.blindTimeLabel_:setString(sa.LangUtil.getText("MATCH", "ADD_BLIND_TIME", sa.TimeUtil:getTimeString(self.blindTime_)))
    self.blindTimeLabel_:schedule(function()
        self.blindTime_ = self.blindTime_ - 1
        if self.blindTime_ <= 0 then
            self.blindTimeLabel_:stopAllActions()
        end
        local str = sa.TimeUtil:getTimeString(self.blindTime_)
        self.blindTimeLabel_:setString(sa.LangUtil.getText("MATCH", "ADD_BLIND_TIME", str))
    end, 1)
end

function MatchRoomScene:stopBlindTime()
    self.blindTimeLabel_:stopAllActions()
    self.blindTimeLabel_:hide()
    self.avgChipLabel_:hide()
end

--更新涨盲信息提示
function MatchRoomScene:updateBlindTips(isGameStart, blind)
    if isGameStart then
        self:updateTableBlind_(blind)
    else
        local curBlind = self.ctx.model.roomInfo.blind
        if curBlind == blind and self:isPlayingGame_() then
            self:updateTableBlind_(blind)
        elseif curBlind ~= blind and self:isPlayingGame_() then
            tx.HorseLamp:showTips(sa.LangUtil.getText("MATCH", "ADD_BLIND_TIPS_2", blind, blind*2),nil,true)
            self.blindTimeLabel_:hide()
            self.addBlindTips_:setString(sa.LangUtil.getText("MATCH", "ADD_BLIND_TIPS_1"))
        end
    end
end

function MatchRoomScene:updateTableBlind_(blind)
    self.blindTimeLabel_:show()
    self.addBlindTips_:hide()
    local roomInfo = self.ctx.model.roomInfo
    roomInfo.blind = blind
    self:setRoomInfoText(roomInfo)
end

--是否正在玩牌
function MatchRoomScene:isPlayingGame_()
    local gameStatus = self.ctx.model.gameInfo.gameStatus
    if gameStatus >= consts.SVR_GAME_STATUS.DEAL_CARD_ANI_2 and gameStatus < consts.SVR_GAME_STATUS.READY_TO_START then
        return true
    end
    return false
end

function MatchRoomScene:dealCardTypeWord(probValue)
    probValue = probValue or {}
    local orderList = {
        "RoyalFlush",
        "StraightFlush",
        "FourKind",
        "FullHouse",
        "Flush",
        "Straight",
        "Threekind",
        "TwoPairs",
        "OnePairs",
        "High",
    }
    local maxIndex = 1
    local maxValue = 0
    local curValue = nil
    for i=1,8,1 do
        curValue = tonumber(probValue[orderList[i]] or 0)
        if curValue>maxValue then
            maxValue=curValue
            maxIndex=i
        end
    end
    maxValue = math.floor(maxValue*100)
    if maxValue~=0 then
        self.cardRateBg_:show()
        self.cardTypeLabel_:setString(maxValue.."%")
    else
        self.cardRateBg_:hide()
    end
end

function MatchRoomScene:setRoomInfoText(roomInfo)
    local matchLevel = roomInfo.roomType
    local roomName = ""
    local config = tx.userData.sngTableConfig
    for _, v in ipairs(config) do
        if v.matchlevel == matchLevel then
            roomName = v.name
            break
        end
    end

    local info = sa.LangUtil.getText("MATCH", "ROOM_INFO", roomName, sa.formatBigNumber(roomInfo.blind), sa.formatBigNumber(roomInfo.blind * 2))
    self.roomInfo_:setString(info)

    self:setCardPowerStatus_()
end

--是否显示牌力指示器
function MatchRoomScene:setCardPowerStatus_()
    local isShow = false
    if tx.checkIsVip() then
        isShow = true
    end
    tx.userDefault:setBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, isShow)
end

function MatchRoomScene:updateHalloweenRoomProgress(isShow, info, reward)
    if tx.config.HALLOWEEN_ENABLED and self.halloween_room_node then 
        if isShow then 
            self.halloween_room_node:show()
            self.halloween_room_progress:setString(info)
            if reward and self.halloweenRoomLight then
                self.halloweenRoomLight:show()
                self.halloweenRoomLight:runAction(cc.RepeatForever:create(transition.sequence({
                    cc.RotateTo:create(1, 180),
                    cc.RotateTo:create(1, 360)
                })))
            else
                self.halloweenRoomLight:stopAllActions()
                self.halloweenRoomLight:hide()
            end
        else
            self.halloween_room_node:hide()
        end
    end
end

function MatchRoomScene:requestOutRoom()
    tx.socket.HallSocket:sendGameCmd("sendLogout")
end

function MatchRoomScene:doBackToHall(msg)    
    self:requestOutRoom()
    MatchRoomScene.super.doBackToHall(self,msg)
    tx.matchProxy:unCurReg()
end

function MatchRoomScene:onMenuClick_()
    RoomMenuPopup.new(self.ctx, {2,5}, 2):showPanel()
end

function MatchRoomScene:dealSitDownView()
    if self.ctx.model and self.ctx.model:isSelfInSeat() then
        if self.microphoneBtn_ then
            self.microphoneBtn_:show()
        end
    else
        if self.microphoneBtn_ then
            self.microphoneBtn_:hide()
        end
    end
end

function MatchRoomScene:onCardPower_(evt)
    if not self.cardPowerNode_ or not self.cardPowerStencil_ then
        return
    end
    local isCardPowerTips = tx.userDefault:getBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, true)
    if not isCardPowerTips then
        self.cardPowerNode_:hide()
        return
    end
    local ctx = self.ctx
    local model = ctx and ctx.model
    -- 各种判断
    if model and model:isSelfInGame() and model.gameInfo and model.gameInfo.dealCardNum and model.gameInfo.dealCardNum>1 and model.gameInfo.handCards
    and model.gameInfo.handCards[1] and model.gameInfo.handCards[1]>0 and  model.gameInfo.gameStatus<consts.SVR_GAME_STATUS.READY_TO_START then
        local powerValue = evt and evt.data and evt.data.power or 0
        self.cardPowerStencil_:stopAllActions()
        self.cardPowerStencil_:runAction(cc.MoveTo:create(0.5, cc.p(-self.cardPowerWidth_+self.cardPowerWidth_*powerValue/100, 0)))
        self.cardPowerNode_:show()
    else
        self.cardPowerNode_:hide()
    end
end
function MatchRoomScene:dealCardPower(needHide)
    local isCardPowerTips = tx.userDefault:getBoolForKey(tx.cookieKeys.CARD_POWER_TIPS, true)
    if needHide==false or isCardPowerTips==false then
        if self.cardPowerNode_ then
            self.cardPowerNode_:hide()
        end
        if self.cardPowerStencil_ and self.cardPowerWidth_ then
            self.cardPowerStencil_:setPositionX(-self.cardPowerWidth_)
        end
        return
    end
    if not self.cardPowerNode_ then
        local p = RoomViewPosition.DealCardPosition
        self.cardPowerNode_ = display.newNode()
            :pos(p[5].x+65, p[5].y-58)
            :addTo(self.nodes.seatNode)
            :hide()
        self.cardPowerBG_ = display.newSprite("#texas/room/card_power_bg.png")
            :addTo(self.cardPowerNode_)
        -- 添加到显示列表才能runAction...
        self.cardPowerStencil_ = display.newSprite("#texas/room/card_power_pro.png")
            :addTo(self.cardPowerNode_)
        self.cardPowerStencil_:setOpacity(0)
        self.cardPowerWidth_ = self.cardPowerStencil_:getContentSize().width
        self.cardPowerStencil_:setPositionX(-self.cardPowerWidth_)
        local clipNode = cc.ClippingNode:create()
            :addTo(self.cardPowerNode_)
        clipNode:setStencil(self.cardPowerStencil_)
        self.cardPowerSprite_ = display.newSprite("#texas/room/card_power_pro.png")
            :addTo(clipNode)
        self.cardPowerTouch_ = NormalButton(display.newScale9Sprite("#texas/room/card_power_pro.png", 0, 15, cc.size(self.cardPowerWidth_, 45)))
            :onButtonClicked(function()
                local CardPowerPopup = require("app.module.room.cardpower.CardPowerPopup")
                CardPowerPopup.new():showPanel()
            end)
            :addTo(self.cardPowerNode_)
        self.cardPowerTouch_:setOpacity(0) -- 透明
        self.cardPowerListenerId_ = sa.EventCenter:addEventListener("TEXAS_CARD_POWER", handler(self, self.onCardPower_))
    end
    local ctx = self.ctx
    local model = ctx and ctx.model
    -- 各种判断
    if model and model:isSelfInGame() and model.gameInfo and model.gameInfo.dealCardNum and model.gameInfo.dealCardNum>1 and
    model.gameInfo.handCards and model.gameInfo.handCards[1] and model.gameInfo.handCards[1]>0 then
        local num = model.gameInfo.dealCardNum
        local card1 = model.gameInfo.handCards[1]
        local card2 = model.gameInfo.handCards[2]
        local pubCards = model.gameInfo.pubCards or {}
        if not pubCards or #pubCards<1 then
            self.cardPowerNode_:hide()
        end
        tx.socket.HallSocket:getCardPower(num,card1,card2,pubCards)
    else
        self.cardPowerNode_:hide()
    end
end

-- 牌型按钮
function MatchRoomScene:addCardTypeButton_()
    local btn = cc.ui.UIPushButton.new({normal = "#commonroom/card.png",pressed = "#commonroom/card_down.png"})
        :onButtonClicked(buttontHandler(self, self.onCardTypeClick_))
        :pos(42, -display.height + 158)
        :addTo(self.topNode_, 1)

    self.cardRateBg_= display.newSprite("#commonroom/card_rate_tip.png")
        :pos(0,-27)
        :addTo(btn)

    self.cardTypeLabel_ = ui.newTTFLabel({size=20, text="", color=cc.c3b(0xff,0xe3,0x62)})
        :pos(40,18)
        :addTo(self.cardRateBg_)

    self.cardTypePopup_ = CardTypePopup.new(self.ctx.aysManager.probValue):addTo(self.nodes.popupNode)
end

function MatchRoomScene:onCardTypeClick_()
    if self.cardTypePopup_:isMoving() then
        return
    end

    self.cardTypePopup_:playShowAnimation()
end

function MatchRoomScene:createNodes_()
    self.nodes = {}
    self.nodes.backgroundNode = display.newNode():addTo(self, 1)
    self.nodes.dealerNode = display.newNode():addTo(self, 2)
    self.nodes.publicCardNode = display.newNode():addTo(self,3)
    self.nodes.seatNode = display.newNode():addTo(self, 4)
    self.nodes.chipNode = display.newNode():addTo(self, 5)
    self.nodes.dealCardNode = display.newNode():addTo(self, 6)
    self.nodes.lampNode = display.newNode():addTo(self, 7)
    self.nodes.oprNode = display.newNode():addTo(self, 8)
    self.nodes.animNode = display.newNode():addTo(self, 9)
    self.topNode_ = display.newNode():pos(display.left + 8, display.top - 8):addTo(self, 10)
    self.nodes.popupNode = display.newNode():addTo(self, 11)
    -- 顶层触摸 
    self.touchLayer = display.newLayer():addTo(self,12)
    self.backgroundTouchHelper_ = sa.TouchHelper.new(self.touchLayer, handler(self, self.onBackgroundTouch_))
    self.backgroundTouchHelper_:enableTouch()
    self.touchLayer:setTouchSwallowEnabled(false)
    -- self.backgroundTouchHelper_ = sa.TouchHelper.new(self.nodes.backgroundNode, handler(self, self.onBackgroundTouch_))
    -- self.backgroundTouchHelper_:enableTouch()
end

function MatchRoomScene:onCleanup()
    if self.cardPowerListenerId_ then
        sa.EventCenter:removeEventListener(self.cardPowerListenerId_)
    end
    MatchRoomScene.super.onCleanup(self,self.unDispose)
    -- 控制器清理
    self.controller:dispose()
    -- 移除事件
    self:removeAllEventListeners()
    self:removePropertyObservers()
end

function MatchRoomScene:onBackgroundTouch_(target, evt, isInSprite, touchData)
    if evt == sa.TouchHelper.CLICK then
        self:dispatchEvent({name=MatchRoomScene.EVT_BACKGROUND_CLICK})
    end
    if not evt or not touchData then return; end
    if evt==sa.TouchHelper.TOUCH_BEGIN then
        self.touchIsMoveX_ = nil
        self.touchIsMoveY_ = nil
        self.isInTouchArea_ = nil
        self.bgTouchLeft_ = nil
        self.bgTouchRight_ = nil
        self.bgTouchX_,self.bgTouchY_ = touchData.x,touchData.y
        if self.bgTouchX_<400 then
            local halfWidth = self.cardTypePopup_:getContentSize().width*0.5
            local xx = self.cardTypePopup_:getPositionX()
            if xx<(-halfWidth+30) then -- 缩进的
                if self.bgTouchX_<135 then
                    self.isInTouchArea_ = true
                    self.bgTouchLeft_ = true    
                end
            else -- 已经展开
                self.isInTouchArea_ = true
                self.bgTouchLeft_ = true
            end
        elseif self.bgTouchX_>display.width-550 then
            self.isInTouchArea_ = true
            self.bgTouchRight_ = true
            self.cardTypePopup_:playHideAnimation()
        else
            self.cardTypePopup_:playHideAnimation()
        end
    elseif evt==sa.TouchHelper.TOUCH_END or evt==sa.TouchHelper.CLICK then
        if self.touchIsMoveX_ and self.bgTouchOffsetX_ then
            if self.bgTouchRight_ then
                if self.bgTouchOffsetX_ > 0 then
                    -- self.slotPopup:playHideAnimation()
                elseif self.bgTouchOffsetX_ < 0 then
                    -- self.slotPopup:playShowAnimation()
                end
            elseif self.bgTouchLeft_ then
                if not self.dealedCardType_ then
                    if self.bgTouchOffsetX_ > 0 then
                        self.cardTypePopup_:playShowAnimation()
                    elseif self.bgTouchOffsetX_ < 0 then
                        self.cardTypePopup_:playHideAnimation()
                    end
                end
            end
        end
    elseif evt==sa.TouchHelper.TOUCH_MOVE then
        -- 第一次移动
        if self.isInTouchArea_ then
            local xx,yy = touchData.x,touchData.y
            if math.abs(xx-self.bgTouchX_)>30 then
                self.touchIsMoveX_ = true
            end
            if math.abs(yy-self.bgTouchY_)>10 then
                self.touchIsMoveY_ = true
            end
        end
        if self.touchIsMoveX_ then
            local offsetX = touchData.x - touchData.prevX
            if offsetX ~= 0 then
                self.bgTouchOffsetX_ = offsetX --只记录发生过位移，为了处理特殊情况，上次move发生了位移，这次为0，最终end的时候就不会收缩或者伸展
            end
            if self.bgTouchRight_ then
                -- self.slotPopup:setMovePositionX(offsetX)
            elseif self.bgTouchLeft_ then
                if not self.dealedCardType_ then
                    self.cardTypePopup_:setMovePositionX(offsetX)
                end
            end
        end
    end
end

function MatchRoomScene:addPropertyObservers()
end

function MatchRoomScene:removePropertyObservers()
end


-- 覆盖父类相关socket事件
function MatchRoomScene:onServerFail_(evt)
end

--登录比赛房间成功
function MatchRoomScene:onLoginMatchRoomSucc_(evt)
end

function MatchRoomScene:onLoginMatchRoomFail_(evt)
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    -- 提示
    tx.ui.Dialog.new({
        closeWhenTouchModel = false,
        hasCloseButton = false,
        hasFirstButton = false,
        messageText = sa.LangUtil.getText("MATCH", "JOIN_MATCH_FAIL"),
        secondBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
        callback = function (type)
            self:doBackToHall()
        end
    }):show()
end

function MatchRoomScene:onMatchServerFail_(evt)
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
                    tx.socket.MatchSocket:disconnect()
                    local ip, port = string.match(tx.userData.MatchServer[1], "([%d%.]+):(%d+)")
                    tx.socket.MatchSocket:connectDirect(ip, port, false)
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

function MatchRoomScene:onLoginHallSvrSucc_(evt)
end

function MatchRoomScene:onLoginMatchHallSvrSucc_(evt)
    local pack = evt.data
    if not pack or not pack.tid or pack.tid<1 then
        if self.roomLoading_ then 
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end
        self:matchEndTips()
    end
end

function MatchRoomScene:matchEndTips()
    tx.ui.Dialog.new({
        closeWhenTouchModel = false,
        hasCloseButton = false,
        hasFirstButton = false,
        messageText = sa.LangUtil.getText("MATCH", "MATCH_END_TIPS"),
        secondBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
        callback = function ()
            self:doBackToHall()
        end
    }):show()
end

function MatchRoomScene:onMatchStartLogin_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    local data = evt.data
    local curMatchLevel = tx.matchProxy:getCurMatchLevel()
    if curMatchLevel < 0 or data.level == curMatchLevel then
        local msg = sa.LangUtil.getText("ROOM", "ENTERING_MSG")
        self.roomLoading_ = tx.ui.RoomLoading.new(msg)
            :pos(display.cx, display.cy)
            :addTo(self, 100)
        local pack=evt.data
        tx.matchProxy:sendEnterMatch(pack.level,pack.matchid)
    else
        MatchRoomScene.super.onMatchStartLogin_(evt)
    end
end

function MatchRoomScene:updatePlayerNumTips()
    self.playerNumTips_:hide()
    local gameStatus = self.ctx.model.gameInfo.gameStatus
    if gameStatus ~= consts.SVR_GAME_STATUS.CAN_NOT_START then --不是等待状态说明牌局正在进行
        return
    end

    if self.ctx.model.matchBaseInfo then
        local curNum = self.ctx.model:getNumInSeat()
        local totalNum = self.ctx.model.matchBaseInfo.startMatchNum
        local num = totalNum - curNum
        if num > 0 then
            self.playerNumTips_:show():updateChangeElementText({num})
        end
    end
end

function MatchRoomScene:hidePlayerNumTips()
    self.playerNumTips_:hide()
end

return MatchRoomScene
