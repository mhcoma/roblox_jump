-- 플레이어를 즉사시키는 스크립트
-- 떨어져서 지형지물에 닿았을 때 호출

function on_touched(part)
	local h = part.Parent:findFirstChild("Humanoid")
	if h ~= nil then
		h.Health = h.Health-100
	end
end

script.Parent.Touched:connect(on_touched)