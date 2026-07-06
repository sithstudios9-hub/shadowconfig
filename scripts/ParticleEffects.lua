-- Particle Effects Example

-- ===== CLEANUP =====
local SCRIPT_NAME = "ParticleEffects"

local old = workspace:FindFirstChild(SCRIPT_NAME)
if old then
	old:Destroy()
end

_G.Versions = _G.Versions or {}
_G.Versions[SCRIPT_NAME] = (_G.Versions[SCRIPT_NAME] or 0) + 1
local myVersion = _G.Versions[SCRIPT_NAME]
-- ===================

print("=== Particle Effects Starting ===")

local baseplate = workspace:WaitForChild("Baseplate")

if _G.Versions[SCRIPT_NAME] ~= myVersion then
	return
end

if baseplate then
	-- Container so cleanup can simply destroy one instance
	local container = Instance.new("Folder")
	container.Name = SCRIPT_NAME
	container.Parent = workspace

	local attachment = Instance.new("Attachment")
	attachment.Parent = container
	attachment.WorldPosition = baseplate.Position + Vector3.new(0, 1, 0)

	local particles = Instance.new("ParticleEmitter")
	particles.Color = ColorSequence.new(Color3.fromRGB(0, 191, 255))
	particles.Size = NumberSequence.new(0.5, 2)
	particles.Lifetime = NumberRange.new(2, 4)
	particles.Rate = 50
	particles.Speed = NumberRange.new(5, 10)
	particles.SpreadAngle = Vector2.new(360, 360)
	particles.Parent = attachment

	print("Particle emitter created")
end

print("=== Particle Effects Running ===")
