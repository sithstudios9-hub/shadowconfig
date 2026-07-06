-- scripts/DoorSystem.lua
local TweenService = game:GetService("TweenService")

local doorPart = Instance.new("Part")
doorPart.Name = "AutoDoor"
doorPart.Size = Vector3.new(5, 5, 1)
doorPart.Position = Vector3.new(0, 4, 10)
doorPart.Anchored = true
doorPart.Parent = workspace

local openPos = doorPart.Position + Vector3.new(0, 5, 0)
local closePos = doorPart.Position

task.spawn(function()
    while true do
        local info = TweenInfo.new(2, Enum.EasingStyle.Quad)
        TweenService:Create(doorPart, info, {Position = openPos}):Play()
        task.wait(5)
        TweenService:Create(doorPart, info, {Position = closePos}):Play()
        task.wait(5)
    end
end)
