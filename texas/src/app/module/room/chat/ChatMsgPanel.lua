local ChatMsgShortcutListItem = import(".ChatMsgShortcutListItem")
local ChatMsgToListItem = import(".ChatMsgToListItem")
local ChatMsgHistoryListItem = import(".ChatMsgHistoryListItem")

local ChatMsgPanel = class("ChatMsgPanel", function() return display.newNode() end)
local ExpressionConfig = import(".ExpressionConfig").new()

local EXP_WIDTH,EXP_HEIGHT = 454, 600
local OTHER_WIDTH,OTHER_HEIGHT = 454,688
-- 全拼缩放
local ViewScale = display.height/800
ViewScale = 1
local THE_ROOM_TYPE = 1
local THE_LABA_TYPE = 2

local GROUP_BTNS = {
    {
        "#common/transparent.png",
        "#expression_btn_11.png",
        0.6,
    },
    {
        "#common/transparent.png",
        "#expression_btn_335.png",
        0.5,
    },
    {
        "#common/transparent.png",
        "#expression_btn_21.png",
        0.7,
    },
    {
        "#common/transparent.png",
        "#expression_btn_410.png",
        0.4,
    },
}

ChatMsgPanel.ELEMENTS = {
    "bg",
    "main.nodeBottom.bgInput",
    "main.nodeBottom.editAt",
    "main.nodeBottom.edit.btnAt",
    "main.nodeBottom.btnSend.labelSend",
    "main.nodeBottom.btnBack",
    "main.nodeBottom.btnMicrophone",

    "main.nodeExp.nodeExpList",
    "main.nodeFastList",
    "main.nodeRecordList",
    "main.nodeToList",

    "main.nodeGroup.top.icon",
    "main.nodeGroup.middle.icon",
    "main.nodeGroup.bottom.icon",
    "main.nodeGroup.bottom2.icon",
}

function ChatMsgPanel:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self,"dialog_room_chat.csb",true)
    self.bg:setTouchEnabled(true)
    ImgButton(self.main.nodeBottom.edit.btnAt,"#dialogs/chat/room_chat_at.png","#dialogs/chat/room_chat_at_down.png"):onButtonClicked(function( ... )
        self:setShowAtView(true)
    end)
    ImgButton(self.main.nodeBottom.btnBack,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png"):onButtonClicked(function( ... )
        self:setShowAtView(false)
    end)
    -- 语音功能关闭
    if not tx.VoiceSDK or not tx.VoiceSDK.open then
        self.main.nodeBottom.btnMicrophone:hide()
        self.main.nodeBottom.btnMicrophone.show = function()
            self.main.nodeBottom.btnMicrophone:hide()
        end
        self.main.nodeBottom.edit.btnAt:setPositionX(-50)
        self.main.nodeBottom.edit.btnAt:scale(1.2)
    end
    ImgButton(self.main.nodeBottom.btnMicrophone,"#common/microphone_btn.png","#common/microphone_btn_down.png")
        :onButtonPressed(function(evt)
            if not tx.VoiceSDK or not tx.VoiceSDK.open then
                tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
                return; 
            end
            self.main.nodeBottom.btnMicrophone:stopAllActions()
            self.main.nodeBottom.btnMicrophone:setOpacity(255)
            self.main.nodeBottom.btnMicrophone:runAction(
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
            if not tx.VoiceSDK or not tx.VoiceSDK.open then
                return; 
            end
            if self.microphoneIsTouching_ then
                local y = evt.y
                if y<self.microphoneTouchY_ then --往下移动
                    self.microphoneTouchY_ = y
                    return
                end
                if y-self.microphoneTouchY_>40 then
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_CANCELED"))
                    self.main.nodeBottom.btnMicrophone:stopAllActions()
                    self.main.nodeBottom.btnMicrophone:setOpacity(255)
                    self.microphoneIsTouching_ = nil
                    tx.voiceRecordAnim:hide()
                    tx.VoiceSDK:cancelRecordedVoice()
                end
            end
        end)
        :onButtonRelease(function(evt)
            if not tx.VoiceSDK or not tx.VoiceSDK.open then
                return; 
            end
            self.main.nodeBottom.btnMicrophone:stopAllActions()
            self.main.nodeBottom.btnMicrophone:setOpacity(255)
            tx.voiceRecordAnim:hide()
            tx.VoiceSDK:stopRecordVoice()
            self.microphoneIsTouching_ = nil
            -- -- 测试模拟数据哦
            -- local ret = {
            --     error = 1,
            --     downloadUrl = "http://giant.audio.mztgame.com/upload/2017122717/27582e876e0c",
            --     duration = 3,
            --     voiceText = "abcef",
            -- }
            -- sa.EventCenter:dispatchEvent({name="RECORD_VOICE_COMPLETE", data=ret})
        end)
    self.main.nodeBottom.btnSend.labelSend:setString(sa.LangUtil.getText("COMMON", "SEND"))
    ImgButton(self.main.nodeBottom.btnSend,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png"):onButtonClicked(function( ... )
        self.inputText_ = ""
        if self.editAtBox_ and self.editAtBox_:isVisible() then
            self.inputText_ = self.editAtBox_:getText()
        elseif self.editBox_ and self.editBox_:isVisible() then
            self.inputText_ = self.editBox_:getText()
        end
        self:onSendClicked_()
    end)
    self.editBox_ = EditLabel(self.main.nodeBottom.edit,cc.c3b(0xb7, 0xc8, 0xd4),32):setReturnHandler(function(evt)
        if evt=="return" then
            if device.platform == "android" then  -- ios不发送
                self.inputText_ = self.editBox_:getText()
                self:onSendClicked_()
            end
        end
    end)
    self.editAtBox_ = EditLabel(self.main.nodeBottom.editAt,cc.c3b(0xb7, 0xc8, 0xd4),32):setReturnHandler(function(evt)
        if evt=="return" then
            if device.platform == "android" then  -- ios不发送
                self.inputText_ = self.editAtBox_:getText()
                self:onSendClicked_()
            end
        end
    end)
    -- 保留原来输入的文字
    local originalShow = self.editAtBox_.show
    self.editAtBox_.show = function(obj)
        local str = self.editBox_:getText() or ""
        self.editAtBox_:setText(str)
        originalShow(obj)
    end

    if device.platform == "ios" then
        self.editBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        self.editAtBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    else
        self.editBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self.editAtBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    end
    self.editAtBox_:hide()

    self.leftGroup_ = tx.ui.CheckBoxButtonGroup.new()
    self.leftGroup_:addButton(ChkBoxButton(ImgButton(self.main.nodeGroup.top,"#common/transparent.png","#common/transparent.png","#dialogs/chat/room_chat_left_middle.png")))
    self.leftGroup_:addButton(ChkBoxButton(ImgButton(self.main.nodeGroup.middle,"#common/transparent.png","#common/transparent.png","#dialogs/chat/room_chat_left_middle.png")))
    self.leftGroup_:addButton(ChkBoxButton(ImgButton(self.main.nodeGroup.bottom,"#common/transparent.png","#common/transparent.png","#dialogs/chat/room_chat_left_middle.png")))
    self.leftGroup_:addButton(ChkBoxButton(ImgButton(self.main.nodeGroup.bottom2,"#common/transparent.png","#common/transparent.png","#dialogs/chat/room_chat_left_middle.png")))
    self.leftGroup_:onButtonSelectChanged(function(evt)
        local selected = evt.selected
        ChatMsgPanelIndex = selected
        self.main.nodeGroup.top.icon:setSpriteFrame("dialogs/chat/room_chat_exp.png")
        self.main.nodeGroup.middle.icon:setSpriteFrame("dialogs/chat/room_chat_fast.png")
        self.main.nodeGroup.bottom.icon:setSpriteFrame("dialogs/chat/room_chat_record.png")
        self.main.nodeGroup.bottom2.icon:setSpriteFrame("dialogs/chat/room_chat_laba.png")
        self.main.nodeExp:hide()
        self.main.nodeFastList:hide()
        self.main.nodeRecordList:hide()
        self.main.nodeToList:hide()
        self.editBox_:show()
        self.editAtBox_:hide()
        self.main.nodeBottom.btnMicrophone:show()
        self.main.nodeBottom.btnBack:hide()
        self.main.nodeBottom.edit.btnAt:show()
        if ChatMsgPanelIndex==1 then
            self.main.nodeExp:show()
            self.main.nodeGroup.top.icon:setSpriteFrame("dialogs/chat/room_chat_exp_select.png")
            self:createExpPage_()
        elseif ChatMsgPanelIndex==2 then
            self.main.nodeFastList:show()
            self.main.nodeGroup.middle.icon:setSpriteFrame("dialogs/chat/room_chat_fast_select.png")
            self:createShortcutPage_()
        elseif ChatMsgPanelIndex==3 then
            self.main.nodeRecordList:show()
            self.main.nodeGroup.bottom.icon:setSpriteFrame("dialogs/chat/room_chat_record_select.png")
            self:createHistoryPage_(THE_ROOM_TYPE)
        elseif ChatMsgPanelIndex==4 then
            self.main.nodeBottom.edit.btnAt:hide()
            self.editBox_:hide()
            self.editAtBox_:show()
            self.main.nodeRecordList:show()
            self.main.nodeGroup.bottom2.icon:setSpriteFrame("dialogs/chat/room_chat_laba_select.png")
            self:createHistoryPage_(THE_LABA_TYPE)
        end
    end)
    if not ChatMsgPanelIndex then
        ChatMsgPanelIndex = 1
    end
    self.leftGroup_:getButtonAtIndex(ChatMsgPanelIndex):setButtonSelected(true)

    if self.toPlayer then
        local name = string.format("@%s ",self.toPlayer.nick)
        self.editBox_:setText(name)
        self.inputText_ = name
    end
    self.toPlayer = nil
end

function ChatMsgPanel:ctor(ctx,toPlayer)
    self:setNodeEventEnabled(true)
    self.ctx = ctx
    self.toPlayer = toPlayer
    self:initViews_()
    self:setScale(ViewScale)
end

function ChatMsgPanel:chageExpBtnImg(index)
    if not index then return end
    local btn = self.subGroup_ and self.subGroup_:getButtonAtIndex(index)
    if btn and btn.options and not btn.icon then
        local sprite = display.newSprite(btn.options[2])
            :addTo(btn)
        sprite:setScale(btn.options[3])
        if index~=ChatMsgPanelExpIndex then
            btn:setColor(cc.c3b(150, 150, 150))
        end
    end
end

function ChatMsgPanel:createExpPage_()
    if self.subGroup_ then return; end
    --表情tab
    self.subGroup_ = tx.ui.CheckBoxButtonGroup.new()

    -- GROUP_BTNS的坐标要根据长度来显示  坑爹
    local btnX = {50, 170, 290, 385}
    local btnY = {-47, -47, -40, -42}
    local priceY = {0, 0, -35, -33}
    local expression = tx.userData.vipinfo.expression
    local vipPrice = {0, 0, expression.dog, expression.ant}
    if appconfig.LANG ~= "th" then
        btnX = {50, 170, 170, 290}
        if ChatMsgPanelExpIndex and ChatMsgPanelExpIndex == 2 then
            ChatMsgPanelExpIndex = 1
        end
    end

    for i, v in ipairs(GROUP_BTNS) do
        local chkBox = cc.ui.UICheckBoxButton.new({off=v[1]})
            :pos(btnX[i], btnY[i])
            :addTo(self.main.nodeExp)
        self.subGroup_:addButton(chkBox)

        if i == 2 and appconfig.LANG ~= "th" then
            chkBox:hide()
        end

        if i > 2 then
            display.newSprite("#commonroom/vip_mark_icon.png")
                :pos(20, 23)
                :addTo(chkBox, 1)

            if not tx.checkIsVip() then
                local frame_w, frame_h = 80, 28
                chkBox.price = display.newScale9Sprite("#commonroom/vip_exp_price_frame.png", 0, 0, cc.size(frame_w, frame_h))
                    :pos(0, priceY[i])
                    :addTo(chkBox, 1)

                ui.newTTFLabel({text = vipPrice[i], size = 20})
                    :pos(frame_w*0.5, frame_h*0.5)
                    :addTo(chkBox.price)
            end
        end

        -- 动态赋值
        chkBox.options = v
    end

    self.subGroup_:onButtonSelectChanged(function(event)
        local index = event.selected
        ChatMsgPanelExpIndex = index
        for i=1, 5 do
            local chkBox = self.subGroup_:getButtonAtIndex(i)
            if chkBox then
                if index==i then
                    chkBox:setColor(display.COLOR_WHITE)
                else
                    chkBox:setColor(cc.c3b(100, 100, 100))
                end
            end
        end
        local page = self.main.nodeExp.nodeExpList

        if index == 1 then
            display.addSpriteFrames("expressionsbtns_1.plist", "expressionsbtns_1.png", function()
                self:createExpression_(page, 1, 1)
            end)
        elseif index == 2 then
            display.addSpriteFrames("expressionsbtns_3.plist", "expressionsbtns_3.png", function()
                self:createExpression_(page, 2, 3)
            end)
        elseif index == 3 then
            display.addSpriteFrames("expressionsbtns_2.plist", "expressionsbtns_2.png", function()
                self:createExpression_(page, 3, 2)
            end)
        elseif index == 4 then
            display.addSpriteFrames("expressionsbtns_4.plist", "expressionsbtns_4.png", function()
                self:createExpression_(page, 4, 4)
            end)
        end
    end)

    display.addSpriteFrames("expressionsbtns_1.plist", "expressionsbtns_1.png", function()
        self:chageExpBtnImg(1)
    end)
    display.addSpriteFrames("expressionsbtns_3.plist", "expressionsbtns_3.png", function()
        self:chageExpBtnImg(2)
    end)
    display.addSpriteFrames("expressionsbtns_2.plist", "expressionsbtns_2.png", function()
        self:chageExpBtnImg(3)
    end)
    display.addSpriteFrames("expressionsbtns_4.plist", "expressionsbtns_4.png", function()
        self:chageExpBtnImg(4)
    end)

    if not ChatMsgPanelExpIndex then --全局，记录上次打开的类型
        ChatMsgPanelExpIndex = 1
    end

    self.subGroup_:getButtonAtIndex(ChatMsgPanelExpIndex):setButtonSelected(true)

    return page
end

function ChatMsgPanel:createShortcutPage_()
    --快捷消息
    if not self.shortcutMsgList_ then
        local listW, listH = OTHER_WIDTH, OTHER_HEIGHT
        self.shortcutMsgStringArr_ = sa.LangUtil.getText("ROOM", "CHAT_SHORTCUT")
        ChatMsgShortcutListItem.WIDTH = listW
        ChatMsgShortcutListItem.HEIGHT = 105
        ChatMsgShortcutListItem.ON_ITEM_CLICKED_LISTENER = buttontHandler(self, self.onChatShortcutClicked_)
        self.shortcutMsgList_ = sa.ui.ListView.new({
                viewRect = cc.rect(-0.5 * listW, -0.5 * listH, listW, listH),
                direction = sa.ui.ListView.DIRECTION_VERTICAL,
                scrollBar = display.newScale9Sprite("#dialogs/chat/slider_bar.png", 0, 0, cc.size(10, 54))
            }, ChatMsgShortcutListItem)
        self.shortcutMsgList_:addTo(self.main.nodeFastList)
        self.shortcutMsgList_:setData(self.shortcutMsgStringArr_)
    end
end

function ChatMsgPanel:createHistoryPage_(type)
    self.historyType_ = type  --历史消息类型
    --快捷消息
    if not self.historyList_ then
        local listW, listH = OTHER_WIDTH, OTHER_HEIGHT
        ChatMsgHistoryListItem.WIDTH = listW
        self.historyList_ = sa.ui.ListView.new({
                viewRect = cc.rect(-0.5 * listW, -0.5 * listH, listW, listH),
                direction = sa.ui.ListView.DIRECTION_VERTICAL,
                scrollBar = display.newScale9Sprite("#dialogs/chat/slider_bar.png", 0, 0, cc.size(10, 54))
            }, ChatMsgHistoryListItem)
        self.historyList_:addTo(self.main.nodeRecordList)
    end
    self:historyChanged_(nil)
end

function ChatMsgPanel:onChatShortcutClicked_(msg,index)
    if tx.userData.silenced == 1 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "USER_SILENCED_MSG"))
        return
    end
    if not self.ctx.model:isSelfInSeat() then
        if not self.ctx.model.standChatCount then
            self.ctx.model.standChatCount = 0;
        end
        self.ctx.model.standChatCount = self.ctx.model.standChatCount + 1
        if self.ctx.model.standChatCount>3 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHAT_MUST_BE_IN_SEAT"))
            self:hidePanel()
            return;
        end
    end
    tx.socket.HallSocket:sendChatMsg(msg,index)
    self:hidePanel()
end

function ChatMsgPanel:onEnter()
    self.historyWatcher_ = sa.DataProxy:addDataObserver(tx.dataKeys.ROOM_CHAT_HISTORY, handler(self, self.historyChanged_))
    self.bigLaBaMessageWatacher_ = sa.DataProxy:addDataObserver(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY, handler(self, self.historyChanged_))
end

function ChatMsgPanel:onExit()
    sa.DataProxy:removeDataObserver(tx.dataKeys.ROOM_CHAT_HISTORY, self.historyWatcher_)
    sa.DataProxy:removeDataObserver(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY, self.bigLaBaMessageWatacher_)
    if self.laBaNumberRequestId_ then
        sa.HttpService.CANCEL(self.laBaNumberRequestId_)
    end
end

function ChatMsgPanel:historyChanged_(list)
    if self.historyList_ then
        local mergedList = {}
        if self.historyType_==THE_LABA_TYPE then
            table.insertto(mergedList, sa.DataProxy:getData(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY) or {})
        else
            table.insertto(mergedList, sa.DataProxy:getData(tx.dataKeys.ROOM_CHAT_HISTORY) or {})
            table.insertto(mergedList, sa.DataProxy:getData(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY) or {})
        end
        table.sort(mergedList, function(o1, o2)
            return o1.time < o2.time
        end)
        self.historyList_:setData(mergedList)
        self.historyList_:scrollTo(1000000) --移动到最底部 默认很大
    end
end

function ChatMsgPanel:onSelectTo_(player)
    local str = self.editBox_:getText()
    str = string.format("@%s %s",player.nick,str)
    self.editBox_:setText(str)
    self.inputText_ = str
    self:setShowAtView(false)
end

function ChatMsgPanel:setShowAtView(value)
    if value then
        self.editBox_:hide()
        self.editAtBox_:show()
        self.main.nodeBottom.btnMicrophone:hide()
        self.main.nodeBottom.btnBack:show()
        self.main.nodeExp:hide()
        self.main.nodeFastList:hide()
        self.main.nodeRecordList:hide()
        self.main.nodeToList:show()
        if not self.sendToList_ then
            -- 头像选择列表
            local listW, listH = OTHER_WIDTH,OTHER_HEIGHT
            ChatMsgToListItem.WIDTH = listW
            ChatMsgToListItem.HEIGHT = 112
            ChatMsgToListItem.ON_ITEM_CLICKED_LISTENER = buttontHandler(self, self.onSelectTo_)
            self.sendToList_ = sa.ui.ListView.new({
                    viewRect = cc.rect(-0.5 * listW, -0.5 * listH, listW, listH),
                    direction = sa.ui.ListView.DIRECTION_VERTICAL,
                }, ChatMsgToListItem)
            self.sendToList_:addTo(self.main.nodeToList)
        end
        local str = self.editBox_:getText()
        self.inputText_ = str
        -- 刷新list
        local list = {}
        local players = self.ctx.model.playerList
        for i = 0, 9 do
            local player = (players and players[i])
            if player and not player.isSelf and player.uid >1 then
                table.insert(list,player)
            end
        end
        self.sendToList_:setData(list)
        self.sendToList_:setScrollContentTouchRect()
    else
        self.main.nodeBottom.btnMicrophone:show()
        self.editBox_:show()
        self.editAtBox_:hide()
        self.main.nodeBottom.btnBack:hide()
        self.main.nodeToList:hide()
        if ChatMsgPanelIndex==1 then
            self.main.nodeExp:show()
        elseif ChatMsgPanelIndex==2 then
            self.main.nodeFastList:show()
        elseif ChatMsgPanelIndex==3 then
            self.main.nodeRecordList:show()
        elseif ChatMsgPanelIndex==4 then
            self.main.nodeBottom.edit.btnAt:hide()
            self.editBox_:hide()
            self.editAtBox_:show()
            self.main.nodeRecordList:show()
        end
    end
end

function ChatMsgPanel:onSendClicked_()
    if tx.userData.silenced == 1 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "USER_SILENCED_MSG"))
        return
    end

    local text = string.trim(self.inputText_ or "")
    if text ~= "" then
        -- 大喇叭
        if ChatMsgPanelIndex==4 and self.historyType_== THE_LABA_TYPE then
            if self.laBaUserRequestId_ then return; end --自己正在发送大喇叭
            self.laBaUserRequestId_ = sa.HttpService.POST({
                    mod="Speaker",
                    act="useSpeaker",
                    msg = text,
                    nick = tx.userData.nick or "",
                },
                function(data) 
                    self.laBaUserRequestId_ = nil
                    local callData = json.decode(data)
                    if callData and callData.code==1 then
                        self:hidePanel()
                    elseif callData and callData.code==-3 then
                        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "NOT_ENOUGH_LABA"))
                    else
                        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_BIG_LABA_MESSAGE_FAIL"))
                    end
                end, function()
                    self.laBaUserRequestId_ = nil
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_BIG_LABA_MESSAGE_FAIL"))
                end)
            return
        end
        if not self.ctx.model:isSelfInSeat() then
            if not self.ctx.model.standChatCount then
                self.ctx.model.standChatCount = 0;
            end
            self.ctx.model.standChatCount = self.ctx.model.standChatCount + 1
            if self.ctx.model.standChatCount>3 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHAT_MUST_BE_IN_SEAT"))
                self:hidePanel()
                return;
            end
        end
        tx.socket.HallSocket:sendChatMsg(text)
        self:hidePanel()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "INPUT_ALERT"))
    end
end

function ChatMsgPanel:onCleanup()
    display.removeSpriteFramesWithFile("expressionsbtns_1.plist", "expressionsbtns_1.png")
    display.removeSpriteFramesWithFile("expressionsbtns_2.plist", "expressionsbtns_2.png")
    display.removeSpriteFramesWithFile("expressionsbtns_3.plist", "expressionsbtns_3.png")
    display.removeSpriteFramesWithFile("expressionsbtns_4.plist", "expressionsbtns_4.png")
end

function ChatMsgPanel:onExpressionClicked(id)
    if self.ctx.model:isSelfInSeat() then
        local isVipExp, price = tx.checkIsVipExpression(id)
        if isVipExp then
            if not tx.checkIsVip() then
                if tx.userData.isShowVipExpTips then
                    tx.ui.Dialog.new({
                        messageText = sa.LangUtil.getText("VIP", "SEND_EXPRESSIONS_TIPS"),
                        firstBtnText =sa.LangUtil.getText("VIP", "COST_CHIPS", price),
                        secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
                        callback = function(param)
                            if param == tx.ui.Dialog.FIRST_BTN_CLICK then
                                tx.userData.isShowVipExpTips = false
                                self:sendExpress_(id, price)
                            elseif param == tx.ui.Dialog.SECOND_BTN_CLICK then
                                tx.PayGuideManager:openStore(4)
                                self:hidePanel()
                            end
                        end
                    }):show()
                else
                    self:sendExpress_(id, price)
                end
            else
                self:sendExpress_(id)
            end
        else
            self:sendExpress_(id)
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_EXPRESSION_MUST_BE_IN_SEAT"))
    end
end

function ChatMsgPanel:sendExpress_(id, price)
    if price then
        self:sendVipExpress_(id, price)
    else
        self:sendFreeExpress_(id)
    end    

    self:hidePanel()
    -- 记录缓存  只存6个
    local s = tx.userDefault:getStringForKey("EXP_SORT","13,16,19,312,33,320")
    local list = string.split(s,",")
    if not list or #list<1 then
        list = {13,16,19,312,33,320}
    end
    for k,v in ipairs(list) do
        if tonumber(v)==tonumber(id) then
            table.remove(list,k)
            break
        end
        if k==#list then  -- 删除掉第一个
            table.remove(list,1)
        end
    end
    list[6] = id
    s = ""
    for k,v in ipairs(list) do 
        if k==1 then
            s = s..v
        else
            s = s..","..v
        end
    end
    tx.userDefault:setStringForKey("EXP_SORT",s)
    sa.EventCenter:dispatchEvent({name = "PLAYER_USE_EXP", data = id})
end

--免费表情
function ChatMsgPanel:sendFreeExpress_(id)
    tx.socket.HallSocket:sendExpression(id,0)
end

--VIP表情
function ChatMsgPanel:sendVipExpress_(id, price)
    tx.sendVipExpression({
        sendType = 1,
        id = id,
        price = price,
        callback = function()
            tx.socket.HallSocket:sendExpression(id,0)
        end
    })
end

-- 表情Item
--****************************************************************************************************************************
local ExpListItem = class("ExpListItem", sa.ui.ListItem)
ExpListItem.NUM = 4
ExpListItem.WIDTH = EXP_WIDTH
ExpListItem.HEIGHT = EXP_HEIGHT*0.25
function ExpListItem:ctor()
    ExpListItem.super.ctor(self, ExpListItem.WIDTH, ExpListItem.HEIGHT)
    self.btnsNode = display.newNode():pos(0,0):addTo(self)
    local startX = ExpListItem.WIDTH*0.5/ExpListItem.NUM
    local itemWidth = startX*2
    for i=1,4,1 do
        self["btn"..i] = ScaleButton(display.newNode(),1.1)
            :onButtonClicked(function(evt)
                if self:getParent():getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
                    tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                    local owner = self:getOwner()
                    if owner and owner.onExpressionClicked then
                        owner.onExpressionClicked(self.data_[i])
                    end
                end
            end)
            :pos(startX+itemWidth*(i-1),0)
            :addTo(self.btnsNode)
        self["btn"..i]:setTouchSwallowEnabled(false)
    end
end
function ExpListItem:onDataSet(dataChanged, data)
    self.btnsNode:setPositionY(ExpListItem.HEIGHT*0.5)
    local startX = ExpListItem.WIDTH*0.5/ExpListItem.NUM
    local itemWidth = startX*2
    if dataChanged then
        local btn = nil
        for i=1,4,1 do
            btn = self["btn"..i]
            btn:setPositionX(startX+itemWidth*(i-1))
            if data[i] then
                local index = tonumber(string.sub(data[i], 1, 1))
                local scale = 1
                if index==2 then
                    scale = 1.1
                elseif index==3 then
                    scale = 0.5
                elseif index==4 then
                    scale = 0.6
                end
                local expConfig = ExpressionConfig:getConfig(id) or {}
                btn:removeAllChildren()
                display.newSprite("#expression_btn_" .. data[i] .. ".png")
                    :scale(expConfig.scale or scale)
                    :pos(expConfig.itemX or 0, expConfig.itemY or 0)
                    :addTo(btn)
                btn:show()
            else
                btn:hide()
            end
        end
    end
    local preSize = self:getContentSize()
    self:setContentSize(cc.size(ExpListItem.WIDTH, ExpListItem.HEIGHT))
    if preSize.height~=ExpListItem.HEIGHT then
        local owner = self:getOwner()
        local allData = owner and owner:getData()
        if owner and allData and #allData==self:getIndex() then  --最后一个才触发
            owner:onItemResize_()
        end
    end
end
--****************************************************************************************************************************

function ChatMsgPanel:createExpression_(parent, tabIdx, expIdx)
    if not self.subGroup_ then return; end
    if self.subGroup_.currentSelectedIndex_~=tabIdx then return; end
    if not self.expressionList_ then
        local listW, listH = EXP_WIDTH,EXP_HEIGHT
        local rect = cc.rect(-listW*0.5, -listH*0.5, listW, listH)
        self.expressionList_ = sa.ui.ListView.new({
                viewRect = cc.rect(-0.5 * listW, -0.5 * listH, listW, listH),
                direction = sa.ui.ListView.DIRECTION_VERTICAL,
                scrollBar = display.newScale9Sprite("#dialogs/chat/slider_bar.png", 0, 0, cc.size(10, 54))
            }, ExpListItem)
            :addTo(parent)
        self.expressionList_.onExpressionClicked = handler(self, self.onExpressionClicked)
    end
    local expNumList = {
        {16,"1"},
        {14,"2"},
        {35,"3"},
        {16,"4"},
    }
    local curList = expNumList[expIdx]
    if not curList then return; end
    if expIdx==3 then
        ExpListItem.HEIGHT = EXP_HEIGHT/6.7
        ExpListItem.NUM = 3
    else
        ExpListItem.HEIGHT = EXP_HEIGHT/4
        ExpListItem.NUM = 4
    end
    local showData = {}
    local item = nil
    for i=1,curList[1],1 do
        if i%ExpListItem.NUM==1 then
            item = {}
            table.insert(showData,item)
        end
        table.insert(item,curList[2]..i)
    end
    self.expressionList_:setData(showData)
    self.expressionList_:show()
end

function ChatMsgPanel:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)
    return self
end

function ChatMsgPanel:hidePanel()
    tx.PopupManager:removePopup(self)
    return self
end

function ChatMsgPanel:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=(-556*0.5)*ViewScale, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function ChatMsgPanel:onShowPopup()
    self:stopAllActions()
    self:pos((-556*0.5-20)*ViewScale,display.cy)
    transition.moveTo(self, {time=0.2, x=(556*0.5-4)*ViewScale, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
    end})
end

function ChatMsgPanel:onShow()
    if self.expressionList_ then
        self.expressionList_:setScrollContentTouchRect()
    end

    if self.shortcutMsgList_ then
        self.shortcutMsgList_:setScrollContentTouchRect()
    end

    if self.historyList_ then
        self.historyList_:setScrollContentTouchRect()
    end

    tx.cacheKeyWordFile()
end
return ChatMsgPanel