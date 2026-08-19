repeat wait() until game:IsLoaded()

if LPH_OBFUSCATED == nil then
	LPH_NO_VIRTUALIZE = function(...) return (...) end
	LPH_ENCSTR = function(...) return (...) end
	LRM_SANITIZE = function(...) return ... end
end

local cloneref = cloneref or function(o) return o end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local TextService = cloneref(game:GetService("TextService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = cloneref(Players.LocalPlayer)

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

if identifyexecutor and identifyexecutor() == "Wave" then
	getgenv().gethui = function()
		return game:GetService("CoreGui")
	end
end

local Folder_Configs = {
	Directory = "solixhub",
	Assets = "solixhub/Assets",
	Configs = "solixhub/Configs",
	Datas = "solixhub/Datas",
	Images = "solixhub/Images",
	Themes = "solixhub/Themes"
}

for _, Folder in Folder_Configs do
	if not isfolder(Folder) then
		makefolder(Folder)
	end
end

local GameId = tostring(game.GameId)
local GameConfigFolder = Folder_Configs.Configs .. "/" .. GameId

if not isfolder(GameConfigFolder) then
	makefolder(GameConfigFolder)
end

local GameList = {
	["9584852943"] = { id = "61e0f394c005902cda5643069ac59226", keyless = false }, -- +1 Speed Keyboard Escape
	["7326934954"] = { id = "00e140acb477c5ecde501c1d448df6f9", keyless = true }, -- 99 Nights in the Forest
	["10148749921"] = { id = "0d120852a6e2eb65c691e5ce2c628429", keyless = false }, -- Animal Hospital
	["4658598196"] = { id = "d383a1d5c0a779bbfd0a2b74437923d5", keyless = true }, -- Attack on Titan Revolution
	["5130394318"] = { id = "3e7a75a970118d0f0cf629369524dc7d", keyless = false }, -- Bizarre Lineage
	["994732206"] = { id = "e2718ddebf562c5c4080dfce26b09398", keyless = false }, -- Blox Fruits
	["10200395747"] = { id = "535322ccaa7a6ba59febea91b085c89c", keyless = true }, -- Grow a Garden 2
	["3808223175"] = { id = "4fe2dfc202115670b1813277df916ab2", keyless = false }, -- Jujutsu Infinite
	["66654135"] = { id = "1bc67a62ae73efe4babe9f2b6b7e4646", keyless = true }, -- Murder Mystery 2
	["7395930870"] = { id = "d3191d52e71790d40a4d169f5becd325", keyless = true }, -- Sell Lemons
	["1511883870"] = { id = "fefdf5088c44beb34ef52ed6b520507c", keyless = false }, -- Shindo Life
	["7219654364"] = { id = "a5182e78f7af6810e08e05cb72542dbf", keyless = true }, -- Sheriff VS Murderer
	["10475794799"] = { id = "7c9b5f90b8e6b7f89698e773feb9eac2", keyless = true }, -- Dig & Clean
	["7613921865"] = { id = "46d43d3868af285218f28453704b620b", keyless = true }, -- Anime Expedition
	["10563114921"] = { id = "82f55d768183c258359d9a7c093d5a60", keyless = false }, -- Steal A Egg 

}

local Config = {
	File = "solixhub/savedkey.txt",
	Workink = "https://rekonise.com/workink-al8vg",
	Rinku = "https://ads.luarmor.net/get_key?for=Solix_Hub_Rinku-pqJCGTqnTsng",
	Discord = "https://discord.gg/solixhub",
	Shop = "https://solixhub.com/free",
}

local ErrorMessages = {
	KEY_EXPIRED = "Your key ran out. Buy a new one for $1.99",
	KEY_BANNED = "This key is banned. Join Discord for help.",
	KEY_HWID_LOCKED = "Key used on another PC. Reset HWID in Discord.",
	KEY_INCORRECT = "Wrong key. Check it and try again.",
	KEY_INVALID = "That doesnt look like a key.",
	SCRIPT_ID_INCORRECT = "Script not found.",
	SCRIPT_ID_INVALID = "Script deleted.",
	INVALID_EXECUTOR = "Your executor isnt supported.",
	SECURITY_ERROR = "Something went wrong. Try again.",
	TIME_ERROR = "Fix your PC clock and try again.",
	UNKNOWN_ERROR = "Something broke. Join Discord for help.",
}

local GameConfig = GameList[GameId]

if not GameConfig then
	StarterGui:SetCore("SendNotification", {
		Title = "SHARA Hub [Dangzues]",
		Text = "This game is not supported.",
		Icon = "rbxassetid://137698471325689",
	})
	return
end

local ScriptId = GameConfig.id
local IsKeyless = true

local LoaderUrl = "https://api.luarmor.net/files/v4/loaders/" .. ScriptId .. ".lua"

-- Keyless loader: no Get Key UI, no key input, no key validation.
loadstring(game:HttpGet(LoaderUrl))()
