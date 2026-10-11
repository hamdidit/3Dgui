--[[
                                   
                                        ==============                                              
                                =========================                                           
                           ================        ========                                         
                          =========                   ======                                        
                                                        ====                                        
                      ==========       ==============    ====                                       
                    ==============     ================  =====                                      
                     ==============    =================  =====                                     
                      =     =======    ======     =======  ====              ====                   
                           ========    ======      =======  ====         ========                   
                        =========      ======      =======   =================:::                   
                        ==========     ======      =======    =============  ::::                   
                        ===========    ======      ======   ::::::: :::  ::: ::::                   
                             =======   ======     ======= ::::::::: ::: :::: ::::                   
                    ================   =================  ::::::::  ::: :::: ::::                   
                   ================    ================    ::::::   ::: :::: ::::                   
                    ==============     ==============     ::::::::: :::::::: ::::                   
                         ====                             :::::::::   ::                            
                                                          :::::::::                                 
                                                            ::::                                    
                                                                                          
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mod = ReplicatedStorage["3Dgui"]

local ThreeDgui = {}
local objects = {}

local selectX = 1
local selectY = 1
local selectActivated = false

function ThreeDgui.new(class : string, parent : {})
    --[[local folder = workspace:FindFirstChild("3Dgui UIs")
    if folder == nil then
        folder = Instance.new("Folder")
        folder.Name = "3Dgui UIs"
        folder.Parent = workspace
    end
    ]]
    
    local module = mod:FindFirstChild(class)
    
    if module then
        if not module:IsA("ModuleScript") then
       	 print("Not a module")
        	return
    	end
        
        local ui = require(module).new(parent)
        table.insert(objects, ui)
        
        if parent then
            table.insert(parent.Children, ui)
        end
        
        --ui:Draw()
        return ui
    else
        print("Could not find class")
        return
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if selectActivated then
         if input.KeyCode == Enum.KeyCode.Left and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        	 selectX -= 1
             if selectX < 1 then
                 selectX = 1
             end
         end
    	 if input.KeyCode == Enum.KeyCode.Right and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
       	selectX += 1
    	end
    
    	if input.KeyCode == Enum.KeyCode.Up and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        	selectY -= 1
        	if selectY < 1 then
            	selectY = 1
        	end
    	end
    
    	if input.KeyCode == Enum.KeyCode.Down and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        	selectY += 1
    	end
    end
    
    if input.KeyCode == Enum.KeyCode.BackSlash then
        selectActivated = not selectActivated 
    end
end)

RunService.Heartbeat:Connect(function(dt)
    local folder = workspace:FindFirstChild("3Dgui UIs")
	if folder == nil then
   	 folder = Instance.new("Folder")
   	 folder.Name = "3Dgui UIs"
        folder.Parent = workspace
    end
    
    local selects = {}
    local indexY = {}
    local indexX = {}
    
    -- selecting order
    for _, uiObj in pairs(objects) do
        if uiObj.Interactable == true then
            local x = uiObj.Position.X
            local y = uiObj.Position.Y
            
        	if selects[y] == nil then
        	    table.insert(indexY, y)
        	    
            	selects[y] = {value = y, objects = {}}
        	end
        	
        	uiObj.Selected = false
        	selects[y].objects[x] = uiObj
        end
    end
    
    table.sort(indexY, function(a, b)
        return a > b
    end)
    
    -- again but for X
    for _, uiObj in pairs(objects) do
        if uiObj.Interactable == true then
            local x = uiObj.Position.X
            local y = uiObj.Position.Y
            
            local index = table.find(indexY, y)
            if indexX[index] == nil then
                indexX[index] = {}
            end
        	
        	table.insert(indexX[index], x)
        end
    end
    
    for _, values in pairs(indexX) do
        table.sort(values, function(a, b)
            return a < b
        end)
    end
    
    if #indexY > 0 and selectActivated then
        if selectY > #indexY then
            selectY = #indexY
        end
        
        local selectableObj = selects[indexY[selectY]].objects
        if selectX > #indexX[selectY] then
            selectX = #indexX[selectY]
        end
        
        selectableObj[indexX[selectY][selectX]].Selected = true
    end
    
    for _, obj in pairs(folder:GetChildren()) do
        obj:Destroy()
    end
    
    for _, uiObj in pairs(objects) do
    	uiObj:Draw(dt)
    end
end)

return ThreeDgui
