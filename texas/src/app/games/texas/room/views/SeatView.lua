local HandCard = import(".HandCard")
local AnimationIcon = import("openpoker.ui.AnimationIcon")
local SeatStateMachine = import("app.games.texas.room.model.SeatStateMachine")
local GiftShopPopUp = import("app.module.gift.GiftShopPopup")
local LoadGiftControl = import("app.module.gift.LoadGiftControl")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local P = import(".RoomViewPosition")

local SeatView = class("SeatView", function() 
    return display.newNode()
end)

SeatView.CLICKED = "SeatView.CLICKED"
local WIDTH, HEIGHT = 124, 186
SeatView.WIDTH = WIDTH
SeatView.HEIGHT = HEIGHT

local SELFWIDTH, SELFHEIGHT = 160, 230
SeatView.SELFWIDTH = SELFWIDTH
SeatView.SELFHEIGHT = SELFHEIGHT

local GIFT_MAX_W, GIFT_MAX_H = 70, 70 --礼物最大宽高
local NAME_COLOR = {
    [0] = cc.c3b(0xff, 0xff, 0xff),
    [1] = cc.c3b(0x5d, 0xff, 0x70),
    [2] = cc.c3b(0x42, 0xde, 0xff),
    [3] = cc.c3b(0xc5, 0x72, 0xff),
    [4] = cc.c3b(0xff, 0x65, 0x3b),
}

function SeatView:ctor(ctx, seatId)
    self:retain()
    self.ctx = ctx
    self.nodeCleanup_ = true
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self:setNodeEventEnabled(true)

    --桌子背景
    self.background_ = display.newScale9Sprite("#texas/room/room_seat_bg.png", 0, 0, cc.size(WIDTH, HEIGHT)):addTo(self, 1)
    self.normalNode_ = self.background_

    --赢牌座位金色边框
    self.seatId_ = seatId
    self.positionId_ = seatId + 1

    --坐下图片
    self.sitdown_ = display.newSprite("#lang/room_sitdown_icon.png")
    --用户头像容器
    self.image_ = SimpleAvatar.new({
            shapeImg = "#common/modal_texture.png",
            frameImg = "#common/transparent.png",
            scale9 = 1,
            offsetSize = 0,
            size = WIDTH
        })
        :pos(0, -WIDTH)
    self.background_.image_ = self.image_
    --用户头像剪裁节点
    local rect = cc.rect(-WIDTH*0.5, -WIDTH*0.5, WIDTH, WIDTH)
    self.clipNode_ = display.newClippingRectangleNode(rect)

    self.clipNode_:addChild(self.sitdown_, 1)
    self.clipNode_:addChild(self.image_, 2)
    self.clipNode_:addTo(self.background_, 4)
        :pos(WIDTH*0.5, HEIGHT*0.5)

    --头像灰色覆盖
    self.cover_ = display.newRect(WIDTH, WIDTH, {fill=true, fillColor=cc.c4f(0, 0, 0, 0.5)})
        :addTo(self.background_, 5)
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :hide()

    self.state_ = ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER, color=cc.c3b(0xff, 0xff, 0xff) })
    self.state_:pos(WIDTH*0.5, HEIGHT-16):addTo(self.background_, 6)

    self.winnerAnimation_ = sp.SkeletonAnimation:create("spine/winner.json","spine/winner.atlas")
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self.background_, 6)
        :hide()
    -- stateIcon  状态图片
    self.stateIcon_ = display.newSprite():pos(WIDTH*0.5, HEIGHT-16):addTo(self.background_, 7):hide()

    --座位筹码文字
    self.chips_ = display.newBMFontLabel({text = "", font = "fonts/room_seat_money.fnt"})
        :pos(WIDTH*0.5, 4)
        :addTo(self.background_, 8)

    -- 礼物
    self.giftImage_ = AnimationIcon.new("#common/btn_gift_room.png", 1.0, 0.5, buttontHandler(self, self.openGiftPopUpHandler))
        :addTo(self, 8)
        :hide()
    self.giftImage_:retain()
    self.giftImage_:setNodeEventEnabled(false)
    -- 手牌
    self.handCards_ = HandCard.new(0.8):addTo(self, 9):hide()

    --牌型背景
    self.cardTypeBackground_ = display.newScale9Sprite("#texas/room/room_seat_card_type_light_bg.png")
        :addTo(self, 10)
        :hide()

    --牌型文字
    self.cardType_ = ui.newTTFLabel({
        size = 24,
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_CENTER,
        color=cc.c3b(255, 255, 255)
    }):addTo(self, 11):hide()

    --座位触摸
    self.touchHelper_ = sa.TouchHelper.new(self.background_, handler(self, self.onTouch_))
    self.touchHelper_:enableTouch()

    self.propList_ = {"background_","winnerAnimation_","image_","clipNode_","cover_","state_","stateIcon_","chips_"}
    for k,v in pairs(self.propList_) do
        self["KEY__"..v] = self[v]
    end
    --初始为站起状态
    self:standUpState_()
end

function SeatView:createSelfBigNode_()
    if not self.selfNode_ then
        self.selfNode_ = display.newNode()
            :pos(P.SelfOffsetX,P.SelfOffsetY)
            :addTo(self)
        local node = self.selfNode_
        node.background_ = display.newScale9Sprite("#texas/room/room_seat_bg.png", 0, 0, cc.size(SELFWIDTH, SELFHEIGHT))
            :addTo(self.selfNode_)
        local parent = node.background_

        node.image_ = SimpleAvatar.new({
            shapeImg = "#common/modal_texture.png",
            frameImg = "#common/transparent.png",
            scale9 = 1,
            offsetSize = 0,
            size = SELFWIDTH
        })
        :pos(0, -SELFWIDTH)

        --用户头像剪裁节点
        local rect = cc.rect(-SELFWIDTH*0.5, -SELFWIDTH*0.5, SELFWIDTH, SELFWIDTH)
        node.clipNode_ = display.newClippingRectangleNode(rect)

        node.clipNode_:addChild(node.image_, 1, 1)
        node.clipNode_:addTo(parent, 4)
            :pos(SELFWIDTH*0.5, SELFHEIGHT*0.5)

        node.cover_ = display.newRect(SELFWIDTH, SELFWIDTH, {fill=true, fillColor=cc.c4f(0, 0, 0, 0.5)})
            :addTo(parent, 5)
            :pos(SELFWIDTH*0.5, SELFHEIGHT*0.5)
            :hide()

        node.state_ = ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER, color=cc.c3b(0xff, 0xff, 0xff) })
        node.state_:pos(SELFWIDTH*0.5, SELFHEIGHT-18):addTo(parent, 6)

        node.stateIcon_ = display.newSprite():pos(SELFWIDTH*0.5, SELFHEIGHT-18):addTo(parent, 7):hide()

        node.winnerAnimation_ = sp.SkeletonAnimation:create("spine/winner.json","spine/winner.atlas")
            :pos(SELFWIDTH*0.5, SELFHEIGHT*0.5)
            :addTo(parent, 7)
            :hide()
        node.winnerAnimation_:setScaleX(SELFWIDTH/WIDTH)
        node.winnerAnimation_:setScaleY(SELFHEIGHT/HEIGHT)

        node.chips_ = display.newBMFontLabel({text = "", font = "fonts/room_seat_money.fnt"})
            :pos(SELFWIDTH*0.5, 6)
            :addTo(parent, 8)
        --座位触摸
        node.touchHelper_ = sa.TouchHelper.new(node.background_, handler(self, self.onTouch_))
        node.touchHelper_:enableTouch()
    end
    return self.selfNode_
end

function SeatView:enableTouch()
    if self.touchHelper_ then
        self.touchHelper_:enableTouch()
    end
    if self.selfNode_ and self.selfNode_.touchHelper_ then
        self.selfNode_.touchHelper_:enableTouch()
    end
end

function SeatView:onCleanup()
    if self.giftUrlReqId_ then
        LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
    end
end

function SeatView:playSitDownAnimation(onCompleteCallback)
    transition.moveTo(self.image_:pos(0, WIDTH):show(), {time=0.5, easing="backOut", x=0, y=0})
    transition.moveTo(self.sitdown_:pos(0, 0):show(), {time=0.5, easing="backOut", x=0, y=-WIDTH, onComplete=function() 
        self.sitdown_:hide()
        if onCompleteCallback then
            onCompleteCallback()
        end
    end})
    -- vip坐下动画
    if self.seatData_ and not self.seatData_.isSelf and self.seatData_.vip and tonumber(self.seatData_.vip)>0 then
        local spAnim = sp.SkeletonAnimation:create("spine/sitandpro.json","spine/sitandpro.atlas")
            :addTo(self)
        spAnim:registerSpineEventHandler(function (event)
            if event.type == "complete" then
                spAnim:performWithDelay(function()
                    spAnim:removeFromParent()
                end, 0.01)
            end
        end, sp.EventType.ANIMATION_COMPLETE)
        spAnim:setAnimation(0, "4", false)
    end
end

function SeatView:playStandUpAnimation(onCompleteCallback)
    transition.moveTo(self.image_:pos(0, 0):show(), {time=0.5, easing="backOut", x=0, y=WIDTH})
    transition.moveTo(self.sitdown_:pos(0, -WIDTH):show(), {time=0.5, easing="backOut", x=0, y=0, onComplete=function() 
        self.image_:hide()
        if onCompleteCallback then
            onCompleteCallback()
        end
    end})
end

function SeatView:playAllInAnimation(onCompleteCallback)
    if not self.allinNode_ then
        self.allinNode_ = display.newNode()
            :pos(0,0)
            :addTo(self, 2)
    end

    local allInWidth,allInHeight = 110,160
    if self.seatData_ and self.seatData_.isSelf then
        self.allinNode_:pos(P.SelfOffsetX + 5,P.SelfOffsetY + 2)
        self.allinNode_:setScaleX(SELFWIDTH/allInWidth)
        self.allinNode_:setScaleY(SELFHEIGHT/allInHeight)
    else
        self.allinNode_:pos(5, 0)
        self.allinNode_:setScaleX(WIDTH/allInWidth)
        self.allinNode_:setScaleY(HEIGHT/allInHeight)
    end

    self.allinNode_:show()
    if self.allinFire_ then
        self.allinFire_:removeFromParent()
    end 

    self.allinFire_ = sp.SkeletonAnimation:create("spine/allin_fire.json","spine/allin_fire.atlas")
        :addTo(self.allinNode_)
    self.allinFire_:setAnimation(0, "allin_fire", true)
end

function SeatView:fade()
    transition.execute(self.cover_:show(), cc.FadeIn:create(0.2))
end

function SeatView:unfade()
    self.cover_:hide()
end

function SeatView:sitDownState_()
    self.image_:stopAllActions()
    self.sitdown_:stopAllActions()
    self.image_:pos(0, 0):show()
    self.sitdown_:pos(0, -WIDTH):hide()
    self.giftImage_:show()
end

function SeatView:standUpState_()
    self.image_:stopAllActions()
    self.sitdown_:stopAllActions()
    self.image_:pos(0, WIDTH):hide()
    self.sitdown_:pos(0, 0):show()
    self.giftImage_:hide()
end

function SeatView:isEmpty()
    return not self.seatData_
end

function SeatView:getPositionId()
    return self.positionId_
end

function SeatView:setPositionId(id)
    self.positionId_ = id
    if id then
        if id<=5 then
            if self.selfNode_ and self.selfNode_:isVisible() then
                self.giftImage_:pos(-P.GiftX+P.SelfGiftOffsetX, 0+P.SelfOffsetY)
            else
                self.giftImage_:pos(-P.GiftX, 0)
            end
        else
            if self.selfNode_ and self.selfNode_:isVisible() then
                self.giftImage_:pos(P.GiftX+P.SelfGiftOffsetX, 0+P.SelfOffsetY)
            else
                self.giftImage_:pos(P.GiftX, 0)
            end
        end
    end
end

function SeatView:resetToEmpty()
    self.seatData_ = nil
    self:updateState()
end

function SeatView:changeSelfProps_(isSelf)
    if isSelf==true and self.selfNode_ then
        self.selfNode_:show()
        self.normalNode_:hide()
        if self.positionId_<=5 then
            self.giftImage_:pos(-P.GiftX+P.SelfGiftOffsetX, 0+P.SelfOffsetY)
        else
            self.giftImage_:pos(P.GiftX+P.SelfGiftOffsetX, 0+P.SelfOffsetY)
        end 
        for k,v in pairs(self.propList_) do
            self[v] = self.selfNode_[v]
        end
    else
        if self.positionId_<=5 then
            self.giftImage_:pos(-P.GiftX, 0)
        else
            self.giftImage_:pos(P.GiftX, 0)
        end
        if self.selfNode_ then
            self.selfNode_:hide()
        end
        self.normalNode_:show()
        for k,v in pairs(self.propList_) do
            self[v] = self["KEY__"..v]
        end
    end
end

function SeatView:setSeatData(seatData)
    self.seatData_ = seatData
    if self.seatData_ and self.seatData_.isSelf then
        self:createSelfBigNode_()
        self:changeSelfProps_(true)
    else
        self:changeSelfProps_(false)
    end

    if not self.showedHandCardAnim_ then
        self.showedHandCardAnim_ = false
        if seatData and seatData.isSelf then
            self.handCards_:setIsSelf(true)
            self.handCards_:pos(126, 23):scale(1)
            self.cardTypeBackground_:pos(126, -67)
            self.cardType_:pos(126, -67)
            self.cardTypeBGWidth_ = 170
            self.cardTypeBGHeight_ = 30
        else
            self.handCards_:setIsSelf(false)
            self.handCards_:pos(0, 0):scale(0.8)
            self.cardTypeBackground_:pos(0, -47)
            self.cardType_:pos(0, -47)
            self.cardTypeBGWidth_ = 130
            self.cardTypeBGHeight_ = 30
        end
    end
    
    if not seatData then
        self:reset()
        self:standUpState_()
    else
        self:sitDownState_()
        self.image_:setDefaultAvatar(seatData.sex)
        if seatData.img and string.len(seatData.img) > 5 then
            self:updateHeadImage(seatData.img)
        end

        self:updateGiftUrl(seatData.giftId)
    end

end

function SeatView:getSeatData()
    return self.seatData_
end

function SeatView:updateGiftUrl(gift_Id)
    if self.giftUrlReqId_ then
        LoadGiftControl:getInstance():cancel(self.giftUrlReqId_)
    end
    self.giftUrlReqId_ = LoadGiftControl:getInstance():getGiftUrlById(gift_Id, function(url)
        self.giftUrlReqId_ = nil
        if url and string.len(url) > 5 then
            self.giftImage_:onData(url, GIFT_MAX_W, GIFT_MAX_H)
        else
            self.giftImage_:onData(nil, GIFT_MAX_W, GIFT_MAX_H)
        end
    end)
end

function SeatView:updateHeadImage(imgurl)
    if string.len(imgurl) > 5 then
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        self.image_:loadImage(imgurl)
    end
end

function SeatView:updateState()
    if self.seatData_ == nil then
        if self.ctx.model:isSelfInSeat() then
            self:hide()
        else
            self:show()
            self.state_:hide()
            self.stateIcon_:hide()
            self.chips_:hide()
            self.sitdown_:show()
            if self.userImage_ then
                self.userImage_:removeFromParent()
                self.userImage_ = nil
            end
        end
        if self.ctx.model:isInMatch() then
            self:hide()
        end
    else
        self:show()
        self.state_:show()
        self.chips_:show()
        self.sitdown_:hide()
        local stateStr,stateIcon = self.seatData_.statemachine:getStateText()
        if stateIcon then
            self.state_:hide()
            self.stateIcon_:show()
            self.stateIcon_:setSpriteFrame(display.newSprite(stateIcon):getSpriteFrame())
        else
            local level = 0
            if self.seatData_ and self.seatData_.isSelf then
                level = tx.userData.vipinfo.level
                self.state_:setString(tx.Native:getFixedWidthText("", 24, stateStr, SELFWIDTH))
            else
                if self.seatData_.vip then
                    level = tonumber(self.seatData_.vip) or 0
                end
                self.state_:setString(tx.Native:getFixedWidthText("", 24, stateStr, WIDTH))
            end
            self.state_:setTextColor(NAME_COLOR[level])
            self.state_:show()
            self.stateIcon_:hide()
        end
        self.state_:setTextColor(self.seatData_.statemachine:getStateColor())
        if self.seatData_.seatChips < 100000 then
            self.chips_:setString(sa.formatNumberWithSplit(self.seatData_.seatChips))
        else
            self.chips_:setString(sa.formatBigNumber(self.seatData_.seatChips))
        end

        local sm = self.seatData_.statemachine
        local st = sm:getState()

        if st ~= SeatStateMachine.STATE_BETTING then
            self.handCards_:stopShakeAll()
        end

        if st == SeatStateMachine.STATE_WAIT_START or st == SeatStateMachine.STATE_FOLD then
            self.cover_:show()
        else
            self.cover_:hide()
        end

        if st == SeatStateMachine.STATE_FOLD then
            self.handCards_:addDarkWithNum(2)
        end
    end
end

function SeatView:setHandCardValue(cards)
    self.handCards_:setCards(cards)
end

function SeatView:setHandCardNum(num)
    self.handCards_:setCardNum(num)
end

function SeatView:showHandCards()
    self.handCards_:show()
end

function SeatView:hideHandCards()
    self.handCards_:hide()
end

function SeatView:showHandCardBackAll()
    self.handCards_:showBackAll()
end

function SeatView:showHandCardFrontAll()
    self.handCards_:showFrontAll()
end

function SeatView:flipAllHandCards()
    self.handCards_:flipAll()
end

function SeatView:hideAllHandCardsElement()
    self.handCards_:hideAllCards()
end

function SeatView:showAllHandCardsElement()
    self.handCards_:showAllCards()
end

function SeatView:showHandCardsElement(idx,showBack)
    self.handCards_:showWithIndex(idx)
    if showBack==true then
        self.handCards_:showBackWithIndex(idx)
    end
end

function SeatView:flipHandCardsElement(idx)
    self.handCards_:flipWithIndex(idx)
end

function SeatView:shakeAllHandCards()
    self.handCards_:shakeWithNum(2)
end

function SeatView:showHandCardsAnimation()
    local sequence = transition.sequence({
        cc.ScaleTo:create(0.1, 1.2),
        cc.MoveTo:create(0.35, cc.p(240, 165)),
        cc.ScaleTo:create(0.2, 0.8),
        cc.CallFunc:create(function() 
            tx.SoundManager:playSound(tx.SoundManager.SHOW_HAND_CARD)
        end),
    })
    self.handCards_:runAction(sequence)    

    self.showedHandCardAnim_ = true
end

function SeatView:showCardTypeIf()
    local getFrame = display.newSpriteFrame
    if self.seatData_ and self.seatData_.cardType and self.seatData_.cardType:getLabel() then
        if self.isShowingWinner_ then
            self.cardTypeBackground_:setSpriteFrame(getFrame("texas/room/room_seat_card_type_light_bg.png"))
        else
            self.cardTypeBackground_:setSpriteFrame(getFrame("texas/room/room_seat_card_type_dark_bg.png"))
        end
        if self.seatData_.cardType and self.seatData_.cardType:isBadType() then
            self.cardType_:setTextColor(cc.c3b(255,255,255))
        else
            self.cardType_:setTextColor(cc.c3b(0xfe,0xf7,0x2c))
        end
        self.cardTypeBackground_:show()
        self.cardTypeName = self.seatData_.cardType:getLabel()
        self.cardType_:setString(self.cardTypeName)
        self.cardType_:show()
        local bgWidth = self.cardTypeBGWidth_ or 130
        local bgHeight = self.cardTypeBGHeight_ or 30
        self.cardTypeBackground_:setContentSize(cc.size(bgWidth,bgHeight))
        sa.fitSprteWidth(self.cardType_, bgWidth-10)
    else
        self.cardTypeBackground_:hide()
        self.cardType_:hide()
    end
end

function SeatView:showSelfCardType(type)
    if not self.seatData_ or not type or not self.seatData_.isSelf or type<consts.CARD_TYPE.HIGH_CARD then
        self.cardTypeBackground_:hide()
        self.cardType_:hide() 
        return
    end
    self.cardTypeBackground_:setSpriteFrame(display.newSpriteFrame("texas/room/room_seat_card_type_dark_bg.png"))
    self.cardTypeBackground_:show()
    if type>=consts.CARD_TYPE.THREE_KIND then
        self.cardType_:setTextColor(cc.c3b(0xfe,0xf7,0x2c))
    else
        self.cardType_:setTextColor(cc.c3b(255,255,255))
    end
    local cardTypeName = sa.LangUtil.getText("COMMON", "CARD_TYPE")[type]
    self.cardTypeName = cardTypeName
    self.cardType_:setString(cardTypeName)
    self.cardType_:show()
    local bgWidth = self.cardTypeBGWidth_ or 170
    local bgHeight = self.cardTypeBGHeight_ or 30
    self.cardTypeBackground_:setContentSize(cc.size(bgWidth,bgHeight))
    sa.fitSprteWidth(self.cardType_, bgWidth-10)
end

function SeatView:playExpChangeAnimation(expChange)
    if expChange > 0 then
        local node = display.newNode()
        if self.seatData_ and self.seatData_.isSelf then
            node:pos(P.SelfOffsetX,P.SelfOffsetY)
        end
        node:setCascadeOpacityEnabled(true)
        local exp = display.newSprite("#common/icon_exp.png"):addTo(node)
        local num = ui.newBMFontLabel({text = "+"..expChange, font = "fonts/xiaolan.fnt"}):addTo(node)
        local expW = exp:getContentSize().width
        local numW = num:getContentSize().width
        local w =  expW + numW
        exp:pos(w * -0.5 + expW * 0.5, 0)
        num:pos(w * 0.5 - numW * 0.5, 0)

        node:addTo(self, 99)
            :scale(0.4)
            :moveBy(0.8, 0, 92)
            :scaleTo(0.8, 1)
        node:runAction(transition.sequence({
            cc.FadeIn:create(0.4),
            cc.DelayTime:create(1.2),


            cc.FadeOut:create(0.2),
            cc.CallFunc:create(function()
                node:removeFromParent()
            end),
        }))
    end
end

function SeatView:playAutoBuyinAnimation(buyinChips)
    local buyInBg = display.newSprite("#texas/room/room_seat_auto_buyin.png")
        :addTo(self, 6)
    local buyInBgSize = buyInBg:getContentSize()

    local offOffsetX_ = 0
    local offOffsetY_ = 0
    if self.seatData_ and self.seatData_.isSelf then
        offOffsetX_ = P.SelfOffsetX
        buyInBg:pos(offOffsetX_, -HEIGHT/2 + buyInBgSize.height/2+offOffsetY_)
    else
        buyInBg:pos(0, -HEIGHT/2 + buyInBgSize.height/2)
    end
    local buyInSequence = transition.sequence({
            cc.FadeIn:create(0.5),
            cc.FadeOut:create(0.5),
            cc.CallFunc:create(function()
                buyInBg:removeFromParent()
            end),
        })
    buyInBg:runAction(buyInSequence)

    local buyInLabelPaddding = 20
    local buyInLabel = ui.newTTFLabel({
            text = "+"..buyinChips, 
            color = cc.c3b(0xf4, 0xcd, 0x56), 
            size = 32, 
            align = ui.TEXT_ALIGN_CENTER
        }):addTo(self, 6):pos(offOffsetX_, -HEIGHT/2 + buyInBgSize.height/2 + buyInLabelPaddding + offOffsetY_)

    local function spawn(actions)
        if #actions < 1 then return end
        if #actions < 2 then return actions[1] end

        local prev = actions[1]
        for i = 2, #actions do
            prev = cc.Spawn:create(prev, actions[i])
        end
        return prev
    end

    local buyInLabelSequence = transition.sequence({
            spawn({
                cc.FadeTo:create(1, 0.7 * 255),
                cc.MoveTo:create(1, cc.p(offOffsetX_, HEIGHT/2 - buyInBgSize.height/2 - buyInLabelPaddding + offOffsetY_)),
            }),
            cc.CallFunc:create(function()
                buyInLabel:removeFromParent()
            end),
        })
    buyInLabel:runAction(buyInLabelSequence)
end

function SeatView:clearWinStatus()
    self:stopWinAnimation_()
    if self.isLiangPai_~=true then  -- 已经亮牌了就不要置灰
        self.handCards_:showBigs({-100}) -- 0还未重复
    end
end

--亮牌，隐藏自己需要展示的手牌
function SeatView:showLiangPai2(cardList)
    self.isLiangPai_ = true
    for i,v in ipairs(cardList) do
        if v ~= 0 then
            self.handCards_.cards[i]:hide()
        end
    end
end

function SeatView:onlyShowBigCards(pot)
    if pot then
        if pot.compareEnd and self.ctx and self.ctx.publicCardManager then  -- 不用提示最大牌 只展示了一个人的牌
            self.ctx.publicCardManager:showBigs(pot.handCards)
            self.handCards_:showBigs(pot.handCards)
        else -- 肯定是最大的 （自己的啊）
            self.handCards_:removeDarkAll()
        end
    end
end

function SeatView:playWinAnimation(type_, label_, pot)
    if not self.seatData_ then return end

    --停止未播放完的动画
    self:stopWinAnimation_()

    --开始新的动画
    self.winnerAnimation_:show()
    if pot.compareEnd and self.ctx and self.ctx.publicCardManager then  -- 不用提示最大牌 只展示了一个人的牌
        self.ctx.publicCardManager:showBigs(pot.handCards)
        self.handCards_:showBigs(pot.handCards)
    else -- 肯定是最大的 （自己的啊）
        self.handCards_:removeDarkAll()
    end

    self.isShowingWinner_ = true
    if self.seatData_.isSelf then
        self.selfNode_.winnerAnimation_:setAnimation(0, "self_win", false)
    else
        self.winnerAnimation_:setAnimation(0, "other_win", false)
    end
    self:showCardTypeIf()
    -- 播放头像赢牌动画  或者  礼物的
    self.image_:playWinAnim()
    self.giftImage_:playWinAnim()
end

function SeatView:stopWinAnimation_()
    self.isShowingWinner_ = false
    self.winnerAnimation_:hide()

    -- 自己的节点
    if self.selfNode_ then
        self.selfNode_.winnerAnimation_:hide()
    end
end
function SeatView:stopAllInAnimation()
    if self.allinNode_ then
        self.allinNode_:hide()
        self.allinFire_:setAnimation(0, "allin_fire", false)
    end
end

function SeatView:onTouch_(target, evt)
    if evt == sa.TouchHelper.CLICK then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self:dispatchEvent({name=SeatView.CLICKED, seatId=self.seatId_, target=self})
    end
end

function SeatView:reset()
    self.isLiangPai_ = false
    self.handCards_:showAllCards()
    self.handCards_:showBackAll()
    self.handCards_:removeDarkAll()
    self.handCards_:stopShakeAll()
    self.handCards_:hide()
    self.cover_:hide()

    self:stopAllInAnimation()
    self:stopWinAnimation_()
    self.cardTypeBackground_:hide()
    self.cardType_:setString("")
    self.cardType_:hide()
end

function SeatView:openGiftPopUpHandler()
    local roomUid = ""
    local roomOtherUserUidArray = ""
    local tableNum = 0
    local toUidArr = {}
    local toInfoArr = {}
    for i=0,8  do
        if self.ctx.model.playerList[i] then
            if self.ctx.model.playerList[i].uid > 0 then
                tableNum = tableNum + 1
                roomUid = roomUid..","..self.ctx.model.playerList[i].uid
                roomOtherUserUidArray = string.sub(roomUid,2)
                table.insert(toUidArr, self.ctx.model.playerList[i].uid)
                table.insert(toInfoArr, self.ctx.model.playerList[i].info)
            end
        end
    end
    if self.ctx.model.playerList[self.seatId_] then
        local seatData = self.ctx.model.playerList[self.seatId_];
        GiftShopPopUp.new():show(true,self.ctx.model.playerList[self.seatId_].uid,roomOtherUserUidArray,tableNum,toUidArr,toInfoArr)
    end
end

function SeatView:dispose()
    self.handCards_:dispose()
    if self.giftImage_ then
        self.giftImage_:cancelLoaderId()
        self.giftImage_:release()
    end
    self:release()
    self.disposed_ = true
end

return SeatView