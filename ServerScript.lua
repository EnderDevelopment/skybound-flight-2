-- Place this Script in ServerScriptService.
-- This server controls whether each player may use the game's flight ability.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("FlightToggle")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "FlightToggle"
	remote.Parent = ReplicatedStorage
end

local lastToggleAt = {}
local TOGGLE_COOLDOWN = 0.35

local function setFlightEnabled(player, enabled)
	if typeof(enabled) ~= "boolean" then
		return
	end

	local now = os.clock()
	if now - (lastToggleAt[player] or 0) < TOGGLE_COOLDOWN then
		return
	end
	lastToggleAt[player] = now

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	player:SetAttribute("FlightEnabled", enabled)
end

remote.OnServerEvent:Connect(setFlightEnabled)

local function onPlayerAdded(player)
	player:SetAttribute("FlightEnabled", false)
	player.CharacterAdded:Connect(function()
		player:SetAttribute("FlightEnabled", false)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
	lastToggleAt[player] = nil
end)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
