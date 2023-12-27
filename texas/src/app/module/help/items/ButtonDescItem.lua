local ButtonDescItem = class("ButtonDescItem", sa.ui.ListItem)

local TITLEHEIGHT = 55
local WIDTH, HEIGHT = 800, 130
local BTN_W, BTN_H = 200, 86

function ButtonDescItem:ctor()
	ButtonDescItem.super.ctor(self, WIDTH, HEIGHT)
	local bg = display.newNode()
        :size(WIDTH, HEIGHT)
		:align(display.CENTER, WIDTH/2, HEIGHT/2)
		:addTo(self)

    self.btn_ = display.newScale9Sprite("#dialogs/help/red_btn_icon.png", 0, 0, cc.size(BTN_W, BTN_H))
        :align(display.LEFT_CENTER, 30, HEIGHT/2)
        :addTo(bg)

    self.point_ = display.newSprite("#dialogs/help/btn_point.png")
        :pos(30, BTN_H/2)
        :addTo(self.btn_)

    self.title_ = ui.newTTFLabel({text = "", size = 26})
        :pos(BTN_W/2, BTN_H/2)
        :addTo(self.btn_)

    self.desc_ = ui.newTTFLabel({
            text="",
            color=styles.FONT_COLOR.CONTENT_TEX,
            size=24,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions=cc.size(WIDTH - 300, 0)
        })
        :align(display.LEFT_CENTER, 240, HEIGHT/2)
        :addTo(bg)
end

function ButtonDescItem:onDataSet(dataChanged, data)
    if data and dataChanged then
        self.btn_:setSpriteFrame(display.newSprite(data.img):getSpriteFrame())
            :setPreferredSize(cc.size(BTN_W, BTN_H))
        if data.type == 1 then
            self.point_:hide()
        else
            self.point_:show()
            self.title_:setPositionX(BTN_W/2 + 15)
        end

        self.title_:setString(data.title)
        sa.fitSprteWidth(self.title_, 150)
        self.desc_:setString(data.desc)
    end
end

function ButtonDescItem:onCleanup()
end

return ButtonDescItem;