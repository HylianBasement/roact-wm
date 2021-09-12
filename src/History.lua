local copy = require(script.Parent.copy)

local History = {}
History.__index = History

function History.new(roactSource, initialHistory, omitSignal)
        local self = {}

        self._history = initialHistory or {}
        self._roactSource = roactSource

        if not omitSignal then
                local createSignal = require(roactSource.createSignal)
                self.changed = createSignal()
        end

        setmetatable(self, History)

        return self
end

function History.Is(obj)
        return (type(obj) == "table" and getmetatable(obj) == History)
end

function History:__tostring()
        return "<History>"
end

function History:_dispatch(newHistory)
        self._history = newHistory

        if self.changed then
                task.spawn(function()
                        self.changed:fire(newHistory)
                end)
        end
end

function History:from(history)
        assert(History.Is(history))
        return History.new(self._roactSource, history:get(), true)
end

function History:get()
        return copy(self._history)
end

function History:set(history)
        local newHistory = {}

        for _, v in ipairs(history) do
                table.insert(newHistory, v)
        end

        self:_dispatch(newHistory)
end

function History:has(value)
        for _, v in ipairs(self._history) do
                if value == v then
                        return true
                end
        end
        return false
end

function History:push(value)
        assert(type(value) == "string" or type(value) == "number")
        if self:latest() == value then
                return
        end

        local newHistory = {}
        local lastValue

        for _, v in ipairs(self._history) do
                if value == v then
                        lastValue = v
                else
                        table.insert(newHistory, v)
                end
        end

        table.insert(newHistory, lastValue or value)

        self:_dispatch(newHistory)
end

function History:remove(value)
        if not self:has(value) then
                return
        end
        local newHistory = self:get()

        for i, v in ipairs(newHistory) do
                if value == v then
                        table.remove(newHistory, i)
                        self:_dispatch(newHistory)

                        break
                end
        end
end

function History:index(value)
        for i, v in ipairs(self._history) do
                if value == v then
                        return i
                end
        end

        return -1
end

function History:clear()
        self:_dispatch({})
end

function History:size()
        return #self._history
end

function History:latest()
        return self:get()[self:size()]
end

function History:latestIs(value)
        return self:latest() == value
end

return History