-- 邀请好友弹窗

local InvitePopup = class("InvitePopup", function ()
    return display.newNode()
end)

local InviteListItem = import(".InviteListItem")
local InvitePopupController = import(".InvitePopupController")
local logger = sa.Logger.new("InvitePopup")
local RichText = import("openpoker.ui.RichText")

local WIDTH, HEIGHT = 1208, 775
local frame_w, frame_h = 1190, 665
local LIST_POS_Y = -48
local friendDataGlobal = {}

local MAX_SELECT_NUM --当前最多选择人数

local INVITE_NUM = 200 --0全选 其他数字表示具体人数
local TEXT_CORLOR_1 = cc.c3b(0x54, 0x71, 0xad) --输入框蓝
local TEXT_CORLOR_2 = cc.c3b(0x90, 0x39, 0xed) --紫色
local TEXT_CORLOR_3 = cc.c3b(0xc9, 0x86, 0x0) --金色
local INVITE_SEND_CHIPS --发送FB邀请奖励

function InvitePopup:ctor()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()

    INVITE_SEND_CHIPS = tx.userData.inviteSendChips

    self.isFirstShow_ = true --是否首次打开弹窗

    self.userItems_ = {}

    self.controller_ = InvitePopupController.new(self)

    self.isShowFBTips_ = tx.config.IS_SHOW_FB_TIPS

    display.addSpriteFrames("invite_texture.plist", "invite_texture.png")

    if INVITE_NUM == 0 then
        MAX_SELECT_NUM = 200
    else
        local num = self:getTodayInviteCount()
        MAX_SELECT_NUM = INVITE_NUM - num
    end

    self:addMainUI_()

    self:setVisible(false)

    self:reportNewUserClickInviteBtn_()
end

function InvitePopup:addMainUI_()
    local bg = display.newScale9Sprite("#invite_friend_bg.png", 0, 0, cc.size(WIDTH, HEIGHT), cc.rect(24, 140, 1, 1))
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)
    self.bg_ = bg

    cc.ui.UIPushButton.new({normal = "#invite_friend_close_btn_normal.png", pressed = "#invite_friend_close_btn_pressed.png"}, {scale9=true})
        :onButtonClicked(buttontHandler(self, self.onCloseClicked_))
        :pos(5, HEIGHT - 15)
        :addTo(bg)

    local btn_w, btn_h = 290, 68
    local btn_x, btn_y = 180, HEIGHT - 55
    self.allSelectedBtn_ = cc.ui.UIPushButton.new({normal = "#invite_friend_btn_normal.png", pressed = "#invite_friend_btn_pressed.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "SELECT_ALL"), size = 30}))
        :onButtonClicked(buttontHandler(self, self.onSelectAllClicked_))
        :setDelayTouchEnabled(false)
        :pos(btn_x, btn_y)
        :addTo(bg)

    local x, y = -110, 0
    display.newSprite("#invite_friend_selectall_checkbox_bg.png")
        :pos(x, y)
        :addTo(self.allSelectedBtn_)

    self.selectedIcon_ = display.newSprite("#invite_friend_selectall_checkbox_selected.png")
        :pos(x, y)
        :addTo(self.allSelectedBtn_)
        :hide()

    self:addSearchNode_()

    cc.ui.UIPushButton.new({normal = "#invite_friend_btn_normal.png", pressed = "#invite_friend_btn_pressed.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "SEND_INVITE"), size = 30}))
        :onButtonClicked(buttontHandler(self, self.onInviteClicked_))
        :pos(WIDTH - btn_x, btn_y)
        :addTo(bg)

    self:addMiddleNode_()
end

function InvitePopup:addSearchNode_()
    local input_w, input_h = 425, 54
    local input_x, input_y = WIDTH/2 + 25, HEIGHT - 55
    local bg = self.bg_
    display.newSprite("#invite_friend_fb_icon.png")
        :align(display.RIGHT_CENTER, input_x - input_w/2 - 5, input_y)
        :addTo(bg)

    display.newScale9Sprite("#invite_friend_search_frame.png", 0, 0, cc.size(input_w, input_h), cc.rect(30, 17, 1, 1))
        :pos(input_x, input_y)
        :addTo(bg)

    local editBox = ui.newEditBox({
        size = cc.size(input_w, input_h),
        image="#common/transparent.png",
        x = input_x,
        y = input_y,
        listener = handler(self, self.onEditBoxChange_)
    })
    editBox:setFontName(ui.DEFAULT_TTF_FONT)
    editBox:setFontSize(26)
    editBox:setFontColor(TEXT_CORLOR_1)
    editBox:setPlaceholderFontName(ui.DEFAULT_TTF_FONT)
    editBox:setPlaceholderFontSize(26)
    editBox:setPlaceholderFontColor(TEXT_CORLOR_1)
    editBox:setPlaceHolder(sa.LangUtil.getText("FRIEND", "SEARCH_FRIEND"))
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_GO)
    editBox:addTo(bg)
end

function InvitePopup:addMiddleNode_()
    local x = frame_w/2

    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.BOTTOM_CENTER, WIDTH/2, 10)
        :addTo(self.bg_)
    self.frame_ = frame

    -- 选中好友人数提示和奖励提示
    local fontSize = 28
    self.inviteTip_ = RichText.new()
        :addElementText({color = TEXT_CORLOR_1, text = sa.LangUtil.getText("FRIEND","INVITE_SELECT_TIP_1"), fontSize = fontSize})
        :addChangeElementText({color = TEXT_CORLOR_2, text = "0", fontSize = fontSize})
        :addElementText({color = TEXT_CORLOR_1, text = sa.LangUtil.getText("FRIEND","INVITE_SELECT_TIP_2"), fontSize = fontSize})
        :addChangeElementText({color = TEXT_CORLOR_3, text = "0", fontSize = fontSize})
        :addElementText({color = TEXT_CORLOR_1, text = sa.LangUtil.getText("FRIEND","INVITE_SELECT_TIP_3"), fontSize = fontSize})
        :pos(x, frame_h - 30)
        :addTo(frame)

    if self.isShowFBTips_ == 1 then
        fontSize = 24
        local chipStr = sa.LangUtil.getText("STORE","FORMAT_CHIP", "") 
        RichText.new()
            :addElementText({color = TEXT_CORLOR_1, text = sa.LangUtil.getText("FRIEND","INVITE_REWARD_TIPS_1"), fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_2, text = "1", fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_1, text = sa.LangUtil.getText("FRIEND","INVITE_REWARD_TIPS_2"), fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_3, text = INVITE_SEND_CHIPS, fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_1, text = chipStr .. sa.LangUtil.getText("FRIEND","INVITE_REWARD_TIPS_3"), fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_3, text = sa.formatBigNumber(tx.userData.inviteSuccessReward), fontSize = fontSize})
            :addElementText({color = TEXT_CORLOR_1, text = chipStr, fontSize = fontSize})
            :pos(x, 25)
            :addTo(frame)
    else
        self.inviteTip_:hide()
    end
end

function InvitePopup:setSelectedAll()
    self:onSelectAllClicked_()
end

-- 设置好友 「全部选择」「取消」的状态
function InvitePopup:setSelectedAll_()
    -- local selectedAllStr
    -- if INVITE_NUM == 0 then
    --     selectedAllStr = bm.LangUtil.getText("FRIEND", "SELECT_ALL")
    -- else
    --     selectedAllStr = bm.LangUtil.getText("FRIEND", "SELECT_NUM", MAX_SELECT_NUM)
    -- end

    if not self.userItems_ or #self.userItems_ == 0 then
        self.selectedIcon_:hide()
        self.allSelectedBtn_:setButtonLabelString("normal", sa.LangUtil.getText("FRIEND", "SELECT_ALL"))
        return
    end

    local selectedNum = self:getSelectedItemNum()
    if selectedNum >= MAX_SELECT_NUM or selectedNum == #self.userItems_ then
        self.selectedIcon_:show()
        self.allSelectedBtn_:setButtonLabelString("normal", sa.LangUtil.getText("FRIEND", "DESELECT_ALL"))
    else
        self.selectedIcon_:hide()
        self.allSelectedBtn_:setButtonLabelString("normal", sa.LangUtil.getText("FRIEND", "SELECT_ALL"))
    end
end

function InvitePopup:onCloseClicked_()
    self:hidePanel()
end

-- 全选/取消权限 按钮点击事件
function InvitePopup:onSelectAllClicked_()
    if not self.userItems_ or #self.userItems_ == 0 then
        self:setSelectedAll_()
        return
    end

    local selectedNum = self:getSelectedItemNum()
    if selectedNum >= MAX_SELECT_NUM or selectedNum == #self.userItems_ then
        for _, item in ipairs(self.userItems_) do
            item:setSelected(false)
        end
    else
        for _, item in ipairs(self.userItems_) do
            if not item:isSelected() then
                selectedNum = selectedNum + 1
                item:setSelected(true)
                if selectedNum >= MAX_SELECT_NUM then
                    break
                end
            end
        end
    end

    self:setSelecteTip()
end

function InvitePopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
        self.searchStr_ = editbox:getText()
    elseif event == "return" then
        self:filterData()
    end
end

function InvitePopup:filterData()
    if self.scrollView_ then
        self.scrollView_:hide()
    end

    self:setNoDataTip(false)

    if self.searchStr_ and self.searchStr_ ~= nil then
        self:onGetData_(true, friendDataGlobal, self.searchStr_)
    end

    self:setSelecteTip()
end

-- 上报新用户facebook邀请点击量
function InvitePopup:reportNewUserClickInviteBtn_()
    if device.platform == "android" or device.platform == "ios" then
        if tx.userData.registerReward.code == 1 then
            cc.analytics:doCommand{
                command = "event",
                args = {eventId = "new_user_fb_invite_click", label = "new_user_fb_invite_click"}
            }
        end
    end
end

function InvitePopup:onGetData_(success, friendData, filterStr)
    if type(friendData) == "string" then --当在加载FB登录界面点击关闭返回 "canceled" or "failed"
        tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "INVITE_FAIL_SESSION"))
        tx.PopupManager:removePopup(self)
        return
    end

    self:setVisible(true)
    friendDataGlobal = clone(friendData)

    self:setLoading(false)
    if success then
        self.pageNum_ = checkint(tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_INVITED_PAGE, 0))
        
        friendData = self.controller_:filterAllData(friendData)

        if filterStr and filterStr ~= "" then
            print("string.lower(filterStr):" .. string.lower(filterStr))
            local tmpData = {}
            for k, v in pairs(friendData) do
                if (string.find(string.lower(v.name),string.lower(filterStr)) ~= nil) then
                    table.insert(tmpData,v)
                end
            end
            friendData = tmpData
        end

        friendData = self:sortFreind_(friendData)

        self.maxData_ = #friendData
        if self.maxData_ == 0 then
            self:setNoDataTip(true)
            self.userItems_ = {}
            return
        end

        local dir_w, dir_h = InviteListItem.ITEM_WIDTH + 25, InviteListItem.ITEM_HEIGHT + 5
        local nodeHeight = math.ceil(self.maxData_ / 2) * 125
        local list_w, list_h = frame_w, 550
        if self.scrollView_ then
            self.scrollView_:removeFromParent()
        end
        self.inviteUserNode_ = display.newNode():size(frame_w, nodeHeight)
        self.scrollView_ = sa.ui.ScrollView.new({
                viewRect      = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h),
                scrollContent = self.inviteUserNode_,
            })
            :pos(frame_w/2, frame_h/2)
            :addTo(self.frame_)

        self.userItems_ = {}

        local minNum = self.maxData_
        if self.isFirstShow_ then
            if self.maxData_ > 20 then
                minNum = 20
            end
        end
        
        local start_x = -frame_w/2 + 32
        for i = 1, minNum do
            friendData[i].chips = INVITE_SEND_CHIPS
            friendData[i].sex =  "f"
            self.userItems_[i] = InviteListItem.new(friendData[i], self.scrollView_, self, i)
                :align(display.LEFT_CENTER, start_x + (i + 1) % 2 * dir_w, nodeHeight/2 - dir_h/2 - math.floor((i - 1) / 2) * dir_h)
                :addTo(self.inviteUserNode_)
        end

        if self.isFirstShow_ then
            tx.schedulerPool:delayCall(function()
                for i = minNum + 1, self.maxData_ do
                    friendData[i].chips = INVITE_SEND_CHIPS
                    friendData[i].sex =  "f"
                    self.userItems_[i] = InviteListItem.new(friendData[i], self.scrollView_, self, i)
                        :align(display.LEFT_CENTER, start_x + (i + 1) % 2 * dir_w, nodeHeight/2 - dir_h/2 - math.floor((i - 1) / 2) * dir_h)
                        :addTo(self.inviteUserNode_)
                end

                self.isFirstShow_ = false

                -- self:setSelectedAll()

                self.scrollView_:setScrollContentTouchRect()
                self.scrollView_:update()
            end, 0.1)
        end

        local outterSelf = self
        local innerSelf = self.scrollView_
        self.scrollView_.onScrolling = function()
            if innerSelf.viewRectOriginPoint_ and #outterSelf.userItems_ > 0 then
                for _, item in ipairs(outterSelf.userItems_) do
                    local tempWorldPt = outterSelf.inviteUserNode_:convertToWorldSpace(cc.p(item:getPosition()))
                    if tempWorldPt.y > innerSelf.viewRectOriginPoint_.y + innerSelf.viewRect_.height + item.ITEM_HEIGHT or tempWorldPt.y < innerSelf.viewRectOriginPoint_.y - item.ITEM_HEIGHT - item.ITEM_HEIGHT then
                        item:hide()
                        if item.onItemDeactived then
                            if tempWorldPt.y - (innerSelf.viewRectOriginPoint_.y + innerSelf.viewRect_.height) > innerSelf.viewRect_.height or innerSelf.viewRectOriginPoint_.y - item.ITEM_HEIGHT - tempWorldPt.y > innerSelf.viewRect_.height then
                                item:onItemDeactived()
                            end
                        end
                    else
                        item:show()
                        if item.lazyCreateContent then
                            item:lazyCreateContent()
                        end
                    end
                end
            end
        end
        
        self.scrollView_:setScrollContentTouchRect()
        self.scrollView_:update()
    else
        self:setNoDataTip(true)
    end
end

--- 排序好友列表
function InvitePopup:sortFreind_(friendData)
    local count = #friendData
    math.newrandomseed()
    if tx.config.INVITE_SORT_TYPE == 2 and count > 50 then
        for i=1, count do
            local j,k = math.random(count), math.random(count)
            friendData[j],friendData[k] = friendData[k],friendData[j]
        end

        local pageStartIdx = (self.pageNum_ - 1) * 50 + 1
        local pageSizeCount = 50
        if count < pageStartIdx + 50 then
            pageSizeCount = count - pageStartIdx + 1
        end
        local friendDataTmp = {}
        local k,j = 1,1
        for i=1, count do
            if i < pageStartIdx or i >= pageStartIdx + pageSizeCount then
                friendDataTmp[j] = friendData[i]
                j = j + 1
            else
                friendDataTmp[count - pageSizeCount + k] =  friendData[i]
                k = k + 1
            end
        end
        friendData = friendDataTmp
    elseif tx.config.INVITE_SORT_TYPE == 1 then
        for i=1, count do
            local j,k = math.random(count), math.random(count)
            friendData[j],friendData[k] = friendData[k],friendData[j]
        end
    end

    return friendData
end

-- 获取选择了多少个好友
function InvitePopup:getSelectedItemNum()
    local selectedNum = 0
    if self.userItems_ then
        for _, item in ipairs(self.userItems_) do
            if item:isSelected() then
                selectedNum = selectedNum + 1
            end
        end
    end
    return selectedNum
end

function InvitePopup:setSelecteTip()
    local selectedNum = 0
    for _, item in ipairs(self.userItems_) do
        if item:isSelected() then
            selectedNum = selectedNum + 1
        end
    end

    local totalReward = selectedNum * INVITE_SEND_CHIPS
    if self.isShowFBTips_ == 1 then
        self.inviteTip_:updateChangeElementText({selectedNum, totalReward})

        if self.isFirstShow_ then
            self.inviteTip_:hide()
        else
            self.inviteTip_:show()
        end
    else
        self.inviteTip_:hide()
    end

    self:setSelectedAll_()
end

-- 获取当前已经邀请的好友数量
function InvitePopup:getTodayInviteCount()
    local k1 = tx.cookieKeys.FB_LAST_INVITE_DAY
    -- 今日已邀请数量
    local saved_day = tx.userDefault:getStringForKey(k1, '')
    if saved_day == os.date('%Y%m%d') then
        local k2 = tx.cookieKeys.FB_INVITE_FRIENDS_NUMBER
        return tx.userDefault:getIntegerForKey(k2, 0)
    else
        return 0
    end
end

function InvitePopup:onInviteClicked_()
    if not self.userItems_ then return end

    local selectedNum = self:getSelectedItemNum()
    local remainCount = MAX_SELECT_NUM

    if remainCount < selectedNum then
        local txt = sa.LangUtil.getText("FRIEND", "INVITE_LEFT_TIP")
        local fmt_txt = sa.LangUtil.formatString(txt, remainCount)
        tx.TopTipManager:showToast(fmt_txt)

        return
    elseif selectedNum == 0 then
        tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "INVITE_EMPTY_TIP"))
    elseif remainCount >= selectedNum then
        self:sendInvites_()
    end 
end

function InvitePopup:isCanSelected()
    local selectedNum = self:getSelectedItemNum()
    if selectedNum >= MAX_SELECT_NUM then
        local txt = sa.LangUtil.getText("FRIEND", "INVITE_LEFT_TIP")
        local fmt_txt = sa.LangUtil.formatString(txt, MAX_SELECT_NUM)
        tx.TopTipManager:showToast(fmt_txt)

        return false
    end

    return true
end

function InvitePopup:sendInvites_()
    tx.schedulerPool:delayCall(function()
        tx.PopupManager:removePopup(self)
    end, 0.2)

    -- 发送邀请
    if toIds ~= "" then
        self.controller_:sendInvites(self.userItems_)
    end
end

function InvitePopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, LIST_POS_Y)
                :addTo(self, 9, 9)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function InvitePopup:setNoDataTip(noData)
    if noData then
        if not self.noDataTip_ then
            self.noDataTip_ = ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "NO_FRIEND_TIP"), color = styles.FONT_COLOR.GREY_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, LIST_POS_Y)
                :addTo(self, 8)
        end
    else
        if self.noDataTip_ then
            self.noDataTip_:removeFromParent()
            self.noDataTip_ = nil
        end
    end
end

function InvitePopup:getTodayInvitedMoney_()
    local invitedMoney = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_TODAY_INVITE_MONEY, "")
    local today = os.date("%Y%m%d")
    local money = 0

    if invitedMoney == "" or string.sub(invitedMoney, 1, 8) ~= today then
        money = 0
    else
        local reward = string.split(invitedMoney, "#") 
        money = tonumber(reward[2])
    end

    return money
end

function InvitePopup:showPanel()
    if MAX_SELECT_NUM <= 0 then --达到当天邀请上限，不显示弹窗
        tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "INVITE_FULL_TIP"))
        return
    end

    tx.PopupManager:addPopup(self)

    self.controller_:getInvitableFriends()
end

function InvitePopup:hidePanel()
    tx.PopupManager:removePopup(self) 
end

function InvitePopup:onShowed()
    if self.scrollView_ then
        self.scrollView_:setScrollContentTouchRect()
        self.scrollView_:update()
    end
end

function InvitePopup:onExit()
    display.removeSpriteFramesWithFile("invite_texture.plist", "invite_texture.png")

    tx.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return InvitePopup