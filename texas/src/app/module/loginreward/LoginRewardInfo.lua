local LoginRewardInfo = class("LoginRewardInfo", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 160, 272
local IMAGE = {
    "login_reward_receive_icon_1.png",
    "login_reward_receive_icon_2.png",
    "#login_reward_receive_icon_3.png",
}

function LoginRewardInfo:ctor(params)
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)

    local icon_x, icon_y = WIDTH*0.5, HEIGHT*0.5
    self.bg_ = display.newSprite("#" .. IMAGE[1])
        :pos(icon_x, icon_y)
        :addTo(self)

    display.newSprite("#login_reward_chip_" .. params.index .. ".png")
        :pos(icon_x, icon_y)
        :addTo(self)

    self.shadow_ = display.newSprite(IMAGE[3])
        :pos(icon_x, icon_y)
        :addTo(self)
        :hide()

    self.ok_ = display.newSprite("#login_reward_ok.png")
        :pos(icon_x, HEIGHT - 126)
        :addTo(self)
        :hide()

    local fontName = "fonts/denglu02.fnt"
    ui.newBMFontLabel({text = params.index, font = fontName})
        :pos(icon_x, HEIGHT - 28)
        :addTo(self)

    local label_y = 15
    self.reward_ = ui.newBMFontLabel({text = params.reward, font = fontName})
        :pos(icon_x, label_y)
        :addTo(self)

    self.receiveReward_ = ui.newBMFontLabel({text = params.reward, font = "fonts/xiaohuang.fnt"})
        :pos(icon_x, label_y)
        :addTo(self)
        :hide()
end

function LoginRewardInfo:showCanReceive()
    self.bg_:setSpriteFrame(IMAGE[2])
    self.shadow_:hide()
    self.ok_:hide()
    self.receiveReward_:show()
    self.reward_:hide()
end
 
function LoginRewardInfo:showAlreadyReceive()
    self.bg_:setSpriteFrame(IMAGE[1])
    self.shadow_:show()
    self.ok_:show()
    self.receiveReward_:hide()
    self.reward_:show()
end

-- function LoginRewardInfo:showNextCanReceive()
--     self.bg_:setSpriteFrame(IMAGE[2])
--     self.shadow_:hide()
--     self.ok_:hide()
--     self.receiveReward_:hide()
--     self.reward_:show()
-- end

return LoginRewardInfo
