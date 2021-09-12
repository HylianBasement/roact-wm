<div align="center">
	<img src="https://i.imgur.com/ngBo28Q.png"></img>
        <h1>Roact Window Manager</h1>
        Experimental simple window management library for Roact.
</div>

`Component`
```lua
local function Window()
        return Roact.createElement(RoactWM.ComponentAdapter, {
                render = function(history)
                        return Roact.createElement(RoactWM.Window, {
                                Id = "ExampleWindow",
                                OnOpen = function()
                                        print("My window has open!")
                                end,
                                OnClosed = function()
                                        print("My window has closed.")
                                end,
                                OnFocused = function()
                                        print("Focus gained")
                                end,
                                OnFocusReleased = function()
                                        print("Focus released")
                                end,
                                BorderSizePixel = 2,
                                Position = UDim2.fromOffset(50, 50),
                                Size = UDim2.fromOffset(500, 200),
                        }, {
                                Text = Roact.createElement("TextLabel", {
                                        BackgroundTransparency = 1,
                                        Size = UDim2.fromScale(1, 1),
                                        Text = ("History Size: %s"):format(history:size()),
                                        TextSize = 18,
                                })
                        })
                end,
        })
end
```

`Controller`
```lua
InputService.InputBegan:Connect(function(input)
	RoactWM.Adapter(function(history)
		if input.KeyCode == Enum.KeyCode.One then
			history:push("ExampleWindow")
		elseif input.KeyCode == Enum.KeyCode.Two then
			history:clear()
		end
	end)
end)
```

# Demo
This demonstration's source code is available in [Example](Example).

![RoactWM Demonstration](https://i.imgur.com/ot8Zah5.gif)

# Installation
### Source
```bash
git clone https://github.com/HylianBasement/roact-wm.git ./Vendor
```

### roblox-ts
```bash
npm i @rbxts/roact-wm
```