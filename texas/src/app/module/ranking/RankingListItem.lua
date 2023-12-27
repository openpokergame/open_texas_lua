local RankingListItem = class("RankingListItem", sa.ui.ListItem)
local RankingPopupController = import(".RankingPopupController")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local BG_W, BG_H = 800, 122
local ITEM_W, ITEM_H = 808, 125
local RANK_X = 50
local PROFIT_TAB = 1 --盈利榜
local CHIP_TAB = 2 --游戏币榜
local UP_COLOR = cc.c3b(0xee, 0xdd, 0x5d)
local DOWN_COLOR = cc.c3b(0x30, 0xff, 0x68)

function RankingListItem:ctor()
    RankingListItem.super.ctor(self, ITEM_W, ITEM_H)
    
    self:setNodeEventEnabled(true)

    self.subSelected_ = PROFIT_TAB
end

function RankingListItem:createContent_()
    local posY = BG_H/2
    self.frame_ = display.newScale9Sprite("#common/pop_list_item_bg.png", ITEM_W/2, ITEM_H/2, cc.size(BG_W, BG_H)):addTo(self)
    local frame = self.frame_

    -- 名次标签
    self.ranking_ = ui.newBMFontLabel({text = "", font = "fonts/hall_ranking.fnt"})
        :pos(RANK_X, posY)
        :addTo(frame)

    -- 头像
    local avatarSize = 88
    self.avatar_ = SimpleAvatar.new()
        :pos(145, posY)
        :addTo(frame)
    NormalButton(self.avatar_):onButtonClicked(function()
        self:showDetail()
    end)
    self.avatar_:setTouchSwallowEnabled(false)

    local gender_x, gender_y = 220, posY + 20
    self.genderIcon_ = display.newSprite()
        :pos(gender_x, gender_y)
        :scale(0.7)
        :addTo(frame)

    self.nick_ =  ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER})
        :align(display.LEFT_CENTER, gender_x + 20, gender_y)
        :addTo(frame)

    local money_x, money_y = 220, posY - 20
    self.moneyIcon_ = display.newSprite("#common/common_chip_icon.png")
        :pos(money_x, money_y)
        :scale(0.7)
        :addTo(frame)

    self.moneyLabel_ =  ui.newTTFLabel({text = "", color = UP_COLOR, size = 24, align = ui.TEXT_ALIGN_CENTER})
        :align(display.LEFT_CENTER, money_x + 20, money_y)
        :addTo(frame)

    -- 追踪按钮
    self.trackBtn_ = cc.ui.UIPushButton.new({normal = "#hall/hall_track_btn_normal.png", pressed = "#hall/hall_track_btn_pressed.png", disabled = "#hall/hall_track_btn_disabled.png"})
        :onButtonClicked(buttontHandler(self, self.onTraceClick_))
        :pos(740, posY)
        :addTo(frame)

    self.trackBtn_:setTouchSwallowEnabled(false)
end

function RankingListItem:showDetail()
    if self.data_ and self.data_.uid~=tx.userData.uid then
        local OtherUserPopup = require("app.module.userInfo.OtherUserPopup")
        OtherUserPopup.new(self.data_):showPanel()
    end
end

function RankingListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    else
        self:updateRankItemText_()
    end

    if self.avatarDeactived_ and self.data_ then
        self.avatarDeactived_ = false
        self.avatar_:loadImage(self.data_.img)
    end
end

function RankingListItem:onItemDeactived()
    if self.created_ then
        if self.avatarLoaded_ then
            self.avatarLoaded_ = false
            self.avatarDeactived_ = true
            self.avatar_:setDefaultAvatar(self.data_.sex)
        end
    end
end

--[[
    data = {
        nick = "Aloha", 
        img = "img.png", 
        money = 1889, 
        level = 12, 
        ip = "192.168.0.1",
        port = "9001", 
        tid = "10012"}
]]
function RankingListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = self.dataChanged_ or dataChanged
    self.data_ = data
end

-- 排名数据
function RankingListItem:updateRankItemText_()
    if self.subSelected_ == PROFIT_TAB then
        self.moneyLabel_:setString("+" .. sa.formatNumberWithSplit(self.data_.money or 0)) 
    else
        self.moneyLabel_:setString(sa.formatNumberWithSplit(self.data_.money or 0)) 
    end
end

function RankingListItem:setData_(data)
    self.frame_:setContentSize(cc.size(BG_W, BG_H))
    -- 设置名次
    if self.index_ <= 3 then
        self.topRankIcon_ = display.newSprite("#common/ranking_icon_" .. self.index_ .. ".png")
        self.ranking_:hide()
        self.topRankIcon_:pos(RANK_X, BG_H/2 + 3):addTo(self.frame_)
    else
        if self.topRankIcon_ then
            self.topRankIcon_:removeFromParent()
        end
        self.ranking_:setString(self.index_)
        self.ranking_:show()
    end
    
    -- 设置头像
    if data.sex == "f" then
        self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
        self.avatar_:setSpriteFrame("common/icon_female.png")
    else
        self.genderIcon_:setSpriteFrame("common/common_sex_male.png")
        self.avatar_:setSpriteFrame("common/icon_male.png")
    end

    if data.img and string.len(data.img) > 5 then
       self.avatar_:loadImage(data.img)
    end 

    -- 设置昵称
    self.nick_:setString(tx.Native:getFixedWidthText("", 24, data.nick, 200))
    
    local posY = BG_H/2
    self.subSelected_ = self.owner_.controller:getSubSelectedTab()
    local gender_x, gender_y = 220, posY + 20 
    local money_x, money_y = 220, posY - 20
    local change_x = 465

    self.moneyIcon_:show()
    if self.subSelected_ == PROFIT_TAB then
        gender_x, gender_y = 220, posY
        money_x, money_y = 530, posY
        change_x = 450

        self.moneyIcon_:hide()
    end

    self.genderIcon_:pos(gender_x, gender_y)
    self.nick_:pos(gender_x + 20, gender_y)
    self.moneyLabel_:pos(money_x + 20, money_y)

    self:updateRankItemText_()

    self:updateRankingChangeState_(data.pos or 0, change_x)

    -- 设置追踪按钮
    if data.serverGameid and data.serverTid and tonumber(data.serverGameid)>0 and tonumber(data.serverTid)>0 then
        self.trackBtn_:setButtonEnabled(true)
    else
        self.trackBtn_:setButtonEnabled(false)
    end
end

function RankingListItem:onTraceClick_()
    sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = self.data_, isTrace = true})
    tx.PopupManager:removeAllPopup()
end

function RankingListItem:updateRankingChangeState_(pos, x)
    if self.rankingChangeNode_ then
        self.rankingChangeNode_:removeFromParent()
        self.rankingChangeNode_ = nil
    end

    if pos ~= 0 then
        local img = "#common/ranking_down_mark.png"
        local color = DOWN_COLOR
        if pos > 0 then
            img = "#common/ranking_up_mark.png"
            color = UP_COLOR
        end

        self.rankingChangeNode_ = display.newNode()
            :pos(x, BG_H/2)
            :addTo(self.frame_)

        display.newSprite(img)
            :addTo(self.rankingChangeNode_)

        ui.newTTFLabel({text = math.abs(pos), color = color, size = 24, align = ui.TEXT_ALIGN_CENTER})
            :align(display.LEFT_CENTER, 15, 0)
            :addTo(self.rankingChangeNode_)
    end
end

function RankingListItem:onCleanup()
end

return RankingListItem