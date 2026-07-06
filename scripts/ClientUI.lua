-- ===== CLEANUP =====
local SCRIPT_NAME = "ClientUI"

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== Client UI Script Loaded ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DamageEvent = ReplicatedStorage:WaitForChild("PlayerDamage")

-- Remove previous GUI
local oldGui = playerGui:FindFirstChild("DamageCounter")
if oldGui then
	oldGui:Destroy()
end

-- Stop immediately if a newer version loaded
if _G.Versions[SCRIPT_NAME] ~= myVersion then
	return
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DamageCounter"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

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

task.spawn(function()
	while _G.Versions[SCRIPT_NAME] == myVersion do
		task.wait(2)

		local damage = math.random(10, 50)
		totalDamage += damage
		damageLabel.Text = "Damage: " .. totalDamage

		DamageEvent:FireServer(damage)
	end

	-- Cleanup when replaced
	if screenGui then
		screenGui:Destroy()
	end

	print("[" .. SCRIPT_NAME .. "] Stopped")
end)

print("=== Client UI Script Initialized ===")
