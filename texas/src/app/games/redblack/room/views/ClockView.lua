-- 倒计时
local ClockView = class("ClockView",function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 450, 160
local OFFET = 2
local CLOCK_X, CLOCK_Y

function ClockView:ctor()
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)

    local x, y = WIDTH*0.5, HEIGHT*0.5
    local bg = display.newScale9Sprite("#redblack/room/redblack_tips_big_bg.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :pos(x, y)
        :addTo(self)
    self.bg_ = bg

    CLOCK_X, CLOCK_Y = x, HEIGHT + 5
    local clock = display.newSprite("#redblack/room/redblack_clock.png")
        :align(display.TOP_CENTER, CLOCK_X, CLOCK_Y)
        :addTo(bg)
    self.clock_ = clock

    self.time_ = ui.newBMFontLabel({text = "", font = "fonts/redblack_time.fnt"})
        :pos(58, 62)
        :addTo(clock)

    ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK","SELECTED_BET_TIPS"), size = 26})
        :align(display.BOTTOM_CENTER, x, 5)
        :addTo(bg)

    self.isShaking_ = false
    self:setNodeEventEnabled(true)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))
end

function ClockView:startCountDown(countdown, callback)
    if countdown <= 0 then
        return
    end

    self.countdown_ = countdown
    self.time_:setString(self.countdown_)

    self.time_:stopAllActions()
    self:startShake()
    self.time_:schedule(function()
        self.countdown_ = self.countdown_ - 1
        self.time_:setString(self.countdown_)
        self:startShake()
        if self.countdown_ <= 0 then
            tx.SoundManager:stopSound(self.timeSoundId_)
            self.timeSoundId_ = nil
            self:stopShake()

            if callback then
                callback()
            end
        end
    end, 1)
end

function ClockView:playShowAnimation()
    local x, y = WIDTH*0.5, HEIGHT*0.5
    local dir = 300
    self:show()
    self.bg_:pos(x, y + dir)
    self.bg_:setCascadeOpacityEnabled(true)
    self.bg_:stopAllActions()

    local t = 0.5
    local move = cc.EaseSineIn:create(cc.MoveTo:create(t, cc.p(x, y)))
    local fade = cc.FadeIn:create(t)
    local spawn = cc.Spawn:create(move, fade)

    self.bg_:runAction(spawn)
end

function ClockView:showCountDown(countdown)
    self.bg_:setCascadeOpacityEnabled(true)
    self.bg_:pos(WIDTH*0.5, HEIGHT*0.5):fadeIn(0.5)

    self:show():startCountDown(countdown)
end

function ClockView:hideCountDown()
    self:stopShake()
    self:hide()
end

-- 震动时钟
function ClockView:startShake()
    if self.isShaking_ or self.countdown_ > 5 then
        return
    end

    self.timeSoundId_ = tx.SoundManager:playSound(tx.SoundManager.REDBLACK_TIME)
    self:scheduleUpdate()
    self.isShaking_ = true

    return self
end

-- 停止震动时钟
function ClockView:stopShake()
    self.time_:stopAllActions()
    self:unscheduleUpdate()
    self.clock_:pos(CLOCK_X, CLOCK_Y)
    self.isShaking_ = false

    return self
end

function ClockView:onEnterFrame(dt)
    local posX, posY = self.clock_:getPosition()
    if posX <= CLOCK_X - OFFET or posX >= CLOCK_X + OFFET then
        posX = CLOCK_X
        self.clock_:setPositionX(posX)
    end

    if posY <= CLOCK_Y - OFFET or posY >= CLOCK_Y + OFFET then
        posY = CLOCK_Y
        self.clock_:setPositionY(posY)
    end

    posX = posX + math.random(-OFFET, OFFET)
    posY = posY + math.random(-OFFET, OFFET)
    self.clock_:pos(posX, posY)

    return self
end

function ClockView:onCleanup()
    tx.SoundManager:stopSound(self.timeSoundId_)
end

return ClockView