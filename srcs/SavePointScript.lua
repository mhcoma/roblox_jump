-- 세이브포인트를 저장하는 스크립트

-- 세이브포인트 파트 객체
local teleport_part = script.Parent

local players = game:GetService("Players")

local function on_touched(hit)
	-- 세이브포인트 파트에 플레이어가 접촉했을 경우
	if hit.Parent:FindFirstChild("Humanoid") then
		local hit_player = players:GetPlayerFromCharacter(hit.parent)
		-- 해당 플레이어의 세이브포인트 위치를 세이브포인트 파트의 위치로 설정
		hit_player.SavePoint.Value = teleport_part.Position
	end
end

-- 세이브포인트 파트에 닿았을 경우 on_touched 호출
teleport_part.Touched:Connect(on_touched)