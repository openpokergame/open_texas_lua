-- 好友弹窗

local FriendPopup           = class("FeiendPopup", tx.ui.Panel)

local FriendData            = import(".FriendData")
local FriendPopupController = import(".FriendPopupController")
local AvatarIcon            = import("openpoker.ui.AvatarIcon")
local FriendListView        = import(".FriendListView")
local MoreFriendView        = import(".MoreFriendView")

local WIDTH, HEIGHT = 1136, 746

local SHOW_FRIEND = 1 --我关注的
local SHOW_FRIEND_2 = 2 --关注我的
local SHOW_MORE_FRIEND = 3 --更多好友

function FriendPopup:ctor(defaultTab)
    FriendPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setNodeEventEnabled(true)

    self.controller_ = FriendPopupController.new(self)

    self.selectedMainTab_ = defaultTab or 1

    display.addSpriteFrames("dialog_friend.plist", "dialog_friend.png")

    self:createMainUI_()

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:start("analytics.UmengAnalytics")
    end
end

function FriendPopup:createMainUI_()
    self:setImgTitleStyle("#lang/pop_title_friend.png")

    self:setMainTabStyle(sa.LangUtil.getText("FRIEND", "MAIN_TAB_TEXT"), self.selectedMainTab_, handler(self, self.onMainTabChange_))

    -- self.newFriendPoint = display.newSprite("#common/common_red_point.png")
    --     :pos(260, 420)
    --     :addTo(self.background_, 10)

    self.friendListView_ = FriendListView.new(self.controller_)
        :align(display.RIGHT_BOTTOM, WIDTH*0.5 - 28, -HEIGHT*0.5+30)
        :addTo(self)

    -- if FriendData.hasNewMessage then
    --     self.newFriendPoint:show()
    -- else
    --     self.newFriendPoint:hide()
    -- end

    self.noDataTip_ = self:createNoDataTips(sa.LangUtil.getText("FRIEND", "NO_FRIEND_TIP")):hide()

    self.controller_:onMainTabChange(self.selectedMainTab_)
end

function FriendPopup:onMainTabChange_(evt)
    local selected = evt.selected
    self:setListData()
    self:setNoDataTip(false)

    if selected == SHOW_FRIEND then
        self.friendListView_:show()
        self:updateMoreFriendView_(false)
    elseif selected == SHOW_FRIEND_2 then
        self.friendListView_:show()
        self:updateMoreFriendView_(false)
    elseif selected == SHOW_MORE_FRIEND then
        self.friendListView_:hide()
        self:updateMoreFriendView_(true)
    end

    self.controller_:onMainTabChange(selected)
end

function FriendPopup:updateMoreFriendView_(isShow)
    if self.moreFriendView_ then
        self.moreFriendView_:removeFromParent()
        self.moreFriendView_ = nil
    end

    if isShow then
        self.moreFriendView_ = MoreFriendView.new(self.controller_)
            :align(display.RIGHT_BOTTOM, WIDTH*0.5 - 28, -HEIGHT*0.5+30)
            :addTo(self)
    end
end

function FriendPopup:setListData(data)
    data = data or {}

    self:setLoading(false)

    if #data == 0 then
        self:setNoDataTip(true)
    else
        self:setNoDataTip(false)
    end

    self.friendListView_:setListData(data)
end

function FriendPopup:updateOneKeySendStatus(enable, reward)
    self.friendListView_:updateOneKeySendStatus(enable, reward)
end

function FriendPopup:updateOneKeyRecallStatus(enable, reward)
    self.friendListView_:updateOneKeyRecallStatus(enable, reward)
end

function FriendPopup:setNoDataTip(noData)
    if noData then
        self.noDataTip_:show()
    else
        self.noDataTip_:hide()
    end
end

function FriendPopup:onShowed()
    if self.list_ then
        self.list_:setScrollContentTouchRect()
    end
end

function FriendPopup:onCleanup()
    self.controller_:dispose()
    display.removeSpriteFramesWithFile("dialog_friend.plist", "dialog_friend.png")
end

function FriendPopup:onExit()
    tx.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return FriendPopup