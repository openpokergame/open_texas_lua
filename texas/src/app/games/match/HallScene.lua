local GameHallScene	= import("app.scenes.GameHallScene")
local MatchListItem = import(".hall.MatchListItem")
local PopupDetail 	= import("app.module.match.views.PopupDetail")
local PopupReg 		= import("app.module.match.views.PopupReg")

local PopupRoomDetail 	= import("app.module.match.views.PopupRoomDetail")

local P = import(".net.PROTOCOL")

local MatchHallScene = class("MatchHallScene", GameHallScene)
MatchHallScene.ELEMENTS = {
	"bg",
	"bg.left",
	"bg.right",
	"bgTitle",
	"nodeTop.SNG",
	"nodeTop.MTT",
	"nodeTop.btnBack",
	"nodeTop.btnHelp",
	"nodeTop.btnShop",
	"nodeTop.nodeMoney.iconMoney",
	"nodeTop.nodeMoney.labelMoney",
	"nodeTop.nodeMoney.btnMoneyAdd",
	"nodeTop.labelName",
	"nodeTop.labelAward",
	"nodeTop.labelPlayer",
	"nodeTop.labelCost",
	"nodeTop.splite1",
	"nodeTop.splite2",
	"nodeTop.splite3",
}

local data2 = {
	{
		matchType = "mtt",
		name = "周五筹码赛",
		matchLevel = 1,
		level = 11,
		player = 30,
		reward = {450000, 270000, 180000},
		online = 300,
		registerCost = 30000,
		serverCost = 6000,
		chip = 10000,
	},
	{
		matchType = "mtt",
		name = "周六筹码赛",
		matchLevel = 2,
		level = 11,
		player = 50,
		reward = {500000, 300000, 200000},
		online = 500,
		registerCost = 20000,
		serverCost = 4000,
		chip = 10000,
	},
	{
		matchType = "mtt",
		name = "周日筹码赛",
		matchLevel = 3,
		level = 11,
		player = 100,
		reward = {500000, 300000, 200000},
		online = 1000,
		registerCost = 10000,
		serverCost = 1000,
		chip = 10000,
	},
}
data2 = nil

function MatchHallScene:ctor(idx)
	self.this_ = self
	MatchHallScene.super.ctor(self,P.GAMEID)
	tx.ui.EditPanel.bindElementsToTarget(self,"match_hall.csb",true)
		:pos(display.cx,display.cy)
	self.bg:setScale(tx.bgScale)
	self.bgTitle:setScaleX(tx.widthScale)
	self.bgTitle:setPosition(0,display.cy)
	self.nodeTop:setPosition(0,display.cy)

	self.selected_ = idx or 1
	self.nodeTop.btnBack:setPositionX(-display.cx+55)
	ImgButton(self.nodeTop.btnBack,"#common/btn_scene_back.png","#common/btn_scene_back_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		self:doBackToHall()
	end)

	self.nodeTop.nodeMoney:setPositionX(-display.cx+115)
	ImgButton(self.nodeTop.nodeMoney.btnMoneyAdd,"#match/hall/btn_add.png","#match/hall/btn_add_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		tx.PayGuideManager:openStore()
	end)

	ChkBoxButton(ImgButton(self.nodeTop.SNG,"#lang/SNG.png","#lang/SNG.png","#lang/SNG_on.png"))
	ChkBoxButton(ImgButton(self.nodeTop.MTT,"#lang/MTT.png","#lang/MTT.png","#lang/MTT_on.png"))
	local tabGroup = tx.ui.CheckBoxButtonGroup.new()
	self.titleGroup_ = tabGroup
	tabGroup:addButton(self.nodeTop.SNG)
	tabGroup:addButton(self.nodeTop.MTT)
	tabGroup:onButtonSelectChanged(function(evt)
		local selected = evt.selected
		self.selected_ = selected
		self:onTitleTabChange_(selected)
	end)

	self.nodeTop.btnShop:setPositionX(display.cx-55)
	ImgButton(self.nodeTop.btnShop,"#common/btn_scene_shop.png","#common/btn_scene_shop_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		tx.PayGuideManager:quickPayGuide()
	end)

	self.nodeTop.btnHelp:setPositionX(display.cx-165)
	ImgButton(self.nodeTop.btnHelp,"#common/btn_scene_help.png","#common/btn_scene_help_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		local PopupHelp = require("app.module.match.views.PopupHelp")
		PopupHelp.new(self.selected_):showPanel()
	end)
	
	self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, function(obj, userMoney)
		self:onRefreshMoney_()
	end))

	local padding = 25
	local topPadding = 180
	local bottomPadding = 22
	local listWidth,listHeight = display.width-padding*2,display.height-topPadding-bottomPadding
	local itemWidth = listWidth/5
	local xx, yy = self.nodeTop.labelName:getPosition()
	self.nodeTop.labelName:pos(padding+itemWidth*0.5-display.cx,yy)
		:setString(sa.LangUtil.getText("MATCH", "MATCH_NAME"))
	self.nodeTop.labelAward:pos(padding+itemWidth*1.5-display.cx,yy)
		:setString(sa.LangUtil.getText("MATCH", "MATCH_REWARD"))
	self.nodeTop.labelPlayer:pos(padding+itemWidth*2.5-display.cx,yy)
		:setString(sa.LangUtil.getText("MATCH", "MATCH_PLAYER"))
	self.nodeTop.labelCost:pos(padding+itemWidth*3.5-display.cx + 70,yy)
		:setString(sa.LangUtil.getText("MATCH", "MATCH_COST"))
	self.nodeTop.splite1:setPositionX(padding+itemWidth-display.cx)
	self.nodeTop.splite2:setPositionX(padding+itemWidth*2-display.cx)
	self.nodeTop.splite3:setPositionX(padding+itemWidth*3-display.cx)

	MatchListItem.WIDTH= listWidth
	self.roomList_ = sa.ui.ListView.new(
			{
				viewRect = cc.rect(-listWidth * 0.5, -listHeight * 0.5, listWidth, listHeight),
			},
			MatchListItem
		)
		:pos(display.cx,display.cy-topPadding*0.5+bottomPadding*0.5)
		:addTo(self)
	self.roomList_.onItemClickListener = handler(self, self.onItemClick_)

	self.expectTips_ = ui.newTTFLabel({text = sa.LangUtil.getText("MATCH", "EXPECT_TIPS"), size = 26})
        :pos(display.cx, display.cy)
        :addTo(self)
        :hide()

    self:updateShopIcon_()
	self:getSNGTableConfig()
end

function MatchHallScene:updateShopIcon_(evt)
	MatchHallScene.super.updateShopIcon_(self,evt)
	MatchHallScene.super.dealShopShow(self,self.nodeTop.btnShop,nil,-1)
end

function MatchHallScene:onItemClick_(data,type)
	local level = data.matchlevel
	if type==1 then  -- 详细信息
		if data.matchType == "sng" then
			PopupReg.new(data):showPanel()
			-- PopupRoomDetail.new(level):showPanel() --test
			-- PopupDetail.new(data):showPanel()--test
		else
			PopupDetail.new(data):showPanel()
		end
	elseif type==2 then -- 直接报名
		if tx.userData.money >= (data.registerCost + data.serverCost) then
            tx.matchProxy:dealReg(level)
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "NOT_ENOUGH_MONEY"))
        end
	end
end

function MatchHallScene:onTitleTabChange_(selected)
	local titleScolor = cc.c3b(0xf5,0xdd,0x8b)
	local titleSNcolor = cc.c3b(0x5A,0x56,0x84)
	local titleNColor1 = cc.c3b(0xa9,0x4c,0x53)
	local titleNColor2 = cc.c3b(0x9C,0x36,0xB6)
	local splite1 = "match/hall/splite2.png"
	local splite2 = "match/hall/splite1.png"
	local bg1 = "img/match_hall_bg2.jpg"
	local bg2 = "img/match_hall_bg1.jpg"
	if selected == 1 then
		self.nodeTop.splite1:setSpriteFrame(splite1)
		self.nodeTop.splite2:setSpriteFrame(splite1)
		self.nodeTop.splite3:setSpriteFrame(splite1)

		local sprite = display.newSprite(bg1)
		self.bg.left:setSpriteFrame(sprite:getSpriteFrame())
		self.bg.right:setSpriteFrame(sprite:getSpriteFrame())
		self.nodeTop.labelName:setColor(titleNColor1)
		self.nodeTop.labelAward:setColor(titleNColor1)
		self.nodeTop.labelPlayer:setColor(titleNColor1)
		self.nodeTop.labelCost:setColor(titleNColor1)
		self.roomList_:setData(self.sngData_)
		self.expectTips_:hide()
	elseif selected == 2 then
		self.nodeTop.splite1:setSpriteFrame(splite2)
		self.nodeTop.splite2:setSpriteFrame(splite2)
		self.nodeTop.splite3:setSpriteFrame(splite2)

		local sprite = display.newSprite(bg2)
		self.bg.left:setSpriteFrame(sprite:getSpriteFrame())
		self.bg.right:setSpriteFrame(sprite:getSpriteFrame())
		self.nodeTop.labelName:setColor(titleNColor2)
		self.nodeTop.labelAward:setColor(titleNColor2)
		self.nodeTop.labelPlayer:setColor(titleNColor2)
		self.nodeTop.labelCost:setColor(titleNColor2)

		self.roomList_:setData(data2)
		self.expectTips_:show()
	end
end

function MatchHallScene:onRefreshMoney_()
	self.nodeTop.nodeMoney.labelMoney:setString(sa.formatNumberWithSplit(tx.userData.money))
	sa.fitSprteWidth(self.nodeTop.nodeMoney.labelMoney, 145)
end

function MatchHallScene:onCleanup()
	MatchHallScene.super.onCleanup(self)
	sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
end

-- 覆盖父类相关socket事件
function MatchHallScene:onServerFail_(evt)
end

function MatchHallScene:onMatchStartLogin_(evt)
	self:removeRoomLoading_()

	local msg = sa.LangUtil.getText("ROOM", "ENTERING_MSG")
	self.roomLoading_ = tx.ui.RoomLoading.new(msg)
		:pos(display.cx, display.cy)
		:addTo(self, 100)
	MatchHallScene.super.onMatchStartLogin_(self,evt) -- 进入比赛
end

function MatchHallScene:onLoginMatchRoomFail_(evt)
	self:removeRoomLoading_()
end

function MatchHallScene:onMatchServerFail_(evt)
	-- --连接失败
	--    if evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE then

	--    --心跳包超时
	--    elseif evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT then

	--    --登录超时
	--    elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then

	-- --未连接发送数据
    -- elseif evt.data == consts.SVR_ERROR.ERROR_SEND_NOT_CON then

	--    end
	self:removeRoomLoading_()

	-- 这种状态自己回去连接
    if evt.data == consts.SVR_ERROR.ERROR_SEND_NOT_CON then
		tx.ui.Dialog.new({
			closeWhenTouchModel = false,
			messageText = sa.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"),
			secondBtnText = sa.LangUtil.getText("COMMON", "RETRY"),
			callback = function (type)
				if type == tx.ui.Dialog.SECOND_BTN_CLICK then
					self.roomLoading_ = tx.ui.RoomLoading.new(sa.LangUtil.getText("ROOM", "ENTERING_MSG"))
						:pos(display.cx, display.cy)
						:addTo(self, 100)
					tx.socket.MatchSocket:disconnect()
					local ip, port = string.match(tx.userData.MatchServer[1], "([%d%.]+):(%d+)")
					tx.socket.MatchSocket:connectDirect(ip, port, false)
				end
			end
		}):show()
	elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then
        
    elseif evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT or evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE then
        tx.socket.MatchSocket:disconnect()
        local ip, port = string.match(tx.userData.MatchServer[1], "([%d%.]+):(%d+)")
        tx.socket.MatchSocket:connectDirect(ip, port, false) -- 不能自动重连 必须要显示 否则失败了没有事件出来
	end
end

function MatchHallScene:onLoginHallSvrSucc_(evt)
end

function MatchHallScene:onLoginMatchHallSvrSucc_(evt)
	local pack = evt.data
	if not pack or not pack.tid or pack.tid<1 then
		self:removeRoomLoading_()
	end
end

function MatchHallScene:onRegStatusChange_(evt)
	local status = evt.data.status
	local enabled = true
	if status == "START_REGISTER" then
		enabled= false
	elseif status == "REGISTER_SUCCESS" or status == "REGISTER_FAILED" then
		enabled = true
	end

	if evt.data.isMaintain then
		local data = self.roomList_:getData()
		for i, v in ipairs(data) do
			if v.matchlevel == evt.data.level then
				table.remove(data, i)
				break
			end
		end
		-- self.roomList_:setData(nil)
		self.roomList_:setData(data)
	end

	local items = self.roomList_:getListItems()
	for _, v in ipairs(items) do
		v:setRegisterBtnEnabled(enabled)
	end
end

function MatchHallScene:removeRoomLoading_()
	if self.roomLoading_ then 
		self.roomLoading_:removeFromParent()
		self.roomLoading_ = nil
	end
end

function MatchHallScene:setLoading(isLoading)
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

function MatchHallScene:getSNGTableConfig()
    if not tx.userData.sngTableConfig then
    	self:setLoading(true)
		tx.TableConfigManager:getSNGTableConfig(function()
			if self.this_ then
	    		self:setLoading(false)
				self:initData_()
			end
		end, true)
    else
		self:initData_()
    end
end

-- matchType = "sng",
-- name = "欢乐免费赛",
-- matchLevel = 1, --比赛级别
-- roomLevel = 11, --比赛房间
-- player = 6, --比赛配置人数
-- reward = {20000, 10000}, --比赛场奖励
-- online = 120, --报名参数人数
-- registerCost = 5000, --报名费
-- serverCost = 0, --服务费
-- chip = 5000, --初始化筹码
-- matchTime = "全天无休坐满即玩" --比赛时间
-- blindList = "75,150,200,300,400,500,750,1000,1500,2000,3000,4000,5000,7500,10000" --盲注
-- blindTime = 100 --涨盲间隔

function MatchHallScene:initData_()
	self.sngData_ = tx.userData.sngTableConfig
	self.titleGroup_:getButtonAtIndex(self.selected_):setButtonSelected(true)

	-- for _, v in ipairs(self.sngData_) do
	-- 	tx.socket.MatchSocket:getRegCount(v.matchlevel)
	-- end
end

return MatchHallScene