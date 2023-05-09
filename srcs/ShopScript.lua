-- 상점 열기 스크립트

-- 상점 파트
local shop_building = script.Parent

-- 상점에 상호작용하기 위한 프롬프트
local prompt = shop_building.Shop.Prompt

-- 상점을 켜고 끄는 이벤트
local shop_toggle = game.ReplicatedStorage:WaitForChild("shop_toggle")

function on_triggered(player)
	-- 상호작용 시 shop_toggle 발생
	shop_toggle:FireClient(player)
end

-- 상점에 상호작용 시 on_triggerd 호출
prompt.Triggered:Connect(on_triggered)