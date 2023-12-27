-- 预览排行榜item

local SimpleAvatar       = import("openpoker.ui.SimpleAvatar")

local PreviewRankingItem = class("PreviewRankingItem", sa.ui.ListItem)
-- 1 显示小的  2展示全部
PreviewRankingItem.SHOWTYPE = 1

local OtherUserPopup = import("app.module.userInfo.OtherUserPopup")

PreviewRankingItem.WIDTH = 370
local ITEM_W, ITEM_H = 368, 100
local RANK_X, RANK_Y = 25, ITEM_H/2

function PreviewRankingItem:ctor()
    ITEM_W = PreviewRankingItem.WIDTH - 2
    PreviewRankingItem.super.ctor(self, ITEM_W, ITEM_H)
end

function PreviewRankingItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self.dataChanged_ = true
        self:createContent_()
    end
    if self.dataChanged_ and self.data_ then
        self.dataChanged_ = false
        local data = self.data_
        -- 设置名次
        if self.topRankIcon_ then
            self.topRankIcon_:removeFromParent()
            self.topRankIcon_ = nil
        end

        if self.index_ <= 3 then
            local img = "#common/ranking_icon_" .. self.index_ .. ".png"
            self.topRankIcon_ = display.newSprite(img)
                :scale(0.6)
                :pos(RANK_X, RANK_Y - 2)
                :addTo(self)

            self.ranking_:hide()
        else
            self.ranking_:setString(self.index_)
            self.ranking_:show()
        end
        
        -- 设置头像
        self.avatar_:setDefaultAvatar(data.sex)
        if data.img and string.len(data.img) > 5 then
            local imgurl = data.img
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.avatar_:loadImage(imgurl)
        end 

        -- 设置昵称
        self.nick_:setString(tx.Native:getFixedWidthText("", 24, data.nick, 120))

        self.money_:setString(sa.formatNumberWithSplit(data.money or 0))

        -- 设置追踪按钮
        if data.serverGameid and data.serverTid and tonumber(data.serverGameid)>0 and tonumber(data.serverTid)>0 then
            self.trackBtn_:setButtonEnabled(true)
            self.untrackBtn_:hide()
        else
            self.trackBtn_:setButtonEnabled(false)
            self.untrackBtn_:show()
        end
    end
end

function PreviewRankingItem:createContent_()
    local posY = ITEM_H/2

    self.avatar_ = SimpleAvatar.new()
        :pos(95, posY)
        :addTo(self)

    NormalButton(self):onButtonClicked(function()
            if not self.isClickTrack_ then  -- 点击了跟踪按钮
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                self:onUserInfoClicked_()
            end
        end)
        :onButtonRelease(function(evt)
            self.isClickTrack_ = false
        end)
        :setTouchSwallowEnabled(false)

    -- 名次标签
    self.ranking_ = ui.newBMFontLabel({text = "", font = "fonts/hall_ranking.fnt"})
        :pos(RANK_X, RANK_Y)
        :addTo(self)

    -- 追踪按钮
    self.trackBtn_ = cc.ui.UIPushButton.new({normal = "#hall/hall_track_btn_normal.png", pressed = "#hall/hall_track_btn_pressed.png", disabled = "#hall/hall_track_btn_disabled.png"})
        :onButtonClicked(buttontHandler(self, self.onTrackClicked_))
        :onButtonPressed(function(evt)
            self.isClickTrack_ = true
        end)
        :align(display.RIGHT_CENTER, ITEM_W - 5, posY)
        :addTo(self)
        
    self.trackBtn_:setTouchSwallowEnabled(false)

    self.untrackBtn_ = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(60, 90)
        :onButtonClicked(buttontHandler(self, self.onUntrackClicked_))
        :onButtonPressed(function(evt)
            self.isClickTrack_ = true
        end)
        :align(display.RIGHT_CENTER, ITEM_W - 10, posY)
        :addTo(self)
        
    self.untrackBtn_:setTouchSwallowEnabled(false)

    -- 昵称标签
    local nick_x = 145
    self.nick_ = ui.newTTFLabel({text = "", size = 22})
        :align(display.LEFT_CENTER, nick_x, posY + 17)
        :addTo(self)

    -- 数值
    self.money_ = ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 22})
        :align(display.LEFT_CENTER, nick_x, posY - 17)
        :addTo(self)

    display.newScale9Sprite("#hall/hall_ranking_item_line.png", 0, 0, cc.size(ITEM_W, 2))
        :pos(ITEM_W/2, 0)
        :addTo(self)
end

function PreviewRankingItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function PreviewRankingItem:onUserInfoClicked_()
    if self.data_ and self.data_.uid~=tx.userData.uid then
        OtherUserPopup.new(self.data_):showPanel()
    end
end

function PreviewRankingItem:onTrackClicked_()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "hall_left_track", label = "hall_left_track"}
        }
    end
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = self.data_, isTrace = true})
    tx.PopupManager:removeAllPopup()
end

function PreviewRankingItem:onUntrackClicked_()
    tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "NOT_TRACK_TIPS"))
end

return PreviewRankingItem
