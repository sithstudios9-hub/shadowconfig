print("=== Teleport System Starting ===")

local Players = game:GetService("Players")

local teleportLocations = {
    {name = "Spawn", position = Vector3.new(0, 5, 0)},
    {name = "High", position = Vector3.new(0, 50, 0)},
    {name = "Far", position = Vector3.new(100, 5, 100)},
}

local function onPlayerChatted(player, message)
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
    player.Chatted:Connect(function(message)
        print("Chat received:", player.Name, message)
        onPlayerChatted(player, message)
    end)

    print("Connected:", player.Name)
end

Players.PlayerAdded:Connect(setupPlayer)

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

print("=== Teleport System Running ===")
