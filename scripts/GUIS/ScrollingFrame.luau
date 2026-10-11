local classFunctions = {}

local ScrollingFrame = {}
ScrollingFrame.__index = classFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

local selves = {}
local scrollLeft = false
local scrollRight = false
local scrollUp = false
local scrollDown = false

function ScrollingFrame.new(parent)
    local self = setmetatable({}, ScrollingFrame)
    self.Size = Vector3.new(100, 100, 0) -- has to use Vector3 cause no support for Vector2
    self.Position = Vector3.new(0, 0, 0) -- starts from center cause i dont know the screen size
    self.BackgroundColor3 = Color3.new(1, 1, 1) -- white
    self.BackgroundTransparency = 0
    self.Parent = parent
    self.Children = {}
    self.Visible = true
    self.Rotation = 0
    self.ZIndex = 0
    self.CanvasPosition = Vector3.new(0, 0, 0)
    self.CanvasSizeOffset = Vector3.new(0, 0, 0)
    self.CanvasSizeScale = Vector3.new(2, 2, 0)
    self.ScrollBarSize = 8
    self.Selected = false
    self.ClassName = "ScrollingFrame"
    self.Name = "ScrollingFrame"
    self.Interactable = true
    self.VerticalScrollBarPosition = "Left"
    
    table.insert(selves, self)
    
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
    clone.ScrollBarSize = self.ScrollBarSize
    clone.CanvasSizeScale = self.CanvasSizeScale
    clone.CanvasSizeOffset = self.CanvasSizeOffset
    clone.Interactable = self.Interactable
    clone.ZIndex = self.ZIndex
    clone.Name = self.Name
    clone.VerticalScrollBarPosition = self.VerticalScrollBarPosition
    
    return clone
end

function classFunctions:GetCFrame(parent, finalCFrame, z)
    local newZ = 0
    if z == nil then
        z = -3 - (self.ZIndex * 0.012)
    	if mod:FindFirstChild("Sibling") then
        	if parent then
           	 z = -3 - ((parent.ZIndex * 0.012) - (self.ZIndex * 0.012)) + 0.012
       	 end
    	end
    else
        newZ -= (self.ZIndex * 0.012)
        if mod:FindFirstChild("Sibling") then
        	if parent then
           	 newZ += 0.012
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

function classFunctions:Draw(dt : number)
    if self.Visible == true then
        local parent = self.Parent
        
        local xCanvas = (self.CanvasSizeScale.X * self.Size.X) + self.CanvasSizeOffset.X
        local yCanvas = (self.CanvasSizeScale.Y * self.Size.Y) + self.CanvasSizeOffset.Y
        
        local finalCFrame = self:GetCFrame(parent) * CFrame.Angles(0, 0, math.rad(self.Rotation))
        local scale = self:GetScale(parent, 1)
        
    	local scrollingFrame = Instance.new("Part")
    	scrollingFrame.Size = Vector3.new((self.Size.X / 100) * scale, (self.Size.Y / 100) * scale, 0.01)
    	scrollingFrame.CFrame = finalCFrame
		scrollingFrame.Color = self.BackgroundColor3
    	scrollingFrame.Anchored = true
    	scrollingFrame.CanCollide = false
    	scrollingFrame.CastShadow = false
    	scrollingFrame.Transparency = self.BackgroundTransparency
    	scrollingFrame.Parent = workspace:WaitForChild("3Dgui UIs")
    	
    	local differX = xCanvas - self.Size.X
    	if differX > 0 then
    	    local scrollSizeX = ((self.Size.X / xCanvas) * self.Size.X) * scale
    	    local scrollPosY = (-((self.Size.Y / 2) / 100) + ((self.ScrollBarSize / 2) / 100)) * scale
    	    local scrollPosX = -(((self.Size.X / 2) / 100) * scale) + ((scrollSizeX / 100) / 2) + (self.CanvasPosition.X / 200) * scale
    	
    		local scrollBarX = Instance.new("Part")
    		scrollBarX.Color = Color3.new(0, 0, 0)
    		scrollBarX.Transparency = 0.5
    		scrollBarX.Anchored = true
    		scrollBarX.CanCollide = false
    		scrollBarX.CastShadow = false
    		scrollBarX.Parent = workspace:FindFirstChild("3Dgui UIs")
    		scrollBarX.CFrame = finalCFrame * CFrame.new(scrollPosX, scrollPosY, 0.012)
    		scrollBarX.Size = Vector3.new(scrollSizeX / 100, (self.ScrollBarSize / 100) * scale, 0.01)
    	end
    	
    	local differY = yCanvas - self.Size.Y
    	if differY > 0 then
    	    local scrollSizeY = ((self.Size.Y / yCanvas) * self.Size.Y) * scale
    	    local scrollPosX = (((self.Size.X / 2) / 100) - ((self.ScrollBarSize / 2) / 100)) * scale
    	    if self.VerticalScrollBarPosition == "Left" or self.VerticalScrollBarPosition == "left" then
    	        scrollPosX = (-((self.Size.X / 2) / 100) + ((self.ScrollBarSize / 2) / 100)) * scale
    	    end
    	    
    	    local scrollPosY = -(((self.Size.Y / 2) / 100) * scale) + ((scrollSizeY / 100) / 2) + (self.CanvasPosition.Y / 200) * scale
    	
    		local scrollBarY = Instance.new("Part")
    		scrollBarY.Color = Color3.new(0, 0, 0)
    		scrollBarY.Transparency = 0.5
    		scrollBarY.Anchored = true
    		scrollBarY.CanCollide = false
    		scrollBarY.CastShadow = false
    		scrollBarY.Parent = workspace:FindFirstChild("3Dgui UIs")
    		scrollBarY.CFrame = finalCFrame * CFrame.new(scrollPosX, scrollPosY, 0.012)
    		scrollBarY.Size = Vector3.new((self.ScrollBarSize / 100) * scale, scrollSizeY / 100, 0.01)
    	end
    	
    	if self.Selected then
    	    local selectOutline = Instance.new("Part")
    		selectOutline.Size = Vector3.new(((self.Size.X / 100) + (0.1)) * scale, ((self.Size.Y / 100) + (0.1)) * scale, 0.01)
    		selectOutline.CFrame = finalCFrame * CFrame.new(0, 0, -0.0009)
			selectOutline.Color = Color3.new(0, 1, 1)
    		selectOutline.Anchored = true
    		selectOutline.CanCollide = false
    		selectOutline.CastShadow = false
    		selectOutline.Parent = workspace:WaitForChild("3Dgui UIs")
    		
    		if differX > 0 then
    		    if scrollLeft then
    		    	local x = math.clamp(self.CanvasPosition.X - (dt * 200), 0, xCanvas - self.Size.X)
    		    	self.CanvasPosition = Vector3.new(x, self.CanvasPosition.Y, 0)
    			end
    		
    			if scrollRight then
    			    local x = math.clamp(self.CanvasPosition.X + (dt * 200), 0, xCanvas - self.Size.X)
    			    self.CanvasPosition = Vector3.new(x, self.CanvasPosition.Y, 0)
    			end
    		end
    		
    		if differY > 0 then
    		    if scrollUp then
    		    	local y = math.clamp(self.CanvasPosition.Y + (dt * 200), 0, yCanvas - self.Size.Y)
    		    	self.CanvasPosition = Vector3.new(self.CanvasPosition.X, y, 0)
    			end
    		
    			if scrollDown then
    			    local y = math.clamp(self.CanvasPosition.Y - (dt * 200), 0, yCanvas - self.Size.Y)
    			    self.CanvasPosition = Vector3.new(self.CanvasPosition.X, y, 0)
    			end
    		end
    		
    	end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Left and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        scrollLeft = true
    end
    
    if input.KeyCode == Enum.KeyCode.Right and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        scrollRight = true
    end
    
    if input.KeyCode == Enum.KeyCode.Up and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        scrollUp = true
    end
    
    if input.KeyCode == Enum.KeyCode.Down and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        scrollDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Left then
        scrollLeft = false
    end
    
    if input.KeyCode == Enum.KeyCode.Right then
        scrollRight = false
    end
    
    if input.KeyCode == Enum.KeyCode.Up then
        scrollUp = false
    end
    
    if input.KeyCode == Enum.KeyCode.Down then
        scrollDown = false
    end
end)

return ScrollingFrame
