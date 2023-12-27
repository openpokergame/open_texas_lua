local UpgradePopup = class("UpgradePopup", tx.ui.Panel)

local UpgradeController = import(".UpgradeController")

local WIDTH, HEIGHT = 830, 570

function UpgradePopup:ctor()
    UpgradePopup.super.ctor(self, {WIDTH, HEIGHT})

    self.controller_ = UpgradeController.new(self)

    self:setTextTitleStyle(sa.LangUtil.getText("COMMON", "CONGRATULATIONS"), true)

    self.controller_:getReward()
end

function UpgradePopup:addMainUI(data)
    local bg = self.background_

    self.level_ = data.curRewardLevel

    ui.newTTFLabel({text = "LV." .. data.curRewardLevel, color = styles.FONT_COLOR.CHIP_TEXT, size = 40})
        :pos(WIDTH/2, HEIGHT - 170)
        :addTo(bg)

    local icon_x, icon_y = WIDTH/2, HEIGHT/2
    display.newSprite("#common/pop_reward_light.png")
        :pos(icon_x, icon_y)
        :addTo(bg)

    display.newSprite("#common/pop_level_reward_icon.png")
        :pos(icon_x, icon_y)
        :addTo(bg)

    self.rewards_ = data.desc
    ui.newTTFLabel({text = data.desc, size = 32})
        :pos(WIDTH/2, 180)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(330, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 26}))
        :pos(WIDTH/2, 100)
        :onButtonClicked(buttontHandler(self, self.onShareClicked_))
        :addTo(bg)
end

function UpgradePopup:onShareClicked_()
    local feedData = clone(sa.LangUtil.getText("FEED", "UPGRADE_REWARD"))
    feedData.name = sa.LangUtil.formatString(feedData.name, self.level_, self.rewards_)
    feedData.picture = sa.LangUtil.formatString(feedData.picture, self.level_)
    feedData.link = sa.LangUtil.formatString(feedData.link, self.level_)
    tx.ShareSDK:shareFeed(feedData, function(success, result)
        print("FEED.UPGRADE_REWARD result handler -> ", success, result)
        if success then
            self:hidePanel()
        end
    end)
end

function UpgradePopup:onCleanup()
    self.controller_:dispose()
end

return UpgradePopup