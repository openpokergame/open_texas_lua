local TimeUtil = class("TimeUtil")

-- -- 将一个时间数转换成"00:00:00"格式
function TimeUtil:getTimeString1(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00:00:00"
    else
        return string.format("%02d:%02d:%02d", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
    end
end

-- 将一个时间数转换成"00:00"格式
function TimeUtil:getTimeString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00:00"
    else
        return string.format("%02d:%02d", math.floor((timeInt/60)%60), timeInt%60)
    end
end

-- 将一个时间数转换成"00"分格式
function TimeUtil:getTimeMinuteString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00"
    else
        return string.format("%02d", math.floor((timeInt/60)%60))
    end
end

-- 将一个时间数转换成"00“秒格式
function TimeUtil:getTimeSecondString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00"
    else
        return string.format("%02d", timeInt%60)
    end
end

-- 将一个时间戳转换
function TimeUtil:getTimeStampString(time,splitStr,haveSec)
    if not time then 
        return ""
    end
    time = tonumber(time)
    if time<0 then
       return "" 
    end
    if not splitStr then splitStr="_" end
    local date = os.date("*t",time)
    local year = date.year
    local month = date.month
    if tonumber(month)<10 then
        month = "0"..month
    end
    local day = date.day
    if tonumber(day)<10 then
        day = "0"..day
    end
    local hour = date.hour
    if tonumber(hour)<10 then
        hour = "0"..hour
    end
    local min = date.min
    if tonumber(min)<10 then
        min = "0"..min
    end 
    if haveSec==true then
        local sec = date.sec
        if tonumber(sec)<10 then
            sec = "0"..sec
        end
        return date.year..splitStr..month..splitStr..day.."  "..hour..":"..min.."  "..sec
    end
    return date.year..splitStr..month..splitStr..day.."  "..hour..":"..min
end

function TimeUtil:getTimeSimpleString(time,splitStr,ishaveYear, isnohaveTime, onlyHourAndMin)
    if not time then 
        return ""
    end
    time = tonumber(time)
    if time<0 then
       return "" 
    end

    if not splitStr then splitStr="_" end
    local date = os.date("*t",time)
    local year = date.year
    local month = date.month
    if tonumber(month)<10 then
        month = "0"..month
    end
    local day = date.day
    if tonumber(day)<10 then
        day = "0"..day
    end
    local hour = date.hour
    if tonumber(hour)<10 then
        hour = "0"..hour
    end
    local min = date.min
    if tonumber(min)<10 then
        min = "0"..min
    end 
    if onlyHourAndMin==true then
        return hour..":"..min
    end
    -- 
    if ishaveYear then
        if isnohaveTime then
            return year..splitStr..month..splitStr..day
        else
            return year..splitStr..month..splitStr..day.." "..hour..":"..min
        end        
    else
        return month..splitStr..day.." "..hour..":"..min
    end
end

--[[
os.date("*t", time) 返回的table
time = {
    "day"   = 12 日
    "hour"  = 15 时
    "isdst" = false 是否夏令时
    "min"   = 7 分
    "month" = 11 月
    "sec"   = 12 秒
    "wday"  = 5 星期几(星期天为1)
    "yday"  = 316 一年中的第几天
    "year"  = 2015 年
 }]]

--判断是否为闰年
function TimeUtil:isLeapYear(year)
    if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
        return true
    end

    return false
end

function TimeUtil:getMessageTime(time)
    local date = os.date("*t", time)
    local dayStr = string.format("%02d-%02d-%02d", date.year, date.month, date.day)
    local timeStr = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)

    return dayStr .. " " .. timeStr
end

return TimeUtil