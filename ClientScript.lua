-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Press F to toggle flight. WASD moves, Space rises, and LeftControl descends.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("FlightToggle")
local SPEED = 55

local character
local humanoid
local rootPart
local attachment
local velocity
local orientation
local renderConnection
local flightEnabled = false

local function stopFlight()
	flightEnabled = false
	if renderConnection then
		renderConnection:Disconnect()
		renderConnection = nil
	end
	if velocity then
		velocity:Destroy()
		velocity = nil
	end
	if orientation then
		orientation:Destroy()
		orientation = nil
	end
	if attachment then
		attachment:Destroy()
		attachment = nil
	end
	if humanoid and humanoid.Parent then
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

local function startFlight()
	if flightEnabled or not character or not humanoid or not rootPart or humanoid.Health <= 0 then
		return
	end

	flightEnabled = true
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	humanoid.PlatformStand = true

	attachment = Instance.new("Attachment")
	attachment.Name = "FlightAttachment"
	attachment.Parent = rootPart

	velocity = Instance.new("LinearVelocity")
	velocity.Name = "FlightVelocity"
	velocity.Attachment0 = attachment
	velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	velocity.VectorVelocity = Vector3.zero
	velocity.MaxForce = rootPart.AssemblyMass * workspace.Gravity * 10
	velocity.Parent = rootPart

	orientation = Instance.new("AlignOrientation")
	orientation.Name = "FlightOrientation"
	orientation.Attachment0 = attachment
	orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	orientation.Responsiveness = 15
	orientation.MaxTorque = rootPart.AssemblyMass * workspace.Gravity * 10
	orientation.Parent = rootPart

	renderConnection = RunService.RenderStepped:Connect(function()
		if not flightEnabled or not rootPart or not rootPart.Parent then
			stopFlight()
			return
		end

		local camera = workspace.CurrentCamera
		if not camera then
			return
		end

		local input = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then input += camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then input -= camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then input += camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then input -= camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then input += Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then input -= Vector3.yAxis end

		if input.Magnitude > 1 then
			input = input.Unit
		end
		velocity.VectorVelocity = input * SPEED

		local look = camera.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if flatLook.Magnitude > 0.01 then
			orientation.CFrame = CFrame.lookAt(Vector3.zero, flatLook.Unit)
		end
	end)
end

local function toggleFlight()
	if flightEnabled then
		stopFlight()
		remote:FireServer(false)
	else
		startFlight()
		if flightEnabled then
			remote:FireServer(true)
		end
	end
end

local function onCharacterAdded(newCharacter)
	stopFlight()
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")
	humanoid.Died:Connect(stopFlight)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.F then
		toggleFlight()
	end
end)

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end
