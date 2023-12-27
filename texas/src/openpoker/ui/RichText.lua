--对cocos2dx提供的RichText进行封装，目前暂不考虑删除元素的情况
--如果ignoreContentAdaptWithSize(false),必须设置setRichTextSize大小,否则会崩溃。默认为true，会忽略设置的大小，只会显示一行，所以不需要设置大小
--调用setAnchorPoint，不会改变内容位置
local RichText = class("RichText", function()
    return display.newNode()
end)

function RichText:ctor(params)
    self.elementTag_ = 0
    self.elementCount_ = 0
    self.changeElementList_ = {}
    self.richText_ = ccui.RichText:create()
        :addTo(self)
end

function RichText:createElementText_(params)
    self.elementTag_ = self.elementTag_ + 1
    local color = params.color or cc.c3b(0xff, 0xff, 0xff)
    local opacity = params.opacity or 0xff
    local text = params.text or ""
    local fontName = params.fontName or display.DEFAULT_TTF_FONT
    local fontSize = params.fontSize or 24

    local element = ccui.RichElementText:create(self.elementTag_, color, opacity, text, fontName, fontSize)

    return element
end

function RichText:addElementText(params)
    self.elementCount_ = self.elementCount_ + 1
    local element = self:createElementText_(params)
    self.richText_:pushBackElement(element)

    return self
end

function RichText:addChangeElementText(params)
    self:addElementText(params)
    local data = {params = params, index = self.elementCount_ - 1}

    table.insert(self.changeElementList_, data)

    return self
end

function RichText:updateChangeElementText(text)
    for i, v in ipairs(self.changeElementList_) do
        local params = v.params
        local index = v.index
        params.text = text[i]

        self.richText_:removeElement(index)
        local element = self:createElementText_(params)
        self.richText_:insertElement(element, index)
    end
end

function RichText:setRichTextSize(w, h)
    self.richText_:size(w, h)

    return self
end

function RichText:getVirtualRendererSize()
    return self.richText_:getVirtualRendererSize()
end

function RichText:formatText()
    self.richText_:formatText()

    return self
end

function RichText:ignoreContentAdaptWithSize(ignore)
    self.richText_:ignoreContentAdaptWithSize(ignore)

    return self
end

--设置每个元素之间的空白
function RichText:setVerticalSpace(space)
    self.richText_:setVerticalSpace(space)

    return self
end

return RichText