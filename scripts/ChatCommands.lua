-- Simple Chat Commands
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
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = speed
                print("Set " .. player.Name .. " speed to " .. speed)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

print("=== Chat Commands Running ===")
