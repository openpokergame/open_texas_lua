local GameRoomScene         = import("app.scenes.GameRoomScene")
local RedBlackRoomScene     = class("RedBlackRoomScene", GameRoomScene)

local RoomController        = import(".room.RoomController")
local RoomViewPosition      = import(".room.views.RoomViewPosition")
local P                     = import(".net.PROTOCOL")
local UserInfoPopup         = import("app.module.userInfo.UserInfoPopup")
local SettingPopup          = import("app.module.setting.SettingPopup")
local HelpPopup             = import(".room.views.HelpPopup")
local PlayerPopup           = import(".room.views.PlayerPopup")
local logger                = sa.Logger.new("RedBlackRoomScene")

RedBlackRoomScene.EVT_BACKGROUND_CLICK = "EVT_BACKGROUND_CLICK"
local BET_TYPE_IMG = {
    "#lang/redblack_title_silver_win.png",
    "#lang/redblack_title_draw.png",
    "#lang/redblack_title_gold_win.png",
    "#lang/redblack_hand_card_type_1.png",
    "#lang/redblack_hand_card_type_2.png",
    "#lang/redblack_hand_card_type_3.png",
    "#lang/redblack_hand_card_type_4.png",
    "#lang/redblack_hand_card_type_5.png",
    "#lang/redblack_win_card_type_1.png",
    "#lang/redblack_win_card_type_2.png",
    "#lang/redblack_win_card_type_3.png",
    "#lang/redblack_win_card_type_4.png",
    "#lang/redblack_win_card_type_5.png",
}

local BET_TITLE_TYPE = {
    "#lang/redblack_hand_card_type.png",
    "#lang/redblack_win_card_type.png",
}

local FLAG_TITLE = {
    "#lang/redblack_title_silver_elephant.png",
    "#lang/redblack_title_gold_elephant.png",
}

local x = 1

function RedBlackRoomScene:ctor()
    RedBlackRoomScene.super.ctor(self, P.GAMEID)

    self:createNodes_()

    self:createRoomBg_()

    -- 房间总控
    self.controller = RoomController.new(self)
    self.ctx = self.controller.ctx

    -- 顶部操作栏
    local dir = 100
    local btn_x = 48
    local node = self.nodes.topNode
    cc.ui.UIPushButton.new({normal = "#common/btn_scene_back.png", pressed = "#common/btn_scene_back_down.png"})
        :onButtonClicked(buttontHandler(self, self.onBackClicked_))
        :pos(btn_x, 0)
        :addTo(node)

    self.allPlayerBtn_ = cc.ui.UIPushButton.new({normal = "#redblack/room/redblack_all_player_btn_normal.png", pressed = "#redblack/room/redblack_all_player_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onAllPlayerClicked_))
        :setDelayTouchEnabled(false)
        :pos(btn_x + dir, 0)
        :addTo(node)

    btn_x = display.width - btn_x
    self.shopBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_scene_shop.png", pressed = "#common/btn_scene_shop_down.png"})
        :pos(btn_x, 0)
        :onButtonClicked(buttontHandler(self, self.openStore))
        :addTo(node)

    cc.ui.UIPushButton.new({normal = "#redblack/room/redblack_rule_btn_normal.png", pressed = "#redblack/room/redblack_rule_btn_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.onRuleClicked_))
        :pos(btn_x - dir, 0)
        :addTo(node)

    -- 创建其他元素
    self.controller:createNodes()

    self:updateShopIcon_()
end

function RedBlackRoomScene:updateShopIcon_()
    RedBlackRoomScene.super.updateShopIcon_(self,evt)
    RedBlackRoomScene.super.dealShopShow(self,self.shopBtn_)
end

-- 创建房间背景
function RedBlackRoomScene:createRoomBg_()
    local bgImg = "img/redblack_table_bg.jpg"
    if self.backgroundImg_ then
        self.backgroundImg_:removeFromParent()
        self.backgroundImg_ = nil
    end

    self.backgroundImg_ = display.newNode()
        :pos(display.cx, display.cy)
        :addTo(self.nodes.backgroundNode)

    display.newSprite(bgImg)
        :align(display.RIGHT_CENTER)
        :addTo(self.backgroundImg_)

    display.newSprite(bgImg)
        :flipX(true)
        :align(display.LEFT_CENTER)
        :addTo(self.backgroundImg_)

    self.backgroundImg_:setScale(tx.bgScale)

    self:addTopCardView_()

    self:addBetView_()
end

--顶部旗子和公共牌视图
function RedBlackRoomScene:addTopCardView_()
    local node = self.nodes.backgroundNode
    self:addFlag_(1)
    self:addFlag_(2)

    local x, y = display.cx, display.height
    display.newSprite("#redblack/room/redblack_deal_card_turn.png")
        :align(display.RIGHT_TOP, x, y)
        :addTo(node)

    display.newSprite("#redblack/room/redblack_deal_card_turn.png")
        :flipX(true)
        :align(display.LEFT_TOP, x, y)
        :addTo(node)

    display.newSprite("#redblack/room/redblack_card_icon.png")
        :align(display.TOP_CENTER, x, y)
        :addTo(node)

    local posList = RoomViewPosition.PubCardPosition

    for i = 1, 5 do
        display.newSprite("#redblack/room/redblack_deal_card_area.png")
            :pos(posList[i].x, posList[i].y)
            :addTo(node)
    end
end

function RedBlackRoomScene:addFlag_(index)
    local flag_w, flag_h = 196, 204
    local p = RoomViewPosition.DealCardPosition[index]
    local flag = display.newSprite("#redblack/room/redblack_flag.png")
        :align(display.TOP_CENTER, p.x, display.height)
        :addTo(self.nodes.backgroundNode)

    display.newSprite(FLAG_TITLE[index])
        :pos(flag_w*0.5, flag_h - 24)
        :addTo(flag)
end

--下注视图
function RedBlackRoomScene:addBetView_()
    local node = self.nodes.backgroundNode
    local x, y = RoomViewPosition.BET_TYPE_X, RoomViewPosition.BET_TYPE_Y

    display.newSprite("#redblack/room/redblack_bet_area.png")
        :align(display.TOP_CENTER, x, y)
        :addTo(node)

    local posList = RoomViewPosition.BetTypePosition
    local oddsList = {}
    local offsetX = {92, 0, -84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    for i = 1, 13 do
        local x, y = posList[i].x + offsetX[i], posList[i].y
        local sp = display.newSprite(BET_TYPE_IMG[i])
            :pos(x, y)
            :addTo(node)

        local size = sp:getContentSize()
        oddsList[i] = ui.newBMFontLabel({text = "", font = "fonts/redblack_odds.fnt"})
            :align(display.BOTTON_CENTER, size.width*0.5, 0)
            :addTo(sp)
    end
    self.betOddsList_ = oddsList

    posList = RoomViewPosition.BetTypeTitlePosition
    
    for i = 1, 2 do
        display.newSprite(BET_TITLE_TYPE[i])
            :pos(posList[i].x, posList[i].y)
            :addTo(node)
    end
end

function RedBlackRoomScene:updateBetOdds(data)
    for i, v in ipairs(data) do
        self.betOddsList_[i]:setString("X" .. v)
    end
end

function RedBlackRoomScene:setStoreDiscount(discount)
end

function RedBlackRoomScene:updateHalloweenRoomProgress(isShow, info, reward)
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

function RedBlackRoomScene:requestOutRoom()
    tx.socket.HallSocket:sendGameCmd("sendLogout")
end

function RedBlackRoomScene:doBackToHall(msg)
    if self.isback_ then
        return
    end

    local fun = function()
        self.isback_ = true
        self:requestOutRoom()
        RedBlackRoomScene.super.doBackToHall(self, msg)
    end

    if self.ctx.model:isSelfPlaying() then
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

function RedBlackRoomScene:onBackClicked_()
    self:doBackToHall()
end

function RedBlackRoomScene:onAllPlayerClicked_()
    PlayerPopup.new(self.ctx):showPanel()
end

function RedBlackRoomScene:onRuleClicked_()
    HelpPopup.new(self.ctx.model):showPanel()
end

function RedBlackRoomScene:getNewRoom(msg)
    self:requestOutRoom()
    RedBlackRoomScene.super.getNewRoom(self,msg)
end

--[[
    oprNode:操作按钮层
    chipNode:桌面筹码层
    dealCardNode:手牌层
    seatNode:座位层
    backgroundNode:背景层
]]
function RedBlackRoomScene:createNodes_()
    self.nodes = {}
    self.nodes.backgroundNode = display.newNode():addTo(self, 1)
    self.nodes.seatNode = display.newNode():addTo(self, 2)
    self.nodes.topNode = display.newNode():pos(display.left, display.top - 58):addTo(self, 3)
    self.nodes.dealCardNode = display.newNode():addTo(self, 4)
    self.nodes.oprNode = display.newNode():addTo(self, 5)
    self.nodes.chipNode = display.newNode():addTo(self, 6)
    self.nodes.betTypeNode = display.newNode():addTo(self, 7)
    self.nodes.animNode = display.newNode():addTo(self, 8)
end

function RedBlackRoomScene:onCleanup()
    RedBlackRoomScene.super.onCleanup(self,self.unDispose)
    if self.privateRoomInfo_ then
        self.privateRoomInfo_:stopAllActions()
    end

    -- 控制器清理
    self.controller:dispose()

    -- 移除事件
    self:removeAllEventListeners()

    sa.HttpService.CANCEL(self.sendMoneyToDealerId_)
end

function RedBlackRoomScene:onPlayPropertyChangeAnim(evt)
    if evt and evt.data and evt.noShow~=false then
        if self.ctx and self.ctx.model and self.ctx.model:isSelfInSeat() then
            local P = RoomViewPosition.SeatPosition[9]
            self:playPropertyChangeAnim_(evt.data, P.x, P.y)
        end
    end
end

function RedBlackRoomScene:playBetAvatarAnimation()
    local btn = self.allPlayerBtn_
    btn:stopAllActions()
    btn:scale(1)

    local t = 0.2
    transition.scaleTo(btn, {scale = 1.2, time=t, easing = "backOut", onComplete=function()
        transition.scaleTo(btn, {scale = 1, time=t})
    end})
end

return RedBlackRoomScene
