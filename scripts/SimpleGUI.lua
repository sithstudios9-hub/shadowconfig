-- ===== CLEANUP =====
local SCRIPT_NAME = "ShadowConfigGUI"

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== ShadowConfig GUI Starting ===")

local Players = game:GetService("Players")

local connections = {}

local function createGUI(player)
	if _G.Versions[SCRIPT_NAME] ~= myVersion then
		return
	end

	local playerGui = player:WaitForChild("PlayerGui")

	-- Remove previous GUI
	local oldGui = playerGui:FindFirstChild("ShadowConfigGUI")
	if oldGui then
		oldGui:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ShadowConfigGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Shadow
	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(0, 280, 0, 100)
	shadow.Position = UDim2.new(1, -25, 1, -25)
	shadow.AnchorPoint = Vector2.new(1, 1)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.55
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = screenGui

	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 12)
	shadowCorner.Parent = shadow

	-- Main Frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 280, 0, 100)
	frame.Position = UDim2.new(1, -30, 1, -30)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(220, 40, 40)
	stroke.Thickness = 2
	stroke.Parent = frame

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 5, 1, 0)
	accent.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
	accent.BorderSizePixel = 0
	accent.Parent = frame

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(0, 12)
	accentCorner.Parent = accent

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 18, 0, 10)
	title.Size = UDim2.new(1, -25, 0, 28)
	title.Font = Enum.Font.GothamBold
	title.Text = "ShadowConfig"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 22
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local subtitle = Instance.new("TextLabel")
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.new(0, 18, 0, 42)
	subtitle.Size = UDim2.new(1, -25, 0, 40)
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = "Configuration system loaded successfully."
	subtitle.TextWrapped = true
	subtitle.TextColor3 = Color3.fromRGB(190, 190, 190)
	subtitle.TextSize = 14
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.Parent = frame

	print("GUI created for", player.Name)
end

table.insert(connections, Players.PlayerAdded:Connect(createGUI))

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
	createGUI(player)
end

-- Cleanup event connections when replaced
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

print("=== ShadowConfig GUI Running ===")
