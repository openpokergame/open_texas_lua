-- 下注筹码数据结构
local BetChipData = class("BetChipData")
function BetChipData:ctor(filename, index)
    self.sprite_ = display.newSprite(filename)
    self.index_ = index
end

function BetChipData:getSprite()
    return self.sprite_
end

function BetChipData:getIndex()
    return self.index_
end

function BetChipData:retain()
    self.sprite_:retain()
end

function BetChipData:release()
    self.sprite_:release()
    self.index_ = nil
end



return BetChipData

