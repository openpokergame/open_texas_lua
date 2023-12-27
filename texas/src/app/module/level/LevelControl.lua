-- 等级管理

local LevelControl =  class("LevelControl")
local instance

function LevelControl:getInstance()
    instance = instance or LevelControl.new()
    return instance
end

function LevelControl:ctor()
    self.requestId_ = 0
    self.isConfigLoaded_ = false
    self.isConfigLoading_ = false
end

function LevelControl:loadConfig(url, callback)
    if self.url_ ~= url then
        self.url_ = url
        self.isConfigLoaded_ = false
        self.isConfigLoading_ = false
    end
    self.loadConfigCallback_ = callback
    self:loadConfig_()
end

function LevelControl:loadConfig_()
    local url = self.url_
    if not url then
        url = tx.userData and tx.userData.levelJsonDomain
    end
    if not url or url=="" then
        if self.loadConfigCallback_ then
            self.loadConfigCallback_(false)
            self.loadConfigCallback_ = nil
        end
        return
    end
    if not self.isConfigLoaded_ and not self.isConfigLoading_ then
        self.isConfigLoading_ = true
        sa.cacheFile(url, function(result, content)
            self.isConfigLoading_ = false
            if result == "success" then
                self.isConfigLoaded_ = true
                local data = json.decode(content)
                self.levelData_ = data
                if self.levelData_ and #self.levelData_>0 then
                    if self.loadConfigCallback_ then
                        self.loadConfigCallback_(true, self.levelData_)
                        self.loadConfigCallback_ = nil
                    end
                    -- 保存上次URL
                    tx.userDefault:setStringForKey(tx.cookieKeys.LEVEL_CONFIGU_URL, url)
                    tx.userDefault:flush()
                else
                    if self.loadConfigCallback_ then
                        self.loadConfigCallback_(false)
                        self.loadConfigCallback_ = nil
                    end
                end
            else
                if self.loadConfigCallback_ then
                    self.loadConfigCallback_(false)
                    self.loadConfigCallback_ = nil
                end
            end
        end, "level")
    elseif self.isConfigLoaded_ then
         if self.loadConfigCallback_ then
            self.loadConfigCallback_(true, self.levelData_)
            self.loadConfigCallback_ = nil
        end
    end
end

--根据经验获得等级
function LevelControl:getLevelByExp(exp)
    exp = (exp and tonumber(exp) or 0)
    if not exp or not self.levelData_ then return 1 end
    local t
    for i = 1, #self.levelData_ do
        t = self.levelData_[i]
        if t.exp == exp then
            return i
        elseif self.levelData_[i].exp > exp then
            if i - 1 < 1 then
                return 1
            else
                return i - 1
            end
        end
    end
    return #self.levelData_
end

--根据等级获得称号
function LevelControl:getTitleByLevel(level)
    level = (level and tonumber(level) or 1)
    if not level or not self.levelData_ then return "" end
    local t = self.levelData_[level]
    if t then
        return t.name
    end
    return ""
end

--改等级是否有奖励
function LevelControl:checkLevelAward(level)
    level = (level and tonumber(level) or 1)
    if not level or not self.levelData_ then return false end
    if self.levelData_[level] then
        local reward = self.levelData_[level].reward
        if not reward or string.trim(reward)=="" then
            return false, nil
        end
        return true, reward
    end
    return false, nil
end

--根据经验获得称号
function LevelControl:getTitleByExp(exp)
    exp = (exp and tonumber(exp) or 0)
    local level = self:getLevelByExp(exp)
    return self:getTitleByLevel(level)
end

--根据经验值获得经验值升级进度 
--@return  进度百分比,升级已获得经验，升级总经验
function LevelControl:getLevelUpProgress(exp)
    exp = (exp and tonumber(exp) or 0)
    if not exp or not self.levelData_ then return 1/4146696,1,4146696,1 end
    local level = self:getLevelByExp(exp)
    local nextLevel = (level + 1 <= #self.levelData_ and level + 1 or #self.levelData_)
    if level == nextLevel then
        return 0, 0, 0, level
    else
        local progress = exp
        local all = self.levelData_[nextLevel].exp
        return progress / all, progress, all, level
    end
end


return LevelControl