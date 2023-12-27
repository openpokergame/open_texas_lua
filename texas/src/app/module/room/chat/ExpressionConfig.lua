local ExpressionConfig = class("ExpressionConfig")

function ExpressionConfig:ctor()
    self.config_ = {}

    local data = {
        -- 表情1
        {id= 11,    frameNum = 10,  itemX = -5, itemY = 0, offsetX = 0, offsetY = 0},
        {id= 12,    frameNum = 13,  itemX = 4,  itemY = 8, offsetX = 0, offsetY = 0},
        {id= 13,    frameNum = 17,  itemX = 10, itemY = 6, offsetX = 0, offsetY = 0},
        {id= 14,    frameNum = 6,   itemX = 0,  itemY = 8, offsetX = 0, offsetY = 0},
        {id= 15,    frameNum = 8,   itemX = 6,  itemY = 6, offsetX = 0, offsetY = 0},
        {id= 16,    frameNum = 7,   itemX = 0,  itemY = 4, offsetX = 0, offsetY = 0},
        {id= 17,    frameNum = 7,   itemX = 0,  itemY = 2, offsetX = 0, offsetY = 0},
        {id= 18,    frameNum = 9,   itemX = 0,  itemY = 2, offsetX = 0, offsetY = 0},
        {id= 19,    frameNum = 12,  itemX = 0,  itemY = 4, offsetX = 0, offsetY = 0},
        {id= 110,   frameNum = 16,  itemX = 0,  itemY = 6, offsetX = 0, offsetY = 0},
        {id= 111,   frameNum = 10,  itemX = 8,  itemY = 0, offsetX = 0, offsetY = 0},
        {id= 112,   frameNum = 16,  itemX = 0,  itemY = 0, offsetX = 0, offsetY = 0},
        {id= 113,   frameNum = 12,  itemX = 0,  itemY = 0, offsetX = 0, offsetY = 0},
        {id= 114,   frameNum = 12,  itemX = 0,  itemY = 0, offsetX = 0, offsetY = 0},
        {id= 115,   frameNum = 8,   itemX = 0,  itemY = 0, offsetX = 0, offsetY = 0},
        {id= 116,   frameNum = 11,  itemX = 0,  itemY = 0, offsetX = 0, offsetY = 0},

        -- 表情2
        {id= 21,    frameNum = 7,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 5},
        {id= 22,    frameNum = 7,   itemX = 0,  itemY = -10, offsetX = 0, offsetY = 0},
        {id= 23,    frameNum = 8,   itemX = 0,  itemY = 5,   offsetX = 0, offsetY = 5},
        {id= 24,    frameNum = 9,   itemX = 0,  itemY = -5,  offsetX = -5, offsetY = 5},
        {id= 25,    frameNum = 4,   itemX = 0,  itemY = 10,  offsetX = 5, offsetY = 5},
        {id= 26,    frameNum = 9,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},
        {id= 27,    frameNum = 8,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},
        {id= 28,    frameNum = 11,  itemX = 0,  itemY = -2,  offsetX = 0, offsetY = 0},
        {id= 29,    frameNum = 5,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},
        {id= 210,   frameNum = 6,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},
        {id= 211,   frameNum = 12,  itemX = 0,  itemY = 2,   offsetX = 5, offsetY = 0},
        {id= 212,   frameNum = 11,  itemX = 0,  itemY = 2,   offsetX = 0, offsetY = 0},
        {id= 213,   frameNum = 15,  itemX = 0,  itemY = 10,  offsetX = 0, offsetY = 0},
        {id= 214,   frameNum = 6,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},

        -- 表情4
        {id= 41,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 0},
        {id= 42,    frameNum = 12,   itemX = 0,  itemY = 4,   offsetX = 0, offsetY = 5},
        {id= 43,    frameNum = 12,   itemX = 0,  itemY = 4,   offsetX = -5, offsetY = 5},
        {id= 44,    frameNum = 12,   itemX = 0,  itemY = -2,  offsetX = 0, offsetY = 0},
        {id= 45,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = -10, offsetY = 5},
        {id= 46,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 5},
        {id= 47,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = -5, offsetY = 5},
        {id= 48,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = -10, offsetY = 5},
        {id= 49,    frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = -5, offsetY = 0},
        {id= 410,   frameNum = 12,   itemX = 0,  itemY = -2,  offsetX = -10, offsetY = 0},
        {id= 411,   frameNum = 12,   itemX = 0,  itemY = 4,   offsetX = 0, offsetY = 5},
        {id= 412,   frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 10},
        {id= 413,   frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 10},
        {id= 414,   frameNum = 12,   itemX = 0,  itemY = -2,  offsetX = -5, offsetY = 5},
        {id= 415,   frameNum = 12,   itemX = 0,  itemY = 2,   offsetX = 0, offsetY = 5},
        {id= 416,   frameNum = 12,   itemX = 0,  itemY = 0,   offsetX = 0, offsetY = 5},
    }
    for _, v in ipairs(data) do
        self:addConfig_(v)
    end

    -- 表情3
    for i = 1, 35 do
        self:addConfig_({id = tonumber("3"..i), frameNum = 1})
    end
end

function ExpressionConfig:getConfig(id)
    return self.config_[id]
end

function ExpressionConfig:addConfig_(params)
    local config = {}
    config.id = params.id
    config.frameNum = params.frameNum

    -- 表情面板中的偏移
    config.itemX = params.itemX or 0 
    config.itemY = params.itemY or 0

    -- 播放表情头像上的偏移
    config.offsetX = params.offsetX or 0
    config.offsetY = params.offsetY or 0

    self.config_[params.id] = config
end

return ExpressionConfig