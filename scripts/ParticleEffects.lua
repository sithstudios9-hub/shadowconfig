-- Particle Effects Example

print("=== Particle Effects Starting ===")

local baseplate = workspace:WaitForChild("Baseplate")

if baseplate then
	local attachment = Instance.new("Attachment")
	attachment.Parent = baseplate
	attachment.Position = Vector3.new(0, 1, 0)

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
