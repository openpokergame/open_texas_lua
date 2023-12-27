local TopTipManager = class("TopTipManager")

local MAX_WIDTH = 530

local Z_ORDER = 1002

function TopTipManager:ctor()
    -- 视图容器
    self.container_ = display.newNode()
    self.container_:retain()
end

-- callback:用于指定按钮点击事件
--[[
    topTipData = "str"
    topTipData = {
        text = "str",
        image = "#xx.png"
    }
--]]
-- toast 提示
function TopTipManager:showToast(topTipData,x,y)
    assert(type(topTipData) == "table" or type(topTipData) == "string", "topTipData should be a table or String")
    local str = nil
    local image = "#common/tips_toast_bg.png"
    local x = x or 0
    local y = y or 100
    if type(topTipData) == "string" then
        str = string.trim(topTipData)
    elseif type(topTipData)=="table" then
        str = topTipData.text and string.trim(topTipData.text)
        image = topTipData.image
    end
    if not str or str=="" then return; end

    if not self.container_:getParent() then
        self.container_:removeAllChildren()  -- 清楚之前场景的
        self.container_:pos(display.cx, display.cy)
            :addTo(tx.runningScene, Z_ORDER)
    end

    local bg = display.newScale9Sprite(image)
        :pos(x,y)
        :addTo(self.container_)
    bg:setCascadeOpacityEnabled(true)
    -- local label = ui.newTTFLabel({
    --         text=str,
    --         size=30,
    --         color=cc.c3b(0xff,0xff,0xff),
    --     })
    --     :addTo(bg)
    -- local size = label:getContentSize()
    -- if size.width>MAX_WIDTH then
    --     label:setDimensions(MAX_WIDTH, 0)
    --     size = label:getContentSize()
    -- end
    -- bg:setContentSize(cc.size(size.width+16,size.height+10))
    -- label:pos(size.width*0.5+8,size.height*0.5+5)
    -- bg:scale(display.width/MAX_WIDTH)
    ---**************************************
    local label = ui.newTTFLabel({
            text=str,
            size=36,
            color=cc.c3b(0xff,0xff,0xff),
        })
        :addTo(bg)
    local size = label:getContentSize()
    bg:setContentSize(cc.size(size.width+30,76))
    label:pos(size.width*0.5+15,size.height*0.5+18)
    -- 超出区域
    local endScale = 1
    if (size.width+30)>(display.width-200) then
        endScale = (display.width-200)/(size.width+30)
    end
    bg:scale(1.5*endScale)
    ---**************************************
    local scaleAction = cc.ScaleTo:create(0.15,endScale*1)
    local moveAndHide = cc.Spawn:create(
            cc.FadeOut:create(1),
            cc.EaseBackOut:create(cc.MoveBy:create(1, cc.p(0, 50)))
        )
    local sequence = transition.sequence({
        scaleAction,
        cc.DelayTime:create(0.8),
        moveAndHide,
        cc.CallFunc:create(function() 
            bg:removeFromParent()
        end),
    })
    bg:runAction(sequence)
end

-- 金边领奖提示/金边按钮交互提示
function TopTipManager:showGoldTips(tips,btnLabel,callback)
    if tips and type(tips)=="string" then
        tips = string.trim(tips)
        if tips=="" then tips=nil end
    else
        tips = nil
    end
    if not tips then return; end
    if btnLabel and type(btnLabel)=="string" then
        btnLabel = string.trim(btnLabel)
        if btnLabel=="" then btnLabel=nil end
    else
        btnLabel = nil
    end
    if not self.container_:getParent() then
        self.container_:removeAllChildren()  -- 清楚之前场景的
        self.container_:pos(display.cx, display.cy)
            :addTo(tx.runningScene, Z_ORDER)
    end
    local bg = display.newScale9Sprite("#common/tips_goldedge_bg.png", 0, 0, cc.size(760, 50), cc.rect(379,24,1,1))
        :pos(0,0)
        :addTo(self.container_)
    bg:setCascadeOpacityEnabled(true)
    local size = cc.size(display.width,140)
    if btnLabel then
        size = cc.size(display.width,208)
    end
    bg:setContentSize(size)
    local label = ui.newTTFLabel({
            text=tips,
            size=44,
            color=cc.c3b(0x96,0x58,0x01),
        })
        :addTo(bg)
    if btnLabel then
        local btn = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
            :setButtonLabel(ui.newTTFLabel({text = btnLabel, size = 40}))
            :setButtonSize(175, 64)
            :onButtonClicked(function()
                tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
                if bg:getParent() then
                    bg:removeFromParent()
                end
                if callback then
                    callback()
                end
            end)
            :pos(size.width*0.5,size.height*0.5 - 40)
            :addTo(bg)
        local btnLabel = btn:getButtonLabel("normal")
        sa.fitSprteWidth(btnLabel, 170)
        label:pos(size.width*0.5,size.height*0.5 + 35)
    else
        label:pos(size.width*0.5,size.height*0.5)
    end
    bg:setOpacity(0)
    local time = 0.6
    if btnLabel then
        time = 2
    end

    local sequence = transition.sequence({
        cc.FadeIn:create(0.2),
        cc.DelayTime:create(time),
        cc.FadeOut:create(0.2),
        cc.CallFunc:create(function()
            bg:removeFromParent()
        end),
    })
    tx.SoundManager:playSound(tx.SoundManager.SHOW_GOLD_TIPS)
    bg:runAction(sequence)
end

--[[
    显示左下角
    {
        uid:
        img:
        tips:
        btnLabel:
        callback
    }
]]
function TopTipManager:showBottomTips(param)
    if _G.isInTutorial then --正在新手教程
        return
    end
    if not param then return; end
    local uid = param.uid
    local img = param.img
    local sex = param.sex
    local tips = param.tips
    local btnLabel = param.btnLabel
    local callback = param.callback
    local width,height = 260, 320
    local offX,offY = 30,30
    local bg = display.newScale9Sprite("#common/pop_bg.png", 0, 0, cc.size(width+offX*2,height+offY*2))
        :pos(-width*0.5,height*0.5 + 10)
    -- 关闭窗口
    local closeFun = function()
        tx.PopupManager:removePopup(bg)
    end
    bg.onRemovePopup = function(obj,removeFunc)
        bg:stopAllActions()
        transition.moveTo(bg, {time=0.2, x=-width * 0.5, easing="OUT", onComplete=function()
            removeFunc()
        end})
    end
    bg.onShowPopup = function(obj)
        bg:stopAllActions()
        transition.moveTo(bg, {time=0.2, x=width * 0.5, easing="OUT", onComplete=function()
            bg:performWithDelay(closeFun, 5)
        end})
    end
    -- 点击背景重启定时器
    sa.TouchHelper.new(bg, function()
        bg:stopAllActions()
        bg:performWithDelay(closeFun, 3)
    end)
    local SimpleAvatar = require("openpoker.ui.SimpleAvatar")
    local avatar_ = SimpleAvatar.new()
        :pos(width*0.5+offX,height-65+offY)
        :addTo(bg)
    if sex == "f" then
        avatar_:setSpriteFrame("common/icon_female.png")
    else
        avatar_:setSpriteFrame("common/icon_male.png")
    end
    if img and type(img)=="string" and string.len(img)>5 then
        avatar_:loadImage(img)
    end

    local ScrollLabel = require("openpoker.ui.ScrollLabel")
    local dw,dh = width-40,height-200
    -- tips = "asdf;ajsd;flkja;sdkjf;asjkdf;kjas;difjqpwioerjka;dsfkja;sjkdf;ajksd;fkjas;dkfjiqojwer;jka;sdkjf;asjkdf"
    local label = ScrollLabel.new({
                text=tips,
                size=32,
                align = ui.TEXT_ALIGN_LEFT,
                valign = ui.TEXT_VALIGN_TOP,
                dimensions=cc.size(dw, dh)
            },{
                viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
            })
        :align(display.LEFT_TOP,dw*0.5+20+offX,144+offY)
        :addTo(bg,true) 
    label:setTouchNodeSwallowEnabled(false)

    local btn = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonLabel(ui.newTTFLabel({text = btnLabel, size = 32}))
        :setButtonSize(220, 104)
        :onButtonClicked(function()
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            closeFun()
            if callback then
                callback()
            end
        end)
        :pos(width*0.5+offX,45+offY)
        :addTo(bg)
    local btnLabel = btn:getButtonLabel("normal")
    sa.fitSprteWidth(btnLabel, 170)
    local closeBtn = cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
            :pos(width-18+offX, height-18+offY)
            :onButtonClicked(function()
                tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
                closeFun()
            end)
            :scale(0.7)
            :addTo(bg)
    tx.PopupManager:addPopup(bg, false, false, true, false)
end

return TopTipManager