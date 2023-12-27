local PlayCardPopup = class("PlayCardPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 620, 570 --弹窗大小

function PlayCardPopup:ctor(blind)
    PlayCardPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("NEWESTACT", "PLAY_CARD_TITLE"))

    self:addSecondFrame()

    self:pos(display.width + WIDTH * 0.5, display.cy + 20)

    self.this_ = self

    self.blind_ = blind

    self:getPlayNum_()
end

function PlayCardPopup:addMainUI_()
    self.data_ = {}
    local config = tx.userData.playPokerConfig
    local data = config.reward
    local playNum = tx.userData.playPokerNum
    for i, v in ipairs(data) do
        local data_ = {}
        local progress = playNum
        if progress > v.playNum then
            progress = v.playNum
        end

        data_.progress = progress
        data_.target = v.playNum
        data_.money = v.money
        data_.status = v.rwdFlag

        self.data_[i] = data_
    end

    -- local time = config.dayTime
    -- if config.hourTime then
    --     time = config.hourTime
    -- end
    -- ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT", "PLAY_CARD_TIME", time), size = 20, color = cc.c3b(0xff, 0xee, 0x63)})
    --     :pos(WIDTH*0.5, HEIGHT - 105)
    --     :addTo(self.background_)

    local sy = HEIGHT - 260
    for i = 1, 2 do
        display.newScale9Sprite("#common/setting_item_line.png", 0, 0, cc.size(WIDTH - 56, 2))
            :pos(WIDTH*0.5, sy)
            :addTo(self.background_)
        sy = sy - 140
    end

    sy = HEIGHT - 190
    self.infoNode_ = {}
    for i = 1, #self.data_ do
        self.infoNode_[i] = self:createInfoNode_(i, sy)
        sy = sy - 140
    end
end

function PlayCardPopup:createInfoNode_(index, y)
    local data = self.data_[index]
    local node = display.newNode()
        :pos(100, y)
        :addTo(self.background_)

    local icon = display.newSprite("#commonroom/play_crad_act_btn.png")
        :addTo(node)

     ui.newBMFontLabel({text = data.target, font = "fonts/shangcheng.fnt"})
        :pos(75, 83)
        :addTo(icon)

    local progress_w, progress_h = 136, 22
    local progress = tx.ui.ProgressBar.new(
        "#common/common_progress_bg.png", 
        "#common/common_progress.png", 
        {
            bgWidth = progress_w, 
            bgHeight = progress_h, 
            fillWidth = 26, 
            fillHeight = 20
        }
    )
    :align(display.LEFT_CENTER, 70, 0)
    :setValue(data.progress / data.target)
    :addTo(node)

    --进度文字
    ui.newTTFLabel({text = data.progress.."/"..data.target, size = 20, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(progress_w/2, 0)
        :addTo(progress)

    local money = ui.newTTFLabel({text = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatBigNumber(data.money)), size = 26})
        :align(display.LEFT_CENTER, 210, 0)
        :addTo(node)
    sa.fitSprteWidth(money, 140)

    local btn_x = 420
    local label = ui.newTTFLabel({text = "", size = 26, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(btn_x, 0)
        :addTo(node)
        :hide()

    local btn = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(160, 104)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "GET_REWARD"), size = 24}))
        :pos(btn_x, 0)
        :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
        :addTo(node)
        :hide()
    btn:setTag(index)

    if data.status == 0 then
        label:show():setString(sa.LangUtil.getText("COMMON", "NOT_FINISH"))
    elseif data.status == 1 then
        btn:show()
    elseif data.status == 2 then
        label:show():setString(sa.LangUtil.getText("COMMON", "ALREADY_GET"))
    end
    sa.fitSprteWidth(label, 126)

    node.label = label
    node.btn = btn

    return node
end

function PlayCardPopup:onGetRewardClicked_(evt)
    local tag = evt.target:getTag()
    local btn = evt.target
    btn:setButtonEnabled(false)
    sa.HttpService.POST(
    {
        mod = "Activity",
        act = "playPokerRwd",
        flag = self.data_[tag].target,
        blind = self.blind_,
    },
    function(data)
        local callData = json.decode(data)
        if callData.code == 1 then
            local reward = {
                rewardType = 1,
                num = callData.money
            }

            tx.ui.RewardDialog.new(reward):showPanel()

            tx.userData.playPokerConfig.reward[tag].rwdFlag = 2

            sa.EventCenter:dispatchEvent(tx.eventNames.UPDATE_PLAY_CARD_STATUS)

            if self.this_ then
                self:showAlreadyReceive_(tag)
            end
        else
            if btn then
                btn:setButtonEnabled(true)
            end
        end
    end,
    function()
        if btn then
            btn:setButtonEnabled(true)
        end
    end)
end

function PlayCardPopup:getPlayNum_()
    self:setLoading(true)
    tx.getPlayPokerNum(self.blind_, function(data)
        if self.this_ then
            self:setLoading(false)
            self:addMainUI_(data)
        end
    end)
end

function PlayCardPopup:showAlreadyReceive_(index)
    local node = self.infoNode_[index]
    node.btn:hide()
    node.label:show():setString(sa.LangUtil.getText("COMMON", "ALREADY_GET"))
    sa.fitSprteWidth(node.label, 126)
end

function PlayCardPopup:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function PlayCardPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width + WIDTH * 0.5, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function PlayCardPopup:onShowPopup()
    self:stopAllActions()
    transition.moveTo(self, {time=0.2, x=display.width - WIDTH * 0.5 + 26, easing="OUT"})
end

function PlayCardPopup:onCleanup() 
end

return PlayCardPopup