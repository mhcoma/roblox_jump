-- 특수 점프 스크립트
-- 오픈 소스로부터 수정

local user_input_service = game:GetService("UserInputService")
local local_player = game.Players.LocalPlayer
local character
local humanoid

local can_double_jump = false
local has_double_jumped = false
local old_power
local old_speed
local TIME_BETWEEN_JUMPS = 0.2

function on_jump_request()
	if not character or not humanoid or not character:IsDescendantOf(workspace) or
		humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end
	
	-- 플레이어가 하이 점프가 가능한 상태라면
	if local_player.CanHighJump.Value then
		humanoid.JumpPower = old_power * 1.25
	else
		humanoid.JumpPower = old_power
	end
	
	-- 왼쪽 시프트 키를 누른 상태에서,
	-- 플레이어가 롱 점프가 가능한 상태라면
	if user_input_service:IsKeyDown(Enum.KeyCode.LeftShift) then
		if local_player.Speed.Value then
			-- 그 순간 이동 속도를 두 배로 설정
			humanoid.WalkSpeed = old_speed * 2
		else
			humanoid.WalkSpeed = old_speed
		end
	end

	if can_double_jump and not has_double_jumped then
		has_double_jumped = true
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

function on_character_added(new_character)
	character = new_character
	humanoid = new_character:WaitForChild("Humanoid")
	has_double_jumped = false
	can_double_jump = false
	old_power = humanoid.JumpPower
	old_speed = humanoid.WalkSpeed
	humanoid.UseJumpPower = true;

	humanoid.StateChanged:connect(function(old, new)
		if new == Enum.HumanoidStateType.Landed then
			can_double_jump = false
			has_double_jumped = false
			humanoid.JumpPower = old_power
			humanoid.WalkSpeed = old_speed
		elseif new == Enum.HumanoidStateType.Freefall then
			if local_player.CanDoubleJump.Value then
				wait(TIME_BETWEEN_JUMPS)
				can_double_jump = true
			end
		end
	end)
end

if local_player.Character then
	on_character_added(local_player.Character)
end

local_player.CharacterAdded:connect(on_character_added)
user_input_service.JumpRequest:connect(on_jump_request)
