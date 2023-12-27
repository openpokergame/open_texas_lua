-- 选择游戏界面

local ChooseGameView = class("ChooseGameView", function ()
    return display.newNode()
end)

local logger = sa.Logger.new("ChooseGameView")

local LOGO_POS_X = display.cx - 260
local LOGO_POS_Y = 176
local BTN_NODE_SHOW_Y = -display.cy + 140
local BTN_NODE_HIDE_Y = -display.cy - 250

local TITLE_IMG = {
    "#lang/choose_game_title_texas.png",
    "#lang/choose_game_title_omaha.png",
    "#lang/choose_game_title_redblack.png"
}

function ChooseGameView:ctor()
    self.bg_ = display.newSprite("img/choose_game_bg.jpg")
        :addTo(self)

    local s = 1
    self.bg_:setScale(tx.widthScale * s)
    self.bg_:setTouchEnabled(true)
    self.bg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))

    self.isOpenOmaha_ = (tx.userData.switch_aomaha == 1)
    self.isOpenRedblack_ = (tx.userData.switch_honghei == 1)

    self:createChooseGameBtn_(1, -400, 0, handler(self, self.onTexasClicked_))
    local omahaBtn = self:createChooseGameBtn_(2, 0, 0, handler(self, self.onOmahaClicked_))
    local redblackBtn = self:createChooseGameBtn_(3, 400, 0, handler(self, self.onRedblackClicked_))

    local level = tx.userData.aomahLevelLimit
    if not self.isOpenOmaha_ or (tx.userData.level < level) then
        local lock = sp.SkeletonAnimation:create("spine/DZXC.json", "spine/DZXC.atlas")
            :pos(170, 150)
            :addTo(omahaBtn)
        lock:setAnimation(0, 2, false)

        if self.isOpenOmaha_ and tx.userData.level < level then
            ui.newTTFLabel({text=level, size = 26, color = cc.c3b(0x57, 0x2d, 0x08)})
                :pos(0, -14)
                :addTo(lock)
        end
    end

    level = tx.userData.hongheiLevelLimit
    if not self.isOpenRedblack_ or (tx.userData.level < level) then
        local lock = sp.SkeletonAnimation:create("spine/DZXC.json", "spine/DZXC.atlas")
            :pos(170, 150)
            :addTo(redblackBtn)
        lock:setAnimation(0, 2, false)

        if self.isOpenRedblack_ and tx.userData.level < level then
            ui.newTTFLabel({text=level, size = 26, color = cc.c3b(0x57, 0x2d, 0x08)})
                :pos(0, -14)
                :addTo(lock)
        end
    end
end

function ChooseGameView:createChooseGameBtn_(index, x, y, callback)
    local btn_w, btn_h = 368, 488
    local title_x, title_y = btn_w*0.5 - 17, 70

    local btn = sp.SkeletonAnimation:create("spine/XZAN.json","spine/XZAN.atlas")
        :size(cc.size(btn_w, btn_h))
        :align(display.CENTER, x, y)
        :addTo(self)
    btn:setAnimation(0, index, true)

    ScaleButton(btn, 0.95):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        callback()
    end)

    local titleS_ = display.newSprite(TITLE_IMG[index])
        :pos(title_x, title_y)
        :addTo(btn)

    if index == 2 and not self.isOpenOmaha_ then
        titleS_:setColor(cc.c3b(120,120,120))
    elseif index == 3 and not self.isOpenRedblack_ then
        titleS_:setColor(cc.c3b(120,120,120))
    end

    local emitter = cc.ParticleSystemQuad:create("particle/pp1.plist")
        :pos(title_x, 170)
        :addTo(btn)

    return btn
end

function ChooseGameView:onTexasClicked_()
    app:enterGameHall(1)
end

function ChooseGameView:onOmahaClicked_()
    if self.isOpenOmaha_ then
        local level = tx.userData.aomahLevelLimit
        if tx.userData.level >= level then
            app:enterGameHall(3)
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_LIMIT_LEVEL", level, level))
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function ChooseGameView:onRedblackClicked_()
    local hallScene = display.getRunningScene()
    if self.isOpenRedblack_ then
        local level = tx.userData.hongheiLevelLimit
        if tx.userData.level >= level then
            hallScene:requestRoom({gameId=tx.config.REDBLACK_GAME_ID, level=tx.config.REDBLACK_ROOM_LEVEL})
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_LIMIT_LEVEL", level, level))
        end
        
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("MATCH", "EXPECT_TIPS"))
    end
end

function ChooseGameView:onTouch_()
    tx.PopupManager:removePopup(self)
end

function ChooseGameView:showPanel()
    tx.PopupManager:addPopup(self)
end

function ChooseGameView:playShowAnim()
end

function ChooseGameView:playHideAnim()
end

return ChooseGameView
