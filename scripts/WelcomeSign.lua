-- scripts/WelcomeSign.lua
-- SignConfig is available directly as a global from the sandbox

local signPart = Instance.new("Part")
signPart.Name = "WelcomeSign"
signPart.Size = Vector3.new(1, 1, 1)
signPart.Position = SignConfig.Position
signPart.Anchored = true
signPart.CanCollide = false
signPart.Transparency = 1
signPart.Parent = workspace

local billboard = Instance.new("BillboardGui")
billboard.Size = UDim2.new(0, 120, 0, 120)
billboard.StudsOffset = Vector3.new(0, 0, 0)
billboard.AlwaysOnTop = true
billboard.Parent = signPart
billboard.MaxDistance = 50

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 0.25
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Text = SignConfig.Text
label.TextColor3 = SignConfig.Colors[1]
label.Parent = billboard

task.spawn(function()
    local colorIndex = 1
    while true do
        colorIndex = (colorIndex % #SignConfig.Colors) + 1
        label.TextColor3 = SignConfig.Colors[colorIndex]
        task.wait(SignConfig.ColorCycleSeconds)
    end
end)

print("[WelcomeSign] Sign created")
