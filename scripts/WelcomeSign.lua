-- scripts/WelcomeSign.lua
-- Script (not ModuleScript): creates a real, visible floating sign in the
-- game world, using settings pulled from the SignConfig ModuleScript.
-- Demonstrates a Script -> ModuleScript reference under this loader.

-- ===== CLEANUP =====
-- Same pattern as DoorSystem: gives this script a "name tag" so a re-run
-- destroys the old sign and stops the old animation loop before starting
-- a new one, instead of stacking duplicates.
local SCRIPT_NAME = "WelcomeSign"

local old = workspace:FindFirstChild(SCRIPT_NAME)
if old then
    old:Destroy()
end

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

-- Reference the ModuleScript loaded by the bootstrap script. Because
-- scripts.json entries can load in any order, wait briefly for the module
-- to show up in the shared _G.ShadowConfigModules table (exposed by the
-- bootstrap script) rather than assuming it's already there.
local SignConfig
local attempts = 0
while not SignConfig and _G.Versions[SCRIPT_NAME] == myVersion and attempts < 20 do
    SignConfig = _G.ShadowConfigModules and _G.ShadowConfigModules["SignConfig"]
    if not SignConfig then
        attempts = attempts + 1
        task.wait(0.5)
    end
end

if not SignConfig then
    warn("[" .. SCRIPT_NAME .. "] SignConfig module not available, aborting")
    return
end

if _G.Versions[SCRIPT_NAME] ~= myVersion then
    -- A newer version of this script started while we were waiting; let
    -- that one own the sign instead of creating a second one.
    return
end

-- Build a real, visible object in the world (not just a print statement):
-- an invisible anchor Part carrying a BillboardGui with big text, floating
-- above the map, cycling through colors.
local signPart = Instance.new("Part")
signPart.Name = SCRIPT_NAME -- matches SCRIPT_NAME so cleanup can find it next time
signPart.Size = Vector3.new(1, 1, 1)
signPart.Position = SignConfig.Position
signPart.Anchored = true
signPart.CanCollide = false
signPart.Transparency = 1
signPart.Parent = workspace

local billboard = Instance.new("BillboardGui")
billboard.Size = UDim2.new(0, 400, 0, 120)
billboard.StudsOffset = Vector3.new(0, 0, 0)
billboard.AlwaysOnTop = true
billboard.Parent = signPart

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 0.25
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Text = SignConfig.Text
label.TextColor3 = SignConfig.Colors[1]
label.Parent = billboard

-- Animate forever, gated by version so this loop stops itself the moment
-- a newer version of this script takes over.
task.spawn(function()
    local colorIndex = 1
    while _G.Versions[SCRIPT_NAME] == myVersion do
        colorIndex = (colorIndex % #SignConfig.Colors) + 1
        label.TextColor3 = SignConfig.Colors[colorIndex]
        task.wait(SignConfig.ColorCycleSeconds)
    end
end)

print("[" .. SCRIPT_NAME .. "] Sign created using SignConfig (version " .. myVersion .. ")")
