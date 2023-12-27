local MainHallView = class("MainHallView", function ()
    return display.newNode()
end)

local UserInfoPopup       = import("app.module.userInfo.UserInfoPopup")
local FriendPopup         = import("app.module.friend.FriendPopup")
local FriendData          = import("app.module.friend.FriendData")
local RankingPopup        = import("app.module.ranking.RankingPopup")
local SettingPopup        = import("app.module.setting.SettingPopup")
local HelpPopup           = import("app.module.help.HelpPopup")
local MessagePopup        = import("app.module.message.MessagePopup")
local DailyTasksPopup     = import("app.module.dailytasks.DailyTasksPopup")
local MessageData         = import("app.module.message.MessageData")
local AvatarIcon          = import("openpoker.ui.AvatarIcon")
local InviteView          = import("app.module.hall.invite.InviteView")
local SimpleAvatar        = import("openpoker.ui.SimpleAvatar")
local CountLabel          = import("openpoker.ui.CountLabel")
local FreeChipView        = import("app.module.hall.FreeChipView")
local ChooseGameView      = import("app.module.hall.ChooseGameView")
local ActivityCenterPopup = import("app.module.newestact.ActivityCenterPopup")
local BindGuestView       = import("app.module.setting.BindGuestView")
local BindRewardView      = import("app.module.setting.BindRewardView")
local FirstPayPopup       = import("app.module.payguide.firstpay.FirstPayPopup")
local MoreGameView        = import("app.module.hall.MoreGameView")
local PrivateScene        = import("app.module.privateroom.PrivateScene")
local ExchangeCodePopup   = import("app.module.exchangecode.ExchangeCodePopup")

local BOTTOM_PANEL_W, BOTTOM_PANEL_H = display.width, 134
local TOP_PANEL_W, TOP_PANEL_H = display.width, 110
local BOTTOM_PANEL_SHOW_Y, BOTTOM_PANEL_HIDE_Y = -display.cy, -display.cy - BOTTOM_PANEL_H - 100
local TOP_PANEL_SHOW_Y, TOP_PANEL_HIDE_Y = display.cy, display.cy + TOP_PANEL_H + 100 --顶部面板不可见时坐标
local LEFT_NODE_SHOW_X, LEFT_NODE_HIDE_X = 0, -400
local RIGHT_NODE_SHOW_X, RIGHT_NODE_HIDE_X = display.cx - 15, display.cx + 800
local MIDDLE_BTN_X = -215 --中间快捷按钮坐标
local RIGHT_BOTTOM_NODE_HIDE_X = display.cx + 900
local GAME_TITLE = {
    "lang/hall_more_game_title.png",
    "lang/hall_texas_must_title.png",
    "lang/hall_omaha_title.png",
    "lang/hall_private_btn_title.png",
    "lang/hall_redblack_title.png",
    "lang/hall_texas_title.png",
}
local MORE_GAME_TAG = 1
local TEXAS_MUST_TAG = 2
local OMAHA_TAG = 3
local PRIVATE_TAG = 4
local REDBLACK_TAG = 5
local TEXAS_TAG = 6

function MainHallView:ctor(controller, tablePos)
    self.this_ = self
    self.controller_ = controller

    self.controller_:setDisplayView(self)

    self:setNodeEventEnabled(true)

    --添加顶部节点(首充礼包,账号升级,好友,消息中心,帮助,设置)
    self:addTopNode_()

    --添加中间左边节点(排行榜)
    self:addMiddleLeftNode_()

    --添加中间右边节点(游戏类型选择)
    self:addMiddleRightNode_()

    --添加底部结点(商城,活动中心,排行榜,任务,快速开始)
    self:addBottomNode_()

    -- 添加数据观察器
    self:addPropertyObservers()

    sa.DataProxy:setData(tx.dataKeys.NEW_LOGIN_REWARD, tx.userData.loginReward.canReward)

    self.controller_:checkLuckturnFreeTimes()

    -- 初始化友盟
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:start("analytics.UmengAnalytics")
    end

    self:accelerometerLayer_()

    self:updateCrashBtn()

    MessageData.requestMessageData(true)-- 请求红点  保证初始化拉取一次

    -- self:setNodeEventEnabled(true)

end

--重力层，摇一摇功能
function MainHallView:accelerometerLayer_()
    local layer = cc.Layer:create()
    layer:addTo(self)
    layer:setAccelerometerEnabled(true)
    self.acclayer_ = layer

    local label = ui.newTTFLabel({text = "", size = 26})
        :addTo(layer)

    local UPTATE_INTERVAL_TIME = 200 -- 两次检测的时间间隔
    local SPEED_SHRESHOLD = 1000 --调节灵敏度,速度阈值，当摇晃速度达到这值后产生作用
    local lastUpdateTime = 0
    local lastX = 0
    local lastY = 0
    local lastZ = 0

    -- 用来回调的方法
    local function accelerometerListener(event,x,y,z,timestamp)
        -- 计算球下落的位置
        local currentUpdateTime = sa.getTime() * 1000
        local timeInterval = currentUpdateTime - lastUpdateTime
        if timeInterval < UPTATE_INTERVAL_TIME then
            return
        end

        x = x * 10
        y = y * 10
        z = z * 10

        lastUpdateTime = currentUpdateTime
        local deltaX = x - lastX
        local deltaY = y - lastY
        local deltaZ = z - lastZ

        lastX = x
        lastY = y
        lastZ = z

        local speed = (math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ) / timeInterval) * 10000
        if speed >= SPEED_SHRESHOLD + 500 then
            local curScene = display.getRunningScene()
            curScene:playGirlAnimation(5)

            local num = math.random(1000)
            if num <= 100 then
                curScene:showGirlChat()
            end
        elseif speed >= SPEED_SHRESHOLD then
            local curScene = display.getRunningScene()
            curScene:playGirlAnimation(4)
        end
    end

    -- 创建一个重力加速计事件监听器
    local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)
    -- 获取事件派发器然后设置触摸绑定到精灵，优先级为默认的0
    layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner, label)
end

function MainHallView:addMiddleLeftNode_()
    self.leftNode_ = display.newNode()
        :addTo(self)

    self.inviteView_ = InviteView.new()
        :align(display.LEFT_CENTER, -display.cx + 10, 15)
        :addTo(self.leftNode_)
end

function MainHallView:addMiddleRightNode_()
    local w, h = display.width*0.5, 500
    self.rightNode_ = display.newNode()
        :size(w, h)
        :align(display.RIGHT_CENTER, RIGHT_NODE_SHOW_X, 15)
        :addTo(self)

    local btn_w, btn_h = 210, 240
    local dir_w = (w - btn_w*3)/2
    local x, y = btn_w*0.5, h - 120
    self.gameList_ = {}
    local btnType = {5, 3, 2, 13, 4, 1}
    for i, v in ipairs(GAME_TITLE) do
        local btn = self:createMiddleRightBtn_(btnType[i], "#" .. v, x, y)
        btn:setTag(i)

        self.gameList_[i] = btn
        if i == MORE_GAME_TAG then
            self.freeChipPoint_ = display.newSprite("#common/common_red_point.png")
                :pos(btn_w - 10, btn_h - 10)
                :addTo(btn)
                :hide()
        end

        x = x + btn_w + dir_w
        if i == 3 then
            x = btn_w*0.5
            y = y - btn_h - 20
        end
    end

    self:setGameLockStatus_()
end

function MainHallView:createMiddleRightBtn_(btnType, title, x, y)
    local w, h = 210, 240
    local btn = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(w, h)
        :align(display.CENTER, x, y)
        :addTo(self.rightNode_)
    btn:setAnimation(0, btnType, true)
    ScaleButton(btn, 0.95):onButtonClicked(buttontHandler(self, self.onChooseGameClicked_))

    btn.wordIcon = display.newSprite(title)
        :align(display.CENTER, w*0.5, 55)
        :addTo(btn)

    return btn
end

function MainHallView:onChooseGameClicked_(evt)
    local tag = evt.target:getTag()

    if tag == TEXAS_TAG then
        app:enterGameHall(1)
    elseif tag == OMAHA_TAG then
        self:onOmahaClicked_()
    elseif tag == PRIVATE_TAG then
        PrivateScene.new(2):showPanel()
    elseif tag == REDBLACK_TAG then
        self:onRedblackClicked_()
    elseif tag == TEXAS_MUST_TAG then
        self:onTexasMustClicked_()
    elseif tag == MORE_GAME_TAG then
        MoreGameView.new(self.controller_):showPanel()
    end
end

function MainHallView:setGameLockStatus_()
    self.isOpenOmaha_ = (tx.userData.switch_aomaha == 1)
    self.isOpenRedblack_ = (tx.userData.switch_honghei == 1)
    self.isOpenTexasMust_ = (tx.userData.switch_allin == 1)

    self:createGameLock_(self.gameList_[OMAHA_TAG], self.isOpenOmaha_, tx.userData.aomahLevelLimit)
    self:createGameLock_(self.gameList_[REDBLACK_TAG], self.isOpenRedblack_, tx.userData.hongheiLevelLimit)
    self:createGameLock_(self.gameList_[TEXAS_MUST_TAG], self.isOpenTexasMust_, tx.userData.allinLevelLimit)
end

function MainHallView:createGameLock_(parent, isOpen, limitLevel)
    local level = tx.userData.level
    if not isOpen or (level < limitLevel) then
        local x, y = 106, 121
        local lock = display.newSprite("#hall/hall_game_lock.png")
            :pos(x, y)
            :addTo(parent)

        local btn_y = y - 30
        if not isOpen then
            parent.label = ui.newTTFLabel({text=sa.LangUtil.getText("MATCH", "EXPECT_TIPS"), size = 26})
                :pos(x, btn_y)
                :addTo(lock)
        elseif isOpen and level < limitLevel then
            parent.label = ui.newTTFLabel({text="LV " .. limitLevel, size = 30})
                :pos(x, btn_y)
                :addTo(lock)
        end

        sa.fitSprteWidth(parent.label, 200)
        parent.label.isOpen = isOpen
    end
end

function MainHallView:onOmahaClicked_()
    if self.isOpenOmaha_ then
        app:enterOmahaHall()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function MainHallView:onRedblackClicked_()
    if self.isOpenRedblack_ then
        app:enterRedblcakRoom()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function MainHallView:onTexasMustClicked_()
    if self.isOpenTexasMust_ then
        app:enterTexasMustHall()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function MainHallView:addTopNode_()
    local w, h = TOP_PANEL_W, TOP_PANEL_H
    self.topNode_ = display.newNode()
        :size(w, h)
        :align(display.TOP_CENTER, 0, TOP_PANEL_SHOW_Y)
        :addTo(self)
    local node = self.topNode_

    display.newScale9Sprite("#hall/hall_top_bg.png", 0, 0, cc.size(w, h))
        :pos(w/2, h/2)
        :addTo(node)

    local logo_w = 466
    local logo = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(logo_w, 92)
        :align(display.CENTER, w*0.5, h*0.5 + 7)
        :addTo(node)
    logo:setAnimation(0, 8, true)

    local dir = (w - logo_w)*0.5/3
    local btn_x, btn_y = dir*0.5 + 5, h*0.5 + 20
    self.inviteCodeBtn_ = self:addTopButton_(
        12,
        "#lang/hall_invite_friend_title.png",
        btn_x, btn_y,
        buttontHandler(self, self.onExchangeCodeClicked_),
        10
    )

    btn_x = btn_x + dir
    if tx.userData and tonumber(tx.userData.level) and tonumber(tx.userData.level)<3 then
        self.tutorialBtn_ = self:addTopButton_(
            9,
            "#lang/hall_tutorial_title.png",
            btn_x + 10, btn_y,
            buttontHandler(self, self.onTutorialClicked_)
        )
    else
       self.bindBtn_ = self:addTopButton_(
            10,
            "#lang/hall_bind_account_title.png",
            btn_x + 10, btn_y,
            buttontHandler(self, self.onBindClicked_),
            -5
        )

        if tx.getBindGuestStatus() > 0 then
            self.bindBtn_:show()
        else
            self.bindBtn_:hide()
        end
    end

    btn_x = btn_x + dir
    if tx.userData.payStatus == 0 then
        self.firstPayBtn_ = self:addTopButton_(
            11,
            "#lang/hall_first_title.png",
            btn_x, btn_y,
            buttontHandler(self, self.onPayActivityClicked_)
        )
    end

    -- 设置
    dir = (w - logo_w)*0.5/4
    btn_x, btn_y = w - dir*0.5, h*0.5 + 5
    self:addPopupOptionButton_(
        node,
        "#hall/hall_setting_btn_normal.png", 
        "#hall/hall_setting_btn_pressed.png",
        btn_x, btn_y,
        buttontHandler(self, self.onSettingClicked))

    --帮助
    btn_x = btn_x - dir
    self:addPopupOptionButton_(
        node,
        "#hall/hall_help_btn_normal.png", 
        "#hall/hall_help_btn_pressed.png",
        btn_x, btn_y,
        buttontHandler(self, self.onHelpClicked))

    --信息
    btn_x = btn_x - dir
    self:addPopupOptionButton_(
        node,
        "#hall/hall_message_btn_normal.png", 
        "#hall/hall_message_btn_pressed.png",
        btn_x, btn_y,
        buttontHandler(self, self.onMessageClicked))

    self.newMessagePoint = display.newSprite("#common/common_red_point.png")
        :pos(btn_x + 30, btn_y + 25)
        :addTo(node)
        :hide()

    --活动
    btn_x = btn_x - dir
    self:addPopupOptionButton_(
        node,
        "#hall/hall_act_btn_normal.png", 
        "#hall/hall_act_btn_pressed.png",
        btn_x, btn_y,
        buttontHandler(self, self.onActivityClicked_), 0.9)

    if tx.userData.isShowActPoint and tx.userData.isShowActivity == 1 then
        self.activityPoint_ = display.newSprite("#common/common_red_point.png")
            :pos(btn_x + 30, btn_y + 25)
            :addTo(node)
    end
end

function MainHallView:addTopButton_(btnType, titleImg, x, y, callback, wordOffsetX)
    wordOffsetX = wordOffsetX or 0
    local btn_w, btn_h = 80, 86
    local btn = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(btn_w, btn_h)
        :align(display.CENTER, x, y)
        :addTo(self.topNode_)
    btn:setAnimation(0, btnType, true)
    ScaleButton(btn, 0.9):onButtonClicked(callback)

    btn.wordIcon = display.newSprite(titleImg)
        :pos(btn_w*0.5 + wordOffsetX, 5)
        :addTo(btn)

    return btn
end

function MainHallView:addBottomNode_()
    local w, h = BOTTOM_PANEL_W, BOTTOM_PANEL_H
    self.bottomNode_ = display.newNode()
        :size(w, h)
        :align(display.BOTTOM_CENTER, 0, BOTTOM_PANEL_SHOW_Y)
        :addTo(self)
    local node = self.bottomNode_

    display.newScale9Sprite("#hall/hall_bottom_bg.png", 0, 0, cc.size(w, h))
        :pos(w/2, h/2)
        :addTo(node)

    --添加用户信息结点
    self:addUserInfoNode_()

    -- 商城按钮
    local btn_y = h*0.5 - 10
    local storeBtn = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(190, 80)
        :align(display.CENTER, 490, btn_y + 5)
        :addTo(node)
    storeBtn:setAnimation(0, 6, true)
    ScaleButton(storeBtn, 0.97):onButtonClicked(buttontHandler(self, self.onStoreClicked_))
    self.storeBtn_ = storeBtn

    local playBtn = sp.SkeletonAnimation:create("spine/datinganniu.json","spine/datinganniu.atlas")
        :size(280, 95)
        :align(display.CENTER, w - 155, btn_y)
        :addTo(node)
    playBtn:setAnimation(0, 7, true)
    ScaleButton(playBtn, 0.95):onButtonClicked(buttontHandler(self, self.onPlayNowClicked_))

    playBtn.wordIcon = display.newSprite("#lang/hall_play_now_btn_title.png")
        :pos(120, 48)
        :addTo(playBtn)
    self.playNowBtn_ = playBtn

    -- 按钮宽度
    local btn_w = (w - 575 - 295 - 15)/3
    local btn_x = 590 + btn_w*0.5
    local line_x = {370, 590, 590 + btn_w, 590 + btn_w*2}
    for i = 1, 4 do
        display.newSprite("#hall/hall_bottom_line.png")
            :pos(line_x[i], btn_y)
            :addTo(node)
    end

    -- 好友按钮
    btn_y = btn_y + 5
    self:addPopupOptionButton_(
        node,
        "#hall/hall_friend_btn_normal.png", 
        "#hall/hall_friend_btn_pressed.png",
        btn_x, btn_y,
        buttontHandler(self, self.onFriendBtnClicked))

    --有新好友数据标记
    self.newFriendPoint = display.newSprite("#common/common_red_point.png")
        :pos(btn_x + 30, btn_y + 25)
        :addTo(node)

    if FriendData.hasNewMessage then
        self.newFriendPoint:show()
    else
        self.newFriendPoint:hide()
    end

    --排行榜
    btn_x = btn_x + btn_w
    self:addPopupOptionButton_(
        node,
        "#hall/hall_ranking_btn_normal.png", 
        "#hall/hall_ranking_btn_pressed.png",
        btn_x, btn_y - 4,
        buttontHandler(self, self.onRankingClicked_))

    --任务
    btn_x = btn_x + btn_w
    self:addPopupOptionButton_(
        node,
        "#hall/hall_task_btn_normal.png", 
        "#hall/hall_task_btn_pressed.png",
        btn_x, btn_y - 4,
        buttontHandler(self, self.onDailyTaskClick))

    self.newTaskPoint = display.newSprite("#common/common_red_point.png")
        :pos(btn_x + 30, btn_y + 25)
        :addTo(node)
end

--添加用户信息结点
function MainHallView:addUserInfoNode_()
    self.avatarIcon_ = SimpleAvatar.new({
            shapeImg = "#common/head_bg.png",
            frameImg = "#hall/hall_head_frame.png",
        })
        :scale(0.7)
        :pos(100, BOTTOM_PANEL_H/2)
        :addTo(self.bottomNode_)
    NormalButton(self.avatarIcon_):onButtonClicked(buttontHandler(self, self.onUserInfoClicked_))

    local x = 190
    self.nick_ = ui.newTTFLabel({text = "", color = styles.FONT_COLOR.LIGHT_TEXT, size = 26})
        :align(display.LEFT_CENTER, x - 10, BOTTOM_PANEL_H/2 + 30)
        :addTo(self.bottomNode_)

    self.money_ = self:createPropertyLabel_("#common/common_chip_icon.png", tx.userData.money, x, BOTTOM_PANEL_H/2 - 10, styles.FONT_COLOR.CHIP_TEXT)

    self.diamond_ = self:createPropertyLabel_("#common/common_diamond_icon.png", tx.userData.diamonds, x, BOTTOM_PANEL_H/2 - 50, styles.FONT_COLOR.DIAMOND)
end

--添加底部选项
function MainHallView:addPopupOptionButton_(parent, normalImg, pressedImg, x, y, callback, s)
    s = s or 1
    cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg})
        :scale(s)
        :pos(x, y)
        :onButtonClicked(function()
            local thisTime = sa.getTime()
            if not LastClickTime or math.abs(thisTime - LastClickTime) > 1 then
                LastClickTime = thisTime
                callback()
            end
        end)
        :addTo(parent)
end

function MainHallView:createPropertyLabel_(icon, num, x, y, textColor)
    display.newSprite(icon)
        :pos(x, y)
        :scale(0.7)
        :addTo(self.bottomNode_)

    local label = CountLabel.new({text = sa.formatNumberWithSplit(num), color = textColor, UILabelType = 2})
        :setStartNum(num)
        :align(display.LEFT_CENTER, x + 20, y)
        :addTo(self.bottomNode_)

    return label
end

function MainHallView:updateCrashBtn()
    if tx.userData then
        -- 昨天破产了没有领取今天不能领取了 大于破产值也领取不了
        if tx.userData.registerReward.code==1 or 
            tx.userData.loginReward.canReward==1 or
            tx.userData.money + tx.userData.safe_money>appconfig.CRASHMONEY then
            MessageData.resetBroken()
        end
    end
end

-- 入场动画
function MainHallView:playShowAnim(isAnimation)
    local animTime = self.controller_.getAnimTime()
    local delayTime = 0.2

    self.topNode_:setPositionY(TOP_PANEL_HIDE_Y)
    self.bottomNode_:setPositionY(BOTTOM_PANEL_HIDE_Y)
    self.leftNode_:setPositionX(LEFT_NODE_HIDE_X)
    self.rightNode_:setPositionX(RIGHT_NODE_HIDE_X)

    if isAnimation then
        transition.moveTo(self.topNode_, {time = animTime, y = TOP_PANEL_SHOW_Y, delay = delayTime})
        transition.moveTo(self.bottomNode_, {time = animTime, y = BOTTOM_PANEL_SHOW_Y, delay = delayTime})
        transition.moveTo(self.leftNode_, {time = animTime, x = LEFT_NODE_SHOW_X, easing = "BACKOUT"})--, onComplete = handler(self, self.onPlayShowAnimCallBack)
        transition.moveTo(self.rightNode_, {time = animTime, x = RIGHT_NODE_SHOW_X, easing = "BACKOUT"})
    end
end

-- 出场动画
function MainHallView:playHideAnim()
    local animTime = self.controller_.getAnimTime()
    animTime = animTime * 0.1

    if self.topNode_ then
        transition.moveTo(self.topNode_, {time = animTime, y = TOP_PANEL_SHOW_Y})
    end

    transition.moveTo(self.bottomNode_, {
        time = animTime,
        y = BOTTOM_PANEL_HIDE_Y,
        onComplete = handler(self, function (obj)
            obj:removeFromParent()
        end)
    })

    if self.leftNode_ then
        transition.moveTo(self.leftNode_, {time = animTime, x = LEFT_NODE_HIDE_X, easing = "BACKOUT"})
    end

    if self.rightNode_ then
        transition.moveTo(self.rightNode_, {time = animTime, x = RIGHT_NODE_HIDE_X})
    end
end

-- 出场动画结束回调
function MainHallView:onPlayHideAnimCallBack()
    self.isPlayAnim_ = nil
end

-- 入场动画结束回调
function MainHallView:onPlayShowAnimCallBack()
    self.isPlayAnim_ = true

    if (tx.userData.loginReward.ret == 1) or (tx.userData.registerReward.code == 1) or tx.PopupManager:isHasPopup() then
        self.pengdingEndId_ = sa.EventCenter:addEventListener("PengdingPopup_End", handler(self, self.onPengdingPopupEndHandler_))
    end
end

function MainHallView:onPengdingPopupEndHandler_()
    if self.pengdingEndId_ then
        sa.EventCenter:removeEventListener(self.pengdingEndId_)
    end

    local curScene = display.getRunningScene()
    curScene:showHolidayGirlChat()
end

function MainHallView:messagePoint(hasNewMessage)
    if self.newMessagePoint then
        if hasNewMessage then
            self.newMessagePoint:show()
        else
            self.newMessagePoint:hide()
        end
    end
end

function MainHallView:friendPoint(hasNewMessage)
    if self.newFriendPoint then
        if hasNewMessage then
            self.newFriendPoint:show()
        else
            self.newFriendPoint:hide()
        end
    end
end

function MainHallView:loginRewardPoint_()
    self:dailyTasksPoint_()
end

--判断是否显示任务提示红点
function MainHallView:dailyTasksPoint_()
    if self.newTaskPoint then
        if (tx.userData.loginReward.canReward == 1 or tx.userData.canTasksReward or tx.userData.canAchieveReward) then
            self.newTaskPoint:show()
        else
            self.newTaskPoint:hide()
        end
    end
end

function MainHallView:onBindGuestReward_(evt)
    if self.bindBtn_ then
        self.bindBtn_:hide()
    end
end

function MainHallView:updateFreeChipPoint_(evt)
    if self.freeChipPoint_ then
        if evt.freeTimes > 0  then
            self.freeChipPoint_:show()
        else
            self.freeChipPoint_:hide()
        end
    end
end

function MainHallView:onHolidayShakeGirlChat_()
    local curScene = display.getRunningScene()
    curScene:showGirlChat(sa.LangUtil.getText("ACT", "CHRISTMAS_HALL_GIRL_CHAT_6"))
end

function MainHallView:onUserInfoClicked_()
    if self.isUserInfoClick_ then
        return
    end
    self.isUserInfoClick_ = true
    tx.schedulerPool:delayCall(function()
        self.isUserInfoClick_ = false
    end, 0.5)
    UserInfoPopup.new():show(false)

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_userinfo_click", label = "hall_userinfo_click"}
        }
    end
end

function MainHallView:onPayActivityClicked_()
    FirstPayPopup.new():showPanel()
end

function MainHallView:onTutorialClicked_()
    self.controller_:openTutorial()
end

function MainHallView:onBindClicked_()
    if tx.getBindGuestStatus() == 1 then
        BindGuestView.new():showPanel()
    elseif tx.getBindGuestStatus() == 2 then
        BindRewardView.new():showPanel()
    end
end

function MainHallView:onExchangeCodeClicked_()
    ExchangeCodePopup.new():showPanel()
end

function MainHallView:onActivityClicked_()
    tx.userData.isShowActPoint = 0
    if self.activityPoint_ then
        self.activityPoint_:hide()
    end
    ActivityCenterPopup.new():showPanel()
end

function MainHallView:onDailyTaskClick()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_dailytasks_click", label = "hall_dailytasks_click"}
        }
    end
    DailyTasksPopup.new():showPanel()
end

function MainHallView:onPlayNowClicked_()
    self.controller_:quickStart()
end

function MainHallView:onStoreClicked_()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_store_click", label = "hall_store_click"}
        }
    end
    tx.PayGuideManager:openStore()
end

function MainHallView:onFriendBtnClicked()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_friend_click", label = "hall_friend_click"}
        }
    end
    FriendPopup.new():showPanel()
end

function MainHallView:onRankingClicked_()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_ranking_click", label = "hall_ranking_click"}
        }
    end 
    RankingPopup.new():show()
end

function MainHallView:onMessageClicked()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_massage_click", label = "hall_massage_click"}
        }
    end
    MessagePopup.new():showPanel()
end

function MainHallView:onSettingClicked()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_setting_click", label = "hall_setting_click"}
        }
    end
    SettingPopup.new():showPanel()
end

function MainHallView:onHelpClicked()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "hall_help_click", label = "hall_help_click"}
        }
    end
    HelpPopup.new():showPanel()
end

function MainHallView:onOffCallback()
end

function MainHallView:onOffLoadCallback_()
    tx.config.HALLOWEEN_ENABLED = tx.OnOff:check("conduct")
end

function MainHallView:onRefreshMoney_()
    if not self.lastMoney_ or tonumber(self.lastMoney_) == tonumber(tx.userData.money) then
        self.money_:setString(sa.formatNumberWithSplit(tx.userData.money))
    else
        self.money_:setEndNum(tx.userData.money)
    end

    if not self.lastDiamonds_ or tonumber(self.lastDiamonds_) == tonumber(tx.userData.diamonds) then
        self.diamond_:setString(sa.formatNumberWithSplit(tx.userData.diamonds))
    else
        self.diamond_:setEndNum(tx.userData.diamonds)
    end

    self.lastMoney_ = tx.userData.money
    self.lastDiamonds_ = tx.userData.diamonds

    self:updateCrashBtn()
end

function MainHallView:onEnter()
    tx.SoundManager:playBgMusic()
    if tx.userData then
        tx.userData.inHall_ = true
    end
end

function MainHallView:onExit()
    tx.SoundManager:stopBgMusic()
    if tx.userData then
        tx.userData.inHall_  = false
    end
end

function MainHallView:onCleanup()
    tx.SoundManager:stopBgMusic()
    self.acclayer_:setAccelerometerEnabled(false)
    self:removePropertyObservers()
end

function MainHallView:addPropertyObservers()
    self.nickObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "nick", handler(self, function (obj, nick)
        obj.nick_:setString(tx.Native:getFixedWidthText("", 24, nick or "", 200))
    end))

    self.avatarUrlObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "s_picture", handler(self, function (obj, s_picture)
        if tx.userData.sex == "f" then
            self.avatarIcon_:setSpriteFrame("common/icon_female.png")
        else
            self.avatarIcon_:setSpriteFrame("common/icon_male.png")
        end
        if s_picture and string.len(s_picture) > 5 then
            local imgurl = s_picture
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.avatarIcon_:loadImage(imgurl)
        end
    end))

    self.onNewMessageDataObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_MESSAGE, handler(self, self.messagePoint))

    self.onNewFriendDataObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_FRIEND_DATA, handler(self, self.friendPoint))

    self.onNewLoginRewardObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_LOGIN_REWARD, handler(self, self.loginRewardPoint_))

    if not self.onOffLoadId_ then
        self.onOffLoadId_ = sa.EventCenter:addEventListener("OnOff_Load", handler(self, self.onOffLoadCallback_))
    end
    
    if not self.newRewardTaskId_ then
        self.newRewardTaskId_ = sa.EventCenter:addEventListener(tx.eventNames.TASK_REWARD_POINT, handler(self, self.dailyTasksPoint_))
    end

    self:onRefreshMoney_()

    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, function(obj, userMoney)
        self:onRefreshMoney_()
    end))

    self.diamondsObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "diamonds", handler(self, function(obj, userScore)
        self:onRefreshMoney_()
    end))

    self.changLangueId_ = sa.EventCenter:addEventListener("CHANGE_LANGUE", handler(self, self.onLangeChange_))

    self.updateRedPointStateId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_FREE_CHIP_VIEW_RED_STATE, handler(self, self.updateFreeChipPoint_))

    self.bindGuestId_ = sa.EventCenter:addEventListener("GUEST_BIND_REWARD", handler(self, self.onBindGuestReward_))

    self.holidayShakeGirlChatId_ = sa.EventCenter:addEventListener("HOLIDAY_SHAKE_GIRL_CHAT", handler(self, self.onHolidayShakeGirlChat_))

    self.firstPaySuccessId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_FIRST_PAY_SUCCESS, function()
        if self.firstPayBtn_ then
            self.firstPayBtn_:removeFromParent()
            self.firstPayBtn_ = nil
        end
    end)
end

function MainHallView:onLangeChange_()
    self.playNowBtn_.wordIcon:setSpriteFrame("lang/hall_play_now_btn_title.png")
    self.inviteCodeBtn_.wordIcon:setSpriteFrame("lang/hall_invite_friend_title.png")
    self.inviteView_.wordIcon:setSpriteFrame("lang/hall_ranking_title.png")

    for i,v in ipairs(GAME_TITLE) do
        local game = self.gameList_[i]
        game.wordIcon:setSpriteFrame(v)

        if game.label and not game.label.isOpen then
            game.label:setString(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
            sa.fitSprteWidth(game.label, 200)
        end
    end

    if self.bindBtn_ then
        self.bindBtn_.wordIcon:setSpriteFrame("lang/hall_bind_account_title.png")
    end

    if self.tutorialBtn_ then
       self.tutorialBtn_.wordIcon:setSpriteFrame("lang/hall_tutorial_title.png") 
    end

    if self.firstPayBtn_ then
       self.firstPayBtn_.wordIcon:setSpriteFrame("lang/hall_first_title.png") 
    end
end

function MainHallView:removePropertyObservers()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "nick", self.nickObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "diamonds", self.diamondsObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "s_picture", self.avatarUrlObserverHandle_)

    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_MESSAGE, self.onNewMessageDataObserver)
    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_FRIEND_DATA, self.onNewFriendDataObserver)
    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_LOGIN_REWARD, self.onNewLoginRewardObserver)

    sa.EventCenter:removeEventListener(self.changLangueId_)
    sa.EventCenter:removeEventListener(self.updateRedPointStateId_)
    sa.EventCenter:removeEventListener(self.bindGuestId_)
    sa.EventCenter:removeEventListener(self.holidayShakeGirlChatId_)
    sa.EventCenter:removeEventListener(self.firstPaySuccessId_)

    if self.onOffLoadId_ then
        sa.EventCenter:removeEventListener(self.onOffLoadId_)
        self.onOffLoadId_ = nil
    end

    if self.newRewardTaskId_ then
        sa.EventCenter:removeEventListener(self.newRewardTaskId_)
        self.newRewardTaskId_ = nil
    end
end

-- 更新按钮图标
function MainHallView:updateShopIcon_()
    local brokenData = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
    if brokenData and brokenData.gid then
        self:showDiscount_(brokenData)
    elseif tx.userData.maxSaleInfo then
        self:showDiscount_(tx.userData.maxSaleInfo)
    else
        if self.discountTips_ then
            self.discountTips_:hide()
        end
    end

    -- self:showDiscount_({clientTime = os.time() - 1000, countdown = 2000, sale = 20})--test
end

function MainHallView:showDiscount_(data)
    if not self.discountTips_ then
        local x, y = self.storeBtn_:getPosition()
        local DiscountTips = require("app.pokerUI.DiscountTips")
        self.discountTips_ = DiscountTips.new("#hall/hall_store_btn_mark.png")
            :pos(x + 50, y + 55)
            :addTo(self.bottomNode_)
    end

    local time = tonumber(data.countdown) - (os.time()-data.clientTime)
    self.discountTips_:setInfo(time,"+"..data.sale.."%")
end

return MainHallView