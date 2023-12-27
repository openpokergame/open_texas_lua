local HorseLamp = class("HorseLamp")
local SimpleColorLabel = import("openpoker.ui.SimpleColorLabel")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local DEFAULT_STAY_TIME = 3
local X_GAP = 100
local Y_GAP = 0
local TIP_HEIGHT = 62
local LABEL_X_GAP = 25
local LABEL_ROLL_VELOCITY = 60
local LABEL_OFFY = 0
local BG_CONTENT_SIZE = cc.size(display.width - X_GAP * 2, TIP_HEIGHT)
local Z_ORDER = 1003

local ENTER_BUTTON_SIZE = 100

HorseLamp.ANIM_TYPE_HOR = "horizontal"
HorseLamp.ANIM_TYPE_VER = "vertical"

function HorseLamp:ctor()
    -- 视图容器
    self.container_ = display.newNode()
    self.container_:retain()
    self.container_:setNodeEventEnabled(true)

    -- 等待队列
    self.waitQueue_ = {}
    self.isPlaying_ = false

    self.cancelBtn_ = nil
end

function HorseLamp:cleanup()
    -- 移除图标
    if self.currentData_ and self.currentData_.image and type(self.currentData_.image) == "userdata" then
        self.currentData_.image:release()
        self.currentData_.image:removeFromParent()
    end

    -- 移除定时器
    if self.delayScheduleHandle_ then
        scheduler.unscheduleGlobal(self.delayScheduleHandle_)
        self.delayScheduleHandle_ = nil
    end

    -- 移除延时影藏
    if self.delayHideCancel_ then
        scheduler.unscheduleGlobal(self.delayHideCancel_)
        self.delayHideCancel_ = nil
    end

    -- 延迟一秒播放下一条
    scheduler.performWithDelayGlobal(function ()
        self:playNext_()
    end, 1)

    if self.enterBtn_ then
        self.enterBtn_:removeFromParent()
        self.enterBtn_ = nil
    end

    if self.cancelBtn_ then
        self.cancelBtn_:removeFromParent()
        self.cancelBtn_ = nil
    end

    print("container removed")
end

function HorseLamp:onBgTouch_(bg, evtName, ...)
    if evtName=="TOUCH_BEGIN" or evtName=="CLICK" then
        if self.currentData_.messageType==2000 then
            if self.delayHideCancel_ then
                scheduler.unscheduleGlobal(self.delayHideCancel_)
                self.delayHideCancel_ = nil
            end
            if self.cancelBtn_ then
                self.cancelBtn_:setVisible(true)
            end
            self.delayHideCancel_ = scheduler.performWithDelayGlobal(handler(self, self.hideCancelBtn), 5)
        end
    end
end

function HorseLamp:onCancel_()
    self.waitQueue_ = {}
    self:onHideComplete_()
end

function HorseLamp:hideCancelBtn()
    if self.delayHideCancel_ then
        scheduler.unscheduleGlobal(self.delayHideCancel_)
        self.delayHideCancel_ = nil
    end
    if self.cancelBtn_ then
        self.cancelBtn_:setVisible(false)
    end
end

-- Note:添加buttonInfo参数用于添加跳转按钮
-- buttonInfo是一个table 支持两个参数
-- text:用于指定按钮文字
-- callback:用于指定按钮点击事件
function HorseLamp:showTips(topTipData,buttonInfo,isFirst)
    if _G.isInTutorial then --正在新手教程
        return
    end
    assert(type(topTipData) == "table" or type(topTipData) == "string", "topTipData should be a table")
    if not self.tipBg_ then
        -- 背景
        self.tipBg_ = display.newScale9Sprite("#common/horses_bg.png", 0, 0, BG_CONTENT_SIZE)
            :addTo(self.container_)

        -- 添加事件
        sa.TouchHelper.new(self.tipBg_, handler(self, self.onBgTouch_))

        -- 小的裁剪模板（文本 + 图标）
        self.smallStencil_ = display.newDrawNode()
        self.smallStencil_:drawPolygon({
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP , -BG_CONTENT_SIZE.height * 0.5}, 
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP ,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP ,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP , -BG_CONTENT_SIZE.height * 0.5}
        })
        self.smallStencil_:retain()

        -- 大的裁剪模板（文本）
        self.bigStencil_ = display.newDrawNode()
        self.bigStencil_:drawPolygon({
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP, -BG_CONTENT_SIZE.height * 0.5}, 
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP ,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP , -BG_CONTENT_SIZE.height * 0.5}
        })
        self.bigStencil_:retain()

        self.btnStencil_ = display.newDrawNode()
        self.btnStencil_:drawPolygon({
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP, -BG_CONTENT_SIZE.height * 0.5}, 
            {-BG_CONTENT_SIZE.width * 0.5 + LABEL_X_GAP,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP - ENTER_BUTTON_SIZE,  BG_CONTENT_SIZE.height * 0.5}, 
            { BG_CONTENT_SIZE.width * 0.5 - LABEL_X_GAP - ENTER_BUTTON_SIZE, -BG_CONTENT_SIZE.height * 0.5}
        })
        self.btnStencil_:retain()

        -- 裁剪容器
        self.clipNode_ = cc.ClippingNode:create():addTo(self.container_)
        self.clipNode_:setStencil(self.bigStencil_)

        -- 文本
        self.label_ = display.newNode()
            :addTo(self.clipNode_)
    end

    -- 交互按钮
    self:addCancelBtn_()

    if type(topTipData) == "string" then
        -- 过滤重复的消息
        if self.currentData_ and self.currentData_.text == topTipData then
            return
        end

        for _, v in pairs(self.waitQueue_) do
            if v.text == topTipData then
                return
            end
        end
        if isFirst == true then
            table.insert(self.waitQueue_,1,{text = topTipData,buttonInfo = buttonInfo})
        else
            table.insert(self.waitQueue_, {text = topTipData,buttonInfo = buttonInfo})
        end
    else
        -- 过滤重复的消息   大喇叭消息不过滤哦
        if topTipData.animType == HorseLamp.ANIM_TYPE_HOR then
            -- print("this is DA LABA")
        else
            if self.currentData_ and self.currentData_.text == topTipData.text then
                return
            end

            for _, v in pairs(self.waitQueue_) do
                if v.text == topTipData.text then
                    return
                end
            end
        end

        if topTipData.image and type(topTipData.image) == "userdata" then
            topTipData.image:retain()
        end

        topTipData.buttonInfo = buttonInfo
        if isFirst==true then
            table.insert(self.waitQueue_,1,topTipData)
        else
            table.insert(self.waitQueue_, topTipData)
        end
    end
    
    if not self.isPlaying_ then
        self:playNext_()
    end
end

function HorseLamp:addCancelBtn_()
    self.cancelBtn_ = cc.ui.UIPushButton.new({normal= "#common/horses_btn.png",pressed="#common/horses_btn_down.png"},{scale9 = true})
        :setButtonSize(102, 36)
        :setButtonLabel(ui.newTTFLabel({text=sa.LangUtil.getText("MATCH", "MATCHTIPSCANCEL"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self,self.onCancel_))
        :pos((BG_CONTENT_SIZE.width+102)/2-115,-(TIP_HEIGHT+36)/2)
        :addTo(self.container_)
        :hide()
end

function HorseLamp:addEnterButton_(buttonInfo)
    local title = buttonInfo.text or ""
    self.enterBtn_ = cc.ui.UIPushButton.new({normal= "#common/horses_btn.png",pressed="#common/horses_btn_down.png"},{scale9 = true})
        :setButtonSize(102, 48)
        :setButtonLabel(ui.newTTFLabel({text= title, size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked( function()
            if buttonInfo.callback then
                buttonInfo.callback()
            end

            self:onHideComplete_()
        end)
        :pos((BG_CONTENT_SIZE.width+102)/2 - 110,0)
        :addTo(self.container_)
end

function HorseLamp:playNext_()
    if self.waitQueue_[1] then
        self.currentData_ = table.remove(self.waitQueue_, 1)
    else
        -- 播放完毕
        self.isPlaying_ = false
        return
    end

    -- 设置文本和图标
    local topTipData = self.currentData_
    local buttonInfo = topTipData.buttonInfo
    if buttonInfo then
        self:addEnterButton_(buttonInfo)
    end

    local colorLbl
    local scrollTime = 0
    local labelWidth = 0
    local button_width = 0
    local startXPos = 0
    local icon_width = 0
    local total_width = 0
    if topTipData.text then
        self.label_:removeAllChildren()
        colorLbl = SimpleColorLabel.html(topTipData.text, topTipData.textColor or cc.c3b(0xff, 0xff, 0xff), cc.c3b(0xff, 0xae, 0x70), 28, 1):addTo(self.label_, 1, 1)
        labelWidth = colorLbl.width
        
        if topTipData.image and type(topTipData.image) == "userdata" then
            topTipData.image:pos(-labelWidth * 0.5 - LABEL_X_GAP, 0):addTo(self.label_)
            icon_width = topTipData.image:getContentSize().width
        end
        
        if buttonInfo then
            -- 设置对应的裁剪模板
            self.clipNode_:setStencil(self.btnStencil_)
            button_width = ENTER_BUTTON_SIZE
        else
            -- 设置对应的裁剪模板
            self.clipNode_:setStencil(self.bigStencil_)
        end

        total_width = labelWidth + icon_width + button_width + LABEL_X_GAP * 2 - BG_CONTENT_SIZE.width
        -- 计算文本滚屏时间
        scrollTime = total_width / LABEL_ROLL_VELOCITY
        
    end

    -- 下滑动画
    self.isPlaying_ = true
    local px, py
    -- animType：ANIM_TYPE_HOR 为游戏广播消息
    if self.currentData_.animType and self.currentData_.animType == HorseLamp.ANIM_TYPE_HOR then
        local px = BG_CONTENT_SIZE.width * 0.5 + labelWidth*0.5 - LABEL_X_GAP
        local tpx = -BG_CONTENT_SIZE.width * 0.5 - labelWidth*0.5 + LABEL_X_GAP
        self.label_:pos(px, LABEL_OFFY)

        local ts = BG_CONTENT_SIZE.width/LABEL_ROLL_VELOCITY
        if labelWidth > BG_CONTENT_SIZE.width then
            ts = labelWidth/LABEL_ROLL_VELOCITY
        end

        transition.execute(self.label_, cc.MoveTo:create(ts, cc.p(tpx, 0)), {delay = 0.0})
        scrollTime = ts

        px = display.right + BG_CONTENT_SIZE.width * 0.5 + 20
        py = display.top - Y_GAP - TIP_HEIGHT * 0.5
        self.container_:pos(px, py)
            :addTo(tx.runningScene, Z_ORDER)
            :moveTo(0.0, display.cx, py)

        -- 移除tip定时器
        local delayTs =  scrollTime
        self.delayScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.delayCallback_), delayTs)
    else
        if scrollTime > 0 then
            startXPos = total_width * 0.5 + LABEL_X_GAP * 2
            self.label_:pos(startXPos, LABEL_OFFY)
            transition.execute(self.label_, cc.MoveTo:create(scrollTime, cc.p(-startXPos - button_width, 0)), {delay = DEFAULT_STAY_TIME * 0.5})
        else
            scrollTime = 0
            self.label_:pos(0, LABEL_OFFY)
        end
        self.container_:pos(display.cx, display.top + TIP_HEIGHT * 0.5)
            :addTo(tx.runningScene, Z_ORDER)
            :moveTo(0.3, display.cx, display.top - Y_GAP - TIP_HEIGHT * 0.5)
        -- 移除tip定时器
        self.delayScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.delayCallback_), 0.3 + DEFAULT_STAY_TIME + scrollTime)
    end

    local getFrame = display.newSpriteFrame
    if topTipData.messageType == 1000 or topTipData.messageType == 2000 then
        self.tipBg_:setSpriteFrame(getFrame("common/horses_bg.png"))
        self.tipBg_:setContentSize(display.width - X_GAP * 2, TIP_HEIGHT)
    else
        self.tipBg_:setSpriteFrame(getFrame("common/horses_bg.png"))
        self.tipBg_:setContentSize(display.width - X_GAP * 2, TIP_HEIGHT)
    end

    if topTipData.messageType==2000 and tx.socket.HallSocket.hallBroadcast_.isFirstShowMatchLaBa then
        tx.socket.HallSocket.hallBroadcast_.isFirstShowMatchLaBa = false
        self:onBgTouch_(nil,"CLICK")
        self.tipBg_:setTouchEnabled(true)
        self.tipBg_:setTouchSwallowEnabled(true)
    else
        if self.cancelBtn_ then
            self.cancelBtn_:setVisible(false)
        end
        self.tipBg_:setTouchEnabled(false)
        self.tipBg_:setTouchSwallowEnabled(false)
    end
end

function HorseLamp:delayCallback_()
    self.delayScheduleHandle_ = nil

    local px, py = display.cx, display.top + TIP_HEIGHT * 0.5
    if self.currentData_ and self.currentData_.animType and self.currentData_.animType == HorseLamp.ANIM_TYPE_HOR then
        px = display.left - BG_CONTENT_SIZE.width * 0.5 - 20
        py = display.top - Y_GAP - TIP_HEIGHT * 0.5
    end

    if self.currentData_.animType and self.currentData_.animType == HorseLamp.ANIM_TYPE_HOR then
        self.container_:pos(px, py)
        self:onHideComplete_()
    else
        if self.container_:getParent() then
            transition.moveTo(self.container_, {
                x = px, 
                y = py, 
                time = 0.3, 
                onComplete = handler(self, self.onHideComplete_), 
            })
        else
            self.container_:pos(px, py)
            self:onHideComplete_()
        end
    end
end

function HorseLamp:onHideComplete_()
    self.currentData_ = nil
    self.container_:removeFromParent()
    self:cleanup()
end

return HorseLamp