local classFunctions = {}

local TextBox = {}
TextBox.__index = classFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

local vortexFont = require(ReplicatedStorage.VortexFont)
local caps = false

function TextBox.new(parent)
    local self = setmetatable({}, TextBox)
    self.Size = Vector3.new(200, 50, 0) -- has to use Vector3 cause no support for Vector2
    self.Position = Vector3.new(0, 0, 0) -- starts from center cause i dont know the screen size
    self.BackgroundColor3 = Color3.new(1, 1, 1) -- white
    self.BackgroundTransparency = 0
    self.Parent = parent
    self.Children = {}
    self.Visible = true
    self.Rotation = 0
    self.ZIndex = 0
    self.ClassName = "TextBox"
    self.Text = "Label"
    self.TextColor3 = Color3.new(0, 0, 0)
    self.TextSize = 14
    self.id = math.random(-500000, 500000)
    self.Font = "Pixel"
    self.Name = "TextBox"
    self.Interactable = true
    self.Selected = true
    
    local props: VortexFont.Font = {
        origin = workspace.Baseplate.Position,
		pixelSize = self.TextSize / 100,
		color = self.TextColor3,
		rotation = Vector3.new(0, 0, math.rad(self.Rotation)),
		align = "center",
    }
    
    vortexFont:CreateText(props, self.Text, self.id)
    
    return self
end

function classFunctions:Clone()
    local clone = TextBox.new()
    clone.Size = self.Size
    clone.Position = self.Position
    clone.Visible = self.Visible
    clone.Rotation = self.Rotation
    clone.BackgroundColor3 = self.BackgroundColor3
    clone.BackgroundTransparency = self.BackgroundTransparency
    clone.ZIndex = self.ZIndex
    clone.Name = self.Name
    clone.Font = self.Font
    clone.TextSize = self.TextSize
    clone.TextColor3 = self.TextColor3
    clone.Text = self.Text
    clone.Interactable = self.Interactable
    
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
        local camera = workspace.CurrentCamera
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
        
    	local button = Instance.new("Part")
    	button.Size = Vector3.new((self.Size.X / 100) * scale, (self.Size.Y / 100) * scale, 0.01)
    	button.CFrame = finalCFrame
		button.Color = self.BackgroundColor3
    	button.Anchored = true
    	button.CanCollide = false
    	button.CastShadow = false
    	button.Transparency = self.BackgroundTransparency
    	button.Parent = workspace:WaitForChild("3Dgui UIs")
    	
    	local y, x, z = finalCFrame:ToEulerAnglesXYZ()
    	
    	local props: VortexFont.Font = {
        	origin = (finalCFrame * CFrame.new(0, -((self.Size.Y * scale) / ((7 * scale) / ((self.TextSize * scale) / 14))) / 100, 0.01)).Position,
			pixelSize = (self.TextSize / 100) * scale,
			color = self.TextColor3,
			rotation = Vector3.new(y, x, z), 
			align = "center",
    	}
    	
    	vortexFont:UpdateText(self.id, props, self.Text)
    	
    	if self.Selected then
			local selectOutline = Instance.new("Part")
    		selectOutline.Size = Vector3.new(((self.Size.X / 100) + (0.1)) * scale, ((self.Size.Y / 100) + (0.1)) * scale, 0.01)
    		selectOutline.CFrame = finalCFrame * CFrame.new(0, 0, -0.0009)
			selectOutline.Color = Color3.new(0, 1, 1)
    		selectOutline.Anchored = true
    		selectOutline.CanCollide = false
    		selectOutline.CastShadow = false
    		selectOutline.Parent = workspace:WaitForChild("3Dgui UIs")

			if lastPressed then
			    local text = string.char(lastPressed.Value)
			    if lastPressed == Enum.KeyCode.Space then
			        text = " "
			    end
			    
			    if lastPressed == Enum.KeyCode.Backspace then
			        self.Text = self.Text:sub(1, #self.Text - 1)
			        lastPressed = nil
			        return
			    end
			    
			    if caps then
			        text = string.upper(text)
			    else
			        text = string.lower(text)
			    end
			    
			    self.Text ..= text
			    lastPressed = nil
			end
			
		end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        if input.KeyCode == Enum.KeyCode.LeftShift then
            caps = true
            return
        end
        
        lastPressed = input.KeyCode
        
    end 
end)

return TextBox
