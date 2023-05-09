-- 동전 수집 스크립트
-- 오픈 소스로부터 수정

-- 데이터 저장소
local data_stores = game:GetService("DataStoreService")
local data_store = data_stores:GetDataStore("DataStore")

local players = game:GetService("Players")
-- 코인 파트
local coin = script.Parent
-- 코인에 저장된 값
local value = coin:GetAttribute("coin_value")

-- 중복지급을 막기 위한 목록
local awarded_players = {}

function on_touched(hit)
	-- 동전 파트에 플레이어가 접촉했을 경우
	if hit.Parent:FindFirstChild("Humanoid") then
		local hit_player = players:GetPlayerFromCharacter(hit.parent)
		-- 이미 수집한 플레이어의 경우 아무런 작용도 하지 않음
		if awarded_players[hit_player] then
			return
		end
		
		-- 그렇지 않을 경우 플레이어의 코인 보유량을 증가
		hit_player.leaderstats.Coins.Value = hit_player.leaderstats.Coins.Value + value

		-- 동전을 수집한 경우 같은 동전을 다시 수집할 수 없음
		awarded_players[hit_player] = true

		-- 효과음 재생 이후 동전은 1초간 사라졌다가 나타남
		script.Sound:Play()
		script.Parent.Transparency = 1
		wait(1)
		script.Parent.Transparency = 0
	end
end

function on_died(player)
	-- 플레이어가 죽었을 경우 다시 해당 동전을 수집할 수 있음
	awarded_players[player] = nil
end

function on_character_added(character, player)
	-- 플레이어가 죽었을 때, on_died 호출
	character:WaitForChild("Humanoid").Died:Connect(function()
		on_died(player)
	end)
end

function on_player_added(player)
	player.CharacterAdded:Connect(function(character)
		on_character_added(character, player)
	end)
end

-- 동전에 닿았을 때 on_touched 호출
coin.Touched:connect(on_touched)
-- 플레이어가 나갈 때, on_died 호출
players.PlayerRemoving:Connect(on_died)
-- 플레이어가 나타났을 때, on_player_added 호출
players.PlayerAdded:Connect(on_player_added)