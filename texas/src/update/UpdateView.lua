local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local upd = require("update.init")

local UpdateView = class("UpdateView", function ()
    return display.newNode()
end)

local DOTS_NUM         = 30

local LOGO_POS_X  = display.cx - 300

local PRO_POS_X = 0
local PRO_POS_Y = -display.cy + 140
local PRO_BG_WIDTH, PRO_BG_HEIGHT = 1059, 14
local PRO_HEIGHT = 14
local PRO_MIN_WOIDTH = 60
local Girl_Pos_X = -0.55 * display.cx --女孩X轴位置
local Girl_Pos_Y = 350 - display.cy --女孩Y轴位置

function UpdateView:ctor(scaleNum)
    self:setNodeEventEnabled(true)
    -- 背景
    self.bg_ = display.newNode()
        :addTo(self)
    display.newSprite("img/bg_signin_v2.jpg")
        :addTo(self.bg_)
    self.bg_:setScale(scaleNum)

    -- self:performWithDelay(function()
    --     local logo = sp.SkeletonAnimation:create("spine/denglu.json","spine/denglu.atlas")
    --         :pos(display.cx - 420, display.cy - 160)
    --         :addTo(self)
    --     logo:setAnimation(0, "1", false)
    -- end, 0.1)

    --进度条
    self.progress = display.newScale9Sprite("img/hotfix_bg.png")
        :pos(PRO_POS_X,PRO_POS_Y)
        :addTo(self)
    local stencil = display.newScale9Sprite("img/hotfix_progress.png")
    self.clipNode_ = cc.ClippingNode:create()
        :align(display.CENTER, -PRO_BG_WIDTH*0.5, PRO_BG_HEIGHT*0.5)
        :addTo(self.progress)
    self.clipNode_:setStencil(stencil)
    self.progressBar = display.newScale9Sprite("img/hotfix_progress.png")
        :align(display.LEFT_CENTER, -PRO_BG_WIDTH*0.5, 0)
        :addTo(self.clipNode_)
    self.prolight = display.newSprite("img/hotfix_light.png")
        :addTo(self.progress)

    self.progressLabel = ui.newTTFLabel({
            text = "",
            size = 22,
            color = cc.c3b(255, 255, 255),
            align = ui.TEXT_ALIGN_CENTER,
            x = PRO_POS_X,
            y = PRO_POS_Y + 30
        })
        :addTo(self)

    self.speedLabel = ui.newTTFLabel({
            text = "",
            size = 22,
            color = cc.c3b(0xb0, 0xb0, 0xb0),
            align = ui.TEXT_ALIGN_LEFT,
            x = PRO_POS_X - PRO_BG_WIDTH/2, 
            y = PRO_POS_Y - 20
        })
        :addTo(self)

    self.totalLabel = ui.newTTFLabel({
            text = "",
            size = 22,
            color = cc.c3b(0xb0, 0xb0, 0xb0),
            align = ui.TEXT_ALIGN_RIGHT,
            x = PRO_POS_X + PRO_BG_WIDTH/2, 
            y = PRO_POS_Y - 30
        })
        :addTo(self)

    -- copyright
    self.copyrightLabel_ = ui.newTTFLabel({
        text = "", 
        color = cc.c3b(0x3d, 0x32, 0x74),
        size = 25,
        align = ui.TEXT_ALIGN_CENTER})
        :align(display.CENTER_BOTTOM, 0, - display.cy + 15)
        :addTo(self)
end

function UpdateView:playLeaveScene(callback)
    self.progressLabel:setVisible(false)
    callback()
end

function UpdateView:onCleanup()
end

--资源总大小文本框
function UpdateView:setTotalLabel(total)
    self.totalLabel:setString(upd.lang.getText("UPDATE", "DOWNLOAD_SIZE", total))
    self.totalLabel:pos(PRO_POS_X + PRO_BG_WIDTH/2 - self.totalLabel:getContentSize().width/2,PRO_POS_Y - 20)
end

--tips文字
function UpdateView:setTipsLabel(msg)
    self.progressLabel:stopAllActions()
    self.progressLabel:setVisible(true)
    self.progressLabel:setString(msg)
    -- 调整位置
    self.progressLabel:align(display.CENTER)
    self.progressLabel:pos(PRO_POS_X,PRO_POS_Y + 30)
end

--tips文字
function UpdateView:showLoadingStrAnim(msg)
    self.progressLabel:stopAllActions()
    self.progressLabel:setVisible(true)
    self.progressLabel:setString(msg)
    -- 调整位置
    local size = self.progressLabel:getContentSize()
    self.progressLabel:align(display.LEFT_CENTER)
    self.progressLabel:pos(-size.width*0.5,PRO_POS_Y + 90)

    local pointNum = 0
    self.progressLabel:schedule(function()
        pointNum = pointNum + 1
        if pointNum>3 then pointNum = 0 end
        if pointNum==0 then
            self.progressLabel:setString(msg)
        elseif pointNum==1 then
            self.progressLabel:setString(msg..".")
        elseif pointNum==2 then
            self.progressLabel:setString(msg.."..")
        elseif pointNum==3 then
            self.progressLabel:setString(msg.."...")
        end
    end,0.4)
end

--设置版本号
function UpdateView:setVersion(version)
    if version and #(string.split(version, ".")) == 3 then
        version = version .. ".0"
    end
    local ver = upd.lang.getText("UPDATE", "COPY_RIGHT") .. "V" .. version
    self.copyrightLabel_:setString(ver)
end

--设置进度条是否可见
function UpdateView:setBarVisible(bool)
    self.progress:setVisible(bool)
    self.progressLabel:setVisible(bool)
    self.speedLabel:setVisible(bool)
    self.totalLabel:setVisible(bool)
end

local proLines = {}
--设置进度条，坐标为左对齐
local lastProNum
local lastSpeed
function UpdateView:setProgress(proNum,speed)
    if proNum > 1 then
        proNum = 1
    end
    if speed ~= lastSpeed then
        lastSpeed = speed
        if speed then
            self.speedLabel:setString(upd.lang.getText("UPDATE", "SPEED", speed))
            self.speedLabel:pos(PRO_POS_X - PRO_BG_WIDTH/2 + self.speedLabel:getContentSize().width/2,PRO_POS_Y - 20)
        end
    end
    if lastProNum == proNum then
        return
    end
    lastProNum = proNum
    if proNum > 0 then
        self:setTipsLabel(upd.lang.getText("UPDATE", "DOWNLOAD_PROGRESS", checkint(proNum * 100)))
    else
        --self:setTipsLabel("")
    end

    local wid = PRO_BG_WIDTH*proNum
    if proNum <= 0 then
        self.progressBar:setVisible(false)
        return
    else
        self.progressBar:setVisible(true)
        if wid <= PRO_MIN_WOIDTH then
            self.prolight:pos(PRO_MIN_WOIDTH, PRO_HEIGHT/2)
        else
            self.prolight:pos(wid, PRO_HEIGHT/2)
        end
    end

    if wid <= PRO_MIN_WOIDTH then
        wid = PRO_MIN_WOIDTH
    end

    -- self.progressBar:setContentSize(cc.size(wid, PRO_HEIGHT))
    self.clipNode_:setPositionX(-PRO_BG_WIDTH*0.5+wid)
    self.progressBar:setPositionX(PRO_BG_WIDTH*0.5-wid)
end

return UpdateView
