-- Leaderboard Stats Example
print("=== Leaderboard Stats Starting ===")

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local leaderstats = Instance.new("Folder")
leaderstats.Name = "leaderstats"
leaderstats.Parent = game.Players

local function setupPlayer(player)
    local playerLeaderstats = leaderstats:Clone()
    playerLeaderstats.Name = "leaderstats"
    playerLeaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 100
    coins.Parent = playerLeaderstats
    
    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = 1
    level.Parent = playerLeaderstats
    
    print("Setup leaderboard for " .. player.Name)
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

print("=== Leaderboard Stats Running ===")
