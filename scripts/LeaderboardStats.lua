-- ===== CLEANUP =====
local SCRIPT_NAME = "LeaderboardStats"

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== Leaderboard Stats Starting ===")

local Players = game:GetService("Players")

local function setupPlayer(player)
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		return
	end

	-- Remove old leaderstats if this script is reloaded
	local old = player:FindFirstChild("leaderstats")
	if old then
		old:Destroy()
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 100
	coins.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = leaderstats

	print("Setup leaderboard for " .. player.Name)
end

local playerAddedConnection

playerAddedConnection = Players.PlayerAdded:Connect(function(player)
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		playerAddedConnection:Disconnect()
		return
	end

	setupPlayer(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

print("=== Leaderboard Stats Running ===")
