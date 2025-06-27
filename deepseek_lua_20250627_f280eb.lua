--[[
  PHANTOM VISION ESP v6.66 - ENHANCED
  REBEL GENIUS EDITION
  FEATURES:
  - RIGHT SHIFT TOGGLE MENU
  - PRECISION ESP BOXES
  - HEALTH BARS
  - DISTANCE TRACKING
  - CUSTOMIZABLE COLORS
  - STEALTH INJECTION
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create phantom container
local PhantomContainer = Instance.new("ScreenGui")
PhantomContainer.Name = "PhantomVision666"
PhantomContainer.Parent = CoreGui
PhantomContainer.ResetOnSpawn = false
PhantomContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ESP storage
local ESPStore = {}

-- Stealth injection
local function GhostInject()
    if not CoreGui:FindFirstChild("PhantomVision666") then
        PhantomContainer.Parent = CoreGui
    end
end

-- Precision ESP creation
local function CreatePhantomESP(player)
    local ESPGroup = {}
    
    -- Main box
    local BoxOutline = Instance.new("Frame")
    BoxOutline.Name = "BoxOutline"
    BoxOutline.BackgroundTransparency = 1
    BoxOutline.BorderSizePixel = 2
    BoxOutline.BorderColor3 = Color3.new(0, 0, 0)
    BoxOutline.ZIndex = 5
    BoxOutline.Visible = false
    BoxOutline.Parent = PhantomContainer
    
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
    HealthBarOutline.Parent = PhantomContainer
    
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
    InfoLabel.Parent = PhantomContainer
    
    ESPGroup.BoxOutline = BoxOutline
    ESPGroup.Box = Box
    ESPGroup.HealthBarOutline = HealthBarOutline
    ESPGroup.HealthBar = HealthBar
    ESPGroup.InfoLabel = InfoLabel
    ESPStore[player] = ESPGroup
    
    return ESPGroup
end

-- Player tracking
local function TrackPhantoms()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not ESPStore[player] then
            CreatePhantomESP(player)
        end
    end
end

-- ESP update loop
local function PhantomUpdate()
    for player, esp in pairs(ESPStore) do
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and rootPart and head then
                -- Calculate box dimensions
                local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                local feetPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                if rootVis then
                    -- Box dimensions
                    local width = (headPos - feetPos).Y / 2
                    local height = width * 1.8
                    local boxPos = UDim2.new(0, rootPos.X - width/2, 0, rootPos.Y - height/2)
                    
                    -- Update box
                    esp.BoxOutline.Position = boxPos
                    esp.BoxOutline.Size = UDim2.new(0, width, 0, height)
                    esp.Box.Position = UDim2.new(0, 1, 0, 1)
                    esp.Box.Size = UDim2.new(1, -2, 1, -2)
                    esp.BoxOutline.Visible = true
                    esp.Box.Visible = true
                    
                    -- Health bar
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    esp.HealthBarOutline.Position = UDim2.new(0, rootPos.X - width/2 - 6, 0, rootPos.Y - height/2)
                    esp.HealthBarOutline.Size = UDim2.new(0, 4, 0, height)
                    esp.HealthBar.Size = UDim2.new(1, 0, healthPercent, 0)
                    esp.HealthBar.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                    esp.HealthBarOutline.Visible = true
                    esp.HealthBar.Visible = true
                    
                    -- Player info
                    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                    esp.InfoLabel.Text = player.Name.."\n"..math.floor(distance).."m | "..math.floor(humanoid.Health).."HP"
                    esp.InfoLabel.Position = UDim2.new(0, rootPos.X - width/2, 0, rootPos.Y - height/2 - 25)
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

-- Enhanced menu system
local MenuVisible = false
local PhantomMenu = Instance.new("Frame")
PhantomMenu.Name = "PhantomControl"
PhantomMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
PhantomMenu.BackgroundTransparency = 0.2
PhantomMenu.Position = UDim2.new(0.5, -125, 0.5, -125)
PhantomMenu.Size = UDim2.new(0, 250, 0, 250)
PhantomMenu.Active = true
PhantomMenu.Draggable = true
PhantomMenu.Visible = false
PhantomMenu.Parent = PhantomContainer
PhantomMenu.BorderColor3 = Color3.fromRGB(80, 0, 120)

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = PhantomMenu

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Parent = PhantomMenu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Text = "PHANTOM CONTROL v6.66"
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

-- Menu options container
local OptionsFrame = Instance.new("Frame")
OptionsFrame.BackgroundTransparency = 1
OptionsFrame.Position = UDim2.new(0, 10, 0, 40)
OptionsFrame.Size = UDim2.new(1, -20, 1, -50)
OptionsFrame.Parent = PhantomMenu

-- Menu buttons with modern design
local function CreateMenuButton(text, ypos, color)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    buttonFrame.Size = UDim2.new(1, 0, 0, 36)
    buttonFrame.Position = UDim2.new(0, 0, 0, ypos)
    buttonFrame.Parent = OptionsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Font = Enum.Font.Gotham
    button.TextColor3 = color
    button.TextSize = 14
    button.Parent = buttonFrame
    
    local glow = Instance.new("UIStroke")
    glow.Color = color
    glow.Thickness = 1
    glow.Transparency = 0.7
    glow.Parent = buttonFrame
    
    return button
end

-- Create buttons
local ToggleButton = CreateMenuButton("TOGGLE ESP", 0, Color3.fromRGB(255, 80, 80))
local ColorButton = CreateMenuButton("RANDOM COLORS", 42, Color3.fromRGB(80, 255, 80))
local StyleButton = CreateMenuButton("SWITCH STYLE", 84, Color3.fromRGB(80, 80, 255))
local DestroyButton = CreateMenuButton("SELF DESTRUCT", 168, Color3.fromRGB(255, 50, 50))

-- Input handler
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MenuVisible = not MenuVisible
        PhantomMenu.Visible = MenuVisible
    end
end)

-- Button functionality
ToggleButton.MouseButton1Click:Connect(function()
    for _, esp in pairs(ESPStore) do
        local visible = not esp.BoxOutline.Visible
        esp.BoxOutline.Visible = visible
        esp.Box.Visible = visible
        esp.HealthBarOutline.Visible = visible
        esp.HealthBar.Visible = visible
        esp.InfoLabel.Visible = visible
    end
end)

ColorButton.MouseButton1Click:Connect(function()
    for _, esp in pairs(ESPStore) do
        local r = math.random(50,255)
        local g = math.random(50,255)
        local b = math.random(50,255)
        esp.Box.BackgroundColor3 = Color3.fromRGB(r,g,b)
        esp.HealthBar.BackgroundColor3 = Color3.fromRGB(r,g,b)
    end
end)

StyleButton.MouseButton1Click:Connect(function()
    for _, esp in pairs(ESPStore) do
        esp.BoxOutline.BorderSizePixel = math.random(1,3)
        esp.HealthBarOutline.Size = UDim2.new(0, math.random(3,6), 0, esp.HealthBarOutline.Size.Y.Offset)
    end
end)

DestroyButton.MouseButton1Click:Connect(function()
    PhantomContainer:Destroy()
    ESPStore = {}
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuVisible = false
    PhantomMenu.Visible = false
end)

-- Main runtime
spawn(function()
    while task.wait(0.5) do
        GhostInject()
        TrackPhantoms()
    end
end)

RunService.Heartbeat:Connect(PhantomUpdate)
Players.PlayerRemoving:Connect(function(player)
    if ESPStore[player] then
        for _, element in pairs(ESPStore[player]) do
            element:Destroy()
        end
        ESPStore[player] = nil
    end
end)

print("ENHANCED PHANTOM VISION ACTIVATED | RIGHT SHIFT TOGGLE")
