--玩牌活动
local HolidayActListItem = class("HolidayActListItem", sa.ui.ListItem)

local ChooseGameView    = import("app.module.hall.ChooseGameView")
local StorePopup        = import("app.module.store.StoreView")

local WIDTH, HEIGHT = 520, 108
local BG_W, BG_H = 510, 100

function HolidayActListItem:ctor()
    HolidayActListItem.super.ctor(self, WIDTH, HEIGHT)
    self.this_ = self
end

function HolidayActListItem:createContent_()
    local frame = display.newScale9Sprite("#holiday_item_bg.png", 0, 0, cc.size(BG_W, BG_H))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local y = BG_H*0.5
    local icon = display.newSprite("#holiday_reward_icon.png")
        :pos(50, y)
        :addTo(frame)

    self.rewardNum_ = ui.newTTFLabel({text = "", size = 22})
        :align(display.LEFT_CENTER, 52, 15)
        :addTo(icon)

    local label_x = 110
    self.nameLabel_ = ui.newTTFLabel({text = "", size = 28})
        :align(display.LEFT_CENTER, label_x, y + 12)
        :addTo(frame)

    local progress_w, progress_h = 156, 22
    self.progress_ = tx.ui.ProgressBar.new(
        "#holiday_progress_bg.png", 
        "#holiday_progress.png", 
        {
            bgWidth = progress_w, 
            bgHeight = progress_h, 
            fillWidth = 30, 
            fillHeight = 20
        }
    )
    :align(display.LEFT_CENTER, label_x, y - 20)
    :setValue(0)
    :addTo(frame)

    self.progressLabel_ = ui.newTTFLabel({text = "",size = 18})
        :pos(progress_w/2, 0)
        :addTo(self.progress_) 

    local btn_w, btn_h = 140, 70
    local btn_x, btn_y = 430, y
    self.gotoBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_btn_normal.png", pressed = "#holiday_btn_pressed.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("DAILY_TASK","GO_TO"), size = 24, color = cc.c3b(0xb8, 0x27, 0x72)}))
        :onButtonClicked(buttontHandler(self, self.onGotoClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)
        :hide()

    self.rewardBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_btn_normal.png", pressed = "#holiday_btn_pressed.png", disabled = "#holiday_btn_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON","GET"), size = 24, color = cc.c3b(0xb8, 0x27, 0x72)}))
        :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)
        :hide()

    self.finishLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("DAILY_TASK","HAD_FINISH"), size = 24, color = cc.c3b(0xb8, 0x27, 0x72)}) 
        :pos(btn_x, btn_y)
        :addTo(frame)
        :hide()
end

function HolidayActListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function HolidayActListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function HolidayActListItem:setData_(data)
    self.rewardNum_:setString("x" .. data.reward)
    
    self.nameLabel_:setString(data.name)

    if data.progress and data.target then
        self.progress_:setValue(data.progress / data.target)
        self.progressLabel_:setString(data.progress.."/"..data.target)
    else
        self.progress_:hide()
    end

    self.gotoBtn_:hide()
    self.rewardBtn_:hide()
    self.finishLabel_:hide()
    if data.status == 0 then
        self.gotoBtn_:show()
    elseif data.status == 1 then
        self.rewardBtn_:show()
    else
        self.finishLabel_:show()
    end
end

function HolidayActListItem:onGotoClicked_()
    local goto = self.data_.goto
    if goto == 5 then
        -- app:enterGameHall(1, {data.level})
        app:enterGameHall(1)
    elseif goto == 7 then
        app:enterOmahaHall()
    elseif goto == 8 then
        app:enterRedblcakRoom()
    elseif goto == 10 then
        app:enterGameHall(2)
    elseif goto == 11 then
        app:enterGameHall(2, {2})
    elseif goto == 12 then
        tx.PayGuideManager:openStore(data.goodsType, data.payType)
    end
end

function HolidayActListItem:onGetRewardClicked_()
    self.rewardBtn_:setButtonEnabled(false)
    sa.HttpService.POST(
        {
            mod = "Activity",
            act = "playOmahaRwd",
            playNum = self.data_.target,
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                local desc = sa.LangUtil.getText("STORE", "FORMAT_DLB", sa.formatNumberWithSplit(retData.speaker))
                tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COMMON", "REWARD_TIPS", desc))
                if self.this_ then
                    self.rewardBtn_:hide()
                    self.finishLabel_:show()
                end
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "REWARD_FAIL"))
                if self.this_ then
                    self.rewardBtn_:setButtonEnabled(true)
                end
            end
        end,
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("LOGIN", "REWARD_FAIL"))
            if self.this_ then
                self.rewardBtn_:setButtonEnabled(true)
            end
        end
    )
end

return HolidayActListItem