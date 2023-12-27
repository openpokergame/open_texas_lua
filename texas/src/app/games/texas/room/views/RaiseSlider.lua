local OperationButton = import(".OperationButton")

local RaiseSlider = class("RaiseSlider", function()
    return display.newNode()
end)
RaiseSlider.showRaiseAnim__ = 1 --首次显示的时候要展示

function RaiseSlider:ctor(width)
    RaiseSlider.showRaiseAnim__ = 100000
    -- 左右分别有10透明像素
    self.writeSpace_ = 10
    self.itemWidth_ = 132 -- =!=!=一列的高度
    self.topHeight_ = 100 -- 顶部高度
    self.padding_ = (width - self.itemWidth_*2)/3  -- 间距
    local backgroundWidth = width+self.writeSpace_*2
    local backgroundHeight = display.height-88+self.writeSpace_*2
    local labelWidth = 146  --按钮宽
    local labelHeight = 98  -- 按钮高
    local btnX = (-self.padding_-self.itemWidth_)*0.5+5
    local btnTop = 148  -- 第一个按钮
    local btnGap = 116  -- 按钮间距
    local btnViewH = 82  -- 按钮可视高度去掉阴影部分
    local trackX = (self.padding_+self.itemWidth_)*0.5
    self.trackX__ = trackX
    -- x*3+50/64*2*x+82*4 = display.height-88-self.topHeight_
    btnGap = (display.height-88-self.topHeight_-btnViewH*4)/(3+50/64*2)  -- 空白间距
    btnTop = backgroundHeight * 0.5-self.writeSpace_-self.topHeight_-btnViewH*0.5-50/64*btnGap
    btnGap = btnGap + btnViewH  --按钮间距
    local optHeight = btnGap*3+btnViewH  -- 可操作区域空间（滚动空间）
    --背景
    self.background_ = display.newScale9Sprite("#texas/room/raise_bg.png", 0, 0, cc.size(backgroundWidth, backgroundHeight))
        :addTo(self)
    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    --顶部文字背景
    self.labelBackground_ = display.newSprite("#texas/room/raise_text_bg.png")
        :addTo(self)
    local labelBgSize = self.labelBackground_:getContentSize()
    self.labelBackground_:pos(0,backgroundHeight * 0.5-labelBgSize.height*0.5-self.writeSpace_+1)

    local trackY = -self.topHeight_*0.5
    RaiseSlider.THUMB_BOUND_TOP = trackY + optHeight*0.5 - 22  --22是筹码高度的一半
    RaiseSlider.THUMB_BOUND_BOTTOM = trackY - optHeight*0.5 + 22
    RaiseSlider.THUMB_BOUND_HEIGHT = RaiseSlider.THUMB_BOUND_TOP - RaiseSlider.THUMB_BOUND_BOTTOM

    --加注Slider背景
    self.trackBackground_ = display.newSprite("#texas/room/raise_track_bg.png", trackX, trackY):addTo(self)
    local size = self.trackBackground_:getContentSize()
    local height = size.height-50 -- 上下各25像素的空白区域
    local scaleY = optHeight/height
    self.trackBackground_:setScaleY(scaleY)
    self.trackBackground_:setTouchEnabled(true)
    self.trackBackground_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.trackBGonTouch_))
    -- 背景点击区域
    self.bgTouchTop_ = trackY + height*scaleY
    self.bgTouchButtom_ = trackY - height*scaleY

    --
    self.batchNode_ = display.newBatchNode("texas_room_texture.png")
        :pos(trackX,0)
        :addTo(self)
    local num = math.ceil(RaiseSlider.THUMB_BOUND_HEIGHT/15)
    self.chipsList_ = {}
    local chip = nil
    local originalY = nil
    for i=1,num,1 do
        originalY = RaiseSlider.THUMB_BOUND_BOTTOM+(i-1)*15
        chip = display.newSprite("#texas/room/raise_chips.png")
            :pos(0,originalY)
            :addTo(self.batchNode_)
            :hide()
        chip.originalY = originalY
        self.chipsList_[i]=chip
    end
    if self.chipsList_[1] then
        self.chipsList_[1]:show()
    end

    --加注Slider按钮
    self.thumb_ = display.newNode()
        :pos(trackX, RaiseSlider.THUMB_BOUND_BOTTOM)
        :addTo(self)
    -- self.thumb_ = display.newSprite("#texas/room/raise_chips.png")
    -- self.thumb_:pos(trackX, RaiseSlider.THUMB_BOUND_BOTTOM)
    -- self.thumb_:addTo(self)

    --全部奖池按钮
    self.btnAllPot_ = tx.ui.SimpleButton.new({
        label = sa.LangUtil.getText("ROOM", "BUYIN_ALL_POT"),
        width = labelWidth,
        height = labelHeight,
        up={
            background={
                texture="#texas/room/raise_up.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        down={
            background={
                texture="#texas/room/raise_down.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        disabled={
            background={
                texture="#texas/room/raise_disabled.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(0x95, 0x8c, 0xff)
            }
        }
    }, 1):onClicked(handler(self, self.onButtonClicked_)):pos(btnX, btnTop):enabled(true):addTo(self)

    --3/4奖池按钮
    self.btn3QPot_ = tx.ui.SimpleButton.new({
        label = sa.LangUtil.getText("ROOM", "BUYIN_3QUOT_POT"),
        width = labelWidth,
        height = labelHeight,
        up={
            background={
                texture="#texas/room/raise_up.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        down={
            background={
                texture="#texas/room/raise_down.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        disabled={
            background={
                texture="#texas/room/raise_disabled.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(0x95, 0x8c, 0xff)
            }
        }
    }, 2):onClicked(handler(self, self.onButtonClicked_)):pos(btnX, btnTop - btnGap):enabled(true):addTo(self)

    --1/2奖池按钮
    self.btnHalfPot_ = tx.ui.SimpleButton.new({
        label = sa.LangUtil.getText("ROOM", "BUYIN_HALF_POT"),
        width = labelWidth,
        height = labelHeight,
        up={
            background={
                texture="#texas/room/raise_up.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        down={
            background={
                texture="#texas/room/raise_down.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        disabled={
            background={
                texture="#texas/room/raise_disabled.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(0x95, 0x8c, 0xff)
            }
        }
    }, 3):onClicked(handler(self, self.onButtonClicked_)):pos(btnX, btnTop - 2 * btnGap):enabled(true):addTo(self)

    --3倍反加
    self.btnTriple_ = tx.ui.SimpleButton.new({
        label = sa.LangUtil.getText("ROOM", "BUYIN_TRIPLE"),
        width = labelWidth,
        height = labelHeight,
        up={
            background={
                texture="#texas/room/raise_up.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        down={
            background={
                texture="#texas/room/raise_down.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(255, 255, 255)
            }
        },
        disabled={
            background={
                texture="#texas/room/raise_disabled.png",
                scale9 = true
            },
            label={
                type="ttf",
                size=20,
                color=cc.c3b(0x95, 0x8c, 0xff)
            }
        }
    }, 4):onClicked(handler(self, self.onButtonClicked_)):pos(btnX, btnTop - 3 * btnGap):enabled(true):addTo(self)

    self.label_ = display.newBMFontLabel({text = "0", font = "fonts/shangcheng.fnt"})
        :pos(self.labelBackground_:getPositionX(), self.labelBackground_:getPositionY()+11)
        :addTo(self)

    ImgButton(self.labelBackground_,"#texas/room/raise_text_bg.png","#texas/room/raise_text_bg_down.png"):onButtonClicked(function()
            self:onButtonClicked_(6)
        end)

    --all in 按钮
    local s = self.labelBackground_:getContentSize()
    self.btnAllin_ = ImgButton(display.newSprite("#texas/room/raise_ALL_IN.png"),"#texas/room/raise_ALL_IN.png","#texas/room/raise_ALL_IN_down.png")
        :pos(self.labelBackground_:getPositionX(), self.labelBackground_:getPositionY())
        :setButtonEnabled(true)
        :onButtonClicked(function()
            self:onButtonClicked_(5)
        end)
        :addTo(self)
        :hide()
    self.allinAnim_ = sp.SkeletonAnimation:create("spine/ALLIN.json","spine/ALLIN.atlas")
        :pos(140,18)
        :addTo(self.btnAllin_)
    self.btnAllin_.show = function(obj)
        cc.Node.show(obj)
        self.allinAnim_:setAnimation(0, "2", false)
        tx.SoundManager:playSound(tx.SoundManager.RAISETOTOP)
    end

    self:setValueRange(0, 0)
    self:setSliderPercentValue(0)
end

function RaiseSlider:showPanel()
    self:setSliderPercentValue(0)
    if RaiseSlider.showRaiseAnim__>0 then -- 显示动画
        if not self.raiseGuideAnim_ then
            self.raiseGuideAnim_ = sp.SkeletonAnimation:create("spine/ALLIN.json","spine/ALLIN.atlas")
                :pos(self.trackX__,RaiseSlider.THUMB_BOUND_BOTTOM)
                :addTo(self)
        end
        self.raiseGuideAnim_:show()
        self.raiseGuideAnim_:setAnimation(0, "1", true)
    else
        if self.raiseGuideAnim_ then
            self.raiseGuideAnim_:hide()
        end
    end
    return self:show()
end

function RaiseSlider:setButtonStatus(allPotEnabled, q3PotEnabled, halfPotEnabled, tripleEnabled, isMaxAllin)
    self.btnAllPot_:enabled(allPotEnabled)
    self.btn3QPot_:enabled(q3PotEnabled)
    self.btnHalfPot_:enabled(halfPotEnabled)
    self.btnTriple_:enabled(tripleEnabled)
    if allPotEnabled then
        self.btnAllPot_:setOpacity(255)
    -- else
    --     self.btnAllPot_:setOpacity(120)
    end
    if q3PotEnabled then
        self.btn3QPot_:setOpacity(255)
    -- else
    --      self.btn3QPot_:setOpacity(120)
    end
    if halfPotEnabled then
        self.btnHalfPot_:setOpacity(255)
    -- else
    --     self.btnHalfPot_:setOpacity(120)
    end
    if tripleEnabled then
        self.btnTriple_:setOpacity(255)
    -- else
    --     self.btnTriple_:setOpacity(120)
    end
    self.isMaxAllin_ = isMaxAllin
end

function RaiseSlider:hidePanel()
    self:setSliderPercentValue(0)
    return self:hide()
    -- self:show()
    -- return self
end

function RaiseSlider:onButtonClicked(callback)
    self.buttonClickedCallback_ = callback
    return self
end

function RaiseSlider:setValueRange(valueMin, valueMax, step)
    self.step_ = step
    self.valueMin_ = valueMin
    self.valueMax_ = valueMax
    if self.step_ then
        if self.step_>self.valueMax_ then
            self.step_ = self.valueMax_
        end
        if self.valueMin_<self.step_ then
            self.valueMin_ = self.step_
        end
    end
    self.valueRange_ = self.valueMax_ - self.valueMin_
    return self
end

function RaiseSlider:setValue(val)
    if self.valueRange_ and self.valueRange_ > 0 then
        self:setSliderPercentValue(val / self.valueRange_)
    else
        self:setSliderPercentValue(0)
    end
    return self
end

function RaiseSlider:getValue()
    local value_ = math.round(self:getSliderPercentValue() * self.valueRange_ + self.valueMin_)
    if self.step_ then
        -- fixBug AllIn 返回值无法达到allin
        if value_>=self.valueMax_ then
            return self.valueMax_
        end
        local mul = math.round(value_/self.step_)
        local checkValue_ = mul * self.step_
        if checkValue_>self.valueMax_ then
            checkValue_ = self.valueMax_
        elseif checkValue_<self.valueMin_ then
            checkValue_ = self.valueMin_
        end
        return checkValue_
    else
        return value_
    end
end

function RaiseSlider:setSliderPercentValue(newVal)
    assert(newVal >= 0 and newVal <= 1, "slider value must be between 0 and 1")
    self.thumb_:setPositionY(RaiseSlider.THUMB_BOUND_BOTTOM + RaiseSlider.THUMB_BOUND_HEIGHT * newVal)
    self:onSliderPercentValueChanged_(newVal, true)
    return self
end

function RaiseSlider:getSliderPercentValue()
    return (self.thumb_:getPositionY() - RaiseSlider.THUMB_BOUND_BOTTOM) / RaiseSlider.THUMB_BOUND_HEIGHT
end

function RaiseSlider:onSliderPercentValueChanged_(newVal, forceUpdate, needSound)
    if self.percentValue_ ~= newVal or forceUpdate then
        self.percentValue_ = newVal
        if newVal == 1 then
            if self.isMaxAllin_ then
                if self.allinState_ ~= true then
                    self.btnAllin_:stopAllActions()
                    self.btnAllin_:show()
                    self.btnAllin_:runAction(cc.FadeTo:create(0.75, 255))
                    -- 透明啊
                    self.labelBackground_:hide()
                    self.label_:hide()
                end
                self.allinState_ = true
            else
                self.btnAllin_:stopAllActions()
                self.btnAllin_:hide()
                -- 透明啊
                self.labelBackground_:show()
                self.label_:show()
            end
        else
            if self.isMaxAllin_ then
                if self.allinState_ ~= false then
                    self.btnAllin_:stopAllActions()
                    self.btnAllin_:setOpacity(0.2 * 255)
                    self.btnAllin_:hide()
                    -- 透明啊
                    self.labelBackground_:show()
                    self.label_:show()
                end
                self.allinState_ = false
            else
                self.btnAllin_:stopAllActions()
                self.btnAllin_:hide()
                -- 透明啊
                self.labelBackground_:show()
                self.label_:show()
            end
        end
        self.prevValue_ = self.curValue_
        self.curValue_ = self:getValue()
        local curTime = sa.getTime()
        local prevTime = self.lastRaiseSliderGearTickPlayTime_ or 0
        if needSound and self.prevValue_ ~= self.curValue_  and curTime - prevTime > 0.05 then
            self.lastRaiseSliderGearTickPlayTime_ = curTime
            tx.SoundManager:playSound(tx.SoundManager.GEAR_TICK)
            -- tx.SoundManager:playSound(tx.SoundManager.RAISEMOVE)
        end
        -- self.label_:setString(self.curValue_)
        self.label_:setString(sa.formatBigNumber(self.curValue_))

        if forceUpdate and not needSound then
            self:dealSlider_(true)
        else
            self:dealSlider_(false)
        end

        if self.addBtn_ then
            self.addBtn_:getButtonLabel("normal"):setString(sa.formatBigNumber(self.curValue_))
        end
    end
end

function RaiseSlider:dealSlider_(isOnece)
    local thumbY = self.thumb_:getPositionY()
    local len = #self.chipsList_
    local chip = nil
    local xx = nil
    if self.chipsList_[1] then
        self.chipsList_[1]:show()--第一个永远展示
    end
    local showAnimNum = 0
    local distance = 0
    for i=1,len,1 do
        chip = self.chipsList_[i]
        if chip.originalY<thumbY then
            if not chip:isVisible() then
                if math.random()>0.5 then
                    xx = math.random()*10
                else
                    xx = -math.random()*10
                end
                chip:setPositionX(xx)
                chip:stopAllActions()
                chip:setOpacity(0)
                chip:setPositionY(chip.originalY+100)
                local spawn = cc.Spawn:create(
                    cc.FadeIn:create(0.2),
                    cc.MoveTo:create(0.2 , cc.p(xx, chip.originalY))
                )
                if isOnece then -- 一次性往下掉
                    local sequence = transition.sequence({
                        cc.DelayTime:create(0.01*showAnimNum),
                        spawn
                    })
                    if showAnimNum==0 then
                        distance = thumbY - chip.originalY
                        -- 播放声音
                        tx.SoundManager:playSound(tx.SoundManager.RAISETOCENTER)
                    end
                    chip:setPositionY(thumbY+showAnimNum*4)
                    chip:runAction(sequence)
                else
                    chip:runAction(spawn)
                end
                showAnimNum = showAnimNum + 1
            end
            chip:show()
        else
            for j=i,len,1 do
                chip = self.chipsList_[j]
                chip:stopAllActions()
                chip:hide()
            end
            break;
        end
    end
    if self.chipsList_[1] then
        self.chipsList_[1]:show()--第一个永远展示
    end
end

function RaiseSlider:setAddBtn(btn)
    self.addBtn_ = btn
end

function RaiseSlider:trackBGonTouch_(evt)
    local name, x, y, prevX, prevY = evt.name, evt.x, evt.y, evt.prevX, evt.prevY
    local isTouchInSprite = self.trackBackground_:getCascadeBoundingBox():containsPoint(cc.p(x, y))
    if name == "began" then
        if isTouchInSprite then
            if self.raiseGuideAnim_ then -- 加注引导
                RaiseSlider.showRaiseAnim__ = RaiseSlider.showRaiseAnim__ - 1
                self.raiseGuideAnim_:hide()
            end
            self.isTrackBGTouching_ = true
            self.trackBGTouchBeginY_ = y
            local coord = self:convertToNodeSpace(cc.p(x, y))
            local toY = coord.y
            if toY<=self.bgTouchTop_ and toY>=self.bgTouchButtom_ then
                if toY >= RaiseSlider.THUMB_BOUND_TOP then
                    toY = RaiseSlider.THUMB_BOUND_TOP
                elseif toY <= RaiseSlider.THUMB_BOUND_BOTTOM then
                    toY = RaiseSlider.THUMB_BOUND_BOTTOM
                end
                self.thumb_:setPositionY(toY)
                local val = (toY - RaiseSlider.THUMB_BOUND_BOTTOM) / RaiseSlider.THUMB_BOUND_HEIGHT
                self:onSliderPercentValueChanged_(val, true, false)
                return true
            else
                return false
            end
        else
            return false
        end
    elseif not self.isTrackBGTouching_ then
        return false
    elseif name == "moved" then
        local coord = self:convertToNodeSpace(cc.p(x, y))
        local toY = coord.y
        if toY >= RaiseSlider.THUMB_BOUND_TOP then
            toY = RaiseSlider.THUMB_BOUND_TOP
        elseif toY <= RaiseSlider.THUMB_BOUND_BOTTOM then
            toY = RaiseSlider.THUMB_BOUND_BOTTOM
        end
        self.thumb_:setPositionY(toY)
        local val = (toY - RaiseSlider.THUMB_BOUND_BOTTOM) / RaiseSlider.THUMB_BOUND_HEIGHT
        self:onSliderPercentValueChanged_(val, false, true)
    elseif name == "ended"  or name == "cancelled" then
        self.isTrackBGTouching_ = false
    end
    return true
end

function RaiseSlider:onButtonClicked_(tag)
    tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
    if self.buttonClickedCallback_ and (
            tag == 1 and self.btnAllPot_:isEnabled() or
            tag == 2 and self.btn3QPot_:isEnabled() or
            tag == 3 and self.btnHalfPot_:isEnabled() or
            tag == 4 and self.btnTriple_:isEnabled() or
            tag == 5 and self.btnAllin_:isButtonEnabled()) or
            tag == 6 then
        self.buttonClickedCallback_(tag)
    end
end

return RaiseSlider