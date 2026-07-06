-- Simple GUI Example
print("=== Simple GUI Starting ===")

local Players = game:GetService("Players")

local function createGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShadowConfigGUI"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Welcome to ShadowConfig!"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 24
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = frame
    
    print("GUI created for " .. player.Name)
end

Players.PlayerAdded:Connect(createGUI)

-- Create GUI for existing players
for _, player in pairs(Players:GetPlayers()) do
    createGUI(player)
end

print("=== Simple GUI Running ===")
