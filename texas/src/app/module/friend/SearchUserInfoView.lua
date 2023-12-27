-- 用户信息视图
local SearchUserInfoView = class("SearchUserInfoView", function ()
    return display.newNode()
end)

local AvatarIcon = import("openpoker.ui.AvatarIcon")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local WIDTH, HEIGHT = 820, 380
local NAME_COLOR = styles.FONT_COLOR.CONTENT_TEXT

-- data = {
--     img         = "https://graph.facebook.com/221116858239857/picture", --头像
--     level       = 5, --等级
--     money       = 0, --筹码
--     nick        = "สะ'ฟิล์ม ยิ้ม'มหวาน'น", --名称
--     sex         = "m", --性别
--     suid        = 11064244, --搜索ID
--     isFriend    = 0, --是否为好友关系
--     totalPoker    = 111, --牌局总数 
--     ruju     = 0.35, --入局率 
--     tanpai       = 0.25, --摊牌率 
--     winTimes      = 0.85, --赢牌率 
-- }
function SearchUserInfoView:ctor(data, controller)
	self:setNodeEventEnabled(true)

	self.data_ = data

	self.controller_ = controller

	self:addMainUI_(data)
	
    self:updateFriendStatus_()  
end

function SearchUserInfoView:addMainUI_(data)
	local frame = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER)
        :addTo(self)
    self.frame_ = frame

    -- 头像
    local avatar_x, avatar_y = 150, HEIGHT - 100

    self.avatar_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :setDefaultAvatar(data.sex)
        :pos(avatar_x, avatar_y)
        :addTo(frame)

    --头像ID
    if string.len(data.img) > 5 then
        local imgurl = data.img
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=160&height=160"
            else
                imgurl = imgurl .. "?width=160&height=160"
            end
        end
        self.avatar_:loadImage(imgurl)
    end

    ui.newTTFLabel({text = sa.LangUtil.getText("ROOM", "INFO_UID", data.suid), size = 24, color = NAME_COLOR})
        :pos(avatar_x, avatar_y - 120)
        :addTo(frame)

    self.isFriend_ = data.isFriend or 0
    local btn_w, btn_h = 220, 104
    local btn_x, btn_y = avatar_x, avatar_y - 190
    self.addFriendBtn_ = cc.ui.UIPushButton.new({normal="#common/btn_small_green.png", pressed="#common/btn_small_green_down.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("ROOM", "ADD_FRIEND"), size = 24}))
        :onButtonClicked(buttontHandler(self, self.onAddFriendClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)

    self.delFriendBtn_ = cc.ui.UIPushButton.new({normal="#common/btn_small_blue.png", pressed="#common/btn_small_blue_down.png"}, {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("ROOM", "DEL_FRIEND"), size = 24, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onDelFriendClicked_))
        :pos(btn_x, btn_y)
        :addTo(frame)
        :hide()

    --性别图标背景
    local dir = 60  
    local sy = HEIGHT - 50
    local sex_x = 300
    if data.sex == "f" then
        display.newSprite("#common/common_sex_female.png"):pos(sex_x, sy):addTo(frame)
    else
        display.newSprite("#common/common_sex_male.png"):pos(sex_x, sy):addTo(frame)
    end

    --昵称
    ui.newTTFLabel({text = tx.Native:getFixedWidthText("", 24, data.nick, 200), size = 24, color = NAME_COLOR})
        :align(display.LEFT_CENTER, sex_x + 30, sy)
        :addTo(frame)

    --line
    self:addLineInfo_(frame, sex_x + 280, sy, data.lineaccount)

    --国籍
    local country_x = 300
    sy = sy - dir
    display.newSprite("#country_" .. data.countryId .. ".png")
        :scale(0.8)
        :pos(country_x, sy)
        :addTo(frame)

    local name = tx.getCountryNameById(data.countryId)
    ui.newTTFLabel({text = name, size = 26})
        :align(display.LEFT_CENTER, country_x + 30, sy)
        :addTo(frame)

    --筹码
    local chip_x = 300
    sy = sy - dir
    display.newSprite("#common/common_chip_icon.png", chip_x, sy):addTo(frame)

    ui.newTTFLabel({text = sa.formatBigNumber(data.money), size=24, color=cc.c3b(0xff, 0xd5, 0x31)})
        :align(display.LEFT_CENTER, chip_x + 30, sy)
        :addTo(frame)

    --等级
    local level_x = chip_x + 285
    local icon = display.newSprite("#common/common_level_icon.png")
        :align(display.LEFT_CENTER, level_x, sy)
        :addTo(frame)

    ui.newTTFLabel({text = data.level, size = 24})
        :align(display.LEFT_CENTER, level_x + 55, sy)
        :addTo(frame)

    --牌局记录
    local totalPoker = data.totalPoker
    local recordData = {
        totalPoker, --牌局数
        sa.transformToPercent(data.winTimes, totalPoker), --胜率
        sa.transformToPercent(data.ruju, totalPoker), --入局率
        sa.transformToPercent(data.tanpai, totalPoker) --摊牌率
    }
    local title = {
        sa.LangUtil.getText("USERINFO", "PLAY_TOTOAL_COUNT"),
        sa.LangUtil.getText("USERINFO", "WIN_TOTAL_RATE"),
        sa.LangUtil.getText("USERINFO", "PLAY_START_RATE"),
        sa.LangUtil.getText("USERINFO", "SHOW_CARD_RATE")
    }

    local label_x = 285
    sy = sy - dir - 20
    for i = 1, 4 do
        if i % 2 == 1 then
            label_x = 285

            if i > 2 then
                sy = sy - dir
            end
        else
            label_x = label_x + 295
        end
        self:addRecordInfo_(title[i], recordData[i], label_x, sy)
    end
end

function SearchUserInfoView:addRecordInfo_(title, data, x, y)
    local label = ui.newTTFLabel({text = title, size = 24, color = NAME_COLOR})
        :align(display.LEFT_CENTER, x, y)
        :addTo(self.frame_)

    local label_w = label:getContentSize().width
    ui.newTTFLabel({text = data, size = 24})
        :align(display.LEFT_CENTER, x + label_w, y)
        :addTo(self.frame_)
end

function SearchUserInfoView:addLineInfo_(parent, x, y, lineaccount)
    local lineIcon = display.newSprite("#common/common_line_icon.png")
        :align(display.LEFT_CENTER, x, y)
        :addTo(parent)

    if lineaccount ~= "" then
        ui.newTTFLabel({text = lineaccount, size = 24, color = NAME_COLOR})
            :align(display.LEFT_CENTER, x + 55, y)
            :addTo(parent)
    else
        sa.DisplayUtil.setGray(lineIcon)
        ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "NO_CHECK_LINE"), size = 24, color = NAME_COLOR})
            :align(display.LEFT_CENTER, x + 55, y)
            :addTo(parent)
    end
end

function SearchUserInfoView:onAddFriendClicked_()
    self.addFriendBtn_:setButtonEnabled(false)
    sa.HttpService.POST(
        {
            mod="friend",
            act="setPoker",
            fuid=self.data_.suid,
            new = 1
        },
        function(data)
            local retData = json.decode(data)
            if retData then
                if retData.ret == 1 or retData.ret == 2 then
                    self.controller_:clearAllFriendData()
                    self.isFriend_ = 1
                    if retData.ret == 2 then
                        local noticed = tx.userDefault:getBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, false)
                        if not noticed then
                            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "ADD_FULL_TIPS",tx.OnOff:getConfig("maxFriendNum") or "300"))
                            tx.userDefault:setBoolForKey(tx.cookieKeys.FRIENDS_FULL_TIPS .. tx.userData.uid, true)
                        end
                    else
                        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_SUCC_MSG"))
                    end
                else
                    tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                end
            end
            self:updateFriendStatus_()
        end,
        function()
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
            self:updateFriendStatus_()
        end)
end

function SearchUserInfoView:onDelFriendClicked_()
    self.addFriendBtn_:setButtonEnabled(false)
    sa.HttpService.POST(
        {
            mod="friend",
            act="delPoker",
            fuid=self.data_.suid
        },
        function(data)
            if data == "1" then
                self.controller_:clearAllFriendData()
                self.isFriend_ = 0
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
            end
            self:updateFriendStatus_()
        end,
        function()
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "DELE_FRIEND_FAIL_MSG"))
            self:updateFriendStatus_()
        end)
end

function SearchUserInfoView:updateFriendStatus_()
    if self.isFriend_ == 0 then
        self.addFriendBtn_:show()
        self.delFriendBtn_:hide()
    else
        self.addFriendBtn_:hide()
        self.delFriendBtn_:show()
    end
end

function SearchUserInfoView:onExit()

end

return SearchUserInfoView