local GameRoomScene         = import("app.scenes.GameRoomScene")
local OmahaRoomScene        = class("OmahaRoomScene", GameRoomScene)

local RoomController        = import(".room.RoomController")
local RoomViewPosition      = import("app.games.texas.room.views.RoomViewPosition")
local RoomMenuPopup         = import("app.games.texas.room.views.RoomMenuPopup")
local CardTypePopup         = import("app.games.texas.room.views.CardTypePopup")
local AnimationDownNum      = import("app.games.texas.room.views.AnimationDownNum")
local P                     = import(".net.PROTOCOL")
local SlotPopup             = import("app.module.slot.SlotPopup")
local HallController        = import("app.module.hall.HallController")
local RoomFastTask          = import("app.module.room.task.RoomFastTask")
local RoomChatBubble        = import("app.module.room.chat.RoomChatBubble")


local logger = sa.Logger.new("OmahaRoomScene")

OmahaRoomScene.EVT_BACKGROUND_CLICK = "EVT_BACKGROUND_CLICK"
local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
    {"c_9", "c_6"},--普通场
    {"q_9", "q_6"},--快速场
}

function OmahaRoomScene:ctor()
    OmahaRoomScene.super.ctor(self,P.GAMEID)
    RoomViewPosition.setOmaha()
    self:createNodes_()
    self:createRoomBg_()
    self:createRoomTable_()

    -- 房间总控
    self.controller = RoomController.new(self)
    self.ctx = self.controller.ctx
    
    -- 房间信息 (初级场 前注)
    self.roomInfo_ = ui.newTTFLabel({size=26, text="", color=cc.c3b(0x0, 0x0, 0x0)})
        :opacity(40)
        :pos(display.cx, RoomViewPosition.TablePosition.y-320)
        :addTo(self.nodes.backgroundNode)

    self.shareBtn_ = cc.ui.UIPushButton.new({normal = "#texas/room/room_share_btn_normal.png", pressed = "#texas/room/room_share_btn_pressed.png"})
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 20}))
        :setButtonLabelOffset(20, 0)
        :onButtonClicked(buttontHandler(self, self.onShareClicked_))
        :addTo(self.nodes.backgroundNode)
        :hide()

    self.qucikIcon_ = display.newSprite("#texas/room/fast_icon.png")
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

    -- 站起按钮
    local standupPosX = marginLeft + 136
    local standupPosY = marginTop
    self.standupBtn_ = cc.ui.UIPushButton.new({normal = {"#commonroom/stand.png"},pressed = {"#commonroom/stand_down.png"}})
        :onButtonClicked(buttontHandler(self, self.onStandupClick_))
        :pos(standupPosX, standupPosY)
        :addTo(self.topNode_)

    -- 换桌按钮
    local changeRoomPosX = marginLeft + 136
    local changeRoomPosY = marginTop
    self.changeRoomBtn_ = cc.ui.UIPushButton.new({normal = {"#commonroom/change.png"}, pressed = {"#commonroom/change_down.png"}})
        :onButtonClicked(buttontHandler(self, self.onChangeRoomClick_))
        :pos(changeRoomPosX, changeRoomPosY)
        :addTo(self.topNode_)
        :hide()

    --邀请按钮
    self.inviteBtn_ = cc.ui.UIPushButton.new({normal = "#commonroom/invite_table.png", pressed = "#commonroom/invite_table_down.png"})
        :onButtonClicked(buttontHandler(self, self.onInviteClicked_))
        :pos(display.right - 170, marginTop)
        :addTo(self.topNode_)
    if tx.config.SHOW_SHARE~=1 then
        self.inviteBtn_:hide()
    end

    -- 商城按钮
    local shopPosX = display.right - 56
    local shopPosY = marginTop
    self.shopNode_ = display.newNode()
    self.shopNode_:pos(shopPosX,shopPosY):addTo(self.topNode_)

    self.shopBtn_ = cc.ui.UIPushButton.new({normal = {"#common/btn_scene_shop.png"},pressed = {"#common/btn_scene_shop_down.png"}})
        :onButtonClicked(buttontHandler(self, self.openStore))
        :addTo(self.shopNode_)

    -- 牌型按钮
    self:addCardTypeButton_()

    -- 增购筹码
    if true then
        self.addChipsBtn_ = cc.ui.UIPushButton.new({normal = "#texas/room/addBuy.png", pressed = "#texas/room/addBuy_down.png"})
            :onButtonClicked(buttontHandler(self, self.onAddBtnClick_))
            :pos(RoomViewPosition.SeatPosition[10].x+110, RoomViewPosition.SeatPosition[10].y + 25)
            :addTo(self.nodes.dealCardNode)
            :hide()
    end

    -- 荷官赠送筹码
    self.sendChipsCount_ = 0 --统计赠送筹码总数
    self.sendMoneyToDealerBtn_ = ScaleButton(display.newSprite("#lang/dear.png"), 0.9)
        :onButtonClicked(buttontHandler(self,function()
            local seatId,player = nil,nil
            if self.ctx.model then
                seatId,player = self.ctx.model:getSeatIdByUid(tx.userData.uid)
            end

            if not self.ctx.model or not player then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","SEND_CHIP_NOT_IN_SEAT"))
                return
            end

            if self.isSendingMoneyToDealer_ then
                return
            end

            local money = self.ctx.model.roomInfo.blind*2
            if player.seatChips<=money then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","SELF_CHIP_NO_ENOUGH_SEND_DELEAR"))
                return
            end

            self.isSendingMoneyToDealer_ = true

            sa.HttpService.CANCEL(self.sendMoneyToDealerId_)
            self.sendMoneyToDealerId_ = sa.HttpService.POST({
                    mod = "User",
                    act = "sendMoneyToDealer",
                    money = money,
                },
                function(data)
                    local jsnData = json.decode(data)
                    if jsnData and jsnData.code==1 then
                        tx.userData.money = tx.userData.money - money
                        self.sendChipsCount_ = self.sendChipsCount_ + money

                        local PROTOCOL = tx.socket.HallSocket.PROTOCOL -- 大厅公共协议
                        local msgInfo = {
                            t=PROTOCOL.TABLE_MSG_TYPES[5],
                            chips=money,
                            from=seatId,
                            to=-100,
                            isInT=jsnData.isInTable,
                        }
                        self.ctx.model:processSendChipSuccess(msgInfo,((msgInfo.isInT)==1))
                        self.ctx.animManager:playSendChipAnimation(msgInfo.from,msgInfo.to,msgInfo.chips)

                        self.sendMoneyToDealerBtn_:stopAllActions()
                        self.sendMoneyToDealerBtn_:performWithDelay(function()
                            local sendChip = self.sendChipsCount_
                            self.sendChipsCount_ = 0
                            tx.socket.HallSocket:sendChips(sendChip,seatId,-100,jsnData.isInTable or 0)
                        end, 0.5)
                    elseif jsnData and jsnData.code==-3 then
                        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","SELF_CHIP_NO_ENOUGH_SEND_DELEAR"))
                    else    
                        tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND","RECALL_FAILED_TIP"))
                    end
                    self.isSendingMoneyToDealer_ = false
                end,
                function()
                    tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND","RECALL_FAILED_TIP"))
                    self.isSendingMoneyToDealer_ = false
                end)
        end))
        :pos(RoomViewPosition.SeatPosition[10].x-115, RoomViewPosition.SeatPosition[10].y + 45)
        :addTo(self.nodes.dealCardNode)

    self:addSlot_()

    self:addMicrophoneBtn(display.right-145, display.bottom+155,self.nodes.lampNode)
    -- 倒计时进度框
    self.fastTaskNode_ = RoomFastTask.new(self.ctx)
        :pos(display.right, display.bottom)
        :addTo(self.nodes.lampNode)

    -- 创建其他元素
    self.controller:createNodes()

    self:setChangeRoomButtonMode(1)

    self:addPropertyObservers()
    self:updateShopIcon_()
end

function OmahaRoomScene:dealCardTypeWord(probValue)
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

function OmahaRoomScene:setRoomInfoText(roomInfo)
    local isPrivate = self.ctx.model:isPrivateRoom()

    if tx.userData.tableConfig then
        self:setNewRoomInfoText_(roomInfo, isPrivate)
    else
        self:setRoomInfoText_(roomInfo)
    end

    if roomInfo.betExpire == 10 then--快速场
        local size = self.roomInfo_:getContentSize()
        local x, y = self.roomInfo_:getPosition()
        self.qucikIcon_:show():pos(x - size.width/2 - 10, y)
    else
        self.qucikIcon_:hide()
    end
end

--新版房间信息格式
function OmahaRoomScene:setNewRoomInfoText_(roomInfo, isPrivate)
    local info = ""

    if isPrivate then
        info = sa.LangUtil.getText("ROOM", "PRIVATE_ROOM_INFO",
            roomInfo.playerNum,
            roomInfo.tid,
            sa.formatBigNumber(roomInfo.blind),
            sa.formatBigNumber(roomInfo.blind * 2))
        self.shareBtn_:show()
        self.controller:changeDealer(4)
    else
        info = sa.LangUtil.getText("ROOM", "NORMAL_ROOM_INFO",
            self:getCityName_(),
            roomInfo.playerNum,
            roomInfo.tid,
            sa.formatBigNumber(roomInfo.blind),
            sa.formatBigNumber(roomInfo.blind * 2))
        self.shareBtn_:hide()
        self.controller:changeDealer(5)
    end

    self.roomInfo_:setString(info)

    local size = self.roomInfo_:getContentSize()
    local x, y = self.roomInfo_:getPosition()
    self.shareBtn_:align(display.LEFT_CENTER, x + size.width/2 + 10, y + 20)
end

--如果配置没有获取到，用老版信息格式
function OmahaRoomScene:setRoomInfoText_(roomInfo)
    if roomInfo.roomField == 0 then
        roomInfo.roomField = 1
    end
    local roomFiled = sa.LangUtil.getText("HALL", "ROOM_LEVEL_TEXT_ROOMTIP")[roomInfo.roomField]

    local info = sa.LangUtil.getText("ROOM", "ROOM_INFO", roomFiled, roomInfo.tid, sa.formatBigNumber(roomInfo.blind), sa.formatBigNumber(roomInfo.blind * 2))
    self.roomInfo_:setString(info)
end

function OmahaRoomScene:setPrivateRoomInfo(pack)
    -- 私人房不展示
    self:addMicrophoneBtn(display.right-50, display.bottom+155,self.nodes.lampNode)
    if self.fastTaskNode_ then
        self.fastTaskNode_:dele()
        self.fastTaskNode_:hide()
    end

    self.changeRoomBtn_:pos(-10000,-10000)

    if not self.privateRoomInfo_ then
        self.privateRoomInfo_ = ui.newTTFLabel({size=26, text="", color=cc.c3b(0x0, 0x0, 0x0)}):pos(display.cx, RoomViewPosition.TablePosition.y-280):addTo(self.nodes.backgroundNode)
        self.privateRoomInfo_:setOpacity(40)
    end
    self.privateRoomInfo_:stopAllActions()
    self.privateRoomInfo_:setString(sa.LangUtil.getText("ROOM","PRIVTE_INFO",sa.TimeUtil:getTimeString1(pack.leftTime)))
    self.privateRoomInfo_:schedule(function( ... )
        local nowTime = os.time()
        local leftTime = pack.leftTime - (nowTime - pack.clientRecTime)
        -- 提示房间即将到期解散
        if leftTime<=60 and not self.privateTipsLeftTime_ then
            self.privateTipsLeftTime_ = true
            tx.HorseLamp:showTips(sa.LangUtil.getText("PRIVTE", "NOTIMETIPS",leftTime),nil,true)
        elseif leftTime<=0 then -- 没时间了，并且时间重置了
            leftTime = 0 
            if self.controller.hasReset_==true and not self.privateShowEnded_ then
                self.privateShowEnded_ = true
                tx.ui.Dialog.new({
                    closeWhenTouchModel = false,
                    hasCloseButton = false,
                    hasFirstButton = false,
                    messageText = sa.LangUtil.getText("PRIVTE", "TIMEEND"),
                    secondBtnText = sa.LangUtil.getText("ROOM", "BACK_TO_HALL"),
                    callback = function (type)
                        self:doBackToHall()
                    end
                }):show()
                self.privateRoomInfo_:stopAllActions()
            end
        end
        self.privateRoomInfo_:setString(sa.LangUtil.getText("ROOM","PRIVTE_INFO",sa.TimeUtil:getTimeString1(leftTime)))
    end,1)

    self:setRoomInfoText(self.ctx.model.roomInfo)
end

function OmahaRoomScene:getCityName_()
    local index = 1
    local config = tx.userData.omahaTableConfig
    if not config then
        return ""
    end

    local level = tonumber(tx.socket.HallSocket.curGameLevel)
    local city = sa.LangUtil.getText("HALL", "OMAHA_ROOM_CITY_NAME")
    local data = config[1][ROOM_TYPE_KEY[QUICK_PLAY][NUM_9]]

    for i, v in ipairs(data) do
        if level == tonumber(v.level) then
            index = v.index or i
            break
        end
    end

    return city[index]
end

function OmahaRoomScene:updateHalloweenRoomProgress(isShow, info, reward)
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

function OmahaRoomScene:setSlotBlind(roomInfo)
    self.slotBlindRoomInfo_ = roomInfo
    if self.slotPopup then
        self.slotPopup:setPreBlind(roomInfo.blind)
    end
end

function OmahaRoomScene:setChangeRoomButtonMode(mode)
    if mode == 1 then
        self.changeRoomBtn_:show()
        self.standupBtn_:hide()
    else
        self.changeRoomBtn_:hide()
        self.standupBtn_:show()
    end
end

function OmahaRoomScene:onStandupClick_()
    if self.ctx.model:isSelfInGame() then
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("ROOM", "STAND_UP_IN_GAME_MSG"), 
            hasCloseButton = false,
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    tx.socket.HallSocket:sendGameCmd("sendStandUp")
                end
            end
        }):show()
    else
        tx.socket.HallSocket:sendGameCmd("sendStandUp")
    end
end

function OmahaRoomScene:requestOutRoom()
    tx.socket.HallSocket:sendGameCmd("sendLogout")
end

function OmahaRoomScene:doBackToHall(msg)
    if self.isback_ then
        return
    end
    local fun = function()
        self.isback_ = true
        if self.ctx and self.ctx.model and not self.ctx.model:isPrivateRoom() then
            _G.PlayStatistics = self.ctx.model.statistics_ -- 输赢统计
        end
        self:requestOutRoom()
        OmahaRoomScene.super.doBackToHall(self,msg)
    end

    if self.ctx.model:isSelfInGame() then
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("ROOM", "LEAVE_IN_GAME_MSG"),
            hasCloseButton = false,
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    fun()
                end
            end
        }):show()
    else
        fun()
    end
end

function OmahaRoomScene:onShareClicked_()
    local InviteFriendPopup = require("app.module.room.inviteplay.InviteFriendPopup")
    InviteFriendPopup.new():showPanel()
end

function OmahaRoomScene:onInviteClicked_()
    local ExchangeCodePopup = require("app.module.exchangecode.ExchangeCodePopup")
    ExchangeCodePopup.new():showPanel()
end

function OmahaRoomScene:onMenuClick_()
    local model = self.ctx and self.ctx.model
    local noChange = false
    if self.ctx.model and self.ctx.model:isPrivateRoom() then
        noChange = true
    end
    RoomMenuPopup.new(self.ctx,noChange and {2} or nil):showPanel()
end

function OmahaRoomScene:getNewRoom(msg)
    self:requestOutRoom()
    OmahaRoomScene.super.getNewRoom(self,msg)
end

function OmahaRoomScene:onChangeRoomClick_()
    local fun = function()
        self:getNewRoom2_()
    end
    if self.ctx.model:isSelfInGame() then
        tx.ui.Dialog.new({
            messageText = sa.LangUtil.getText("ROOM", "LEAVE_IN_GAME_MSG"),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    fun()
                end
            end
        }):show()
    else
        fun()
    end
end

function OmahaRoomScene:dealSitDownView()
    if self.ctx.model and self.ctx.model:isSelfInSeat() then
        if self.microphoneBtn_ then
            self.microphoneBtn_:show()
        end
        self.addChipsBtn_:show()
        if not self.invitePlayBtn_ then  -- 邀请一起玩牌
            local width,height = 124,186
            self.invitePlayBtn_ = cc.ui.UIPushButton.new("#texas/room/room_seat_bg.png", {scale9 = true})
                :pos(display.cx,display.cy)
                :setButtonSize(width,height)
                :addTo(self.nodes.seatNode)
                :onButtonClicked(function()
                    tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                    local InvitePlayPopup = require("app.module.room.inviteplay.InvitePlayPopup")
                    InvitePlayPopup.new(self.ctx.model):showPanel()
                end)
                :onButtonRelease(function()
                    self.invitePlayBtn_:setColor(cc.c3b(255,255,255))
                end)
                :onButtonPressed(function()
                    self.invitePlayBtn_:setColor(cc.c3b(170,170,170))
                end)
            display.newSprite("#commonroom/invite_seat.png")
                :addTo(self.invitePlayBtn_)
        end
        local emptySeatId = self.ctx.seatManager:getEmptySeatId()
        if not emptySeatId then
            self.invitePlayBtn_:hide()
        else
            local seatView = self.ctx.seatManager:getSeatView(emptySeatId)
            if seatView then
                local positionId = seatView:getPositionId()
                local pos = RoomViewPosition.SeatPosition[positionId]
                self.invitePlayBtn_:show()
                self.invitePlayBtn_:pos(pos.x,pos.y)
            end
        end
    else
        if self.microphoneBtn_ then
            self.microphoneBtn_:hide()
        end
        self.addChipsBtn_:hide()
        if self.invitePlayBtn_ then
            self.invitePlayBtn_:hide()
        end
    end
end

function OmahaRoomScene:onAddBtnClick_()
    if not self.ctx.model or not self.ctx.model:isSelfInSeat() then
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS"))
        return;
    end
    local selfData = self.ctx.model:selfSeatData()
    if not selfData then
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS"))
        return;
    end
    local curSeatChips = selfData.seatChips  -- 座位上显示的钱
    if not self.ctx.model or not self.ctx.model.roomInfo then return; end
    local leftMoney = tx.userData.money - selfData.curChips--当前没有结算初始的时候的钱
    if leftMoney<1 then
        self:openStore()
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS_2"))
        return
    end
    if leftMoney>0 and (leftMoney+curSeatChips)<self.ctx.model.roomInfo.minBuyIn then
        -- tx.ui.Dialog.new({
        --     messageText = sa.LangUtil.getText("COMMON", "NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG", self.ctx.model.roomInfo.minBuyIn), 
        --     hasCloseButton = false,
        --     callback = function (type)
        --         if type == tx.ui.Dialog.SECOND_BTN_CLICK then
        --             self:openStore()
        --         end
        --     end
        -- }):show()
        self:openStore()
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG", self.ctx.model.roomInfo.minBuyIn))
        return
    end
    local max = self.ctx.model.roomInfo.maxBuyIn  -- 上限值
    if curSeatChips>=max then
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS_3"))
        return
    end
    -- 最小的
    local minBuyIn = self.ctx.model.roomInfo.minBuyIn
    if minBuyIn<=curSeatChips then  -- 至少要多余现在的座位上的
        minBuyIn = curSeatChips + 1 -- 至少加1
    end
    -- 最大的
    local maxBuyIn = max
    if (leftMoney+curSeatChips)<maxBuyIn then
        maxBuyIn = (leftMoney+curSeatChips)
    end

    local BuyInPopup = require("app.games.texas.room.views.BuyInPopup")
    BuyInPopup.new({
        type = 1,  -- 增购
        minBuyIn = minBuyIn,
        maxBuyIn = maxBuyIn,
        blind = self.ctx.model.roomInfo.blind,
        callback = function(buyinChips, autoBuyType)
            -- 已经被站起了
            if not self.ctx.model or not self.ctx.model:isSelfInSeat() then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS"))
                return;
            end
            local selfData = self.ctx.model:selfSeatData()
            if not selfData then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM","ADD_IN_BTN_TIPS"))
                return;
            end
            local isAutoIn = false
            if autoBuyType>0 then
                isAutoIn = true
                if autoBuyType==2 then
                    autoBuyType = 1
                else
                    autoBuyType = 0
                end
            else
                autoBuyType = 0
            end
            tx.socket.HallSocket:sendGameCmd("setAutoBuy",isAutoIn and 1 or 0, autoBuyType)
            -- tx.socket.HallSocket:sendGameCmd("addChips",buyinChips+curSeatChips)
            tx.socket.HallSocket:sendGameCmd("addChips",buyinChips)
            if tx.socket.HallSocket:isConnected() then
                -- tx.HorseLamp:showTips(sa.LangUtil.getText("ROOM","ADD_IN_SUC_TIPS",buyinChips),nil,true)
                tx.HorseLamp:showTips(sa.LangUtil.getText("ROOM","ADD_IN_SUC_TIPS",buyinChips-curSeatChips),nil,true)
            end

        end
    }):showPanel()
end

-- 牌型按钮
function OmahaRoomScene:addCardTypeButton_()
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

function OmahaRoomScene:onCardTypeClick_()
    if self.cardTypePopup_:isMoving() then
        return
    end

    self.cardTypePopup_:playShowAnimation()
end
--[[
OmahaRoomScene nodes:
    animLayer:动画层
    oprNode:操作按钮层
    lampNode:桌面灯光层
    chipNode:桌面筹码层
    dealCardNode:手牌层
    seatNode:桌子层
    seat1~9:桌子
    giftImage:礼物图片(*)
    userImage:用户头像
    backgroundImage:桌子背景
    backgroundNode:背景层
    dealerImage:荷官图片
    tableTextLayer:桌面文字
    tableImage:桌子图片
    backgroundImage:背景图片
]]
function OmahaRoomScene:createNodes_()
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
end

function OmahaRoomScene:onCleanup()
    OmahaRoomScene.super.onCleanup(self,self.unDispose)
    if self.privateRoomInfo_ then
        self.privateRoomInfo_:stopAllActions()
    end

    -- 控制器清理
    self.controller:dispose()

    -- 移除事件
    self:removeAllEventListeners()
    self:removePropertyObservers()

    if self.fastTaskNode_ then
        self.fastTaskNode_:dele()
        self.fastTaskNode_ = nil
    end
    sa.HttpService.CANCEL(self.sendMoneyToDealerId_)
end

function OmahaRoomScene:onBackgroundTouch_(target, evt, isInSprite, touchData)
    if evt == sa.TouchHelper.CLICK then
        self:dispatchEvent({name=OmahaRoomScene.EVT_BACKGROUND_CLICK})
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
            local halfWidth = self.slotPopup:getContentSize().width*0.5*self.slotPopup:getScale()
            local xx,yy = self.slotPopup:getPosition()
            if xx>(display.width+halfWidth-30) then -- 缩进的
                if self.bgTouchX_>display.width-135 then
                    local halfHeight = self.slotPopup:getContentSize().height*0.5*self.slotPopup:getScale()
                    if self.bgTouchY_>(yy-halfHeight-10) and self.bgTouchY_<(yy+halfHeight+10) then
                        self.isInTouchArea_ = true
                        self.bgTouchRight_ = true
                    end
                end
            else -- 已经展开
                self.isInTouchArea_ = true
                self.bgTouchRight_ = true
            end
            self.cardTypePopup_:playHideAnimation()
        else
            self.cardTypePopup_:playHideAnimation()
        end
    elseif evt==sa.TouchHelper.TOUCH_END or evt==sa.TouchHelper.CLICK then
        if self.touchIsMoveX_ and self.bgTouchOffsetX_ then
            if self.bgTouchRight_ then
                if self.bgTouchOffsetX_ > 0 then
                    self.slotPopup:playHideAnimation()
                elseif self.bgTouchOffsetX_ < 0 then
                    self.slotPopup:playShowAnimation()
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
                self.slotPopup:setMovePositionX(offsetX)
            elseif self.bgTouchLeft_ then
                if not self.dealedCardType_ then
                    self.cardTypePopup_:setMovePositionX(offsetX)
                end
            end
        end
    end
end

-- 老虎机
function OmahaRoomScene:addSlot_()
    if tx.config.SLOT_ENABLED and not self.slotPopup then
        display.addSpriteFrames("slot_texture.plist", "slot_texture.png", function()
            self.slotPopup = SlotPopup.new(true)
                :addTo(self.nodes.popupNode)
                :showPanel()

            if self.slotBlindRoomInfo_ then
                self:setSlotBlind(self.ctx.model.roomInfo)
            end
        end)
    end
end

function OmahaRoomScene:updateShopIcon_()
    OmahaRoomScene.super.updateShopIcon_(self,evt)
    OmahaRoomScene.super.dealShopShow(self,self.shopBtn_)
end

function OmahaRoomScene:addPropertyObservers()
    self.changeDealerObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "dealerId", handler(self, function (obj, dealerId)
        -- self.controller:changeDealer(dealerId)
    end))
end

function OmahaRoomScene:removePropertyObservers()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "dealerId", self.changeDealerObserverHandle_)
end

function OmahaRoomScene:onPlayPropertyChangeAnim(evt)
    if evt and evt.data and evt.noShow~=false then
        if self.ctx and self.ctx.model and self.ctx.model:isSelfInSeat() then
            local P = RoomViewPosition.SeatPosition[5]
            local x, y = P.x+RoomViewPosition.SelfOffsetX, P.y+RoomViewPosition.SelfOffsetY
            self:playPropertyChangeAnim_(evt.data, x, y)
        end
    end
end

return OmahaRoomScene
