-- scripts/DoorSystem.lua
print("=== Door System Starting ===")

local TweenService = game:GetService("TweenService")

-- Create door part
local doorPart = Instance.new("Part")
doorPart.Name = "AutoDoor"
doorPart.Size = Vector3.new(4, 8, 1)
doorPart.Position = Vector3.new(0, 4, 10)
doorPart.Anchored = true
doorPart.Color = Color3.fromRGB(139, 69, 19) -- Brown
doorPart.Parent = workspace

print("Door created at: " .. tostring(doorPart.Position))

local openPosition = doorPart.Position + Vector3.new(0, 10, 0)
local closePosition = doorPart.Position
local isOpen = false

-- Animate door up and down automatically
task.spawn(function()
    while true do
        -- Open door
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(doorPart, tweenInfo, {Position = openPosition})
        tween:Play()
        isOpen = true
        print("Door opening...")
        
        tween.Completed:Wait()
        print("Door opened")
        
        -- Wait 3 seconds
        task.wait(3)
        
        -- Close door
        local closeTween = TweenService:Create(doorPart, tweenInfo, {Position = closePosition})
        closeTween:Play()
        isOpen = false
        print("Door closing...")
        
        closeTween.Completed:Wait()
        print("Door closed")
        
        -- Wait 3 seconds
        task.wait(3)
    end
end)

print("=== Door System Running ===")
