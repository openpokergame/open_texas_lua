local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local HttpService = {}
local logger = sa.Logger.new("HttpService")
HttpService.defaultURL = ""
HttpService.defaultParams = {}

-- 单调递增的请求ID
HttpService.requestId_ = 1
HttpService.requests = {}
HttpService.delaycalls = {}

function HttpService.getDefaultURL()
    return HttpService.defaultURL
end

function HttpService.setDefaultURL(url)
    HttpService.defaultURL = url
end

function HttpService.clearDefaultParameters()
    HttpService.defaultParams = {}
end

function HttpService.setDefaultParameter(key, value)
    HttpService.defaultParams[key] = value;
end

function HttpService.cloneDefaultParams(params)
    if params ~= nil then
        table.merge(params, HttpService.defaultParams)
        return params
    else
        return clone(HttpService.defaultParams)
    end
end

local function request_(method, url, addDefaultParams, params, resultCallback, errorCallback)
    -- url = "https://facebook.com"
    local requestId = HttpService.requestId_
    local request = cc.XMLHttpRequest:new()
    request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING -- 响应类型
    HttpService.requests[requestId] = request
    HttpService.requestId_ = HttpService.requestId_ + 1

    logger:debugf("[%d] Method=%s URL=%s defaultParam=%s params=%s", requestId, method, url, json.encode(addDefaultParams), json.encode(params))
    --代理回调
    local onRequestFinished = nil
    onRequestFinished = function()
        if request.readyState==4 then  --处理完毕  UNSENT = 0; OPENED = 1; HEADERS_RECEIVED = 2; LOADING = 3; DONE = 4;
            if request.status==200 then
                local responseStr = request.response
                if string.len(responseStr) <= 10000 then
                    logger:debugf("[%d] response=%s", requestId, responseStr)
                end

                HttpService.requests[requestId]:unregisterScriptHandler()
                HttpService.requests[requestId] = nil
                if HttpService.delaycalls[requestId] then
                    scheduler.unscheduleGlobal(HttpService.delaycalls[requestId])
                end
                HttpService.delaycalls[requestId] = nil
                if resultCallback ~= nil then
                    resultCallback(responseStr)
                end
            else
                logger:debugf("[%d] errCode=%s theStatus=%s", requestId, request.readyState, request.status)

                HttpService.requests[requestId]:unregisterScriptHandler()
                HttpService.requests[requestId] = nil
                if HttpService.delaycalls[requestId] then
                    scheduler.unscheduleGlobal(HttpService.delaycalls[requestId])
                end
                HttpService.delaycalls[requestId] = nil
                if errorCallback ~= nil then
                    errorCallback(request.readyState)
                end
            end
        else
            logger:debugf("[%d] errCode=%s ", requestId, request.readyState)
            HttpService.requests[requestId]:abort()
            HttpService.requests[requestId]:unregisterScriptHandler()
            HttpService.requests[requestId] = nil
            if HttpService.delaycalls[requestId] then
                scheduler.unscheduleGlobal(HttpService.delaycalls[requestId])
            end
            HttpService.delaycalls[requestId] = nil
            if errorCallback ~= nil then
                errorCallback(request.readyState)
            end
        end
    end

    local timeout = 7
    if params and params.requestTimeOut then
        timeout = tonumber(params.requestTimeOut)
        if not timeout then
            timeout = 7
        end
        params.requestTimeOut = nil
    end

    local allParams
    if addDefaultParams then
        allParams = HttpService.cloneDefaultParams()
        table.merge(allParams, params)
    else
        allParams = params
    end

    -- 加入参数
    local paramStr = ""
    for k, v in pairs(allParams) do
        paramStr = paramStr .. tostring(k).."="..tostring(v).."&"
    end
    local modAndAct = ""
    if params.mod and params.act then
        modAndAct = string.format("[%s_%s]", params.mod, params.act)
    end
    logger:debug("url:::"..url..paramStr);
    logger:debugf("[%s][%s][%s]%s %s", requestId, method, url, modAndAct, json.encode(allParams))
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:registerScriptHandler(onRequestFinished)
    -- request.timeout = timeout  默认是30秒太长了吧
    local handle = scheduler.performWithDelayGlobal(function()
        onRequestFinished()
    end,timeout)
    HttpService.delaycalls[requestId] = handle

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
-- local function request_(method, url, addDefaultParams, params, resultCallback, errorCallback)
--     local requestId = HttpService.requestId_
--     logger:debugf("[%d] Method=%s URL=%s defaultParam=%s params=%s", requestId, method, url, json.encode(addDefaultParams), json.encode(params))
--     --代理回调
--     local function onRequestFinished(evt)
--         if evt.name ~= "progress" and evt.name ~= "cancelled" then
--             local ok = (evt.name == "completed")
--             local request = evt.request
--             HttpService.requests[requestId] = nil

--             if not ok then
--                 -- 请求失败，显示错误代码和错误消息
--                 logger:debugf("[%d] errCode=%s errmsg=%s", requestId, request:getErrorCode(), request:getErrorMessage())
--                 if errorCallback ~= nil then
--                     errorCallback(request:getErrorCode(), request:getErrorMessage())
--                 end
--                 return
--             end

--             local code = request:getResponseStatusCode()
--             if code ~= 200 then
--                 -- 请求结束，但没有返回 200 响应代码
--                 logger:debugf("[%d] code=%s", requestId, code)
--                 local request = evt.request
--                 local ret = request:getResponseString()
--                 logger:debugf("[%d]  getResponseHeadersString() =\n%s", requestId, request:getResponseHeadersString())
--                 logger:debugf("[%d]  getResponseDataLength() = %d", requestId, request:getResponseDataLength())
--                 logger:debugf("[%d]  getResponseString() =\n%s", requestId, ret)

--                 if errorCallback ~= nil then
--                     errorCallback(code)
--                 end
--                 return
--             end

--             -- 请求成功，显示服务端返回的内容
--             local response = request:getResponseString()
--             -- todo:better,string太长了打日志报错
--             if string.len(response) <= 10000 then
--                 logger:debugf("[%d] response=%s", requestId, response)
--             end
--             -- logger:debugf("[%d] response=%s", requestId, response)
--             if resultCallback ~= nil then
--                 resultCallback(response)
--             end
--         end
--     end
--     -- 创建一个请求，并以 指定method发送数据到服务端HttpService.cloneDefaultParams初始化
--     local request = network.createHTTPRequest(onRequestFinished, url, method)
--     HttpService.requests[requestId] = request
--     HttpService.requestId_ = HttpService.requestId_ + 1
--     local allParams
--     if addDefaultParams then
--         allParams = HttpService.cloneDefaultParams()
--         table.merge(allParams, params)
--     else
--         allParams = params
--     end

--     -- 加入参数
--     local paramStr = ""
--     for k, v in pairs(allParams) do
--         if method == "GET" then
--             request:addGETValue(tostring(k), tostring(v))
--         else
--             request:addPOSTValue(tostring(k), tostring(v))
--         end
--         paramStr = paramStr .. tostring(k).."="..tostring(v).."&"
--     end
--     local modAndAct = ""
--     if params.mod and params.act then
--         modAndAct = string.format("[%s_%s]", params.mod, params.act)
--         paramStr=paramStr.."mod="..params.mod.."&act="..params.act;
--     end
--     logger:debug("url:::"..url..paramStr);
--     logger:debugf("[%s][%s][%s]%s %s", requestId, method, url, modAndAct, json.encode(allParams))
--     -- 开始请求。当请求完成时会调用 callback() 函数
--     request:start()

--     return requestId
-- end

--[[
    POST到默认的URL，并附加默认参数
    @param {resultCallback} 可以为空， callback(response)
    @param {errorCallback} 可以为空， callback(错误代码，错误消息)
]]
function HttpService.POST(params, resultCallback, errorCallback)
    return request_("POST", HttpService.defaultURL, true, params, resultCallback, errorCallback)
end

--[[
    GET到默认的URL，并附加默认参数
    @param {resultCallback} 可以为空， callback(response)
    @param {errorCallback} 可以为空， callback(错误代码，错误消息)
]]
function HttpService.GET(params, resultCallback, errorCallback)
    return request_("GET", HttpService.defaultURL, true, params, resultCallback, errorCallback)
end

--[[
    POST到指定的URL，该调用不附加默认参数，如需默认参数,params应该使用HttpService.cloneDefaultParams初始化
]]
function HttpService.POST_URL(url, params, resultCallback, errorCallback)
    return request_("POST", url, false, params, resultCallback, errorCallback)
end

--[[
    GET到指定的URL，该调用不附加默认参数，如需默认参数,params应该使用HttpService.cloneDefaultParams初始化
]]
function HttpService.GET_URL(url, params, resultCallback, errorCallback)
    return request_("GET", url, false, params, resultCallback, errorCallback)
end

--[[
    取消指定id的请求
]]
function HttpService.CANCEL(requestId)
    if HttpService.requests[requestId] then
        HttpService.requests[requestId]:unregisterScriptHandler()
        HttpService.requests[requestId]:abort()
        HttpService.requests[requestId] = nil
    end
    if HttpService.delaycalls[requestId] then
        scheduler.unscheduleGlobal(HttpService.delaycalls[requestId])
        HttpService.delaycalls[requestId] = nil
    end
end

-- function HttpService.CANCEL(requestId)
--     if HttpService.requests[requestId] then
--         HttpService.requests[requestId]:cancel()
--         HttpService.requests[requestId] = nil
--     end
-- end

return HttpService
