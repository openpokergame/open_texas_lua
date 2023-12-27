local DealerHddjDialog = class("DealerHddjDialog", function()
    return display.newNode()
end)

function DealerHddjDialog:ctor(ctx)
    self:setNodeEventEnabled(true)
    self.ctx_ = ctx
    self.this_ = self
    display.newSprite("#dealer_hddj_bg.png"):pos(0, 160+50):addTo(self):setTouchEnabled(true)

    -- --荷官互动道具的图片,位置x,位置y,道具编号信息
    -- local hddjd_const = {}
    -- -- hddjd_const[1] = {"#hddjd_egg_icon.png", -137, 215, 1}
    -- hddjd_const[1] = {"#dealer_hddj_8.png", -137, 215, 8}
    
    -- hddjd_const[2] = {"#dealer_hddj_2.png", -124, 140, 2}

    -- -- hddjd_const[3] = {"#hddjd_rose_icon.png", -75, 83, 3}
    -- hddjd_const[3] = {"#dealer_hddj_1.png", -75, 83, 1}

    -- -- hddjd_const[4] = {"#hddjd_kiss_icon.png", 0, 60, 4}
    -- hddjd_const[4] = {"#dealer_hddj_6.png", 0, 60, 6}

    -- -- hddjd_const[5] = {"#hddjd_tomato_icon.png", 75, 83, 6}
    -- hddjd_const[5] = {"#dealer_hddj_3.png", 75, 83, 3}

    -- -- hddjd_const[6] = {"#hddjd_dog_icon.png", 124, 140, 7}
    -- hddjd_const[6] = {"#dealer_hddj_5.png", 124, 140, 5}

    -- -- hddjd_const[7] = {"#hddjd_bomb_icon.png", 137, 215, 9}
    -- hddjd_const[7] = {"#dealer_hddj_4.png", 137, 215, 4}
     --荷官互动道具的图片,位置x,位置y,道具编号信息
    local hddjd_const = {}
    hddjd_const[1] = {"#dealer_hddj_1.png", -133, 215, 1}
    hddjd_const[2] = {"#dealer_hddj_2.png", -102, 110, 2}
    hddjd_const[3] = {"#dealer_hddj_3.png", 0, 60, 3}
    hddjd_const[4] = {"#dealer_hddj_4.png", 102, 110, 4}
    hddjd_const[5] = {"#dealer_hddj_5.png", 133, 215, 5}

    for k, v in pairs(hddjd_const) do
        ColorButton(display.newSprite(v[1]),cc.c3b(170,170,170))
            :onButtonClicked(function()
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)

                self:sendHddjClicked_(v[4])
            end)
            :pos(v[2],v[3]+50)
            :addTo(self)
    end

    self:pos(display.cx, display.cy)

    self.isShowTips_ = false
    if tx.userData.hddjnum <= 0 and not tx.checkIsVip() then
        self.isShowTips_ = true
    end
end

function DealerHddjDialog:sendHddjClicked_(hddjId)
    if self.ctx_.model:isSelfInSeat() then
        if self.isSending then
            return
        end

        if self.isShowTips_ and tx.userData.isShowVipPropTips then
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("VIP", "SEND_PROPS_TIPS_2"),
                firstBtnText =sa.LangUtil.getText("VIP", "COST_CHIPS", 20000),
                secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
                callback = function(param)
                    if param == tx.ui.Dialog.FIRST_BTN_CLICK then
                        tx.userData.isShowVipPropTips = false
                        self:sendHddj_(hddjId)
                    elseif param == tx.ui.Dialog.SECOND_BTN_CLICK then
                        tx.PayGuideManager:openStore(4)
                    end
                end
            }):show()
        else
            self:sendHddj_(hddjId)
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_NOT_IN_SEAT"))
    end
end

function DealerHddjDialog:sendHddj_(hddjId)
    self.isSending = true
    local ctx = self.ctx_

    -- sa.HttpService.CANCEL(self.useHDDJId_)
    self.useHDDJId_ = sa.HttpService.POST(
        {
            mod = "Props",
            act = "useUserProps"
        },
        function (data)
            self.isSending = nil
            local callData = json.decode(data)
            if callData and callData.code >= 1 then
                tx.userData.hddjnum = tonumber(callData.num)
                ctx.animManager:playHddjAnimation(ctx.model:selfSeatId(), -100, hddjId)
                tx.socket.HallSocket:sendHddj(hddjId, ctx.model:selfSeatId(), -100)

                if self.this_ then
                    self:hide()
                end
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_FAILED"))
            end
        end,
        function()
            self.isSending = nil
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "SEND_HDDJ_FAILED"))
        end)
end

function DealerHddjDialog:onCleanup()
    -- sa.HttpService.CANCEL(self.useHDDJId_)
end

function DealerHddjDialog:show()
    tx.PopupManager:addPopup(self, isModal ~= false, false, closeWhenTouchModel ~= false, false)
    return self
end

function DealerHddjDialog:onShowed()
end

function DealerHddjDialog:hide()
    tx.PopupManager:removePopup(self)
    return self
end

return DealerHddjDialog