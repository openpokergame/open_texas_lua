local LoginRewardView = class("LoginRewardView", function()
    return display.newNode()
end)

local logger = sa.Logger.new("LoginRewardView")
local LoginRewardInfo = import(".LoginRewardInfo")

local WIDTH, HEIGHT = 1210, 686
local MAX_DAYS = 7
local CUR_DAYS --当前签到的天数

local VIP_ICONS = {
    "#common/vip_level_icon_1.png",
    "#common/vip_level_icon_2.png",
    "#common/vip_level_icon_3.png",
    "#common/vip_level_icon_4.png",
}

local LEVEL_NAME
function LoginRewardView:ctor()
    self:setNodeEventEnabled(true)

    CUR_DAYS = nil

    LEVEL_NAME = sa.LangUtil.getText("VIP", "LEVEL_NAME")

    self.this_ = self

    display.addSpriteFrames("login_reward_texture.plist", "login_reward_texture.png", function()
        self:addMainUI_()
    end)
end

function LoginRewardView:addMainUI_()
    display.newScale9Sprite("#common/pop_bg.png", 0, 0, cc.size(WIDTH + 56, HEIGHT + 60), cc.rect(170, 170, 1, 1))
        :addTo(self)

    local bg = display.newSprite("img/login_reward_bg.jpg")
        :addTo(self)
    bg:setTouchEnabled(true)
    self.bg_ = bg

    local x = WIDTH*0.5
    display.newSprite("#lang/login_reward_title.png")
        :pos(x, HEIGHT - 40)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
        :pos(WIDTH - 50, HEIGHT - 40)
        :onButtonClicked(handler(self, self.onCloseClicked_))
        :addTo(bg)

    self:addNormalRewardNode_()

    self:addVipRewardNode_()

    self:addFbRewardNode_()

    local btn_w, btn_h = 352, 146
    local btn_x, btn_y = x, 57
    self.signBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed="#common/btn_big_green_down.png"}, {scale9 = true, capInsets= cc.rect(45, 55, 1, 1)})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({size=36, text=sa.LangUtil.getText("LOGINREWARD", "REWARD_BTN", self.todayTotalReward_)}))
        :onButtonClicked(buttontHandler(self, self.onSignClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()

    --分享
    self.shareBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9=true, capInsets= cc.rect(45, 55, 1, 1)})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("COMMON", "SHARE"), size=36}))
        :onButtonClicked(buttontHandler(self, self.onShareClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()

    self:updateRewardState_()
end

function LoginRewardView:addNormalRewardNode_()
    local frame_w, frame_h = 1246, 272
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 268)
        :addTo(self.bg_)
    
    local rewardMoney = tx.userData.loginReward.rewardMoney.base
    local day = tx.userData.loginReward.day + 1
    if day > MAX_DAYS then
        day = MAX_DAYS
    end
    local todayReward = rewardMoney[day .. ""]
    self.baseReward_ = todayReward
    self.todayTotalReward_ = self.baseReward_

    self.rewardList_ = {}

    local dir = 170
    local sx, sy = frame_w*0.5 - dir*3, 0
    for i = 1, MAX_DAYS do
        self.rewardList_[i] = LoginRewardInfo.new({index = i, reward = rewardMoney[i .. ""]})
            :align(display.BOTTOM_CENTER, sx, sy)
            :addTo(frame)
        sx = sx + dir
    end
end

function LoginRewardView:addVipRewardNode_()
    local frame_w, frame_h = 1136, 58
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.LEFT_BOTTOM, 90, 188)
        :addTo(self.bg_)

    local label_y = frame_h*0.5 - 5
    local label = ui.newTTFLabel({text=sa.LangUtil.getText("LOGINREWARD", "VIP_REWARD_TIPS"), size = 26})
        :align(display.LEFT_CENTER, 0, label_y)
        :addTo(frame)
    local labelSize = label:getContentSize()

    local level = tonumber(tx.userData.loginReward.vipLevel)
    self.vipReard_ = tx.userData.loginReward.rewardMoney.vip
    local sx, sy = labelSize.width + 50, frame_h*0.5
    for i = 1, 3 do
        local isVip = false
        local z = 1
        if i == level then
            isVip = true
            z = 2
        end

        local reward, dir = self:createVipReward_(isVip, sx, sy, i)
        reward:addTo(frame, z)

        sx = sx + dir
    end
end

function LoginRewardView:createVipReward_(isVip, x, y, index)
    local node = display.newNode()

    local fontName = "fonts/denglu01.fnt"
    local offsetY = -12
    local textColor = cc.c3b(0xbd, 0x31, 0xcd)
    local iconColor = styles.FONT_COLOR.GREY_TEXT
    if isVip then
        fontName = "fonts/xiaohuang.fnt"
        offsetY = -4
        textColor = cc.c3b(0xff, 0xff, 0xff)
        iconColor = cc.c3b(0xff, 0xff, 0xff)
        self.todayTotalReward_ = self.todayTotalReward_ + self.vipReard_[""..index]
    end

    local frame = display.newScale9Sprite("#login_reward_frame.png")
        :addTo(node)

    local s = 0.9
    local icon = display.newSprite(VIP_ICONS[index])
        :scale(s)
        :pos(x, y)
        :addTo(node)
    icon:setColor(iconColor)

    local label_1 = ui.newTTFLabel({text = LEVEL_NAME[index], size = 24, color = textColor})
        :addTo(node)

    local label_2 = ui.newBMFontLabel({text = self.vipReard_[""..index], font = fontName})
        :addTo(node)

    local iconSize = icon:getContentSize()
    local size_1 = label_1:getContentSize()
    local size_2 = label_2:getContentSize()
    local icon_w = iconSize.width*s
    local dir_1, dir_2 = 0, 5
    local label_1_x, label_1_y = x + icon_w*0.5 + dir_1, y - 5
    local label_2_x, label_2_y = label_1_x + size_1.width + dir_2, label_1_y + offsetY
    local w = icon_w*0.5 + dir_1 + size_1.width + dir_2 + size_2.width

    label_1:align(display.LEFT_CENTER, label_1_x, label_1_y)
    label_2:align(display.LEFT_CENTER, label_2_x, label_2_y)

    if isVip then
        display.newSprite("#login_reward_ok.png")
            :pos(label_2_x + size_2.width, label_1_y)
            :addTo(node)
        w = w + 60
    else
        w = w + 40
    end

    frame:size(w, 50):align(display.LEFT_CENTER, x - icon_w*0.5, label_1_y)

    w = w + 5

    return node, w
end

--FB奖励提示
function LoginRewardView:addFbRewardNode_()
    local frame_w, frame_h = 1136, 64
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.LEFT_BOTTOM, 90, 110)
        :addTo(self.bg_)

    local icon = display.newSprite("#login_fb_reward_icon.png")
        :addTo(frame)

    local label_1 = ui.newTTFLabel({text=sa.LangUtil.getText("LOGINREWARD", "FB_REWARD_TIPS"), size = 26})
        :addTo(frame)

    local fontName = "fonts/denglu01.fnt"
    local offsetY = -12
    local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
    if lastLoginType == "FACEBOOK" then
        fontName = "fonts/xiaohuang.fnt"
        offsetY = -4
        self.todayTotalReward_ = self.todayTotalReward_ + self.baseReward_
    end

    local label_2 = ui.newBMFontLabel({text = sa.LangUtil.getText("LOGINREWARD", "FB_REWARD", self.baseReward_, self.baseReward_*2), font = fontName})
        :addTo(frame)

    local size_1 = label_1:getContentSize()
    local size_2 = label_2:getContentSize()
    local dir_1, dir_2 = 42, 15
    local w = size_1.width + dir_1 + size_2.width + dir_2
    -- local icon_x, icon_y = frame_w*0.5 - w*0.5, frame_h*0.5
    local icon_x, icon_y = 0, frame_h*0.5
    local label_1_x, label_1_y = icon_x + dir_1, icon_y
    local label_2_x, label_2_y = label_1_x + size_1.width + dir_2, icon_y + offsetY

    icon:align(display.LEFT_CENTER, icon_x, icon_y)
    label_1:align(display.LEFT_CENTER, label_1_x, label_1_y)
    label_2:align(display.LEFT_CENTER, label_2_x, label_2_y)

    if lastLoginType == "FACEBOOK" then
        display.newSprite("#login_reward_ok.png")
            :pos(label_2_x + size_2.width, label_2_y)
            :addTo(frame)
    end
end

function LoginRewardView:updateRewardState_()
    local loginReward = tx.userData.loginReward
    if loginReward.canReward == 1 then
        self.signBtn_:show()
    else
        self.shareBtn_:show()
    end

    CUR_DAYS = loginReward.day + 1 --loginReward.day表示已经领了多少天，初始返回0
    -- if CUR_DAYS > MAX_DAYS then
    --     CUR_DAYS = MAX_DAYS -- 没领取 默认亮最后一天
    -- end

    for i = 1, MAX_DAYS do
        if CUR_DAYS and i < CUR_DAYS then
            self.rewardList_[i]:showAlreadyReceive()
        elseif loginReward.canReward == 1 and i == CUR_DAYS then
            self.rewardList_[i]:showCanReceive()
        end
    end
    
    -- if CUR_DAYS < MAX_DAYS then
    --     local nextDay = CUR_DAYS
    --     if loginReward.canReward == 1 then
    --         nextDay = CUR_DAYS + 1
    --     end
    --     self.rewardList_[nextDay]:showNextCanReceive()
    -- end
end

function LoginRewardView:onCloseClicked_()
    tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
    self:hidePanel_()
end

function LoginRewardView:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function updateSignStatus_()
    tx.userData.loginReward.canReward = 0
    sa.DataProxy:setData(tx.dataKeys.NEW_LOGIN_REWARD, 0)
    tx.userData.loginReward.day = CUR_DAYS
end

function playAddMoneyAnimation_(reward)
    tx.userData.money = tx.userData.money + reward
    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=reward}})
end

function LoginRewardView:onSignClicked_()
    app:playChipsDropAnimation()

    self.signBtn_:setButtonEnabled(false)
    self:setLoading(true)

    sa.HttpService.POST(
        { 
            mod = "LoginReward",
            act = "loginRwd"
        },
        function (data)
            local callData = json.decode(data)
            
            if callData.code == 1 then
                updateSignStatus_()
                
                local reward = tonumber(callData.money) or 0
                if self.this_ then
                    self:onSignSuccess_(reward)
                else --关闭弹窗以后，领取成功，同步大厅信息
                    playAddMoneyAnimation_(reward)
                end
            else
                if self.this_ then
                    self:onSignFailed_()
                end
            end
        end,
        function()
            if self.this_ then
                self:onSignFailed_()
            end
        end
    )
end

function LoginRewardView:onSignSuccess_(money)
    self:setLoading(false)

    tx.schedulerPool:delayCall(function()
        playAddMoneyAnimation_(money)
    end, 1.5)

    self.signBtn_:hide()

    self.shareBtn_:show()
    if self.rewardList_[CUR_DAYS] then
        self.rewardList_[CUR_DAYS]:showAlreadyReceive()
    end
end

function LoginRewardView:onSignFailed_()
    self.signBtn_:setButtonEnabled(true)
    self:setLoading(false)
    tx.TopTipManager:showToast(sa.LangUtil.getText("LOGINREWARD", "GET_REWARD_FAILED"))
end

function LoginRewardView:onShareClicked_()
    if tx.userData.loginReward.money then
        local feedData = clone(sa.LangUtil.getText("FEED", "LOGIN_REWARD"))
        feedData.name = sa.LangUtil.formatString(feedData.name, tx.userData.loginReward.money)
        tx.ShareSDK:shareFeed(feedData, function(success, result)
            logger:debug("FEED.LOGIN_REWARD result handler -> ", success, result)
            if success then
                self:hidePanel_()
            end
        end)
    end
end

function LoginRewardView:onRemovePopup(removeFunc)
    if removeFunc then
        if self.closeCallback_ then
            self.closeCallback_()
        end

        removeFunc()
    end
end

function LoginRewardView:showPanel()
    tx.PopupManager:addPopup(self, true, true, true, true)
    return self
end

function LoginRewardView:hidePanel_()
    tx.PopupManager:removePopup(self)
end

function LoginRewardView:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function LoginRewardView:onCleanup()
    display.removeSpriteFramesWithFile("login_reward_texture.plist", "login_reward_texture.png")
end

return LoginRewardView
