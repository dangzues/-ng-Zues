local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "EggStealerUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 70, 0, 80)
mainFrame.Position = UDim2.new(0.5, -35, 0.5, -40)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
mainFrame.ClipsDescendants = false

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

game:GetService("RunService").RenderStepped:Connect(function()
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

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = mainFrame
toggleButton.Size = UDim2.new(0.8, 0, 0.25, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.BorderSizePixel = 1
toggleButton.BorderColor3 = Color3.new(0.4, 0.4, 0.4)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.new(1, 0, 0)
toggleButton.TextSize = 12
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "IDLE"
statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
statusLabel.TextSize = 10
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

local autoButton = Instance.new("TextButton")
autoButton.Parent = mainFrame
autoButton.Size = UDim2.new(0.8, 0, 0.25, 0)
autoButton.Position = UDim2.new(0.1, 0, 0.7, 0)
autoButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
autoButton.BorderSizePixel = 1
autoButton.BorderColor3 = Color3.new(0.4, 0.4, 0.4)
autoButton.Text = "AUTO: OFF"
autoButton.TextColor3 = Color3.new(0.8, 0.8, 0.8)
autoButton.TextSize = 10
autoButton.TextScaled = true
autoButton.Font = Enum.Font.Gotham

local isEnabled = false
local isAutoSteal = false
local HOME_POS = Vector3.new(0, 120, 0)
local flySpeed = 200

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

local isStealing = false

local function stealEgg()
    if isStealing or not isEnabled then return end
    isStealing = true
    statusLabel.Text = "STEALING..."
    statusLabel.TextColor3 = Color3.new(1, 0.8, 0)

    local prompt, part = getEggPrompt()
    if not prompt or not part then
        isStealing = false
        statusLabel.Text = "IDLE"
        statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        return
    end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isStealing = false
        statusLabel.Text = "IDLE"
        statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
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
    statusLabel.Text = "IDLE"
    statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
end

local function stealBestEgg()
    if isStealing or not isEnabled then return end
    isStealing = true
    statusLabel.Text = "STEAL BEST..."
    statusLabel.TextColor3 = Color3.new(1, 0.5, 0)

    local best = getBestEggPrompt()
    if not best then
        isStealing = false
        statusLabel.Text = "IDLE"
        statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        return
    end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isStealing = false
        statusLabel.Text = "IDLE"
        statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
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
    
    -- Bay cao lên 70 stud
    flyToWithHeight(best.part.Position, 70)
    task.wait(0.3)
    
    hrp.CFrame = CFrame.new(hrp.Position.X, 120, hrp.Position.Z)
    task.wait(0.3)
    flyTo(HOME_POS)
    task.wait(0.3)
    hrp.CFrame = CFrame.new(HOME_POS)

    isStealing = false
    statusLabel.Text = "IDLE"
    statusLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
end

local autoStealTask = nil

local function startAutoSteal()
    if autoStealTask then return end
    isAutoSteal = true
    autoButton.Text = "AUTO: ON"
    autoButton.TextColor3 = Color3.new(0, 1, 0)
    
    autoStealTask = task.spawn(function()
        while isAutoSteal and isEnabled do
            stealBestEgg()
            task.wait(5)
        end
        autoStealTask = nil
    end)
end

local function stopAutoSteal()
    isAutoSteal = false
    autoButton.Text = "AUTO: OFF"
    autoButton.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    if autoStealTask then
        task.cancel(autoStealTask)
        autoStealTask = nil
    end
end

toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleButton.Text = "ON"
        toggleButton.TextColor3 = Color3.new(0, 1, 0)
        toggleButton.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
        statusLabel.Text = "READY"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        if isAutoSteal then startAutoSteal() end
    else
        toggleButton.Text = "OFF"
        toggleButton.TextColor3 = Color3.new(1, 0, 0)
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        statusLabel.Text = "DISABLED"
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
        stopAutoSteal()
    end
end)

autoButton.MouseButton1Click:Connect(function()
    if not isEnabled then return end
    if isAutoSteal then stopAutoSteal() else startAutoSteal() end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F and input.ModifierKeys == Enum.ModifierKeys.Control then
        toggleButton.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.S and isEnabled then stealEgg() end
    if input.KeyCode == Enum.KeyCode.B and isEnabled then stealBestEgg() end
end)
