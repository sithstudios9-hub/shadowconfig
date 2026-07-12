print("=== Leaderboard Stats Starting ===")

local Players = game:GetService("Players")

local function setupPlayer(player)
	-- Remove old leaderstats if they already exist
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

	local xp = Instance.new("IntValue")
		xp.Name = "XP"
		xp.Value = 1
		xp.Parent = leaderstats

	print("Setup leaderboard for " .. player.Name)
end

Players.PlayerAdded:Connect(setupPlayer)

-- Setup existing players
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

print("=== Leaderboard Stats Running ===")
