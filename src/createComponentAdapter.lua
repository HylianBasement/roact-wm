
local function createComponentAdapter(roactSource, history)
        local Roact = require(roactSource)
        local Adapter = Roact.Component:extend("ComponentAdapter")

        function Adapter:init()
                assert(
                        type(self.props.render) == "function",
                        "A valid render property must be provided."
                )
                self:update()
        end

        function Adapter:render()
                return self.props.render(history)
        end

        function Adapter:didMount()
                self.connection = history.changed:subscribe(function()
                        self:update()
                end)
        end

        function Adapter:willUnmount()
                self.connection()
        end

        function Adapter:update()
                self:setState({ history = history })
        end

        return Adapter
end

return createComponentAdapter