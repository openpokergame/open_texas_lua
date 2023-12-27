local LangUtil = {}
local lang = require(appconfig.LANG_FILE_NAME)

function mergeLang(lang, lang_ex)
    for k, v in pairs(lang_ex) do
        for kk, vv in pairs(v) do
            lang[k][kk] = vv
        end
    end
end

-- 切换语言时重新加载
function LangUtil.reload()
    lang = require(appconfig.LANG_FILE_NAME)

    for i = 1, 20 do
        local status, lang_ex = pcall(require, appconfig.LANG_FILE_NAME .. "_ex_" .. i)
        if not status then
            break
        else
            mergeLang(lang, lang_ex)
        end
    end
end

LangUtil.reload()

-- 获取一个指定键值的text
function LangUtil.getText(primeKey, secKey, ...)
    assert(primeKey ~= nil and secKey ~= nil, "must set prime key and secondary key")
    if LangUtil.hasKey(primeKey, secKey) then
        if (type(lang[primeKey][secKey]) == "string") then
            return LangUtil.formatString(lang[primeKey][secKey], ...)
        else
            return lang[primeKey][secKey]
        end
    else
        return ""
    end
end

-- 判断是否存在指定键值的text
function LangUtil.hasKey(primeKey, secKey)
    return lang[primeKey] ~= nil and lang[primeKey][secKey] ~= nil
end

-- formatString("{1},{2}", a, b)
function LangUtil.formatString(str, ...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        local output = str
        for i = 1, numArgs do
            local value = select(i, ...)
            output = string.gsub(output, "{" .. i .. "}", value)
        end
        return output
    else
        return str
    end
end

function LangUtil.compareResource(cn, th, path)
    for k, v in pairs(cn) do
        local found = false
        if th then
            for k1, v1 in pairs(th) do
                if k1 == k then
                    found = true
                    if type(v) == "table" then
                        LangUtil.compareResource(v, v1, path .. "." ..k)
                    end
                    break;
                end
            end
        end
        if not found then
            print(path .. "." .. k)
        end
    end
end

return LangUtil
