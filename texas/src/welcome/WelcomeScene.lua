local WelcomeScene = class("WelcomeScene", function()
    return display.newScene("WelcomeScene")
end)

function WelcomeScene:ctor(controller)
    self.controller_ = controller
    self:setNodeEventEnabled(true)
end

function WelcomeScene:onEnter()
end

function WelcomeScene:onExit()
    self:stopAutoCleanup()
    self:removeVideoPlayer()
end

function WelcomeScene:removeVideoPlayer()
    -- if self.videoPlayer_ then
    --     self.videoPlayer_:removeFromParent()
    --     self.videoPlayer_ = nil
    -- end
end

--预防某些情况出错导致停留在欢迎动画界面，不能进入游戏，开启超时自动清理
-- 视频时长约2秒
function WelcomeScene:startAutoCleanup()
    self.autoCleanupAction_ = self:performWithDelay(function()
        self:stopAutoCleanup()
        self:removeVideoPlayer()
        self:enterGame()
    end, 2)
end

function WelcomeScene:stopAutoCleanup()
    if self.autoCleanupAction_ then
        self:stopAction(self.autoCleanupAction_)
        self.autoCleanupAction_ = nil
    end
end

function WelcomeScene:enterGame()
    if not _G.IS_ENTER_APP_UPDATE_VIEW then
        _G.IS_ENTER_APP_UPDATE_VIEW = true
        require("update.UpdateController").new()
    end
end

function WelcomeScene:onVideoEventCallback(sener, eventType)
    if eventType == ccexp.VideoPlayerEvent.PLAYING then
    elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
    elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
    elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then  -- 这个事件执行了两次
        if not self.animStartTime_ or (self.animStartTime_ and (os.time()-self.animStartTime_)>1) then
            self:enterGame()
        end
    end
end

function WelcomeScene:showWelcomePage()
    self.animStartTime_ = os.time() -- 动画监听到两次播放
    self:stopAutoCleanup()
    self:startAutoCleanup()

    -- self.videoPlayer_ = ccexp.VideoPlayer:create()
    -- self.videoPlayer_:size(display.width,display.height)
    -- self.videoPlayer_:pos(display.width/2, display.height/2)
    -- self.videoPlayer_:setFullScreenEnabled(true)
    -- self.videoPlayer_:addTo(self)
    -- self.videoPlayer_:setFileName("res/logo.mp4")
    -- self.videoPlayer_:addEventListener(handler(self,self.onVideoEventCallback))
    -- self.videoPlayer_:play()

    -- 背景缩放系数
    local bgScale = 1
    if display.width / display.height > RESOLUTION_WIDTH / RESOLUTION_HEIGHT then
        bgScale = display.width / RESOLUTION_WIDTH
    else
        bgScale = display.height / RESOLUTION_HEIGHT
    end

    -- 背景
    local bg_ = display.newNode()
    :pos(display.cx, display.cy)
    :addTo(self)
    display.newSprite("res/img/bg_signin_v2.jpg")
    :addTo(bg_)
    bg_:setScale(bgScale)

    self:performWithDelay(function()
        local logo = sp.SkeletonAnimation:create("res/spine/denglu.json", "res/spine/denglu.atlas")
        :pos(display.cx, display.cy - 100)
        :addTo(self)
        -- logo:registerSpineEventHandler(function (event)
        --     tx.SoundManager:playSound("res/sounds/logo.mp3")
        -- end, sp.EventType.ANIMATION_START)
        -- logo:registerSpineEventHandler(function(event)
        --     self:enterGame()
        -- end, sp.EventType.ANIMATION_COMPLETE)
        logo:setAnimation(0, "2", true)    
    end, 0.3)
end


return WelcomeScene