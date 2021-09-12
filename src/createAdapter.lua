
local function createAdapter(history)
        return function(callback)
                task.spawn(function()
                        callback(history)
                end)
        end
end

return createAdapter