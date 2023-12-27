local BetTypeManager = class("BetTypeManager")
local RoomViewPosition = import(".views.RoomViewPosition")
local BetTypePosition = RoomViewPosition.BetTypePosition
local BetTypeArea = RoomViewPosition.BetTypeArea
local SeatPosition = RoomViewPosition.SeatPosition
local WinTipsView = import(".views.WinTipsView")

local BTN_NUM = 13
local HISTORY_X = {}
local HISTORY_Y = RoomViewPosition.HISTORY_Y
local HISTORY_NUM = 10

function BetTypeManager:ctor()
    self.betBtnList_ = {} --下注按钮
    self.myBetLabelList_ = {} --自己下注label
    self.myBetNumList_ = {} --自己下注的值
    self.allBetLabelList_ = {} --所有下注统计lable
    self.allBetNumList_ = {} --所有下注统计值
    self.historyList_ = {} --历史牌局提示点
    self.winTipsList_ = {}
end

function BetTypeManager:createNodes()
    local node = self.scene.nodes.betTypeNode
    -- 减少drawcalls
    local allBetNode = display.newNode()
        :addTo(node)
    local btnNode = display.newNode()
        :addTo(node)
    local betNumViewNode = display.newNode()
        :addTo(node)

    self.betTypeNode_ = node

    --下注按钮
    for i = 1, BTN_NUM do
        self.allBetNumList_[i] = 0
        self.myBetNumList_[i] = 0

        local bet_x, bet_y = BetTypePosition[i].x, BetTypePosition[i].y
        local bet_w, bet_h = BetTypeArea[i].width, BetTypeArea[i].height
        local allBet_y = bet_y + bet_h*0.5 - 2
        local allBet = ui.newTTFLabel({text = "", color = cc.c3b(0xff, 0xbe, 0xae), size = 22})
            :addTo(allBetNode)
        if i == 1 then
            allBet:align(display.RIGHT_TOP, bet_x + bet_w*0.5 - 4, allBet_y)
        elseif i == 2 then
            allBet:align(display.TOP_CENTER, bet_x, allBet_y)
        else
            allBet:align(display.LEFT_TOP, bet_x - bet_w*0.5 + 4, allBet_y)
        end

        self.allBetLabelList_[i] = allBet

        local y = bet_y - bet_h*0.5 + 6
        if i < 3 then
            y = y + 8
        end
        -- 减少drawcalls start
        local bg = display.newSprite("#redblack/room/redblack_tips_small_bg.png")
            :align(display.BOTTOM_CENTER, bet_x, y)
            :addTo(betNumViewNode)
        local label = ui.newTTFLabel({text = "", color = cc.c3b(0xff, 0xed, 0x5e), size = 24})
            :align(display.CENTER, bet_x, y+22)
            :addTo(betNumViewNode,i + BTN_NUM)
        label.bg = bg
        label.show = function(obj)
            cc.Node.show(obj)
            cc.Node.show(obj.bg)
            return obj
        end
        label.hide = function(obj)
            cc.Node.hide(obj)
            cc.Node.hide(obj.bg)
            return obj
        end
        label.setString = function(obj,num)
            cc.Label.setString(obj,sa.formatBigNumber(num))
            return obj
        end
        self.myBetLabelList_[i] = label
        label:hide()
        -- 减少drawcalls end

        local btn = cc.ui.UIPushButton.new("#common/transparent.png",{scale9=true})
            :setButtonSize(bet_w, bet_h)
            :onButtonPressed(buttontHandler(self, self.onBetPressed_))
            -- :onButtonClicked(buttontHandler(self, self.onBetClicked_))
            :setDelayTouchEnabled(false)
            :setButtonEnabled(false)
            :pos(bet_x, bet_y)
            :addTo(btnNode)

        btn:setTag(i)
        self.betBtnList_[i] = btn
    end

    for i = 1, HISTORY_NUM do
        local x = display.cx + (5.5 - i) * 30
        display.newSprite("#redblack/room/redblack_win_history_bg.png")
            :pos(x, HISTORY_Y)
            :addTo(node)

        HISTORY_X[i] = x
    end
end

function BetTypeManager:onBetPressed_(evt)
    cc.ParticleSystemQuad:create("particle/redblack_bet.plist")
        :pos(evt.x, evt.y)
        :addTo(self.scene.nodes.betTypeNode)
        :setAutoRemoveOnFinish(true)

    local tag = evt.target:getTag()
    self:sendBet(tag)
end

function BetTypeManager:onBetClicked_(evt)
    -- local tag = evt.target:getTag()
    -- self:sendBet(tag)
end

function BetTypeManager:setBetEnabled(enabled)
    for i = 1, BTN_NUM do
        self.betBtnList_[i]:setButtonEnabled(enabled)
    end
end

function BetTypeManager:sendBet(betType)
    self.ctx.oprManager:requestBet(betType)
end

--点击下注，更新我的下注状态
function BetTypeManager:updateMyChips(betType, chips)
    assert(betType > 0 and betType < 14,"bet betType error")
    self.myBetNumList_[betType] = self.myBetNumList_[betType] + chips
    self.myBetLabelList_[betType]:show():setString(self.myBetNumList_[betType])
    self:updateAllChips(betType, chips)
end

--点击下注，更新所有下注状态
function BetTypeManager:updateAllChips(betType, chips)
    assert(betType > 0 and betType < 14,"bet betType error")
    self.allBetNumList_[betType] = self.allBetNumList_[betType] + chips
    self.allBetLabelList_[betType]:setString(sa.formatBigNumber(self.allBetNumList_[betType]))
end

--下注失败，更新下注数量
function BetTypeManager:updateBetFailedStatus(betType, betChips, betTotalChips)
    self.myBetNumList_[betType] = betChips
    self.myBetLabelList_[betType]:show():setString(betChips)

    self.allBetNumList_[betType] = betTotalChips
    self.allBetLabelList_[betType]:setString(sa.formatBigNumber(betTotalChips))
end

--重连时，更新下注状态
function BetTypeManager:updateBetStatus(selfBetList, allBetList)
    self:updateMyBet_(selfBetList)
    self:updateAllBet_(allBetList)   
end

--登录成功的时候，更新我的下注状态
function BetTypeManager:updateMyBet_(data)
    if data then
        for i,v in pairs(data) do
            self.myBetNumList_[v.betType] = v.betChips
            self.myBetLabelList_[v.betType]:show():setString(self.myBetNumList_[v.betType])

            self.ctx.model:processSelfBetSuccess(v)
        end

        self.ctx.oprManager:updateBetButtonState()
    end
end

--登录成功的时候，更新所有下注状态
function BetTypeManager:updateAllBet_(data)
    if data then
        for i,v in pairs(data) do
            self.allBetNumList_[v.betType] = v.betChips
            self.allBetLabelList_[v.betType]:setString(sa.formatBigNumber(self.allBetNumList_[v.betType]))
        end
    end
end

--清除下注数值
function BetTypeManager:clearChips()
    for i = 1, BTN_NUM do
        self.allBetNumList_[i] = 0
        self.myBetNumList_[i] = 0
        self.allBetLabelList_[i]:setString("")
        self.myBetLabelList_[i]:hide():setString("")
    end
end

--显示赢牌动画
function BetTypeManager:showWinType(data)
    for i, v in ipairs(data) do
        local tips = self.winTipsList_[v.winType]
        if not tips then
            local idx = v.winType
            local node = self.scene.nodes.betTypeNode
            local bet_x, bet_y = BetTypePosition[idx].x, BetTypePosition[idx].y
            tips = WinTipsView.new(BetTypeArea[idx])
                :pos(bet_x, bet_y)
                :addTo(node)
                :hide()
            self.winTipsList_[idx] = tips
        end
        tips:performWithDelay(function()
            tips:playAnimation()
        end, 0.2 * i)
    end
end

--隐藏赢牌动画
function BetTypeManager:hideWinType()
    for _, v in pairs(self.winTipsList_) do
        v:stopAnimation()
    end
end

--设置历史赢牌记录
function BetTypeManager:setHistory(history)
    local index = 1
    for i = #history, 1, -1 do
        local img = nil
        local v = history[i]
        if v.winner == 1 then
            img = "#redblack/room/redblack_win_history_silver.png"
        elseif v.winner == 2 then
            img = "#redblack/room/redblack_win_history_gold.png"
        end

        self.historyList_[index] = display.newSprite(img)
            :pos(HISTORY_X[index], HISTORY_Y)
            :addTo(self.betTypeNode_)
        index = index + 1
    end
end

--更新历史赢牌记录
function BetTypeManager:updateHistory(winner)
    local count = #self.historyList_
    if count == HISTORY_NUM then
        self.historyList_[HISTORY_NUM]:removeFromParent()
    else
        count = count + 1
    end

    for i = count, 2, -1 do
        self.historyList_[i] = self.historyList_[i - 1]
        self.historyList_[i]:runAction(cc.MoveTo:create(0.2, cc.p(HISTORY_X[i], HISTORY_Y)))
    end

    local img = nil
    local pos = BetTypePosition[1]
    if winner == 1 then
        img = "#redblack/room/redblack_win_history_silver.png"
        pos = BetTypePosition[1]
    elseif winner == 2 then
        img = "#redblack/room/redblack_win_history_gold.png"
        pos = BetTypePosition[3]
    end

    self.historyList_[1] = display.newSprite(img)
        :pos(pos.x,pos.y)
        :addTo(self.betTypeNode_)

    self.pointSoundId_ = tx.SoundManager:playSound(tx.SoundManager.REDBLACK_POINT)
    self.historyList_[1]:runAction(cc.MoveTo:create(0.8,cc.p(HISTORY_X[1], HISTORY_Y)))
end

--重置
function BetTypeManager:reset()
    self:clearChips()

    self:hideWinType()

    self:setBetEnabled(false)
end

function BetTypeManager:dispose()
    tx.SoundManager:stopSound(self.pointSoundId_)
end

return BetTypeManager