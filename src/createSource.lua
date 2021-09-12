local History = require(script.Parent.History)

local createAdapter = require(script.Parent.createAdapter)
local createComponentAdapter = require(script.Parent.createComponentAdapter)
local createWindow = require(script.Parent.createWindow)

local function createSource(roactSource)
        local history = History.new(roactSource)

        return {
                Adapter = createAdapter(history),
                AdapterComponent = createComponentAdapter(roactSource, history),
                Window = createWindow(roactSource, history),
        }
end

return createSource