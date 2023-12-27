-- 购买记录弹窗

local WebDialog = class("WebDialog", tx.ui.Panel)

local POPUP_WIDTH = 815+60
local POPUP_HEIGHT = 712+60

-- url  payServices:Android要特殊实现
function WebDialog:ctor(width,height,title,url)
    POPUP_WIDTH = width or (815+60)
    POPUP_HEIGHT = height or (712+60)
    title = title or ""
    url = url or appconfig.POLICY_URL
	WebDialog.super.ctor(self, {POPUP_WIDTH, POPUP_HEIGHT})
    self.url_ = url
    self.PANEL_W,self.PANEL_H = POPUP_WIDTH-56,POPUP_HEIGHT-86-56
    self.centerOffY_ = -43  -- 中间偏移量
    self.bg_ = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(self.PANEL_W, self.PANEL_H))
        :pos(0, self.centerOffY_)
        :addTo(self)
    self:setTextTitleStyle(title or "")
    sa.fitSprteWidth(self.title_, 680)
    self:setLoading(true)
end

function WebDialog:onShowed()
    if self.url_ and #self.url_>0 and ccexp.WebView and ccexp.WebView.create then
        self:setLoading(false)
        if string.upper(device.platform)=="ANDROID" then  -- android
            --原生的尺寸
            local width = self.PANEL_W
            local height = self.PANEL_H

            local glview = cc.Director:getInstance():getOpenGLView()
            local size = glview:getFrameSize()
            local w = size.width
            local h = size.height
            local scale = 1
            local xx = w*0.5
            local yy = h*0.5
            if w / h >= CONFIG_SCREEN_WIDTH / CONFIG_SCREEN_HEIGHT then
                scale = h/CONFIG_SCREEN_HEIGHT
            else
                scale = w/CONFIG_SCREEN_WIDTH
            end
            width = math.floor(width*scale)
            height = math.floor(height*scale)
            -- xx = w*0.5  -- 原生的计算尺寸
            -- yy = h*0.5 + self.centerOffY_*scale
            xx = math.floor((w-width)*0.5)
            yy = math.floor((h-height)*0.5+self.centerOffY_*scale)
            luaj.callStaticMethod("com/opentexas/cocoslib/core/functions/WebFunction", "openWebPay", {self.url_,width,height,xx,yy}, "(Ljava/lang/String;IIII)V")
        else  -- IOS
            local width = self.PANEL_W
            local height = self.PANEL_H
            local webview = ccexp.WebView:create()
            self.webview_ = webview
            self.bg_:addChild(webview)
            webview:setVisible(true)
            webview:setScalesPageToFit(true)
            webview:loadURL(self.url_)
            webview:setContentSize(cc.size(width,height)) -- 一定要设置大小才能显示
            webview:reload()
            webview:setPosition(self.PANEL_W*0.5,self.PANEL_H*0.5)
        end
    end
end

function WebDialog:onCleanup()
    if string.upper(device.platform)=="ANDROID" then  -- android
        luaj.callStaticMethod("com/opentexas/cocoslib/core/functions/WebFunction", "removeWebPay", {}, "()V")
    end
    if self.webview_ then
        self.webview_:setVisible(false)
        self.webview_ = nil
    end
end

return WebDialog
