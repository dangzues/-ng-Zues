local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
	local Old = PlayerGui:FindFirstChild("VXZ_MoonIntro")
	if Old then
		Old:Destroy()
	end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "VXZ_MoonIntro"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = Color3.fromRGB(2, 2, 5)
Background.BorderSizePixel = 0
Background.Parent = Gui

local BackgroundGradient = Instance.new("UIGradient")
BackgroundGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 18)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
BackgroundGradient.Parent = Background

local MoonGlow = Instance.new("Frame")
MoonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
MoonGlow.Position = UDim2.fromScale(0.5, 0.5)
MoonGlow.Size = UDim2.fromOffset(480, 480)
MoonGlow.BackgroundColor3 = Color3.fromRGB(210, 220, 255)
MoonGlow.BackgroundTransparency = 0.95
MoonGlow.BorderSizePixel = 0
MoonGlow.Parent = Background

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(1, 0)
GlowCorner.Parent = MoonGlow

local Moon = Instance.new("Frame")
Moon.AnchorPoint = Vector2.new(0.5, 0.5)
Moon.Position = UDim2.fromScale(0.5, 0.5)
Moon.Size = UDim2.fromOffset(300, 300)
Moon.BackgroundColor3 = Color3.fromRGB(225, 230, 240)
Moon.BorderSizePixel = 0
Moon.ZIndex = 2
Moon.Parent = Background

local MoonCorner = Instance.new("UICorner")
MoonCorner.CornerRadius = UDim.new(1, 0)
MoonCorner.Parent = Moon

local MoonGradient = Instance.new("UIGradient")
MoonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 135, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 242, 255))
})
MoonGradient.Rotation = 35
MoonGradient.Parent = Moon

for _, Data in ipairs({
	{0.25, 0.25, 48},
	{0.68, 0.25, 35},
	{0.42, 0.50, 55},
	{0.74, 0.65, 38},
	{0.23, 0.72, 28}
}) do
	local Crater = Instance.new("Frame")
	Crater.AnchorPoint = Vector2.new(0.5, 0.5)
	Crater.Position = UDim2.fromScale(Data[1], Data[2])
	Crater.Size = UDim2.fromOffset(Data[3], Data[3])
	Crater.BackgroundColor3 = Color3.fromRGB(80, 85, 100)
	Crater.BackgroundTransparency = 0.5
	Crater.BorderSizePixel = 0
	Crater.ZIndex = 3
	Crater.Parent = Moon

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(1, 0)
	Corner.Parent = Crater
end

local NanoFolder = Instance.new("Folder")
NanoFolder.Parent = Background

local NanoObjects = {}

for i = 1, 30 do
	local Nano = Instance.new("Frame")
	Nano.AnchorPoint = Vector2.new(0.5, 0.5)
	Nano.Size = UDim2.fromOffset(math.random(3, 7), math.random(3, 7))
	Nano.Position = UDim2.fromScale(math.random(), math.random())
	Nano.BackgroundColor3 = Color3.fromRGB(180, 200, 255)
	Nano.BackgroundTransparency = 0.45
	Nano.BorderSizePixel = 0
	Nano.ZIndex = 4
	Nano.Parent = NanoFolder

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(1, 0)
	Corner.Parent = Nano

	table.insert(NanoObjects, {
		Object = Nano,
		Offset = math.random() * math.pi * 2,
		Direction = math.random() > 0.5 and 1 or -1
	})
end

local TitleHolder = Instance.new("Frame")
TitleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
TitleHolder.Position = UDim2.new(0.5, 0, -0.2, 0)
TitleHolder.Size = UDim2.fromOffset(420, 80)
TitleHolder.BackgroundTransparency = 1
TitleHolder.ZIndex = 10
TitleHolder.Parent = Background

local TitleShadow = Instance.new("TextLabel")
TitleShadow.Size = UDim2.fromScale(1, 1)
TitleShadow.Position = UDim2.fromOffset(4, 5)
TitleShadow.BackgroundTransparency = 1
TitleShadow.Text = "Vxz Hub"
TitleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleShadow.TextSize = 42
TitleShadow.Font = Enum.Font.GothamBlack
TitleShadow.ZIndex = 10
TitleShadow.Parent = TitleHolder

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromScale(1, 1)
Title.BackgroundTransparency = 1
Title.Text = "Vxz Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 42
Title.Font = Enum.Font.GothamBlack
Title.ZIndex = 11
Title.Parent = TitleHolder

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(20, 20, 30)
TitleStroke.Thickness = 1.5
TitleStroke.Parent = Title

local LeftShadow = Instance.new("Frame")
LeftShadow.AnchorPoint = Vector2.new(0.5, 0.5)
LeftShadow.Position = UDim2.new(-0.25, 8, 0.5, 8)
LeftShadow.Size = UDim2.fromOffset(240, 155)
LeftShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LeftShadow.BackgroundTransparency = 0.45
LeftShadow.BorderSizePixel = 0
LeftShadow.Parent = Background

local LeftShadowCorner = Instance.new("UICorner")
LeftShadowCorner.CornerRadius = UDim.new(0, 14)
LeftShadowCorner.Parent = LeftShadow

local LeftPanel = Instance.new("Frame")
LeftPanel.AnchorPoint = Vector2.new(0.5, 0.5)
LeftPanel.Position = UDim2.new(-0.25, 0, 0.5, 0)
LeftPanel.Size = UDim2.fromOffset(240, 155)
LeftPanel.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
LeftPanel.BorderSizePixel = 0
LeftPanel.ZIndex = 6
LeftPanel.Parent = Background

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 14)
LeftCorner.Parent = LeftPanel

local LeftStroke = Instance.new("UIStroke")
LeftStroke.Color = Color3.fromRGB(230, 235, 255)
LeftStroke.Transparency = 0.4
LeftStroke.Thickness = 1
LeftStroke.Parent = LeftPanel

local TeamTitle = Instance.new("TextLabel")
TeamTitle.Position = UDim2.fromOffset(18, 12)
TeamTitle.Size = UDim2.new(1, -36, 0, 25)
TeamTitle.BackgroundTransparency = 1
TeamTitle.Text = "VXZ TEAM"
TeamTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamTitle.TextSize = 12
TeamTitle.Font = Enum.Font.GothamBold
TeamTitle.TextXAlignment = Enum.TextXAlignment.Left
TeamTitle.ZIndex = 7
TeamTitle.Parent = LeftPanel

local TeamLine = Instance.new("Frame")
TeamLine.Position = UDim2.fromOffset(18, 42)
TeamLine.Size = UDim2.new(1, -36, 0, 1)
TeamLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TeamLine.BackgroundTransparency = 0.7
TeamLine.BorderSizePixel = 0
TeamLine.ZIndex = 7
TeamLine.Parent = LeftPanel

local Member1 = Instance.new("TextLabel")
Member1.Position = UDim2.fromOffset(18, 58)
Member1.Size = UDim2.new(1, -36, 0, 32)
Member1.BackgroundTransparency = 1
Member1.Text = "ĐANGEPZAI36"
Member1.TextColor3 = Color3.fromRGB(255, 255, 255)
Member1.TextSize = 16
Member1.Font = Enum.Font.GothamSemibold
Member1.TextXAlignment = Enum.TextXAlignment.Left
Member1.ZIndex = 7
Member1.Parent = LeftPanel

local Member2 = Instance.new("TextLabel")
Member2.Position = UDim2.fromOffset(18, 98)
Member2.Size = UDim2.new(1, -36, 0, 30)
Member2.BackgroundTransparency = 1
Member2.Text = "HTRI1854"
Member2.TextColor3 = Color3.fromRGB(190, 195, 215)
Member2.TextSize = 15
Member2.Font = Enum.Font.GothamMedium
Member2.TextXAlignment = Enum.TextXAlignment.Left
Member2.ZIndex = 7
Member2.Parent = LeftPanel

local RightShadow = Instance.new("Frame")
RightShadow.AnchorPoint = Vector2.new(0.5, 0.5)
RightShadow.Position = UDim2.new(1.25, 8, 0.5, 8)
RightShadow.Size = UDim2.fromOffset(180, 180)
RightShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RightShadow.BackgroundTransparency = 0.45
RightShadow.BorderSizePixel = 0
RightShadow.Parent = Background

local RightShadowCorner = Instance.new("UICorner")
RightShadowCorner.CornerRadius = UDim.new(0, 14)
RightShadowCorner.Parent = RightShadow

local RightPanel = Instance.new("Frame")
RightPanel.AnchorPoint = Vector2.new(0.5, 0.5)
RightPanel.Position = UDim2.new(1.25, 0, 0.5, 0)
RightPanel.Size = UDim2.fromOffset(180, 180)
RightPanel.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
RightPanel.BorderSizePixel = 0
RightPanel.ZIndex = 6
RightPanel.Parent = Background

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 14)
RightCorner.Parent = RightPanel

local RightStroke = Instance.new("UIStroke")
RightStroke.Color = Color3.fromRGB(255, 255, 255)
RightStroke.Transparency = 0.35
RightStroke.Thickness = 1
RightStroke.Parent = RightPanel

local OwnerTitle = Instance.new("TextLabel")
OwnerTitle.Position = UDim2.fromOffset(12, 14)
OwnerTitle.Size = UDim2.new(1, -24, 0, 28)
OwnerTitle.BackgroundTransparency = 1
OwnerTitle.Text = "OWNER"
OwnerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
OwnerTitle.TextSize = 13
OwnerTitle.Font = Enum.Font.GothamBold
OwnerTitle.ZIndex = 7
OwnerTitle.Parent = RightPanel

local OwnerLine = Instance.new("Frame")
OwnerLine.Position = UDim2.fromOffset(15, 48)
OwnerLine.Size = UDim2.new(1, -30, 0, 1)
OwnerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OwnerLine.BackgroundTransparency = 0.7
OwnerLine.BorderSizePixel = 0
OwnerLine.ZIndex = 7
OwnerLine.Parent = RightPanel

local OwnerName = Instance.new("TextLabel")
OwnerName.AnchorPoint = Vector2.new(0.5, 0.5)
OwnerName.Position = UDim2.fromScale(0.5, 0.58)
OwnerName.Size = UDim2.new(1, -18, 0, 45)
OwnerName.BackgroundTransparency = 1
OwnerName.Text = "NG.NAMM_"
OwnerName.TextColor3 = Color3.fromRGB(255, 255, 255)
OwnerName.TextSize = 18
OwnerName.Font = Enum.Font.GothamBlack
OwnerName.TextScaled = true
OwnerName.ZIndex = 7
OwnerName.Parent = RightPanel

local Status = Instance.new("TextLabel")
Status.AnchorPoint = Vector2.new(0.5, 0.5)
Status.Position = UDim2.new(0.5, 0, 0.78, 0)
Status.Size = UDim2.fromOffset(400, 40)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(230, 235, 255)
Status.TextSize = 14
Status.Font = Enum.Font.GothamMedium
Status.ZIndex = 12
Status.Parent = Background

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(0, 0, 0)
StatusStroke.Thickness = 1.5
StatusStroke.Transparency = 0.3
StatusStroke.Parent = Status

TweenService:Create(
	MoonGlow,
	TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{
		Size = UDim2.fromOffset(550, 550),
		BackgroundTransparency = 0.985
	}
):Play()

TweenService:Create(
	LeftPanel,
	TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{
		Position = UDim2.new(0.18, 0, 0.5, 0)
	}
):Play()

TweenService:Create(
	LeftShadow,
	TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{
		Position = UDim2.new(0.18, 8, 0.5, 8)
	}
):Play()

TweenService:Create(
	RightPanel,
	TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{
		Position = UDim2.new(0.82, 0, 0.5, 0)
	}
):Play()

TweenService:Create(
	RightShadow,
	TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{
		Position = UDim2.new(0.82, 8, 0.5, 8)
	}
):Play()

TweenService:Create(
	TitleHolder,
	TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}
):Play()

TweenService:Create(
	Title,
	TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{
		TextTransparency = 0.2
	}
):Play()

local StartTime = tick()

local Connection = RunService.RenderStepped:Connect(function()
	local Time = tick() - StartTime

	for _, Data in ipairs(NanoObjects) do
		local Object = Data.Object

		if Object and Object.Parent then
			local X = Object.Position.X.Scale + math.sin(Time + Data.Offset) * 0.0005 * Data.Direction
			local Y = Object.Position.Y.Scale + math.cos(Time * 0.8 + Data.Offset) * 0.00025

			if X > 1.05 then
				X = -0.05
			elseif X < -0.05 then
				X = 1.05
			end

			if Y > 1.05 then
				Y = -0.05
			elseif Y < -0.05 then
				Y = 1.05
			end

			Object.Position = UDim2.fromScale(X, Y)
		end
	end
end)

task.wait(1)
Status.Text = "Set Data Game"

task.wait(1)
Status.Text = "Set Data Script"

task.wait(1)
Status.Text = "Wait is Script"

task.wait(1)

for _, Object in ipairs(Gui:GetDescendants()) do
	if Object:IsA("TextLabel") then
		TweenService:Create(
			Object,
			TweenInfo.new(0.7),
			{TextTransparency = 1}
		):Play()
	elseif Object:IsA("Frame") then
		TweenService:Create(
			Object,
			TweenInfo.new(0.7),
			{BackgroundTransparency = 1}
		):Play()
	elseif Object:IsA("UIStroke") then
		TweenService:Create(
			Object,
			TweenInfo.new(0.7),
			{Transparency = 1}
		):Play()
	end
end

task.wait(0.8)

Connection:Disconnect()
Gui:Destroy()

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Config = {
    Godmode = false,

    BoostLevel = 1,
    MinBoost = 1,
    MaxBoost = 25,

    BaseWalkSpeed = 16,
    PromptDistance = 30,
    PromptHoldDuration = 0,

    DeleteTrap = false,
    EspTrap = false,
    DeleteTreadmill = false,
    
    AntiRagdoll = false,
    InstantEgg = false,

    AutoBat = false,
    EspPlayer = false,
    AutoAttackBloom = false,
    
    AutoFixLagOnEnable = true
}

local Connections = {
    Heartbeat = nil,
    RenderStepped = nil,
    CharacterAdded = nil,
    WorkspaceAdded = nil,
    WorkspaceRemoving = nil,
    HealthChanged = nil,

    TrapAdded = nil,
    TrapCleanup = nil,
    TrapESP = nil,
    TreadmillAdded = nil,
    TreadmillCleanup = nil,
    
    AntiRagdoll = nil,
    InstantEgg = nil,

    AutoBat = nil,
    EspPlayer = nil,
    AutoAttackBloom = nil
}

local TrapCache = {}
local TreadmillCache = {}
local EggPromptCache = {}
local TrapESPObjects = {}
local PlayerESPObjects = {}

local TargetPrompt = nil
local PromptLoopRunning = false
local LastRagdollReset = 0
local AntiRagdollResetCooldown = 0

local ATTACK_RANGE = 20

local BAT_NAMES = {
    "bat",
    "gậy"
}

-- Hàm tự động Fix Lag giúp mượt máy khi bật tính năng
local function ApplyFixLagAuto()
    if not Config.AutoFixLagOnEnable then return end
    pcall(function()
        local settingsObj = settings()
        settingsObj.Rendering.QualityLevel = Enum.QualityLevel.Level01
        settingsObj.Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01

        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Technology = Enum.Technology.Compatibility

        if setfpscap then
            setfpscap(9999999)
        end
    end)
end

-- Hàm rút gọn chữ số cho đơn vị Speed (K, M, B, T)
local function FormatSpeedNumber(val)
    local num = tonumber(val)
    if not num then return tostring(val or "N/A") end
    
    if num >= 1e12 then
        return string.format("%.2fT", num / 1e12)
    elseif num >= 1e9 then
        return string.format("%.2fB", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.2fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.2fK", num / 1e3)
    else
        return tostring(math.floor(num))
    end
end

local function DisconnectConnection(name)
    local connection = Connections[name]

    if connection then
        pcall(function()
            connection:Disconnect()
        end)

        Connections[name] = nil
    end
end

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid(character)
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function GetRoot(character)
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function GetAdaptiveSpeed()
    local character = GetCharacter()
    local humanoid = GetHumanoid(character)

    if not humanoid then
        return Config.BaseWalkSpeed
    end

    local currentSpeed = humanoid.WalkSpeed

    if currentSpeed <= 0 then
        currentSpeed = Config.BaseWalkSpeed
    end

    currentSpeed = math.clamp(currentSpeed, 1, 500)

    local boost = math.clamp(
        tonumber(Config.BoostLevel) or Config.MinBoost,
        Config.MinBoost,
        Config.MaxBoost
    )

    local speedRatio = math.clamp(
        currentSpeed / Config.BaseWalkSpeed,
        0.25,
        8
    )

    local adaptiveMultiplier =
        1 + ((boost * 0.25) * speedRatio)

    return math.clamp(
        Config.BaseWalkSpeed * adaptiveMultiplier,
        1,
        1000
    )
end

local TrapKeywords = {
    "trap",
    "beartrap",
    "bear trap",
    "snare",
    "bay",
    "spike trap",
    "spiketrap",
    "landmine",
    "mine",
    "webtrap",
    "web trap"
}

local TreadmillKeywords = {
    "treadmill",
    "máy chạy",
    "may chay",
    "running machine"
}

local function NormalizeName(value)
    value = tostring(value or "")
    value = string.lower(value)

    return value
end

local function ContainsKeyword(text, keywordsList)
    text = NormalizeName(text)

    for _, keyword in ipairs(keywordsList) do
        if string.find(text, keyword, 1, true) then
            return true
        end
    end

    return false
end

local function IsTrapObject(object)
    if not object or object == Workspace then
        return false
    end

    if ContainsKeyword(object.Name, TrapKeywords) then
        return true
    end

    local attributes = {
        "Trap",
        "Type",
        "ObjectType",
        "ItemType",
        "Name",
        "DisplayName"
    }

    for _, attributeName in ipairs(attributes) do
        local success, value = pcall(function()
            return object:GetAttribute(attributeName)
        end)

        if success and value ~= nil then
            if ContainsKeyword(value, TrapKeywords) then
                return true
            end
        end
    end

    return false
end

local function IsTreadmillObject(object)
    if not object or object == Workspace then
        return false
    end

    if ContainsKeyword(object.Name, TreadmillKeywords) then
        return true
    end

    local attributes = {
        "Treadmill",
        "Type",
        "ObjectType",
        "ItemType",
        "Name",
        "DisplayName"
    }

    for _, attributeName in ipairs(attributes) do
        local success, value = pcall(function()
            return object:GetAttribute(attributeName)
        end)

        if success and value ~= nil then
            if ContainsKeyword(value, TreadmillKeywords) then
                return true
            end
        end
    end

    return false
end

local function GetESPAdornee(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object
    end

    if object:IsA("Model") then
        local primary = object.PrimaryPart

        if primary and primary:IsA("BasePart") then
            return primary
        end

        local root = object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

        return root
    end

    return nil
end

local function RemoveTrapESP(object)
    local data = TrapESPObjects[object]

    if not data then
        return
    end

    if data.Highlight then
        pcall(function()
            data.Highlight:Destroy()
        end)
    end

    if data.Billboard then
        pcall(function()
            data.Billboard:Destroy()
        end)
    end

    TrapESPObjects[object] = nil
end

local function CreateTrapESP(object)
    if not Config.EspTrap or not object or not object.Parent or TrapESPObjects[object] then
        return
    end

    local adornee = GetESPAdornee(object)

    if not adornee then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "VxzTrapHighlight"
    highlight.Adornee = object:IsA("Model") and object or adornee

    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)

    highlight.FillTransparency = 0.55
    highlight.OutlineTransparency = 0

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true

    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VxzTrapLabel"
    billboard.Adornee = adornee

    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1000

    billboard.Size = UDim2.fromOffset(120, 38)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)

    billboard.Parent = object

    local label = Instance.new("TextLabel")
    label.Name = "TrapText"

    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)

    label.Font = Enum.Font.GothamBold
    label.Text = "Trap !"
    label.TextSize = 18

    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0

    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.Parent = billboard

    TrapESPObjects[object] = {
        Highlight = highlight,
        Billboard = billboard
    }
end

local function ScanAllTraps()
    for _, object in ipairs(Workspace:GetDescendants()) do
        if IsTrapObject(object) then
            TrapCache[object] = true

            if Config.EspTrap then
                CreateTrapESP(object)
            end

            if Config.DeleteTrap then
                pcall(function()
                    object:Destroy()
                end)
            end
        end
    end
end

local function ScanAllTreadmills()
    for _, object in ipairs(Workspace:GetDescendants()) do
        if IsTreadmillObject(object) then
            TreadmillCache[object] = true

            if Config.DeleteTreadmill then
                pcall(function()
                    object:Destroy()
                end)
            end
        end
    end
end

local function CleanupTrapESP()
    for object in pairs(TrapESPObjects) do
        if not object or not object.Parent then
            RemoveTrapESP(object)
        elseif not IsTrapObject(object) then
            RemoveTrapESP(object)
        end
    end
end

local function StartTrapESP()
    DisconnectConnection("TrapESP")
    ScanAllTraps()

    Connections.TrapESP = RunService.Heartbeat:Connect(function()
        if not Config.EspTrap then
            return
        end
        CleanupTrapESP()
    end)
end

local function StopTrapESP()
    DisconnectConnection("TrapESP")
    for object in pairs(TrapESPObjects) do
        RemoveTrapESP(object)
    end
end

local function DeleteTrapObject(object)
    if not Config.DeleteTrap or not object or not object.Parent or not IsTrapObject(object) then
        return
    end

    TrapCache[object] = true
    pcall(function()
        object:Destroy()
    end)
end

local function DeleteTreadmillObject(object)
    if not Config.DeleteTreadmill or not object or not object.Parent or not IsTreadmillObject(object) then
        return
    end

    TreadmillCache[object] = true
    pcall(function()
        object:Destroy()
    end)
end

local function StartTrapScanner()
    DisconnectConnection("TrapAdded")
    DisconnectConnection("TrapCleanup")
    ScanAllTraps()

    Connections.TrapAdded = Workspace.DescendantAdded:Connect(function(object)
        if Config.DeleteTrap and IsTrapObject(object) then
            DeleteTrapObject(object)
        end
    end)

    Connections.TrapCleanup = RunService.Heartbeat:Connect(function()
        if not Config.DeleteTrap then
            return
        end

        for object in pairs(TrapCache) do
            if object and object.Parent then
                DeleteTrapObject(object)
            else
                TrapCache[object] = nil
            end
        end
    end)
end

local function StopTrapScanner()
    DisconnectConnection("TrapAdded")
    DisconnectConnection("TrapCleanup")
    table.clear(TrapCache)
end

local function StartTreadmillScanner()
    DisconnectConnection("TreadmillAdded")
    DisconnectConnection("TreadmillCleanup")
    ScanAllTreadmills()

    Connections.TreadmillAdded = Workspace.DescendantAdded:Connect(function(object)
        if Config.DeleteTreadmill and IsTreadmillObject(object) then
            DeleteTreadmillObject(object)
        end
    end)

    Connections.TreadmillCleanup = RunService.Heartbeat:Connect(function()
        if not Config.DeleteTreadmill then
            return
        end

        for object in pairs(TreadmillCache) do
            if object and object.Parent then
                DeleteTreadmillObject(object)
            else
                TreadmillCache[object] = nil
            end
        end
    end)
end

local function StopTreadmillScanner()
    DisconnectConnection("TreadmillAdded")
    DisconnectConnection("TreadmillCleanup")
    table.clear(TreadmillCache)
end

local function EnableDeleteTrap()
    Config.DeleteTrap = true
    ApplyFixLagAuto()
    StartTrapScanner()
end

local function DisableDeleteTrap()
    Config.DeleteTrap = false
    StopTrapScanner()
end

local function EnableDeleteTreadmill()
    Config.DeleteTreadmill = true
    ApplyFixLagAuto()
    StartTreadmillScanner()
end

local function DisableDeleteTreadmill()
    Config.DeleteTreadmill = false
    StopTreadmillScanner()
end

local function EnableTrapESP()
    Config.EspTrap = true
    ApplyFixLagAuto()
    StartTrapESP()
end

local function DisableTrapESP()
    Config.EspTrap = false
    StopTrapESP()
end

local function RemovePlayerESP(player)
    local data = PlayerESPObjects[player]
    if data then
        if data.Highlight then pcall(function() data.Highlight:Destroy() end) end
        if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
        PlayerESPObjects[player] = nil
    end
end

local function GetPlayerSpeedFromLeaderboard(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local speedStat = leaderstats:FindFirstChild("Speed") or leaderstats:FindFirstChild("speed") or leaderstats:FindFirstChild("WalkSpeed")
        if speedStat then
            return FormatSpeedNumber(speedStat.Value)
        end
    end
    
    local char = player.Character
    if char then
        local hum = GetHumanoid(char)
        if hum then
            return FormatSpeedNumber(hum.WalkSpeed)
        end
    end
    return "N/A"
end

local function CreatePlayerESP(player)
    if player == LocalPlayer or not Config.EspPlayer then return end
    
    local char = player.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    RemovePlayerESP(player)

    local highlight = Instance.new("Highlight")
    highlight.Name = "VxzPlayerHighlight"
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(0, 170, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 100, 200)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VxzPlayerLabel"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1000
    billboard.Size = UDim2.fromOffset(200, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "PlayerText"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(0, 120, 255)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = billboard

    PlayerESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        Label = label
    }
end

local function UpdatePlayerESP()
    local myChar = GetCharacter()
    local myRoot = GetRoot(myChar)

    for player, data in pairs(PlayerESPObjects) do
        if player and player.Parent and player.Character and player.Character:FindFirstChild("Head") then
            local targetChar = player.Character
            local targetRoot = GetRoot(targetChar)
            
            local distStr = "N/A"
            if myRoot and targetRoot then
                local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                distStr = tostring(dist) .. "m"
            end

            local speedStr = GetPlayerSpeedFromLeaderboard(player)

            if data.Label then
                data.Label.Text = string.format("%s\n[%s] | Speed: %s", player.DisplayName or player.Name, distStr, speedStr)
            end
        else
            RemovePlayerESP(player)
        end
    end
end

local function StartPlayerESP()
    DisconnectConnection("EspPlayer")
    ApplyFixLagAuto()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end

    task.spawn(function()
        while Config.EspPlayer do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if not PlayerESPObjects[player] and player.Character then
                        CreatePlayerESP(player)
                    end
                end
            end
            UpdatePlayerESP()
            task.wait(0.1)
        end
    end)
end

local function StopPlayerESP()
    DisconnectConnection("EspPlayer")
    for player in pairs(PlayerESPObjects) do
        RemovePlayerESP(player)
    end
end

local function IsEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local nameText = string.lower(
        tostring(prompt.Name) ..
        " " ..
        tostring(prompt.ObjectText)
    )

    local actionText = string.lower(
        tostring(prompt.ActionText)
    )

    local nameMatch =
        string.find(nameText, "trứng", 1, true) or
        string.find(nameText, "trung", 1, true) or
        string.find(nameText, "egg", 1, true)

    local actionMatch =
        string.find(actionText, "trộm", 1, true) or
        string.find(actionText, "trom", 1, true) or
        string.find(actionText, "cắp", 1, true) or
        string.find(actionText, "steal", 1, true)

    return nameMatch ~= nil or actionMatch ~= nil
end

local function ApplyInstantEggPrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") and IsEggPrompt(prompt) then
        pcall(function()
            prompt.HoldDuration = 0
        end)
    end
end

local function StartInstantEgg()
    DisconnectConnection("InstantEgg")
    ApplyFixLagAuto()

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            ApplyInstantEggPrompt(object)
        end
    end

    Connections.InstantEgg = Workspace.DescendantAdded:Connect(function(object)
        if Config.InstantEgg and object:IsA("ProximityPrompt") then
            ApplyInstantEggPrompt(object)
        end
    end)
end

local function StopInstantEgg()
    DisconnectConnection("InstantEgg")
end

local function TrackObject(object)
    if Config.DeleteTrap and IsTrapObject(object) then
        TrapCache[object] = true
        pcall(function() object:Destroy() end)
        return
    end

    if Config.DeleteTreadmill and IsTreadmillObject(object) then
        TreadmillCache[object] = true
        pcall(function() object:Destroy() end)
        return
    end

    if Config.EspTrap and IsTrapObject(object) then
        CreateTrapESP(object)
    end

    if object:IsA("ProximityPrompt") and IsEggPrompt(object) then
        EggPromptCache[object] = true
        if Config.InstantEgg then
            ApplyInstantEggPrompt(object)
        end
    end
end

local function UntrackObject(object)
    TrapCache[object] = nil
    TreadmillCache[object] = nil
    EggPromptCache[object] = nil

    RemoveTrapESP(object)

    if TargetPrompt == object then
        TargetPrompt = nil
    end
end

local function BuildInitialCache()
    table.clear(TrapCache)
    table.clear(TreadmillCache)
    table.clear(EggPromptCache)

    for _, object in ipairs(Workspace:GetDescendants()) do
        if IsTrapObject(object) then
            TrapCache[object] = true

            if Config.EspTrap then
                CreateTrapESP(object)
            end

            if Config.DeleteTrap then
                pcall(function()
                    object:Destroy()
                end)
            end

        elseif IsTreadmillObject(object) then
            TreadmillCache[object] = true

            if Config.DeleteTreadmill then
                pcall(function()
                    object:Destroy()
                end)
            end

        elseif object:IsA("ProximityPrompt") and IsEggPrompt(object) then
            EggPromptCache[object] = true
            if Config.InstantEgg then
                ApplyInstantEggPrompt(object)
            end
        end
    end
end

local function BypassAntiCheat()
    if not Config.Godmode then
        return
    end

    local character = GetCharacter()

    if not character then
        return
    end

    local humanoid = GetHumanoid(character)

    if humanoid then
        pcall(function()
            humanoid:Destroy()
        end)
    end

    local newHumanoid = Instance.new("Humanoid")

    newHumanoid.Name = "Humanoid"
    newHumanoid.Parent = character

    pcall(function()
        newHumanoid.BreakJointsOnDeath = false

        newHumanoid:SetStateEnabled(
            Enum.HumanoidStateType.Dead,
            false
        )

        newHumanoid:SetStateEnabled(
            Enum.HumanoidStateType.FallingDown,
            false
        )

        newHumanoid:SetStateEnabled(
            Enum.HumanoidStateType.Ragdoll,
            false
        )

        newHumanoid.WalkSpeed = GetAdaptiveSpeed()
    end)

    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.CameraSubject = newHumanoid
    end
end

local function SetupAntiDie()
    if not Config.Godmode then
        return
    end

    DisconnectConnection("HealthChanged")

    local character = GetCharacter()

    if not character then
        return
    end

    local humanoid = GetHumanoid(char
