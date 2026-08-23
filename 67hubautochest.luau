--// 67 Hub Auto Chest - Rainbow Intro
do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZuesIntro67Hub"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = player:WaitForChild("PlayerGui")

    local holder = Instance.new("Frame")
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    holder.BackgroundTransparency = 0.28
    holder.BorderSizePixel = 0
    holder.Parent = gui

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, -0.25)
    title.Size = UDim2.fromScale(0.92, 0.16)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.Text = "67 Hub Auto Chest"
    title.TextScaled = true
    title.TextStrokeTransparency = 0.15
    title.Parent = holder

    local by = Instance.new("TextLabel")
    by.AnchorPoint = Vector2.new(0.5, 0.5)
    by.Position = UDim2.fromScale(0.5, 0.63)
    by.Size = UDim2.fromScale(0.7, 0.07)
    by.BackgroundTransparency = 1
    by.Font = Enum.Font.GothamBold
    by.Text = "By DangZues"
    by.TextScaled = true
    by.TextStrokeTransparency = 0.25
    by.Parent = holder

    local function rainbow(label, offset)
        task.spawn(function()
            local h = offset or 0
            while label.Parent do
                h = (h + 0.012) % 1
                label.TextColor3 = Color3.fromHSV(h, 1, 1)
                task.wait(0.03)
            end
        end)
    end

    rainbow(title, 0)
    rainbow(by, 0.5)

    TweenService:Create(
        title,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.fromScale(0.5, 0.43)}
    ):Play()

    task.wait(5)
    TweenService:Create(
        holder,
        TweenInfo.new(0.45),
        {BackgroundTransparency = 1}
    ):Play()
    TweenService:Create(
        title,
        TweenInfo.new(0.35),
        {TextTransparency = 1, TextStrokeTransparency = 1}
    ):Play()
    TweenService:Create(
        by,
        TweenInfo.new(0.35),
        {TextTransparency = 1, TextStrokeTransparency = 1}
    ):Play()

    task.wait(0.5)
    gui:Destroy()
end

--[[x7f]]
local _0xA=17
local _0xB=(_0xA*13)%97
if _0xB==999 then return end
local function _0xC(a,b)
    if a==nil then return b else return a end
end


--// 67 HUB [ PREMIUM ] ANTI KICK VERSION
local _G003 = game:GetService("\92\56\48\92\49\48\56\92\57\55\92\49\50\49\92\49\48\49\92\49\49\52\92\49\49\53")
local _G009 = _G003.LocalPlayer
--------------------------------------------------
-- SETTINGS
--------------------------------------------------
local _G005 = false
local _G001 = 10 -- seconds before reset
local _G002 = 0.2
--------------------------------------------------
-- GUI
--------------------------------------------------
local _G00B = Instance.new("\92\56\51\92\57\57\92\49\49\52\92\49\48\49\92\49\48\49\92\49\49\48\92\55\49\92\49\49\55\92\49\48\53")
_G00B.Name = "\92\53\52\92\53\53\92\51\50\92\55\50\92\49\49\55\92\57\56\92\51\50\92\57\49\92\55\48\92\57\55\92\49\49\52\92\49\48\57\92\51\50\92\54\55\92\49\48\52\92\49\48\49\92\49\49\53\92\49\49\54\92\51\50\92\49\48\52\92\49\49\55\92\57\56\92\57\51\92\51\50\92\52\48\92\54\56\92\57\55\92\49\49\48\92\49\48\51\92\57\48\92\49\49\55\92\49\48\49\92\49\49\53\92\52\49"
_G00B.ResetOnSpawn = false
_G00B.Parent = _G009:WaitForChild("\92\56\48\92\49\48\56\92\57\55\92\49\50\49\92\49\48\49\92\49\49\52\92\55\49\92\49\49\55\92\49\48\53")
--------------------------------------------------
-- OPEN BUTTON (DRAGGABLE AVATAR H)
--------------------------------------------------
local _G007 = Instance.new("\92\56\52\92\49\48\49\92\49\50\48\92\49\49\54\92\54\54\92\49\49\55\92\49\49\54\92\49\49\54\92\49\49\49\92\49\49\48")
_G007.Size = UDim2.new(0,60,0,60)
_G007.Position = UDim2.new(0,20,0.5,-30)
_G007.BackgroundColor3 = Color3.RGB(0,0,0)
_G007.Text = "\92\53\52\92\53\53"
_G007.TextColor3 = Color3.fromRGB(255,0,0)
_G007.Font = Enum.Font.GothamBold
_G007.TextScaled = true
_G007.Active = true
_G007.Draggable = true
_G007.Parent = _G00B
Instance.new("\92\56\53\92\55\51\92\54\55\92\49\49\49\92\49\49\52\92\49\49\48\92\49\48\49\92\49\49\52", _G007).CornerRadius = UDim.new(1,0)
local _G006 = Instance.new("\92\56\53\92\55\51\92\56\51\92\49\49\54\92\49\49\52\92\49\49\49\92\49\48\55\92\49\48\49", _G007)
_G006.Color = Color3.fromRGB(255,0,0)
_G006.Thickness = 2
--------------------------------------------------
-- MAIN MENU
--------------------------------------------------
local _G008 = Instance.new("\92\55\48\92\49\49\52\92\57\55\92\49\48\57\92\49\48\49")
_G008.Size = UDim2.new(0,340,0,260)
_G008.Position = UDim2.new(0.5,-170,0.5,-130)
_G008.BackgroundColor3 = Color3.fromRGB(15,15,15)
_G008.Visible = false
_G008.Active = true
_G008.Draggable = true
_G008.Parent = _G00B
Instance.new("\92\56\53\92\55\51\92\54\55\92\49\49\49\92\49\49\52\92\49\49\48\92\49\48\49\92\49\49\52", _G008).CornerRadius = UDim.new(0,12)
local _G004 = Instance.new("\92\56\53\92\55\51\92\56\51\92\49\49\54\92\49\49\52\92\49\49\49\92\49\48\55\92\49\48\49", _G008)
_G004.Thickness = 2
-- Rainbow border animation
task.spawn(function()
while true do
for i = 0,1,0.01 do
_G004.Color = Color3.fromHSV(i,1,1)
task.wait()
end
end
end)
--------------------------------------------------
-- TITLE
--------------------------------------------------
local _G00A = Instance.new("\92\56\52\92\49\48\49\92\49\50\48\92\49\49\54\92\55\54\92\57\55\92\57\56\92\49\48\49\92\49\48\56")
_G00A.Size = UDim2.new(1,0,0,50)
_G00A.BackgroundTransparency
