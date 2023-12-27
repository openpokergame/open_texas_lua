function table.slice(tables, starts, ends)
	local sliceTable = {}
	if tables then
		if not starts then starts = 1 end
		if not ends then ends = #tables end
		if ends>#tables then ends = #tables end
		local index = 1
		for i = starts, ends, 1 do
			sliceTable[index] = tables[i]
			index = index + 1
		end
	end
	return sliceTable
end

function table.insertto(dest, src, begin)
	begin = checkint(begin)
	if begin <= 0 then
		begin = #dest + 1
	end

	local tailList = {}  -- 尾部数据
	if dest[begin] then -- 中间插入
		local len = #dest
		for i=begin,len,1 do
			tailList[i-begin+1] = dest[i]
		end
	end

	local len = #src
	for i = 0, len - 1 do
		dest[i + begin] = src[i + 1]
	end

	-- 尾部重新加入
	local tailLen = #tailList
	for i=0,tailLen-1 do
		dest[len + begin + i] = tailList[i + 1]
	end
end