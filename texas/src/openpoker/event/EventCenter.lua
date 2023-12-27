-- 事件中心类

local EventCenter         = class("EventCenter")
local CURRENT_MODULE_NAME = ...

function EventCenter:ctor()
    self.eventObject_ = import(".EventObject", CURRENT_MODULE_NAME).new();
end

-- 侦听事件，返回一个唯一的数字字符
function EventCenter:addEventListener(eventName, listener, tag)
    return self.eventObject_:addEventListener(eventName, listener, tag)
end

-- 派发事件
function EventCenter:dispatchEvent(eventObj)
    if type(eventObj) == "string" then
        eventObj = {name = string.upper(tostring(eventObj))}
    end
    return self.eventObject_:dispatchEvent(eventObj)
end

-- 移除某一个事件，handleToRemove是由addEventListener返回的一个唯一数字字符
function EventCenter:removeEventListener(handleToRemove)
    assert(type(handleToRemove) == "string" and handleToRemove ~= "", "EventCenter:removeEventListener() - invalid handleToRemove, should be a string")
    return self.eventObject_:removeEventListener(handleToRemove)
end

-- 移除由该tag标记的所有侦听
function EventCenter:removeEventListenersByTag(tagToRemove)
    return self.eventObject_:removeEventListenersByTag(tagToRemove)
end

-- 移除某一事件的所有侦听
function EventCenter:removeEventListenersByEvent(eventName)
    return self.eventObject_:removeEventListenersByEvent(eventName)
end

-- 检测是否已经侦听某个事件
function EventCenter:hasEventListener(eventName)
    return self.eventObject_:hasEventListener(eventName)
end

-- 打印所有事件视图
function EventCenter:dumpAllEventListeners()
    return self.eventObject_:dumpAllEventListeners();
end

return EventCenter.new()