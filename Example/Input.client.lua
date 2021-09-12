local InputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local RoactWM = require(path.to.roactwm)

InputService.InputBegan:Connect(function(input)
	RoactWM.Adapter(function(history)
		if input.KeyCode == Enum.KeyCode.One then
			history:push("Window1")
		elseif input.KeyCode == Enum.KeyCode.Two then
			history:push("Window2")
		elseif input.KeyCode == Enum.KeyCode.Three then
			history:push("Window3")
		elseif input.KeyCode == Enum.KeyCode.Four then
			history:clear()
		end
	end)
end)