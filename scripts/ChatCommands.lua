-- ===== CLEANUP =====
local SCRIPT_NAME = "ChatCommands"

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== Chat Commands Starting ===")

local Players = game:GetService("Players")

local connections = {}

local function onPlayerChatted(player, message)
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		return
	end

	local lowerMessage = message:lower()

	if lowerMessage == "!hello" then
		print(player.Name .. " said hello!")

	elseif lowerMessage == "!stats" then
		print("Stats command from " .. player.Name)

	elseif lowerMessage:sub(1, 6) == "!speed" then
		local speed = tonumber(lowerMessage:sub(8))

		if speed then
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:FindFirstChild("Humanoid")

			if humanoid then
				humanoid.WalkSpeed = speed
				print("Set " .. player.Name .. " speed to " .. speed)
			end
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

	print("Connected chat for", player.Name)
end

table.insert(connections, Players.PlayerAdded:Connect(setupPlayer))

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- Cleanup when a newer version starts
task.spawn(function()
	while _G.Versions[SCRIPT_NAME] == myVersion do
		task.wait(0.5)
	end

	for _, connection in ipairs(connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end

	print("[" .. SCRIPT_NAME .. "] Cleaned up")
end)

print("=== Chat Commands Running ===")
