--// ĐOẠN 1: BOOST FPS & FIX LAG + STEAL FUNCTIONS
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- STEAL FUNCTIONS
local HOME_POS = Vector3.new(0, 120, 0)
local flySpeed = 200
local isStealing = false

local function getEggPrompt()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == "StealEgg" then
            return v, v.Parent
        end
    end
    return nil, nil
end

local function getBestEggPrompt()
    local best = nil
    local bestValue = -math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == "StealEgg" then
            local value = v.Parent and v.Parent:FindFirstChild("Value") and v.Parent.Value.Value or 0
            if value > bestValue then
                bestValue = value
                best = {prompt = v, part = v.Parent}
            end
        end
    end
    return best
end

local function activatePrompt(prompt)
    if prompt then fireproximityprompt(prompt) end
end

local function flyTo(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = Vector3.new(targetPos.X, 120, targetPos.Z)
    local bp = Instance.new("BodyPosition")
    bp.Parent = hrp
    bp.MaxForce = Vector3.new(1, 1, 1) * 100000
    bp.Position = target

    local bv = Instance.new("BodyVelocity")
    bv.Parent = hrp
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(flySpeed, 0, 0)

    task.wait(0.5)
    bp:Destroy()
    bv:Destroy()

    if hrp.Position.Y < 0 or hrp.Position.Y > 1000 then
        hrp.CFrame = CFrame.new(HOME_POS)
    end
end

local function flyToWithHeight(targetPos, height)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = Vector3.new(targetPos.X, height, targetPos.Z)
    local bp = Instance.new("BodyPosition")
    bp.Parent = hrp
    bp.MaxForce = Vector3.new(1, 1, 1) * 100000
    bp.Position = target

    local bv = Instance.new("BodyVelocity")
    bv.Parent = hrp
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(flySpeed, 0, 0)

    task.wait(0.5)
    bp:Destroy()
    bv:Destroy()
end

local function stealEgg()
    if isStealing then return end
    isStealing = true

    local prompt, part = getEggPrompt()
    if not prompt or not part then
        isStealing = false
        return
    end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isStealing = false
        return
    end

    hrp.CFrame = CFrame.new(HOME_POS)
    task.wait(0.3)
    hrp.CFrame = hrp.CFrame * CFrame.new(50, 0, 0)
    task.wait(0.3)
    flyTo(part.Position)
    task.wait(0.3)
    activatePrompt(prompt)
    task.wait(0.5)
    hrp.CFrame = CFrame.new(hrp.Position.X, 120, hrp.Position.Z)
    task.wait(0.3)
    flyTo(HOME_POS)
    task.wait(0.3)
    hrp.CFrame = CFrame.new(HOME_POS)

    isStealing = false
end

local function stealBestEgg()
    if isStealing then return end
    isStealing = true

    local best = getBestEggPrompt()
    if not best then
        isStealing = false
        return
    end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isStealing = false
        return
    end

    hrp.CFrame = CFrame.new(HOME_POS)
    task.wait(0.3)
    hrp.CFrame = hrp.CFrame * CFrame.new(50, 0, 0)
    task.wait(0.3)
    flyTo(best.part.Position)
    task.wait(0.3)
    activatePrompt(best.prompt)
    task.wait(0.5)
    flyToWithHeight(best.part.Position, 70)
    task.wait(0.3)
    hrp.CFrame = CFrame.new(hrp.Position.X, 120, hrp.Position.Z)
    task.wait(0.3)
    flyTo(HOME_POS)
    task.wait(0.3)
    hrp.CFrame = CFrame.new(HOME_POS)

    isStealing = false
end

-- BOOST FPS
local function boostFPS()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 999999
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        end
        if v:IsA("Decal") then
            v.Transparency = 1
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            v.Material = Enum.Material.Plastic
        end
    end
end

local fpsBoostEnabled = false
local function toggleFPSBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    if fpsBoostEnabled then
        boostFPS()
    end
end)
--// ĐOẠN 2: TẠO UI CHÍNH + DRAG
local gui = Instance.new("ScreenGui")
gui.Name = "TTriDangZuesGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 360)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = false
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local uistroke = Instance.new("UIStroke")
uistroke.Color = Color3.fromRGB(60, 60, 60)
uistroke.Thickness = 0.5
uistroke.Parent = mainFrame

local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
--// ĐOẠN 4: CONTENT FRAME + TOGGLES
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -110)
contentFrame.Position = UDim2.new(0, 10, 0, 100)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 2
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new()
scrollFrame.Parent = contentFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local function createToggle(text, desc, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 11
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -70, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 27)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
    descLabel.TextSize = 9
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 20)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
    indicator.BackgroundTransparency = 0.8
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 20)
    indicatorCorner.Parent = indicator
    
    local active = false
    
    toggle.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 50, 120)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 150, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 160)}):Play()
        end
        if callback then callback(active) end
    end)
    
    return toggle
end

createToggle("Auto Steal Random Egg", "Random egg selection", function(on)
    if on then print("Auto Steal Random Egg: ON") else print("Auto Steal Random Egg: OFF") end
end)

createToggle("Auto Steal Best Egg", "Target best egg", function(on)
    if on then print("Auto Steal Best Egg: ON") else print("Auto Steal Best Egg: OFF") end
end)

createToggle("Auto Training", "Automatic training", function(on)
    if on then print("Auto Training: ON") else print("Auto Training: OFF") end
end)

createToggle("Auto Upgrade Training", "Upgrade training", function(on)
    if on then print("Auto Upgrade Training: ON") else print("Auto Upgrade Training: OFF") end
end)

createToggle("Auto Upgrade Garden", "Upgrade garden", function(on)
    if on then print("Auto Upgrade Garden: ON") else print("Auto Upgrade Garden: OFF") end
end)

createToggle("Auto Sell Full Egg", "Sell when storage is full", function(on)
    if on then print("Auto Sell Full Egg: ON") else print("Auto Sell Full Egg: OFF") end
end)

createToggle("Kill Aura", "Kill aura interface", function(on)
    if on then print("Kill Aura: ON") else print("Kill Aura: OFF") end
end)

createToggle("Auto Equip Bat", "Automatically equip bat", function(on)
    if on then print("Auto Equip Bat: ON") else print("Auto Equip Bat: OFF") end
end)

print("✅ UI Fluent 350x360 loaded!")
print("✅ TKL Button: Bật fix lag + boost FPS 100%")
print("✅ Ctrl + T: Ẩn/Hiện UI")
print("✅ S: Steal Random | B: Steal Best")
