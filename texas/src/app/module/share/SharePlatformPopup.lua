--分享平台选择弹窗
local SharePlatformPopup = class("SharePlatformPopup", function()
    return display.newNode()
end)

local IMAGE = {
    "#common/share_sdk_line_icon.png",
    "#common/share_sdk_shortmessage_icon.png",
    "#common/share_sdk_whatsapp_icon.png",
    "#common/share_sdk_facebookmessenger_icon.png",
    "#common/share_sdk_facebook_icon.png",
}

local SHARE_TYPE = {  
    LINE                = 1,
    SHORT_MESSAGE       = 2,
    WHATSAPP            = 3,
    FACEBOOK_MESSENGER  = 4,
    FACEBOOK            = 5,
}
local WIDTH, HEIGHT = display.width, 224
local SHOW_Y = 0
local HIDE_Y = -HEIGHT

function SharePlatformPopup:ctor(params)
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)

    self.params_ = params
    local bg = display.newNode()
        :size(WIDTH, HEIGHT)
        :pos(0, HIDE_Y)
        :addTo(self)
    self.bg_ = bg

    display.newScale9Sprite("#common/pop_bg.png", 0, 0, cc.size(WIDTH + 56, HEIGHT + 56))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 30})
        :align(display.LEFT_CENTER, 30, HEIGHT - 35)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed = "#common/btn_close_down.png"})
        :pos(WIDTH - 40, HEIGHT - 35)
        :onButtonClicked(buttontHandler(self, self.onCloseClicked_))
        :addTo(bg)

    local title = {
        "Line",
        "SMS",
        "Whatsapp",
        "Messenger",
        "Facebook",
        "VK"
    }
    local sid = appconfig.SID[string.upper(device.platform)]
    local copyImage = clone(IMAGE)
    if sid==19 or sid==20 then  --俄语版 添加VK分享
        table.insert(copyImage,"vk_share_btn.png")
    end
    local num = #copyImage
    local dir = WIDTH/(num + 1)
    local startX = dir
    local btn_x, btn_y = dir, HEIGHT*0.5
    self.btnList_ = {}
    for i = 1, num do
        local btn = ScaleButton(display.newSprite(copyImage[i]), 0.95)
            :pos(btn_x, btn_y)
            :onButtonClicked(buttontHandler(self, self.onShareClicked_))
            :addTo(bg)

        local btnSize = btn:getContentSize()

        btn:setTag(i)

        ui.newTTFLabel({text = title[i], size = 26})
            :pos(btnSize.width*0.5, -27)
            :addTo(btn)

        btn_x = btn_x + dir
        self.btnList_[i] = btn
    end
    -- 删除SMS
    if tx.config.SHOW_SMS~=1 then
        self.btnList_[2]:hide()
        local list = clone(self.btnList_)
        table.remove(list, 2)
        local newDir = dir*(#self.btnList_-1)/(#list-1)
        for k,v in pairs(list) do
            v:setPositionX(startX + (k - 1) * newDir)
        end
    end
    self.shareSuccessId_ = sa.EventCenter:addEventListener("SHARE_SDK_SUCCESS", handler(self, self.hidePanel))
end

function SharePlatformPopup:onShareClicked_(evt)
    local tag = evt.target:getTag()
    if device.platform == "android" or device.platform == "ios" then
        if tag == SHARE_TYPE.LINE then
            tx.ShareSDK:shareByLine(self.params_)
        elseif tag == SHARE_TYPE.SHORT_MESSAGE then
            tx.ShareSDK:shareByShortMessage(self.params_)
        elseif tag == SHARE_TYPE.WHATSAPP then
            tx.ShareSDK:shareByWhatsApp(self.params_)
        elseif tag == SHARE_TYPE.FACEBOOK_MESSENGER then
            tx.ShareSDK:shareByFacebookMessenger(self.params_)
        elseif tag == SHARE_TYPE.FACEBOOK then
            tx.ShareSDK:shareByFacebook(self.params_)
        elseif tag == 6 then
            tx.ShareSDK:shareByVK(self.params_)
        end
    end
end

function SharePlatformPopup:onCloseClicked_()
    self:hidePanel()
end

function SharePlatformPopup:hidePanel()
    tx.ShareSDK:clearShareFeedCallback()
    tx.PopupManager:removePopup(self)
end

function SharePlatformPopup:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)

    transition.moveTo(self.bg_, {time=0.2, y=SHOW_Y, easing = "exponentialOut"})

    return self
end

function SharePlatformPopup:onRemovePopup(func)
    transition.moveTo(self.bg_, {time=0.2, y=HIDE_Y, easing = "exponentialIn", onComplete=function() 
        if func then
            func()
        end
    end})
end

function SharePlatformPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.shareSuccessId_)
end

return SharePlatformPopup