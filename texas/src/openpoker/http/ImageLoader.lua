require("lfs")

local ImageLoader = class("ImageLoader")
local log = sa.Logger.new("ImageLoader"):enabled(true)


ImageLoader.CACHE_TYPE_NONE = "CACHE_TYPE_NONE"
ImageLoader.DEFAULT_TMP_DIR = device.writablePath .. "cache" .. device.directorySeparator .. "tmpimg" .. device.directorySeparator

function ImageLoader:ctor()
    self.loadId_ = 0
    self.cacheConfig_ = {}
    self.loadingJobs_ = {}
    sa.rmdir(ImageLoader.DEFAULT_TMP_DIR)
    sa.mkdir(ImageLoader.DEFAULT_TMP_DIR)
    self:registerCacheType(ImageLoader.CACHE_TYPE_NONE, {path=ImageLoader.DEFAULT_TMP_DIR})
end

function ImageLoader:registerCacheType(cacheType, cacheConfig)
    self.cacheConfig_[cacheType] =  cacheConfig
    if cacheConfig.path then
        sa.mkdir(cacheConfig.path)
    else
        cacheConfig.path = ImageLoader.DEFAULT_TMP_DIR
    end
end

function ImageLoader:clearCache()
    for k, v in pairs(self.cacheConfig_) do
        sa.rmdir(v.path)
    end
end

function ImageLoader:nextLoaderId()
    self.loadId_ = self.loadId_ + 1
    return self.loadId_
end

function ImageLoader:loadAndCacheAnimation(files, loadId, url, callback, cacheType)
    log:debugf("loadAndCacheAnimation(%s, %s, %s)", loadId, url, cacheType)
    self:cancelJobByLoaderId(loadId)
    cacheType = cacheType or ImageLoader.CACHE_TYPE_NONE
    self:addJobAnimation_(files, loadId, url, self.cacheConfig_[cacheType], callback)
end
-- 
function ImageLoader:loadAndCacheAnimationExt(files, loadId, url, callback, cacheType)
    log:debugf("loadAndCacheAnimation(%s, %s, %s)", loadId, url, cacheType)
    files = files or {"skeleton.png","skeleton.atlas", "skeleton.json"}
    self:cancelJobByLoaderId(loadId)
    cacheType = cacheType or ImageLoader.CACHE_TYPE_NONE
    self:addJobAnimation_(files, loadId, url, self.cacheConfig_[cacheType], function(success, params, loaderId)
        callback(success)
    end)
end
-- 
function ImageLoader:addJobAnimation_(files, loadId, url, config, callback)
    local params = sa.getFileNameByFilePath(url)
    local hash = crypto.md5(url)
    local path = config.path .. params["name"]

    local cloneFiles = clone(files)  --hash路径也放进去，如果有修改可以更新到最新的
    table.insert(cloneFiles,hash)

    if sa.isExistFiles(cloneFiles, path) then
        log:debugf("file exists (%s, %s, %s)", loadId, url, params["name"])
        lfs.touch(path..device.directorySeparator..files[1])
        if callback ~= nil then
            callback(true, params, loadId)
        end
    else
        sa.delFiles(cloneFiles, path, hash)
        sa.mkdir(path)
        local loadingJob = self.loadingJobs_[url]
        if loadingJob then
            log:debugf("job is loading -> %s", url)
            loadingJob.callbacks[loadId] = callback
        else
            log:debugf("start job -> %s", url)
            loadingJob = {}
            loadingJob.callbacks = {}
            loadingJob.callbacks[loadId] = callback
            self.loadingJobs_[url] = loadingJob
            -- local function onRequestFinished(evt)
            --     if evt.name ~= "progress" then
            --         local ok = (evt.name == "completed")
            --         local request = evt.request
            --         -- 
            --         if not ok then
            --             -- 请求失败，显示错误代码和错误消息
            --             log:debugf("[%d] errCode=%s errmsg=%s", loadId, request:getErrorCode(), request:getErrorMessage())
            --             local values = table.values(loadingJob.callbacks)
            --             for i, v in ipairs(values) do
            --                 if v ~= nil then
            --                     v(false, request:getErrorCode() .. " " .. request:getErrorMessage(), loadId)
            --                 end
            --             end
            --             self.loadingJobs_[url] = nil
            --             return
            --         end
            --         -- 
            --         local code = request:getResponseStatusCode()
            --         if code ~= 200 then
            --             -- 请求结束，但没有返回 200 响应代码
            --             log:debugf("[%d] code=%s", loadId, code)
            --             local values = table.values(loadingJob.callbacks)
            --             for i, v in ipairs(values) do
            --                 if v ~= nil then
            --                     v(false, code, loadId)
            --                 end
            --             end
            --             self.loadingJobs_[url] = nil
            --             return
            --         end
            --         -- 请求成功，显示服务端返回的内容
            --         log:debugf("loaded from network, save to file -> %s", path)
            --         local content = request:getResponseData()
            --         local zippath = path..device.directorySeparator..hash
            --         io.writefile(zippath, content, "w+b")
            --         -- 读取zip包中文件
            --         -- local zipData = cc.FileUtils:getInstance():getFileData(zippath)

            --         for _,v in ipairs(files) do
            --             local file_content = cc.FileUtils:getInstance():getFileDataFromZip(zippath, v)
            --             io.writefile(path..device.directorySeparator..v, file_content, "w+b")
            --         end
            --         os.remove(zippath)
            --         -- 
            --         if sa.isExistFiles(files, path) then
            --             for k, v in pairs(loadingJob.callbacks) do
            --                 log:debugf("call callback -> " .. k)
            --                 if v then
            --                     v(true, params, loadId)
            --                 end
            --             end
            --             if config.onCacheChanged then
            --                 config.onCacheChanged(config.path)
            --             end
            --         else
            --             log:debug("file not exists -> " .. path)
            --         end
            --         self.loadingJobs_[url] = nil
            --     end
            -- end
            -- -- 创建一个请求，并以 指定method发送数据到服务端HttpService.cloneDefaultParams初始化
            -- local request = network.createHTTPRequest(onRequestFinished, url, "GET")
            -- loadingJob.request = request
            -- request:start()

            local request = cc.XMLHttpRequest:new()
            request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING -- 响应类型
            loadingJob.request = request
            request:open("GET", url)
            local function onRequestFinished()
                if request.readyState==4 then  --处理完毕  UNSENT = 0; OPENED = 1; HEADERS_RECEIVED = 2; LOADING = 3; DONE = 4;
                    if request.status==200 then  -- 请求成功，显示服务端返回的内容
                        log:debugf("loaded from network, save to file -> %s", path)
                        request:unregisterScriptHandler()
                        local content = request.response
                        local zippath = path..device.directorySeparator..hash
                        io.writefile(zippath, content, "w+b")
                        -- 读取zip包中文件
                        -- local zipData = cc.FileUtils:getInstance():getFileData(zippath)
                        for _,v in ipairs(files) do
                            local file_content = cc.FileUtils:getInstance():getFileDataFromZip(zippath, v)
                            io.writefile(path..device.directorySeparator..v, file_content, "w+b")
                        end
                        os.remove(zippath)
                        -- 手动写入hash值
                        io.writefile(path..device.directorySeparator..hash, "", "w+b")

                        if sa.isExistFiles(files, path) then
                            for k, v in pairs(loadingJob.callbacks) do
                                log:debugf("call callback -> " .. k)
                                if v then
                                    v(true, params, loadId)
                                end
                            end
                            if config.onCacheChanged then
                                config.onCacheChanged(config.path)
                            end
                        else
                            log:debug("file not exists -> " .. path)
                        end

                        self.loadingJobs_[url] = nil
                    else  -- 请求结束，但没有返回 200 响应代码
                        log:debugf("[%d] errCode=%s theStatus=%s", loadId, request.readyState, request.status)
                        request:unregisterScriptHandler()
                        local values = table.values(loadingJob.callbacks)
                        for i, v in ipairs(values) do
                            if v ~= nil then
                                v(false, request.readyState, loadId)
                            end
                        end
                        self.loadingJobs_[url] = nil
                    end
                else  -- 请求失败，显示错误代码和错误消息
                    log:debugf("[%d] errCode=%s ", loadId, request.readyState)
                    request:abort()
                    request:unregisterScriptHandler()
                    local values = table.values(loadingJob.callbacks)
                    for i, v in ipairs(values) do
                        if v ~= nil then
                            v(false, request.readyState, loadId)
                        end
                    end
                    self.loadingJobs_[url] = nil
                end
            end
            request:registerScriptHandler(onRequestFinished)
            request:send()
        end
    end
end

function ImageLoader:loadAndCacheImage(loadId, url, callback, cacheType)
    log:debugf("loadAndCacheImage(%s, %s, %s)", loadId, url, cacheType)
    self:cancelJobByLoaderId(loadId)
    cacheType = cacheType or ImageLoader.CACHE_TYPE_NONE
    self:addJob_(loadId, url, self.cacheConfig_[cacheType], callback)
end

function ImageLoader:loadImage(url, callback, cacheType)
    local loadId = self:nextLoaderId()
    cacheType = cacheType or ImageLoader.CACHE_TYPE_NONE
    local config = self.cacheConfig_[cacheType]
    log:debugf("loadImage(%s, %s, %s)", loadId, url, cacheType)
    self:addJob_(loadId, url, config, callback)
end

function ImageLoader:cancelJobByUrl_(url)
    local loadingJob = self.loadingJobs_[url]
    if loadingJob then
        loadingJob.callbacks = {}
    end
end

function ImageLoader:cancelJobByLoaderId(loaderId)
    if loaderId then
        for url, loadingJob in pairs(self.loadingJobs_) do
            loadingJob.callbacks[loaderId] = nil
        end
    end
end

function ImageLoader:addJob_(loadId, url, config, callback)
    if not url or string.find(url,"http")~=1 then
        callback(false, 404, loadId)
        return;
    end
    local hash = crypto.md5(url)

    if config == self.cacheConfig_[tx.ImageLoader.CACHE_TYPE_SHARE] then
        if string.find(url, "/") then
            local arr = string.split(url, "/")
            hash = arr[#arr]
        end
    end

    local path = config.path .. hash
    if io.exists(path) then
        log:debugf("file exists (%s, %s, %s)", loadId, url, path)
        lfs.touch(path)
        local tex = cc.Director:getInstance():getTextureCache():addImage(path)
        if not tex then
            os.remove(path)
        elseif callback ~= nil then
            callback(tex ~= nil, cc.Sprite:createWithTexture(tex), loadId)
        end
    else
        local loadingJob = self.loadingJobs_[url]
        if loadingJob then
            log:debugf("job is loading -> %s", url)
            loadingJob.callbacks[loadId] = callback
        else
            log:debugf("start job -> %s", url)
            loadingJob = {}
            loadingJob.callbacks = {}
            loadingJob.callbacks[loadId] = callback
            self.loadingJobs_[url] = loadingJob
            -- local function onRequestFinished(evt)
            --     if evt.name ~= "progress" then
            --         local ok = (evt.name == "completed")
            --         local request = evt.request

            --         if not ok then
            --             -- 请求失败，显示错误代码和错误消息
            --             log:debugf("[%d] errCode=%s errmsg=%s url=%s", loadId, request:getErrorCode(), request:getErrorMessage(),url)
            --             local values = table.values(loadingJob.callbacks)
            --             for i, v in ipairs(values) do
            --                 if v ~= nil then
            --                     v(false, request:getErrorCode() .. " " .. request:getErrorMessage(), loadId)
            --                 end
            --             end
            --             self.loadingJobs_[url] = nil
            --             return
            --         end

            --         local code = request:getResponseStatusCode()
            --         if code ~= 200 then
            --             -- 请求结束，但没有返回 200 响应代码
            --             log:debugf("[%d] code=%s url=%s", loadId, code, url)
            --             local values = table.values(loadingJob.callbacks)
            --             for i, v in ipairs(values) do
            --                 if v ~= nil then
            --                     v(false, code, loadId)
            --                 end
            --             end
            --             self.loadingJobs_[url] = nil
            --             return
            --         end

            --         -- 请求成功，显示服务端返回的内容
            --         local content = request:getResponseData()
            --         local pre1 = string.sub(content, 1,1)
            --         local pre2 = string.sub(content, 2,2)
            --         pre1 = string.byte(pre1)
            --         pre2 = string.byte(pre2)
            --         -- 0xFFD8  JPEG
            --         -- 0x8950  PNG
            --         -- 0x4D42  BMP
            --         if (pre1==0xFF and pre2==0xD8) or (pre1==0x89 and pre2==0x50) then
            --             log:debugf("loaded from network, save to file -> %s", path)
            --             io.writefile(path, content, "w+b")

            --             if sa.isFileExist(path) then
            --                 local tex = nil
            --                 for k, v in pairs(loadingJob.callbacks) do
            --                     log:debugf("call callback -> " .. k)
            --                     if v then
            --                         if not tex then
            --                             lfs.touch(path)
            --                             tex = cc.Director:getInstance():getTextureCache():addImage(path)
            --                         end
            --                         if not tex then
            --                             os.remove(path)
            --                         else
            --                             v(true, cc.Sprite:createWithTexture(tex), loadId)
            --                         end
            --                     end
            --                 end
            --                 if config.onCacheChanged then
            --                     config.onCacheChanged(config.path)
            --                 end
            --             else
            --                 log:debug("file not exists -> " .. path)
            --             end
            --         else   -- 非正常图片
            --             log:debugf("loaded img is not img format pre1=%s  pre2=%s url=%s",pre1,pre2,url)
            --             content = nil
            --             for k, v in pairs(loadingJob.callbacks) do
            --                 if v then
            --                     v(false, "is not img format", loadId)
            --                 end
            --             end
            --         end
            --         self.loadingJobs_[url] = nil
            --     end
            -- end
            -- -- 创建一个请求，并以 指定method发送数据到服务端HttpService.cloneDefaultParams初始化
            -- local request = network.createHTTPRequest(onRequestFinished, url, "GET")
            -- loadingJob.request = request
            -- request:start()

            local request = cc.XMLHttpRequest:new()
            request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING -- 响应类型
            -- request.withCredentials = true
            loadingJob.request = request
            request:open("GET", url)
            local function onRequestFinished()
                if request.readyState==4 then  --处理完毕  UNSENT = 0; OPENED = 1; HEADERS_RECEIVED = 2; LOADING = 3; DONE = 4;
                    if request.status==200 then  -- 请求成功，显示服务端返回的内容
                        request:unregisterScriptHandler()
                        local content = request.response
                        local pre1 = string.sub(content, 1,1)
                        local pre2 = string.sub(content, 2,2)
                        pre1 = string.byte(pre1)
                        pre2 = string.byte(pre2)
                        -- 0xFFD8  JPEG
                        -- 0x8950  PNG
                        -- 0x4D42  BMP
                        if (pre1==0xFF and pre2==0xD8) or (pre1==0x89 and pre2==0x50) then
                            log:debugf("loaded from network, save to file -> %s", path)
                            io.writefile(path, content, "w+b")

                            if sa.isFileExist(path) then
                                local tex = nil
                                for k, v in pairs(loadingJob.callbacks) do
                                    log:debugf("call callback -> " .. k)
                                    if v then
                                        if not tex then
                                            lfs.touch(path)
                                            tex = cc.Director:getInstance():getTextureCache():addImage(path)
                                        end
                                        if not tex then
                                            os.remove(path)
                                        else
                                            v(true, cc.Sprite:createWithTexture(tex), loadId)
                                        end
                                    end
                                end
                                if config.onCacheChanged then
                                    config.onCacheChanged(config.path)
                                end
                            else
                                log:debug("file not exists -> " .. path)
                            end
                        else   -- 非正常图片
                            log:debugf("loaded img is not img format pre1=%s  pre2=%s url=%s",pre1,pre2,url)
                            content = nil
                            for k, v in pairs(loadingJob.callbacks) do
                                if v then
                                    v(false, "is not img format", loadId)
                                end
                            end
                        end
                        self.loadingJobs_[url] = nil
                    else  -- 请求结束，但没有返回 200 响应代码
                        log:debugf("[%d] errCode=%s theStatus=%s url=%s", loadId, request.readyState, request.status,url)
                        request:unregisterScriptHandler()
                        local values = table.values(loadingJob.callbacks)
                        for i, v in ipairs(values) do
                            if v ~= nil then
                                v(false, request.readyState, loadId)
                            end
                        end
                        self.loadingJobs_[url] = nil
                    end
                else  -- 请求失败，显示错误代码和错误消息
                    log:debugf("[%d] errCode=%s url=%s", loadId, request.readyState,url)
                    request:abort()
                    request:unregisterScriptHandler()
                    local values = table.values(loadingJob.callbacks)
                    for i, v in ipairs(values) do
                        if v ~= nil then
                            v(false, request.readyState, loadId)
                        end
                    end
                    self.loadingJobs_[url] = nil
                end
            end
            request:registerScriptHandler(onRequestFinished)
            request:send()
        end
    end
end

return ImageLoader