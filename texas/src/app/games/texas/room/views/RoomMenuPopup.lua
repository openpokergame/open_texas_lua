local RoomMenuPopup = class("RoomMenuPopup", function() return display.newNode() end)

RoomMenuPopup.ELEMENTS = {
    "bg",
    "nodeBtns.btn1.icon",
    "nodeBtns.btn1.label",
    "nodeBtns.btn1.divLine",
    "nodeBtns.btn2.icon",
    "nodeBtns.btn2.label",
    "nodeBtns.btn2.divLine",
    "nodeBtns.btn3.icon",
    "nodeBtns.btn3.label",
    "nodeBtns.btn3.divLine",
    "nodeBtns.btn4.icon",
    "nodeBtns.btn4.label",
    "nodeBtns.btn4.divLine",
    "nodeBtns.btn5.icon",
    "nodeBtns.btn5.label",
    "nodeBtns.btn5.divLine",
    "nodeBtns.btn6.icon",
    "nodeBtns.btn6.label",
    "nodeBtns.btn6.divLine",
}

local HEIGHT = 0

function RoomMenuPopup:ctor(ctx, noShowList, roomlevel)
    self.ctx_ = ctx
    roomlevel = roomlevel or 1
    if not noShowList then noShowList = {} end
    tx.ui.EditPanel.bindElementsToTarget(self,"texas_room_menu.csb",true)
    local colorList = {
        cc.c3b(0x8b, 0xa7, 0xc0),
        cc.c3b(0xd7, 0xe5, 0xf5)
    }
    local btnList = {
        [1] = {
            "#commonroom/menu_back.png",
            "#commonroom/menu_back_down.png",
            sa.LangUtil.getText("ROOM", "BACK_TO_HALL"),
            1,   -- callBackParam
        },
        [2] = {
            "#commonroom/menu_change.png",
            "#commonroom/menu_change_down.png",
            sa.LangUtil.getText("ROOM", "CHANGE_ROOM"),
            2,
        },
        [3] = {
            "#commonroom/menu_info.png",
            "#commonroom/menu_info_down.png",
            sa.LangUtil.getText("ROOM","USER_INFO_ROOM"),
            3,
        },
        [4] = {
            "#commonroom/menu_record.png",
            "#commonroom/menu_record_down.png",
            sa.LangUtil.getText("USERINFO", "BOARD"),
            4,
        },
        [5] = {
            "#commonroom/invite_menu.png",
            "#commonroom/invite_menu_down.png",
            sa.LangUtil.getText("FRIEND", "ROOM_INVITE_TITLE"),
            5,
        },
        [6] = {
            "#commonroom/menu_set.png",
            "#commonroom/menu_set_down.png",
            sa.LangUtil.getText("ROOM", "SETTING"),
            6,
        },
    }
    for k,v in pairs(btnList) do
        self.nodeBtns["btn"..k]:hide()
    end
    for k,v in pairs(noShowList) do
        for kk,vv in pairs(btnList) do
            if vv[4]==v then
                table.remove(btnList,kk)
                break
            end
        end
    end

    local bgSize = self.bg:getContentSize()
    local itemSize = self.nodeBtns.btn1:getContentSize()
    itemSize.height = itemSize.height + 1
    local bgX,bgY = self.bg:getPosition()
    local nodeBtnsX,nodeBtnsY = self.nodeBtns:getPosition()
    local offY = math.abs(nodeBtnsY - bgY)
    self.bg:setContentSize(cc.size(bgSize.width,itemSize.height*#btnList+offY*2))
    HEIGHT = itemSize.height*#btnList+offY*2
    
    for k,v in pairs(btnList) do
        local btn = self.nodeBtns["btn"..k]
        btn.label:setString(v[3])
        -- sa.fitSprteWidth(btn.label, 190)
        btn.icon:setSpriteFrame(display.newSprite(v[1]):getSpriteFrame())
        ImgButton(btn,"#common/transparent.png","#commonroom/menu_down_bg.png")
            :onButtonPressed(function() 
                btn.icon:setSpriteFrame(display.newSprite(v[2]):getSpriteFrame())
            end)
            :onButtonRelease(function()
                btn.icon:setSpriteFrame(display.newSprite(v[1]):getSpriteFrame())
            end)
            :onButtonClicked(function()
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                self:hidePanel()
                -- if callback then
                --     callback(v[4])
                -- end
                if v[4]==1 then
                    if self.ctx_ and self.ctx_.scene and self.ctx_.scene.doBackToHall then
                        self.ctx_.scene:doBackToHall()
                    end
                elseif v[4]==2 then
                    if self.ctx_ and self.ctx_.scene and self.ctx_.scene.onChangeRoomClick_ then
                        self.ctx_.scene:onChangeRoomClick_()
                    end
                elseif v[4]==3 then
                    if self.ctx_ and self.ctx_.model then
                        local UserInfoPopup = require("app.module.userInfo.UserInfoPopup")
                        local tableAllUid, toUidArr = self.ctx_.model:getTableAllUid()
                        local tableNum = self.ctx_.model:getNumInSeat()
                        local tableMessage = {tableAllUid = tableAllUid,toUidArr = toUidArr,tableNum = tableNum}
                        UserInfoPopup.new(self.ctx_):show(true,tableMessage)
                    end
                elseif v[4]==4 then
                    local GameRecordPopup = require("app.module.gamerecord.GameRecordPopup")
                    GameRecordPopup.new(true):showPanel()
                elseif v[4]==5 then
                    if self.ctx_ and self.ctx_.model then
                        local InvitePlayPopup = require("app.module.room.inviteplay.InvitePlayPopup")
                        InvitePlayPopup.new(self.ctx_.model):showPanel()
                    end
                elseif v[4]==6 then
                    local SettingPopup = require("app.module.setting.SettingPopup")
                    SettingPopup.new(true, roomlevel):showPanel()
                end
            end)
        if k==#btnList then
            btn.divLine:hide()
        else
            btn.divLine:show()
        end
        btn:show()
    end
end

function RoomMenuPopup:showPanel()
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function RoomMenuPopup:hidePanel(immediatlyClose)
    self.immediatlyClose_ = immediatlyClose
    tx.PopupManager:removePopup(self)
end

function RoomMenuPopup:onShowPopup()
    self:pos(0,display.top+HEIGHT)
    self:stopAllActions()
    transition.moveTo(self, {time=0.15, y=display.top, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
    end})
end

function RoomMenuPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    if self.immediatlyClose_ then
        removeFunc()
    else
        transition.moveTo(self, {time=0.15, y=display.top + HEIGHT, easing="OUT", onComplete=function() 
            removeFunc()
        end})
    end
end

return RoomMenuPopup