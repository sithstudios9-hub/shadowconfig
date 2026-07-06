-- scripts/DoorSystem.lua
local TweenService = game:GetService("TweenService")

-- ===== CLEANUP =====
local SCRIPT_NAME = "AutoDoor"
local old = workspace:FindFirstChild(SCRIPT_NAME)
if old then old:Destroy() end
_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

local doorPart = Instance.new("Part")
doorPart.Name = SCRIPT_NAME -- must match SCRIPT_NAME
doorPart.Size = Vector3.new(4, 8, 1)
doorPart.Position = Vector3.new(0, 4, 10)
doorPart.Anchored = true
doorPart.Parent = workspace

local openPos = doorPart.Position + Vector3.new(0, 10, 0)
local closePos = doorPart.Position

task.spawn(function()
    while _G.Versions[SCRIPT_NAME] == myVersion do
        local info = TweenInfo.new(2, Enum.EasingStyle.Quad)
        TweenService:Create(doorPart, info, {Position = openPos}):Play()
        task.wait(5)
        TweenService:Create(doorPart, info, {Position = closePos}):Play()
        task.wait(5)
    end
end)
