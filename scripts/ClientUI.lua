-- scripts/ClientUI.lua
print("=== Client UI Script Loaded ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local DamageEvent = ReplicatedStorage:WaitForChild("PlayerDamage")

-- Create a simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DamageCounter"
screenGui.Parent = player.PlayerGui

local damageLabel = Instance.new("TextLabel")
damageLabel.Name = "DamageLabel"
damageLabel.Size = UDim2.new(0, 200, 0, 50)
damageLabel.Position = UDim2.new(0.5, -100, 0, 20)
damageLabel.BackgroundTransparency = 0.5
damageLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
damageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
damageLabel.Text = "Damage: 0"
damageLabel.TextScaled = true
damageLabel.Parent = screenGui

local totalDamage = 0

-- Simulate dealing damage
task.spawn(function()
    while true do
        task.wait(2)
        local damage = math.random(10, 50)
        totalDamage = totalDamage + damage
        damageLabel.Text = "Damage: " .. totalDamage
        DamageEvent:FireServer(damage)
    end
end)

print("=== Client UI Script Initialized ===")
