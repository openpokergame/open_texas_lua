-- 查看所有玩家
local PlayerPopup = class("PlayerPopup", tx.ui.Panel)
local PlayerListItem = import(".PlayerListItem")
local OtherUserRoomPopup = import("app.module.userInfo.OtherUserRoomPopup")
local UserInfoPopup = import("app.module.userInfo.UserInfoPopup")

local WIDTH, HEIGHT = 910, 690
local FRAME_W, FRAME_H = WIDTH - 56, HEIGHT - 140

function PlayerPopup:ctor(ctx)
	PlayerPopup.super.ctor(self, {WIDTH, HEIGHT})

    self.ctx = ctx
    self:setNodeEventEnabled(true)

    self.updatePlayerDataId_ = sa.EventCenter:addEventListener(tx.eventNames.REDBLACK_ALL_PLAYER_LIST, handler(self, self.updatePlayerData_))

    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(FRAME_W, FRAME_H))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 30)
        :addTo(self.background_)

    local list_w, list_h = FRAME_W, FRAME_H - 10
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        PlayerListItem
    )
    :pos(FRAME_W*0.5, FRAME_H*0.5)
    :addTo(frame)

    self.list_.onItemClickListener = handler(self, self.onItemClicked_)
    self:addCloseBtn()
    self:setLoading(true)
end

function PlayerPopup:transformData(data)
    local ret = {}
    local row_num = 2
    if data then
        for i, v in ipairs(data) do
            local m = math.floor(i / row_num) + 1
            local n = i % row_num
            if n == 0 then
                n = row_num
                m = m - 1
            end
            if not ret[m] then
                ret[m] = {}
            end
            ret[m][n] = json.decode(v.userInfo)
            ret[m][n].seatId = v.seatId
			ret[m][n].uid = v.uid
            ret[m][n].money = v.money
        end
    end
    return ret
end

function PlayerPopup:updatePlayerData_(evt)
    self:setLoading(false)
    local data = self:transformData(evt.data)
    self:setTextTitleStyle(sa.LangUtil.getText("REDBLACK", "ALL_PLAYER", #evt.data))
    self.list_:setData(data, true)
end

function PlayerPopup:onItemClicked_(data)
    if data.uid ~= tx.userData.uid then
        OtherUserRoomPopup.new(self.ctx, data):showPanel()
    else
        UserInfoPopup.new():show(false)
    end
end

function PlayerPopup:onShowed()
    self.list_:setScrollContentTouchRect()
    local curScene = tx.runningScene
    local needRequest = true
    if curScene and curScene.controller then
        local allUserList = curScene.controller.allUserList
        local getAllUserListTime = curScene.controller.getAllUserListTime
        if allUserList then
            self:updatePlayerData_({data=allUserList})
            local nowTime = os.time()
            if getAllUserListTime and (nowTime-getAllUserListTime)<=5 then
                needRequest = false
            end
        end
    end
    if needRequest then
        if curScene and curScene.controller then
            curScene.controller.getAllUserListTime = os.time()
        end
        tx.socket.HallSocket:sendGameCmd("sendAllUserInfo")
    end
end

function PlayerPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.updatePlayerDataId_)
end

return PlayerPopup