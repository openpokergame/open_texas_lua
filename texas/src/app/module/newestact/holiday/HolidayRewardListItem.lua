local HolidayRewardListItem = class("HolidayRewardListItem", sa.ui.ListItem)

local HolidayBlessingPopup = import(".HolidayBlessingPopup")
local HolidayRewardTipsView = import(".HolidayRewardTipsView")
local HolidayRewardPopup = import(".HolidayRewardPopup")

local WIDTH, HEIGHT = 520, 108
local BG_W, BG_H = 510, 100

function HolidayRewardListItem:ctor()
    HolidayRewardListItem.super.ctor(self, WIDTH, HEIGHT)
end

function HolidayRewardListItem:createContent_()
    local frame = display.newScale9Sprite("#holiday_item_bg.png", 0, 0, cc.size(BG_W, BG_H))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local y = BG_H*0.5
    local icon = display.newSprite("#holiday_reward_icon.png")
        :pos(50, y)
        :addTo(frame)

    self.needNum_ = ui.newTTFLabel({text = "", size = 22})
        :align(display.LEFT_CENTER, 52, 15)
        :addTo(icon)

    display.newSprite("#holiday_equal.png")
        :pos(140, y)
        :addTo(frame)

    self.rewardIcon_ = display.newSprite()
        :pos(230, y)
        :addTo(frame)

    NormalButton(self.rewardIcon_):onButtonPressed(handler(self, self.showRewardTips_))
            :onButtonRelease(handler(self, self.hideRewardTips_))

    local btn_x, btn_y = 430, y + 10
    self.rewardBtn_ = cc.ui.UIPushButton.new({normal = "#holiday_btn_normal.png", pressed = "#holiday_btn_pressed.png", disabled = "#holiday_btn_disabled.png"}, {scale9 = true})
        :setButtonSize(140, 70)
        :setButtonLabel(ui.newTTFLabel({text = "", size = 24, color = cc.c3b(0xb8, 0x27, 0x72)}))
        :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)

    self.limitLabel_ = ui.newTTFLabel({text = "", size = 22})
        :pos(btn_x, btn_y - 48)
        :addTo(frame)
end

function HolidayRewardListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end
end

function HolidayRewardListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

function HolidayRewardListItem:setData_(data)
    self.needNum_:setString("x" .. data.needNum)

    self.rewardIcon_:setSpriteFrame("holiday_reward_icon_" .. data.rewardType .. ".png")

    self.rewardBtn_:setButtonLabelString(data.name)

    self.rewardBtn_:setButtonEnabled(false)
    if data.limitGet < 0 then
        self.limitLabel_:setString(sa.LangUtil.getText("NEWESTACT","HOLIDAY_NO_LIMIT"))
        if data.actProps >= data.needNum then
            self.rewardBtn_:setButtonEnabled(true)
        end
    else
        self.limitLabel_:setString(sa.LangUtil.getText("NEWESTACT","HOLIDAY_REWARD_LIMIT", data.alreadyGet, data.limitGet))
        if data.alreadyGet < data.limitGet and data.actProps >= data.needNum then
            self.rewardBtn_:setButtonEnabled(true)
        end
    end
end

function HolidayRewardListItem:showRewardTips_(evt)
    self:hideRewardTips_()

    local x, y = self.rewardIcon_:getPosition()
    local list = self:getOwner()
    local bg = list:getParent()
    local tempWorldPt = self:convertToWorldSpace(cc.p(x, y))
    local tempNodePt = bg:convertToNodeSpace(tempWorldPt)
    local view = HolidayRewardTipsView.new(self.data_.rewardDesc)
        :align(display.BOTTOM_CENTER, tempNodePt.x + 0, tempNodePt.y + 0)
        :addTo(bg, 10)

    self.rewardTipsView_ = view
end

function HolidayRewardListItem:hideRewardTips_()
    if self.rewardTipsView_ then
        self.rewardTipsView_:removeFromParent()
        self.rewardTipsView_ = nil
    end
end

function HolidayRewardListItem:onGetRewardClicked_()
    local rewardType = self.data_.rewardType
    local needNum = self.data_.needNum
    if rewardType == 1 then
        local descData = self.data_.descList 
        descData.needNum = needNum
        HolidayBlessingPopup.new(descData, handler(self, self.updateRewardListData_)):showPanel()
    elseif rewardType == 2 then
        self:getExchangeReward_(rewardType, needNum)
    end
end

function HolidayRewardListItem:getExchangeReward_(rewardType, needNum)
    self.rewardBtn_:setButtonEnabled(false)
    sa.HttpService.POST(
        {
            mod = "Activity",
            act = "omahaExchange",
            type = rewardType,
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                local reward = retData.data
                HolidayRewardPopup.new(reward):showPanel()

                local evtData = {} -- 动画
                for _, v in ipairs(reward) do
                    if v.rewardType == 1 then
                        tx.userData.money = tx.userData.money + v.rewardNum
                        evtData.money = v.rewardNum
                    elseif v.rewardType == 2 then
                        tx.userData.diamonds = tx.userData.diamonds + v.rewardNum
                        evtData.diamonds = v.rewardNum
                    elseif v.rewardType == 3 then
                        evtData.props = v.rewardNum
                    end
                end
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
                self:updateRewardListData_(needNum)
            elseif retData.code == -3 then
                tx.TopTipManager:showToast(retData.msg)
            else
                self.rewardBtn_:setButtonEnabled(true)
                tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "EXCHANGE_REAL_FAILED_2"))
            end
        end,
        function ()
            self.rewardBtn_:setButtonEnabled(true)
            tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "EXCHANGE_REAL_FAILED_2"))
        end
    )
end

function HolidayRewardListItem:updateRewardListData_(needNum)
    self.data_.alreadyGet = self.data_.alreadyGet + 1
    local list = self:getOwner()
    if list.updateDataListener then
        list.updateDataListener(needNum)
    end
end

return HolidayRewardListItem