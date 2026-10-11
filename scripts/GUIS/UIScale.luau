local classFunctions = {}

local UIScale = {}
UIScale.__index = classFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

function UIScale.new(parent)
    local self = setmetatable({}, UIScale)
    self.Parent = parent
    self.Children = {}
    self.Scale = 1
    self.ClassName = "UIScale"
    self.Name = "UIScale"
    
    return self
end

function classFunctions:Clone()
    local clone = UIScale.new()
    clone.Scale = self.Scale
    clone.Name = self.Name
    
    return clone
end
  
function classFunctions:Draw()
    
end

return UIScale
