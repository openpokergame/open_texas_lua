local PropHDDJItem = import(".PropHDDJItem")
local OtherUserRoomPopup = class("OtherUserRoomPopup", tx.ui.Panel)
local UserMarkView = import(".UserMarkView")
local UserAvatarPopup = import(".UserAvatarPopup")
local SimpleAvatar  = import("openpoker.ui.SimpleAvatar")
local AnimationIcon = import("openpoker.ui.AnimationIcon")
local DisplayUtil = import("openpoker.util.DisplayUtil")
local LoadGiftControl = require("app.module.gift.LoadGiftControl")

local WIDTH, HEIGHT = 1020, 660

local LIST_WIDTH, LIST_HEIGHT = 934, 126

local AVATAR_SIZE = 182
OtherUserRoomPopup.sendConf = {50,100,200,500,999}

OtherUserRoomPopup.ELEMENTS = {
    "nodeLeft.headFrame",
    "nodeLeft.labelID",
    "nodeLeft.iconVip",
    "nodeLeft.btnFriend",
    "nodeLeft.btnFriend.labelFriend",
    "nodeLeft.btnForbid",
    "nodeLeft.btnForbid.labelForbid",
    "nodeLeft.btnChatTo",
    "nodeLeft.btnChatTo.labelChatTo",

    "nodeCenter.iconSex",
    "nodeCenter.labelName",
    "nodeCenter.iconCountry",
    "nodeCenter.labelCountry",
    "nodeCenter.labelChips",
    "nodeCenter.wordJvShu",
    "nodeCenter.labelJvShu",
    "nodeCenter.wordRuJv",
    "nodeCenter.labelRuJv",
    "nodeCenter.wordTanPai",
    "nodeCenter.labelTanPai",
    "nodeCenter.wordShengLv",
    "nodeCenter.labelShengLv",

    "nodeRight.labelLine",
    "nodeRight.iconLine",
    "nodeRight.labelLevel",
    "nodeRight.barLevelBg",
    "nodeRight.barLevelBg.barLevel",
    "nodeRight.iconUserMark",
    "nodeRight.labelUserMark",
    "nodeRight.btnUserMark",
    "nodeRight.wordBest",
    "nodeRight.nodeBest",

    "nodeBottom.labelTitle",
    "nodeBottom.sendChip1",
    "nodeBottom.sendChip1.label",
    "nodeBottom.sendChip2",
    "nodeBottom.sendChip2.label",
    "nodeBottom.sendChip3",
    "nodeBottom.sendChip3.label",
    "nodeBottom.sendChip4",
    "nodeBottom.sendChip4.label",
    "nodeBottom.sendChip5",
    "nodeBottom.sendChip5.label",
    "nodeBottom.noSendChip.label",
}

function OtherUserRoomPopup:ctor(ctx,param)
    OtherUserRoomPopup.super.ctor(self, {WIDTH, HEIGHT})
    self.ctx_ = ctx
    self.param_ = param
    self.isInMatch_ = ctx.model:isInMatch()

    self:addCloseBtn()
    self:initViews_()

    self.updateMakrInfoId_ = sa.EventCenter:addEventListener("UPDATE_MARKINFO", handler(self, self.updateMakrInfo_))
end

function OtherUserRoomPopup:setForbitStatus()
    if _G.FORBID_CHAT_LIST and _G.FORBID_CHAT_LIST[self.param_.uid] then
        ImgButton(self.nodeLeft.btnForbid,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        self.nodeLeft.btnForbid.labelForbid:setString(sa.LangUtil.getText("ROOM","CANCEL_FORBID_CHAT"))
    else
        ImgButton(self.nodeLeft.btnForbid,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        self.nodeLeft.btnForbid.labelForbid:setString(sa.LangUtil.getText("ROOM","FORBID_CHAT"))
    end
end

function OtherUserRoomPopup:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self,"dialog_other_info_room.csb",true)

    self.avatarIcon_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :pos(0,0)
        :addTo(self.nodeLeft.headFrame, 99)
        
    NormalButton(self.avatarIcon_):onButtonClicked(function()
        UserAvatarPopup.new():show(self.param_,true)
    end)

    sa.DisplayUtil.setGray(self.nodeRight.iconLine)

    self.giftImage_ = AnimationIcon.new("#common/btn_gift.png", 0.6, 0.5)
        :pos(-AVATAR_SIZE/2, 0)
        :addTo(self.nodeLeft.headFrame, 100)

    ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_green.png","#common/btn_small_green_down.png")
    self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","ADD_FRIEND"))
    self.nodeLeft.btnFriend:onButtonClicked(handler(self,self.onFriend))

    ImgButton(self.nodeLeft.btnForbid,"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        :onButtonClicked(function()
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            if not _G.FORBID_CHAT_LIST then _G.FORBID_CHAT_LIST={} end
            if _G.FORBID_CHAT_LIST[self.param_.uid] then
                _G.FORBID_CHAT_LIST[self.param_.uid] = nil
            else
                _G.FORBID_CHAT_LIST[self.param_.uid] = true
            end
            self:setForbitStatus()
        end)
    self:setForbitStatus()

    ImgButton(self.nodeLeft.btnChatTo,"#common/btn_small_blue.png","#common/btn_small_blue_down.png")
        :onButtonClicked(function()
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            local curScene = display.getRunningScene()
            local ChatMsgPanel = require("app.module.room.chat.ChatMsgPanel")
            local chatPanel = ChatMsgPanel.new(curScene.ctx,self.param_)
            chatPanel:showPanel()
            self:hidePanel()
        end)

    ImgButton(self.nodeRight.btnUserMark,"#common/btn_editbox_normal.png","#common/btn_editbox_pressed.png")
        :onButtonClicked(handler(self,self.onUserMarkClicked_))

    self:addSendChipNode_()

    self.propList_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-LIST_WIDTH * 0.5, -LIST_HEIGHT * 0.5, LIST_WIDTH, LIST_HEIGHT),
                direction=sa.ui.ListView.DIRECTION_HORIZONTAL
            },
            PropHDDJItem
        )
        :hideScrollBar()
        :pos(0, 28)
        :addTo(self.nodeBottom)
    self.propList_.onPropItemClickListener = handler(self, self.onPropItemClick)

    -- local idList = {1,2,7,8,6,10,9,4,3,5,11,12,13,14}
    local idList = {1,2,3,4,5,9,12,14}
    -- local tempPrice = {20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000}
    local priceList = tx.userData.vipinfo.propsPrice
    local hddjData = {}
    for i, v in ipairs(idList) do
        local price = ""
        if priceList and priceList[""..i] then
            price = priceList[""..i]
        end
        hddjData[i] = {id = v, price = price}
    end
    self.propList_:setData(hddjData)

    -- 移动到最末尾
    self.propList_:scrollTo(-10000)

    local PokerCard = tx.ui.PokerCard
    self.cards_ = {}
    local x, y = -126, 0
    local dir = 68
    for i = 1, 5 do
        self.cards_[i] = PokerCard.new()
            :showBack()
            :scale(0.55)
            :pos(x + (i - 1) * dir, y)
            :addTo(self.nodeRight.nodeBest)
    end
    for i = 1, 5 do
        self.nodeBottom["sendChip"..i].label:setString(OtherUserRoomPopup.sendConf[i])
    end
    self.nodeBottom.labelTitle:setString(sa.LangUtil.getText("VIP", "SEND_PROPS_TIPS_1"))
    self.nodeBottom.noSendChip.label:setString(sa.LangUtil.getText("ROOM", "NO_SEND_CHIP_TIPS"))
    
    self.nodeCenter.iconCountry:hide():scale(0.75)
    self.nodeCenter.labelCountry:hide()

    self.nodeCenter.wordJvShu:setString(sa.LangUtil.getText("USERINFO","PLAY_TOTOAL_COUNT"))
    self.nodeCenter.labelJvShu:setString("")
    self.nodeCenter.wordRuJv:setString(sa.LangUtil.getText("USERINFO","PLAY_START_RATE"))
    self.nodeCenter.labelRuJv:setString("")
    self.nodeCenter.wordTanPai:setString(sa.LangUtil.getText("USERINFO","SHOW_CARD_RATE"))
    self.nodeCenter.labelTanPai:setString("")
    self.nodeCenter.wordShengLv:setString(sa.LangUtil.getText("USERINFO","WIN_TOTAL_RATE"))
    self.nodeCenter.labelShengLv:setString("")
    self.nodeRight.labelLevel:setString("")
    self.nodeRight.wordBest:setString(sa.LangUtil.getText("USERINFO", "MAX_CARD_TYPE"))
    self.nodeRight.labelLine:setString(sa.LangUtil.getText("USERINFO", "NO_CHECK_LINE"))
    self.nodeRight.labelUserMark:setString(sa.LangUtil.getText("USERINFO", "MARK_TITLE"))

    -- 布局
    local size1 = self.nodeCenter.wordJvShu:getContentSize()
    local width_ = size1.width
    local size2 = self.nodeCenter.wordRuJv:getContentSize()
    if size2.width>width_ then
        width_ = size2.width
    end
    local size3 = self.nodeCenter.wordTanPai:getContentSize()
    if size3.width>width_ then
        width_ = size3.width
    end
    local size4 = self.nodeCenter.wordShengLv:getContentSize()
    if size4.width>width_ then
        width_ = size4.width
    end
    local xx=self.nodeCenter.wordJvShu:getPositionX()+10
    self.nodeCenter.labelJvShu:setPositionX(xx+width_)
    self.nodeCenter.labelRuJv:setPositionX(xx+width_)
    self.nodeCenter.labelTanPai:setPositionX(xx+width_)
    self.nodeCenter.labelShengLv:setPositionX(xx+width_)

    self:showInitData_()
    sa.HttpService.CANCEL(self.userDataRequestId_)
    self.userDataRequestId_ = sa.HttpService.POST(
        {
            mod = "User",
            act = "checkPlayer",
            cuid = self.param_.uid,
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                self.data_ = retData.info
                self:showRetData_()
                self:setLoading(false)
            end
        end,
        function()
        end
    )
end

function OtherUserRoomPopup:addSendChipNode_()
    if self.isInMatch_ then
        for i=1,5 do
            local node = self.nodeBottom["sendChip".. i]
            DisplayUtil.setGray(node)
            node.label:setColor(cc.c3b(0x79, 0x79, 0x79))
        end

        self.nodeBottom.noSendChip:show()
    else
        self.nodeBottom.noSendChip:hide()
        ColorButton(self.nodeBottom.sendChip1,cc.c3b(150,150,150))
            :onButtonClicked(function()
                self:onSendChips(1)
            end)
        ColorButton(self.nodeBottom.sendChip2,cc.c3b(150,150,150))
            :onButtonClicked(function()
                self:onSendChips(2)
            end)
        ColorButton(self.nodeBottom.sendChip3,cc.c3b(150,150,150))
            :onButtonClicked(function()
                self:onSendChips(3)
            end)
        ColorButton(self.nodeBottom.sendChip4,cc.c3b(150,150,150))
            :onButtonClicked(function()
                self:onSendChips(4)
            end)
        ColorButton(self.nodeBottom.sendChip5,cc.c3b(150,150,150))
            :onButtonClicked(function()
                self:onSendChips(5)
            end)
    end
end

function OtherUserRoomPopup:showRetData_()
    self.isLoaded_ = true
    local data = self.data_
    if data.comment == "" then
        self.markData_ = {id = 8, comment = data.comment}
    else
        local comment = string.gsub(data.comment, "\\", "")
        self.markData_ = json.decode(comment)
    end

    self.lastComment_ = self.markData_.comment

    self:setMakrInfo_()

    self.nodeCenter.labelJvShu:setString(data.totalPoker)
    self.nodeCenter.labelShengLv:setString(sa.transformToPercent(data.winTimes, data.totalPoker)) --胜率
    self.nodeCenter.labelRuJv:setString(sa.transformToPercent(data.ruju, data.totalPoker)) --入局率
    self.nodeCenter.labelTanPai:setString(sa.transformToPercent(data.tanpai, data.totalPoker)) --摊牌率
    self.nodeCenter.labelChips:setString(sa.formatNumberWithSplit(data.money or 0))

    self.nodeCenter.iconCountry:show():setSpriteFrame("country_" .. data.countryId .. ".png")

    local name = tx.getCountryNameById(data.countryId)
    self.nodeCenter.labelCountry:show():setString(name)
    sa.fitSprteWidth(self.nodeCenter.labelCountry, 220)

    -- 等级进度
    local radio,pro,all,level = tx.Level:getLevelUpProgress(data.exp)
    self.nodeRight.labelLevel:setString(level)
    local size = self.nodeRight.barLevelBg:getContentSize()
    local minWidth = 20
    local curSize = size.width*radio
    if curSize>=minWidth then
        self.nodeRight.barLevelBg.barLevel:setContentSize(cc.size(curSize,size.height))
    else
        self.nodeRight.barLevelBg.barLevel:setContentSize(cc.size(minWidth,size.height))
        self.nodeRight.barLevelBg.barLevel:setScaleX(curSize/minWidth)
    end

    if tonumber(data.line) == 1 and data.lineaccount ~= "" then
        self.nodeRight.labelLine:setString(data.lineaccount)
    else
        sa.DisplayUtil.setGray(self.nodeRight.iconLine)
    end

    data.isFriend = tonumber(data.isFriend)
    if data.isFriend==1 then
        ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_red.png","#common/btn_small_red_down.png")
        self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","DEL_FRIEND"))
    end

    local cardUint = {}
    if data.bestcard ~= "0" and data.bestcard ~= 0 then
        for i = 1, 5 do
            cardUint[i] = tonumber(string.sub(data.bestcard, (i + 1) * 2, (i + 1) * 2 + 1))
        end
    end

    if cardUint and #cardUint>0 then
        for i = 1, 5 do
            self.cards_[i]:showFront():setCard(cardUint[i])
        end
    end
end

function OtherUserRoomPopup:showInitData_()
    local img = self.param_ and self.param_.img
    local sex = self.param_ and self.param_.sex
    local nick = self.param_ and self.param_.nick or ""
    local money = self.param_ and self.param_.money
    local uid = self.param_ and self.param_.uid
    local vipLevel = self.param_ and self.param_.vip or 0
    self.nodeLeft.labelID:setString("ID: "..(uid or "null"))

    local offsetX, offsetY = 5, 0
    local sx = self.nodeLeft.labelID:getPositionX()
    local sy = self.nodeLeft.iconVip:getPositionY()
    local size = self.nodeLeft.labelID:getContentSize()
    if vipLevel > 0 then
        offsetX = 8
        offsetY = 10
    end
    self.nodeLeft.iconVip:setSpriteFrame("common/vip_level_icon_" .. vipLevel .. ".png")
    self.nodeLeft.iconVip:pos(sx - size.width*0.5 + offsetX, sy + offsetY)

    if sex == "f" then
        self.avatarIcon_:setSpriteFrame("common/icon_female.png")
        self.nodeCenter.iconSex:setSpriteFrame("common/common_sex_female.png")
    else
        self.avatarIcon_:setSpriteFrame("common/icon_male.png")
        self.nodeCenter.iconSex:setSpriteFrame("common/common_sex_male.png")
    end
    if img and string.len(img) > 5 then
        self.avatarIcon_:loadImage(img)  --先显示模糊图
        local imgurl = img
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        self.avatarIcon_:loadImage(imgurl)
    end
    self.nodeCenter.labelName:setString(tx.Native:getFixedWidthText("", 28, nick, 220))
    self.nodeCenter.labelChips:setString(sa.formatNumberWithSplit(money or 0))

    local giftId = self.param_ and self.param_.giftId
    if self.giftUrlReqId_ then
        LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
    end
    self.giftUrlReqId_ = LoadGiftControl:getInstance():getGiftUrlById(giftId, function(url)
        self.giftUrlReqId_ = nil
        if url and string.len(url) > 5 then
            self.giftImage_:onData(url,80,80)
        else
            -- self.giftImage_:onData(nil,60,60)
            self.giftImage_:hide()
        end
    end)
end

function OtherUserRoomPopup:onUserMarkClicked_()
    UserMarkView.new():addTo(self, 999)
end

function OtherUserRoomPopup:onFriend()
    if not self.isLoaded_ then return; end
    if self.param_ then
        sa.HttpService.CANCEL(self.addFriendId_)
        sa.HttpService.CANCEL(self.deleteFriendId_)
        if self.data_.isFriend==1 then
            self.deleteFriendId_ = sa.HttpService.POST(
                {
                    mod="friend", 
                    act="DelPoker", 
                    fuid = self.param_.uid,
                },
                function(retCall)                    
                    local jsonCall = json.decode(retCall)
                    if jsonCall then
                        if jsonCall == 1 then
                            self.data_.isFriend = 0
                            ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_green.png","#common/btn_small_green_down.png")
                            self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","ADD_FRIEND"))
                            -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_SUCCESS_MSG"))
                        else
                            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
                        end
                    end
                end,
                function(retCall)
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
                end)
        else
            self.addFriendId_ = sa.HttpService.POST(
                {
                    mod="friend",
                    act="setPoker",
                    fuid=self.param_.uid,
                    new = 1
                },
                function(data)
                    local retData = json.decode(data)
                    if retData then
                        if retData.ret == 1 or retData.ret == 2 then
                            self.data_.isFriend = 1
                            ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_red.png","#common/btn_small_red_down.png")
                            self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","DEL_FRIEND"))
                            if retData.ret == 2 then
                                local noticed = tx.userDefault:getBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, false)
                                if not noticed then
                                    tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "ADD_FULL_TIPS",tx.OnOff:getConfig("maxFriendNum") or "300"))
                                    tx.userDefault:setBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, true)
                                end
                            end
                            if self.ctx_ and self.ctx_.model then
                                local extraData = {
                                    fromUid = tx.userData.uid,
                                    toUid = self.param_.uid
                                }
                                self.ctx_.animManager:playAddFriendAnimation(self.ctx_.model:selfSeatId(), self.param_.seatId, extraData)
                                tx.socket.HallSocket:sendAddFriend(self.ctx_.model:selfSeatId(), self.param_.seatId, extraData)
                                self:hidePanel()
                            end
                        else
                            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                        end
                    end
                end,
                function()
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                end)
        end
    end
end

function OtherUserRoomPopup:onSendChips(type)
    if self.ctx_ and self.ctx_.model and self.ctx_.model:isSelfInSeat() and self.param_ then
        local seatId,player = self.ctx_.model:getSeatIdByUid(tx.userData.uid)
        if not player then
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHIP_NOT_IN_SEAT"))
            return
        end
        local money = OtherUserRoomPopup.sendConf[type]
        if player.seatChips<=money then
            tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON","NOT_ENOUGH_MONEY"))
            return
        end

        local ctx = self.ctx_
        local model = self.ctx_.model
        local param = self.param_

        sa.HttpService.CANCEL(self.sendChipsId_)
        self.sendChipsId_ = sa.HttpService.POST(
            {
                mod = "User",
                act = "sendMoneyInRoom",
                acceptuid = self.param_.uid,
                money = money
            },
            function (data)
                local callData = json.decode(data)
                if callData.code == 1 then
                    -- 模拟协议
                    local PROTOCOL = tx.socket.HallSocket.PROTOCOL -- 大厅公共协议
                    local msgInfo = {
                        t=PROTOCOL.TABLE_MSG_TYPES[5],
                        chips=money,
                        from=model:selfSeatId(),
                        to=param.seatId,
                        isInT=callData.isInTable or 0,
                    }
                    model:processSendChipSuccess(msgInfo,((msgInfo.isInT)==1))
                    ctx.animManager:playSendChipAnimation(msgInfo.from,msgInfo.to,msgInfo.chips)

                    tx.userData.money = tx.userData.money - money
                    tx.socket.HallSocket:sendChips(money,model:selfSeatId(),param.seatId,callData.isInTable or 0)
                elseif callData.code == -2 or callData.code == -21 then -- 赠送超过上限(单人) | 赠送超过上限(所有)
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHIP_TOO_MANY"))
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHIP_NOT_ENOUGH_CHIPS"))
                end
            end,
            function()
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHIP_NOT_ENOUGH_CHIPS"))
            end
        )
        self:hidePanel()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_CHIP_NOT_IN_SEAT"))
    end
end

function OtherUserRoomPopup:onPropItemClick(propId)
    if self.ctx_ and self.ctx_.model and self.ctx_.model:isSelfInSeat() and self.param_ then
        local ctx = self.ctx_
        local model = self.ctx_.model
        local param = self.param_
        sa.HttpService.CANCEL(self.useHDDJId_)
        self.useHDDJId_ = sa.HttpService.POST(
            {
                mod = "Props",
                act = "useUserProps"
            },
            function (data)
                local jsonData = json.decode(data)
                if jsonData.code >= 1 then
                    local extraData = {
                        fromUid = tx.userData.uid,
                        toUid = param.uid
                    }
                    ctx.animManager:playHddjAnimation(model:selfSeatId(),param.seatId,propId, extraData)
                    tx.socket.HallSocket:sendHddj(propId, model:selfSeatId(), param.seatId, extraData)
                    tx.userData.hddjnum = tonumber(jsonData.num)
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_FAILED"))
                end
            end,
            function()
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_FAILED"))
            end
        )
        self:hidePanel()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_NOT_IN_SEAT"))
    end
end

function OtherUserRoomPopup:onShowed()
    if self.propList_ then
        self.propList_:setScrollContentTouchRect()
    end
end

function OtherUserRoomPopup:onCleanup()
    sa.HttpService.CANCEL(self.userDataRequestId_)
    -- sa.HttpService.CANCEL(self.useHDDJId_)
    -- sa.HttpService.CANCEL(self.sendChipsId_)
    sa.HttpService.CANCEL(self.addFriendId_)
    sa.HttpService.CANCEL(self.deleteFriendId_)
    if self.giftUrlReqId_ then
        LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
    end
    sa.EventCenter:removeEventListener(self.updateMakrInfoId_)
    self:markUser_()
end

function OtherUserRoomPopup:markUser_()
    if self.markData_ and self.lastComment_ ~= self.markData_.comment then
        sa.HttpService.POST(
            {
                mod = "User",
                act = "commentUser",
                cuid = self.param_.uid,
                comment = json.encode(self.markData_)
            },
            function(data)
                local retData = json.decode(data)
                if retData.code == 1 then
                    -- tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "MARK_SUCCESS"))
                else
                    -- tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "MARK_FAIL"))
                end
            end,
            function()
                -- tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "MARK_FAIL"))
            end
        )
    end
end

function OtherUserRoomPopup:updateMakrInfo_(evt)
    local data = evt.data

    if data.id ~= -1 then
        self.markData_ = data
        self:setMakrInfo_()
    end
end

function OtherUserRoomPopup:setMakrInfo_()
    local data = self.markData_
    local id = data.id
    local comment = data.comment
    if comment == "" then
        self.nodeRight.labelUserMark:setString(sa.LangUtil.getText("USERINFO", "MARK_TITLE"))
        self.nodeRight.iconUserMark:setSpriteFrame("common/userinfo_mark_icon_8.png")
    else
        self.nodeRight.labelUserMark:setString(comment)
        self.nodeRight.iconUserMark:setSpriteFrame("common/userinfo_mark_icon_" .. id .. ".png")
    end
end

return OtherUserRoomPopup