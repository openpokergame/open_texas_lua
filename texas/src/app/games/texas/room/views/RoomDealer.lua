local RoomDealer = class("RoomDealer", function ()
    return display.newNode()
end)

-- 暂定所有荷官的动作帧数 时间 一样
-- 不同荷官只有美术资源的不同 和 相应的位置坐标的不同
local DealerInfo = {
    [1] = {
        dealerBody = '#dealer1/room_dealer.png', -- 荷官
        tapTablePos = {0, 0},
        tapTable = {
            'dealer1/room_dealer_tap_table_1.png',
            'dealer1/room_dealer_tap_table_2.png',
            'dealer1/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0, 0},
        blinkTwoEyes = {
            'dealer1/room_dealer_blink_1.png',
            'dealer1/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0, 0},
        singleBlink = {
            'dealer1/room_dealer_single_blink_1.png',
            'dealer1/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0, 0},
        kissPlayer = {
            'dealer1/room_dealer_kiss_1.png',
            'dealer1/room_dealer_kiss_2.png',
        },
    },

    [2] = {
        dealerBody = '#dealer2/room_dealer.png', -- 荷官
        tapTablePos = {0, 0},
        tapTable = {
            'dealer2/room_dealer_tap_table_1.png',
            'dealer2/room_dealer_tap_table_2.png',
            'dealer2/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0, 0},
        blinkTwoEyes = {
            'dealer2/room_dealer_blink_1.png',
            'dealer2/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0, 0},
        singleBlink = {
            'dealer2/room_dealer_single_blink_1.png',
            'dealer2/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0, 0},
        kissPlayer = {
            'dealer2/room_dealer_kiss_1.png',
            'dealer2/room_dealer_kiss_2.png',
        },
    },

    [3] = {
        dealerBody = '#dealer3/room_dealer.png',
        tapTablePos = {0, 0},
        tapTable = {
            'dealer3/room_dealer_tap_table_1.png',
            'dealer3/room_dealer_tap_table_2.png',
            'dealer3/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0, 0},
        blinkTwoEyes = {
            'dealer3/room_dealer_blink_1.png',
            'dealer3/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0, 0},
        singleBlink = {
            'dealer3/room_dealer_single_blink_1.png',
            'dealer3/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0, 0},
        kissPlayer = {
            'dealer3/room_dealer_kiss_1.png',
            'dealer3/room_dealer_kiss_2.png',
        },
    },
    [4] = {
        dealerBody = '#dealer4/room_dealer.png',
        dealerBodyPos = {0,5},
        tapTablePos = {0,5},
        tapTable = {
            'dealer4/room_dealer_tap_table_1.png',
            'dealer4/room_dealer_tap_table_2.png',
            'dealer4/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0,5},
        blinkTwoEyes = {
            'dealer4/room_dealer_blink_1.png',
            'dealer4/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0,5},
        singleBlink = {
            'dealer4/room_dealer_single_blink_1.png',
            'dealer4/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0,5},
        kissPlayer = {
            'dealer4/room_dealer_kiss_2.png',
            'dealer4/room_dealer_kiss_1.png',
        },
    },
    [5] = {
        dealerBody = '#dealer5/room_dealer.png',
        dealerBodyPos = {0,0},
        tapTablePos = {0,0},
        tapTable = {
            'dealer5/room_dealer_tap_table_1.png',
            'dealer5/room_dealer_tap_table_2.png',
            'dealer5/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0,0},
        blinkTwoEyes = {
            'dealer5/room_dealer_blink_1.png',
            'dealer5/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0,0},
        singleBlink = {
            'dealer5/room_dealer_single_blink_1.png',
            'dealer5/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0,0},
        kissPlayer = {
            'dealer5/room_dealer_kiss_2.png',
            'dealer5/room_dealer_kiss_1.png',
        },
    },
    [6] = {
        dealerBodyPos = {0,0},
        dealerBody = '#dealer6/room_dealer.png', -- 荷官
        tapTablePos = {0, 0},
        tapTable = {
            'dealer6/room_dealer_tap_table_1.png',
            'dealer6/room_dealer_tap_table_2.png',
            'dealer6/room_dealer_tap_table_3.png',
        },
        -- 眨两只眼睛动画
        blinkTwoEyePos = {0, 0},
        blinkTwoEyes = {
            'dealer6/room_dealer_blink_1.png',
            'dealer6/room_dealer_blink_2.png',
        },
        singleBlinkPos = {0, 0},
        singleBlink = {
            'dealer6/room_dealer_single_blink_1.png',
            'dealer6/room_dealer_single_blink_2.png',
        },
        kissPlayerPos = {0, 0},
        kissPlayer = {
            'dealer6/room_dealer_kiss_1.png',
            'dealer6/room_dealer_kiss_2.png',
        },
    },
}
-- 比赛场荷官
local MatchDealerInfo = {
    [1] = DealerInfo[6],
    [2] = DealerInfo[2],
    [3] = DealerInfo[3],
}

function RoomDealer:ctor(dealerId,isMatch,clickCallback)
    assert(dealerId == math.floor(dealerId) and dealerId >= 1 and dealerId <= #DealerInfo)
    self.clickCallback_ = clickCallback
   
    self.batchNode_ = display.newNode()
        :addTo(self)

    if isMatch == true then
        self.ti = MatchDealerInfo[dealerId]
    else
        self.ti = DealerInfo[dealerId]
        
        self.pushArea_ = cc.ui.UIPushButton.new({normal="#common/transparent.png"}, {scale9 = true})
            :setButtonSize(100,150)
            :onButtonClicked(buttontHandler(self,self.onDealerPush_))
            :addTo(self)
    end

    self.mainBody_ = display.newSprite(self.ti.dealerBody)
        :addTo(self.batchNode_)
    
    local coord = self.ti.dealerBodyPos
    if coord then
        self.mainBody_:setPosition(coord[1],coord[2])
    end
    self.tapSpr_ = display.newSprite('#' .. self.ti.tapTable[1])
        :pos(unpack(self.ti.tapTablePos))
        :addTo(self.batchNode_)
    self.blinkTwoEyesAction_ = self.mainBody_:schedule(handler(self, self.blinkTwoEyes_), 3)
end

function RoomDealer:onDealerPush_()
    if self.clickCallback_ then
        self.clickCallback_()
    end
end

function RoomDealer:killLoop()
    -- if self.mainBody_ and self.blinkTwoEyesAction_ then
        self.mainBody_:stopAction(blinkTwoEyesAction_)
        self.blinkTwoEyesAction_ = nil
    -- end
end

function RoomDealer:blinkTwoEyes_()
    local blinkTwoSpr = display.newSprite('#' .. self.ti.blinkTwoEyes[1])
        :pos(unpack(self.ti.blinkTwoEyePos))
        :addTo(self.batchNode_)
    blinkTwoSpr:performWithDelay(function ()
        blinkTwoSpr:setSpriteFrame(self.ti.blinkTwoEyes[2])
    end, 0.05)
    blinkTwoSpr:performWithDelay(function ()
        blinkTwoSpr:setSpriteFrame(self.ti.blinkTwoEyes[1])
    end, 0.15)
    blinkTwoSpr:performWithDelay(function ()
        blinkTwoSpr:removeFromParent()
    end, 0.20)
end

-- 亲嘴玩家
function RoomDealer:kissPlayer()
    -- 先眨眼
    if self.blinkSingleSpr_ then
        self.blinkSingleSpr_:removeFromParent()
    end
    self.blinkSingleSpr_ = display.newSprite('#' .. self.ti.singleBlink[1])
        :pos(unpack(self.ti.singleBlinkPos))
        :addTo(self.batchNode_)

    self.blinkSingleSpr_:performWithDelay(function ()
        self.blinkSingleSpr_:setSpriteFrame(self.ti.singleBlink[2])
    end, 0.05)
    self.blinkSingleSpr_:performWithDelay(function ()
        self.blinkSingleSpr_:setSpriteFrame(self.ti.singleBlink[1])
    end, 0.15)
    self.blinkSingleSpr_:performWithDelay(function ()
        self.blinkSingleSpr_:removeFromParent()
        self.blinkSingleSpr_ = nil

        -- 后亲嘴
        local kissSpr = display.newSprite('#' .. self.ti.kissPlayer[1])
            :pos(unpack(self.ti.kissPlayerPos))
            :addTo(self.batchNode_)
        kissSpr:performWithDelay(function ()
            kissSpr:setSpriteFrame(self.ti.kissPlayer[2])
        end, 0.05)
        kissSpr:performWithDelay(function ()
            kissSpr:setSpriteFrame(self.ti.kissPlayer[1])
        end, 0.15)
        kissSpr:performWithDelay(function ()
            kissSpr:removeFromParent()
        end, 0.20)
    end, 0.20)
end

-- 敲桌子
function RoomDealer:tapTable()
    local tapSpr = self.tapSpr_
    if tapSpr:getNumberOfRunningActions() >= 1 then
        tapSpr:stopAllActions()
    end

    local t = self.ti.tapTable

    tapSpr:performWithDelay(function ()
        tx.SoundManager:playSound(tx.SoundManager.TAP_TABLE)
        tapSpr:setSpriteFrame(t[2])
    end, 0.25)
    tapSpr:performWithDelay(function ()
        tapSpr:setSpriteFrame(t[3])
    end, 0.40)
    tapSpr:performWithDelay(function ()
        tapSpr:setSpriteFrame(t[2])
    end, 0.55)
    tapSpr:performWithDelay(function ()
        tapSpr:setSpriteFrame(t[3])
    end, 0.65)
    tapSpr:performWithDelay(function ()
        tapSpr:setSpriteFrame(t[1])
    end, 0.90)
end

return RoomDealer
