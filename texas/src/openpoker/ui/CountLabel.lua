-- 对label的封装，增加数值变化接口

local CountLabel = class("CountLabel", cc.ui.UILabel)

function CountLabel:ctor(params)
	CountLabel.super.ctor(self, params)

	self:align(display.CENTER)

	self.startNum_ = 0
	self.endNum_ = 0
	self.prefix_ = params.prefix or "" --字符串前缀，单位符号
	self.minDifference_ =  params.Difference or 3 --最小差值
	self.proportion_ = params.proportion or 0.1 --每一帧差值比例

	self:setNodeEventEnabled(true)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame_))
end

function CountLabel:setFitWidth(width)
	self.fitWidth_ = width
	return self
end

--设置最小差值
function CountLabel:setMinDifference(minDifference)
	self.minDifference_ = minDifference
	return self
end

--设置每一帧差值比例
function CountLabel:setProportione(proportion)
	self.proportion_ = proportion
	return self
end

--一次性变化的时候调用
function CountLabel:startCount(startNum, endNum)
	self.startNum_ = tonumber(startNum)
	self.endNum_ = tonumber(endNum)

	self:setString(self.prefix_ .. sa.formatNumberWithSplit(self.startNum_))

	self:scheduleUpdate()

	return self
end

--设置初始值
function CountLabel:setStartNum(startNum)
	self.startNum_ = tonumber(startNum)

	return self
end

--设置结束值，动态改变的时候调用
function CountLabel:setEndNum(endNum)
	self.endNum_ = tonumber(endNum)
	self:unscheduleUpdate()
	self:scheduleUpdate()
end

function CountLabel:onEnterFrame_()
	self:getDifferenceNum_()
	self:setString(self.prefix_ .. sa.formatNumberWithSplit(self.startNum_))
	if self.fitWidth_ then
		sa.fitSprteWidth(self, self.fitWidth_)
	end
end

function CountLabel:getDifferenceNum_()
	self.startNum_ = self.startNum_ + math.floor(math.max((self.endNum_ - self.startNum_) * self.proportion_, self.minDifference_))
	if self.startNum_ > self.endNum_ then
		self.startNum_ = self.endNum_
		self:unscheduleUpdate()
	end
end

return CountLabel