local logger = sa.Logger.new("RegisterRewardPopup")
local RegisterRewardInfo = import(".RegisterRewardInfo")

local RegisterRewardPopup = class("RegisterRewardPopup", function()
	return display.newNode()
end)

local WIDTH, HEIGHT = display.width, display.height

function RegisterRewardPopup:ctor()
    self:setNodeEventEnabled(true)

    self.rewardData_ = nil

    display.addSpriteFrames("registered_texture.plist", "registered_texture.png",function()
        self:addMainUI_()
    end)
end

function RegisterRewardPopup:addMainUI_()
    local bg = display.newScale9Sprite("#dialogs/register/register_bg.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :addTo(self)

    self.bg_ = bg

    self:addTitleNode_()

    local x, y = WIDTH * 0.5, HEIGHT * 0.5
    local dir = 346
    local num = tx.userData.registerReward.num

    --state为 0已领取 1可领取 2未领取
    local data = {
        {state = 2, index = 1},
        {state = 2, index = 2},
        {state = 2, index = 3}
    }
    for i = 1, num do
        data[i].state = 0
    end

    data[num + 1].state = 1
    for i = 1, 3 do
        RegisterRewardInfo.new(data[i], self)
            :pos(x + (i - 2) * dir, y)
            :addTo(bg)
    end
    
   self:addRewardTipsNode_()

    self:getRegisterReward_(num + 1)
end

function RegisterRewardPopup:addTitleNode_()
    local x, y = WIDTH * 0.5, HEIGHT - 120
    local bg = self.bg_
    local icon_offset = 195
    local line_offset = icon_offset + 115
    display.newSprite("#lang/register_title.png")
        :pos(x, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_icon.png")
        :align(display.RIGHT_CENTER, x - icon_offset, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_line.png")
        :align(display.RIGHT_CENTER, x - line_offset, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_icon.png")
        :flipX(true)
        :align(display.LEFT_CENTER, x + icon_offset, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_line.png")
        :align(display.LEFT_CENTER, x + line_offset, y)
        :addTo(bg)
end

function RegisterRewardPopup:addRewardTipsNode_()
    local x, y = WIDTH * 0.5, 120
    local bg = self.bg_
    local icon_offset = 195
    local line_offset = icon_offset + 115

    ui.newTTFLabel({size=24, text=sa.LangUtil.getText("LOGIN", "REGISTER_FB_TIPS"), dimensions=cc.size(580, 0), align=ui.TEXT_ALIGN_CENTER})
        :pos(x, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_line.png")
        :align(display.RIGHT_CENTER, x - line_offset, y)
        :addTo(bg)

    display.newSprite("#dialogs/register/register_line.png")
        :align(display.LEFT_CENTER, x + line_offset, y)
        :addTo(bg)
end

function RegisterRewardPopup:getRegisterReward_(index, isClicked)
    sa.HttpService.POST(
    {
        mod = "RegisterReward",
        act = "regReward",
        type = index
    },
    function(data)
        local callData = json.decode(data)
        if callData.code == 1 then
            tx.userData.registerReward.code = 0
            self.rewardData_ = callData
        end
    end,
    function()
    end)
end

function RegisterRewardPopup:playGetRewardAnimation()
    tx.SoundManager:playSound(tx.SoundManager.WINNER1)

    app:playChipsDropAnimation()
end

function RegisterRewardPopup:getRegisterReward()
    return self.rewardData_
end

function RegisterRewardPopup:showPanel()
    tx.PopupManager:addPopup(self, true, true, false)
end

function RegisterRewardPopup:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function RegisterRewardPopup:onCleanup()
    display.removeSpriteFramesWithFile("registered_texture.plist", "registered_texture.png")
end

function RegisterRewardPopup:hidePanel()
    if self.closeCallback_ then
        self.closeCallback_()
        self.closeCallback_ = nil
    end

    tx.PopupManager:removePopup(self)
end

return RegisterRewardPopup