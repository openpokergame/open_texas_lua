local function removeModule(moduleName)
    package.loaded[moduleName] = nil
end

--已加载模块清理
removeModule("config")


--应用本地更新
if SA_UPDATE then
    print("version", SA_UPDATE.VERSION)
    print(dump(SA_UPDATE.STAGE_FILE_LIST))
    if SA_UPDATE.STAGE_FILE_LIST and #SA_UPDATE.STAGE_FILE_LIST > 0 then
        for i = 1, #SA_UPDATE.STAGE_FILE_LIST do
            local fileinfo = SA_UPDATE.STAGE_FILE_LIST[i]
            if fileinfo then
                if fileinfo.act and string.lower(fileinfo.act) == "framework" then
                    print("load framework ", fileinfo.name)
                    print(cc.LuaLoadChunksFromZIP(fileinfo.name))
                end
            end
        end
        for i = 1, #SA_UPDATE.STAGE_FILE_LIST do
            local fileinfo = SA_UPDATE.STAGE_FILE_LIST[i]
            if fileinfo then
                if fileinfo.act and string.lower(fileinfo.act) == "load" then
                    print("load zip ", fileinfo.name)
                    print(cc.LuaLoadChunksFromZIP(fileinfo.name))
                end
            end
        end
    end
end

require("app.TexasApp").new():run()
