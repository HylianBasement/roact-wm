local roactSource = script.Parent:FindFirstAncestor("node_modules"):WaitForChild("roact").src
local createSource = require(script.Parent.createSource)

return createSource(roactSource)