require("lfs")
local function findindir(path, wefind, r_table, intofolder)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..device.directorySeparator..file
            --print ("/t "..f)
            if string.find(f, wefind) ~= nil then
                --print("/t "..f)
                table.insert(r_table, f)
            end  
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" and intofolder then  
                findindir(f, wefind, r_table, intofolder)
            else
                --for name, value in pairs(attr) do
                --    print (name, value)
                --end
            end
        end
    end
end

local ItemLevels = import(".items.ItemLevels")

local PanelLevel = class("PanelLevel", function() return display.newNode() end)
local LIST_WIDTH,LIST_HEIGHT = 790, 396
PanelLevel.ELEMENTS = {
	"labelLevelTitle",
	"labelLevel",
	"labelChenHao",
	"labelJingYan",
	"labelJiangLi",
	"nodeList"
}

function PanelLevel:ctor(probValue)
	self:setNodeEventEnabled(true)
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_help_level_ins.csb",true)
	local text = sa.LangUtil.getText("HELP", "LEVEL_TITLES")
	self.labelLevel:setString(text[1])
	self.labelChenHao:setString(text[2])
	self.labelJingYan:setString(text[3])
	self.labelJiangLi:setString(text[4])
	self.labelLevelTitle:setString(sa.LangUtil.getText("HELP", "LEVEL_RULE"))

	ItemLevels.WIDTH = LIST_WIDTH
    self.levelList_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-LIST_WIDTH * 0.5, -LIST_HEIGHT * 0.5, LIST_WIDTH, LIST_HEIGHT),
            },
            ItemLevels
        )
        :addTo(self.nodeList)
   	-- self.levelList_:setData({1,2,3,4,5,6,7})
    -- 从游戏加载的等级数据里直接获取
    if tx.Level.levelData_ and #tx.Level.levelData_>0 then
        self.levelList_:setData(tx.Level.levelData_)
    else
        -- 查找本地文件 服务器已下载的文件
        local searchLocal = function()
            local dirPath = device.writablePath .. "cache" .. device.directorySeparator .. "level"
            if sa.isDirExist(dirPath) then
                local input_table = {}
                findindir(dirPath, "[%s%S]*", input_table, false)--查找txt文件
                for k,v in ipairs(input_table) do
                    local data = json.decode(io.readfile(v))
                    if data and type(data)=="table" and #data>0 and data[1].exp and data[1].level then
                        self.levelList_:setData(data)
                        return;
                    end
                end
            end
        end
        -- 最后一次缓存中的数据
        local lastUrl = tx.userDefault:getStringForKey(tx.cookieKeys.LEVEL_CONFIGU_URL,"")
        if lastUrl=="" then
            searchLocal()
        else
            sa.cacheFile(lastUrl, function(result, content)
                    if result == "success" then
                        local data = json.decode(content)
                        if data and #data>0 then
                            self.levelList_:setData(data)
                        else
                            searchLocal()
                        end
                    else
                        searchLocal()
                    end
                end)
        end
    end
end

function PanelLevel:setScrollContentTouchRect()
    self.levelList_:setScrollContentTouchRect()
end

return PanelLevel