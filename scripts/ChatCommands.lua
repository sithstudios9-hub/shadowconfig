print("=== Chat Commands Starting ===")

local Players = game:GetService("Players")

local function onPlayerChatted(player, message)
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
	player.Chatted:Connect(function(message)
		onPlayerChatted(player, message)
	end)

	print("Connected chat for", player.Name)
end

Players.PlayerAdded:Connect(setupPlayer)

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

print("=== Chat Commands Running ===")
