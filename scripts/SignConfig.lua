-- scripts/SignConfig.lua
-- ModuleScript: just data/settings, no side effects. Safe to reload freely
-- since re-requiring it just gives back a fresh table -- nothing to clean up.

local SignConfig = {}

SignConfig.Text = "Welcome to the Game!"
SignConfig.Position = Vector3.new(12, 12, 0)
SignConfig.ColorCycleSeconds = 1.5
SignConfig.Colors = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(70, 255, 130),
    Color3.fromRGB(80, 170, 255),
    Color3.fromRGB(255, 225, 70),
}

return SignConfig
