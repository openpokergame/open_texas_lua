-- 定人赛弹出

local WIDTH, HEIGHT = 910, 690
local PopupReg = class("PopupReg", tx.ui.Panel)
PopupReg.ELEMENTS = {
    "innerBg.node1.iconRank",
    "innerBg.node1.iconChip",
    "innerBg.node1.labelAwardKey",
    "innerBg.node1.labelAwardValue",
    "innerBg.node1.iconDHQ",
    "innerBg.node1.labelDHQ",
    "innerBg.node2.iconRank",
    "innerBg.node2.iconChip",
    "innerBg.node2.labelAwardKey",
    "innerBg.node2.labelAwardValue",
    "innerBg.node3.iconRank",
    "innerBg.node3.iconChip",
    "innerBg.node3.labelAwardKey",
    "innerBg.node3.labelAwardValue",

    "btnReg.label",
    "btnCancel.label",

    "iconChip1",
    "iconChip2",
    "iconChip3",
    "labelCanSaiKey",
    "labelFuWuKey",
    "labelZiChanKey",
    "labelCanSaiValue",
    "labelFuWuValue",
    "labelZiChanValue",
    "labelStartChip",
    "labelStartBlind",
}

function PopupReg:initViews_()
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_match_reg.csb",true)

    local data = self.data_
    local reward = data.reward
    local len = #reward
    local x = 138
    local dir = 260
    if len == 2 then
        x = 206
        dir = 420
    end

    self.labelStartChip:setString(sa.LangUtil.getText("MATCH", "START_CHIPS") .. data.chip)
    self.labelStartBlind:setString(sa.LangUtil.getText("MATCH", "START_BLIND", data.startBlind, data.startBlind*2))

    for i = 1, 3 do
        self.innerBg["node" .. i]:hide()
    end

    for i = 1, len do
        self.innerBg["node" .. i]:show()
        self.innerBg["node" .. i]:setPositionX(x)
        self.innerBg["node" .. i].labelAwardKey:setString(sa.LangUtil.getText("MATCH", "REWARD_TITLE"))
        self.innerBg["node" .. i].labelAwardValue:setString(sa.formatBigNumber(reward[i].chips))
        x = x + dir
    end

    self.innerBg.node1.iconDHQ:hide()
    self.innerBg.node1.labelDHQ:hide()
    if reward[1].dhqReward > 0 then
        self.innerBg.node1.iconDHQ:show()
        self.innerBg.node1.labelDHQ:show():setString(reward[1].dhqReward)
    else
        self.innerBg.node1.iconChip:setPositionY(48)
        self.innerBg.node1.labelAwardValue:setPositionY(50)
    end

    self.labelCanSaiKey:setString(sa.LangUtil.getText("MATCH", "REGISTER_COST"))
    self.labelCanSaiValue:setString(data.registerCost)
    sa.fitSprteWidth(self.labelCanSaiKey, 190)

    self.labelFuWuKey:setString(sa.LangUtil.getText("MATCH", "SERVER_COST"))
    self.labelFuWuValue:setString(data.serverCost)

    self.labelZiChanKey:setString(sa.LangUtil.getText("MATCH", "TOTAL_MONEY"))
    self.labelZiChanValue:setString(sa.formatNumberWithSplit(tx.userData.money))

	self.btnReg.label:setString(sa.LangUtil.getText("MATCH", "REGISTER"))
	ImgButton(self.btnReg,"#common/btn_big_green.png","#common/btn_big_green_down.png"):onButtonClicked(function()
        if tx.userData.money >= (self.data_.registerCost + self.data_.serverCost) then
            tx.matchProxy:dealReg(self.data_.matchlevel)
            self:hidePanel_()
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "NOT_ENOUGH_MONEY"))
        end
	end)
	self.btnCancel.label:setString(sa.LangUtil.getText("COMMON", "CANCEL"))
	ImgButton(self.btnCancel,"#common/btn_big_blue.png","#common/btn_big_blue_down.png"):onButtonClicked(function()
		self:onClose()
	end)
end

function PopupReg:ctor(data)
	PopupReg.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("MATCH", "REGISTER"))
    self.data_ = data
	self:initViews_()
    self.regStatusChangeId_ = tx.matchProxy:addEventListener("MATCH_REG_STATUS_CHANGE", handler(self, self.onRegStatusChange_))
    self:onRegStatusChange_()
end

function PopupReg:onRegStatusChange_(evt)
    local matchlevel = self.data_.matchlevel
    local matchid = nil
    matchid = tx.matchProxy.regList and tx.matchProxy.regList[matchlevel]
    if matchid then
        self.btnReg.label:setString(sa.LangUtil.getText("MATCH", "UNREGISTER_2"))
    else
        self.btnReg.label:setString(sa.LangUtil.getText("MATCH", "REGISTER"))
    end
end

function PopupReg:onCleanup()
	tx.matchProxy:removeEventListener(self.regStatusChangeId_)
end

return PopupReg