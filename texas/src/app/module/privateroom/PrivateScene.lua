local PrivateScene = class("PrivateScene", tx.ui.EditPanel)
local RoomListItem = import(".RoomListItem")
local FirstPayButton = require("app.module.firstpay.FirstPayButton")

PrivateScene.ELEMENTS = {
    "nodeBg",

    "nodeTop.bg",
    "nodeTop.tab1",
    "nodeTop.tab2",
    "nodeTop.tab3",
    "nodeTop.back",
    "nodeTop.search",
    "nodeTop.shop",

    "nodeList.nodeSearch.btnSearch",
    "nodeList.nodeSearch.labelSearch",

    "nodeCreate",

    "nodeRecord.node1.labelKey",
    "nodeRecord.node1.labelValue",
    "nodeRecord.node2.labelKey",
    "nodeRecord.node2.labelValue",
    "nodeRecord.node3.labelKey",
    "nodeRecord.node3.labelValue",
}

function PrivateScene:ctor(index)
	-- 玩家支付信息变化
    self.payInfoChangeId_ = sa.EventCenter:addEventListener(tx.eventNames.USER_PAY_INFO_CHANGE,handler(self, self.updateShopIcon_))
	self.handlerRoomList_ = sa.EventCenter:addEventListener(tx.eventNames.PRIVATE_ROOM_LIST, handler(self, self.handleRoomList_))
	self.this_ = self
	index = index or 1
    if index > 3 then
        index = 1
    end
    self.curIndex_ = index
    PrivateScene.super.ctor(self,"private.csb",true)
    self.nodeBg:setScaleY(tx.heightScale)
    self.nodeBg:setScaleX(tx.widthScale)
    self.nodeTop:setPositionY(display.cy)
    self.nodeTop.bg:setScaleX(tx.widthScale)
    self.nodeList:setPositionY(display.cy)
    self.nodeRecord:setPositionY(display.cy)
    self.nodeTop.back:setPositionX(-display.cx+50)
	self.nodeTop.shop:setPositionX(display.cx-50)
	self.nodeTop.search:setPositionX(display.cx-50-110)
    ImgButton(self.nodeTop.back,"#common/btn_scene_back.png","#common/btn_scene_back_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		self:hidePanel()
	end)
	ImgButton(self.nodeTop.shop,"#common/btn_scene_shop.png","#common/btn_scene_shop_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		tx.PayGuideManager:quickPayGuide()
	end)
    ImgButton(self.nodeTop.search,"#common/btn_scene_search.png","#common/btn_scene_search_down.png"):onButtonClicked(function()
		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
		--获取按钮世界坐标
		local tempWorldPt = self.nodeTop:convertToWorldSpace(cc.p(self.nodeTop.search:getPosition()))
		local KeyboardPopup = require("app.module.keyboard.KeyboardPopup")
		KeyboardPopup.new(tempWorldPt)
			:align(display.TOP_RIGHT, display.width, display.height - 100)
			:showPanel()
	end)
	self.titleGroup_ = tx.ui.CheckBoxButtonGroup.new()
	self.titleGroup_:addButton(ChkBoxButton(ImgButton(self.nodeTop.tab1,"#lang/pri_list_off.png","#lang/pri_list_off.png","#lang/pri_list_on.png")))
	self.titleGroup_:addButton(ChkBoxButton(ImgButton(self.nodeTop.tab2,"#lang/pri_create_off.png","#lang/pri_create_off.png","#lang/pri_create_on.png")))
	self.titleGroup_:addButton(ChkBoxButton(ImgButton(self.nodeTop.tab3,"#lang/pri_record_off.png","#lang/pri_record_off.png","#lang/pri_record_on.png")))
	self.titleGroup_:onButtonSelectChanged(handler(self, self.onMainTabChanged_))

	self.nodeList.nodeSearch:setLocalZOrder(100)
	self.roomIdEdit_ = EditNumberLabel(self.nodeList.nodeSearch.labelSearch, {tips = sa.LangUtil.getText("PRIVTE", "ENTERBYID"),size = 30, color = cc.c3b(0xBC,0x3C,0x51), onEnterCallback =  handler(self, self.onSearchEnterClicked_)})
	ImgButton(self.nodeList.nodeSearch.btnSearch,"#dialogs/privateroom/search.png","#dialogs/privateroom/search_d.png")
		:onButtonClicked(function()
			tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
			self:onSearchEnterClicked_()
		end)

	-- 记录暂时不开放
	self.nodeTop.tab3:hide()
	self.nodeTop.tab1:setPositionX(-170)
	self.nodeTop.tab2:setPositionX(170)

	self.nodeList:hide()
	self.nodeCreate:hide()

	if self.curIndex_==3 then self.curIndex_ = 1 end
	--在闪出动画的时候 如果有列表会有点卡
	self:performWithDelay(function()
        self.titleGroup_:getButtonAtIndex(self.curIndex_):setButtonSelected(true)
    end, 0.3)
	self:updateShopIcon_()
end

function PrivateScene:onSearchEnterClicked_()
	if not self.sendEnter_ then
        local tid = self.roomIdEdit_:getText()
        tid = tonumber(tid)
        if not tid then 
            tx.TopTipManager:showToast(sa.LangUtil.getText("PRIVTE", "INPUTROOMIDTIPS"))
            return
        end

        self.sendEnter_ = true
        local gameId = 1
        tx.socket.HallSocket:searchRoom(gameId, tid)
        self:performWithDelay(function()
            self.sendEnter_ = false
        end, 1)
    end
end

function PrivateScene:onMainTabChanged_(evt)
 	local selected = evt.selected
 	self.curIndex_ = selected
    self.nodeList:hide()
	self.nodeCreate:hide()
	self.nodeRecord:hide()
	self:setLoading(false)
    if self.curIndex_==1 then
    	self.nodeList:show()
    	self:checkShowList()
    elseif self.curIndex_==2 then
    	self.nodeCreate:show()
    	self:checkShowCreate()
	elseif self.curIndex_==3 then
		self.nodeRecord:show()
		self:checkShowRecord()
	end
end

function PrivateScene:handleRoomList_(evt)
	self.curListPage_ = self.curListPage_ + 1
	self.isRequestListPage_ = nil
	local data = evt.data
	self.totalListPage_ = data.totalPages
	self:setLoading(false)
	if not self.roomListData_ then self.roomListData_ = {} end
	local tempList = data.list
	local curPlayerList = nil
	for k, v in pairs(tempList) do
		curPlayerList = v.playerList
		for kk,vv in pairs(curPlayerList) do
			curPlayerList[kk] = json.decode(vv)
			curPlayerList[kk].img = tostring(curPlayerList[kk].img)
		end
	end
	table.insertto(self.roomListData_, tempList)
	if self.curIndex_==1 then
		if #self.roomListData_>0 then
			self.noListNode_:hide()
			self.roomList_:setData(self.roomListData_,true)
		else
			self.noListNode_:show()
		end
	end
end

function PrivateScene:requestRoomList()
	if self.totalListPage_ and self.curListPage_ and self.totalListPage_<=self.curListPage_ then return; end
	if self.isRequestListPage_ then return; end
	self.isRequestListPage_ = true
	self:setLoading(true)
	tx.socket.HallSocket:getPriRoomList((self.curListPage_+1),self.count_)
end

function PrivateScene:checkShowList()
	if not self.roomList_ then
		local top = 255
		local left = 15
		local list_w, list_h = display.width-left*2 ,display.height - top
	    local x, y = 0, -display.cy-top*0.5
	    RoomListItem.WIDTH = list_w
	    self.roomList_ = sa.ui.ListView.new(
	        {
	            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
	            upRefresh = handler(self, self.requestRoomList)
	        },
	        RoomListItem
	    )
	    	:pos(x,y)
	    	:addTo(self.nodeList,1)
	    -- 没有列表
	    self.noListNode_ = display.newNode()
	    	:pos(x,y+60)
	    	:addTo(self.nodeList,2)
	    	:hide()
	    self.noListLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("PRIVTE", "CHECKCREATE"), size = 30})--, color = cc.c3b(0x48, 0x3c, 0x78)
	        :align(display.LEFT_CENTER, 0, 0)
	        :addTo(self.noListNode_)
	    local size = self.noListLabel_:getContentSize()
	    self.gotoCreateBtn_ = ImgButton(display.newScale9Sprite("#dialogs/privateroom/btn_create.png"),"#dialogs/privateroom/btn_create.png","#dialogs/privateroom/btn_create_down.png")
	    	:pos(size.width+70,0)
	    	:addTo(self.noListNode_)
	    	:onButtonClicked(function()
	    		tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
	    		self.titleGroup_:getButtonAtIndex(2):setButtonSelected(true)
	    	end)
	    self.noListNode_:setPositionX(x-(size.width+130)*0.5)
	end
	if not self.curListPage_ then self.curListPage_ = 0 end
	self.count_ = 6
	self:requestRoomList()
end

function PrivateScene:checkShowCreate()
	if not self.this_ then return; end
	if tx.userData.privateRoomConf then
		if self.curIndex_==2 and not self.createView_ then
			self:setLoading(false)
			local CreateView = require("app.module.privateroom.CreateView")
			self.createView_ = CreateView.new()
				:addTo(self.nodeCreate)
		end
	else
		self:setLoading(true)
		if self.isLoadingPrivateConf_ then return; end
		self.isLoadingPrivateConf_ = true
		local reqFun = nil
		reqFun = function()
            sa.HttpService.CANCEL(self.requestConfId_)
            self.requestConfId_ = sa.HttpService.POST(
                {
                    mod = "Privateroom",
                    act = "getConfig",
                },
                function (data)
                    local retData = json.decode(data)
                    if retData.base then
                        tx.userData.privateRoomConf = retData
                       	if self.this_ then
                        	self:checkShowCreate()
                        end
                    else
                        reqFun()
                    end
                end,
                function()
                    reqFun()
                end
            )
        end
        reqFun()
	end
end

function PrivateScene:checkShowRecord()
	if not self.recordList_ then

	end
end

function PrivateScene:onShowed()
	if self.roomList_ then
		self.roomList_:setScrollContentTouchRect()
	end
	if self.recordList_ then
		self.recordList_:setScrollContentTouchRect()
	end
end

function PrivateScene:onCleanup()
	sa.EventCenter:removeEventListener(self.payInfoChangeId_)
	sa.EventCenter:removeEventListener(self.handlerRoomList_)
	sa.HttpService.CANCEL(self.requestConfId_)
	display.removeSpriteFramesWithFile("dialog_texas_private_room.plist", "dialog_texas_private_room.png")
end

function PrivateScene:updateShopIcon_(evt)
	self.nodeTop.shop:hide()
    if self.firstPayBtn_ then
        self.firstPayBtn_:hide()
    end

    if not self.discountTips_ then
        local DiscountTips = require("app.pokerUI.DiscountTips")
        self.discountTips_ = DiscountTips.new()
            :pos(display.cx-110, -28)
            :addTo(self.nodeTop)
    end

    self.discountTips_:hide()

    local xx,yy = self.nodeTop.shop:getPosition()

    -- 破产
    local brokenData = tx.userData.payinfo and tx.userData.payinfo.brokesalegoods
    if brokenData and brokenData.gid then
        self:showDiscount_(brokenData)
    elseif tx.userData.payStatus == 0 then
        if not self.firstPayBtn_ then
            self.firstPayBtn_ = FirstPayButton.new()
                :pos(xx-5,yy-3)
                :addTo(self.nodeTop)
        end
        self.firstPayBtn_:show()
    else
        self.nodeTop.shop:show()
    end
end

function PrivateScene:showDiscount_(data)
    local time = tonumber(data.countdown) - (os.time()-data.clientTime)
    self.discountTips_:setInfo(time,"+"..data.sale.."%")
    self.nodeTop.shop:show()
end

return PrivateScene