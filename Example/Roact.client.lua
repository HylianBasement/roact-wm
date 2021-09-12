local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")

local Roact = require(path.to.roact)
local RoactWM = require(path.to.roactwm)

local e = Roact.createElement
local PlayerGui = Player:WaitForChild("PlayerGui")

local WindowKind = {
	Window1 = "Window1",
	Window2 = "Window2",
	Window3 = "Window3",
}

local function Button(props)
	return e("TextButton", {
		BackgroundColor3 = props.IsSelected
			and Color3.fromRGB(50, 50, 255)
			or Color3.fromRGB(100, 100, 100),
		Text = props.Text,
		TextColor3 = props.IsSelected
			and Color3.new(1, 1, 1)
			or Color3.new(.2, .2, .2),
		TextSize = 14,
		Size = UDim2.fromOffset(50, 50),
		Position = UDim2.new(0, 100 + (55 * props.Order), 0, 5),
		[Roact.Event.Activated] = props.OnClick,
	})
end

local UI = e("ScreenGui", {}, {
	Buttons = e(RoactWM.AdapterComponent, {
		render = function(history)
			return e("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}, {
				Button1 = e(Button, {
					Order = 0,
					Text = "1",
					IsSelected = history:latestIs(WindowKind.Window1),
					OnClick = function()
						history:push(WindowKind.Window1)
					end,
				}),
				Button2 = e(Button, {
					Order = 1,
					Text = "2",
					IsSelected = history:latestIs(WindowKind.Window2),
					OnClick = function()
						history:push(WindowKind.Window2)
					end,
				}),
				Button3 = e(Button, {
					Order = 2,
					Text = "3",
					IsSelected = history:latestIs(WindowKind.Window3),
					OnClick = function()
						history:push(WindowKind.Window3)
					end,
				}),
			}) 
		end,
	}),
	WindowManager = e("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		Window1 = e(RoactWM.Window, {
			Id = WindowKind.Window1,
			Size = UDim2.fromOffset(500, 250),
			Position = UDim2.fromOffset(100, 100),
		}, {
			e("Frame", {
                                Size = UDim2.fromOffset(50, 50),
                        })	
		}),
		Window2 = e(RoactWM.Window, {
			Id = WindowKind.Window2,
			Size = UDim2.fromOffset(500, 250),
			Position = UDim2.fromOffset(200, 200),
		}),
		Window3 = e(RoactWM.Window, {
			Id = WindowKind.Window3,
			Size = UDim2.fromOffset(500, 250),
			Position = UDim2.fromOffset(300, 100),
		})
	})
})

Roact.mount(UI, PlayerGui, "App")