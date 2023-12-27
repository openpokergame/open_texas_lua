local ActivityContentItem = class("ActivityContentItem", function()
    return display.newNode()
end)

local PlayCardContent       = import(".PlayCardContent")
local PayContent            = import(".PayContent")
local HolidayContent        = import(".holiday.HolidayContent")
local HolidayShakeContent   = import(".holidayshake.HolidayShakeContent")
local NetworkSprite         = import("openpoker.ui.NetworkSprite")
local InvitePopup           = import("app.module.facebookinvite.InvitePopup")
local LuckturnPopup         = import("app.module.luckturn.LuckturnPopup")
local ChooseGameView        = import("app.module.hall.ChooseGameView")
local PrivateScene          = import("app.module.privateroom.PrivateScene")
local ExchangeCodePopup     = import("app.module.exchangecode.ExchangeCodePopup")
local StorePopup            = import("app.module.store.StoreView")

local WIDTH, HEIGHT = 820, 590
local BTN_X, BTN_Y = WIDTH/2, 60
local BLUE_COLOR = 1
local GREEN_COLOR = 2
local YELLOW_COLOR = 3

function ActivityContentItem:ctor(popup, data)
    self.isDisEvt_ = false  -- 是否已经派发图片加载事件
    self.popup_ = popup
    self.data_ = data
    self:size(WIDTH, HEIGHT)
        :align(display.CENTER)

    self.netSprite_ = nil
    self.netSprite_ = NetworkSprite.new(function()
            if not self.isDisEvt_ then
                self.isDisEvt_ = true
                self:performWithDelay(function()
                    local size = self.netSprite_:getContentSize()
                    self.netSprite_:setScaleX(WIDTH/size.width)
                    self.netSprite_:setScaleY(HEIGHT/size.height)
                    sa.EventCenter:dispatchEvent({name="ACTIVITY_CENTER_LOAD_IMAGE",data = self})
                end,0.01)
            end
        end)
        :pos(WIDTH/2, HEIGHT/2)
        :addTo(self)
        :loadAndCacheImage(data.img, tx.ImageLoader.CACHE_TYPE_ACT)

    -- 纯文字  公告类型
    if not data.img or data.img=="" then
        if not self.isDisEvt_ then
            self.isDisEvt_ = true
            self:performWithDelay(function()
                sa.EventCenter:dispatchEvent({name="ACTIVITY_CENTER_LOAD_IMAGE",data = self})
            end,0.01)
        end
        self.noticeBg_ = display.newSprite("img/notice_bg.jpg")
            :pos(WIDTH/2, HEIGHT/2)
            :addTo(self)
        local size = self.noticeBg_:getContentSize()
        self.noticeBg_:setScaleX(WIDTH/size.width)
        self.noticeBg_:setScaleY(HEIGHT/size.height)
    end

    -- 填写的内容
    local content = data.content
    if content and type(content)=="string" and string.len(content)>0 then
        self.noticeTitle_ = ui.newTTFLabel({text = data.title, size = 50})
            :pos(WIDTH/2, HEIGHT-70)
            :addTo(self)
        local ScrollLabel = require("openpoker.ui.ScrollLabel")
        local dw, dh = 680,280
        self.content_ = ScrollLabel.new(
                {
                    text=data.content,
                    color=cc.c3b(0xb6,0xff,0xc9),
                    size=32,
                    align = ui.TEXT_ALIGN_LEFT,
                    valign = ui.TEXT_VALIGN_TOP,
                    dimensions=cc.size(dw, dh)
                },
                {
                    viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
                })
            :pos(WIDTH/2, HEIGHT/2+5)
            :addTo(self)
    elseif content and type(content)=="table" then
        content.title = data.title
        if content.contentType == 1 then
            PlayCardContent.new(content):addTo(self)
        elseif content.contentType == 2 then
            PayContent.new(content):addTo(self)
        elseif content.contentType == 3 then
            for _, v in ipairs(content.list) do
                v.goto = data.goto
            end
            display.addSpriteFrames("act_holiday_texture.plist", "act_holiday_texture.png", function()
                HolidayContent.new(content):addTo(self)
            end)
        elseif content.contentType == 4 then
            display.addSpriteFrames("act_holiday_shake_texture.plist", "act_holiday_shake_texture.png", function()
                HolidayShakeContent.new(content):addTo(self)
            end)
        end
    end

    if data.actType == 1 then
        local nor, pre = self:getButtonImg_()
        local btn = cc.ui.UIPushButton.new({normal = nor, pressed = pre}, {scale9 = true})
            :setButtonSize(300, 146)
            :setButtonLabel("normal", ui.newTTFLabel({text = data.bname, size = 32, align = ui.TEXT_ALIGN_CENTER}))
            :pos(BTN_X, BTN_Y)
            :onButtonClicked(buttontHandler(self, self.onGotoClicked_))
            :addTo(self)
        local label = btn:getButtonLabel("normal")
        sa.fitSprteWidth(label, 230)
    end
end

--[[
打开首充弹框              0
打开FB好友邀请            1
同playnow逻辑             2
网页跳转(去应用商店评分)   3
打开大转盘                 4
跳转到指定的场次            5
跳转到游戏选择界面          6
跳转到奥马哈选场            7
跳转到德州百人场            8
跳转到私人房创建            9
打开单桌赛界面             10
打开锦标赛界面             11
打开商城                  12
打开兑换码界面             13
打开世界杯界面             14
粉丝页点赞活动             15
]]
--[[
    img --图片
    goto --跳转类型
    title --活动标题
    bcolor --按钮颜色
    bname --按钮名字
    content -- 公告内容
    url --网页跳转
    actType --1有按钮，0无按钮
    level--德州1初级场，2中级场，3,高级场
    goodsType 商品类型，1筹码，2钻石，3道具
    payType 支付方式
]]
function ActivityContentItem:onGotoClicked_()
    local data = self.data_
    local goto = data.goto
    local hallScene = display.getRunningScene()
    if goto == 0 then
        tx.PayGuideManager:firstPayGuide()
    elseif goto == 1 then
        InvitePopup.new():showPanel()
    elseif goto == 2 then
        self.popup_:hidePanel()
        
        hallScene:quickStart()
    elseif goto == 3 then
        local url = data.url

        if url then
            device.openURL(url)
        end
    elseif goto == 4 then
        display.addSpriteFrames("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png", function()
            LuckturnPopup.new():showPanel()
        end)
    elseif goto == 5 then
        -- app:enterGameHall(1, {data.level})
        app:enterGameHall(1)
    elseif goto == 6 then
        -- ChooseGameView.new():showPanel()
    elseif goto == 7 then
        app:enterOmahaHall()
    elseif goto == 8 then
        app:enterRedblcakRoom()
    elseif goto == 9 then
        PrivateScene.new(2):showPanel()
    elseif goto == 10 then
        app:enterGameHall(2)
    elseif goto == 11 then
        app:enterGameHall(2, {2})
    elseif goto == 12 then
        tx.PayGuideManager:openStore(data.goodsType, data.payType)
    elseif goto == 13 then
        ExchangeCodePopup.new():showPanel()
    elseif goto == 15 then
        tx.Native:OpenFansUrl(data.appUrl, data.webUrl)
    end
end

function ActivityContentItem:getButtonImg_()
    local bcolor = self.data_.bcolor
    if bcolor == BLUE_COLOR then
        return "#common/btn_big_blue.png", "#common/btn_big_blue_down.png"
    elseif bcolor == GREEN_COLOR then
        return "#common/btn_big_green.png", "#common/btn_big_green_down.png"
    end

    return "#common/btn_big_yellow.png", "#common/btn_big_yellow_down.png"
end

function ActivityContentItem:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(WIDTH/2, HEIGHT/2)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

return ActivityContentItem