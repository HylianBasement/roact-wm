local None = require(script.Parent.None)
local merge = require(script.Parent.merge)
local copy = require(script.Parent.copy)

local windowPropsFilter = {
        Id = None,
        ModalEnabled = None,
        OnOpen = None,
        OnClosed = None,
        OnFocused = None,
        OnFocusReleased = None,
        FocusGui = None,
}

local function createWindow(roactSource, history)
        local Roact = require(roactSource)
        local e = Roact.createElement
        local Window = Roact.Component:extend("RoactWindow")

        function Window:init()
                assert(
                        type(self.props.Id) == "string" or type(self.props.Id) == "number",
                        "You must provide a valid Id property."
                )
                self.id = self.props.Id
        end

        function Window:render()
                local props = self.props
                local children = props[Roact.Children] or {}
                local id = self.id

                local windowProps = {}

                if not self.connection then
                        self.connection = history.changed:subscribe(function()
                                local lastHistory = self.lastHistory

                                if windowProps.OnOpen
                                and (
                                        not lastHistory or
                                        not lastHistory:has(id)
                                )
                                and history:has(id) then
                                        task.spawn(function()
                                                windowProps.OnOpen(history)
                                        end)
                                end

                                if windowProps.OnClosed
                                and lastHistory
                                and lastHistory:has(id)
                                and not history:has(id) then
                                        task.spawn(function()
                                                windowProps.OnClosed(history)
                                        end)
                                end

                                if windowProps.OnFocused
                                and history:latest() == id then
                                        task.spawn(function()
                                                windowProps.OnFocused(history)
                                        end)
                                end

                                if windowProps.OnFocusReleased
                                and lastHistory
                                and lastHistory:latest() == id
                                and history:latest() ~= id then
                                        task.spawn(function()
                                                windowProps.OnFocusReleased(history)
                                        end)
                                end

                                self.lastHistory = history:from(history)
                                self:setState({
                                        isOpen = history:has(id),
                                })
                        end)
                end

                local frameProps = copy(props)

                local screenGuiProps = {
                        DisplayOrder = 50 + history:index(id),
                        Enabled = self.state.isOpen,
                }

                for k, v in pairs(props) do
                        if windowPropsFilter[k] then
                                windowProps[k] = v
                                frameProps[k] = nil
                        end
                end

                local function Modal()
                        return e("TextButton", {
                                Active = false,
                                BackgroundTransparency = 1,
                                Text = "",
                                Size = UDim2.fromScale(1, 1),
                                ZIndex = 50,
                                [Roact.Event.MouseButton1Down] = function()
                                        history:push(id)
                                end,
                        })
                end

                local extraChildren = {}

                if windowProps.ModalEnabled == true then
                        if windowProps.FocusGui then
                                extraChildren["FocusArea"] = e(Roact.Portal, {
                                        target = windowProps.FocusGui:getValue(),
                                }, {
                                        FocusArea = e(Modal)
                                })
                        else
                                extraChildren["FocusArea"] = e(Modal)
                        end
                end

                local newChildren = merge(children, extraChildren)
                local fullProps = merge(frameProps, {
                        [Roact.Children] = newChildren
                })

                return e("ScreenGui", screenGuiProps, {
                        Frame = e("Frame", fullProps)
                })
        end

        function Window:didMount()
                task.defer(function()
                        history:push(self.id)
                end)
        end

        function Window:willUnmount()
                self.connection()
        end

        return Window
end

return createWindow