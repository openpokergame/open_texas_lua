-- 好友列表视图
local FriendListView = class("FriendListView", function()
    return display.newNode()
end)

local FriendListItem = import(".FriendListItem")

local WIDTH, HEIGHT = 820, 590

function FriendListView:ctor(controller)
    self.controller_ = controller

    self:size(WIDTH, HEIGHT)
    local bg = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    local list_w, list_h = 808, 450
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
            upRefresh = handler(self, self.onFriendUpFrefresh_)
        }, 
        FriendListItem
    )
    :pos(WIDTH/2, HEIGHT/2 + 60)
    :addTo(self)

    self.list_.controller_ = self.controller_

    self.oneKeySendText_ = sa.LangUtil.getText("FRIEND", "ONE_KEY_SEND_CHIP")
    
    self.oneKeyRecallText_ = sa.LangUtil.getText("FRIEND", "ONE_KEY_RECALL")

    -- 一键赠送按钮
    local btn_w, btn_h = 270, 104
    local btn_x, btn_y = WIDTH/2, 65
    local dir = 160
    self.oneKeySendBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h )
        :setButtonLabel("normal", ui.newTTFLabel({text = self.oneKeySendText_, size = 20}))
        :pos(btn_x - dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onOneKeySendClicked_))
        :addTo(bg)
    self.oneKeySendBtn_:setButtonEnabled(false)

    -- 一键召回按钮
    self.oneKeyRecallBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h )
        :setButtonLabel("normal", ui.newTTFLabel({text = self.oneKeyRecallText_, size = 20}))
        :pos(btn_x + dir, btn_y)
        :onButtonClicked(buttontHandler(self, self.onOneKeyRecallClicked_))
        :addTo(bg)
    self.oneKeyRecallBtn_:setButtonEnabled(false)
end

function FriendListView:onOneKeySendClicked_()
    self.controller_:oneKeySend()
end

function FriendListView:onOneKeyRecallClicked_()
    self.controller_:oneKeyRecall()
end

function FriendListView:onFriendUpFrefresh_()
    self.controller_:onFriendUpFrefresh()
end

function FriendListView:setListData(data)
    data = data or {}
    -- sa.sortFriendData(data) --去掉排序
    self.list_:setData(data, true)
end

function FriendListView:updateOneKeySendStatus(enable, reward)
    if enable then
        self.oneKeySendBtn_:setButtonEnabled(true)
        self.oneKeySendBtn_:setButtonLabelString(self.oneKeySendText_ .. sa.formatBigNumber(reward))
    else
        self.oneKeySendBtn_:setButtonEnabled(false)
        self.oneKeySendBtn_:setButtonLabelString(self.oneKeySendText_)
    end
end

function FriendListView:updateOneKeyRecallStatus(enable, reward)
    if enable then
        self.oneKeyRecallBtn_:setButtonEnabled(true)
        self.oneKeyRecallBtn_:setButtonLabelString(self.oneKeyRecallText_ .. "+" .. reward)
    else
        self.oneKeyRecallBtn_:setButtonEnabled(false)
        self.oneKeyRecallBtn_:setButtonLabelString(self.oneKeyRecallText_)
    end
end

return FriendListView