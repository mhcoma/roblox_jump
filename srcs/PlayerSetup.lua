-- 플레이어 시작 세팅 스크립트

-- 유저 데이터 저장 장소
local data_store = game:GetService("DataStoreService")

-- 각각의 저장소로 구성
local gold_store = data_store:GetDataStore("GoldStore")
local speed_store = data_store:GetDataStore("SpeedStore")
local double_jump_store = data_store:GetDataStore("DoubleJumpStore")
local high_jump_store = data_store:GetDataStore("HighJumpStore")
local save_point_store = data_store:GetDataStore("SavePointStore")

-- 정보 불러오기 함수
-- store: 불러올 저장소
-- dest: 값을 저장할 정보 공간
-- 매개변수가 하나 더 있을 경우 전처리 함수
function load_data(player, store, dest, ...)
	local get_success, value = pcall(function()
		return store:GetAsync(player.UserId)
	end)

	if select('#', ...) > 0 then
		local func = select(1, ...)
		value = func(value)
	end
	
	if get_success and value then
		dest.Value = value
	end
end

-- 벡터 unpack
function unpack_vec3(value)
	return Vector3.new(table.unpack(value))
end

-- 벡터 pack
function pack_vec3(v)
	return {v.x, v.y, v.z}
end

-- 유저 입장 시
function on_player_join(player)
	-- 유저 정보 공간 초기화
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	-- 동전
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats
	
	-- 롱 점프 가능 여부
	local speed = Instance.new("BoolValue")
	speed.Name = "Speed"
	speed.Value = false
	speed.Parent = player
	
	-- 더블 점프 가능 여부
	local can_double_jump = Instance.new("BoolValue")
	can_double_jump.Name = "CanDoubleJump"
	can_double_jump.Value = false
	can_double_jump.Parent = player
	
	-- 하이 점프 가능 여부
	local can_high_jump = Instance.new("BoolValue")
	can_high_jump.Name = "CanHighJump"
	can_high_jump.Value = false
	can_high_jump.Parent = player
	
	-- 세이브포인트의 기본값은 영벡터
	local save_point = Instance.new("Vector3Value")
	save_point.Name = "SavePoint"
	save_point.Value = Vector3.zero
	save_point.Parent = player
	
	-- 유저 정보 불러오기
	-- 이미 저장된 정보가 없다면 초기화된 정보를 그대로 사용
	load_data(player, gold_store, player.leaderstats.Coins)
	load_data(player, speed_store, player.Speed)
	load_data(player, double_jump_store, player.CanDoubleJump)
	load_data(player, high_jump_store, player.CanHighJump)
	load_data(player, save_point_store, player.SavePoint, unpack_vec3)
end

-- 정보 저장 함수
-- store: 저장할 저장소
-- dest: 값을 저장된 정보 공간
-- 매개변수가 하나 더 있을 경우 전처리 함수
function save_data(player, store, src, ...)
	local value
	
	if select('#', ...) > 0 then
		local func = select(1, ...)
		value = func(src.Value)
	else
		value = src.Value
	end
	
	local set_success, error_message = pcall(function()
		return store:SetAsync(player.UserId, value)
	end)

	if not set_success then
		warn(error_message)
	end
end

-- 유저 퇴장 시
function on_player_quit(player)
	-- 유저 정보 저장
	save_data(player, gold_store, player.leaderstats.Coins)
	save_data(player, speed_store, player.Speed)
	save_data(player, double_jump_store, player.CanDoubleJump)
	save_data(player, high_jump_store, player.CanHighJump)
	save_data(player, save_point_store, player.SavePoint, pack_vec3)
end

game.Players.PlayerAdded:Connect(on_player_join)
game.Players.PlayerRemoving:Connect(on_player_quit)