local RoomViewPosition = require("app.games.texas.room.views.RoomViewPosition")
local P = require("app.games.texas.net.PROTOCOL")

local GuideView = class("GuideView", function() return display.newNode() end)
local ScrollLabel = import("openpoker.ui.ScrollLabel")

GuideView.ELEMENTS = {
	"nodeTips.tips1.label",
	"nodeTips.tips2.label",
	"nodeTips.tips3.label",
	"nodeTips.tips4.label",
	"nodeTips.tips5.label",
	"nodeTips.tips6.label",
	"nodeTips.tips7.label",
	"nodeTips.tips8.label",
	"nodeTips.tips9.label",
	"nodeTips.light1",
	"nodeTips.light2",
	"nodeTips.light3",
	"nodeTips.light4",
	"nodeTips.light5",
	"nodeTips.arrow",

	"nodeCard.tipsCards",
	"nodeCard.btnCard1.label",
	"nodeCard.btnCard2.label",
	"nodeCard.btnCard3.label",
}

function GuideView:ctor(scene)
	self:initDoActData()
	self:setNodeEventEnabled(true)
	self.touchHelper_ = sa.TouchHelper.new(self, handler(self, self.onBGTouch_))
	self.scene_ = scene
	self.ctx = self.scene_.ctx
	tx.ui.EditPanel.bindElementsToTarget(self,"tutorial.csb",true)

	self:addcrollLabel_()

	-- 重新赋值设置文本
	local originalSetStr = self.nodeCard.btnCard1.label.setString
	local newSetStr = function(obj,str)
		originalSetStr(obj,str)
		sa.fitSprteWidth(obj,155)
	end
	self.nodeCard.btnCard1.label.setString = newSetStr
	self.nodeCard.btnCard2.label.setString = newSetStr
	self.nodeCard.btnCard3.label.setString = newSetStr
	-- tips
	local tipsList = sa.LangUtil.getText("TUTORIAL","TIPS")
	local curLabel = nil
	local curTips = nil
	local tipsSize = nil
	for i=1,9,1 do
		curTips = self.nodeTips["tips"..i]
		curTips:hide()
		curLabel = curTips.label
		curLabel:setString(tipsList[i])
		tipsSize = curTips:getContentSize()
		sa.fitSprteWidth(curLabel, tipsSize.width-20)
	end
	-- 调整坐标
	local seatP = RoomViewPosition.SeatPosition
	self.nodeTips.tips1:pos(80,display.height-50)
	self.nodeTips.tips2:pos(display.width-80,display.height-50)
	self.nodeTips.tips3:pos(seatP[8].x+50,seatP[8].y+35)
	self.nodeTips.tips4:pos(seatP[10].x-300,seatP[10].y-220)
	self.nodeTips.tips5:pos(display.width-35,display.cy+40)
	self.nodeTips.tips6:pos(seatP[5].x-110,seatP[5].y+80)
	self.nodeTips.tips7:pos(seatP[5].x+200,seatP[5].y+70)
	self.nodeTips.tips8:pos(display.width-300,80)
	self.nodeTips.tips9:pos(80,50)
	self.nodeTips.light1:pos(seatP[10].x+233,seatP[10].y-375)
	self.nodeTips.light2:pos(seatP[10].x+324,seatP[10].y-144)
	self.nodeTips.light3:pos(seatP[10].x+324,seatP[10].y-144)

	for i=1,3,1 do
		ImgButton(self.nodeCard["btnCard"..i],"#tutorial/btn_up.png","#tutorial/btn_down.png")
			:onButtonClicked(function(evt)
				self:onButtonHandler(i)
			end)
	end
	self.nodeTips:pos(0,0)
	self.nodeCard:pos(display.width,display.height)
	self.nodeCard:setTouchEnabled(true)
	NormalButton(self.nodeTips.light4):onButtonClicked(function(evt)
			if self.lightFun_ then
				self.lightFun_(self)
			end
		end)
	-- 屏蔽场景点击事件
	self.leftBottomNode_ = display.newSprite("#tutorial/tips_direction.png")
		:pos(-200,-200)
		:addTo(self)
	self.rightTopNode_ = display.newSprite("#tutorial/tips_direction.png")
		:pos(display.width+200,display.height+200)
		:addTo(self)
	-- -- 添加返回
	-- self.backBtn_ = cc.ui.UIPushButton.new({normal = "#commonroom/menu.png",pressed = "#commonroom/menu_down.png"})
 --        :onButtonClicked(buttontHandler(self.scene_, self.scene_.doBackToHall))
 --        :pos(50, display.height-48)
 --        :addTo(self)
 --    self.backBtn_:setRotation(90)
 	self.backBtn_ = cc.ui.UIPushButton.new({normal = "#common/transparent.png"}, {scale9 = true})
 		:setButtonSize(80, 80)
        :onButtonClicked(buttontHandler(self.scene_, self.scene_.onMenuClick_))
        :pos(50, display.height-48)
        :addTo(self)

    self:checkDoAct()
end

function GuideView:addcrollLabel_()
	local x, y = self.nodeCard.tipsCards:getPosition()
	self.nodeCard.tipsCards:hide()
	local dw, dh = 530, 170
	self.nodeCard.tipsCards = ScrollLabel.new({
            text="",
            size=32,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(dw, dh)
        },
        {
            viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
        })
		:pos(x, y)
        :addTo(self.nodeCard)
end

function GuideView:onCleanup()
	-- 清楚Http
	sa.HttpService.CANCEL(self.getAwardRequestId_)
	display.removeSpriteFramesWithFile("tutorial_texture.plist", "tutorial_texture.png")
end

function GuideView:onBGTouch_(target, evt, isInSprite, touchData)
	if not evt or not touchData then return; end
	if evt==sa.TouchHelper.TOUCH_BEGIN then
		self:checkDoAct()
	end
end
function GuideView:guessTrue()
	self.nodeCard.tipsCards:setString(sa.LangUtil.getText("TUTORIAL","GUESS_TRUE_"..self.doActIdx_))
	self.nodeCard.btnCard1:hide()
	self.nodeCard.btnCard3:hide()
	self.nodeCard.btnCard2:show()
	self.nodeCard.btnCard2.label:setString(sa.LangUtil.getText("TUTORIAL","NEXT_STEP"))
	self:availableDoNext()
	self.btn2Fun_ = self.checkDoAct
end
function GuideView:guessFalse()
	self.nodeCard.tipsCards:setString(sa.LangUtil.getText("TUTORIAL","GUESS_FLASE"))
	-- 按照BOSS的意思显示重新选择
	self.btn2Fun_ = self.goToPreStep
	self.nodeCard.btnCard2.label:setString(sa.LangUtil.getText("TUTORIAL","RE_SELECT"))
	self.nodeCard.btnCard2:show()
	self.nodeCard.btnCard1:hide()
	self.nodeCard.btnCard3:hide()
end
function GuideView:goToPreStep()
	self.doActIdx_ = self.doActIdx_ - 1
	if self.doActIdx_<0 then
		self.doActIdx_ = 0
	end
	self:forceDoNext()
end
-- 
function GuideView:onButtonHandler(idx)
	tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
	if idx==1 then
		if self.btn1Fun_ then
			self.btn1Fun_(self)
		end
	elseif idx==2 then
		if self.btn2Fun_ then
			self.btn2Fun_(self)
		end
	elseif idx==3 then
		if self.btn3Fun_ then
			self.btn3Fun_(self)
		end
	elseif idx==4 then
		self.scene_:doBackToHall()
	end
end
function GuideView:getViewAward()
	-- 
end
function GuideView:init()
	if tx.userData and tx.userData.tutorial_getted==1 then
		
	end
end
-- 
function GuideView:showSelfAnim(onlyAnim)
	if not onlyAnim then
		self.nodeTips.tips7:show()
	end
	self.nodeTips.light1:show()
	self.nodeTips.light1:stopAllActions()
	self.nodeTips.light1:setOpacity(0)
	self.nodeTips.light1:performWithDelay(function()
		self.nodeTips.light1:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
end
function GuideView:showPubAnim1()
	self.nodeTips.tips4:show()
	self.nodeTips.light2:show()
	self.nodeTips.light2:stopAllActions()
	self.nodeTips.light2:setOpacity(0)
	self.nodeTips.light2:performWithDelay(function()
		self.nodeTips.light2:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
end
function GuideView:showCardTypeList()
	self.backBtn_:hide()
	if self.scene_ and self.scene_.onCardTypeClick_ then
		self.scene_:onCardTypeClick_()
	end
end
function GuideView:showPubAnim2()
	self:showCardTypeList()
	self.nodeTips.light3:show()
	self.nodeTips.light3:stopAllActions()
	self.nodeTips.light3:setOpacity(0)
	self.nodeTips.light3:performWithDelay(function()
		self.nodeTips.light3:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
	self:showSelfAnim(true)
	self.nodeTips.light5:show()
	self.nodeTips.light5:stopAllActions()
	self.nodeTips.light5:setOpacity(255)
	self.nodeTips.light5:setSpriteFrame(display.newSprite("#tutorial/edge_light.png"):getSpriteFrame())
    local curScale = tx.heightScale
	self.nodeTips.light5:setContentSize(cc.size(408*curScale,100*curScale))
	self.nodeTips.light5:pos(199*curScale,display.height-101*curScale)
end
function GuideView:hideCardTips(flag)
	self.backBtn_:hide()
	self.backBtn_:show()  -- 反正都是透明的
	if self.scene_ and self.scene_.cardTypePopup_ and self.scene_.cardTypePopup_.playHideAnimation then
		self.scene_.cardTypePopup_:playHideAnimation()
	end
	self:performWithDelay(function()
		if flag==1 then  -- 游戏结束
			self:forceDoNext(0.2)
		end
	end,0.4)
end
function GuideView:startGame(data)
	if data then
		self.scene_:doAct(data)
		-- 大小盲注
		self.scene_:doAct({
				cmd = P.SVR_BET_SUCCESS,
				seatId = data.bigSeatId,
				uid =data.bigSeatId,
				betState = consts.SVR_BET_STATE.BIG_BLIND,
				betChips = data.bigChips
			})
		self.scene_:doAct({
				cmd = P.SVR_BET_SUCCESS,
				seatId = data.smallSeatId,
				uid =data.smallSeatId,
				betState = consts.SVR_BET_STATE.SMALL_BLIND,
				betChips = data.smallChips
			})
		self:performWithDelay(function()
			self.scene_:doAct({
				cmd = P.SVR_TURN_TO_BET,
				seatId = data.dealerSeatId,
				callChips = data.bigChips,
				minRaiseChips = data.bigChips*2,
				maxRaiseChips = 5000,
			})
			self.nodeTips.tips8:show()
			self:showOptLight(1,3)
		end,0.5)
	end
end
function GuideView:showOptLight(idx,num)
	-- 提示闪闪
	local OperationButton = require("app.games.texas.room.views.OperationButton")
	local btnWidth = OperationButton.BUTTON_WIDTH
	local size = self.nodeTips.light4:getContentSize()
	local optBtn = self.ctx.oprManager["oprBtn"..idx.."_"]
	local optBtnParent = optBtn:getParent()
	local tempWorldPt = optBtnParent:convertToWorldSpace(cc.p(optBtn:getPosition()))
    local tempLocalPt = self.nodeTips:convertToNodeSpace(tempWorldPt)
    self.nodeTips.light4:setPositionX(tempLocalPt.x)
    local yy = self.nodeTips.light4:getPositionY()
	self.nodeTips.light4:setSpriteFrame(display.newSprite("#tutorial/edge_light.png"):getSpriteFrame())
	if num==3 then  -- 提示
		self.nodeTips.light4:setContentSize(cc.size(btnWidth*3+54,size.height))
	else -- 提示
		self.nodeTips.light4:setContentSize(cc.size(btnWidth+30,size.height))
		self.nodeTips.arrow:show()
		self.nodeTips.arrow:setOpacity(0)
		self.nodeTips.arrow:stopAllActions()
		self.nodeTips.arrow:pos(tempLocalPt.x+50,yy+100+50)
		self.nodeTips.arrow:performWithDelay(function()
			self.nodeTips.arrow:setOpacity(255)
			self.nodeTips.arrow:runAction(
			cc.RepeatForever:create(
				transition.sequence({
		            cc.MoveTo:create(0.5, cc.p(tempLocalPt.x,yy+100)),
		            cc.MoveTo:create(0.5, cc.p(tempLocalPt.x+50,yy+100+50)),
	        })))
		end,0.5)
	end
	self.nodeTips.light4:show()
	self.nodeTips.light4:stopAllActions()
	self.nodeTips.light4:setOpacity(0)
	self.nodeTips.light4:performWithDelay(function()
		self.nodeTips.light4:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
end
-- 跟注
function GuideView:showOptCall()
	self.lightFun_ = self.forceDoNext
	self:showOptLight(1,1)
end
-- 跟注
function GuideView:showOptRaise(num)
	self.lightFun_ = self.forceDoNext
	self:showOptLight(3,1)
	local optBtn = self.ctx.oprManager["oprBtn3_"]
	if optBtn and num then
		self:performWithDelay(function()  -- 操作区域会延迟0.5秒...
			optBtn:setLabel(sa.LangUtil.getText("ROOM","RAISE_NUM",num or 0))
		end,0.6)
	end
end
-- 显示加注
function GuideView:showPlayerOptLight(flag)
	local seatP = RoomViewPosition.SeatPosition
	self.nodeTips.light5:show()
	self.nodeTips.light5:stopAllActions()
	self.nodeTips.light5:setOpacity(0)
	self.nodeTips.light5:setSpriteFrame(display.newSprite("#tutorial/edge_light.png"):getSpriteFrame())
	self.nodeTips.light5:setContentSize(cc.size(124+34,186+34))
	if flag==1 then -- 加注
		self.nodeTips.light5:pos(seatP[8].x,seatP[8].y)
	elseif flag==2 then  -- 弃牌
		self.nodeTips.light5:pos(seatP[3].x,seatP[3].y)
	end
	self.nodeTips.light5:performWithDelay(function()
		self.nodeTips.light5:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
end
function GuideView:doGameOver(delay)
	self:forceDoNext(delay)
end
-- 显示比牌结果
function GuideView:showCompareResult()
	self:showCardTypeList()
	self.nodeTips.light5:show()
	self.nodeTips.light5:stopAllActions()
	self.nodeTips.light5:setOpacity(0)
	self.nodeTips.light5:setSpriteFrame(display.newSprite("#tutorial/edge_light.png"):getSpriteFrame())
	local curScale = tx.heightScale
	self.nodeTips.light5:setContentSize(cc.size(408*curScale,180*curScale))
	self.nodeTips.light5:pos(199*curScale,display.height-353*curScale)
	self.nodeTips.light5:performWithDelay(function()
		self.nodeTips.light5:runAction(
		cc.RepeatForever:create(
			transition.sequence({
	            cc.FadeIn:create(0.4),
	            cc.DelayTime:create(0.2),
	            cc.FadeOut:create(0.4),
        })))
	end,0.5)
end
-- 显示比牌结果
function GuideView:showOtherTips()
	self.nodeTips.tips1:show()
	-- self.nodeTips.tips2:show()
	self.nodeTips.tips3:show()
	self.nodeTips.tips5:show()
	self.nodeTips.tips6:show()
	self.nodeTips.tips9:show()
end
-- 教程结束
function GuideView:showComplete()
	local showSystemDialog = function(msg)
		tx.ui.Dialog.new({
	        hasCloseButton = true,
	        messageText = msg,
	        firstBtnText = sa.LangUtil.getText("TUTORIAL", "FINISH_FIRST_BTN"),
	        secondBtnText = sa.LangUtil.getText("TUTORIAL", "FINISH_SECOND_BTN"),
	        callback = function (type)
	        	if type == tx.ui.Dialog.FIRST_BTN_CLICK then
	        		self:forceDoNext()
	            elseif type == tx.ui.Dialog.SECOND_BTN_CLICK then
	              	self.scene_:changeRoomFromQuickStart()
	           	elseif type == tx.ui.Dialog.CLOSE_BTN_CLICK then
	           		self.scene_:doBackToHall()
	            end
	        end
	    }):show()
	end
	if tx.userData and tx.userData.tutorial_getted==0 then
    	if device.platform == "android" or device.platform == "ios" then
	        cc.analytics:doCommand{
	            command = "eventCustom",
	            args = {
	                eventId = "completed_tutorial",
	                attributes = "count",
	                counter = 1
	            }
	        }
	    end
		self:setLoading(true)
		sa.HttpService.CANCEL(self.getAwardRequestId_)
		self.getAwardRequestId_ = sa.HttpService.POST({
	            mod = "Beginners",
	            act = "reward",
	        },
	        function(data)
	        	self:setLoading(false)
	        	local retData = json.decode(data)
	        	if retData and retData.code==1 then
	        		tx.userData.needTutorial = nil -- 不要再引导了吧
	        		tx.userData.tutorial_getted = 1 -- 已经看完啦
	        		local reward = retData.reward
	        		local evtData = {}
	        		if reward.money and tonumber(reward.money) and tonumber(reward.money)>0 then
			            evtData.money = reward.money
			            tx.userData.money = tx.userData.money + tonumber(reward.money)
			            showSystemDialog(sa.LangUtil.getText("TUTORIAL", "FINISH_AWARD_TIPS",reward.money))
			            tx.TopTipManager:showGoldTips(""..reward.money)
			        else
			        	showSystemDialog(sa.LangUtil.getText("TUTORIAL", "FINISH_NOAWARD_TIPS"))
			        end
			        if reward.props then
			            evtData.props = reward.props
			        end
			        if reward.diamond then
						tx.userData.diamonds = tx.userData.diamonds + tonumber(reward.diamond)
						evtData.diamonds = reward.diamond
	              	end
	              	sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
	        	else
	        		showSystemDialog(sa.LangUtil.getText("TUTORIAL", "FINISH_NOAWARD_TIPS"))
	        	end
	        end,
	        function(data)
	        	self:setLoading(false)
	        	showSystemDialog(sa.LangUtil.getText("TUTORIAL", "FINISH_NOAWARD_TIPS"))
	        end)
	else
		showSystemDialog(sa.LangUtil.getText("TUTORIAL", "FINISH_NOAWARD_TIPS"))
	end
end
-- 触屏可点击
function GuideView:availableDoNext()
	self.canDoAct_ = true
end
-- 强制执行下一步
function GuideView:forceDoNext(delay)
	if not delay or delay==0 then
		self.canDoAct_ = true
		self:checkDoAct()
	else
		self:performWithDelay(function()
			self.canDoAct_ = true
			self:checkDoAct()
		end,delay)
	end
end
-- 手动loading
function GuideView:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(display.cx, display.cy)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end
function GuideView:checkDoAct()
	if not self.canDoAct_ then return; end
	for i=1,9,1 do
		self.nodeTips["tips"..i]:hide()
	end
	for i=1,5,1 do
		self.nodeTips["light"..i]:hide()
	end
	self:setLoading(false)
	self.backBtn_:show()
	self.nodeTips.arrow:hide()
	self.nodeCard:hide()
	self.lightFun_ = nil -- 闪光区按钮
	self.btn1Fun_ = nil -- 第一个按钮操作
	self.btn2Fun_ = nil -- 第二个按钮操作
	self.btn3Fun_ = nil -- 第三个按钮操作
	self.canDoAct_ = false
	self.doActIdx_ = self.doActIdx_ + 1
	local stepLen = #self.guideData_
	if self.doActIdx_>stepLen then
		self.doActIdx_ = 1
	end
	local data = self.guideData_[self.doActIdx_]
	-- 可执行下一个动作
	if data["delay"] then
		self:stopAllActions()
		self:performWithDelay(function()
			self.canDoAct_ = true
		end,data["delay"])
	end
	if data["beforeACT"] and self.scene_[data["beforeACT"]] then
		self.scene_[data["beforeACT"]](self.scene_,data["beforeACTData"])
	end
	if data["ACT"] and self.scene_[data["ACT"]] then
		self.scene_[data["ACT"]](self.scene_,data["ACTData"])
	end
	if data["selfACT"] and self[data["selfACT"]] then
		self[data["selfACT"]](self,data["selfACTData"])
	end
	-- 提示面板
	if data["panelTips"] then
		self.nodeCard:show()
		self.nodeCard.tipsCards:setString(data["panelTips"])
		if data["btn1"] then
			self.nodeCard.btnCard1:show()
			self.nodeCard.btnCard1.label:setString(data["btn1"])
			self.btn1Fun_ = self[data["btnACT1"]]
		else
			self.nodeCard.btnCard1:hide()
		end
		if data["btn2"] then
			self.nodeCard.btnCard2:show()
			self.nodeCard.btnCard2.label:setString(data["btn2"])
			self.btn2Fun_ = self[data["btnACT2"]]
		else
			self.nodeCard.btnCard2:hide()
		end
		if data["btn3"] then
			self.nodeCard.btnCard3:show()
			self.nodeCard.btnCard3.label:setString(data["btn3"])
			self.btn3Fun_ = self[data["btnACT3"]]
		else
			self.nodeCard.btnCard3:hide()
		end
	else
		self.nodeCard:hide()
	end
end

function GuideView:initDoActData()
	self.canDoAct_ = true -- 可以执行动作
	self.doActIdx_ = 0  -- 当前执行的索引
	local cardTypes = sa.LangUtil.getText("HELP", "RULE_DESC")
	local selfId = tx.userData.uid
	local selfSeat = 0
	local tutorial_award = (tx.userData and tx.userData.tutorial_award)
	if not tutorial_award then
		tutorial_award = 8000
	end
	local selfRaise = 500
	local u1 = {
        uid = 3,
        nick = "Alice",
        img = "",
        sex = "f",
        money = 5000,
        giftId = 0,
    }
    local u2 = {
    	uid = 7,
        nick = "Jack",
        img = "",
        sex = "m",
        money = 5000,
        giftId = 0,
	}

	-- 引导数据
	self.guideData_ = {
		[1] = {
			delay = 0.5,   -- 点击背景的延迟
			beforeACT = "doReset", -- 执行前回调函数
			beforeACTData = nil, -- 执行前回调数据
			selfACT = "init", -- 当前类要执行的函数
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_1", tutorial_award),  -- 提示文字
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),  -- 第二个按钮的文字
			btnACT2 = "checkDoAct",  -- 第二个按钮执行的函数
			ACT = "doAct",  --执行函数
			ACTData = {     --执行数据
	            cmd = P.SVR_LOGIN_SUCCESS,
	            blind=50,
	            minBuyIn = 1,
	            maxBuyIn = 100,
	            roomName = "",
	            tid = 1,
	            roomType = 1,
	            userChips = 5000,
	            betExpire = 100, -- 1/10秒为单位
	            gameStatus = 1,
	            seatNum = 9,
	            dealerSeatId = 0,
	            pots = {},
	            pubCards = {},
	            bettingSeatId = -1,
	            leftTime = 9,
	            callChips = 100,
	            minRaiseChips = 200,
	            maxRaiseChips = 900,
	            playerList = {
	                {seatId=selfSeat,uid=selfId, info=json.encode(tx.getUserInfo(false)), seatChips=5000, playing=0, betChips=0, betState=8, handCards={0,0},},
	                {seatId=u1.uid,  uid=u1.uid, info=json.encode(u1),                    seatChips=5000, playing=0, betChips=0, betState=8, handCards={0,0},},
	                {seatId=u2.uid,  uid=u2.uid, info=json.encode(u2),                    seatChips=5000, playing=0, betChips=0, betState=8, handCards={0,0},},
	            },
	        },
		},
		[2] = {
			delay = 1,
			ACT = "doShowSelfHand",
			ACTData = {0x3D, 0x31},
			selfACT = "showSelfAnim",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_2"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[3] = {
			delay = 1,
			ACT = "doShowPubHand",
			ACTData = {0x06, 0x19, 0x3A, 0x3B, 0x3C},
			selfACT = "showPubAnim1",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_3"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[4] = {
			delay = 1,
			selfACT = "showCardTypeList",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_4"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[5] = {
			delay = 1,
			selfACT = "showPubAnim2",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_5"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[6] = {
			delay = 1,
			selfACT = "hideCardTips",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_6"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[7] = {
			delay = 1,
			beforeACT = "doReset",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_7"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			selfACT = "startGame",
			selfACTData = {     --执行数据
	            cmd = P.SVR_GAME_START,
	            playerList = {
	                {seatId=selfSeat,uid=selfId, seatChips=5000},
	                {seatId=u1.uid,  uid=u1.uid, seatChips=5000},
	                {seatId=u2.uid,  uid=u2.uid, seatChips=5000},
	            },
	            userChips = 200,
	            dealerSeatId = selfSeat,
	            bigSeatId = u2.uid,
	            bigChips = 100,
	            smallSeatId = u1.uid,
	            smallChips = 50,
	            handCard1 = 0x31,
	            handCard2 = 0x19,
	        },
		},
		[8] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_8"),
			selfACT = "showOptCall",
		},
		[9] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = selfSeat,
				uid = selfId,
				betState = consts.SVR_BET_STATE.CALL,
				betChips = 100,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u1.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			},
		},
		[10] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u1.uid,
				uid = u1.uid,
				betState = consts.SVR_BET_STATE.CALL,
				betChips = 100,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u2.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			},
		},
		[11] = {
			delay = 1,
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_11"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u2.uid,
				uid = u2.uid,
				betState = consts.SVR_BET_STATE.CHECK,
				betChips = 100,
			},
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_POT,
				pots = {300},
				allInHandCards = {},
			}
		},
		[12] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_DEAL_PUB_CARD,
				type = 3,
				pubCards = {0x11,0x1D,0x16},
			},
			selfACT = "forceDoNext",
			selfACTData = 1,
		},
		[13] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_13"),
			btn1 = cardTypes[6],
			btnACT1 = "guessFalse",
			btn2 = cardTypes[5],
			btnACT2 = "guessFalse",
			btn3 = cardTypes[9],
			btnACT3 = "guessTrue",
		},
		[14] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_14"),
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = selfSeat,
				callChips = 0,
				minRaiseChips = 100,
				maxRaiseChips = 4900,
			},
			selfACT = "showOptCall",
		},
		[15] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = selfSeat,
				uid = selfId,
				betState = consts.SVR_BET_STATE.CHECK,
				betChips = 0,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u1.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			},
		},
		[16] = {    -- 加注
			delay = 1,
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u1.uid,
				uid = u1.uid,
				betState = consts.SVR_BET_STATE.RAISE,
				betChips = 1000,
			},
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_16",u1.nick),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			selfACT = "showPlayerOptLight",
			selfACTData = 1,
		},
		[17] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u2.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
		},
		[18] = {   -- 弃牌
			delay = 1,
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_18",u2.nick),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			selfACT = "showPlayerOptLight",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u2.uid,
				uid = u2.uid,
				betState = consts.SVR_BET_STATE.FOLD,
				betChips = 0,
			}
		},
		[19] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_19"),
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = selfSeat,
				callChips = 1000,
				minRaiseChips = 2000,
				maxRaiseChips = 5000,
			},
			selfACT = "showOptCall",
		},
		[20] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = selfSeat,
				uid = selfId,
				betState = consts.SVR_BET_STATE.CALL,
				betChips = 1000,
			},
			selfACT = "forceDoNext",
			selfACTData = 0.3,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_POT,
				pots = {2300},
				allInHandCards = {},
			}
		},
		[21] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_DEAL_PUB_CARD,
				type = 4,
				pubCards = {0x39},
			},
			selfACT = "forceDoNext",
			selfACTData = 0.5,
		},
		[22] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_22"),
			btn1 = cardTypes[8],
			btnACT1 = "guessTrue",
			btn2 = cardTypes[9],
			btnACT2 = "guessFalse",
			btn3 = cardTypes[6],
			btnACT3 = "guessFalse",
		},
		[23] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_23", selfRaise),
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = selfSeat,
				callChips = 0,
				minRaiseChips = 100,
				maxRaiseChips = 3900,
			},
			selfACT = "showOptRaise",
			selfACTData = selfRaise,
		},
		[24] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = selfSeat,
				uid = selfId,
				betState = consts.SVR_BET_STATE.RAISE,
				betChips = selfRaise,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u1.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			}
		},
		[25] = {
			delay = 1,
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_25", u1.nick),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u1.uid,
				uid = u1.uid,
				betState = consts.SVR_BET_STATE.RAISE,
				betChips = selfRaise,
			},
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_POT,
				pots = {3300},
				allInHandCards = {},
			}
		},
		[26] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_DEAL_PUB_CARD,
				type = 5,
				pubCards = {0x09},
			},
			selfACT = "forceDoNext",
			selfACTData = 0.5,
		},
		[27] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_27"),
			btn1 = cardTypes[4],
			btnACT1 = "guessTrue",
			btn2 = cardTypes[5],
			btnACT2 = "guessFalse",
			btn3 = cardTypes[7],
			btnACT3 = "guessFalse",
		},
		[28] = {
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = u1.uid,
				callChips = 0,
				minRaiseChips = 0,
				maxRaiseChips = 0,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
		},
		[29] = {
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_29", u1.nick),
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = u1.uid,
				uid = u1.uid,
				betState = consts.SVR_BET_STATE.ALL_IN,
				betChips = 3400,
			},
			selfACT = "showOptRaise",
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_TURN_TO_BET,
				seatId = selfSeat,
				callChips = 3400,
				minRaiseChips = 3400,
				maxRaiseChips = 3400,
			},
		},
		[30] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_BET_SUCCESS,
				seatId = selfSeat,
				uid = selfId,
				betState = consts.SVR_BET_STATE.ALL_IN,
				betChips = 3400,
			},
			selfACT = "forceDoNext",
			selfACTData = 2,
			ACT = "doAct",
			ACTData = {
				cmd = P.SVR_POT,
				pots = {10100},
				allInHandCards = {},
			}
		},
		[31] = {
			beforeACT = "doAct",
			beforeACTData = {
				cmd = P.SVR_GAME_OVER,
				isTutorialGuide = true,
				playerList = {
					{
						seatId = selfSeat,
						uid = selfId,
						changeChips = 5100,
						pretaxWinChips = 5100,
						exp = 0,
						seatChips = 10100,
						handCard1 = 0x31,
						handCard2 = 0x19,
						cardType = consts.CARD_TYPE.FULL_HOUSE,
						status = 0,
					},
					{
						seatId = u1.uid,
						uid = u1.uid,
						changeChips = -5000,
						exp = 0,
						seatChips = 0,
						handCard1 = 0x1B,
						handCard2 = 0x1C,
						cardType = consts.CARD_TYPE.FLUSH,
						status = 0,
					},
				},
				potsList = {
					{
						potChips = 10100,
						winList = {
							{
								seatId = selfSeat,
								uid = selfId,
								card1 = 0x31,
								card2 = 0x19,
								card3 = 0x11,
								card4 = 0x39,
								card5 = 0x09,
								winChips = 5100,
							}
						}
					}
				},
			},
			selfACT = "doGameOver",
			selfACTData = 4,
		},
		[32] = {
			delay = 1,
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_32", u1.nick),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
			selfACT = "showCompareResult",
		},
		[33] = {
			beforeACT = "doReset",
			selfACT = "hideCardTips",
			selfACTData = 1,   -- 内部执行下一步
		},
		[34] = {
			delay = 1,
			selfACT = "showOtherTips",
			panelTips = sa.LangUtil.getText("TUTORIAL", "ROOM_STEP_34"),
			btn2 = sa.LangUtil.getText("TUTORIAL", "NEXT_STEP"),
			btnACT2 = "checkDoAct",
		},
		[35] = {
			selfACT = "showComplete",
		},
	}
end

return GuideView