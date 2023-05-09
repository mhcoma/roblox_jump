-- 더블 점프 구매 스크립트
-- 상점 GUI에서 버튼 클릭 시 호출
-- 롱 점프나 하이 점프 등도 똑같이 구현

local local_player = script.Parent.Parent.Parent.Parent.Parent.Parent
local price = tonumber(script.Parent.Price.Text)

function on_clicked()
	local account = local_player.leaderstats.Coins.Value
	-- 플레이어의 돈이 가격보다 많고, 아직 더블 점프를 구매하지 않았을 경우
	if (account >= price and not local_player.CanDoubleJump.Value) then
		-- 더블 점프 가능 여부로 설정
		local_player.CanDoubleJump.Value = true
		-- 플레이어의 돈을 가격만큼 차감
		local_player.leaderstats.Coins.Value -= price
	end
end

script.Parent.MouseButton1Click:connect(on_clicked)