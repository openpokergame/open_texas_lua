--选择游戏玩法界面
local GameHallScene = import("app.scenes.GameHallScene")
local ChooseGameScene = class("ChooseGameScene", GameHallScene)

local OmahaListView = import(".OmahaListView")
local TexasListView = import(".TexasListView")
local TexasMustListView = import(".TexasMustListView")
local OmahaHelpPopup = import("app.games.omaha.hall.PopupHelp")
local TexasMustHelpPopup = import("app.games.texasmust.hall.PopupHelp")

ChooseGameScene.ELEMENTS = {
	"bg",
	"nodeList",

	"nodeTop.bg",
	"nodeTop.light",
	"nodeTop.game_1",
	"nodeTop.game_2",
	"nodeTop.game_3",
	"nodeTop.btnBack",
	"nodeTop.btnShop",
	"nodeTop.btnHelp",
	"nodeTop.chipBg.labelChip",

	"nodeBottom.btnQuickPlay.label",
	"nodeBottom.btnPrivate",
}

local GROUP_IMG = {
	{"#lang/choose_game_texas_off.png","#lang/choose_game_texas_off.png","#lang/choose_game_texas_on.png"},
	{"#lang/choose_game_amaha_off.png","#lang/choose_game_amaha_off.png","#lang/choose_game_amaha_on.png"},
	{"#lang/choose_game_allin_off.png","#lang/choose_game_allin_off.png","#lang/choose_game_allin_on.png"}
}
local QUICK_PLAY_POS = {
	zh = {x = 0, y = 0},
	tw = {x = 0, y = 0},
	en = {x = 5, y = 0},
	id = {x = -35, y = 0},
	ru = {x = -40, y = 5},
	th = {x = -5, y = 0},
}

function ChooseGameScene:ctor(idx)
	ChooseGameScene.super.ctor(self)
	tx.ui.EditPanel.bindElementsToTarget(self,"choose_game.csb",true)
		:pos(display.cx,display.cy)

	self:setGameId_()

	self.gameType_ = 1
	if idx then
		self.gameType_ = idx
	end

	local btnList = {
		self.nodeTop.game_1,
		self.nodeTop.game_2,
		self.nodeTop.game_3,
	}

	local level = tx.userData.level
	local btnNum = 1
	btnList[2]:hide()
	btnList[3]:hide()
	if (tx.userData.switch_aomaha == 1) and level >= tx.userData.aomahLevelLimit then
		btnNum = btnNum + 1
		btnList[2]:show()
	end

	if (tx.userData.switch_allin == 1) and level >= tx.userData.allinLevelLimit then
		btnNum = btnNum + 1
		btnList[3]:show()
	end

	if btnNum == 1 then
		btnList[1]:setPositionX(0)
	elseif btnNum == 2 then
		btnList[1]:setPositionX(-128)
		btnList[2]:setPositionX(128)
		btnList[3]:setPositionX(128)
	end

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
	self.nodeTop.bg:setScaleX(tx.widthScale)

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
	self.nodeTop.btnHelp:setPositionX(display.cx - rx)
	ImgButton(self.nodeTop.btnHelp,"#common/btn_scene_help.png","#common/btn_scene_help_down.png"):onButtonClicked(buttontHandler(self, self.onHelpClicked_))

	self.roomList_ = {}
	self.roomList_[1] = TexasListView.new(self):addTo(self.nodeList):hideList()
	self.roomList_[2] = OmahaListView.new(self):addTo(self.nodeList):hideList()
	self.roomList_[3] = TexasMustListView.new(self):addTo(self.nodeList):hideList()

	ScaleButton(self.nodeBottom.btnQuickPlay, 0.95):onButtonClicked(buttontHandler(self, self.onQuickPlayClicked_))

 	local p = QUICK_PLAY_POS[appconfig.LANG] or {x = 0, y = 0}
 	self.nodeBottom.btnQuickPlay.label:pos(178 + p.x, 75 + p.y)

	self.nodeBottom.btnPrivate:setPositionX(display.cx - 75)
	ImgButton(self.nodeBottom.btnPrivate,"#texas/hall/btn_private.png","#texas/hall/btn_private_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		local PrivateScene = require("app.module.privateroom.PrivateScene")
    	PrivateScene.new(2):showPanel()
	end)

	self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(tx.userData.money))

	self.titleGroup_:getButtonAtIndex(self.gameType_):setButtonSelected(true)

	self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, function(obj, userMoney)
        self.nodeTop.chipBg.labelChip:setString(sa.formatNumberWithSplit(userMoney))
    end))

	self:updateShopIcon_()
end

function ChooseGameScene:onMainTabChanged_(evt)
	self.gameType_ = evt.selected

	self:setGameId_()

	self:showList()
end

function ChooseGameScene:showList()
	for _, v in ipairs(self.roomList_) do
		v:hideList()
	end

	if self.roomList_[self.gameType_] then
		self.roomList_[self.gameType_]:showList()
	end

	if self.gameType_ ~= 1 then
		self.nodeTop.btnHelp:show()
	else
		self.nodeTop.btnHelp:hide()
	end
end

function ChooseGameScene:onMainTabPressed_(evt)
	local tag = evt.target:getTag()
	if self.gameType_ ~= tag then
		local x = evt.target:getPositionX()
		self.nodeTop.light:stopAllActions()
		self.nodeTop.light:opacity(255):show():setPositionX(x)
	end
end

function ChooseGameScene:onMainTabRelease_(evt)
	self.nodeTop.light:fadeOut(1)
end

function ChooseGameScene:onHelpClicked_()
	if self.gameType_ == 2 then --奥马哈
    	OmahaHelpPopup.new():showPanel()
    elseif self.gameType_ == 3 then --德州必下场
    	TexasMustHelpPopup.new():showPanel()
    end
end

function ChooseGameScene:onQuickPlayClicked_()
	if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{
            command = "event",
            args = {eventId = "play_now_enter_room", label = "in_choose_hall_scene"}
        }
    end

  	self:quickStart(self.gameId)
end

function ChooseGameScene:setGameId_()
	self.gameId = 1
    if self.gameType_ == 2 then --奥马哈
    	self.gameId = 3
    elseif self.gameType_ == 3 then --德州必下场
    	self.gameId = 5
    end
end

function ChooseGameScene:enterRoom(data, level)
    self:requestRoom((data and type(data)=="table" and data.level) and {level=data.level} or {level=level})
end

function ChooseGameScene:setLoading(isLoading)
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

function ChooseGameScene:updateShopIcon_(evt)
	ChooseGameScene.super.updateShopIcon_(self,evt)
	ChooseGameScene.super.dealShopShow(self,self.nodeTop.btnShop)
end

function ChooseGameScene:onCleanup()
	ChooseGameScene.super.onCleanup(self)

	sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
end

return ChooseGameScene