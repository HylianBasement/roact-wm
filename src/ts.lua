local RoactSource = script.Parent:FindFirstAncestor("node_modules"):WaitForChild("roact").roact.src
local createSource = require(script.Parent.createSource)

return createSource(RoactSource)