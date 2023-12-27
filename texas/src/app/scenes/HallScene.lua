local GameHallScene = import("app.scenes.GameHallScene")

local HallScene = class("HallScene", GameHallScene)

local HallController = import("app.module.hall.HallController")
local LoginGameView  = import("app.module.hall.LoginGameView")
local MainHallView   = import("app.module.hall.MainHallView")

local logger = sa.Logger.new("HallScene")

local BACKGROUND_ZORDER     = 0
local POKER_GIRL_ZORDER     = 1
local LOGIN_GAME_ZORDER     = 2
local MAIN_HALL_ZORDER      = 3
local COPY_RIGHT_ZORDER     = 4
local TUTORIAL_BG_ZORDER    = 5
local TUTORIAL_GIRL_ZORDER  = 6
local TUTORIAL_FRAME_ZORDER = 7
local BUBBLE_ZORDER         = 8

local Girl_Pos_X, Girl_Pos_Y = 350, 0 --女孩大厅界面的位置

-- 大厅场景
-- @number viewType 默认为 first_open
-- @params action 进入大厅场景的动作
function HallScene:ctor(viewType, action, isCoin)
    HallScene.super.ctor(self, -2)
    _G.From_Hall_Type = 1 -- 从主大厅进入游戏
    self.viewType_ = viewType or HallController.FIRST_OPEN
    self.controller_ = HallController.new(self)
    self.animTime_ = self.controller_:getAnimTime()
    self.isShowChat_ = false --是否正在显示聊天气泡

    -- 背景缩放系数
    self.bgScale_ = tx.bgScale

    -- 背景
    self.bg_ = display.newNode()
        :scale(self.bgScale_)
        :pos(display.cx, display.cy)
        :addTo(self, BACKGROUND_ZORDER)

    display.newSprite("img/main_hall_bg_v2.jpg")
        :align(display.CENTER)
        :addTo(self.bg_)

    -- display.newSprite("img/main_hall_bg.jpg")
    --     :align(display.RIGHT_CENTER, 0, 0)
    --     :addTo(self.bg_)

    -- display.newSprite("img/main_hall_bg.jpg")
    --     :flipX(true)
    --     :align(display.LEFT_CENTER, 0, 0)
    --     :addTo(self.bg_)

    cc.ParticleSystemQuad:create("particle/hall_bg_dot.plist")
        :addTo(self.bg_)

    -- poker girl
    self:addGirlNode_()

    --添加反馈和版权
    self:addCopyrightAndFeedback_()

    -- 根据视图类型加载纹理
    if self.viewType_ == HallController.FIRST_OPEN then
        -- 首次进入场景，加载大厅纹理与共用纹理
        self.loginView_ = LoginGameView.new(self.controller_)
            :pos(display.cx, display.cy)
            :addTo(self, LOGIN_GAME_ZORDER)
        self.loginView_:setShowState()
        self:showCopyrightNode_()

        self:onLoadTextureComplete()
        self.viewType_ = HallController.LOGIN_GAME_VIEW
    else
        self:showHallView_()
    end

    self.action_ = action
    if action == "logout" then
        self.controller_:doLogout()
    elseif action == "doublelogin" then
        self.controller_:doLogout(sa.LangUtil.getText("LOGIN", "DOUBLE_LOGIN_MSG"))
    elseif action == "backFromRoom" then
        self.controller_:doBackFromRoom()
    end
    -- 圣诞节
    self:addChristmasNode()
end

function HallScene:dealGunRotation(x,y,haveBubble)
    if not self.gun_ or not x or not y then return; end
    local xx,yy = self.gun_:getPosition()
    local atanValue = math.atan((x - xx) / (y - yy))
    local angle = math.radian2angle(atanValue)
    if x < xx then
        if angle > 0 then
            angle = angle + 180
        end
    else
        if angle <= 0 then
            angle = angle - 180
        end
    end
    if self.gun_ then
        self.gun_:setRotation(angle)
        local s = display.newSprite("img/christmas_bubble.png")
            :addTo(self,9999+1)
        local offX,offY = 0,0
        offX = 100*math.sin(math.rad(angle))
        offY = 100*math.cos(math.rad(angle))
        s:pos(xx + offX,yy + offY)
        s:setRotation(angle)
        transition.moveTo(s, {time=0.08, x=x, y=y, onComplete=function()
            s:removeFromParent()
        end})
    end
end
function HallScene:addChristmasNode()
    -- 顶层
    self.notStopNum = 0
    self.maxHitNum = 0
    self.curHidNum = 0
    self.isDropAward = false
    self.topNode_ = display.newNode()
        :addTo(self,9999)
    self.topNode_:setContentSize(cc.size(display.width,display.height))
    self.topNode_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(evt)
        local name, x, y, prevX, prevY = evt.name, evt.x, evt.y, evt.prevX, evt.prevY
        if name == "began" then
            self.notStopNum = 0
        end
    end)
    NormalButton(self.topNode_)
        :onButtonPressed(function(evt)
            self:dealGunRotation(evt.x,evt.y)
        end)
        -- :onButtonMove(function(evt)
        --     self:dealGunRotation(evt.x,evt.y)
        -- end)
    self.topNode_:setTouchEnabled(false)
    self.topNode_:setTouchSwallowEnabled(false)
end

function HallScene:showChristmasGift()
    if self.isDropAward==true then 
        return;
    end
    if tx.PopupManager:isHasPopup() then
        return;
    end

    local dropFun = function(list)
        if not list or #list<1 then
            self.isDropAward = false
            return; 
        end
        self.notStopNum = 0
        self.maxHitNum = 0
        self.christmasChips_ = 0
        self.christmasProps_ = 0
        self.curHidNum = 0
        self.curTotalNum = #list
        self.topNode_:setTouchEnabled(true)
        self.topNode_:setTouchSwallowEnabled(true)
        -- 背景雪华
        -- self.xueHua_ = cc.ParticleSystemQuad:create("particle/xh.plist")
        -- self.xueHua_ = cc.ParticleSystemQuad:create("particle/hb.plist")
        --     :pos(display.width*0.5, display.height)
        --     :addTo(self,9999-1) -- 不能放在这个节点处
        -- self.xueHua_:setAutoRemoveOnFinish(true)
        -- 枪
        if not self.gun_ then
            self.gun_ = display.newSprite("img/christmas_gun.png")
                :pos(display.width*0.5,95)
                :addTo(self,9999+1) -- 最上层
        end
        self.gun_:setRotation(0)
        self.gun_:show()
        self.isInDroping_ = true -- 正在掉落
        for i=1,self.curTotalNum,1 do
            local btn_w, btn_h = 120,140
            math.random()
            local xx,yy = 100+math.random(display.width-200),100+math.random(display.height-200)
            local spNode = sp.SkeletonAnimation:create("spine/SDhuodong.json","spine/SDhuodong.atlas")
                :size(cc.size(btn_w, btn_h))
                :align(display.CENTER,0,0)
                :pos(xx,yy)
                :addTo(self.topNode_)
            local chips = list[i].chips
            local props = list[i].props
            spNode:registerSpineEventHandler(function (event)
                if event.type == "complete" and event.animation == "4" then
                    spNode:performWithDelay(function()
                        self.christmasChips_ = self.christmasChips_ + chips
                        self.christmasProps_ = self.christmasProps_ + props
                        spNode:stopAllActions()
                        spNode:removeFromParent()
                        local childNum = self.topNode_:getChildren()
                        if #childNum<1 then
                            local ChristmasAct = require("app.module.act.ChristmasAct")
                            ChristmasAct.new(self.christmasChips_,self.christmasProps_,self.christmasTimes_,self.curTotalNum,self.curHidNum,self.maxHitNum):showPanel()
                            self.isDropAward = false
                            self.isInDroping_ = nil
                            self.topNode_:setTouchEnabled(false)
                            self.topNode_:setTouchSwallowEnabled(false)
                            if self.xueHua_ then
                                self.xueHua_:stopSystem()
                            end
                            if self.gun_ then
                                self.gun_:hide()
                            end
                        end
                    end, 0.01)
                end
            end, sp.EventType.ANIMATION_COMPLETE)
            NormalButton(spNode):onButtonPressed(function()
                if spNode.isOpened~=true then
                    tx.SoundManager:playSound(tx.SoundManager.SHOW_GOLD_TIPS)
                    local xx,yy = spNode:getPosition()

                    spNode:setTouchEnabled(false)
                    self:dealGunRotation(xx,yy,true)

                    if chips and chips>0 then
                        app:tip(1, chips, xx, yy-40, true)
                    end
                    if props and props>0 then
                        app:tip(3, props, xx, yy-40, true)
                    end
                    spNode.isOpened = true
                    self.notStopNum = self.notStopNum + 1
                    if self.maxHitNum<self.notStopNum then
                        self.maxHitNum = self.notStopNum
                    end
                    self.curHidNum = self.curHidNum + 1
                    spNode:setAnimation(0, 4, false)
                end
            end)
            local rd = math.random()
            if rd<0.33 then
                spNode:setAnimation(0, 1, true)
            elseif rd>0.66 then
                spNode:setAnimation(0, 3, true)
            else
                spNode:setAnimation(0, 2, true)
            end
            spNode:setPositionY(display.height+200)
            -- 掉落速度
            local speed = tonumber(list[i].speed)
            local dropTime = 0
            if not speed then
                dropTime = 1 + math.random()*1.5
            else
                if speed<1 then
                    speed=1
                elseif speed>10 then
                    speed=10
                end
                dropTime = 1 + (10 - speed)*0.23
            end

            -- delay 1.5 秒为雪花飘的
            transition.moveTo(spNode, {time = dropTime, y = -200, delay = 1.5 + i*0.3,onComplete=function()
                    spNode:pause()
                    spNode:removeFromParent()
                    local childNum = self.topNode_:getChildren()
                    if #childNum<1 then
                        local ChristmasAct = require("app.module.act.ChristmasAct")
                        ChristmasAct.new(self.christmasChips_,self.christmasProps_,self.christmasTimes_,self.curTotalNum,self.curHidNum,self.maxHitNum):showPanel()
                        self.isDropAward = false
                        self.isInDroping_ = nil
                        self.topNode_:setTouchEnabled(false)
                        self.topNode_:setTouchSwallowEnabled(false)
                        if self.xueHua_ then
                            self.xueHua_:stopSystem()
                        end
                        if self.gun_ then
                            self.gun_:hide()
                        end
                    end
                end})
        end

    end

    self.isDropAward = true
    sa.HttpService.POST({
            mod = "Activity",
            act = "getLuckyDraw",
        },
        function(data)
            local retData = json.decode(data)
            if retData and retData.ret == 0 then  
                self.christmasTimes_ = retData.data.times
                self:showGirlChat(sa.LangUtil.getText("ACT","CHRISTMAS_HALL_GIRL_CHAT_3"))
                dropFun(retData.data.data)
            elseif retData and retData.ret == -1 then-- -1  参数错误
                self.isDropAward = false
            elseif retData and retData.ret == -3 then -- -3  没有奖励
                self.isDropAward = false
            elseif retData and retData.ret == -4 then -- -4  抽奖次数已用完
                if tx.userData.isHolidayShakeSendChips == 1 then
                    self.isDropAward = false
                end
                self:showGirlChat(sa.LangUtil.getText("ACT","CHRISTMAS_HALL_GIRL_CHAT_4"))
            else  -- 活动已经结束
                
            end
        end,
        function()
            self.isDropAward = false
        end)
end

function HallScene:addGirlNode_()
    self.isPlayAnimation_ = false

    self.girl_ = sp.SkeletonAnimation:create("spine/dtmv.json","spine/dtmv.atlas")
        :pos(Girl_Pos_X, Girl_Pos_Y)
        :addTo(self, POKER_GIRL_ZORDER)

    local girl_h = 670
    self.girlScale_ = (display.height - 130) / girl_h
    self.girl_:scale(self.girlScale_)

    self.girl_:setAnimation(0, 1, true)

    self.girl_:registerSpineEventHandler(function (event)
        if event.type == "complete" and event.animation ~= "1" then
            self.isPlayAnimation_ = false
            self.girl_:setAnimation(0, 1, true)
            -- 摇一摇活动
            if event.animation == "4" or event.animation == "5" then
                self:showChristmasGift()
                self.girl_:setLocalZOrder(POKER_GIRL_ZORDER)
            end
        end
    end, sp.EventType.ANIMATION_COMPLETE)

    local w, h = 370, girl_h 
    -- local frame = display.newScale9Sprite("#common/pop_list_item_pressed.png", 0, 0, cc.size(w, h))
    --     :align(display.LEFT_BOTTOM, -20, 0)
    --     :addTo(self.girl_)

    local frame = display.newNode()
        :size(w, h)
        :align(display.LEFT_BOTTOM, -20, 0)
        :addTo(self.girl_)

    local btn_w = w
    local btn_h1, btn_h2 = 380, 330
    --"#common/pop_list_item_selected.png"
    cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btn_w, btn_h1)
        :onButtonClicked(handler(self, self.playGirlAnimation1_))
        :align(display.TOP_CENTER, w/2, h)
        :addTo(frame)

    cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btn_w, btn_h2)
        :onButtonClicked(handler(self, self.playGirlAnimation2_))
        :align(display.TOP_CENTER, w/2, h - btn_h1)
        :addTo(frame)

    local x, y = Girl_Pos_X + 200*self.girlScale_, Girl_Pos_Y + 520*self.girlScale_
    self.chatBubble_ = display.newScale9Sprite("#hall/hall_girl_chat_bubble.png")
        :align(display.LEFT_BOTTOM, x, y)
        :addTo(self, BUBBLE_ZORDER)
        :hide()
end

function HallScene:showGirlChat(specifiedText)
    if self.isShowChat_ and not specifiedText then
        return
    end
    self.chatBubble_:stopAllActions()
    if specifiedText then
        local children = self.chatBubble_:getChildren()
        if children then
            for i, child in ipairs(children) do
                child:removeFromParent()
            end
        end
    end
    self.isShowChat_ = true
    self.chatBubble_:show()
    self.chatBubble_:performWithDelay(function()
        self.isShowChat_ = false
    end, 5)
    
    local textArr = sa.LangUtil.getText("HALL", "GIRL_SHORT_CHAT")
    local index = math.random(1, #textArr)
    local text = specifiedText or textArr[index]
    local img_w, img_h = 119, 88
    local labelMaxW = 200
    local label = ui.newTTFLabel({text=text, size=20, align=ui.TEXT_ALIGN_CENTER, color=cc.c3b(0x10, 0x43, 0x6e)}):addTo(self.chatBubble_)
    if label:getContentSize().width > labelMaxW then
        label:setDimensions(labelMaxW, 0)
    end
    local lbsize = label:getContentSize()
    local bgw = math.max(img_w, lbsize.width + 30)
    local bgh = math.max(img_h, lbsize.height + 50)
    self.chatBubble_:setContentSize(cc.size(bgw, bgh))

    label:pos(bgw * 0.5, bgh * 0.5 + 10)
    label:performWithDelay(function()
        label:removeFromParent()
        self.chatBubble_:hide()
    end, 3)
end

function HallScene:playGirlAnimation1_()
    self:reportGirlClicked_()
    
    self:showGirlChat()
    if not self.isPlayAnimation_ then
        math.newrandomseed()
        local num = math.random(1000)
        if num <= 400 then
        elseif num <= 800 then
            self.isPlayAnimation_ = true
            self.girl_:setAnimation(0, 3, false)
        elseif num <= 1000 then
            self.isPlayAnimation_ = true
            self.girl_:setAnimation(0, 2, false)
        end
    end
end

function HallScene:playGirlAnimation2_()
    self:reportGirlClicked_()
    if not self.isPlayAnimation_ then
        math.newrandomseed()
        local num = math.random(1000)
        if num <= 400 then
        elseif num <= 800 then
            self.isPlayAnimation_ = true
            self.girl_:setAnimation(0, 2, false)
        elseif num <= 1000 then
            self.isPlayAnimation_ = true
            self.girl_:setAnimation(0, 3, false)
        end
    end 
end

function HallScene:playGirlAnimation(index)
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "hall_mm_shake", label = "hall_mm_shake"}
        }
    end

    if not self.isPlayAnimation_ then
        self.isPlayAnimation_ = true
        self.girl_:setLocalZOrder(BUBBLE_ZORDER)
        self.girl_:setAnimation(0, index, false)
    end 
end

function HallScene:reportGirlClicked_()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "hall_mm_click", label = "hall_mm_click"}
        }
    end
end

function HallScene:openTutorial()
    -- 显示一次就不再显示了
    tx.userData.needTutorial = nil
    if self.tutorialBg_ then
        self.tutorialBg_:removeFromParent()
    end

    if self.tutorialFrame_ then
        self.tutorialFrame_:removeFromParent()
    end

    self.tutorialBg_ = display.newScale9Sprite("#common/modal_texture.png", 0, 0, cc.size(display.width, display.height))
        :pos(display.cx, display.cy)
        :addTo(self, TUTORIAL_BG_ZORDER)
    self.tutorialBg_:setTouchEnabled(true)

    self.girl_:setLocalZOrder(TUTORIAL_GIRL_ZORDER)

    local frame_w, frame_h = 670, 520
    local frame = display.newScale9Sprite("#hall/hall_tutorial_bg.png", 0, 0, cc.size(frame_w, frame_h), cc.rect(180, 170, 1, 1))
        :align(display.LEFT_CENTER, Girl_Pos_X + 210, 350 * self.bgScale_)
        :addTo(self, TUTORIAL_FRAME_ZORDER)
    self.tutorialFrame_ = frame

    ui.newTTFLabel({text = sa.LangUtil.getText("TUTORIAL","FIRST_IN_TIPS"), size = 32, align = ui.TEXT_ALIGN_LEFT, dimensions = cc.size(550, 0)})
        :align(display.TOP_CENTER, frame_w*0.5 + 27, frame_h - 30)
        :addTo(frame)

    local btn_w, btn_h = 260, 104
    local btn_x, btn_y = 215, 70
    cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("TUTORIAL", "FIRST_IN_BTN1"), size = 28}))
        :pos(btn_x, btn_y)
        :onButtonClicked(buttontHandler(self, self.onJumpTutorialClicked_))
        :addTo(frame)

    cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("TUTORIAL", "FIRST_IN_BTN2"), size = 28}))
        :pos(btn_x + 294, btn_y)
        :onButtonClicked(buttontHandler(self, self.onStartTutorialClicked_))
        :addTo(frame)
end

function HallScene:onJumpTutorialClicked_()
    if self.tutorialBg_ then
        self.tutorialBg_:removeFromParent()
        self.tutorialBg_ = nil
    end

    if self.tutorialFrame_ then
        self.tutorialFrame_:removeFromParent()
        self.tutorialFrame_ = nil
    end

    self.girl_:setLocalZOrder(POKER_GIRL_ZORDER)
end

function HallScene:onStartTutorialClicked_()
    self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
        :pos(display.cx, display.cy)
        :addTo(self, 100)

    app:enterGameRoom(0)
end

-- android返回键处理
function HallScene:handlerBackKey()
    local currentHallView = sa.DataProxy:getData(tx.dataKeys.CURRENT_HALL_VIEW)
    if currentHallView == HallController.MAIN_HALL_VIEW then
        if self.isInDroping_==true then  -- 正在掉落红包
            return
        end
        -- 从大厅界面退出登录, 返回到登录场景,也弹出提示
        if self.loginoutDialog then
            self.loginoutDialog:onClose()
            self.loginoutDialog = nil
        else
            self.loginoutDialog = tx.ui.Dialog.new({
                titleText = sa.LangUtil.getText("COMMON", "LOGOUT_DIALOG_TITLE"),
                messageText = sa.LangUtil.getText("COMMON", "QUIT_DIALOG_MSG_A"), 
                firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
                secondBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
                hasCloseButton = false,
                callback = function (type)
                        if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                           -- 派发登出成功事件
                            sa.EventCenter:dispatchEvent(tx.eventNames.HALL_LOGOUT_SUCC)
                        end
                        self.loginoutDialog = nil
                   end
                }):show()
        end
    else
        -- 登录界面退出弹确认关闭对话框
        if tx.HuaWeiSDK then
            tx.HuaWeiSDK:gameResumeOrExit()
        else
            local quit_tip = sa.LangUtil.getText("COMMON", "QUIT_DIALOG_MSG_A")
            if self.quitDialog then
                self.quitDialog:onClose()
                self.quitDialog = nil
            else
                self.quitDialog = tx.ui.Dialog.new({
                    titleText = sa.LangUtil.getText("COMMON", "QUIT_DIALOG_TITLE"),
                    messageText = quit_tip, 
                    firstBtnText = sa.LangUtil.getText("COMMON", "QUIT_DIALOG_CONFIRM"),
                    secondBtnText = sa.LangUtil.getText("COMMON", "QUIT_DIALOG_CANCEL"),
                    hasCloseButton = false,
                    callback = function (type)
                            if type == tx.ui.Dialog.FIRST_BTN_CLICK then
                                tx.app:exit()
                            else
                                self.quitDialog = nil
                            end
                       end
                    }):show()
            end
        end
    end
end

function HallScene:onLoadTextureComplete()
    -- 把这里算作 大厅进入完成, 是最准确的
    self.controller_:umengEnterHallTimeUsage()

    self.controller_:checkAutoLogin()
end

function HallScene:showHallView_()
    if self.viewType_ == HallController.LOGIN_GAME_VIEW then
        -- 展示登录游戏界面
        self:showLoginView_()
    elseif self.viewType_ == HallController.MAIN_HALL_VIEW then
        -- 展示主大厅界面
        self:showMainHallView_()
    end
end

-- 显示登录视图
function HallScene:showLoginView_()
    -- 登录视图
    if not self.loginView_ then
        self.loginView_ = LoginGameView.new(self.controller_)
            :pos(display.cx, display.cy)
            :addTo(self, LOGIN_GAME_ZORDER)
    end

    -- 动画
    self.loginView_:playShowAnim()
    self:showCopyrightNode_()

    -- 设置当前场景类型全局数据
    sa.DataProxy:setData(tx.dataKeys.CURRENT_HALL_VIEW, HallController.LOGIN_GAME_VIEW)
    -- self:setGrayNodes_()
end

-- 显示主界面视图
function HallScene:showMainHallView_(tablePos)
    -- 主界面视图
    self.mainHallView_ = MainHallView.new(self.controller_, tablePos)
        :pos(display.cx, display.cy)
        :addTo(self, MAIN_HALL_ZORDER)

    --检测是否有日常任务奖励
    self.controller_:checkDailyTasksReward()

    -- 动画
    self.mainHallView_:playShowAnim(true)
    
    self:hideCopyrightNode_()

    -- 设置当前场景类型全局数据
    sa.DataProxy:setData(tx.dataKeys.CURRENT_HALL_VIEW, HallController.MAIN_HALL_VIEW)

    -- self:resumedGrayNodes_()
    self:updateShopIcon_()
end

function HallScene:showHolidayGirlChat()
    -- tx.schedulerPool:delayCall(function()
    --     -- self.mainHallView_:playShowAnim(true)
    --     -- 圣诞新年提示
    --     if not _G.showChristmas_ then
    --         _G.showChristmas_ = true
    --         local date = os.date("*t",os.time())
    --         if date.year==2017 and date.month==12 and date.day>=22 then -- 圣诞
    --             self:showGirlChat(sa.LangUtil.getText("ACT","CHRISTMAS_HALL_GIRL_CHAT_1"))
    --         elseif date.year==2018 and date.month==1 and date.day<11 then  -- 新年
    --             self:showGirlChat(sa.LangUtil.getText("ACT","CHRISTMAS_HALL_GIRL_CHAT_2"))
    --         elseif date.year==2018 and date.month==2 and date.day>=8 and date.day<=22 then  -- 中国春节
    --             self:showGirlChat(sa.LangUtil.getText("ACT","CHRISTMAS_HALL_GIRL_CHAT_5"))
    --         elseif date.year==2018 and date.month==8 and date.day>=1 and date.day<=23 then  -- 中国七夕 --test
    --             self:showGirlChat(sa.LangUtil.getText("ACT", "CHRISTMAS_HALL_GIRL_CHAT_6"))
    --         end
    --     end
    -- end,0.25)
end

function HallScene:updateShopIcon_(evt)
    HallScene.super.updateShopIcon_(self,evt)
    if self.mainHallView_ then
        self.mainHallView_:updateShopIcon_()
    end
end

function HallScene:onLoginSucc()
    self:cleanLoginView()
    
    self:showMainHallView_()
end

function HallScene:onLogoutSucc()
    self:cleanMainHallView()
    self:showLoginView_()
    tx.PopupManager:removeAllPopup()
end

function HallScene:onShowMainHall()
    self:showMainHallView_()
end

function HallScene:cleanAllView()
    self:cleanMainHallView()
    self:cleanLoginView()
end

function HallScene:cleanMainHallView()
    if self.mainHallView_ and self.mainHallView_.playHideAnim then
        self.mainHallView_:playHideAnim()
        self.mainHallView_ = nil
    end
end

function HallScene:cleanLoginView()
    if self.loginView_ and self.loginView_.playHideAnim then
        self.loginView_:playHideAnim()
        self.loginView_ = nil
    end
end

function HallScene:getBgScale()
    return self.bgScale_ or 1
end

function HallScene:onCleanup()
    HallScene.super.onCleanup(self)
    -- 清除大厅纹理（保留共用纹理）
    display.removeSpriteFramesWithFile("hall_texture.plist", "hall_texture.png")

    -- 清理控制器
    self.controller_:dispose()
end

function HallScene:onOffCallback()
    if self.mainHallView_ and self.mainHallView_["onOffCallback"] then
        self.mainHallView_:onOffCallback()
    end
end

function HallScene:onEnter()
    HallScene.super.onEnter(self)

    if self.action_ == "doublelogin" and self.viewType_ == HallController.LOGIN_GAME_VIEW then
        tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "DOUBLE_LOGIN_MSG"))
        self.action_ = " "
    end
end

function HallScene:onExit()
    HallScene.super.onExit(self)

    if device.platform == "android" then
        device.cancelAlert()
    end
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

--添加反馈和版权
function HallScene:addCopyrightAndFeedback_()
    -- 版权所有
    self.copyrightNode_ = display.newNode():addTo(self, COPY_RIGHT_ZORDER)
    local node = self.copyrightNode_

    local policyNode = display.newNode()
        :align(display.CENTER, display.cx, 66)
        :addTo(node)
    local policyHeadLabel = ui.newTTFLabel({
        text = "Login is regarded to agree ",
        color = cc.c3b(0x3d, 0x32, 0x74),
        size = 24,
        align = ui.TEXT_ALIGN_LEFT})
        :align(display.CENTER_LEFT, 0, 0)
        :addTo(policyNode)
    local labelSize = policyHeadLabel:getContentSize()
    local policyEndLabel = ui.newTTFLabel({
        text = "the service and privacy policy.",
        color = cc.c3b(0x69, 0x72, 0xbe),
        size = 24,
        align = ui.TEXT_ALIGN_LEFT})
        :align(display.CENTER_LEFT, labelSize.width, 0)
        :addTo(policyNode)
    local labelSize1 = policyEndLabel:getContentSize()
    -- display.newScale9Sprite("#hall/hall_guest_line.png", 0, 0, cc.size(labelSize1.width, 3))
    --     :align(display.CENTER_LEFT, labelSize.width, -labelSize1.height*0.5-2)
    --     :addTo(policyNode)
    policyNode:setPositionX(display.cx-(labelSize.width+labelSize1.width)*0.5)
    NormalButton(policyEndLabel):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        local WebDialog = require("app.pokerUI.WebDialog")
        WebDialog.new(910, 690,sa.LangUtil.getText("ABOUT", "SERVICE"),appconfig.POLICY_URL):showPanel()
    end)

    self.copyright_ = ui.newTTFLabel({
        text = sa.LangUtil.getText("ABOUT", "COPY_RIGHT") .. "V" .. SA_UPDATE.VERSION,
        color = cc.c3b(0x3d, 0x32, 0x74),
        size = 25,
        align = ui.TEXT_ALIGN_CENTER})
        :align(display.CENTER_BOTTOM, display.cx, 15)
        :addTo(node)

    --反馈
    cc.ui.UIPushButton.new({normal = "#hall/btn_login_help_normal.png", pressed = "#hall/btn_login_help_pressed.png"})
        :onButtonClicked(buttontHandler(self, self.loginFeedBackHandler_))
        :align(display.LEFT_BOTTOM, 0, 0)
        :addTo(node)
end

function HallScene:showCopyrightNode_()
    self.copyrightNode_:stopAllActions()
    transition.moveTo(self.copyrightNode_, {
        time = 0.5, 
        y = 0, 
    })
end

function HallScene:hideCopyrightNode_()
    self.copyrightNode_:stopAllActions()
    transition.moveTo(self.copyrightNode_, {
        time = 0.1, 
        y = -150, 
    })
end

function HallScene:loginFeedBackHandler_()
    local HelpPopup = require("app.module.help.HelpPopup")
    HelpPopup.new({index=5,subIndex=3}):showPanel()
end

--设置变灰结点
function HallScene:setGrayNodes_()
    sa.DisplayUtil.setGray(self.bg_)
    sa.DisplayUtil.setGray(self.copyrightNode_)
    sa.DisplayUtil.setGray(self.loginView_)
    self.copyright_:setTextColor(cc.c3b(0x6d, 0x6d, 0x6d))
end

--恢复变灰的结点
function HallScene:resumedGrayNodes_()
    sa.DisplayUtil.removeShader(self.bg_)
    sa.DisplayUtil.removeShader(self.copyrightNode_)
end

-----------------------------------------覆盖父类事件------------------------------------------
function HallScene:onLoginHallSvrSucc_(evt)
    HallScene.super.onLoginHallSvrSucc_(self,evt)
    local pack = evt.data
    if not pack or not pack.tid or pack.tid<1 then -- 不是重连 查看推送信息
        self:checkPushData()
    end
end

function HallScene:onServerStop_(evt)
    -- 移除加载loading
    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end
    tx.ui.Dialog.new({
        messageText = sa.LangUtil.getText("ROOM", "SERVER_STOPPED_MSG"),
        secondBtnText = sa.LangUtil.getText("COMMON", "LOGOUT"),
        closeWhenTouchModel = false,
        hasFirstButton = false,
        hasCloseButton = false,
        callback = function (type)
            if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                self:handleLogoutSucc_()
            end
        end,
    }):show()
end

function HallScene:doubleLoginOut_(evt)
    tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "DOUBLE_LOGIN_MSG"))
    self:handleLogoutSucc_()
end

function HallScene:handleLogoutSucc_(evt)
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    self:onJumpTutorialClicked_()

    self.controller_.isLoginInProgress_ = -1
    self.controller_:doLogout()

    -- 设置视图
    self:onLogoutSucc()
end

function HallScene:onEnterForeground(startType)
    HallScene.super.onEnterForeground(self, startType)
    if self.mainHallView_ and device.platform == "android" then
        tx.SoundManager:stopBgMusic()
        tx.SoundManager:playBgMusic()
    end
end

return HallScene
