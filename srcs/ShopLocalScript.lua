-- 상점 토글 스크립트

local run_service = game:GetService("RunService")
local local_player = script.Parent.Parent.Parent
local shop_toggle = game.ReplicatedStorage:WaitForChild("shop_toggle")
local shop = workspace.Map.m00_SpawnStage.Shop.Shop
local shop_pos = shop.Torso.Position
local connection

function on_heartbeat()
	local character = local_player.Character or local_player.CharacterAdded:Wait()
	local character_pos = character:GetPrimaryPartCFrame().p
	
	-- 캐릭터와 상점간의 거리 계산
	local distance = (character_pos - shop_pos).Magnitude
	
	-- 상점이 열려 있는 상태에서,
	-- 캐릭터가 상점으로부터 일정 거리 이상 벗어나면 자동으로 종료
	if (distance >= 15.0) and script.Parent.Frame.Visible then
		on_clicked()
		connection:Disconnect()
	end
end

function on_clicked()
	-- 상점 GUI 켜고 끔
	script.Parent.Frame.Visible = not script.Parent.Frame.Visible
	
	-- 상점이 열려 있다면
	if script.Parent.Frame.Visible then
		-- 텍스트 변경
		shop.Prompt.ActionText = "Close"
		-- 매 틱마다 on_heartbeat 호출
		connection = run_service.Heartbeat:Connect(on_heartbeat)
	else
		shop.Prompt.ActionText = "Open"
	end
end

-- 상점 토글 작동 시 on_clicked 호출
shop_toggle.OnClientEvent:Connect(on_clicked)