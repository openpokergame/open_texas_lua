-- 更多好友视图，包含邀请好友，搜索好友
local MoreFriendView = class("MoreFriendView", function()
    return display.newNode()
end)

local InviteFriendView = import(".InviteFriendView")
local SearchUserInfoView = import(".SearchUserInfoView")
local NumberEditbox = import("openpoker.ui.NumberEditbox")

local WIDTH, HEIGHT = 820, 590
local EDIT_BOX_FONT_COLOR = styles.FONT_COLOR.INPUT_TEXT

function MoreFriendView:ctor(controller)
    self.controller_ = controller

    self:size(WIDTH, HEIGHT)
    self:setNodeEventEnabled(true)
	
    local bg = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :pos(WIDTH*0.5, HEIGHT*0.5)
        :addTo(self)

    self.bg_ = bg

	--搜索好友
    self.editbox_ = NumberEditbox.new({
            width = 582, height = 70, 
            tips = sa.LangUtil.getText("FRIEND", "INPUT_USER_ID"),
            onInputCallback = handler(self, self.onClearClicked_),
            onEnterCallback =  handler(self, self.onEnterClicked_)
        })
        :pos(WIDTH/2 - 80, HEIGHT - 70)
        :addTo(bg, 1)

    --查找,清除按钮
    local btn_w, btn_h = 190, 104
    local btn_x, btn_y = WIDTH - 105, HEIGHT - 70
    self.searchBtn_ = cc.ui.UIPushButton.new({normal="#common/btn_small_blue.png", pressed="#common/btn_small_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(cc.ui.UILabel.new({text = sa.LangUtil.getText("FRIEND", "SEARCH"), size = 28}))
        :onButtonClicked(buttontHandler(self, self.onSearchClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)

    self.clearBtn_ = cc.ui.UIPushButton.new({normal="#common/btn_small_yellow.png", pressed="#common/btn_small_yellow_down.png"}, {scale9 = true})
    	:setButtonSize(btn_w, btn_h)
        :setButtonLabel(cc.ui.UILabel.new({text = sa.LangUtil.getText("FRIEND", "CLEAR"), size = 28}))
        :onButtonClicked(buttontHandler(self, self.onClearClicked_))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()

    self.inviteView_ = InviteFriendView.new(self.controller_)
    	:pos(WIDTH/2, HEIGHT/2)
    	:addTo(bg)
end

--搜索好友结果UI
function MoreFriendView:addSearchUserInfo_(id)
    self:removeSearchUserInfo_()

    self:setLoading(true)
    sa.HttpService.POST({
        mod="Friend",
        act="searchFriends",
        searchid = id
    },
    function(data)
        self:setLoading(false)
        local jsonData = json.decode(data)
        if jsonData.code == 1 then --搜索成功
            self.userInfoView_ = SearchUserInfoView.new(jsonData, self.controller_)
	            :pos(WIDTH/2, HEIGHT/2 - 68)
	            :addTo(self.bg_)
        else --ID不存在
            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "INPUT_USER_ID_NO_EXIST"))
            self:removeSearchUserInfo_()
            self.inviteView_:show()
            self.editbox_:setTextColor(cc.c3b(0xc6, 0x4c, 0x4c))
        end
    end,
    function()
        self:setLoading(false)
        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "BAD_NETWORK"))
        self:removeSearchUserInfo_()
        self.inviteView_:show()
    end)
end

function MoreFriendView:removeSearchUserInfo_()
    if self.userInfoView_ then
        self.userInfoView_:removeFromParent()
        self.userInfoView_ = nil
    end
end

function MoreFriendView:onEnterClicked_(evt)
    self:onSearchClicked_()
end

function MoreFriendView:onSearchClicked_()
    local text = self.editbox_:getText()

    if text ~= "" then
        if tx.userData.uid == tonumber(text) then
            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "NO_SEARCH_SELF"))
            self.editbox_:setText(sa.LangUtil.getText("FRIEND", "INPUT_USER_ID"))
            return
        end

        self.searchBtn_:hide()
        self.clearBtn_:show()
        self.inviteView_:hide()
        self:addSearchUserInfo_(text)
    end
end

function MoreFriendView:onClearClicked_()
    self.clearBtn_:hide()
    self.searchBtn_:show()
    self.editbox_:setTextColor(EDIT_BOX_FONT_COLOR)
    self.editbox_:setText(sa.LangUtil.getText("FRIEND", "INPUT_USER_ID"))
    self.inviteView_:show()
    self:removeSearchUserInfo_()
end

function MoreFriendView:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(WIDTH*0.5, HEIGHT*0.5)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function MoreFriendView:onCleanup()
end

return MoreFriendView