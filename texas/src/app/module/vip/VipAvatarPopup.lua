--头像设置弹窗
local VipAvatarPopup = class("VipAvatarPopup", tx.ui.Panel)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local WIDTH, HEIGHT = 1020, 660
local VIP_PAGE_NUM = 10
local NORMAL_PAGE_NUM = 4

local userData

-------------------------------------------------------Item Class-------------------------------------------------------
local VipAvatarItem = class("VipAvatarItem", sa.ui.ListItem)
VipAvatarItem.WIDTH = 120
VipAvatarItem.HEIGHT = 120
local curSelectedVipAvatarItem = nil  -- 当前选中
function VipAvatarItem:ctor()
    VipAvatarItem.super.ctor(self,VipAvatarItem.WIDTH,VipAvatarItem.HEIGHT)
end
function VipAvatarItem:onDataSet(dataChanged,data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end
function VipAvatarItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self.dataChanged_ = true
        self.avatar_ = SimpleAvatar.new({shapeImg = "#common/vip_avatar_bg.png", frameImg = "#common/vip_avatar_frame_normal.png"})
            :pos(0,0)
            :addTo(self)
        self.selectFrame_ = display.newSprite("#common/vip_avatar_frame_selected.png")
            :pos(0,0)
            :addTo(self)
            :hide()
        ColorButton(self.avatar_):onButtonClicked(buttontHandler(self, function(obj,evt)
            if curSelectedVipAvatarItem~=self then
                self:setSelected(true)
            end
        end))
        self.avatar_:setTouchSwallowEnabled(false)
    end
    if self.data_ and self.dataChanged_ then
        self.dataChanged_ = false
        self.selectFrame_:hide()
        local imgUrl = self.data_.imgUrl
        self.avatar_:loadImage(imgUrl)
        if self.data_.select==true then
            self.data_.select = nil
            self:setSelected(true)
        end
    end
end
function VipAvatarItem:setSelected(value,evt)
    local owner = self:getOwner()
    if value then
        if curSelectedVipAvatarItem~=self then
            if curSelectedVipAvatarItem and curSelectedVipAvatarItem.setSelected then
                curSelectedVipAvatarItem:setSelected(false)
            end
            curSelectedVipAvatarItem = self
            self.selectFrame_:show()
            if owner.onItemClick then
                owner.onItemClick(self)
            end
            self.data_.select = true -- 下次能再次默认选中
        end
    else
        self.data_.select = nil
        self.selectFrame_:hide()
    end
end
-------------------------------------------------------Item Class-------------------------------------------------------

function VipAvatarPopup:ctor(controller, isInRoom, isRedblack)
    self.this_ = self
    VipAvatarPopup.super.ctor(self, {WIDTH, HEIGHT})

    userData = tx.userData

    self.controller_ = controller

    self.isInRoom_ = isInRoom

	self.isRedblack = isRedblack

    self:addCloseBtn()

    self:setLoadingPosition(150, 0)

    self:addSelfAvatarNode_()

    self:getUserIconList_()

    self:addPropertyObservers_()
end

function VipAvatarPopup:addAvatarViews_(vipAvatars, normalAvatars)
    for k,v in pairs(vipAvatars) do
        v.select = nil
    end
    for k,v in pairs(normalAvatars) do
        v.select = nil
    end
	self.selectedAvatarUrl_ = userData.s_picture

	self:addVipAvatarNode_(vipAvatars)
	if userData.canEditAvatar then
		self:addNormalAvatarNode_(normalAvatars)
	end

    local defaultSelect = nil
	if string.len(self.selectedAvatarUrl_) <= 5 then
		if self.selectedGender_ == "f" then
            defaultSelect = self.normalAvatarList_ and self.normalAvatarList_:getListItems()[1] and (self.normalAvatarList_:getListItems()[1]):getItemList()[1]
		else
			defaultSelect = self.normalAvatarList_ and self.normalAvatarList_:getListItems()[1] and (self.normalAvatarList_:getListItems()[1]):getItemList()[2]
		end
	else
        local isFindHead = false
        if not isFindHead then
            for k,v in pairs(normalAvatars) do
                if v.imgUrl==self.selectedAvatarUrl_ then
                    local curPage = math.ceil(k/NORMAL_PAGE_NUM)
                    local curItem = math.ceil(k%NORMAL_PAGE_NUM)
                    if curItem==0 then curItem=NORMAL_PAGE_NUM end
                    defaultSelect = self.normalAvatarList_ and self.normalAvatarList_:getListItems()[curPage] and (self.normalAvatarList_:getListItems()[curPage]):getItemList()[curItem]
                    break;
                end
            end
        end
        if not isFindHead then
            for k,v in pairs(vipAvatars) do
                if v.imgUrl==self.selectedAvatarUrl_ then
                    local curPage = math.ceil(k/VIP_PAGE_NUM)
                    local curItem = math.ceil(k%VIP_PAGE_NUM)
                    if curItem==0 then curItem=VIP_PAGE_NUM end
                    defaultSelect = self.vipAvatarList_ and self.vipAvatarList_:getListItems()[curPage] and (self.vipAvatarList_:getListItems()[curPage]):getItemList()[curItem]
                    break;
                end
            end
        end
	end

    if defaultSelect and defaultSelect.setSelected then
        defaultSelect:setSelected(true)
    end
end

--自己头像节点
function VipAvatarPopup:addSelfAvatarNode_()
	local bg = self.background_
	local x, y = 180, 524
   	self.avatarIcon_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :pos(x, y)
        :addTo(bg)

    -- 昵称标签
    local nick_x, nick_y = 96, y - 160
    self.selectedGender_ = userData.sex
   	self.genderIcon_ = display.newSprite("#common/common_sex_male.png")
        :pos(70, nick_y)
        :addTo(bg)

    if self.selectedGender_ == "f" then
        self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
    end
    
    self.nickLabel_ = ui.newTTFLabel({text = "", size = 26})
        :align(display.LEFT_CENTER, nick_x, nick_y)
        :addTo(bg)

    if userData.canEditAvatar then
        sa.TouchHelper.new(self.genderIcon_, handler(self, self.onGenderIconClick_))

        local w = 210
        local nickEdit = ui.newEditBox({image = "#common/transparent.png", listener = handler(self, self.onNickEdit_), size = cc.size(w, 40)})
            :align(display.LEFT_CENTER, nick_x, nick_y)
            :addTo(bg)
        nickEdit:setFont(ui.DEFAULT_TTF_FONT, 26)
        nickEdit:setPlaceholderFont(ui.DEFAULT_TTF_FONT, 26)
        nickEdit:setMaxLength(25)
        nickEdit:setPlaceholderFontColor(cc.c3b(0xee, 0xee, 0xee))
        nickEdit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        nickEdit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        nickEdit:setCascadeOpacityEnabled(true)
        nickEdit:setOpacity(0)

        display.newSprite("#common/btn_editbox_normal.png")
            :pos(nick_x + w, nick_y)
            :addTo(bg)
    elseif userData.canEditGender then
        sa.TouchHelper.new(self.genderIcon_, handler(self, self.onGenderIconClick_))
    end

   	local level = userData.vipinfo.level
    if level > 0 then
    	display.newSprite("#common/vip_level_icon_" .. level .. ".png")
            :pos(80, y - 80)
            :addTo(bg)
    else
    	cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
	        :setButtonSize(250, 104)
	        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "OPEN_VIP"), size = 26}))
	        :pos(x, 285)
	        :onButtonClicked(buttontHandler(self, self.onOpenVIPClicked_))
	        :addTo(bg)
    end

    display.newScale9Sprite("#common/vip_avatar_line.png", 0, 0, cc.size(2, HEIGHT - 98))
    	:pos(330, HEIGHT*0.5)
    	:addTo(bg)
end
function VipAvatarPopup:onShowed()
    if self.vipAvatarList_ then
        self.vipAvatarList_:setScrollContentTouchRect()
    end
    if self.normalAvatarList_ then
        self.normalAvatarList_:setScrollContentTouchRect()
    end
end
--VIP头像节点
function VipAvatarPopup:addVipAvatarNode_(avatarList)
	local bg = self.background_
	local x, y = WIDTH - 360, HEIGHT - 65
	local frame = display.newScale9Sprite("#common/vip_avatar_title_frame.png", 0, 0, cc.size(282, 38), cc.rect(23, 19, 1, 1))
		:pos(x, y)
		:addTo(bg)

	ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "VIP_AVATAR"), size = 26})
		:pos(x, y)
		:addTo(bg)
    -- Vip翻页
    if not self.vipAvatarList_ then
        local PAGE_WIDTH,PAGE_HEIGHT = 640,284
        local rows,columns = 2,5
        local pageParam = {btnNormal="#common/page_btn_normal.png",btnSelect="#common/page_btn_select.png"}
        self.vipAvatarList_ = sa.ui.PageView.new(
                {
                    viewRect = cc.rect(-PAGE_WIDTH*0.5,-PAGE_HEIGHT*0.5,PAGE_WIDTH,PAGE_HEIGHT),
                    direction = sa.ui.ScrollView.DIRECTION_HORIZONTAL,
                    rows = rows,
                    columns = columns,
                    rowsPadding = 5,
                    columnsPadding = 8,
                    speed = PAGE_WIDTH*0.8 -- 速度
                },
                VipAvatarItem,
                pageParam
            )
            :pos(150,90)
            :addTo(self)
    end
    self.vipAvatarList_.onItemClick = handler(self,self.onAvatarChange_)
    self.vipAvatarList_:setData(avatarList)
    self.vipAvatarList_:update()
    if #avatarList<=VIP_PAGE_NUM then
        self.vipAvatarList_.touchNode_:setTouchEnabled(false)
    end
end

--普通头像节点
function VipAvatarPopup:addNormalAvatarNode_(avatarList)
	local bg = self.background_
	local x, y = WIDTH - 360, 235
	local frame = display.newScale9Sprite("#common/vip_avatar_title_frame.png", 0, 0, cc.size(282, 38), cc.rect(23, 19, 1, 1))
		:pos(x, y)
		:addTo(bg)

	ui.newTTFLabel({text = sa.LangUtil.getText("VIP", "NOR_AVATAR"), size = 26})
		:pos(x, y)
		:addTo(bg)

    -- Common翻页
    if not self.normalAvatarList_ then
        local PAGE_WIDTH,PAGE_HEIGHT = 512,160
        local rows,columns = 1,4
        local pageParam = {btnNormal="#common/page_btn_normal.png",btnSelect="#common/page_btn_select.png"}
        self.normalAvatarList_ = sa.ui.PageView.new(
                {
                    viewRect = cc.rect(-PAGE_WIDTH*0.5,-PAGE_HEIGHT*0.5,PAGE_WIDTH,PAGE_HEIGHT),
                    direction = sa.ui.ScrollView.DIRECTION_HORIZONTAL,
                    rows = rows,
                    columns = columns,
                    rowsPadding = 5,
                    columnsPadding = 8,
                    speed = PAGE_WIDTH*0.8 -- 速度
                },
                VipAvatarItem,
                pageParam
            )
            :pos(86,-200)
            :addTo(self)
    end
    self.normalAvatarList_.onItemClick = handler(self,self.onAvatarChange_)
    self.normalAvatarList_:setData(avatarList)
    self.normalAvatarList_:update()
    if #avatarList<=NORMAL_PAGE_NUM then
        self.normalAvatarList_.touchNode_:setTouchEnabled(false)
    end

	if userData.userUploadIconUrl then
		cc.ui.UIPushButton.new("#common/vip_avatar_camera_icon.png")
	        :pos(150+512*0.5, -200)
	        :onButtonClicked(buttontHandler(self, self.onUploadPicClicked_))
	        :addTo(self)
	end
end

function VipAvatarPopup:addPropertyObservers_()
    self.nickObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "nick", function (nick)
        self.editNick_ = nick
        self:setNickString_(nick)
    end)

    self.avatarUrlObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "s_picture", function (s_picture)
        self.selectedAvatarUrl_ = s_picture
        if userData.sex == "f" then
            self.avatarIcon_:setSpriteFrame("common/icon_female.png")
        else
            self.avatarIcon_:setSpriteFrame("common/icon_male.png")
        end
        if s_picture and string.len(s_picture) > 5 then
            local imgurl = s_picture
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.avatarIcon_:loadImage(imgurl)
        end
    end)
    self.sexObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "sex", function (sex)
        if sex == "f" then
            self.selectedGender_ = "f"
            self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
        else
            self.selectedGender_ = "m"
            self.genderIcon_:setSpriteFrame("common/common_sex_male.png")
        end
    end)
end

function VipAvatarPopup:removePropertyObservers_()
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "nick", self.nickObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "s_picture", self.avatarUrlObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "sex", self.sexObserverHandle_)
end

function VipAvatarPopup:setNickString_(name)
    self.nickLabel_:show()
    self.nickLabel_:setString(tx.Native:getFixedWidthText("", 26, name or "", 190))
end

function VipAvatarPopup:onGenderIconClick_(target, evt)
    if evt == sa.TouchHelper.CLICK then
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.selectedGender_ == "f" then
            self.genderIcon_:setSpriteFrame("common/common_sex_male.png")
            self.selectedGender_ = "m"
        else
            self.genderIcon_:setSpriteFrame("common/common_sex_female.png")
            self.selectedGender_ = "f"
        end
    end
end

function VipAvatarPopup:onNickEdit_(event, editbox)
    if event == "began" then
        local text = self.nickLabel_:getString()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        editbox:setText(text)
        if device.platform == "ios" then
            self.nickLabel_:hide()
        end
    elseif event == "changed" then
    elseif event == "ended" then
    elseif event == "return" then
        local text = editbox:getText()
        local filteredText = tx.keyWordFilter(text)
        self.editNick_ = string.trim(filteredText)
        if self.editNick_ == "" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "NICK_NO_EMPTY"))
            self.editNick_ = self.nickLabel_:getString()
        end
        self:setNickString_(self.editNick_)
    end
end

function VipAvatarPopup:onOpenVIPClicked_()
	tx.PopupManager:removeAllPopup()
    tx.PayGuideManager:openStore(4)
end

function VipAvatarPopup:onAvatarChange_()
    if curSelectedVipAvatarItem then
        local data = curSelectedVipAvatarItem:getData()
        self.data_ = data
        self.avatarIcon_:loadImage(data.imgUrl)
        if data.isVip and not tx.checkIsVip() then
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("VIP", "SET_AVATAR_TIPS"),
                secondBtnText = sa.LangUtil.getText("VIP", "OPEN_VIP"),
                align = ui.TEXT_ALIGN_LEFT,
                callback = function(param)
                    if param == tx.ui.Dialog.SECOND_BTN_CLICK then
                        self:onOpenVIPClicked_()
                    end
                end
            }):show()
        else
            self.selectedAvatarUrl_ = data.imgUrl
        end
    end
end

--自己上传头像
function VipAvatarPopup:onUploadPicClicked_()
    self.controller_:uploadPicture()
end

function VipAvatarPopup:getUserIconList_()
    if tx.userData.userHeadConfig then
        local jsonData = tx.userData.userHeadConfig
        self:addAvatarViews_(jsonData.vip, jsonData.notvip)
        return
    end
	self:setLoading(true)
	sa.HttpService.POST(
    {
        mod = "Vip", 
        act = "vipUserIconList",
    }, 
    function(data)
        local jsonData = json.decode(data)
        if jsonData and type(jsonData)=="table" then
            local url = tx.userData.usericonVipDomain
            for k,v in pairs(jsonData.vip) do
                v.isVip = true
                v.imgUrl = url .. v.img
            end

            for k,v in pairs(jsonData.notvip) do
                v.isVip = nil
                v.imgUrl = url .. v.img
            end
            tx.userData.userHeadConfig = jsonData
        end
        if self.this_ then
            self:addAvatarViews_(jsonData.vip, jsonData.notvip)
            self:setLoading(false)
        end
    end,
    function ()
    end)
end

--设置游戏提供的普通头像和VIP头像
function VipAvatarPopup:updateAvatar_(isInRoom, isRedblack)
	local avatarData = self.data_
	if avatarData and type(avatarData)=="table" and avatarData.id then
		sa.HttpService.POST(
	    {
	        mod="user",
	        act="uploadIcon",
	        iconname=avatarData.img,
	        type=avatarData.type,
	        id=avatarData.id
	    },
	    function(data)
	        local jsonData = json.decode(data)
	        if jsonData and jsonData.code == 1 then
	            userData.s_picture = jsonData.data.s_picture

	            tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "SET_AVATAR_SUCCESS"))
	            if isInRoom or isRedblack then
	                tx.socket.HallSocket:sendUserInfoChanged(true)
	            end
            -- elseif jsonData.code == -6 then
            --     tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "SET_AVATAR_FAILED_2"))
	        else
	            tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "SET_AVATAR_FAILED_1"))
	        end
	    end,
	    function()
	    	tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "SET_AVATAR_FAILED_1"))
	    end)
	end
end

function VipAvatarPopup:isModifyInfo_()
	if self.selectedAvatarUrl_ and self.selectedAvatarUrl_ ~= userData.s_picture then
		self:updateAvatar_(self.isInRoom_, self.isRedblack)
	end

	if self.selectedGender_ and self.selectedGender_ ~= userData.sex then
		return true
	end

	if self.editNick_ and self.editNick_ ~= userData.nick then
		return true
	end

	return false
end

function VipAvatarPopup:onCleanup()
	self:removePropertyObservers_()

	if self:isModifyInfo_() then
        sa.HttpService.POST(
            {
                mod = "User",
                act = "modifyInfo",
                nick = self.editNick_,
                s = self.selectedGender_
            }
        )

        if self.selectedGender_ and self.selectedGender_ ~= userData.sex then
        	userData.sex = self.selectedGender_
        end

        if self.editNick_ and self.editNick_ ~= userData.nick then
            userData.nick = self.editNick_
            if self.isInRoom_ or self.isRedblack then
                tx.socket.HallSocket:sendUserInfoChanged(true)
            end
        end
    end
end

return VipAvatarPopup
