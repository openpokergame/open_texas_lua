local CreateView = class("CreateView", function ()
    return display.newNode()
end)

CreateView.ELEMENTS = {
	"nodeChips.bar",
    "nodeChips.btnChipsSlider",
    "nodeChips.chip1.labelName",
    "nodeChips.chip1.labelBlind",
    "nodeChips.chip2.labelName",
    "nodeChips.chip2.labelBlind",
    "nodeChips.chip3.labelName",
    "nodeChips.chip3.labelBlind",
    "nodeChips.chip4.labelName",
    "nodeChips.chip4.labelBlind",
    "nodeChips.chip5.labelName",
    "nodeChips.chip5.labelBlind",

    "nodeTime.bar",
    "nodeTime.time1.line",
    "nodeTime.time1.label",
    "nodeTime.time2.line",
    "nodeTime.time2.label",
    "nodeTime.time3.line",
    "nodeTime.time3.label",
    "nodeTime.time4.line",
    "nodeTime.time4.label",
    "nodeTime.time5.line",
    "nodeTime.time5.label",
    "nodeTime.time6.line",
    "nodeTime.time6.label",
    "nodeTime.btnTimeSlider",

    "nodeBottom.labelTips",
    "nodeBottom.typeBg",
    "nodeBottom.btnCreate",
    "nodeBottom.btnCreate.iconDiamond",
    "nodeBottom.btnCreate.labelDiamond",
    "nodeBottom.btnCreate.labelStart",
    "nodeBottom.btnCreate.lineFree",
    "nodeBottom.bgInput",

    "nodeBottom.btnVipCreate",
    "nodeBottom.btnVipCreate.iconDiamond",
    "nodeBottom.btnVipCreate.labelDiamond",
    "nodeBottom.btnVipCreate.labelStart",
    "nodeBottom.btnVipCreate.labelPrice",
}

function CreateView:ctor()
	tx.ui.EditPanel.bindElementsToTarget(self,"private_create.csb",true)
	self.secend_ = tx.userData.privateRoomConf.secend
    self.base_ = tx.userData.privateRoomConf.base
    self.diamondServer_ = tx.userData.privateRoomConf.diamond-- 实际要扣的
    self.guoQi_ = tx.userData.privateRoomConf.avaiabletime

    local level = tx.userData.vipinfo.level
    local dis = 0.5
    if tx.userData.vipGoodsData and level > 0 then
        dis = tx.userData.vipGoodsData[level].private/10
    end
    self.privateDis_ = dis

    if self.guoQi_ and #self.guoQi_>6 then
        self.guoQi_ = table.slice(self.guoQi_,1,6)
    end
    self.guoQiIndex_ = 1  -- 过期idx
    self.baseIndex_ = 1  -- 底注idx
    self.timeIndex_ = 1  --操作时间
    self.cost_ = 0  --消耗

    self.nodeBottom.labelTips:setString(sa.LangUtil.getText("PRIVTE","TYPETIPS",self.secend_[1],self.secend_[2]))
    self.nodeBottom.btnCreate.labelStart:setString(sa.LangUtil.getText("PRIVTE","CREATEROOM"))

    self.nodeBottom.btnVipCreate.labelStart:setString(sa.LangUtil.getText("PRIVTE","CREATEROOM"))
    self.nodeBottom.btnVipCreate:hide()

    for k,v in ipairs(self.base_) do
        if k<6 then
            self.nodeChips["chip"..k].labelName:setString(sa.formatBigNumber(v))

            local label = self.nodeChips["chip"..k].labelBlind
            label:setString(sa.LangUtil.getText("HALL","CHOOSE_ROOM_BLIND",sa.formatBigNumber(v),sa.formatBigNumber(v*2)))
            sa.fitSprteWidth(label, 170)
        end
    end

    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    self.chipGroup_ = tabGroup
    tabGroup:addButton(ChkBoxButton(NormalButton(self.nodeChips.chip1)))
    tabGroup:addButton(ChkBoxButton(NormalButton(self.nodeChips.chip2)))
    tabGroup:addButton(ChkBoxButton(NormalButton(self.nodeChips.chip3)))
    tabGroup:addButton(ChkBoxButton(NormalButton(self.nodeChips.chip4)))
    tabGroup:addButton(ChkBoxButton(NormalButton(self.nodeChips.chip5)))
    tabGroup:onButtonSelectChanged(function(evt)
        local selected = evt.selected
        self.baseIndex_ = selected
        local curChips = nil
        for i=1,5,1 do
            curChips = self.nodeChips["chip"..i]
            curChips.labelName:setTextColor(cc.c3b(255, 255, 255))
        end
        curChips = self.nodeChips["chip"..selected]
        curChips.labelName:setTextColor(cc.c3b(0xec, 0xe8, 0x76))
        local posX = curChips:getPositionX()
        self.nodeChips.btnChipsSlider:setPositionX(posX)
        self:changeDiamond()
    end)

    ImgButton(self.nodeBottom.btnCreate,"#common/btn_big_blue.png","#common/btn_big_blue_down.png")
        :onButtonClicked(buttontHandler(self, self.onCreateRoomClicked_))

    ImgButton(self.nodeBottom.btnVipCreate,"#common/btn_big_blue.png","#common/btn_big_blue_down.png")
        :onButtonClicked(buttontHandler(self, self.onCreateRoomClicked_))

    local size = self.nodeBottom.typeBg:getContentSize()
    local text = sa.LangUtil.getText("HALL", "CHOOSE_ROOM_TYPE")
    self.typeTab_ = tx.ui.TabBarWithIndicator.new(
            {
                background = "#common/transparent.png", 
                indicator = "#common/tab_item.png"
            },
            text,
            {
                selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
                defaltText = {color = cc.c3b(0x77, 0x72, 0xcd), size = 22}
            },
            true, true)
        :setTabBarSize(size.width, size.height, 0, -2)
        :onTabChange(function(idx)
            self.timeIndex_ = idx
        end)
        :pos(size.width*0.5, size.height*0.5)
        :addTo(self.nodeBottom.typeBg)
    self.typeTab_:setButtonIcons({{downRes="common/transparent.png",upRes="common/transparent.png"},{downRes="common/icon_fast_on.png",upRes="common/icon_fast_off.png"}},0-size.width*0.25+15,0)
    
    self.roomPwdEdit_ = EditNumberLabel(self.nodeBottom.bgInput, {direction = 2, tips = sa.LangUtil.getText("PRIVTE", "INPUTPWDTIPS")})

    local timeBarX,timeBarY = self.nodeTime.bar:getPosition()
    local timeBarSize = self.nodeTime.bar:getContentSize()
    local itemLength = 0
    local startX = 0
    if not self.guoQi_ or #self.guoQi_==1 then
        startX = timeBarX
    else
        startX = timeBarX - timeBarSize.width*0.5
        itemLength = timeBarSize.width/(#self.guoQi_-1)
    end
    local tempNode = nil
    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    self.timeGroup_ = tabGroup
    for i=1,6,1 do
        tempNode = self.nodeTime["time"..i]
        if self.guoQi_ and self.guoQi_[i] then
            tabGroup:addButton(ChkBoxButton(NormalButton(tempNode)))
            if i==1 or i==#self.guoQi_ then
                tempNode.line:hide()
            end
            tempNode:setPositionX(startX+(i-1)*itemLength)
            tempNode.label:setString(sa.LangUtil.getText("PRIVTE", "TIMEHOUR",self.guoQi_[i]/3600))
        else
            tempNode:hide()
        end
    end
    tabGroup:onButtonSelectChanged(function(evt)
        local selected = evt.selected
        self.guoQiIndex_ = selected
        local curNodeTime = nil
        for i=1,6,1 do
            curNodeTime = self.nodeTime["time"..i]
            curNodeTime.label:setTextColor(cc.c3b(255,255,255))
        end
        curNodeTime = self.nodeTime["time"..selected]
        curNodeTime.label:setTextColor(cc.c3b(0xec, 0xe8, 0x76))
        local posX = curNodeTime:getPositionX()
        self.nodeTime.btnTimeSlider:setPositionX(posX)
        self:changeDiamond()
    end)

    local coordX = self.nodeChips.bar:getPositionX()
    local size = self.nodeChips.bar:getContentSize()
    self.chipsSliderRight_ = coordX + size.width*0.5
    self.chipsSliderLeft_ = coordX - size.width*0.5
    ImgButton(self.nodeChips.btnChipsSlider,"#dialogs/privateroom/btn_chips.png","#dialogs/privateroom/btn_chips_down.png")
        :onButtonPressed(function(evt)
            self.chipsSliderTouchBeginX_ = evt.x
            self.chipsSliderBeginX_ = self.nodeChips.btnChipsSlider:getPositionX()
        end)
        :onButtonMove(function(evt)
            local movedX = evt.x - self.chipsSliderTouchBeginX_
            local toX = self.chipsSliderBeginX_ + movedX
            if toX >= self.chipsSliderRight_ then
                toX = self.chipsSliderRight_
            elseif toX <= self.chipsSliderLeft_ then
                toX = self.chipsSliderLeft_
            end
            local node = nil
            local xx = nil
            for i=1,5,1 do
                node = self.nodeChips["chip"..i]
                xx = node:getPositionX()
                if math.abs(xx-toX)<70 then
                    self.nodeChips.btnChipsSlider:setPositionX(xx)
                    self.chipGroup_:getButtonAtIndex(i):setButtonSelected(true)
                    return
                end
            end
        end)

    local coordX = self.nodeTime.bar:getPositionX()
    local size = self.nodeTime.bar:getContentSize()
    self.timeSliderRight_ = coordX + size.width*0.5
    self.timeSliderLeft_ = coordX - size.width*0.5
    ImgButton(self.nodeTime.btnTimeSlider,"#dialogs/privateroom/btn_hua.png","#dialogs/privateroom/btn_hua_down.png")
        :onButtonPressed(function(evt)
            self.timeSliderTouchBeginX_ = evt.x
            self.timeSliderBeginX_ = self.nodeTime.btnTimeSlider:getPositionX()
        end)
        :onButtonMove(function(evt)
            local movedX = evt.x - self.timeSliderTouchBeginX_
            local toX = self.timeSliderBeginX_ + movedX
            if toX >= self.timeSliderRight_ then
                toX = self.timeSliderRight_
            elseif toX <= self.timeSliderLeft_ then
                toX = self.timeSliderLeft_
            end
            local node = nil
            local xx = nil
            for i=1,6,1 do
                node = self.nodeTime["time"..i]
                if node:isVisible() then
                    xx = node:getPositionX()
                    if math.abs(xx-toX)<70 then
                        self.nodeTime.btnTimeSlider:setPositionX(xx)
                        self.timeGroup_:getButtonAtIndex(i):setButtonSelected(true)
                        return
                    end
                end
            end
        end)
    
    self.typeTab_:gotoTab(self.timeIndex_, true)
    self.chipGroup_:getButtonAtIndex(self.baseIndex_):setButtonSelected(true)
    self.timeGroup_:getButtonAtIndex(self.guoQiIndex_):setButtonSelected(true)
end

function CreateView:changeDiamond()
    local guoQi = self.guoQi_[self.guoQiIndex_]
    if not guoQi then
        guoQi = self.guoQi_[1]
    end

    self.cost_ = self.diamondServer_[self.base_[self.baseIndex_].."_"..guoQi]
    self.nodeBottom.btnVipCreate:hide()

    if tonumber(self.cost_)<1 then
        self.nodeBottom.btnCreate:show()
        self.nodeBottom.btnCreate.labelDiamond:setString(1)
        self.nodeBottom.btnCreate.lineFree:show()
        self.nodeBottom.btnCreate.labelStart:setString(sa.LangUtil.getText("PRIVTE","CREATFREE"))
        ImgButton(self.nodeBottom.btnCreate,"#common/btn_big_yellow.png","#common/btn_big_yellow_down.png")
    else
        self.nodeBottom.btnCreate.labelDiamond:setString(self.cost_)
        -- if tx.checkIsVip() then
            -- self.nodeBottom.btnVipCreate:show()
            -- self.nodeBottom.btnCreate:hide()

            -- self.nodeBottom.btnVipCreate.labelDiamond:setString(self.cost_)
            -- self.nodeBottom.btnVipCreate.labelPrice:setString(self.cost_*self.privateDis_)

            -- sa.fitSprteWidth(self.nodeBottom.btnVipCreate.labelStart, 240)
        -- else
            self.nodeBottom.btnCreate:show()

            self.nodeBottom.btnCreate.lineFree:hide()
            self.nodeBottom.btnCreate.labelStart:setString(sa.LangUtil.getText("PRIVTE","CREATEROOM"))
        -- end
        ImgButton(self.nodeBottom.btnCreate,"#common/btn_big_blue.png","#common/btn_big_blue_down.png")
    end
    sa.fitSprteWidth(self.nodeBottom.btnCreate.labelStart, 240)
    
end

function CreateView:onCreateRoomClicked_()
    local cost = self.cost_
    if tx.checkIsVip() then
        cost = cost * self.privateDis_
    end

    if tx.userData.diamonds < cost then
        local expTime = self.guoQi_[self.guoQiIndex_]
        sa.EventCenter:dispatchEvent({name=tx.eventNames.PRIVATE_CREAT_RESULT})
        return
    end

    if not self.sendCreate_ then
        self.sendCreate_ = true
        local gameId = tx.config.TEXAS_GAME_ID
        local gameLevel = tx.config.TEXAS_PRI_ROOM_LEVEL -- 德州私人房默认等级为100
        local blind = self.base_[self.baseIndex_]
        local optTime = self.secend_[self.timeIndex_]
        local pwd = self.roomPwdEdit_:getText()
        local expTime = self.guoQi_[self.guoQiIndex_]
        tx.socket.HallSocket:createRoom(gameId,gameLevel,blind,optTime,pwd,expTime)
        self:performWithDelay(function()
            self.sendCreate_ = false
        end, 1)
    end
end

return CreateView