local OtherUserPopup = class("OtherUserPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 1020, 410

local AVATAR_SIZE = 182
local SimpleAvatar  = import("openpoker.ui.SimpleAvatar")
local AnimationIcon = import("openpoker.ui.AnimationIcon")
local UserMarkView = import(".UserMarkView")
local UserAvatarPopup = import(".UserAvatarPopup")

OtherUserPopup.ELEMENTS = {
    "nodeLeft.headFrame",
    "nodeLeft.labelID",
    "nodeLeft.iconVip",
    "nodeLeft.btnFriend",
    "nodeLeft.btnFriend.labelFriend",

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
}

function OtherUserPopup:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self,"dialog_other_info.csb",true)

    self.avatarIcon_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :pos(0,0)
        :addTo(self.nodeLeft.headFrame, 99)
    
    NormalButton(self.avatarIcon_):onButtonClicked(function()
        UserAvatarPopup.new():show(self.param_,true)
    end)
    
    sa.DisplayUtil.setGray(self.nodeRight.iconLine)

    self.giftImage_ = AnimationIcon.new("#common/btn_gift.png", 0.6, 0.5)--, buttontHandler(self, self.openGiftPopUpHandler))
        :pos(-AVATAR_SIZE/2, 0)
        :addTo(self.nodeLeft.headFrame, 100)
        :hide()

    ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_green.png","#common/btn_small_green_down.png")
    self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","ADD_FRIEND"))
    self.nodeLeft.btnFriend:onButtonClicked(handler(self,self.onFriendClicked_))

    ImgButton(self.nodeRight.btnUserMark,"#common/btn_editbox_normal.png","#common/btn_editbox_pressed.png")
        :onButtonClicked(handler(self,self.onUserMarkClicked_))

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
    self.nodeRight.labelLine:setString(sa.LangUtil.getText("USERINFO", "NO_CHECK_LINE"))
    self.nodeRight.labelUserMark:setString(sa.LangUtil.getText("USERINFO", "MARK_TITLE"))
    self.nodeRight.wordBest:setString(sa.LangUtil.getText("USERINFO", "MAX_CARD_TYPE"))

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
            if retData.code == 1 and self.this_ then
                self.data_ = retData.info
                self.isFriend_ = self.data_.isFriend
                self:showRetData_()
                self:setLoading(false)
            end
        end,
        function()
        end
    )
end

function OtherUserPopup:showInitData_()
    local img = self.param_ and self.param_.img
    local sex = self.param_ and self.param_.sex
    local nick = self.param_ and self.param_.nick or ""
    local money = self.param_ and self.param_.money
    local uid = self.param_ and self.param_.uid
    self.nodeLeft.labelID:setString("ID: "..(uid or "null"))

    if img==nil and sex==nil then
        self.needReset_ = true
    end
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

    if not tx.userData or tonumber(uid) == tx.userData.uid then
        self.nodeLeft.btnFriend:hide()
        self.nodeRight.iconUserMark:hide()
        self.nodeRight.labelUserMark:hide()
        self.nodeRight.btnUserMark:hide()
    end
end

function OtherUserPopup:showRetData_()
    self.isLoaded_ = true
    local data = self.data_

    local vipLevel = data.vipLevel or 0
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
    local minWidth = 26
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

    if self.needReset_==true then
        self.needReset_ = nil
        if not self.param_ then self.param_ = {} end
        self.param_.img = data.s_picture
        self.param_.sex = data.sex
        self.param_.nick = data.nick
        self.param_.money = data.money
        self.param_.uid = data.uid
        self:showInitData_()
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

function OtherUserPopup:openGiftPopUpHandler()
    local GiftShopPopup = require("app.module.gift.GiftShopPopup")
    GiftShopPopup.new(1):show(false, tx.userData.uid)
end

function OtherUserPopup:onUserMarkClicked_()
    UserMarkView.new():addTo(self, 999)
end

function OtherUserPopup:onFriendClicked_()
    if not self.isLoaded_ then return end
    if self.isFriend_ == 1 then
        self.isFriend_ = 0
        ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_green.png","#common/btn_small_green_down.png")
        self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","ADD_FRIEND"))
    else
        self.isFriend_ = 1
        ImgButton(self.nodeLeft.btnFriend,"#common/btn_small_red.png","#common/btn_small_red_down.png")
        self.nodeLeft.btnFriend.labelFriend:setString(sa.LangUtil.getText("ROOM","DEL_FRIEND"))
    end
end

function OtherUserPopup:updateIsFriend_()
    if self.param_ and self.data_ and self.isFriend_ ~= self.data_.isFriend then
        sa.HttpService.CANCEL(self.addFriendId_)
        sa.HttpService.CANCEL(self.deleteFriendId_)
        local uid = self.param_.uid
        if self.isFriend_ == 0 then
            self.deleteFriendId_ = sa.HttpService.POST(
                {
                    mod="friend", 
                    act="DelPoker", 
                    fuid = uid,
                },
                function(retCall)                    
                    local jsonCall = json.decode(retCall)
                    if jsonCall then
                        if jsonCall == 1 then
                            sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_FRIEND_DATA})
                            -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_SUCCESS_MSG"))
                        else
                            -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
                        end
                    end
                end,
                function(retCall)
                    -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
                end)
        else
            self.addFriendId_ = sa.HttpService.POST(
                {
                    mod="friend",
                    act="setPoker",
                    fuid=uid,
                    new = 1
                },
                function(data)
                    local retData = json.decode(data)
                    if retData then
                        if retData.ret == 1 or retData.ret == 2 then
                            sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_FRIEND_DATA})
                            if retData.ret == 1 then
                                -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_SUCC_MSG"))             
                            else
                                local noticed = tx.userDefault:getBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, false)
                                if not noticed then
                                    -- tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "ADD_FULL_TIPS",tx.OnOff:getConfig("maxFriendNum") or "300"))
                                    tx.userDefault:setBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, true)
                                end
                            end
                        else
                            -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                        end
                    end
                end,
                function()
                    -- tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                end)
        end
    end
end

function OtherUserPopup:ctor(param)
    OtherUserPopup.super.ctor(self, {WIDTH, HEIGHT})
    self.this_ = self
    self.param_ = param
    self:setLoading(true)
    self:addCloseBtn()
    self:initViews_()

    self.updateMakrInfoId_ = sa.EventCenter:addEventListener("UPDATE_MARKINFO", handler(self, self.updateMakrInfo_))
end

function OtherUserPopup:onCleanup()
    sa.HttpService.CANCEL(self.userDataRequestId_)

    sa.EventCenter:removeEventListener(self.updateMakrInfoId_)

    self:updateIsFriend_()

    self:markUser_()
end

--标记玩家
function OtherUserPopup:markUser_()
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

function OtherUserPopup:updateMakrInfo_(evt)
    local data = evt.data

    if data.id ~= -1 then
        self.markData_ = data
        self:setMakrInfo_()
    end
end

function OtherUserPopup:setMakrInfo_()
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

return OtherUserPopup