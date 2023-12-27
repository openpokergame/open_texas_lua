-- 任务元素

local DailyTasksListItem = class("DailyTasksListItem", sa.ui.ListItem)

local DailyTask = import(".DailyTask")

local BG_W, BG_H = 800, 120
local ITEM_W, ITEM_H = BG_W + 10, BG_H + 5
local AVATAR_SIZE = 90

function DailyTasksListItem:ctor()
    DailyTasksListItem.super.ctor(self, ITEM_W, ITEM_H)
    self:setNodeEventEnabled(true)

    local bg = display.newScale9Sprite("#common/pop_list_item_bg.png", ITEM_W/2, ITEM_H/2, cc.size(BG_W, BG_H))
        :addTo(self)

    local y = BG_H*0.5
    --图标
    self.icon_ = display.newSprite()
        :pos(60, y)
        :addTo(bg)

    self.iconLoaderId_ = tx.ImageLoader:nextLoaderId() -- 图标加载id

    --名称
    self.nameLabel_ = ui.newTTFLabel({size = 22, color = cc.c3b(0xff, 0xff, 0xff)})
        :align(display.LEFT_CENTER, 130, y + 30)
        :addTo(bg)

    --进度
    local progress_w = 152
    local progress_h = 22
    self.progress_ = tx.ui.ProgressBar.new(
        "#common/common_progress_bg.png", 
        "#common/common_progress.png", 
        {
            bgWidth = progress_w, 
            bgHeight = progress_h, 
            fillWidth = 26, 
            fillHeight = 20
        }
    )
    :align(display.LEFT_CENTER, 130, y - 20)
    :setValue(0)
    :addTo(bg)

    --进度文字 
    self.progressLabel_ = ui.newTTFLabel({
            size = 18,
            color = styles.FONT_COLOR.CONTENT_TEXT,
        })
        :pos(progress_w/2, 0)
        :addTo(self.progress_) 

    --奖励
    local icon_x, icon_y = BG_W/2, y
    display.newSprite("#common/common_chip_icon.png")
        :pos(icon_x, icon_y)
        :scale(0.8)
        :addTo(bg)

    self.rewardLabel_ = ui.newTTFLabel({size = 22, color = styles.FONT_COLOR.CHIP_TEXT})
        :align(display.LEFT_CENTER, icon_x + 20, icon_y)
        :addTo(bg)
   
    --奖励按钮
    local btn_w, btn_h = 200, 104
    local btn_x, btn_y = BG_W - 105, y
    self.rewardButton_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png"}, {scale9 = true})
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("DAILY_TASK", "GET_REWARD"), size = 22}))
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(buttontHandler(self, self.onGetReward_))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()
    self.rewardButton_:setTouchSwallowEnabled(false)

    --去完成
    self.gotoButton_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png"}, {scale9 = true})
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("DAILY_TASK", "GO_TO"), size = 22}))
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(buttontHandler(self, self.onGotoTask_))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()
    self.gotoButton_:setTouchSwallowEnabled(false)

    --已经完成
    self.finishLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("DAILY_TASK", "HAD_FINISH"), size = 22})
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()
end

function DailyTasksListItem:onDataSet(dataChanged, data)
    if dataChanged then
        self.task = data

        if data.iconUrl then
            tx.ImageLoader:loadAndCacheImage(
                self.iconLoaderId_, 
                data.iconUrl, 
                handler(self, self.onIconLoadComplete_),
                tx.ImageLoader.CACHE_TYPE_ACT
            )
        elseif data.icon then
            self.icon_:setSpriteFrame(data.icon)
        end

        self.nameLabel_:setString(data.name)
        if data.rewardDesc then
            self.rewardLabel_:setString(data.rewardDesc)
        else
            self.rewardLabel_:hide()
        end

        if data.progress and data.target then
            self.progress_:setValue(data.progress / data.target)
            self.progressLabel_:setString(data.progress.."/"..data.target)
        else
            self.progress_:hide()
        end

        if data.status ==  DailyTask.STATUS_UNDER_WAY then
            self.rewardButton_:hide()
            self.finishLabel_:hide()

            if data.goto == 8 then
                self.gotoButton_:hide()
            else
                self.gotoButton_:show()
            end
        elseif data.status ==  DailyTask.STATUS_CAN_REWARD then
            self.rewardButton_:show()
            self.finishLabel_:hide()
            self.gotoButton_:hide()
        elseif data.status ==  DailyTask.STATUS_FINISHED then
            self.rewardButton_:hide()
            self.finishLabel_:show()
            self.gotoButton_:hide()
        -- elseif data.status ==  DailyTask.STATUS_SPECIAL then
        --     self.gotoButton_:setButtonLabelString("normal", sa.LangUtil.getText("MATCH", "MATCHDETAIL"))
        --     self.rewardButton_:hide()
        --     self.finishLabel_:hide()
        --     self.gotoButton_:show()
        end
    end
end

function DailyTasksListItem:onIconLoadComplete_(success, sprite)
    if success and self.icon_ then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()
        self.icon_:setTexture(tex)
        self.icon_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))
        self.icon_:setScaleX(AVATAR_SIZE / texSize.width)
        self.icon_:setScaleY(AVATAR_SIZE / texSize.height)
    end
end

function DailyTasksListItem:onGetReward_()
    sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GET_RWARD, data = self.task})
end

function DailyTasksListItem:onGotoTask_()
    sa.EventCenter:dispatchEvent({name = tx.DailyTasksEventHandler.GOTO_TASK, data = self.task})
end

function DailyTasksListItem:onCleanup()
    tx.ImageLoader:cancelJobByLoaderId(self.iconLoaderId_)
end

return DailyTasksListItem