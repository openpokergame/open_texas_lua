local TexasRoomScene = require("app.games.texas.RoomScene")
local GuideView = import(".GuideView")
local TutorialRoomScene = class("TutorialRoomScene", TexasRoomScene)

function TutorialRoomScene:ctor()
    _G.isInTutorial = true -- 在新手教程中  不能有其他信息干扰
	TutorialRoomScene.super.ctor(self, 0) -- 新手教程gameid 0

    self.guideView_ = GuideView.new(self):addTo(self,20)
end

function TutorialRoomScene:onMenuClick_()
    local RoomMenuPopup = require("app.games.texas.room.views.RoomMenuPopup")
    RoomMenuPopup.new(self.ctx,{2,3,4,5,6,7,8,9,10}):showPanel()
end

function TutorialRoomScene:doBackToHall(msg)
    self:requestOutRoom()
    TexasRoomScene.super.doBackToHall(self,msg)
end

function TutorialRoomScene:hideNotUseNode()
    if self.fastTaskNode_ then
        self.fastTaskNode_:dele()
        self.fastTaskNode_:hide()
    end
    if self.changeRoomBtn_ then self.changeRoomBtn_:hide() end
    if self.inviteBtn_ then self.inviteBtn_:hide() end
    if self.standupBtn_ then self.standupBtn_:hide() end
    if self.sendMoneyToDealerBtn_ then self.sendMoneyToDealerBtn_:hide() end
    if self.microphoneBtn_ then self.microphoneBtn_:hide() end
    -- if self.menuBtn_ then self.menuBtn_:hide() end
end
-- 显示自己的手牌
function TutorialRoomScene:doShowSelfHand(data)
    local seat = self.ctx.seatManager:getSelfSeatView()
    seat:setHandCardNum(2)
    seat:setHandCardValue(data)
    seat:showHandCardBackAll()
    seat:showAllHandCardsElement()
    seat:showHandCards()
    seat:flipAllHandCards()
end
-- 显示公共牌
function TutorialRoomScene:doShowPubHand(data)
    self.ctx.publicCardManager:showReconnect({pubCards = data})
    for i=1,5,1 do
        self.ctx.publicCardManager.cards[i]:flip()
    end
end
-- 重置桌面
function TutorialRoomScene:doReset()
    self.controller:reset()
end
-- 执行动作
function TutorialRoomScene:doAct(actData)
    self.controller:processPacket_(actData)
    self:hideNotUseNode()
end

function TutorialRoomScene:onCleanup()
    _G.isInTutorial = nil
    TutorialRoomScene.super.onCleanup(self)
end

-- 屏蔽功能
function TutorialRoomScene:dealSitDownView()
end

function TutorialRoomScene:updateShopIcon_()
end
return TutorialRoomScene