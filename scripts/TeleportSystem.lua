-- ===== CLEANUP =====
local SCRIPT_NAME = "TeleportSystem"

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== Teleport System Starting ===")

local Players = game:GetService("Players")

local teleportLocations = {
	{name = "Spawn", position = Vector3.new(0, 5, 0)},
	{name = "High", position = Vector3.new(0, 50, 0)},
	{name = "Far", position = Vector3.new(100, 5, 100)},
}

local connections = {}

local function onPlayerChatted(player, message)
	-- Ignore chat from an older version of the script
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		return
	end

	local lowerMessage = message:lower()

	for _, location in ipairs(teleportLocations) do
		if lowerMessage == "!tp " .. location.name:lower() then
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:FindFirstChild("HumanoidRootPart")

			if hrp then
				hrp.CFrame = CFrame.new(location.position)
				print("Teleported " .. player.Name .. " to " .. location.name)
			end

			break
		end
	end
end

local function setupPlayer(player)
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		return
	end

	table.insert(connections,
		player.Chatted:Connect(function(message)
			onPlayerChatted(player, message)
		end)
	)

	print("Connected:", player.Name)
end

table.insert(connections, Players.PlayerAdded:Connect(setupPlayer))

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- Disconnect everything when a newer version starts
task.spawn(function()
	while _G.Versions[SCRIPT_NAME] == myVersion do
		task.wait(0.5)
	end

	for _, connection in ipairs(connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end

	print("[" .. SCRIPT_NAME .. "] Cleaned up old connections")
end)

print("=== Teleport System Running ===")
