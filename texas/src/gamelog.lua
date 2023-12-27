if CF_DEBUG > 0 then
	if device.platform == "windows" then
	    LOG_FILE = io.open("super_poker.txt", "w+")
	else
	    LOG_FILE = io.open(device.writablePath .. "/" .. "super_poker.txt", "w+")
	end

	GAME_PRINT = print

	local WRITE_LOG = function(str)
	    LOG_FILE:write(str)
	    LOG_FILE:write("\r")
	end

	print = function(...)
		local numArgs = select("#", ...)
		if numArgs >= 1 then
			local output = ""
	        for i = 1, numArgs do
	            local value = select(i, ...)
	            output = output .. tostring(value) .. " "
	        end

			LOG_FILE:write(output)
	    	LOG_FILE:write("\r\n")
	    end

	    GAME_PRINT(...)
	end

	return WRITE_LOG
else
	return nil
end
