-- simple general utility functions

local lime = {}

function lime.simple_curry(func, parameter)
    return function(...)
        func(parameter, ...)
    end
end

return lime
