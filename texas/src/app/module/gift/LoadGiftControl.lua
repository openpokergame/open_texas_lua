-- 加载礼物控制器

local LoadGiftControl =  class("LoadGiftControl")
local instance

function LoadGiftControl:getInstance()
    instance = instance or LoadGiftControl.new()
    return instance
end

function LoadGiftControl:ctor()
    self.requestId_ = 0
    self.requests_ = {}
    self.isConfigLoaded_ = false
    self.isConfigLoading_ = false
end

function LoadGiftControl:loadConfig(url, callback)
    if self.url_ ~= url then
        self.url_ = url
        self.isConfigLoaded_ = false
        self.isConfigLoading_ = false
    end
    self.loadGiftConfigCallback_ = callback
    self:loadConfig_()
end

function LoadGiftControl:loadConfig_()
    if not self.isConfigLoaded_ and not self.isConfigLoading_ then
        self.isConfigLoading_ = true
        sa.cacheFile(self.url_ or tx.userData.giftJsonDomain, function(result, content)
            self.isConfigLoading_ = false
            if result == "success" then
                self.isConfigLoaded_ = true
                local data = json.decode(content)
                if not data then
                    self.isConfigLoaded_ = false
                    return
                end
                local list = data.list
                self.giftData_ = list

                if list then
                    for i=1, #list do
                        list[i].imgUrl = tx.userData.giftDomain .. list[i].img   
                    end

                    for k, v in pairs(self.requests_) do
                        local called = false
                        for i=1, #list do
                            if tonumber(list[i].id) == tonumber(v.giftId) then
                                if v.callback then
                                    called = true
                                    v.callback(list[i].imgUrl)
                                    break
                                end
                            end
                        end
                        if not called and v.callback then
                            v.callback(nil)
                        end
                    end
                end
                if self.loadGiftConfigCallback_ then
                    self.loadGiftConfigCallback_(true, self.giftData_)
                end
            else
                if self.loadGiftConfigCallback_ then
                    self.loadGiftConfigCallback_(false)
                end
            end
        end, "gift")
    elseif self.isConfigLoaded_ then
         if self.loadGiftConfigCallback_ then
            self.loadGiftConfigCallback_(true, self.giftData_)
        end
    end
end

function LoadGiftControl:cancel(requestId)
    self.requests_[requestId] = nil
end

function LoadGiftControl:getGiftUrlById(giftId, callback)
    if self.isConfigLoaded_ then
        if self.giftData_ then
            for i=1,#self.giftData_ do
                if tonumber(self.giftData_[i].id) == tonumber(giftId) then
                    if callback then
                        callback(self.giftData_[i].imgUrl)
                        return nil
                    end
                end
            end
            if callback then
                callback(nil)
                return nil
            end
        end
    else
        self.requestId_ = self.requestId_ + 1
        self.requests_[self.requestId_] = {giftId=giftId, callback=callback}
        self:loadConfig_()
        return self.requestId_
    end
end

return LoadGiftControl