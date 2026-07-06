-- Simple Teleport System
print("=== Teleport System Starting ===")

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local teleportLocations = {
    {name = "Spawn", position = Vector3.new(0, 5, 0)},
    {name = "High", position = Vector3.new(0, 50, 0)},
    {name = "Far", position = Vector3.new(100, 5, 100)},
}

local function onPlayerChatted(player, message)
    local lowerMessage = message:lower()
    
    for _, location in ipairs(teleportLocations) do
        if lowerMessage == "!tp " .. location.name:lower() then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(location.position)
                print("Teleported " .. player.Name .. " to " .. location.name)
            end
            break
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

print("=== Teleport System Running ===")
