local classFunctions = {}

local UIStroke = {}
UIStroke.__index = classFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

function UIStroke.new(parent)
    local self = setmetatable({}, UIStroke)
    self.Color3 = Color3.new(0, 0, 0) -- black
    self.Parent = parent
    self.Children = {}
    self.Thickness = 1
    self.Enabled = true
    self.ZIndex = 0
    self.ClassName = "UIStroke"
    self.Name = "UIStroke"
    
    return self
end

function classFunctions:Clone()
    local clone = UIStroke.new()
    clone.Color3 = self.Color3
    clone.Thickness = self.Thickness
    clone.Enabled = self.Enabled
    clone.ZIndex = self.ZIndex
    clone.Name = self.Name
    
    return clone
end

function classFunctions:GetCFrame(parent, finalCFrame, z)
    local newZ = 0
    if z == nil then
        z = -3 - (parent.ZIndex * 0.011)
    	if mod:FindFirstChild("Sibling") then
        	if parent.Parent then
           	 z = -3 - ((parent.Parent.ZIndex * 0.011) - (parent.ZIndex * 0.011)) + 0.011
       	 end
    	end
    else
        newZ -= (parent.ZIndex * 0.011)
        if mod:FindFirstChild("Sibling") then
        	if parent.Parent then
           	 newZ += 0.011
       	 end
    	end
    end
    
    local camera = workspace.CurrentCamera
	if finalCFrame == nil then
	    finalCFrame = camera.CFrame * CFrame.new(parent.Position.X / 100, parent.Position.Y / 100, z)
	else
	    finalCFrame *= CFrame.new(0, 0, newZ)
	end

	if parent.Parent then
	    finalCFrame *= CFrame.Angles(0, 0, math.rad(parent.Parent.Rotation)) * CFrame.new(parent.Parent.Position.X / 100, parent.Parent.Position.Y / 100, 0)
	    if parent.Parent.ClassName == "ScrollingFrame" then
    	    finalCFrame *= CFrame.new(-parent.Parent.CanvasPosition.X / 100, -parent.Parent.CanvasPosition.Y / 100, 0)
    	end
	    
	    if parent.Parent.Parent then
	        return parent.Parent:GetCFrame(parent.Parent.Parent, finalCFrame, z)
	    end
	end
	return finalCFrame
end

function classFunctions:GetScale(parent, scale)
    if scale == nil then
        scale = 1
    end
    
    local stop = false
    for _, obj in parent.Children do
        if stop then
       	 continue
        end
        
        if obj.ClassName == "UIScale" then
            scale += obj.Scale - 1
            stop = true
        end
    end
    
    if parent.Parent then
        local stop = false
    	for _, obj in parent.Parent.Children do
        	if stop then
       	 	continue
        	end
        
        	if obj.ClassName == "UIScale" then
            	scale += obj.Scale - 1
           	 stop = true
        	end
    	end
    	
    	if parent.Parent.Parent then
    	    return parent.Parent:GetScale(parent.Parent.Parent, scale)
    	end
    end
    
    return scale
end

function classFunctions:Draw()
    if self.Enabled == true then
        local parent = self.Parent
        
        if parent then
            local finalCFrame = self:GetCFrame(parent) * CFrame.new(0, 0, -0.011) * CFrame.Angles(0, 0, math.rad(parent.Rotation))
            
            local finalCFrame = self:GetCFrame(parent)
* CFrame.Angles(0, 0, math.rad(parent.Rotation))
        	local scale = parent:GetScale(parent)
    		
    		local outline = Instance.new("Part")
    		outline.Size = Vector3.new(((parent.Size.X / 100) + (self.Thickness / 25)) * scale, ((parent.Size.Y / 100) + (self.Thickness / 25)) * scale, 0.01)
    		outline.CFrame = finalCFrame * CFrame.new(0, 0, -0.001)
			outline.Color = self.Color3
    		outline.Anchored = true
    		outline.CanCollide = false
    		outline.CastShadow = false
    		outline.Parent = workspace:WaitForChild("3Dgui UIs")
        end
    end
end

return UIStroke
