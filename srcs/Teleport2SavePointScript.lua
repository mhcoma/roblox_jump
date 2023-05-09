-- 세이브포인트로 텔레포트하는 스크립트

-- 텔레포트 파트
local teleport_part = script.Parent

local players = game:GetService("Players")

local function on_touched(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	-- 텔레포트 파트에 플레이어가 접촉했을 경우
	if humanoid then
		local hit_player = players:GetPlayerFromCharacter(hit.parent)
		-- 세이브포인트의 값이 영벡터가 아닐 경우
		if hit_player.SavePoint.Value ~= Vector3.zero then
			-- 플레이어의 위치를 세이브포인트로 이동
			humanoid.RootPart.CFrame = CFrame.new(hit_player.SavePoint.Value)
		end
	end
end

-- 텔레포트 파트에 닿을 경우 on_touched 호출
teleport_part.Touched:Connect(on_touched)