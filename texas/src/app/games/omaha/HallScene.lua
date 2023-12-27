local ChooseLevelItem = import(".hall.ChooseLevelItem")
local PopupHelp = import(".hall.PopupHelp")
local KeyboardPopup = import("app.module.keyboard.KeyboardPopup")
local GameHallScene = import("app.scenes.GameHallScene")
local P = import(".net.PROTOCOL")

local OmahaHallScene = class("OmahaHallScene", GameHallScene)
OmahaHallScene.ELEMENTS = {
	"bg",
	"nodeTop.frame",
	"nodeTop.hallIcon",
	"nodeTop.btnShop",
    "nodeTop.btnHelp",
	"nodeTop.btnBack",
	"nodeTop.title",
	"nodeTop.chipBg.labelChip",
}

local NOR_PLAY, QUICK_PLAY = 1, 2
local NUM_9, NUM_6 = 1, 2
local ROOM_TYPE_KEY = { --对应场次key
	{"c_9", "c_6"},--普通场
	{"q_9", "q_6"},--快速场
}

function OmahaHallScene:ctor(idx)
	self.this_ = self
	OmahaHallScene.super.ctor(self,P.GAMEID)
	tx.ui.EditPanel.bindElementsToTarget(self,"omaha_hall.csb",true)
		:pos(display.cx,display.cy)

	self.bg:setScale(tx.bgScale)
	local size = self.nodeTop.frame:getContentSize()
	self.nodeTop.frame:setContentSize(cc.size(display.width,size.height))
	self.nodeTop:setPositionY(display.cy - size.height*0.5)
	self.nodeTop.hallIcon:setPositionX(-display.cx)

	self.nodeTop.btnBack:setPositionX(-display.cx + 63)
	ImgButton(self.nodeTop.btnBack,"#common/btn_scene_back.png","#common/btn_scene_back_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		self:doBackToHall()
	end)

	self.nodeTop.btnShop:setPositionX(display.cx - 67)
	ImgButton(self.nodeTop.btnShop,"#common/btn_scene_shop.png","#common/btn_scene_shop_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		tx.PayGuideManager:quickPayGuide()
	end)

    self.nodeTop.btnHelp:setPositionX(display.cx - 190)
    ImgButton(self.nodeTop.btnHelp,"#common/btn_scene_help.png","#common/btn_scene_help_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        PopupHelp.new():showPanel()
    end)

	local list_w, list_h = display.width - 100, 620
    local spaceWidth = 60
    ChooseLevelItem.WIDTH = (list_w - spaceWidth*3)/3
	self.roomList_ = sa.ui.PageView.new(
        {
            viewRect = cc.rect(-list_w*0.5, -list_h*0.5, list_w, list_h),
            direction = sa.ui.ScrollView.DIRECTION_HORIZONTAL,
            rows = 1,
            columns = 3,
            columnsPadding = spaceWidth,
        }, 
        ChooseLevelItem, -- 继承于ListItem 必须要有 ItemClass.WIDTH,ItemClass.HEIGHT | 在PageListItem里头需要计算
        {
            btnNormal = "#common/selected_point_off.png",
            btnSelect = "#common/selected_point_on.png",
        }
	)
    :pos(display.cx, display.cy - 30)
    :addTo(self)
    self.roomList_.onItemClickListener = handler(self, self.onItemClick_)

    self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(tx.userData.money))

    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, function(obj, userMoney)
        self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(userMoney))
    end))

	self:initNumAndTypeTab_()
	self:updateShopIcon_()
	self:initTableConfig_()
end

function OmahaHallScene:onItemClick_(data)
	self:requestRoom((data and type(data)=="table" and data.level) and {level=data.level} or {level=501})
end

function OmahaHallScene:setLoading(isLoading)
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

function OmahaHallScene:initTableConfig_()
    if not tx.userData.omahaTableConfig then
    	self:setLoading(true)
    else
    	self:initData_()
    end

    self:getTableConfig_()
    self:schedule(function()
    	self:getTableConfig_()
    end, 10)
end

function OmahaHallScene:getTableConfig_()
	tx.TableConfigManager:getOmahaTableConfig(function()
		if self.this_ then
			self:setLoading(false)
	        self:initData_()
	    end
	end, true)
end

function OmahaHallScene:initData_()
	local config = tx.userData.omahaTableConfig[1]
	local data = config[ROOM_TYPE_KEY[self.roomType_][self.roomNum_]]
  	self.roomList_:setData(data,true)
end

function OmahaHallScene:initNumAndTypeTab_()
	self.roomType_ = QUICK_PLAY
	self.roomNum_ = NUM_9
end

function OmahaHallScene:onCleanup()
	OmahaHallScene.super.onCleanup(self)

	sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
end

function OmahaHallScene:updateShopIcon_(evt)
	OmahaHallScene.super.updateShopIcon_(self,evt)
    OmahaHallScene.super.dealShopShow(self,self.nodeTop.btnShop,nil,8)
end

return OmahaHallScene