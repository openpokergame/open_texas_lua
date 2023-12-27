local ChooseLevelItem = import(".hall.ChooseLevelItem")
local KeyboardPopup = import("app.module.keyboard.KeyboardPopup")
local GameHallScene = import("app.scenes.GameHallScene")
local P = import(".net.PROTOCOL")

local TexasHallScene = class("TexasHallScene", GameHallScene)
TexasHallScene.ELEMENTS = {
	"bg",
	"bg.left",
	"bg.right",
	"nodeList",
	"nodeTop.bg",
	"nodeTop.light",
	"nodeTop.primary",
	"nodeTop.intermediate",
	"nodeTop.senior",
	"nodeTop.btnBack",
	"nodeTop.btnShop",
	"nodeTop.btnSearch",
	"nodeTop.chipBg.labelChip",
	"nodeBottom.btnQuickPlay.label",
	"nodeBottom.btnPrivate",
	"nodeBottom.typeBg",
	"nodeBottom.numBg",
}
TexasHallScene.LIST_LAST_POS = 0 --上次列表滚动的位置
local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
	{"c_9", "c_6"},--普通场
	{"q_9", "q_6"},--快速场
}

local GROUP_IMG = {
	{"#lang/texas_hall_primary_off.png","#lang/texas_hall_primary_off.png","#lang/texas_hall_primary_on.png"},
	{"#lang/texas_hall_intermediate_off.png","#lang/texas_hall_intermediate_off.png","#lang/texas_hall_intermediate_on.png"},
	-- {"#lang/texas_hall_senior_off.png","#lang/texas_hall_senior_off.png","#lang/texas_hall_senior_on.png"}
}
local QUICK_PLAY_POS = {
	zh = {x = 0, y = 0},
	tw = {x = 0, y = 0},
	en = {x = 5, y = 0},
	id = {x = -35, y = 0},
	ru = {x = -40, y = 5},
	th = {x = -5, y = 0},
}

function TexasHallScene:ctor(idx)
	self.this_ = self
	TexasHallScene.super.ctor(self,P.GAMEID)
	tx.ui.EditPanel.bindElementsToTarget(self,"texas_hall.csb",true)
		:pos(display.cx,display.cy)

	self.nodeTop.senior:hide()
	local btnList = {
		self.nodeTop.primary,
		self.nodeTop.intermediate,
		-- self.nodeTop.senior,
	}
	self.titleGroup_ = tx.ui.CheckBoxButtonGroup.new()
	for i, v in ipairs(GROUP_IMG) do
		local btn = ChkBoxButton(ImgButton(btnList[i], v[1], v[2], v[3]))
			:onButtonPressed(handler(self, self.onMainTabPressed_))
			:onButtonRelease(handler(self, self.onMainTabRelease_))
		btn:setTag(i)

		self.titleGroup_:addButton(btn)
	end
	self.titleGroup_:onButtonSelectChanged(handler(self, self.onMainTabChanged_))
	self.nodeTop.light:hide()

	self.bg:setScale(tx.bgScale)
	local size = self.nodeTop.bg:getContentSize()
	self.nodeTop.bg:setContentSize(cc.size(display.width,size.height))
	self.nodeTop:setPositionY(display.cy)

	self.nodeBottom:setPositionY(-display.cy)
	self.nodeTop.btnBack:setPositionX(-display.cx+50)
	ImgButton(self.nodeTop.btnBack,"#common/btn_scene_back.png","#common/btn_scene_back_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		self:doBackToHall()
	end)

	self.nodeTop.btnShop:setPositionX(display.cx-50)
	ImgButton(self.nodeTop.btnShop,"#common/btn_scene_shop.png","#common/btn_scene_shop_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		tx.PayGuideManager:quickPayGuide()
	end)

	local rx = 160
	self.nodeTop.btnSearch:setPositionX(display.cx-rx)
	ImgButton(self.nodeTop.btnSearch,"#common/btn_scene_search.png","#common/btn_scene_search_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		--获取按钮世界坐标
		local tempWorldPt = self.nodeTop:convertToWorldSpace(cc.p(self.nodeTop.btnSearch:getPosition()))
		KeyboardPopup.new(tempWorldPt)
			:align(display.TOP_RIGHT, display.width, display.height - 100)
			:showPanel()
	end)

	ScaleButton(self.nodeBottom.btnQuickPlay, 0.95):onButtonClicked(function()
      	tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
      	if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand{
                command = "event",
                args = {eventId = "play_now_enter_room", label = "in_choose_hall_scene"}
            }
        end
      	self:quickStart()
 	end)
 	local p = QUICK_PLAY_POS[appconfig.LANG] or {x = 0, y = 0}
 	self.nodeBottom.btnQuickPlay.label:pos(178 + p.x, 75 + p.y)

	self.nodeBottom.btnPrivate:setPositionX(display.cx - 75)
	ImgButton(self.nodeBottom.btnPrivate,"#texas/hall/btn_private.png","#texas/hall/btn_private_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		local PrivateScene = require("app.module.privateroom.PrivateScene")
    	PrivateScene.new(2):showPanel()
	end)

	self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(tx.userData.money))

	local tabBgX = -display.cx+145
	self.nodeBottom.typeBg:setPositionX(tabBgX)
	local size = self.nodeBottom.typeBg:getContentSize()
	local text = sa.LangUtil.getText("HALL", "CHOOSE_ROOM_TYPE")
	self.typeTab_ = tx.ui.TabBarWithIndicator.new(
		{
			background = "#common/transparent.png", 
			indicator = "#texas/hall/tab_item.png"
		},
		text,
		{
			selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
			defaltText = {color = cc.c3b(0x2c, 0x48, 0x9b), size = 22}
		},
		true, true)
		:setTabBarSize(size.width, size.height, 0, -2)
		:onTabChange(handler(self, self.onTypeTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.nodeBottom.typeBg)
	self.typeTab_:setButtonIcons({{downRes="common/transparent.png",upRes="common/transparent.png"},{downRes="common/icon_fast_on.png",upRes="common/icon_fast_off.png"}},0-size.width*0.25+15,0)

	-- self.fastAnimation_ = sp.SkeletonAnimation:create("spine/kuaisuxuanchang.json","spine/kuaisuxuanchang.atlas")
	-- 	:pos(11, -2)
 --        :addTo(self.typeTab_)
 --        :hide()
 --    self.fastAnimation_:setAnimation(0, 3, true)

	self.nodeBottom.numBg:setPositionX(tabBgX + 324)
	local size = self.nodeBottom.numBg:getContentSize()
	local text = {
		"   9",
		"   6",
	}

	self.numTab_ = tx.ui.TabBarWithIndicator.new(
		{
			background = "#common/transparent.png", 
			indicator = "#texas/hall/tab_item.png"
		},
		text,
		{
			selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 30},
			defaltText = {color = cc.c3b(0x2c, 0x48, 0x9b), size = 30}
		},
		true, true)
		:setTabBarSize(size.width, size.height, 0, -2)
		:onTabChange(handler(self, self.onNumTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.nodeBottom.numBg)
	self.numTab_:setButtonIcons({{downRes="texas/hall/peaple_white.png",upRes="texas/hall/peaple_purple.png"},{downRes="texas/hall/peaple_white.png",upRes="texas/hall/peaple_purple.png"}},0-20,0)

	self.numBgOriginalX_ = self.nodeBottom.numBg:getPositionX()
	self.typeBgOriginalX_ = self.nodeBottom.typeBg:getPositionX()

	local list_w,list_h = display.width-40, 512
	ChooseLevelItem.WIDTH = list_w/3.5
	self.roomList_ = sa.ui.ListView.new(
		{
			viewRect = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h),
			direction=sa.ui.ListView.DIRECTION_HORIZONTAL
		},
		ChooseLevelItem
		)
		:hideScrollBar()
		:addTo(self.nodeList)
	self.roomList_.onItemClickListener = handler(self, self.onItemClick_)

	self.levelType_ = tx.userDefault:getIntegerForKey(tx.cookieKeys.TEXAS_ROOM_TYPE, 1)
	if idx then
		self.levelType_ = idx
	end

	if self.levelType_ > 2 then
		self.levelType_ = 2
	end

	self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, function(obj, userMoney)
        self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(userMoney))
    end))

	self:initNumAndTypeTab_()
	self:updateShopIcon_()
	self:getTableConfig_()
end

function TexasHallScene:onMainTabChanged_(evt)
	local selected = evt.selected
	local img = "img/bg_texas_hall_" .. selected .. ".jpg"
	local sprite = display.newSprite(img)
	self.bg.left:setSpriteFrame(sprite:getSpriteFrame())
	self.bg.right:setSpriteFrame(sprite:getSpriteFrame())

	self.data_ = tx.userData.tableConfig[selected]
	self.levelType_ = selected
	self:onTypeTabChanged_(self.roomType_)
end

function TexasHallScene:onMainTabPressed_(evt)
	local tag = evt.target:getTag()
	if self.levelType_ ~= tag then
		local x = evt.target:getPositionX()
		self.nodeTop.light:stopAllActions()
		self.nodeTop.light:opacity(255):show():setPositionX(x)
	end
end

function TexasHallScene:onMainTabRelease_(evt)
	self.nodeTop.light:fadeOut(1)
end

function TexasHallScene:onTypeTabChanged_(idx)
	self.roomType_ = idx
	-- if idx == 1 then
	-- 	self.fastAnimation_:hide()
	-- else
	-- 	self.fastAnimation_:show()
	-- end
	self:onNumTabChanged_(self.roomNum_)
end

function TexasHallScene:onNumTabChanged_(idx)
	self.roomNum_ = idx
	local data = self.data_[ROOM_TYPE_KEY[self.roomType_][self.roomNum_]]
	ChooseLevelItem.CURTYPE = self.levelType_
  	self.roomList_:setData(data,true)
  	self.roomList_:update() --先重置currentPlace_的值，否则会一直累加，而不是滚动指定位置
  	self.roomList_:scrollTo(TexasHallScene.LIST_LAST_POS)
  	self:showRecommendLight_(data)
end

function TexasHallScene:onItemClick_(data, askUpLevel)
	local smallblind = data.smallblind
	if tx.userData.level > 2 and askUpLevel then
		if smallblind == 50 and tx.userData.money > (smallblind * tx.userData.newPlayerMultiple) then
			tx.ui.Dialog.new({
	            -- hasCloseButton = false,
	            closeWhenTouchModel = true,
	            messageText = sa.LangUtil.getText("HALL", "TEXAS_GUIDE_TIPS_1"),
	            firstBtnText = sa.LangUtil.getText("COMMON", "CANCEL"),
	            secondBtnText = sa.LangUtil.getText("HALL", "TEXAS_UPGRADE"),
	            callback = function (btnType)
	                if btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
	                    self:quickStart()
	                end
	            end
	        }):show()
		elseif smallblind ~= 50 and smallblind <= tx.userData.maxGuideBlind and tx.userData.money > (smallblind * tx.userData.guideMultiple) then
			tx.ui.Dialog.new({
	            -- hasCloseButton = false,
	            closeWhenTouchModel = true,
	            messageText = sa.LangUtil.getText("HALL", "TEXAS_GUIDE_TIPS_2"),
	            firstBtnText = sa.LangUtil.getText("HALL", "TEXAS_STILL_ENTER"),
	            secondBtnText = sa.LangUtil.getText("HALL", "TEXAS_UPGRADE"),
	            callback = function (btnType)
	            	if btnType == tx.ui.Dialog.FIRST_BTN_CLICK then
	            		self:enterRoom_(data)
	                elseif btnType == tx.ui.Dialog.SECOND_BTN_CLICK then
	                    self:quickStart()
	                end
	            end
	        }):show()
		else
			self:enterRoom_(data)
		end
	else
		self:enterRoom_(data)
	end
end

function TexasHallScene:enterRoom_(data)
	if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "texas_choose_room_click", label = "texas_choose_room_click"}
        }
    end

    self:requestRoom((data and type(data)=="table" and data.level) and {level=data.level} or {level=101})
end

function TexasHallScene:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(display.cx, display.cy)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function TexasHallScene:getTableConfig_()
    if not tx.userData.tableConfig then
    	self:setLoading(true)
    	tx.TableConfigManager:getTexasTableConfig(function()
    		if self.this_ then
				self:setLoading(false)
		        self:initData_()
		    end
		end)
    else
    	self:initData_()
    end
end

function TexasHallScene:initData_()
	self:getRecommendLevel_()

	self.titleGroup_:getButtonAtIndex(self.levelType_):setButtonSelected(true)
	self.typeTab_:gotoTab(self.roomType_, true)
	self.numTab_:gotoTab(self.roomNum_, true)
end

function TexasHallScene:initNumAndTypeTab_()
	local isShowType = tx.OnOff:check("switch_level_speed") --普通场快速场开关
	local isShowNum = tx.OnOff:check("switch_level_people") --场次人数开关

	if isShowType then
		self.nodeBottom.typeBg:show()
		self.roomType_ = tx.userDefault:getIntegerForKey(tx.cookieKeys.TEXAS_ROOM_FAST, QUICK_PLAY)

		self.nodeBottom.numBg:setPositionX(self.numBgOriginalX_)
	else
		self.nodeBottom.typeBg:hide()
		self.roomType_ = QUICK_PLAY

		self.nodeBottom.numBg:setPositionX(self.typeBgOriginalX_ + 15)
	end

	if isShowNum then
		self.nodeBottom.numBg:show()
		self.roomNum_ = tx.userDefault:getIntegerForKey(tx.cookieKeys.TEXAS_ROOM_NUM, NUM_6)
	else
		self.nodeBottom.numBg:hide()
		self.roomNum_ = NUM_6
	end
end

function TexasHallScene:showRecommendLight_(data)
	if self.levelType_ and self.recommendLevel_ and self.levelType_ == self.recommendLevel_ then   -- 有时候没赋值....
		local index = 0
		local levelLimit = tx.userData.tableLevelLimit[self.levelType_]
		local level = tx.userData.level
		for i, v in ipairs(data) do
			if self.recommendMinAnte_ >= data[i].min_ante and level >= levelLimit[i] then
				index = i
			end
		end

		if index > 0 then
			local item = self.roomList_:getListItem(index)
			item:showRecommendLight()

			--推荐场次居中,把item坐标移到0的位置,需要再原始坐标上加上偏移place,因为contentNode已经整体偏移了
			local place = self.roomList_:getContentPlace()
			local item_x = item:getPositionX()
			local w = ChooseLevelItem.WIDTH
			local x = -(item_x + place + ChooseLevelItem.WIDTH*0.5)
			self.roomList_:scrollTo(x)
		end
	end
end

--获取推荐房间等级
function TexasHallScene:getRecommendLevel_()
	local money = tx.userData.money
	local recommendTable = tx.userData.recommendTable

	--找到推荐房间
	for _, v in ipairs(recommendTable) do
		if money >= v.range[1] and money <= v.range[2] then
			self.recommendMinAnte_ = v.minAnte
			break
		end
	end

	--推荐房间等级
	local recommendLevel = 1
	for i, v in ipairs(tx.userData.tableConfig) do
		local flag = false
		local config = v[ROOM_TYPE_KEY[self.roomType_][self.roomNum_]]
		for _, vv in ipairs(config) do
			if self.recommendMinAnte_ == vv.min_ante then
				recommendLevel = i
				flag = true
				break
			end
		end

		if flag then
			break
		end
	end

	--玩家等级可以进入的最大房间等级
	local level = tx.userData.level
	local flag = false
	local maxLevelType = 1
	for i, v in ipairs(tx.userData.tableLevelLimit) do
		if level < v[1] then
			break
		end
		maxLevelType = i
	end

	if recommendLevel > maxLevelType then
		recommendLevel = maxLevelType
	end

	self.recommendLevel_ = recommendLevel
end

function TexasHallScene:updateShopIcon_(evt)
	TexasHallScene.super.updateShopIcon_(self,evt)
	TexasHallScene.super.dealShopShow(self,self.nodeTop.btnShop)
end

function TexasHallScene:onCleanup()
	TexasHallScene.LIST_LAST_POS = self.roomList_:getCurrentPlace()

	tx.userDefault:setIntegerForKey(tx.cookieKeys.TEXAS_ROOM_TYPE,self.levelType_)
	tx.userDefault:setIntegerForKey(tx.cookieKeys.TEXAS_ROOM_FAST,self.roomType_)
	tx.userDefault:setIntegerForKey(tx.cookieKeys.TEXAS_ROOM_NUM,self.roomNum_)
	TexasHallScene.super.onCleanup(self)

	sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
end

return TexasHallScene