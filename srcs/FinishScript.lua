-- 클리어 효과 스크립트
-- 동전 수집 스크립트와 텔레포트 스크립트를 응용하여 구성

local players = game:GetService("Players")
local stage = script.Parent
local fireworks = stage.Fireworks
local teleport_part = script.TeleportDestination

local awarded_players = {}

function toggle_transparency(toggle)
	for i, v in pairs(fireworks.Part:GetChildren()) do
		v.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, toggle),
			NumberSequenceKeypoint.new(1, toggle)
		}
	end
end

function on_touched(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	if humanoid then
		local hit_player = players:GetPlayerFromCharacter(hit.parent)
		if awarded_players[hit_player] then
			return
		end
		
		script.JazzFanfare:Play()
		toggle_transparency(0.0)
		awarded_players[hit_player] = true
		wait(10)
		toggle_transparency(1.0)
		humanoid.RootPart.CFrame = CFrame.new(teleport_part.Position)
		awarded_players[hit_player] = false
	end
end

function on_died(player)
	awarded_players[player] = nil
end

function on_character_added(character, player)
	character:WaitForChild("Humanoid").Died:Connect(function()
		on_died(player)
	end)
end

function on_player_added(player)
	player.CharacterAdded:Connect(function(character)
		on_character_added(character, player)
	end)
end

stage.Touched:connect(on_touched)
players.PlayerRemoving:Connect(on_died)
players.PlayerAdded:Connect(on_player_added)

toggle_transparency(1.0)