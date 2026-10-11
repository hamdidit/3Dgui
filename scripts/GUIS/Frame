local classFunctions = {}

local Frame = {}
Frame.__index = classFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

function Frame.new(parent)
    local self = setmetatable({}, Frame)
    self.Size = Vector3.new(100, 100, 0) -- has to use Vector3 cause no support for Vector2
    self.Position = Vector3.new(0, 0, 0) -- starts from center cause i dont know the screen size
    self.BackgroundColor3 = Color3.new(1, 1, 1) -- white
    self.BackgroundTransparency = 0
    self.Parent = parent
    self.Children = {}
    self.Visible = true
    self.Rotation = 0
    self.ZIndex = 0
    self.ClassName = "Frame"
    self.Name = "Frame"
    
    return self
end

function classFunctions:Clone()
    local clone = Frame.new()
    clone.Size = self.Size
    clone.Position = self.Position
    clone.Visible = self.Visible
    clone.Rotation = self.Rotation
    clone.BackgroundColor3 = self.BackgroundColor3
    clone.BackgroundTransparency = self.BackgroundTransparency
    clone.ZIndex = self.ZIndex
    clone.Name = self.Name
    
    return clone
end

function classFunctions:GetCFrame(parent, finalCFrame, z)
    local newZ = 0
    if z == nil then
        z = -3 - (self.ZIndex * 0.011)
    	if mod:FindFirstChild("Sibling") then
        	if parent ~= nil then
           	 z = -3 - ((parent.ZIndex * 0.011) - (self.ZIndex * 0.011)) + 0.011
       	 end
    	end
    else
        newZ -= (self.ZIndex * 0.011)
        if mod:FindFirstChild("Sibling") then
        	if parent ~= nil then
           	 newZ += 0.011
       	 end
    	end
    end
    
    local camera = workspace.CurrentCamera
	if finalCFrame == nil then
	    finalCFrame = camera.CFrame * CFrame.new(self.Position.X / 100, self.Position.Y / 100, z)
	else
	    finalCFrame *= CFrame.new(0, 0, newZ)
	end
	
	
	if parent then
	    finalCFrame *= CFrame.Angles(0, 0, math.rad(parent.Rotation)) * CFrame.new(parent.Position.X / 100, parent.Position.Y / 100, 0)
	    if parent.ClassName == "ScrollingFrame" then
    	    finalCFrame *= CFrame.new(-parent.CanvasPosition.X / 100, -parent.CanvasPosition.Y / 100, 0)
    	end
	    
	    if parent.Parent then
	        return parent:GetCFrame(parent.Parent, finalCFrame, z)
	    end
	end
	return finalCFrame
end

function classFunctions:GetScale(parent, scale)
    if scale == nil then
        scale = 1
    end
    
    local stop = false
    for _, obj in self.Children do
        if stop then
       	 continue
        end
        
        if obj.ClassName == "UIScale" then
            scale += obj.Scale - 1
            stop = true
        end
    end
    
    if parent then
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
    	    return parent:GetScale(parent.Parent, scale)
    	end
    end
    
    return scale
end

function classFunctions:Draw()
    if self.Visible == true then
        local parent = self.Parent
        
        local z = -3 - (self.ZIndex * 0.011)
        if mod:FindFirstChild("Sibling") then
            if parent then
                z = -3 - ((parent.ZIndex * 0.011) - (self.ZIndex * 0.011)) + 0.011
            end
        end
        
        local finalCFrame = self:GetCFrame(parent)
* CFrame.Angles(0, 0, math.rad(self.Rotation))
        local scale = self:GetScale(parent)
        
    	local frame = Instance.new("Part")
    	frame.Size = Vector3.new((self.Size.X / 100) * scale, (self.Size.Y / 100) * scale, 0.01)
    	frame.CFrame = finalCFrame
		frame.Color = self.BackgroundColor3
    	frame.Anchored = true
    	frame.CanCollide = false
    	frame.CastShadow = false
    	frame.Transparency = self.BackgroundTransparency
    	frame.Parent = workspace:WaitForChild("3Dgui UIs")
    end
end

return Frame
