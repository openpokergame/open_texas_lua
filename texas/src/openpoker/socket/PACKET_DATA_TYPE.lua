--[[
    Socket数据包数据类型
]]
local PACKET_DATA_TYPE = {}

PACKET_DATA_TYPE.UBYTE  = "ubyte"
PACKET_DATA_TYPE.BYTE   = "byte"
PACKET_DATA_TYPE.SHORT  = "short"
PACKET_DATA_TYPE.USHORT = "ushort"
PACKET_DATA_TYPE.INT    = "int"
PACKET_DATA_TYPE.UINT   = "uint"
PACKET_DATA_TYPE.LONG   = "long"
PACKET_DATA_TYPE.ULONG  = "ulong"
PACKET_DATA_TYPE.STRING = "string"
PACKET_DATA_TYPE.ARRAY  = "array"
--*************************自定义fun接受发送数据*************************
PACKET_DATA_TYPE.readUByte=function(buf)
	local ret = buf:readUByte()
    if ret < 0 then
        ret = ret + 2^8
    end
    return ret
end
PACKET_DATA_TYPE.readByte=function(buf)
	local ret = buf:readByte()
    if ret > 2^7 -1 then
        ret = ret - 2^8
    end
    return ret
end
PACKET_DATA_TYPE.readInt=function(buf)
	local ret = buf:readInt()
	return ret
end
PACKET_DATA_TYPE.readUInt=function(buf)
	local ret = buf:readUInt()
	return ret
end
PACKET_DATA_TYPE.readShort=function(buf)
	local ret = buf:readShort()
	return ret
end
PACKET_DATA_TYPE.readUShort=function(buf)
	local ret = buf:readUShort()
	return ret
end
PACKET_DATA_TYPE.readLong=function(buf)
	local high = buf:readInt()
    local low = buf:readUInt()
    local ret = high * 2^32 + low
    return ret
end
PACKET_DATA_TYPE.readULong=function(buf)
	local high = buf:readInt()
	local low = buf:readUInt()
	local ret = high * 2^32 + low
	return ret
end
PACKET_DATA_TYPE.readString=function(buf)
	local ret = nil
	local len = buf:readUInt()
    -- 防止server出尔反尔，个别协议中出现字符串不以\0结尾的情况，这里做个判断
    local pos = buf:getPos()
    buf:setPos(pos + len -1)
    local lastByte = buf:readByte()
    buf:setPos(pos)

    if lastByte == 0 then
        ret = buf:readStringBytes(len - 1)
        buf:readByte() -- 消费掉最后一个字节
    else
        ret = buf:readStringBytes(len)
    end
    return ret
end
--*************************自定义fun发送数据*************************
PACKET_DATA_TYPE.writeUByte=function(buf,val)
	if type(val) == "string" and string.len(val) == 1 then
        buf:writeChar(val)
    else
        buf:writeUByte(tonumber(val) or 0)
    end
end
PACKET_DATA_TYPE.writeByte=function(buf,val)
	if type(val) == "string" and string.len(val) == 1 then
        buf:writeChar(val)
    else
        local n = tonumber(val)
        if n and n < 0 then
            n = n + 2^8
        end
        buf:writeByte(n or 0)
    end
end
PACKET_DATA_TYPE.writeInt=function(buf,val)
	buf:writeInt(tonumber(val) or 0)
end
PACKET_DATA_TYPE.writeUInt=function(buf,val)
	buf:writeUInt(tonumber(val) or 0)
end
PACKET_DATA_TYPE.writeShort=function(buf,val)
	buf:writeShort(tonumber(val) or 0)
end
PACKET_DATA_TYPE.writeUShort=function(buf,val)
	buf:writeUShort(tonumber(val) or 0)
end
PACKET_DATA_TYPE.writeLong=function(buf,value)
	local val = tonumber(value) or 0
    local low = val % 2^32
    local high = val / 2^32
    buf:writeInt(high)
    buf:writeUInt(low)
end
PACKET_DATA_TYPE.writeULong=function(buf,value)
	local val = tonumber(value) or 0
    local low = val % 2^32
    local high = val / 2^32
    buf:writeInt(high)
    buf:writeUInt(low)
end
PACKET_DATA_TYPE.writeString=function(buf,value)
	local val = tostring(value) or ""
    buf:writeUInt(#val + 1)
    buf:writeStringBytes(val)
    buf:writeByte(0)
end

return PACKET_DATA_TYPE
