local DailyTask = import("app.module.dailytasks.DailyTask")
local RoomTaskItem = class("RoomTaskItem", sa.ui.ListItem)
RoomTaskItem.WIDTH = 0
RoomTaskItem.HEIGHT = 0
local AVATAR_SIZE = 90
local TEXT_COLOR = cc.c3b(0xEE, 0xEE, 0xEE)
function RoomTaskItem:ctor()
    self:setNodeEventEnabled(true)
    self.iconLoaderId_ = tx.ImageLoader:nextLoaderId() -- 图标加载id
    local item_w, item_h = RoomTaskItem.WIDTH, RoomTaskItem.HEIGHT
	RoomTaskItem.super.ctor(self, item_w, item_h)

    --图标
    self.icon_ = display.newSprite()
        :pos(70, item_h*0.5)
        :addTo(self)

	local progress_width = 120
	local name_pos_x = 130
	--名称
    self.name_ = ui.newTTFLabel({
            text = "",
            size = 22,
            color = TEXT_COLOR,
            align = ui.TEXT_ALIGN_LEFT,
            dimensions = cc.size(136, 0)
        })
        :align(display.LEFT_CENTER, name_pos_x, item_h*0.5 + 27)
        :addTo(self)

    self.progress_ = tx.ui.ProgressBar.new(
	        "#common/common_progress_bg.png", 
	        "#common/common_progress.png", 
	        {
	            bgWidth = progress_width, 
	            bgHeight = 22, 
	            fillWidth = 26, 
	            fillHeight = 20
	        }
	    )
        :pos(name_pos_x, item_h*0.5 - 20)
        :setValue(0.5)
	    :addTo(self)

    --进度文字 
    self.labelProgress_ = ui.newTTFLabel({text = "", size = 22, align = ui.TEXT_ALIGN_CENTER})
        :pos(progress_width * 0.5, 0) 
        :addTo(self.progress_)
        
    local btn_x, btn_y = item_w - 80, item_h*0.5
    local btn_w, btn_h = 150, 104
    self.getAwardBtn_ = ImgButton(display.newScale9Sprite("#common/btn_small_yellow.png",0,0,cc.size(btn_w, btn_h)),"#common/btn_small_yellow.png","#common/btn_small_yellow_down.png")
        :pos(btn_x, btn_y)
        :onButtonClicked(buttontHandler(self, function(obj)
            local list = self:getOwner()
            if list.onItemClick then
                list.onItemClick(self.data_)
            end
        end))
        :addTo(self)

    self.getAwardBtn_:setTouchSwallowEnabled(false)
    self.getAwardLabel_ = ui.newTTFLabel({
            text = sa.LangUtil.getText("COMMON","GET_REWARD"),
            size = 24,
            color = TEXT_COLOR,
            align = ui.TEXT_ALIGN_CENTER
        })
        :pos(btn_w*0.5, btn_h*0.5) 
        :addTo(self.getAwardBtn_)

    self.awardLabel_ = ui.newTTFLabel({
            text = "",
            size = 22,
            color = styles.FONT_COLOR.CONTENT_TEXT,
            align = ui.TEXT_ALIGN_CENTER,
        })
        :pos(btn_x, btn_y)
        :addTo(self)

    self.line_ = display.newScale9Sprite("#common/split_line_h.png",0,0,cc.size(item_w, 2))
        :pos(item_w*0.5, 2)
        :addTo(self)
    
end

function RoomTaskItem:onDataSet(dataChanged, data)
    if data then
        local list_ = self:getOwner()
        local data_ = list_:getData()
        if data_ and self:getIndex()==#data_ then
            self.line_:hide()
        else
            self.line_:show()
        end
        self.name_:setString(data.name)
        self.name_:scale(1)
        local size = self.name_:getContentSize()
        if size.height>65 then
            self.name_:scale(65/size.height)
        end
        if data.progress and data.target then
            self.progress_:setValue(data.progress / data.target)
            self.labelProgress_:setString(data.progress.."/"..data.target)
        else
            self.progress_:hide()
        end
        if data.status ==  DailyTask.STATUS_UNDER_WAY then
            self.getAwardBtn_:hide()
            self.awardLabel_:show()
            if data.rewardDesc then
                self.awardLabel_:setString(data.rewardDesc)
            else
                self.awardLabel_:hide()
            end
        elseif data.status ==  DailyTask.STATUS_CAN_REWARD then
            self.getAwardBtn_:show()
            self.awardLabel_:hide()
        elseif data.status ==  DailyTask.STATUS_FINISHED then
            self.getAwardBtn_:hide()
            self.awardLabel_:show()
            self.awardLabel_:setString(sa.LangUtil.getText("DAILY_TASK","HAD_FINISH"))
        -- elseif data.status ==  DailyTask.STATUS_SPECIAL then
        --     self.getAwardBtn_:hide()
        --     self.finishLabel_:hide()
        --     self.gotoButton_:show()
        end
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
    end
end

function RoomTaskItem:onIconLoadComplete_(success, sprite)
    if not self.icon_ then return; end
    if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()
        self.icon_:setTexture(tex)
        self.icon_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))
        self.icon_:setScaleX(AVATAR_SIZE / texSize.width)
        self.icon_:setScaleY(AVATAR_SIZE / texSize.height)
    end
end

function RoomTaskItem:onCleanup()
    tx.ImageLoader:cancelJobByLoaderId(self.iconLoaderId_)
end

return RoomTaskItem