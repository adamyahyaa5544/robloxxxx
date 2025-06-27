--[[
  KICIAHOOK V2 - REBEL GENIUS EDITION
  FEATURES:
  - PRECISION BOX ESP WITH HEALTH BARS
  - SILENT AIM AIMBOT
  - RIGHT SHIFT TOGGLE MENU
  - MODERN TABBED INTERFACE
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = require(ReplicatedStorage.Modules.Utility)

-- Create GUI container
local KiciaContainer = Instance.new("ScreenGui")
KiciaContainer.Name = "KiciahookV2"
KiciaContainer.Parent = CoreGui
KiciaContainer.ResetOnSpawn = false
KiciaContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ESP storage
local ESPStore = {}

-- Stealth injection
local function GhostInject()
    if not CoreGui:FindFirstChild("KiciahookV2") then
        KiciaContainer.Parent = CoreGui
    end
end

-- Precision ESP creation
local function CreateESP(player)
    local ESPGroup = {}
    
    -- Main box
    local BoxOutline = Instance.new("Frame")
    BoxOutline.Name = "BoxOutline"
    BoxOutline.BackgroundTransparency = 1
    BoxOutline.BorderSizePixel = 2
    BoxOutline.BorderColor3 = Color3.new(0, 0, 0)
    BoxOutline.ZIndex = 5
    BoxOutline.Visible = false
    BoxOutline.Parent = KiciaContainer
    
    local Box = Instance.new("Frame")
    Box.Name = "Box"
    Box.BackgroundTransparency = 0.8
    Box.BackgroundColor3 = Color3.fromRGB(255, 20, 20)
    Box.BorderSizePixel = 0
    Box.ZIndex = 6
    Box.Visible = false
    Box.Parent = BoxOutline
    
    -- Health bar
    local HealthBarOutline = Instance.new("Frame")
    HealthBarOutline.Name = "HealthBarOutline"
    HealthBarOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    HealthBarOutline.BorderSizePixel = 0
    HealthBarOutline.ZIndex = 5
    HealthBarOutline.Visible = false
    HealthBarOutline.Parent = KiciaContainer
    
    local HealthBar = Instance.new("Frame")
    HealthBar.Name = "HealthBar"
    HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    HealthBar.BorderSizePixel = 0
    HealthBar.ZIndex = 6
    HealthBar.Visible = false
    HealthBar.Parent = HealthBarOutline
    
    -- Player info
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    InfoLabel.TextStrokeTransparency = 0.4
    InfoLabel.TextSize = 14
    InfoLabel.Font = Enum.Font.Code
    InfoLabel.Visible = false
    InfoLabel.ZIndex = 7
    InfoLabel.Parent = KiciaContainer
    
    ESPGroup.BoxOutline = BoxOutline
    ESPGroup.Box = Box
    ESPGroup.HealthBarOutline = HealthBarOutline
    ESPGroup.HealthBar = HealthBar
    ESPGroup.InfoLabel = InfoLabel
    ESPStore[player] = ESPGroup
    
    return ESPGroup
end

-- Player tracking
local function TrackPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not ESPStore[player] then
            CreateESP(player)
        end
    end
end

-- ESP update loop
local function UpdateESP()
    for player, esp in pairs(ESPStore) do
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and rootPart and head then
                -- Calculate box dimensions
                local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                if rootVis then
                    -- Box dimensions (corrected height)
                    local width = math.abs((headPos - feetPos).X)
                    local height = math.abs((headPos - feetPos).Y)
                    local boxPos = UDim2.new(0, rootPos.X - width/2, 0, feetPos.Y)
                    
                    -- Update box
                    esp.BoxOutline.Position = boxPos
                    esp.BoxOutline.Size = UDim2.new(0, width, 0, height)
                    esp.Box.Position = UDim2.new(0, 1, 0, 1)
                    esp.Box.Size = UDim2.new(1, -2, 1, -2)
                    esp.BoxOutline.Visible = true
                    esp.Box.Visible = true
                    
                    -- Health bar
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    esp.HealthBarOutline.Position = UDim2.new(0, rootPos.X - width/2 - 6, 0, feetPos.Y)
                    esp.HealthBarOutline.Size = UDim2.new(0, 4, 0, height)
                    esp.HealthBar.Size = UDim2.new(1, 0, healthPercent, 0)
                    esp.HealthBar.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                    esp.HealthBarOutline.Visible = true
                    esp.HealthBar.Visible = true
                    
                    -- Player info
                    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                    esp.InfoLabel.Text = player.Name.."\n"..math.floor(distance).."m | "..math.floor(humanoid.Health).."HP"
                    esp.InfoLabel.Position = UDim2.new(0, rootPos.X - width/2, 0, feetPos.Y - 20)
                    esp.InfoLabel.Visible = true
                else
                    esp.BoxOutline.Visible = false
                    esp.HealthBarOutline.Visible = false
                    esp.InfoLabel.Visible = false
                end
            else
                esp.BoxOutline.Visible = false
                esp.HealthBarOutline.Visible = false
                esp.InfoLabel.Visible = false
            end
        else
            esp.BoxOutline.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.InfoLabel.Visible = false
        end
    end
end

-- Aimbot functionality
local AimbotEnabled = true
local AimbotFOV = 120
local TeamCheck = true
local VisibleCheck = true
local HitParts = {"Head", "UpperTorso"}

local function GetPlayers()
    local entities = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(entities, player.Character)
        end
    end
    return entities
end

local function GetClosestPlayer()
    local closest, closestDistance = nil, math.huge
    local character = LocalPlayer.Character
    if not character then return end

    for _, entity in ipairs(GetPlayers()) do
        if not entity:FindFirstChild("HumanoidRootPart") then continue end
        
        -- Team check
        if TeamCheck and entity:FindFirstChildWhichIsA("Team") and LocalPlayer.Team == entity:FindFirstWhichIsA("Team") then
            continue
        end
        
        -- Visibility check
        if VisibleCheck then
            local ray = Ray.new(Camera.CFrame.Position, (entity.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000)
            local hit, position = workspace:FindPartOnRay(ray, LocalPlayer.Character)
            if hit and not hit:IsDescendantOf(entity) then
                continue
            end
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(entity.HumanoidRootPart.Position)
        if not onScreen then continue end
        
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        
        if distance < AimbotFOV and distance < closestDistance then
            closest = entity
            closestDistance = distance
        end
    end
    return closest
end

-- Raycast hook for silent aim
local oldRaycast = Utility.Raycast
Utility.Raycast = function(...)
    if AimbotEnabled then
        local args = {...}
        if #args > 0 and args[4] == 999 then
            local closest = GetClosestPlayer()
            if closest then
                local hitPart = nil
                for _, partName in ipairs(HitParts) do
                    local part = closest:FindFirstChild(partName)
                    if part then
                        hitPart = part
                        break
                    end
                end
                if hitPart then
                    args[3] = hitPart.Position
                end
            end
        end
    end
    return oldRaycast(unpack({...}))
end

-- Menu system
local MenuVisible = false
local KiciaMenu = Instance.new("Frame")
KiciaMenu.Name = "KiciaMenu"
KiciaMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
KiciaMenu.BackgroundTransparency = 0.2
KiciaMenu.Position = UDim2.new(0.3, 0, 0.3, 0)
KiciaMenu.Size = UDim2.new(0, 400, 0, 300)
KiciaMenu.Active = true
KiciaMenu.Draggable = true
KiciaMenu.Visible = false
KiciaMenu.Parent = KiciaContainer
KiciaMenu.BorderColor3 = Color3.fromRGB(80, 0, 120)

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = KiciaMenu

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Parent = KiciaMenu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Text = "Kiciahook V2 | Rivals"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(220, 120, 255)
Title.TextSize = 14
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

-- Tab buttons
local Tabs = {"Combat", "Visuals", "Misc", "Settings"}
local TabFrames = {}
local CurrentTab = "Combat"

local TabContainer = Instance.new("Frame")
TabContainer.BackgroundTransparency = 1
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.Parent = KiciaMenu

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(0.25, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = TabContainer
    
    local TabFrame = Instance.new("Frame")
    TabFrame.BackgroundTransparency = 1
    TabFrame.Size = UDim2.new(1, -20, 1, -70)
    TabFrame.Position = UDim2.new(0, 10, 0, 70)
    TabFrame.Visible = false
    TabFrame.Parent = KiciaMenu
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        for name, frame in pairs(TabFrames) do
            frame.Visible = (name == tabName)
        end
    end)
end

-- Combat Tab
local CombatFrame = TabFrames["Combat"]
do
    local LegitbotLabel = Instance.new("TextLabel")
    LegitbotLabel.Text = "Legitbot"
    LegitbotLabel.TextColor3 = Color3.new(1,1,1)
    LegitbotLabel.BackgroundTransparency = 1
    LegitbotLabel.Size = UDim2.new(1, 0, 0, 20)
    LegitbotLabel.Font = Enum.Font.GothamBold
    LegitbotLabel.TextSize = 14
    LegitbotLabel.Parent = CombatFrame
    
    local EnabledLabel = Instance.new("TextLabel")
    EnabledLabel.Text = "Enabled"
    EnabledLabel.TextColor3 = Color3.new(0.8,0.8,0.8)
    EnabledLabel.BackgroundTransparency = 1
    EnabledLabel.Position = UDim2.new(0, 0, 0, 25)
    EnabledLabel.Size = UDim2.new(0.5, 0, 0, 20)
    EnabledLabel.Font = Enum.Font.Gotham
    EnabledLabel.TextSize = 12
    EnabledLabel.Parent = CombatFrame
    
    local EnabledToggle = Instance.new("TextButton")
    EnabledToggle.Text = AimbotEnabled and "ON" : "OFF"
    EnabledToggle.Size = UDim2.new(0, 40, 0, 20)
    EnabledToggle.Position = UDim2.new(0.5, 0, 0, 25)
    EnabledToggle.BackgroundColor3 = AimbotEnabled and Color3.new(0,0.5,0) or Color3.new(0.5,0,0)
    EnabledToggle.Font = Enum.Font.Gotham
    EnabledToggle.TextSize = 12
    EnabledToggle.Parent = CombatFrame
    
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Text = "FOV: "..AimbotFOV
    FOVLabel.TextColor3 = Color3.new(0.8,0.8,0.8)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Position = UDim2.new(0, 0, 0, 50)
    FOVLabel.Size = UDim2.new(0.5, 0, 0, 20)
    FOVLabel.Font = Enum.Font.Gotham
    FOVLabel.TextSize = 12
    FOVLabel.Parent = CombatFrame
    
    local FOVSlider = Instance.new("Frame")
    FOVSlider.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    FOVSlider.Size = UDim2.new(0.5, 0, 0, 10)
    FOVSlider.Position = UDim2.new(0.5, 0, 0, 55)
    FOVSlider.Parent = CombatFrame
    
    local FOVFill = Instance.new("Frame")
    FOVFill.BackgroundColor3 = Color3.new(0,0.5,1)
    FOVFill.Size = UDim2.new(AimbotFOV/600, 0, 1, 0)
    FOVFill.Parent = FOVSlider
    
    -- Toggle functionality
    EnabledToggle.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        EnabledToggle.Text = AimbotEnabled and "ON" : "OFF"
        EnabledToggle.BackgroundColor3 = AimbotEnabled and Color3.new(0,0.5,0) or Color3.new(0.5,0,0)
    end)
    
    -- FOV slider functionality
    FOVSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UIS:GetMouseLocation()
            local sliderPos = FOVSlider.AbsolutePosition.X
            local sliderSize = FOVSlider.AbsoluteSize.X
            local relativeX = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            AimbotFOV = math.floor((relativeX / sliderSize) * 600)
            FOVLabel.Text = "FOV: "..AimbotFOV
            FOVFill.Size = UDim2.new(AimbotFOV/600, 0, 1, 0)
        end
    end)
end

-- Visuals Tab
local VisualsFrame = TabFrames["Visuals"]
do
    local ESPLabel = Instance.new("TextLabel")
    ESPLabel.Text = "ESP"
    ESPLabel.TextColor3 = Color3.new(1,1,1)
    ESPLabel.BackgroundTransparency = 1
    ESPLabel.Size = UDim2.new(1, 0, 0, 20)
    ESPLabel.Font = Enum.Font.GothamBold
    ESPLabel.TextSize = 14
    ESPLabel.Parent = VisualsFrame
    
    -- Add visual settings here
end

-- Menu toggle
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MenuVisible = not MenuVisible
        KiciaMenu.Visible = MenuVisible
        TabFrames[CurrentTab].Visible = MenuVisible
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuVisible = false
    KiciaMenu.Visible = false
end)

-- Main runtime
spawn(function()
    while task.wait(0.5) do
        GhostInject()
        TrackPlayers()
    end
end)

RunService.Heartbeat:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(player)
    if ESPStore[player] then
        for _, element in pairs(ESPStore[player]) do
            element:Destroy()
        end
        ESPStore[player] = nil
    end
end)

print("KICIAHOOK V2 ACTIVATED | RIGHT SHIFT TOGGLE")
