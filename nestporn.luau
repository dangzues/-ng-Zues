--[[
    Greeny Growers Hub - Full Script
    Version: 1.0.0
    Tác giả: Script Expert
    ĐOẠN 1: KHỞI TẠO VÀ CONFIG
]]

--===========================================
-- KHỞI TẠO FLUENT LIBRARY
--===========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--===========================================
-- TẠO WINDOW CHÍNH
--===========================================
local Window = Fluent:CreateWindow({
    Title = "Greeny Growers Hub",
    SubTitle = "by Script Expert",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--===========================================
-- TẠO CÁC TAB
--===========================================
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "sprout" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "sliders" })
}

--===========================================
-- BIẾN TOÀN CỤC
--===========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

--===========================================
-- CẤU HÌNH CHUNG
--===========================================
local Config = {
    -- Auto Farm
    AutoFarm = false,
    FarmSpeed = 1,
    FarmRadius = 50,
    SelectedPlants = {"Wheat"},
    AutoHarvest = true,
    AutoPlant = false,
    AutoWater = false,
    AutoSell = false,
    SellThreshold = 100,
    OnlyRipe = true,
    InstantHarvest = false,
    CollectSeeds = true,
    LoopFarming = false,
    FarmMode = "Nearest",
    
    -- Lightning Prediction
    LightningPrediction = false,
    AutoCollectLightning = false,
    ShowCountdownUI = true,
    PlaySound = true,
    CollectRadius = 30,
    AutoCollectSeeds = true,
    AutoCollectItems = true,
    ShowLightningESP = true,
    LightningNotification = true,
    LightningSafeMode = false,
    
    -- Player
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    
    -- Visuals
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ShowFPS = false,
    
    -- Misc
    AntiAFK = false,
    AutoRejoin = false,
    AutoSave = false,
    LowGraphics = false,
    FPSBoost = false,
    
    -- Anime Button
    AnimeEnabled = true,
    SelectedAnime = "Anime Girl 1",
    AnimeGlow = true,
    AnimeBounce = true,
    AnimeParticle = true,
    AnimeAutoRotate = false,
    AnimeOpacity = 100,
    AnimeScale = 100
}

--===========================================
-- DANH SÁCH HÌNH ẢNH ANIME
--===========================================
local AnimeImages = {
    "rbxassetid://1234567890", -- Anime Girl 1
    "rbxassetid://1092837465", -- Anime Girl 2
    "rbxassetid://9876543210", -- Anime Girl 3
    "rbxassetid://1112223334", -- Anime Girl 4
    "rbxassetid://5556667778", -- Anime Girl 5
    "rbxassetid://9998887776", -- Bikini Girl
    "rbxassetid://4443332221", -- Cat Girl
    "rbxassetid://7778889990", -- School Girl
    "rbxassetid://2223334445", -- Maid Girl
    "rbxassetid://8887776665", -- Ninja Girl
}

--===========================================
-- BIẾN TRẠNG THÁI
--===========================================
local UIState = {
    IsHidden = false,
    SelectedAnimeImage = 1,
    AnimeGui = nil,
    AnimeFrame = nil,
    AnimeImageLabel = nil,
    IsHovering = false,
    CurrentRotation = 0,
    IsAnimating = false
}

local LightningState = {
    IsCounting = false,
    CurrentCount = 0,
    IsLightningActive = false,
    LightningPosition = nil,
    CountdownGui = nil,
    CountdownLabel = nil,
    WarningGui = nil,
    ThunderDetected = false,
    HasLightningStruck = false,
    ItemsSpawned = false,
    CollectedItems = 0,
    TotalLightningStrikes = 0
}
--[[
    ĐOẠN 2: MAIN TAB - AUTO FARM
]]

--===========================================
-- MAIN TAB
--===========================================
local MainFarmSection = Tabs.Main:AddSection("Main Farm")

-- Auto Farm Toggle
local AutoFarmToggle = MainFarmSection:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Description = "Bật/tắt tự động farm",
    Default = false,
    Callback = function(Value)
        Config.AutoFarm = Value
        if Value then
            StartFarming()
            Fluent:Notify({
                Title = "Auto Farm",
                Content = "Đã bật Auto Farm",
                Duration = 3,
                Type = "success"
            })
        end
    end
})

-- Farm Mode Dropdown
local FarmModeDropdown = MainFarmSection:AddDropdown("FarmMode", {
    Title = "Chế độ Farm",
    Description = "Chọn cách thức farm",
    Values = {"Nearest", "All", "Custom Position", "Circle", "Line"},
    Multi = false,
    Default = "Nearest",
    Callback = function(Value)
        Config.FarmMode = Value
    end
})

-- Plant Type Dropdown (Multi-select)
local PlantTypeDropdown = MainFarmSection:AddDropdown("PlantType", {
    Title = "Loại cây trồng",
    Description = "Chọn loại cây muốn farm",
    Values = {"Wheat", "Carrot", "Tomato", "Potato", "Corn", "Pumpkin", "Watermelon", "Strawberry", "Blueberry", "Grapes"},
    Multi = true,
    Default = {"Wheat"},
    Callback = function(Value)
        Config.SelectedPlants = Value
    end
})

-- Farm Speed Slider
local FarmSpeedSlider = MainFarmSection:AddSlider("FarmSpeed", {
    Title = "Tốc độ Farm",
    Description = "Điều chỉnh tốc độ farm (giây/chu kỳ)",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        Config.FarmSpeed = Value
    end
})

-- Farm Radius Slider
local FarmRadiusSlider = MainFarmSection:AddSlider("FarmRadius", {
    Title = "Bán kính Farm",
    Description = "Khoảng cách tìm kiếm cây trồng",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.FarmRadius = Value
    end
})

-- Auto Harvest Toggle
local AutoHarvestToggle = MainFarmSection:AddToggle("AutoHarvest", {
    Title = "Auto Harvest",
    Description = "Tự động thu hoạch cây chín",
    Default = true,
    Callback = function(Value)
        Config.AutoHarvest = Value
    end
})

-- Only Ripe Toggle
local OnlyRipeToggle = MainFarmSection:AddToggle("OnlyRipe", {
    Title = "Chỉ thu hoạch cây chín",
    Description = "Chỉ thu hoạch khi cây đã chín hoàn toàn",
    Default = true,
    Callback = function(Value)
        Config.OnlyRipe = Value
    end
})

-- Instant Harvest Toggle
local InstantHarvestToggle = MainFarmSection:AddToggle("InstantHarvest", {
    Title = "Thu hoạch nhanh",
    Description = "Thu hoạch ngay lập tức (có thể bị phát hiện)",
    Default = false,
    Callback = function(Value)
        Config.InstantHarvest = Value
    end
})

-- Auto Plant Toggle
local AutoPlantToggle = MainFarmSection:AddToggle("AutoPlant", {
    Title = "Auto Plant",
    Description = "Tự động trồng cây mới",
    Default = false,
    Callback = function(Value)
        Config.AutoPlant = Value
    end
})

-- Auto Water Toggle
local AutoWaterToggle = MainFarmSection:AddToggle("AutoWater", {
    Title = "Auto Water",
    Description = "Tự động tưới nước cho cây",
    Default = false,
    Callback = function(Value)
        Config.AutoWater = Value
    end
})

-- Auto Sell Toggle
local AutoSellToggle = MainFarmSection:AddToggle("AutoSell", {
    Title = "Auto Sell",
    Description = "Tự động bán sản phẩm khi đầy",
    Default = false,
    Callback = function(Value)
        Config.AutoSell = Value
    end
})

-- Sell Threshold Slider
local SellThresholdSlider = MainFarmSection:AddSlider("SellThreshold", {
    Title = "Ngưỡng bán",
    Description = "Số lượng sản phẩm tối đa trước khi bán",
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Config.SellThreshold = Value
    end
})

-- Collect Seeds Toggle
local CollectSeedsToggle = MainFarmSection:AddToggle("CollectSeeds", {
    Title = "Thu thập hạt giống",
    Description = "Tự động thu thập hạt giống từ cây",
    Default = true,
    Callback = function(Value)
        Config.CollectSeeds = Value
    end
})

-- Loop Farming Toggle
local LoopFarmingToggle = MainFarmSection:AddToggle("LoopFarming", {
    Title = "Farm vòng lặp",
    Description = "Lặp lại quá trình farm liên tục",
    Default = false,
    Callback = function(Value)
        Config.LoopFarming = Value
    end
})
--[[
    ĐOẠN 3: ANIME BUTTON
]]

--===========================================
-- ANIME BUTTON SECTION (trong Main Tab)
--===========================================
local AnimeSection = Tabs.Main:AddSection("Anime Button 🎨")

-- Anime Toggle Button
local AnimeToggleButton = AnimeSection:AddButton({
    Title = "👙 Ẩn/Hiện UI với Anime",
    Description = "Click để ẩn hoặc hiện UI kèm hình anime",
    Callback = function()
        ToggleUIWithAnime()
    end
})

-- Anime Select Dropdown
local AnimeSelectDropdown = AnimeSection:AddDropdown("AnimeSelect", {
    Title = "Chọn hình Anime",
    Description = "Chọn hình anime yêu thích",
    Values = {"Anime Girl 1", "Anime Girl 2", "Anime Girl 3", "Anime Girl 4", "Anime Girl 5", "Bikini Girl", "Cat Girl", "School Girl", "Maid Girl", "Ninja Girl"},
    Multi = false,
    Default = "Anime Girl 1",
    Callback = function(Value)
        Config.SelectedAnime = Value
        UpdateAnimeImage(Value)
    end
})

-- Anime Glow Toggle
local AnimeGlowToggle = AnimeSection:AddToggle("AnimeGlow", {
    Title = "Hiệu ứng Glow",
    Description = "Thêm hiệu ứng phát sáng",
    Default = true,
    Callback = function(Value)
        Config.AnimeGlow = Value
    end
})

-- Anime Bounce Toggle
local AnimeBounceToggle = AnimeSection:AddToggle("AnimeBounce", {
    Title = "Hiệu ứng Bounce",
    Description = "Thêm hiệu ứng nảy",
    Default = true,
    Callback = function(Value)
        Config.AnimeBounce = Value
    end
})

-- Anime Particle Toggle
local AnimeParticleToggle = AnimeSection:AddToggle("AnimeParticle", {
    Title = "Hiệu ứng Particle",
    Description = "Thêm hiệu ứng hạt lấp lánh",
    Default = true,
    Callback = function(Value)
        Config.AnimeParticle = Value
    end
})

-- Anime Auto Rotate Toggle
local AnimeAutoRotateToggle = AnimeSection:AddToggle("AnimeAutoRotate", {
    Title = "Tự động xoay",
    Description = "Tự động xoay hình anime 360 độ",
    Default = false,
    Callback = function(Value)
        Config.AnimeAutoRotate = Value
        if Value then
            StartAutoRotate()
        end
    end
})

-- Anime Opacity Slider
local AnimeOpacitySlider = AnimeSection:AddSlider("AnimeOpacity", {
    Title = "Độ trong suốt",
    Description = "Điều chỉnh độ trong suốt",
    Default = 100,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Config.AnimeOpacity = Value
    end
})

-- Anime Scale Slider
local AnimeScaleSlider = AnimeSection:AddSlider("AnimeScale", {
    Title = "Kích thước",
    Description = "Điều chỉnh kích thước",
    Default = 100,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.AnimeScale = Value
    end
})

-- Random Anime Button
local RandomAnimeButton = AnimeSection:AddButton({
    Title = "🎲 Hình Anime Ngẫu Nhiên",
    Description = "Chọn ngẫu nhiên một hình anime",
    Callback = function()
        ShowRandomAnime()
    end
}) 
--[[
    ĐOẠN 4: FARM TAB - LIGHTNING PREDICTION
]]

--===========================================
-- FARM TAB
--===========================================
local LightningSection = Tabs.Farm:AddSection("Lightning Prediction ⚡")

-- Lightning Prediction Toggle
local LightningPredictionToggle = LightningSection:AddToggle("LightningPrediction", {
    Title = "Đoán Sét Chính Xác",
    Description = "Dự đoán sét với độ chính xác cao",
    Default = false,
    Callback = function(Value)
        Config.LightningPrediction = Value
        if Value then
            StartLightningPrediction()
            Fluent:Notify({
                Title = "Đoán Sét ⚡",
                Content = "Đã bật chức năng đoán sét",
                Duration = 3,
                Type = "success"
            })
        end
    end
})

-- Auto Collect Lightning Toggle
local AutoCollectLightningToggle = LightningSection:AddToggle("AutoCollectLightning", {
    Title = "Tự động nhặt khi sét đánh",
    Description = "Tự động nhặt item khi có sét (phím E)",
    Default = false,
    Callback = function(Value)
        Config.AutoCollectLightning = Value
    end
})

-- Show Countdown Toggle
local ShowCountdownToggle = LightningSection:AddToggle("ShowCountdown", {
    Title = "Hiển thị đếm ngược",
    Description = "Hiển thị số đếm 1-2-3 trên màn hình",
    Default = true,
    Callback = function(Value)
        Config.ShowCountdownUI = Value
    end
})

-- Play Sound Toggle
local PlaySoundToggle = LightningSection:AddToggle("PlaySound", {
    Title = "Âm thanh cảnh báo",
    Description = "Phát âm thanh khi sét sắp đánh",
    Default = true,
    Callback = function(Value)
        Config.PlaySound = Value
    end
})

-- Collect Radius Slider
local CollectRadiusSlider = LightningSection:AddSlider("CollectRadius", {
    Title = "Bán kính nhặt",
    Description = "Khoảng cách tối đa để nhặt item",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Config.CollectRadius = Value
    end
})

-- Collect Seeds Toggle
local CollectSeedsToggle = LightningSection:AddToggle("CollectSeeds", {
    Title = "Nhặt hạt giống",
    Description = "Tự động nhặt hạt giống khi sét đánh",
    Default = true,
    Callback = function(Value)
        Config.AutoCollectSeeds = Value
    end
})

-- Collect Items Toggle
local CollectItemsToggle = LightningSection:AddToggle("CollectItems", {
    Title = "Nhặt tất cả items",
    Description = "Nhặt mọi vật phẩm xuất hiện khi sét đánh",
    Default = true,
    Callback = function(Value)
        Config.AutoCollectItems = Value
    end
})

-- Lightning ESP Toggle
local LightningESPToggle = LightningSection:AddToggle("LightningESP", {
    Title = "ESP Sét",
    Description = "Hiển thị vị trí sét sắp đánh",
    Default = true,
    Callback = function(Value)
        Config.ShowLightningESP = Value
    end
})

-- Lightning Notification Toggle
local LightningNotificationToggle = LightningSection:AddToggle("LightningNotification", {
    Title = "Thông báo",
    Description = "Hiển thị thông báo khi có sét",
    Default = true,
    Callback = function(Value)
        Config.LightningNotification = Value
    end
})

-- Lightning Safe Mode Toggle
local LightningSafeModeToggle = LightningSection:AddToggle("LightningSafeMode", {
    Title = "Chế độ an toàn",
    Description = "Giảm nguy cơ bị phát hiện",
    Default = false,
    Callback = function(Value)
        Config.LightningSafeMode = Value
    end
})

-- Test Lightning Button
local TestLightningButton = LightningSection:AddButton({
    Title = "Test Đoán Sét",
    Description = "Kiểm tra chức năng đoán sét",
    Callback = function()
        StartCountdown()
    end
})
--[[
    ĐOẠN 5: TELEPORT, VISUALS, MISC, SETTINGS
]]

--===========================================
-- TELEPORT TAB
--===========================================
local TeleportSection = Tabs.Teleport:AddSection("Teleport Locations")

-- Teleport Locations
local Locations = {"Farm Area", "Shop", "Market", "Home", "Storage"}

-- Location Dropdown
local LocationDropdown = TeleportSection:AddDropdown("Location", {
    Title = "Địa điểm",
    Description = "Chọn địa điểm muốn dịch chuyển",
    Values = Locations,
    Multi = false,
    Default = "Farm Area",
    Callback = function(Value)
        Config.TeleportLocation = Value
    end
})

-- Teleport Button
local TeleportButton = TeleportSection:AddButton({
    Title = "Teleport",
    Description = "Dịch chuyển đến địa điểm đã chọn",
    Callback = function()
        TeleportToLocation(Config.TeleportLocation)
    end
})

--===========================================
-- VISUALS TAB
--===========================================
local VisualSection = Tabs.Visuals:AddSection("Visual Settings")

-- ESP Toggle
local ESPToggle = VisualSection:AddToggle("ESP", {
    Title = "ESP",
    Description = "Hiển thị thông tin vật phẩm",
    Default = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
        if Value then
            EnableESP()
        else
            DisableESP()
        end
    end
})

-- ESP Color Picker
local ESPColorPicker = VisualSection:AddColorpicker("ESPColor", {
    Title = "Màu ESP",
    Description = "Chọn màu cho ESP",
    Default = Color3.fromRGB(255, 0, 0)
})

-- Show FPS Toggle
local FPSToggle = VisualSection:AddToggle("ShowFPS", {
    Title = "Hiển thị FPS",
    Description = "Hiển thị FPS trên màn hình",
    Default = false,
    Callback = function(Value)
        Config.ShowFPS = Value
        ShowFPS(Value)
    end
})

--===========================================
-- MISC TAB
--===========================================
local MiscSection = Tabs.Misc:AddSection("Miscellaneous Settings")

-- Theme Section
local ThemeSection = Tabs.Misc:AddSection("Theme UI Settings")

-- Theme Dropdown
local ThemeDropdown = ThemeSection:AddDropdown("ThemeSelector", {
    Title = "Chọn Theme UI",
    Description = "Tùy chỉnh giao diện theo sở thích",
    Values = {"Dark", "Light", "Amethyst", "Rose", "Slate", "Darker"},
    Multi = false,
    Default = "Dark",
    Callback = function(Value)
        ChangeTheme(Value)
    end
})

-- Anti AFK Toggle
local AntiAFKToggle = MiscSection:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Description = "Chống AFK tự động",
    Default = false,
    Callback = function(Value)
        Config.AntiAFK = Value
        if Value then
            EnableAntiAFK()
        end
    end
})

-- Auto Rejoin Toggle
local AutoRejoinToggle = MiscSection:AddToggle("AutoRejoin", {
    Title = "Auto Rejoin",
    Description = "Tự động rejoin khi bị kick",
    Default = false,
    Callback = function(Value)
        Config.AutoRejoin = Value
    end
})

-- Auto Save Toggle
local AutoSaveToggle = MiscSection:AddToggle("AutoSave", {
    Title = "Auto Save",
    Description = "Tự động lưu game",
    Default = false,
    Callback = function(Value)
        Config.AutoSave = Value
    end
})

-- Low Graphics Toggle
local LowGraphicsToggle = MiscSection:AddToggle("LowGraphics", {
    Title = "Low Graphics",
    Description = "Giảm chất lượng đồ họa để tăng FPS",
    Default = false,
    Callback = function(Value)
        Config.LowGraphics = Value
        if Value then
            EnableLowGraphics()
        else
            DisableLowGraphics()
        end
    end
})

-- FPS Boost Toggle
local FPSBoostToggle = MiscSection:AddToggle("FPSBoost", {
    Title = "FPS Boost",
    Description = "Tăng FPS bằng cách tối ưu hóa",
    Default = false,
    Callback = function(Value)
        Config.FPSBoost = Value
        if Value then
            EnableFPSBoost()
        else
            DisableFPSBoost()
        end
    end
})

-- Reset Character Button
local ResetButton = MiscSection:AddButton({
    Title = "Reset Character",
    Description = "Reset nhân vật của bạn",
    Callback = function()
        ResetCharacter()
    end
})

-- Rejoin Server Button
local RejoinButton = MiscSection:AddButton({
    Title = "Rejoin Server",
    Description = "Tham gia lại server",
    Callback = function()
        RejoinServer()
    end
})

--===========================================
-- SETTINGS TAB
--===========================================
local SettingsSection = Tabs.Settings:AddSection("Player Settings")

-- Walk Speed Slider
local WalkSpeedSlider = SettingsSection:AddSlider("WalkSpeed", {
    Title = "Tốc độ di chuyển",
    Description = "Điều chỉnh tốc độ chạy",
    Default = 16,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Config.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Jump Power Slider
local JumpPowerSlider = SettingsSection:AddSlider("JumpPower", {
    Title = "Sức nhảy",
    Description = "Điều chỉnh sức nhảy",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.JumpPower = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Infinite Jump Toggle
local InfiniteJumpToggle = SettingsSection:AddToggle("InfiniteJump", {
    Title = "Nhảy vô hạn",
    Description = "Cho phép nhảy liên tục",
    Default = false,
    Callback = function(Value)
        Config.InfiniteJump = Value
        EnableInfiniteJump(Value)
    end
})
--[[
    ĐOẠN 6: CÁC HÀM XỬ LÝ CHỨC NĂNG
]]

--===========================================
-- CÁC HÀM XỬ LÝ CHỨC NĂNG
--===========================================

-- Hàm bắt đầu farm
function StartFarming()
    spawn(function()
        while Config.AutoFarm do
            pcall(function()
                FarmCycle()
            end)
            wait(Config.FarmSpeed)
        end
    end)
end

-- Hàm chu kỳ farm
function FarmCycle()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return end
    
    -- Tìm cây trồng gần nhất
    local nearestPlant = FindNearestPlant()
    
    if nearestPlant then
        local distance = (humanoidRootPart.Position - nearestPlant.Position).Magnitude
        
        if distance > 10 then
            humanoid:MoveTo(nearestPlant.Position)
        else
            HarvestPlant(nearestPlant)
            
            if Config.AutoPlant then
                PlantNewCrop()
            end
            
            if Config.AutoWater then
                WaterPlant()
            end
        end
        
        if Config.CollectSeeds then
            CollectSeedsFromPlant()
        end
    end
    
    if Config.AutoSell and ShouldSell() then
        SellProducts()
    end
end

-- Hàm tìm cây trồng gần nhất
function FindNearestPlant()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local nearestPlant = nil
    local nearestDistance = Config.FarmRadius
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Model") then
            local plantName = obj.Name:lower()
            local isPlant = false
            
            for _, plantType in ipairs(Config.SelectedPlants) do
                if plantName:find(plantType:lower()) then
                    isPlant = true
                    break
                end
            end
            
            if isPlant then
                local plantPosition = nil
                if obj:IsA("Part") then
                    plantPosition = obj.Position
                elseif obj:IsA("Model") and obj.PrimaryPart then
                    plantPosition = obj.PrimaryPart.Position
                end
                
                if plantPosition then
                    local distance = (character.HumanoidRootPart.Position - plantPosition).Magnitude
                    
                    if not Config.OnlyRipe or IsPlantRipe(obj) then
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestPlant = obj
                        end
                    end
                end
            end
        end
    end
    
    return nearestPlant
end

-- Hàm kiểm tra cây đã chín chưa
function IsPlantRipe(plant)
    if plant:FindFirstChild("Growth") then
        return plant.Growth.Value >= 100
    elseif plant:FindFirstChild("Ripe") then
        return plant.Ripe.Value == true
    elseif plant:FindFirstChild("Ready") then
        return plant.Ready.Value == true
    end
    
    return true
end

-- Hàm thu hoạch cây
function HarvestPlant(plant)
    if Config.InstantHarvest then
        FireProximityPrompt(plant)
        ClickPlant(plant)
    else
        ClickPlant(plant)
    end
end

-- Hàm click vào cây
function ClickPlant(plant)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
        wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
    end)
end

-- Hàm kích hoạt ProximityPrompt
function FireProximityPrompt(obj)
    pcall(function()
        local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            prompt:InputHoldBegin()
            wait(0.1)
            prompt:InputHoldEnd()
        end
    end)
end

-- Hàm trồng cây mới
function PlantNewCrop()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("Seed") then
                character.Humanoid:EquipTool(item)
                item:Activate()
                wait(0.5)
                item:Deactivate()
                break
            end
        end
    end)
end

-- Hàm tưới nước
function WaterPlant()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Water") then
                character.Humanoid:EquipTool(tool)
                tool:Activate()
                wait(0.5)
                tool:Deactivate()
                break
            end
        end
    end)
end

-- Hàm thu thập hạt giống
function CollectSeedsFromPlant()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Name:find("Seed") then
                if (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    FireProximityPrompt(obj)
                end
            end
        end
    end)
end

-- Hàm kiểm tra có nên bán không
function ShouldSell()
    local inventoryCount = 0
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        inventoryCount = #backpack:GetChildren()
    end
    return inventoryCount >= Config.SellThreshold
end

-- Hàm bán sản phẩm
function SellProducts()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("Model") then
                if obj.Name:find("Shop") or obj.Name:find("Market") or obj.Name:find("Sell") then
                    if obj:IsA("Part") then
                        LocalPlayer.Character.Humanoid:MoveTo(obj.Position)
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        LocalPlayer.Character.Humanoid:MoveTo(obj.PrimaryPart.Position)
                    end
                    
                    if obj:FindFirstChildOfClass("ProximityPrompt") then
                        FireProximityPrompt(obj)
                    end
                    break
                end
            end
        end
    end)
end

-- Hàm teleport
function TeleportToLocation(locationName)
    local character = LocalPlayer.Character
    if not character then return end
    
    local targetPosition = nil
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Model") then
            if obj.Name == locationName or obj.Name:lower():find(locationName:lower()) then
                if obj:IsA("Part") then
                    targetPosition = obj.Position
                elseif obj:IsA("Model") and obj.PrimaryPart then
                    targetPosition = obj.PrimaryPart.Position
                end
                break
            end
        end
    end
    
    if targetPosition then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local tween = TweenService:Create(humanoidRootPart, 
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))}
            )
            tween:Play()
            
            Fluent:Notify({
                Title = "Teleport",
                Content = "Đã dịch chuyển đến " .. locationName,
                Duration = 3,
                Type = "success"
            })
        end
    else
        Fluent:Notify({
            Title = "Teleport",
            Content = "Không tìm thấy địa điểm: " .. locationName,
            Duration = 3,
            Type = "error"
        })
    end
end

-- Hàm ESP
function EnableESP()
    spawn(function()
        while Config.ESPEnabled do
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") and obj:FindFirstChildOfClass("BillboardGui") == nil then
                    if obj.Name:find("Plant") or obj.Name:find("Item") or obj.Name:find("Crop") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPGui"
                        billboard.Adornee = obj
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.AlwaysOnTop = true
                        
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = obj.Name
                        textLabel.TextColor3 = ESPColorPicker.Value or Color3.fromRGB(255, 0, 0)
                        textLabel.TextStrokeTransparency = 0
                        textLabel.Parent = billboard
                        
                        billboard.Parent = obj
                    end
                end
            end
            wait(5)
        end
    end)
end

-- Hàm tắt ESP
function DisableESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") and obj.Name == "ESPGui" then
            obj:Destroy()
        end
    end
end

-- Hàm hiển thị FPS
function ShowFPS(enable)
    if enable then
        spawn(function()
            local fpsGui = Instance.new("ScreenGui")
            fpsGui.Name = "FPSGui"
            fpsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Name = "FPSLabel"
            fpsLabel.Size = UDim2.new(0, 100, 0, 30)
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            fpsLabel.BackgroundTransparency = 0.5
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fpsLabel.TextStrokeTransparency = 0
            fpsLabel.Parent = fpsGui
            
            while Config.ShowFPS do
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                fpsLabel.Text = "FPS: " .. fps
            end
            
            fpsGui:Destroy()
        end)
    end
end

-- Hàm chống AFK
function EnableAntiAFK()
    spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        while Config.AntiAFK do
            wait(60)
            VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
end

-- Hàm reset character
function ResetCharacter()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end)
end

-- Hàm rejoin server
function RejoinServer()
    pcall(function()
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        ts:Teleport(placeId, LocalPlayer)
    end)
end

-- Hàm đổi theme
function ChangeTheme(themeName)
    Fluent:Notify({
        Title = "Theme UI",
        Content = "Đã chuyển sang theme: " .. themeName,
        Duration = 3,
        Type = "success"
    })
end

-- Hàm low graphics
function EnableLowGraphics()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
    end)
end

-- Hàm tắt low graphics
function DisableLowGraphics()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = true
            end
        end
    end)
end

-- Hàm FPS boost
function EnableFPSBoost()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end)
end

-- Hàm tắt FPS boost
function DisableFPSBoost()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end)
end

-- Hàm nhảy vô hạn
function EnableInfiniteJump(enable)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if enable then
        humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
            if Config.InfiniteJump then
                wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end
--[[
    ĐOẠN 7: LIGHTNING FUNCTIONS
]]

--===========================================
-- LIGHTNING PREDICTION FUNCTIONS
--===========================================

-- Hàm bắt đầu dự đoán sét
function StartLightningPrediction()
    spawn(function()
        while Config.LightningPrediction do
            pcall(function()
                AnalyzeLightningEnvironment()
            end)
            wait(0.05)
        end
    end)
end

-- Hàm phân tích môi trường
function AnalyzeLightningEnvironment()
    DetectThunderSounds()
    DetectLightningFlash()
    DetectStormClouds()
    DetectLightningParticles()
    DetectLightningObjects()
    
    if LightningState.ThunderDetected and not LightningState.IsCounting then
        StartCountdown()
    end
end

-- Hàm phát hiện âm thanh sấm
function DetectThunderSounds()
    pcall(function()
        for _, sound in ipairs(Workspace:GetDescendants()) do
            if sound:IsA("Sound") and sound.IsPlaying then
                local soundName = sound.Name:lower()
                if soundName:find("thunder") or soundName:find("lightning") or soundName:find("storm") then
                    LightningState.ThunderDetected = true
                    break
                end
            end
        end
    end)
end

-- Hàm phát hiện ánh sáng sét
function DetectLightningFlash()
    pcall(function()
        local lighting = game:GetService("Lighting")
        if lighting.Brightness > 3 then
            LightningState.ThunderDetected = true
        end
    end)
end

-- Hàm phát hiện mây bão
function DetectStormClouds()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                local objName = obj.Name:lower()
                if objName:find("cloud") or objName:find("storm") then
                    local color = obj.Color
                    if color.r < 0.3 and color.g < 0.3 and color.b < 0.3 then
                        LightningState.ThunderDetected = true
                        break
                    end
                end
            end
        end
    end)
end

-- Hàm phát hiện particle sét
function DetectLightningParticles()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") and obj.Enabled then
                local objName = obj.Name:lower()
                if objName:find("lightning") or objName:find("electric") then
                    LightningState.ThunderDetected = true
                    break
                end
            end
        end
    end)
end

-- Hàm phát hiện object sét
function DetectLightningObjects()
    pcall(function()
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("Part") and part.Material == Enum.Material.Neon then
                local partName = part.Name:lower()
                if partName:find("lightning") or partName:find("electric") then
                    LightningState.ThunderDetected = true
                    LightningState.LightningPosition = part.Position
                    break
                end
            end
        end
    end)
end

-- Hàm bắt đầu đếm ngược
function StartCountdown()
    LightningState.IsCounting = true
    LightningState.CurrentCount = 0
    LightningState.HasLightningStruck = false
    
    if Config.ShowCountdownUI then
        CreateCountdownUI()
    end
    
    if Config.PlaySound then
        PlayWarningSound()
    end
    
    if Config.LightningNotification then
        Fluent:Notify({
            Title = "Cảnh báo Sét ⚡",
            Content = "Sét sắp đánh! Chuẩn bị nhặt!",
            Duration = 2,
            Type = "warning"
        })
    end
    
    spawn(function()
        for count = 1, 3 do
            LightningState.CurrentCount = count
            
            if LightningState.CountdownLabel then
                LightningState.CountdownLabel.Text = tostring(count)
            end
            
            wait(1)
        end
        
        OnLightningStrike()
    end)
end

-- Hàm xử lý khi sét đánh
function OnLightningStrike()
    LightningState.IsLightningActive = true
    LightningState.HasLightningStruck = true
    LightningState.TotalLightningStrikes = LightningState.TotalLightningStrikes + 1
    
    LightningState.LightningPosition = FindLightningPosition()
    
    if Config.ShowLightningESP then
        ShowLightningESP(LightningState.LightningPosition)
    end
    
    if Config.AutoCollectLightning then
        wait(0.5)
        AutoCollectItems()
    end
    
    if Config.LightningNotification then
        Fluent:Notify({
            Title = "Sét đã đánh ⚡",
            Content = "Đang thu thập vật phẩm!",
            Duration = 3,
            Type = "success"
        })
    end
    
    wait(2)
    LightningState.IsCounting = false
    LightningState.IsLightningActive = false
    LightningState.ThunderDetected = false
    
    RemoveCountdownUI()
end

-- Hàm tạo UI đếm ngược
function CreateCountdownUI()
    pcall(function()
        RemoveCountdownUI()
        
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LightningCountdown"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
        
        local frame = Instance.new("Frame")
        frame.Name = "CountdownFrame"
        frame.Size = UDim2.new(0, 120, 0, 120)
        frame.Position = UDim2.new(0.5, -60, 0.3, -60)
        frame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Name = "CountdownLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "1"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 60
        label.Font = Enum.Font.GothamBlack
        label.TextStrokeTransparency = 0
        label.Parent = frame
        
        LightningState.CountdownGui = screenGui
        LightningState.CountdownLabel = label
    end)
end

-- Hàm xóa UI đếm ngược
function RemoveCountdownUI()
    pcall(function()
        if LightningState.CountdownGui then
            LightningState.CountdownGui:Destroy()
            LightningState.CountdownGui = nil
            LightningState.CountdownLabel = nil
        end
    end)
end

-- Hàm phát âm thanh cảnh báo
function PlayWarningSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9118816544"
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end)
end

-- Hàm tìm vị trí sét
function FindLightningPosition()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return Vector3.new(0, 0, 0)
    end
    
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") and part.Material == Enum.Material.Neon then
            if part.Name:lower():find("lightning") then
                return part.Position
            end
        end
    end
    
    local randomOffset = Vector3.new(math.random(-30, 30), 0, math.random(-30, 30))
    return character.HumanoidRootPart.Position + randomOffset
end

-- Hàm hiển thị ESP sét
function ShowLightningESP(position)
    pcall(function()
        local marker = Instance.new("Part")
        marker.Name = "LightningMarker"
        marker.Size = Vector3.new(5, 5, 5)
        marker.Position = position
        marker.Anchored = true
        marker.CanCollide = false
        marker.Material = Enum.Material.Neon
        marker.Color = Color3.fromRGB(255, 255, 0)
        marker.Transparency = 0.5
        marker.Parent = Workspace
        
        spawn(function()
            wait(3)
            marker:Destroy()
        end)
    end)
end

-- Hàm tự động nhặt items
function AutoCollectItems()
    spawn(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart then return end
        
        local itemsToCollect = {}
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("Model") then
                local shouldCollect = false
                local objName = obj.Name:lower()
                
                if Config.AutoCollectSeeds and objName:find("seed") then
                    shouldCollect = true
                end
                
                if Config.AutoCollectItems and (objName:find("item") or objName:find("drop") or objName:find("loot") or obj:FindFirstChildOfClass("ProximityPrompt")) then
                    shouldCollect = true
                end
                
                if shouldCollect then
                    local itemPosition = nil
                    if obj:IsA("Part") then
                        itemPosition = obj.Position
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        itemPosition = obj.PrimaryPart.Position
                    end
                    
                    if itemPosition then
                        local distance = (humanoidRootPart.Position - itemPosition).Magnitude
                        if distance <= Config.CollectRadius then
                            table.insert(itemsToCollect, {object = obj, position = itemPosition, distance = distance})
                        end
                    end
                end
            end
        end
        
        table.sort(itemsToCollect, function(a, b)
            return a.distance < b.distance
        end)
        
        local collectedCount = 0
        for _, itemData in ipairs(itemsToCollect) do
            if not Config.AutoCollectLightning then break end
            
            pcall(function()
                local item = itemData.object
                local distance = itemData.distance
                
                if distance > 5 then
                    humanoid:MoveTo(itemData.position)
                    local waitTime = 0
                    while waitTime < 3 and (humanoidRootPart.Position - itemData.position).Magnitude > 5 do
                        wait(0.1)
                        waitTime = waitTime + 0.1
                    end
                end
                
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                
                collectedCount = collectedCount + 1
                LightningState.CollectedItems = LightningState.CollectedItems + 1
            end)
            
            wait(0.2)
        end
        
        if Config.LightningNotification and collectedCount > 0 then
            Fluent:Notify({
                Title = "Thu thập hoàn tất",
                Content = "Đã nhặt " .. collectedCount .. " vật phẩm từ sét!",
                Duration = 3,
                Type = "success"
            })
        end
    end)
end
--[[
    ĐOẠN 8: ANIME FUNCTIONS VÀ KẾT THÚC
]]

--===========================================
-- ANIME BUTTON FUNCTIONS
--===========================================

-- Hàm toggle UI với anime
function ToggleUIWithAnime()
    if UIState.IsHidden then
        ShowUIWithAnime()
    else
        HideUIWithAnime()
    end
end

-- Hàm ẩn UI với anime
function HideUIWithAnime()
    UIState.IsHidden = true
    Window:Hide()
    CreateAnimeGUI()
    
    if UIState.AnimeFrame then
        UIState.AnimeFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
        local tween = TweenService:Create(UIState.AnimeFrame, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0.5, 0)}
        )
        tween:Play()
    end
end

-- Hàm hiện UI với anime
function ShowUIWithAnime()
    UIState.IsHidden = false
    
    if UIState.AnimeFrame then
        local tween = TweenService:Create(UIState.AnimeFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, -1.5, 0)}
        )
        tween:Play()
        tween.Completed:Connect(function()
            RemoveAnimeGUI()
        end)
    end
    
    Window:Show()
end

-- Hàm tạo GUI anime
function CreateAnimeGUI()
    pcall(function()
        RemoveAnimeGUI()
        
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AnimeToggleGUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
        UIState.AnimeGui = screenGui
        
        local background = Instance.new("Frame")
        background.Name = "Background"
        background.Size = UDim2.new(1, 0, 1, 0)
        background.Position = UDim2.new(0, 0, 0, 0)
        background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        background.BackgroundTransparency = 0.7
        background.Parent = screenGui
        
        local animeFrame = Instance.new("Frame")
        animeFrame.Name = "AnimeFrame"
        animeFrame.Size = UDim2.new(0, 350 * (Config.AnimeScale / 100), 0, 500 * (Config.AnimeScale / 100))
        animeFrame.Position = UDim2.new(0.5, -175 * (Config.AnimeScale / 100), 0.5, -250 * (Config.AnimeScale / 100))
        animeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        animeFrame.BackgroundTransparency = 0.1
        animeFrame.BorderSizePixel = 0
        animeFrame.Parent = screenGui
        UIState.AnimeFrame = animeFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 20)
        corner.Parent = animeFrame
        
        if Config.AnimeGlow then
            local glow = Instance.new("UIStroke")
            glow.Name = "GlowEffect"
            glow.Color = Color3.fromRGB(255, 100, 200)
            glow.Thickness = 3
            glow.Transparency = 0.5
            glow.Parent = animeFrame
        end
        
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "AnimeImage"
        imageLabel.Size = UDim2.new(1, -20, 1, -80)
        imageLabel.Position = UDim2.new(0, 10, 0, 10)
        imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        imageLabel.BackgroundTransparency = 0.2
        imageLabel.BorderSizePixel = 0
        imageLabel.ScaleType = Enum.ScaleType.Crop
        imageLabel.Parent = animeFrame
        UIState.AnimeImageLabel = imageLabel
        
        local imageCorner = Instance.new("UICorner")
        imageCorner.CornerRadius = UDim.new(0, 15)
        imageCorner.Parent = imageLabel
        
        imageLabel.Image = AnimeImages[UIState.SelectedAnimeImage] or AnimeImages[1]
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.Position = UDim2.new(0, 0, 0.9, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "Click để hiện UI! 💕"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 20
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.Parent = animeFrame
        
        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.BackgroundTransparency = 1
        clickButton.Text = ""
        clickButton.Parent = animeFrame
        
        clickButton.MouseButton1Click:Connect(function()
            ShowUIWithAnime()
        end)
        
        clickButton.MouseEnter:Connect(function()
            UIState.IsHovering = true
            if Config.AnimeBounce then
                local tween = TweenService:Create(animeFrame, 
                    TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 380 * (Config.AnimeScale / 100), 0, 530 * (Config.AnimeScale / 100))}
                )
                tween:Play()
            end
        end)
        
        clickButton.MouseLeave:Connect(function()
            UIState.IsHovering = false
            local tween = TweenService:Create(animeFrame, 
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 350 * (Config.AnimeScale / 100), 0, 500 * (Config.AnimeScale / 100))}
            )
            tween:Play()
        end)
        
        if Config.AnimeParticle then
            CreateParticleEffects()
        end
        
        StartAnimeEffects()
    end)
end

-- Hàm xóa GUI anime
function RemoveAnimeGUI()
    pcall(function()
        if UIState.AnimeGui then
            UIState.AnimeGui:Destroy()
            UIState.AnimeGui = nil
            UIState.AnimeFrame = nil
            UIState.AnimeImageLabel = nil
        end
    end)
end

-- Hàm cập nhật hình ảnh anime
function UpdateAnimeImage(animeName)
    pcall(function()
        local imageIndex = 1
        local animeMap = {
            ["Anime Girl 1"] = 1,
            ["Anime Girl 2"] = 2,
            ["Anime Girl 3"] = 3,
            ["Anime Girl 4"] = 4,
            ["Anime Girl 5"] = 5,
            ["Bikini Girl"] = 6,
            ["Cat Girl"] = 7,
            ["School Girl"] = 8,
            ["Maid Girl"] = 9,
            ["Ninja Girl"] = 10,
        }
        
        imageIndex = animeMap[animeName] or 1
        UIState.SelectedAnimeImage = imageIndex
        
        if UIState.AnimeImageLabel then
            UIState.AnimeImageLabel.Image = AnimeImages[imageIndex]
        end
    end)
end

-- Hàm hiện anime ngẫu nhiên
function ShowRandomAnime()
    pcall(function()
        local randomIndex = math.random(1, #AnimeImages)
        UIState.SelectedAnimeImage = randomIndex
        
        if UIState.AnimeImageLabel then
            UIState.AnimeImageLabel.Image = AnimeImages[randomIndex]
        end
    end)
end

-- Hàm tạo particle effects
function CreateParticleEffects()
    pcall(function()
        if not UIState.AnimeFrame then return end
        
        for i = 1, 20 do
            spawn(function()
                while Config.AnimeParticle and UIState.AnimeFrame do
                    local particle = Instance.new("Frame")
                    particle.Size = UDim2.new(0, 5, 0, 5)
                    particle.Position = UDim2.new(math.random(), math.random(), math.random(), math.random())
                    particle.BackgroundColor3 = Color3.fromRGB(255, 200, 255)
                    particle.BackgroundTransparency = 0.5
                    particle.BorderSizePixel = 0
                    particle.Parent = UIState.AnimeFrame
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = particle
                    
                    local tween = TweenService:Create(particle, 
                        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Position = UDim2.new(math.random(), math.random(), -0.2, 0), BackgroundTransparency = 1}
                    )
                    tween:Play()
                    
                    wait(0.1)
                    particle:Destroy()
                    wait(0.5)
                end
            end)
        end
    end)
end

-- Hàm bắt đầu hiệu ứng anime
function StartAnimeEffects()
    spawn(function()
        while UIState.AnimeFrame do
            if Config.AnimeBounce and not UIState.IsHovering then
                local tween = TweenService:Create(UIState.AnimeFrame, 
                    TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(0.5, 0, 0.5, -10)}
                )
                tween:Play()
                
                local tweenBack = TweenService:Create(UIState.AnimeFrame, 
                    TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(0.5, 0, 0.5, 0)}
                )
                tweenBack:Play()
            end
            
            wait(2)
        end
    end)
end

-- Hàm tự động xoay
function StartAutoRotate()
    spawn(function()
        while Config.AnimeAutoRotate and UIState.AnimeFrame do
            UIState.CurrentRotation = UIState.CurrentRotation + 5
            UIState.AnimeFrame.Rotation = UIState.CurrentRotation
            wait(0.05)
        end
    end)
end

--===========================================
-- KHỞI TẠO SAVE MANAGER VÀ INTERFACE MANAGER
--===========================================
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("GreenyGrowersHub")
SaveManager:BuildConfigSection(Tabs.Settings)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("GreenyGrowersHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

--===========================================
-- CHỌN TAB MẶC ĐỊNH
--===========================================
Window:SelectTab(1)

--===========================================
-- THÔNG BÁO KHỞI ĐỘNG
--===========================================
Fluent:Notify({
    Title = "Greeny Growers Hub",
    Content = "Script đã được tải thành công!",
    Duration = 5,
    Type = "success"
})

print("========================================")
print("Greeny Growers Hub - Loaded Successfully!")
print("Version: 1.0.0")
print("Made with ❤ by Script Expert")
print("========================================")