--[[
    UpdateHttpService.POST({mod="friend",act="list"},
    function(data) 
    end,
    function(errCode[, response])
    end)
]]

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local UpdateHttpService = {}

UpdateHttpService.requestId_ = 1
UpdateHttpService.requests = {}
UpdateHttpService.delaycalls = {}

local function request_(method, url, params, resultCallback, errorCallback)
    -- url = "https://facebook.com"
    local requestId = UpdateHttpService.requestId_
    -- 创建一个请求，并以 指定method发送数据到服务端UpdateHttpService.cloneDefaultParams初始化
    local request = cc.XMLHttpRequest:new()
    request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING -- 响应类型
    UpdateHttpService.requests[requestId] = request
    UpdateHttpService.requestId_ = UpdateHttpService.requestId_ + 1

    --代理回调
    local function onRequestFinished()
        if request.readyState==4 then
            -- print("UpdateHttpService  "..requestId.." success==== "..url)
            request:unregisterScriptHandler()
            UpdateHttpService.requests[requestId] = nil
            if UpdateHttpService.delaycalls[requestId] then
                scheduler.unscheduleGlobal(UpdateHttpService.delaycalls[requestId])
            end
            UpdateHttpService.delaycalls[requestId] = nil
            if request.status==200 then-- 请求成功，显示服务端返回的内容
                local response = request.response
                -- print("UpdateHttpService  "..requestId.." success==== the data is -----"..response.." "..url)
                if resultCallback ~= nil then
                    resultCallback(response)
                end
            else-- 请求结束，但没有返回 200 响应代码
                if errorCallback ~= nil then
                    errorCallback(request.readyState, request.status)
                end
            end
        else-- 请求失败，显示错误代码和错误消息
            -- print("UpdateHttpService  "..requestId.." fail==== the code is -----"..request.readyState.." "..url)
            request:abort()
            request:unregisterScriptHandler()
            UpdateHttpService.requests[requestId] = nil
            if UpdateHttpService.delaycalls[requestId] then
                scheduler.unscheduleGlobal(UpdateHttpService.delaycalls[requestId])
            end
            UpdateHttpService.delaycalls[requestId] = nil
            if errorCallback ~= nil then
                errorCallback(request.readyState, request.status)
            end
        end
    end
    
    -- 加入参数
    local paramStr = ""
    if params then
        for k, v in pairs(params) do
            paramStr = paramStr .. tostring(k).."="..tostring(v).."&"
        end
    end
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:registerScriptHandler(onRequestFinished)
    -- request.timeout = 5  默认是30秒太长了吧
    local handle = scheduler.performWithDelayGlobal(function()
        onRequestFinished()
    end, 5)
    UpdateHttpService.delaycalls[requestId] = handle

    if method=="POST" then
        request:open("POST", url)
        request:send(paramStr)
    else
        if string.find(url, "?") then   --已经带有问号
            request:open("GET", url..paramStr)
        else
            request:open("GET", url.."?"..paramStr)
        end
        request:send()
    end

    return requestId
end

-- local function request_(method, url, params, resultCallback, errorCallback)
--     local requestId = UpdateHttpService.requestId_

--     --代理回调
--     local function onRequestFinished(evt)
--         if evt.name ~= "progress" and evt.name ~= "cancelled" then
--             local ok = (evt.name == "completed")
--             local request = evt.request
--             UpdateHttpService.requests[requestId] = nil

--             if not ok then
--                 -- 请求失败，显示错误代码和错误消息
--                 if errorCallback ~= nil then
--                     errorCallback(request:getErrorCode(), request:getErrorMessage())
--                 end
--                 return
--             end

--             local code = request:getResponseStatusCode()
--             if code ~= 200 then
--                 -- 请求结束，但没有返回 200 响应代码
--                 if errorCallback ~= nil then
--                     errorCallback(code)
--                 end
--                 return
--             end

--             -- 请求成功，显示服务端返回的内容
--             local response = request:getResponseString()
--             if resultCallback ~= nil then
--                 resultCallback(response)
--             end
--         end
--     end
--     -- 创建一个请求，并以 指定method发送数据到服务端UpdateHttpService.cloneDefaultParams初始化
--     local request = network.createHTTPRequest(onRequestFinished, url, method)
--     UpdateHttpService.requests[requestId] = request
--     UpdateHttpService.requestId_ = UpdateHttpService.requestId_ + 1
    
--     -- 加入参数
--     if params then
--         for k, v in pairs(params) do
--             if method == "GET" then
--                 request:addGETValue(tostring(k), tostring(v))
--             else
--                 request:addPOSTValue(tostring(k), tostring(v))
--             end
--         end
--     end
--     request:setTimeout(5)
--     -- 开始请求。当请求完成时会调用 callback() 函数
--     request:start()

--     return requestId
-- end

--[[
    POST到指定的URL，该调用不附加默认参数，如需默认参数,params应该使用UpdateHttpService.cloneDefaultParams初始化
]]
function UpdateHttpService.POST_URL(url, params, resultCallback, errorCallback)
    return request_("POST", url, params, resultCallback, errorCallback)
end

function UpdateHttpService.GET_URL(url, params, resultCallback, errorCallback)
    return request_("GET", url, params, resultCallback, errorCallback)
end

return UpdateHttpService