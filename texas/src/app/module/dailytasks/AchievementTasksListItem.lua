-- 成就元素

local AchievementTasksListItem = class("AchievementTasksListItem", sa.ui.ListItem)
local DisplayUtil = import("openpoker.util.DisplayUtil")
local Achieve = import(".Achieve")
local AchievementRewardPopup = import(".AchievementRewardPopup")
local AchievementTipsView = import(".AchievementTipsView")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local ITEM_W, ITEM_H = 800, 375
local BG_W, BG_H = 250, 362
local ITEM_DISTANCE = 270
local labelColor = cc.c3b(0xEF, 0xEF, 0xEF)
local buttonColor = labelColor
local progressColor = cc.c3b(0xEF, 0xEF, 0xEF)

AchievementTasksListItem.ROW_NUM = 3
local ROW_NUM = AchievementTasksListItem.ROW_NUM

function AchievementTasksListItem:ctor()
    self:setNodeEventEnabled(true)
    AchievementTasksListItem.super.ctor(self, ITEM_W, ITEM_H)

    self.item_nodes = {}
    self.item_lights = {}
    self.item_icons = {}
    self.item_names = {}
    self.item_stars = {}
    self.item_progress = {}
    self.item_progress_labels = {}
    self.item_share_buttons = {}
    self.item_reward_buttons = {}
    self.item_reward_labels = {}

    local posX, posY = BG_W/2, BG_H/2 + 80
    for i = 1, ROW_NUM do
        local node = display.newScale9Sprite("#common/pop_list_item_bg.png", 0, 0, cc.size(BG_W, BG_H))
            :pos(130 + ITEM_DISTANCE * (i - 1), ITEM_H/2)
            :addTo(self)
        self.item_nodes[i] = node

        self.item_lights[i] = display.newSprite("#dialogs/dailytasks/dailytasks_achieve_light.png")
            :pos(posX, posY - 10)
            :addTo(self.item_nodes[i])

        self.item_icons[i] = display.newSprite()
            :pos(posX, posY)
            :addTo(node)

        --名称
        self.item_names[i] = ui.newTTFLabel({text = "", size = 24, color = labelColor, align=ui.TEXT_ALIGN_CENTER, valign=ui.TEXT_VALIGN_CENTER})
            :pos(posX, 162)
            :addTo(node)
        self.item_names[i]:setDimensions(245, 0)

        self.item_stars[i] = {}
        local dir = 58
        local sx, sy = BG_W/2 - dir, 115
        for k = 1, 3 do
            local x, y = sx + (k - 1) * dir
            display.newSprite("#dialogs/dailytasks/dailytasks_star_gray.png")
                :pos(x, sy)
                :addTo(node)

            self.item_stars[i][k] = display.newSprite("#dialogs/dailytasks/dailytasks_star_light.png")
                :pos(x, sy)
                :addTo(node)
                :hide()
        end

        local btn_w, btn_h = 200, 104
        local btn_x, btn_y = posX, 50

        cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
            :setButtonSize(BG_W, BG_H)
            :onButtonClicked(function(evt)
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                self:onAchievementTipsClicked_(i)
            end)
            :pos(BG_W/2, BG_H/2)
            :addTo(node)
            :setTouchSwallowEnabled(false)

        self.item_share_buttons[i] = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 26, color = buttonColor}))
            :onButtonClicked(function(evt)
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                self:onShareClicked_(i)
            end)
            :pos(btn_x, btn_y)
            :addTo(node)

        self.item_reward_buttons[i] = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel(ui.newTTFLabel({text = "", size = 26, color = buttonColor}))
            :setButtonLabelAlignment(display.LEFT_CENTER)
            :setButtonLabelOffset(-10, 2)
            :onButtonClicked(function(evt)
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                self:onGetRewardClicked_(i)
            end)
            :pos(btn_x, btn_y)
            :addTo(node)

        display.newSprite("#common/common_chip_icon.png")
            :pos(-35, 0)
            :addTo(self.item_reward_buttons[i])

        --进度
        local progress_width = 140
        self.item_progress[i] = tx.ui.ProgressBar.new(
            "#common/common_progress_bg.png", 
            "#common/common_progress.png", 
            {
                bgWidth = progress_width, 
                bgHeight = 22, 
                fillWidth = 26, 
                fillHeight = 20
            }
        )
        :setValue(0)
        :pos(btn_x - progress_width/2, btn_y)
        :addTo(node)

        --进度文字 
        self.item_progress_labels[i] = ui.newTTFLabel({text = "", size = 18, color = styles.FONT_COLOR.CONTENT_TEXT})
            :pos(progress_width/2, 0) 
            :addTo(self.item_progress[i])
    end
end

function AchievementTasksListItem:onDataSet(dataChanged, data)
    if dataChanged then
        self.data_ = data
        for i = 1, #data do
            local img = "dialogs/dailytasks/dailytasks_achievement_icon_" .. data[i].id .. ".png"
            self.item_icons[i]:setSpriteFrame(img)

            self.item_names[i]:setString(data[i].name)
            self.item_reward_buttons[i]:setButtonLabelString(data[i].reward)

            if data[i].status ==  Achieve.STATUS_UNDER_WAY then
                self.item_progress[i]:setValue(data[i].progress / data[i].target)
                self.item_progress_labels[i]:setString(sa.formatBigNumber(data[i].progress) .. "/" .. sa.formatBigNumber(data[i].target))
                
                self.item_lights[i]:hide()
                self.item_reward_buttons[i]:hide()
                self.item_share_buttons[i]:hide()

                if data[i].currentSubTaskIndex > 1 then
                    for k = 1, data[i].currentSubTaskIndex - 1 do
                        self.item_stars[i][k]:show()
                    end
                else
                    DisplayUtil.setGray(self.item_icons[i])
                end
            elseif data[i].status ==  Achieve.STATUS_CAN_REWARD then
                self.item_progress[i]:hide()
                self.item_lights[i]:show()
                self.item_reward_buttons[i]:show()
                self.item_share_buttons[i]:hide()

                for k = 1, data[i].currentSubTaskIndex do
                    self.item_stars[i][k]:show()
                end
            elseif data[i].status ==  Achieve.STATUS_FINISHED then
                self.item_progress[i]:hide()
                self.item_lights[i]:hide()
                self.item_reward_buttons[i]:hide()
                self.item_share_buttons[i]:show()

                for k = 1, 3 do
                    self.item_stars[i][k]:show()
                end
            end
        end

        if #data < ROW_NUM then
            for i = #data + 1, ROW_NUM do
                self.item_nodes[i]:hide()
            end
        end
    end
end

function AchievementTasksListItem:onGetRewardClicked_(index)
    -- local texture = self.item_icons[index]:getTexture()
    -- local data = clone(self.data_[index])
    sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GET_ACHIEVE_RWARD, data = self.data_[index]})
    -- scheduler.performWithDelayGlobal(function ()
    --     if texture and data then
    --         AchievementRewardPopup.new(texture, data):showPanel()
    --     end
    -- end, 2.5)
end

function AchievementTasksListItem:onAchievementTipsClicked_(index)
    if self.owner_.tips then
        self.owner_.tips:stopAllActions()
        self.owner_.tips:removeFromParent()
        self.owner_.tips = nil
    end

    local x, y = self.item_nodes[index]:getPosition()
    y = y + 50

    if index == 1 then
        x = x - 75
    elseif index == ROW_NUM then
        x = x + 75
    end

    local tips = AchievementTipsView.new(self.data_[index].task_desc, index)
        :pos(x, y)
        :addTo(self)

    tips:runAction(transition.sequence({cc.DelayTime:create(2), cc.CallFunc:create(function() 
            tips:removeFromParent()
            self.owner_.tips = nil
        end)}))
    self.owner_.tips = tips
end

function AchievementTasksListItem:onShareClicked_(index)
    local feedData = clone(sa.LangUtil.getText("FEED", "ACHIEVEMENT_REWARD"))
    feedData.name = sa.LangUtil.formatString(feedData.name, self.data_[index].name, self.data_[index].rewardDesc)
    feedData.caption = self.data_[index].name
    tx.ShareSDK:shareFeed(feedData, function(success, result)
        print("FEED.ACHIEVEMENT_REWARD result handler -> ", success, result)
    end)
end

function AchievementTasksListItem:onCleanup()
    self.owner_.tips = nil
end

return AchievementTasksListItem