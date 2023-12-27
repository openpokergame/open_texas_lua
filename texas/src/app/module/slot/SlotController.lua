local SlotController = class("SlotController")

function SlotController:ctor(view)
    self.view_ = view

    self.isInRoom_ = self.view_:isInRoom()

    self:getShowSlot_()

    self.isOpened_ = true

    self.isPlayChange_ = false --是否播放了玩家属性变化动画
end

--获取老虎机帮助配置
function SlotController:getShowSlot_()
    local getConfig
    local retry = 3
    getConfig = function()
        sa.HttpService.POST({
            mod = "Slot",
            act = "getShowSlot"
        },
        function(data)
            local jsn = json.decode(data)
            if jsn and jsn.code == 1 then
                self.slotconfig = jsn.data
            else
                retry = retry - 1
                if retry > 0 then
                    getConfig()
                end
            end
        end,
        function()
            retry = retry - 1
            if retry > 0 then
                getConfig()
            end
        end)
    end
    getConfig()
end

function SlotController:getSlotconfig()
    return self.slotconfig
end

--转动老虎机
function SlotController:playSlot(betMoney)
    if self.isOpened_ then
        tx.SoundManager:playSound(tx.SoundManager.SLOT_START)
    end

    if self.isInRoom_ then
        self.view_:playHandlerAnimation()
    end

    self:playSlot_(betMoney)   
end

--发送请求，获取摇奖结果
function SlotController:playSlot_(betMoney)
    local whereclick = 1  -- whereclick = int 0在房间，1在大厅
    if self.isInRoom_ then
        whereclick = 0
    end

    self.tempData_ = nil
    self.isPlayChange_ = false
    self.slotActive = true
    self.slotRequestId_ = sa.HttpService.POST({
            mod = "Slot",
            act = "ernieSlot",
            money = betMoney,
            whereclick = whereclick,
        },
        function(data)
            local result = json.decode(data)
            if result and result.code == 1 then
                self.tempData_ = result
                local totalNum = tonumber(result.money)  -- 转动后最终剩余筹码(包括奖励的)
                local moneyNum = tonumber(result.addmoney) -- 本次转动后奖励筹码
                local rewardArr = string.split(result.cardtype, ",")
                local values = {tonumber(rewardArr[1]), tonumber(rewardArr[2]), tonumber(rewardArr[3])}
                tx.userData.money = tonumber(tx.userData.money) - tonumber(betMoney)
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, noShow=false, data={money=-betMoney}})
                self:playSlotCallback_({values = values, totalNum = totalNum, rewardMoney = moneyNum})
            else
                self.view_:stopRunningAnim()  -- 停止转动动画
                if result and result.code == -3 then --钱不够
                    self:playSlotFailedCallback_(sa.LangUtil.getText("SLOT","NOT_ENOUGH_MONEY"))
                else
                    self:playSlotFailedCallback_(sa.LangUtil.getText("SLOT","BUY_FAILED"))
                end
            end
        end,
        function()
            self.view_:stopRunningAnim()  -- 停止转动动画
            self:playSlotFailedCallback_(sa.LangUtil.getText("SLOT","BUY_FAILED"))
        end
    )
end

function SlotController:playSlotFailedCallback_(msg)
    self.slotActive = false
    tx.TopTipManager:showToast(msg)
    if self.view_ then
        self.view_:playSlotFailed()
    end
end

--转动结束回调
function SlotController:slotScrollViewCallback(i, rewardMoney, leftMoney)
    if self.isOpened_ then
        tx.SoundManager:playSound(tx.SoundManager.SLOT_END)
    end

    self.slotActive = false

    if i == 1 and self.loopSoundId then
        audio.stopSound(self.loopSoundId)
    elseif i == 3 then
        self.view_:stopRunningAnim()  -- 停止转动动画
        if rewardMoney > 0 then
            -- tx.TopTipManager:showGoldTips(sa.LangUtil.getText("SLOT", "PLAY_WIN", sa.formatBigNumber(tonumber(rewardMoney))))
            if self.isOpened_ then
                tx.SoundManager:playSound(tx.SoundManager.SLOT_WIN)
                self.view_:playChipAnimation()
                self.view_:playSlotSuccessCallback(rewardMoney, function()
                    if self.slotActive then
                        self.view_:setFlashViewTip()
                    end
                end)
            else
                self.view_:playGlowAnimation()
                self.view_:playAddMoneyAnimation(rewardMoney)
            end
            self.isPlayChange_ = true
            tx.userData.money = tonumber(leftMoney)
            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, noShow=false, data={money=rewardMoney}})
        end

        --自动操作的情况
        self.view_:checkAutoBet()
    end
end

--自动摇奖回调
function SlotController:autoBetCallback(isChecked)
    if isChecked then
        if not self.slotActive then
            self.view_:loopAutoBet()
        end
    else
        if not self.slotActive then
            self.view_:updateSpinBetBtnStatus(true)
        end
        self.view_:stopLoopAutoBet()
    end
end

--摇奖成功回调
function SlotController:playSlotCallback_(data)
    if self.view_ then
        if self.isOpened_ then
            self.loopSoundId = tx.SoundManager:playSound(tx.SoundManager.SLOT_LOOP, true)
        end

        self.view_:playSlotSuccess(data)
    else
        self:userPropertyChange_()
    end
end

--设置是否展开，只在房间里调用
function SlotController:setIsOpened(isOpened)
    self.isOpened_ = isOpened
end

function SlotController:userPropertyChange_()
    if self.tempData_ then
        local rewardMoney = tonumber(self.tempData_.addmoney)
        if rewardMoney > 0 then
            tx.userData.money = tonumber(self.tempData_.money)
            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, noShow=false, data={money=rewardMoney}})
        end
    end
end

function SlotController:dispose()
    self.view_ = nil
    if self.tempData_ and (not self.isPlayChange_) then
        self:userPropertyChange_()
    end
    
    if self.loopSoundId then
        audio.stopSound(self.loopSoundId)
    end
end

return SlotController
