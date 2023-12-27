local OperationButton = import(".views.OperationButton")
local OperationButtonGroup = import(".views.OperationButtonGroup")
local RaiseSlider = import(".views.RaiseSlider")
local RoomTipsView = import(".views.RoomTipsView")
local OperationManager = class("OperationManager")
local RoomViewPosition = import(".views.RoomViewPosition")
local PP = RoomViewPosition.DealCardPosition

local ChatMsgPanel = import("app.module.room.chat.ChatMsgPanel")

function OperationManager:ctor()
    PP = RoomViewPosition.DealCardPosition
    self.LB_FOLD_ = sa.LangUtil.getText("ROOM", "FOLD")
    self.LB_CHECK_ = sa.LangUtil.getText("ROOM", "CHECK")
    self.LB_CALL_ = sa.LangUtil.getText("ROOM", "CALL").." "
    self.LB_RAISE_ = sa.LangUtil.getText("ROOM", "RAISE")
    self.LB_RAISE_NUM_ = sa.LangUtil.getText("ROOM", "RAISE_NUM", "%%s")
    self.LB_AUTO_CHECK_ = sa.LangUtil.getText("ROOM", "AUTO_CHECK")
    self.LB_AUTO_CHECK_OR_FOLD_ = sa.LangUtil.getText("ROOM", "AUTO_CHECK_OR_FOLD")
    self.LB_AUTO_CALL_ = sa.LangUtil.getText("ROOM", "CALL_NUM", "%%s")
    self.LB_AUTO_FOLD_ = sa.LangUtil.getText("ROOM", "AUTO_FOLD")
    self.LB_AUTO_CALL_ANY_ = sa.LangUtil.getText("ROOM", "AUTO_CALL_ANY")
    self.LB_SHOW_HAND_ = sa.LangUtil.getText("ROOM", "SHOW_HANDCARD")
    self.schedulerPool_ = sa.SchedulerPool.new()
    self.handCardNum_ = 2
    self.showCardBtnPos_ = {
        {x = -27, y = -39},
        {x = 37, y = -39},
    }
end

function OperationManager:createNodes()
    --聊天按钮
    self.chatNode_ = display.newNode():pos(8, 6):addTo(self.scene.nodes.oprNode, 2, 2)
    self.chatNode_:setAnchorPoint(cc.p(0, 0))
    local chatW = math.round(display.width * 0.32)
    local padding = math.round((display.width * 0.05 - 16) / 4)
    local oprBtnW = math.round((display.width - 16 - chatW - 4 * padding) / 3)
    OperationButton.BUTTON_WIDTH = oprBtnW

    --- new ---
    self.chatBtn_ = cc.ui.UIPushButton.new({normal = {"#commonroom/chat.png"},pressed = {"#commonroom/chat_down.png"}})
        :onButtonClicked(function()
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            self.chatPanel_ = ChatMsgPanel.new(self.ctx)
            self.chatPanel_:showPanel()
        end)
        :pos(43, 43)
        :addTo(self.chatNode_)

    local raiseWidth = OperationButton.BUTTON_WIDTH+8-5
    self.raiseSlider_ = RaiseSlider.new(raiseWidth)
        :onButtonClicked(buttontHandler(self, self.onRaiseSliderButtonClicked_))
        :pos(display.right - (raiseWidth)*0.5, display.cy+44)
        :addTo(self.scene.touchLayer,5,5)
        :hide()

    RoomTipsView.WIDTH = display.width * 0.7 - 16 - padding
    self.tipsView_ = RoomTipsView.new():pos(display.right - 8 - RoomTipsView.WIDTH * 0.5, display.bottom + 44):addTo(self.scene.nodes.oprNode, 4, 4)

    self.oprNode_ = display.newNode():pos(display.right - 8, display.bottom + 48):addTo(self.scene.nodes.oprNode, 5, 5)
    self.checkGroup_ = OperationButtonGroup.new()

    self.oprBtn1_ = OperationButton.new("green"):setLabel(self.LB_CHECK_):pos(- oprBtnW * 1.5 - padding, 0):addTo(self.oprNode_)
    self.oprBtn2_ = OperationButton.new("red"):setLabel(self.LB_CALL_):pos(- oprBtnW * 2.5 - 2 * padding, 0):addTo(self.oprNode_)
    self.oprBtn3_ = OperationButton.new("yellow"):setLabel(self.LB_RAISE_):pos(-oprBtnW * 0.5, 0):addTo(self.oprNode_)

    self.checkGroup_:add(1, self.oprBtn1_)
    self.checkGroup_:add(2, self.oprBtn2_)
    self.checkGroup_:add(3, self.oprBtn3_)
    self.scene:addEventListener(self.scene.EVT_BACKGROUND_CLICK, handler(self, self.onBackgroundClicked))


    self.mainBtnWidth_ = oprBtnW
    self.fastBtnWidth_ = math.round((chatW-5*4)/3)
    self.fastBtnHeight_ = 86
    self.fastBtnPadding_ = self.fastBtnWidth_+12
    self.fastBtnStart_ = self.fastBtnWidth_*0.5 + 16

    self.normalBtnWidth_ = math.round((display.width - self.mainBtnWidth_ - 7*padding)/5)
    self.normalPadding_ = padding
    self.oprFastNode_ = display.newNode()
        :pos(-display.width, 0)
        :addTo(self.oprNode_)

    self.oprFastNode_:setContentSize(cc.size(316,65))
    self.oprFastNode_:hide()
    
    self.blind3Btn_ = self:createAddFastBtn(1)
    self.blind3Btn_:pos(self.fastBtnStart_, 0):addTo(self.oprFastNode_)
    self.blind3Btn_:getButtonLabel("normal"):setString(sa.LangUtil.getText("ROOM", "BLIND3"))
        
    self.blind4Btn_ = self:createAddFastBtn(1)
    self.blind4Btn_:pos(self.fastBtnStart_+self.fastBtnPadding_, 0):addTo(self.oprFastNode_)
    self.blind4Btn_:getButtonLabel("normal"):setString(sa.LangUtil.getText("ROOM", "BLIND4"))
    
    self.totalChipsInTable_ = self:createAddFastBtn(1)
    self.totalChipsInTable_:pos(self.fastBtnStart_+self.fastBtnPadding_*2, 0):addTo(self.oprFastNode_)
    self.totalChipsInTable_:getButtonLabel("normal"):setString(sa.LangUtil.getText("ROOM", "TABLECHIPS"))

    self.oprFastNode_.show = function(obj)
        cc.Node.show(obj)
        self:setAddBtnStatus()
    end
    self:createShowCardNode()
end

-- 亮牌
function OperationManager:createShowCardNode()
    self.showCardBtnList_ = {}
    self.showCardIconList_ = {}
    self.showCardStatus_ = {}
    self:setCardSelectedStatus_(false)

    self.showCardNode_ = display.newNode()
        :pos(PP[5].x+59, PP[5].y+90)
        :addTo(self.scene.nodes.oprNode,7,7)

    for i = 1, self.handCardNum_ do
        self.showCardBtnList_[i], self.showCardIconList_[i] = self:createShowCardBtn_(i, buttontHandler(self, self.onShowCardClicked_))
    end

    -- 转化坐标
    local tempWorldPt = self.scene.nodes.oprNode:convertToWorldSpace(cc.p(self.showCardNode_:getPosition()))
    local xx,yy = tempWorldPt.x,tempWorldPt.y
    xx,yy = display.width-xx,0-yy
    self.showCardBtn_ = OperationButton.new("green",{showY=yy+48,hideY=yy-60}):setLabel(self.LB_SHOW_HAND_):pos(xx-OperationButton.BUTTON_WIDTH*0.5-8,yy+48)
        :addTo(self.showCardNode_)
        :onTouch(function(evt)
            if evt == sa.TouchHelper.CLICK then 
                if self.model and self.model:selfSeatData() and self.model.gameInfo then
                    if self:isSelectedHandCard_() then
                        self:setCardSelectedStatus_(false)
                    else
                        self:setCardSelectedStatus_(true)
                    end
                end
                self:setShowCardStatus()
            end
        end)
end

function OperationManager:hideShowBtn(cardList)
    for i,v in ipairs(cardList) do
        if v ~= 0 then
            self.showCardBtnList_[i]:hide()
            self.showCardBtn_:hide()
        end
    end
end

function OperationManager:setShowCardStatus(clear)
    self:hideAllShowCardBtn_()

    if clear == true then
        self:setCardSelectedStatus_(false)

        self.showCardReSet_ = true
        self.showCardNode_:performWithDelay(function()
            self.showCardReSet_ = nil
        end,0.08)
        return self
    end
    if self.model and self.model:selfSeatData() and self.model.gameInfo then
        local canShow = self.model:canShowHandcard()
        local isCheat = self.model:canShowHandcardButton()
        local gameStatus = self.model.gameInfo.gameStatus
        local player = self.model:selfSeatData()
        if canShow and player.handCards and player.handCards[self.handCardNum_]~=0 then
            local seatView = self.seatManager and self.seatManager:getSelfSeatView()

            for i = 1, self.handCardNum_ do
                local card = seatView and seatView.handCards_ and seatView.handCards_.cards[i]
                self.showCardBtnList_[i]:show()

                -- 状态的位置
                if self.showCardStatus_[i]==true then
                    self.showCardIconList_[i]:show()
                    if card then
                        card:removeDark()
                    end
                else
                    self.showCardIconList_[i]:hide()
                    if card and not isCheat then
                        card:addDark()
                    end
                end
            end

            if gameStatus==consts.SVR_GAME_STATUS.READY_TO_START then
                if not self:isSelectedHandCard_() then
                    self.showCardBtn_:show()
                        :setEnabled(true)
                        :setCheckMode(false)
                else
                    self.showCardBtn_:hide()
                end
            else
                self.showCardBtn_:show()
                if not self:isSelectedHandCard_() then
                    self.showCardBtn_:setEnabled(true):setCheckMode(true):setChecked(false)
                else
                    self.showCardBtn_:setEnabled(true):setCheckMode(true):setChecked(true)
                end
            end

            -- 发送给server
            if gameStatus==consts.SVR_GAME_STATUS.READY_TO_START and self:isSelectedHandCard_() then
                self.showCardBtn_:hide()
                if self.showCardBtn_.animParam_ and self.showCardBtn_.animParam_.hideY then
                    self.showCardBtn_:setPositionY(self.showCardBtn_.animParam_.hideY)
                end

                local requestData = {}
                for i = 1, self.handCardNum_ do
                    if self.showCardStatus_[i]==true then
                        self.showCardBtnList_[i]:hide()  -- 发出去了则隐藏
                        requestData[i] = player.handCards[i]
                    else
                        requestData[i] = 0
                    end
                end
                requestData.cardTypeName = seatView.cardTypeName

                tx.socket.HallSocket:showTexasHandCards(requestData)
            end
        end
    end
    return self
end

function OperationManager:createAddFastBtn(type)
    local BG_W,BG_H = self.normalBtnWidth_,86
    local buttonSize,buttonColor = 30,OperationButton.purpleColor
    local resTable = {
        normal="#texas/room/purple.png",
        pressed="#texas/room/purple_down.png",
    }
    if type==1 then
        BG_W,BG_H = math.round(display.width * 0.32)/3-5*2,86
    elseif type==2 then
        resTable = {
            normal="#texas/room/yellow.png",
            pressed="#texas/room/yellow_down.png",
        }
        BG_W = self.mainBtnWidth_
    end
    local btn = cc.ui.UIPushButton.new(resTable, {scale9 = true})
        :setButtonLabel(ui.newTTFLabel({
            text = "",
            size = (type==2) and 32 or buttonSize,
            color = buttonColor,
            align = ui.TEXT_ALIGN_CENTER}))
        :setButtonLabelOffset(0,0)
        :setButtonSize(BG_W, BG_H)
    btn.setButtonEnabled = function(obj,value)
        if value==true then
            obj:setColor(cc.c3b(255,255,255))
            cc.ui.UIPushButton.super.setButtonEnabled(obj,true)
        else
            obj:setColor(cc.c3b(150, 150, 150))
            cc.ui.UIPushButton.super.setButtonEnabled(obj,false)
        end
    end
    btn:onButtonClicked(function()
        btn:setButtonEnabled(false)
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self:onAddFastBtnHandler(btn)
    end)
    return btn
end

function OperationManager:onAddFastBtnHandler(btn)
    if btn==self.blind3Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*3*2)
    elseif btn==self.blind4Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*4*2)
    elseif btn==self.totalChipsInTable_ then
        self:onRaiseSliderButtonClicked_(1)
    elseif btn==self.blind5Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*5*2)
    elseif btn==self.blind10Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*10*2)
    elseif btn==self.blind25Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*25*2)
    elseif btn==self.blind50Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*50*2)
    elseif btn==self.blind100Btn_ then
        self:filterCallAction(self.model.roomInfo.blind*100*2)
    elseif btn==self.addConfirmBtn_ then
        if self.raiseSlider_:isVisible() then
            self:filterCallAction(self.raiseSlider_:getValue())
        end
    end
    self.raiseSlider_:hidePanel()
    self:disabledStatus_()
    if self.addNode_ then
        self.addNode_:hide()
    end
end

function OperationManager:dispose()
    self.schedulerPool_:clear(self.showOptSchedulerId)
end

function OperationManager:showOperationButtons(animation)
    self.showOped_ = true
    self.oprNode_:stopAllActions()
    if animation then
        self.oprNode_:show():moveTo(0.5, display.right - 8, display.bottom + 48)
        transition.moveTo(self.tipsView_, {y = -80, time=0.5, onComplete=function() self.tipsView_:hide():stop() end})
    else
        self.oprNode_:show():pos(display.right - 8, display.bottom + 44)
        self.tipsView_:hide():stop():setPositionY(-80)
    end
    self:dealFastExp_()
end

function OperationManager:hideOperationButtons(animation)
    self.showOped_ = false
    self.oprNode_:stopAllActions()
    if animation then
        self.tipsView_:show():play():moveTo(0.5, display.right - 8 - RoomTipsView.WIDTH * 0.5, display.bottom + 44)
        transition.moveTo(self.oprNode_, {y=-80, time=0.5, onComplete=function() self.oprNode_:hide() end})
    else
        self.oprNode_:hide():setPositionY(-80)
        self.tipsView_:show():play():setPositionY(display.bottom + 44)
    end
    self:dealFastExp_()
end

function OperationManager:blockOperationButtons()
    self:disabledStatus_()
end

function OperationManager:resetAutoOperationStatus()
    self.checkGroup_:onChecked(nil):uncheck()
    self.autoAction_ = nil
end

function OperationManager:updateOperationStatus()
    local callChips = self.model.gameInfo.callChips
    local minRaiseChips = self.model.gameInfo.minRaiseChips
    local maxRaiseChips = self.model.gameInfo.maxRaiseChips
    local bettingSeatId = self.model.gameInfo.bettingSeatId
    local selfSeatId = self.model:selfSeatId()
    printf("updateOperationStatus==> %s=%s", "callChips", callChips)
    printf("updateOperationStatus==> %s=%s", "minRaiseChips", minRaiseChips)
    printf("updateOperationStatus==> %s=%s", "maxRaiseChips", maxRaiseChips)
    printf("updateOperationStatus==> %s=%s", "bettingSeatId", bettingSeatId)
    printf("updateOperationStatus==> %s=%s", "isSelfInSeat", self.model:isSelfInSeat())
    printf("updateOperationStatus==> %s=%s", "isSelfInGame", self.model:isSelfInGame())

    self.schedulerPool_:clear(self.showOptSchedulerId)
    self.oprNode_:show()
    if not self.model:isSelfInSeat() or not self.model:isSelfInGame() or bettingSeatId == -1 then
        --自己不在座 或 自己不在游戏 或 没在下注
        self:disabledStatus_()
    else
        local seatChips = self.model:selfSeatData().seatChips
        printf("updateOperationStatus==> %s=%s", "seatChips", seatChips)
        if selfSeatId == bettingSeatId then
            --轮到自己操作
            if self:applyAutoOperation_() then
                --自动操作已经触发，则直接禁用操作栏
                printf("updateOperationStatus==> %s=%s", "applyAutoOperation_", true)
                self:disabledStatus_()
            else
                printf("updateOperationStatus==> %s=%s", "applyAutoOperation_", false)
                if callChips > 0 then
                    --需要下注
                    if seatChips > callChips then
                        --有钱足够加注
                        if minRaiseChips == maxRaiseChips then
                            --没有加注空间
                            if callChips == minRaiseChips then
                                --加注和跟注值是一样的，当做不能加注处理
                                self:selfCannotRaiseStatus_()
                            else
                                self:selfCanRaiseFixedStatus_(minRaiseChips)
                            end
                        else
                            --有加注空间
                            self:selfCanRaiseStatus_(minRaiseChips, maxRaiseChips)
                        end
                    else
                        --自己没钱加注
                        self:selfCannotRaiseStatus_()
                    end
                else
                    --不需要下注
                    if minRaiseChips == maxRaiseChips then
                        --没有加注空间
                        self:selfNoBetCanRaiseFixedStatus_(minRaiseChips)
                    else
                        --有加注空间
                        self:selfNoBetCanRaiseStatus_(minRaiseChips, maxRaiseChips)
                    end
                end
            end
        else
            --轮到别人操作
            if seatChips > 0 then
                --自己没有all in
                if self.model.gameInfo.hasRaise then
                    --有加注
                    self:otherBetStatus_(math.min(self.model:currentMaxBetChips() - self.model:selfSeatData().betChips, self.model:selfSeatData().seatChips))
                elseif self.model.gameInfo.bettingSeatId ~= -1 and self.model:selfSeatData() then
                    --没有加注
                    self:otherNoBetStatus_(self.model.playerList[self.model.gameInfo.bettingSeatId].betChips - self.model:selfSeatData().betChips)
                end
            else
                --自己已经all in
                self:disabledStatus_()
            end
        end
    end
    self.raiseSlider_:hidePanel()
    if self.addNode_ then
        self.addNode_:hide()
    end
    self:dealFastExp_()
end

function OperationManager:setSliderStatus(minRaiseChips, maxRaiseChips)
    local selfSeatData = self.model:selfSeatData()
    local totalChipsInTable = self.model:totalChipsInTable()
    local currentMaxBetChips = self.model:currentMaxBetChips()
    print("totalChipsInTable -----> " .. totalChipsInTable)
    print("currentMaxBetChips ----> " .. currentMaxBetChips)
    self.raiseSlider_:setButtonStatus(
        totalChipsInTable >= minRaiseChips and totalChipsInTable <= maxRaiseChips,                 --全部奖池按钮
        totalChipsInTable * 0.75 >= minRaiseChips and totalChipsInTable * 0.75 <= maxRaiseChips,--3/4奖池按钮
        totalChipsInTable * 0.5 >= minRaiseChips and totalChipsInTable * 0.5 <= maxRaiseChips,    --1/2奖池按钮
        currentMaxBetChips * 3 >= minRaiseChips and currentMaxBetChips * 3 <= maxRaiseChips,    --3倍反加按钮
        maxRaiseChips == selfSeatData.seatChips                                              --最大加注是否allin
    )
    self.raiseSlider_:setValueRange(minRaiseChips, maxRaiseChips, self.model.roomInfo.blind*2)
end

--无法操作的状态
function OperationManager:disabledStatus_()
    self.oprBtn1_:setLabel(self.LB_CHECK_):setEnabled(false):setCheckMode(false)
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(false):setCheckMode(false)
    self.oprBtn3_:setLabel(self.LB_RAISE_):setEnabled(false):setCheckMode(false)
    self.raiseSlider_:hidePanel()
    self.oprFastNode_:hide()
    self.chatBtn_:show()
    if self.addNode_ then
        self.addNode_:hide()
    end
    self:dealFastExp_()
end

-- 快捷表情
function OperationManager:dealFastExp_()
    -- 座位上，或者游戏结束
    if self.model and self.model:isSelfInSeat() and 
        (not self.model:isSelfInGame() or (self.model.gameInfo and self.model.gameInfo.gameStatus>=consts.SVR_GAME_STATUS.READY_TO_START)) then
        if not self.chatFastExp_ then
            local ChatFastExp = require("app.module.room.chat.ChatFastExp")
            self.chatFastExp_ = ChatFastExp.new()
                :pos(display.width*0.5+255,0)
                :addTo(self.scene.nodes.oprNode, 20, 20)
        end
        if self.chatFastExp_ then
            self.chatFastExp_:show()
        end
    else
        if self.chatFastExp_ then
            self.chatFastExp_:hide()
        end
    end
end

--轮到自己，可以加注状态
function OperationManager:selfCanRaiseStatus_(minRaiseChips, maxRaiseChips)
    local callMoney = 0
    local callChips = self.model.gameInfo.callChips
    local seatChips = self.model:selfSeatData().seatChips
    if seatChips>callChips then
        callMoney = callChips
    else
        callMoney = seatChips
    end
    self.oprBtn1_:setLabel(self.LB_CALL_..sa.formatBigNumber(callMoney)):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.callClickHandler))
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.foldClickHandler))
    self.oprBtn3_:setLabel(self.LB_RAISE_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseRangeClickHandler))
    self:setSliderStatus(minRaiseChips, maxRaiseChips)
    self.oprFastNode_:show()
    self.chatBtn_:hide()
end

--轮到自己，只能加固定注状态
function OperationManager:selfCanRaiseFixedStatus_(raiseChips)
    local callMoney = 0
    local callChips = self.model.gameInfo.callChips
    local seatChips = self.model:selfSeatData().seatChips
    if seatChips>callChips then
        callMoney = callChips
    else
        callMoney = seatChips
    end
    self.raiseFixedChips_ = raiseChips
    self.oprBtn1_:setLabel(self.LB_CALL_..sa.formatBigNumber(callMoney)):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.callClickHandler))
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.foldClickHandler))
    self.oprBtn3_:setLabel(string.format(self.LB_RAISE_NUM_, raiseChips),true):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseFixedClickHandler))
    self.oprFastNode_:show()
    self.chatBtn_:hide()
end

--轮到自己，不能加注状态
function OperationManager:selfCannotRaiseStatus_()
    local callMoney = 0
    local callChips = self.model.gameInfo.callChips
    local seatChips = self.model:selfSeatData().seatChips
    if seatChips>callChips then
        callMoney = callChips
        self.oprBtn3_:setLabel(string.format(self.LB_RAISE_NUM_, callMoney),true):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseFixedClickHandler))
    else
        callMoney = seatChips
        self.oprBtn3_:setLabel(sa.LangUtil.getText("ROOM", "ALL_IN"),true):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseFixedClickHandler))
    end
    self.raiseFixedChips_ = callMoney
    self.oprBtn1_:setLabel(self.LB_CALL_..sa.formatBigNumber(callMoney)):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.callClickHandler))
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.foldClickHandler))
    -- self.oprBtn3_:setLabel(self.LB_RAISE_):setEnabled(false):setCheckMode(false)
    self.oprFastNode_:show()
    self.chatBtn_:hide()
end

--轮到自己，桌面没有加注，可以选择加注
function OperationManager:selfNoBetCanRaiseStatus_(minRaiseChips, maxRaiseChips)
    self.oprBtn1_:setLabel(self.LB_CHECK_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.checkClickHandler))
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.foldClickHandler))
    self.oprBtn3_:setLabel(self.LB_RAISE_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseRangeClickHandler))
    self:setSliderStatus(minRaiseChips, maxRaiseChips)
    self.oprFastNode_:show()
    self.chatBtn_:hide()
end

--轮到自己，桌面没有加注，只能加固定的住
function OperationManager:selfNoBetCanRaiseFixedStatus_(raiseChips)
    self.raiseFixedChips_ = raiseChips
    self.oprBtn1_:setLabel(self.LB_CHECK_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.checkClickHandler))
    self.oprBtn2_:setLabel(self.LB_FOLD_):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.foldClickHandler))
    self.oprBtn3_:setLabel(string.format(self.LB_RAISE_NUM_, raiseChips)):setEnabled(true):setCheckMode(false):onTouch(handler(self, self.raiseFixedClickHandler))
    self.oprFastNode_:show()
    self.chatBtn_:hide()
end

--没轮到自己操作，且没有加注（自动看牌、看或弃、跟任何注）
function OperationManager:otherNoBetStatus_()
    self.checkGroup_:onChecked(function(id) 
        if id == 1 then
            self.autoAction_ = "CHECK";
        elseif id == 2 then
            self.autoAction_ = "CHECK_OR_FOLD"
        elseif id == 3 then
            self.autoAction_ = "CALL_ANY"
        else
            self.autoAction_ = nil
        end
    end)
    local checkedId = self.checkGroup_:getCheckedId()
    if self.oprBtn2_:getLabel() ~= self.LB_AUTO_CHECK_OR_FOLD_ and not (self.oprBtn3_:getLabel() == self.LB_AUTO_CALL_ANY_ and checkedId == 3)  then
        self.checkGroup_:uncheck()
    end
    self.oprBtn1_:setLabel(self.LB_AUTO_CHECK_):setEnabled(true):setCheckMode(true):onTouch(nil)
    self.oprBtn2_:setLabel(self.LB_AUTO_CHECK_OR_FOLD_):setEnabled(true):setCheckMode(true):onTouch(nil)
    self.oprBtn3_:setLabel(self.LB_AUTO_CALL_ANY_):setEnabled(true):setCheckMode(true):onTouch(nil)
    self.oprFastNode_:hide()
    self.chatBtn_:show()
end

--没轮到自己操作，有加注(跟XX注, 自动弃牌，跟任何注)
function OperationManager:otherBetStatus_(autoCallChips)
    self.autoCallChips_ = autoCallChips
    self.checkGroup_:onChecked(function(id) 
        if id == 1 then
            self.autoAction_ = "CALL";
        elseif id == 2 then
            self.autoAction_ = "FOLD"
        elseif id == 3 then
            self.autoAction_ = "CALL_ANY"
        else
            self.autoAction_ = nil
        end
    end)
    local checkedId = self.checkGroup_:getCheckedId()
    local lb = string.format(self.LB_AUTO_CALL_, autoCallChips)
    if self.oprBtn2_:getLabel() ~= self.LB_AUTO_FOLD_ and not (self.oprBtn3_:getLabel() == self.LB_AUTO_CALL_ANY_ and checkedId == 3) 
        or checkedId == 1 and lb ~= self.oprBtn1_:getLabel() then
        self.checkGroup_:uncheck()
    end
    self.oprBtn1_:setLabel(lb):setEnabled(true):setCheckMode(true):onTouch(nil)
    self.oprBtn2_:setLabel(self.LB_AUTO_FOLD_):setEnabled(true):setCheckMode(true):onTouch(nil)
    self.oprBtn3_:setLabel(self.LB_AUTO_CALL_ANY_):setEnabled(true):setCheckMode(true):onTouch(nil)

    self.oprFastNode_:hide()
    self.chatBtn_:show()
end

function OperationManager:filterCallAction(callMoney)
    local callChips = self.model.gameInfo.callChips
    local minRaiseChips = self.model.gameInfo.minRaiseChips
    local maxRaiseChips = self.model.gameInfo.maxRaiseChips
    local bettingSeatId = self.model.gameInfo.bettingSeatId
    local selfSeatId = self.model:selfSeatId()
    if selfSeatId==bettingSeatId then
        local seatChips = self.model:selfSeatData().seatChips
        if callMoney==seatChips then  -- ALL IN
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.ALL_IN, callMoney)
        elseif callMoney>callChips then
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.RAISE, callMoney)
        else
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.CALL, callMoney)
        end            
    end
end

function OperationManager:checkClickHandler(evt)
    if evt == sa.TouchHelper.CLICK then
        tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.CHECK, 0)
        self:disabledStatus_()
    end
end

function OperationManager:foldClickHandler(evt)
    if evt == sa.TouchHelper.CLICK then
        tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.FOLD, 0)
        self:disabledStatus_()
    end
end

function OperationManager:callClickHandler(evt)
    if evt == sa.TouchHelper.CLICK then
        self:filterCallAction(self.model.gameInfo.callChips)
        self:disabledStatus_()
    end
end

function OperationManager:raiseFixedClickHandler(evt)
    if evt == sa.TouchHelper.CLICK then
        if self.oprBtn3_.isAllIn then
            self:filterCallAction(self.raiseFixedChips_)
            self:disabledStatus_()
            return
        end
        self:filterCallAction(self.raiseFixedChips_)
        self:disabledStatus_()
    end
end

function OperationManager:raiseRangeClickHandler(evt)
    if evt == sa.TouchHelper.CLICK then
        if self.raiseSlider_:isVisible() then
            self:filterCallAction(self.raiseSlider_:getValue())
            self:disabledStatus_()
        else
            self.oprNode_:hide()
            -- 点击桌面回退
            if not self.addNode_ then
                local startX = self.normalBtnWidth_*0.5 + self.normalPadding_
                local itemWidth = self.normalBtnWidth_+self.normalPadding_
                self.addNode_ = display.newNode()
                    :pos(2, display.bottom + 44)
                    :addTo(self.scene.nodes.oprNode, 6, 6)
                self.addNode_:setContentSize(cc.size(316,65))
                self.blind5Btn_ = self:createAddFastBtn()
                self.blind5Btn_:pos(startX, 0):addTo(self.addNode_)
                self.blind5Btn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.model.roomInfo.blind*5*2))
                self.blind10Btn_ = self:createAddFastBtn()
                self.blind10Btn_:pos(startX+itemWidth, 0):addTo(self.addNode_)
                self.blind10Btn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.model.roomInfo.blind*10*2))
                self.blind25Btn_ = self:createAddFastBtn()
                self.blind25Btn_:pos(startX+itemWidth*2, 0):addTo(self.addNode_)
                self.blind25Btn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.model.roomInfo.blind*25*2))
                self.blind50Btn_ = self:createAddFastBtn()
                self.blind50Btn_:pos(startX+itemWidth*3, 0):addTo(self.addNode_)
                self.blind50Btn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.model.roomInfo.blind*50*2))
                self.blind100Btn_ = self:createAddFastBtn()
                self.blind100Btn_:pos(startX+itemWidth*4, 0):addTo(self.addNode_)
                self.blind100Btn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.model.roomInfo.blind*100*2))
                self.addConfirmBtn_ = self:createAddFastBtn(2)

                local coord = cc.p(startX+itemWidth*4+self.normalBtnWidth_*0.5+self.normalPadding_+self.mainBtnWidth_*0.5, 0)
                coord = self.addNode_:convertToWorldSpace(coord)
                coord = self.raiseSlider_:convertToNodeSpace(coord)
                self.addConfirmBtn_:pos(coord.x,coord.y):addTo(self.raiseSlider_)

                self.raiseSlider_:setAddBtn(self.addConfirmBtn_)
                self:setAddBtnStatus()
            end
            self.raiseSlider_:showPanel()
            self.addNode_:show()
        end
    end
end

-- 勾选了自动看牌跟注等，在这里自动发包
function OperationManager:applyAutoOperation_()
    local autoAction = self.autoAction_
    local appliedAction = true
    if autoAction == "CHECK" then
        if self.model.gameInfo.callChips == 0 then
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.CHECK, 0)
        else
            appliedAction = false
        end
    elseif autoAction == "CHECK_OR_FOLD" then
        if self.model.gameInfo.callChips > 0 then
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.FOLD, 0)
        else
            tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.CHECK, 0)
        end
    elseif autoAction == "CALL_ANY" then
        if self.model.gameInfo.callChips > 0 then
            self:filterCallAction(self.model.gameInfo.callChips)
        else
            appliedAction = false
        end
    elseif autoAction == "CALL" then
        if self.autoCallChips_ == self.model.gameInfo.callChips then
            self:filterCallAction(self.model.gameInfo.callChips)
        else
            appliedAction = false
        end
    elseif autoAction == "FOLD" then
        tx.socket.HallSocket:sendGameCmd("sendBet",consts.CLI_BET_TYPE.FOLD, 0)
    else
        appliedAction = false
    end

    self.checkGroup_:onChecked(nil):uncheck()
    self.autoAction_ = nil

    if appliedAction then
        self:disabledStatus_()
    end

    return appliedAction
end

function OperationManager:onRaiseSliderButtonClicked_(tag)
    local totalChipsInTable = self.model:totalChipsInTable()
    if tag == 1 then
        self:filterCallAction(totalChipsInTable)
    elseif tag == 2 then
        self:filterCallAction(totalChipsInTable * 0.75)
    elseif tag == 3 then
        self:filterCallAction(totalChipsInTable * 0.5)
    elseif tag == 4 then
        self:filterCallAction(self.model:currentMaxBetChips() * 3)
    elseif tag == 5 then
        self:filterCallAction(self.raiseSlider_:getValue())
    elseif tag == 6 then
        self:filterCallAction(self.raiseSlider_:getValue())
    end
    self.raiseSlider_:hidePanel()
    self:disabledStatus_()
    if self.addNode_ then
        self.addNode_:hide()
    end
end

function OperationManager:onBackgroundClicked()
    self.raiseSlider_:hidePanel()
    if self.addNode_ then
        self.addNode_:hide()
    end
    if self.showOped_ then
        self.oprNode_:show()
    end
end

function OperationManager:setAddBtnStatus()
    local callChips = self.model.gameInfo.callChips
    local minRaiseChips = self.model.gameInfo.minRaiseChips
    local maxRaiseChips = self.model.gameInfo.maxRaiseChips
    local bettingSeatId = self.model.gameInfo.bettingSeatId
    local seatChips = self.model:selfSeatData().seatChips
    -- 翻倍基数
    local multiBase = callChips
    if multiBase>0 then
        multiBase = minRaiseChips
    end

    local blind = self.model.roomInfo.blind * 2  --大盲
    local totalChipsInTable = self.model:totalChipsInTable()
    local currentMaxBetChips = self.model:currentMaxBetChips()
    self.totalChipsInTable_:setButtonEnabled(seatChips>=totalChipsInTable and totalChipsInTable<=maxRaiseChips)
    self.blind3Btn_:setButtonEnabled(blind*3>=multiBase and seatChips>=blind*3 and blind*3<=maxRaiseChips)
    self.blind4Btn_:setButtonEnabled(blind*4>=multiBase and seatChips>=blind*4 and blind*4<=maxRaiseChips)
    if self.blind5Btn_ then
        self.blind5Btn_:setButtonEnabled(blind*5>=multiBase and seatChips>=blind*5 and blind*5<=maxRaiseChips)
    end
    if self.blind10Btn_ then
        self.blind10Btn_:setButtonEnabled(blind*10>=multiBase and seatChips>=blind*10 and blind*10<=maxRaiseChips)
    end
    if self.blind25Btn_ then
        self.blind25Btn_:setButtonEnabled(blind*25>=multiBase and seatChips>=blind*25 and blind*25<=maxRaiseChips)
    end
    if self.blind50Btn_ then
        self.blind50Btn_:setButtonEnabled(blind*50>=multiBase and seatChips>=blind*50 and blind*50<=maxRaiseChips)
    end
    if self.blind100Btn_ then
        self.blind100Btn_:setButtonEnabled(blind*100>=multiBase and seatChips>=blind*100 and blind*100<=maxRaiseChips)
    end
    if self.addConfirmBtn_ then
        self.addConfirmBtn_:setButtonEnabled(true)
    end
end

--创建显示手牌按钮
function OperationManager:createShowCardBtn_(index, callback)
    local btn_w, btn_h = 112, 151
    local x, y = self.showCardBtnPos_[index].x, self.showCardBtnPos_[index].y
    local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})--"#texas/room/room_seat_bg.png"
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(callback)
        :setDelayTouchEnabled(false)
        :pos(x, y)
        :addTo(self.showCardNode_)
        :hide()
    btn:setTag(index)
        
    local icon = display.newSprite("#texas/room/hand_card_show.png")
        :align(display.LEFT_BOTTOM,-btn_w*0.5 - 5, -btn_h*0.5)
        :addTo(btn)

    return btn, icon
end

--按钮点击
function OperationManager:onShowCardClicked_(evt)
    local tag = evt.target:getTag()
    local cardStatus = self.showCardStatus_
    if cardStatus[tag] == true then
        cardStatus[tag] = false
    else
        cardStatus[tag] = true
    end

    -- 刚重置完还在点击
    if self.showCardReSet_ == true then
        cardStatus[tag] = false
        self:hideAllShowCardBtn_()
    else
        self:setShowCardStatus()
    end
end

--设置手牌是否为选中状态
function OperationManager:setCardSelectedStatus_(isSelected)
    for i = 1, self.handCardNum_ do
        self.showCardStatus_[i] = isSelected
    end
end

--是否选择需要显示的手牌
function OperationManager:isSelectedHandCard_()
    for _,v in ipairs(self.showCardStatus_) do
        if v == true then
            return true
        end
    end

    return false
end

--隐藏所有亮牌按钮
function OperationManager:hideAllShowCardBtn_()
    for _,v in ipairs(self.showCardBtnList_) do
        v:hide()
    end

    self.showCardBtn_:hide()
end

return OperationManager