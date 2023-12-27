--玩牌活动
local PlayCardListItem = class("PlayCardListItem", sa.ui.ListItem)

local WIDTH, HEIGHT = 820, 84
local BG_W, BG_H = 760, 64
local LABEL_X = 100
local TEXT_CORLOR_1 = cc.c3b(0xff, 0xff, 0xff)
local TEXT_CORLOR_2 = cc.c3b(0x7d, 0xfd, 0xff) -- 蓝
local TEXT_CORLOR_3 = cc.c3b(0xf7, 0x71, 0xff) -- 紫
local TEXT_CORLOR_4 = cc.c3b(0xff, 0xe0, 0x75) -- 黄

function PlayCardListItem:ctor()
    PlayCardListItem.super.ctor(self, WIDTH, HEIGHT)
end

function PlayCardListItem:createContent_()
    local frame = display.newScale9Sprite("#common/act_play_btn_item.png", 0, 0, cc.size(BG_W, BG_H))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local y = BG_H*0.5
    self.blind_ = ui.newTTFLabel({text = "", size = 22, color = TEXT_CORLOR_1})
        :pos(70, y)
        :addTo(frame)

    self.time_ = ui.newTTFLabel({text = "", size = 22, color = TEXT_CORLOR_2})
        :pos(230, y)
        :addTo(frame)

    self.playNum_ = ui.newTTFLabel({text = "", size = 22, color = TEXT_CORLOR_3})
        :pos(370, y)
        :addTo(frame)

    self.money_ = ui.newTTFLabel({text = "", size = 22, color = TEXT_CORLOR_4})
        :pos(500, y)
        :addTo(frame)

    self.btn_ = cc.ui.UIPushButton.new({normal = "#common/act_play_btn_normal.png", pressed = "#common/act_play_btn_pressed.png"})
        :setButtonLabel(ui.newTTFLabel({text = "PLAY NOW", size = 24}))
        :onButtonClicked(buttontHandler(self, self.onPlayClicked_))
        :align(display.RIGHT_CENTER, BG_W, y)
        :addTo(frame)
end

function PlayCardListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function PlayCardListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function PlayCardListItem:setData_(data)
    local blind = sa.LangUtil.getText("MATCH", "FORMAT_BLIND", sa.formatBigNumber(data.blind), sa.formatBigNumber(data.blind*2))
    self.blind_:setString(blind)

    self.time_:setString(data.time)

    self.playNum_:setString(data.playNum)

    self.money_:setString(sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatBigNumber(data.money)))

    if data.online == 0 then
        self.btn_:setColor(cc.c3b(0x99, 0x99, 0x99))
    else
        self.btn_:setColor(cc.c3b(0xff, 0xff, 0xff))
    end
end

function PlayCardListItem:onPlayClicked_()
    local hallScene = display.getRunningScene()
    hallScene:requestRoom({gameId=self.data_.gameId, level=self.data_.gameLevel})
end

return PlayCardListItem