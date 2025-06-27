--[[
  PHANTOM VISION ESP v4.20
  RIGHTSHIFT MENU ACTIVATION
  BY: REBEL_GENIUS
  WARNING: FOR EDUCATIONAL PURPOSES ONLY
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Create phantom container
local PhantomContainer = Instance.new("ScreenGui")
PhantomContainer.Name = "PhantomVision420"
PhantomContainer.Parent = CoreGui
PhantomContainer.ResetOnSpawn = false

-- Stealth injection protocol
local function GhostInject()
    if not CoreGui:FindFirstChild("PhantomVision420") then
        PhantomContainer.Parent = CoreGui
    end
end

-- ESP rendering engine
local ESPStore = {}
local function CreatePhantomESP(target)
    local ESPGroup = {}
    
    local Box = Instance.new("Frame")
    Box.Name = "PhantomBox"
    Box.BackgroundTransparency = 0.7
    Box.BackgroundColor3 = Color3.fromRGB(255, 20, 20)
    Box.BorderSizePixel = 2
    Box.BorderColor3 = Color3.new(0,0,0)
    Box.ZIndex = 10
    Box.Visible = false
    Box.Parent = PhantomContainer
    
    local Tracer = Instance.new("Frame")
    Tracer.Name = "PhantomTracer"
    Tracer.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    Tracer.BorderSizePixel = 0
    Tracer.Size = UDim2.new(0, 1, 0, 150)
    Tracer.Visible = false
    Tracer.ZIndex = 11
    Tracer.Parent = PhantomContainer
    
    local Label = Instance.new("TextLabel")
    Label.Name = "PhantomLabel"
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 50, 50)
    Label.TextStrokeTransparency = 0
    Label.TextSize = 14
    Label.Font = Enum.Font.Code
    Label.Visible = false
    Label.ZIndex = 12
    Label.Parent = PhantomContainer
    
    ESPGroup.Box = Box
    ESPGroup.Tracer = Tracer
    ESPGroup.Label = Label
    ESPStore[target] = ESPGroup
end

-- Player tracking system
local function TrackPhantoms()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and not ESPStore[player] then
            CreatePhantomESP(player)
        end
    end
end

-- Coordinate transformation
local function WorldToViewport(position)
    local Camera = workspace.CurrentCamera
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

-- ESP update loop
local function PhantomUpdate()
    for target, esp in pairs(ESPStore) do
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = target.Character.HumanoidRootPart
            local screenPosition, onScreen, depth = WorldToViewport(rootPart.Position)
            
            if onScreen then
                -- Box ESP
                local distance = (workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
                local boxSize = math.clamp(3000 / distance, 10, 50)
                
                esp.Box.Size = UDim2.new(0, boxSize, 0, boxSize * 2)
                esp.Box.Position = UDim2.new(0, screenPosition.X - boxSize/2, 0, screenPosition.Y - boxSize)
                esp.Box.Visible = true
                
                -- Tracer line
                esp.Tracer.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
                esp.Tracer.Visible = true
                
                -- Player label
                esp.Label.Text = target.Name.." | "..math.floor(distance).."m"
                esp.Label.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y - 30)
                esp.Label.Visible = true
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Label.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Label.Visible = false
        end
    end
end

-- Phantom menu system
local MenuVisible = false
local PhantomMenu = Instance.new("Frame")
PhantomMenu.Name = "PhantomControl"
PhantomMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PhantomMenu.Position = UDim2.new(0.5, -100, 0.5, -75)
PhantomMenu.Size = UDim2.new(0, 200, 0, 150)
PhantomMenu.Active = true
PhantomMenu.Draggable = true
PhantomMenu.Visible = false
PhantomMenu.Parent = PhantomContainer

local Title = Instance.new("TextLabel")
Title.Text = "PHANTOM CONTROL v4.20"
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(255, 50, 255)
Title.Parent = PhantomMenu

local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "TOGGLE ESP"
ToggleButton.Position = UDim2.new(0, 10, 0, 30)
ToggleButton.Size = UDim2.new(0, 180, 0, 30)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
ToggleButton.Font = Enum.Font.Code
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Parent = PhantomMenu

local ColorButton = Instance.new("TextButton")
ColorButton.Text = "RANDOM COLORS"
ColorButton.Position = UDim2.new(0, 10, 0, 70)
ColorButton.Size = UDim2.new(0, 180, 0, 30)
ColorButton.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
ColorButton.Font = Enum.Font.Code
ColorButton.TextColor3 = Color3.new(1,1,1)
ColorButton.Parent = PhantomMenu

local DestroyButton = Instance.new("TextButton")
DestroyButton.Text = "SELF DESTRUCT"
DestroyButton.Position = UDim2.new(0, 10, 0, 110)
DestroyButton.Size = UDim2.new(0, 180, 0, 30)
DestroyButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
DestroyButton.Font = Enum.Font.Code
DestroyButton.TextColor3 = Color3.new(1,1,1)
DestroyButton.Parent = PhantomMenu

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
        esp.Box.Visible = not esp.Box.Visible
        esp.Tracer.Visible = not esp.Tracer.Visible
        esp.Label.Visible = not esp.Label.Visible
    end
end)

ColorButton.MouseButton1Click:Connect(function()
    for _, esp in pairs(ESPStore) do
        local r = math.random(50,255)
        local g = math.random(50,255)
        local b = math.random(50,255)
        esp.Box.BackgroundColor3 = Color3.fromRGB(r,g,b)
        esp.Tracer.BackgroundColor3 = Color3.fromRGB(r,g,b)
    end
end)

DestroyButton.MouseButton1Click:Connect(function()
    PhantomContainer:Destroy()
    ESPStore = {}
end)

-- Main runtime
spawn(function()
    while task.wait(0.1) do
        GhostInject()
        TrackPhantoms()
    end
end)

RunService.Heartbeat:Connect(PhantomUpdate)
Players.PlayerRemoving:Connect(function(player)
    if ESPStore[player] then
        ESPStore[player].Box:Destroy()
        ESPStore[player].Tracer:Destroy()
        ESPStore[player].Label:Destroy()
        ESPStore[player] = nil
    end
end)

-- Initialization complete
print("PHANTOM VISION ESP ACTIVATED | RIGHT SHIFT TOGGLE")