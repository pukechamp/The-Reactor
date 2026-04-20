extends CharacterBody3D

@export var enemy_type: int # 0 for big guy, 1 for goblin
const SPEED = 3
var extra_speed = 0

enum State { DEAD, MOVE }
var state : State = State.MOVE

var room_locs: Array[Vector3] = [
	Vector3(40.8333, 0, 49.758), # Room 0
	Vector3(81.338, 0, 9.045), # Room 1
	Vector3(81.316, 0, 49.758), # Room 2
	Vector3(81.316, 0, 90.285), # Room 3
	Vector3(40.598, 0, 90.144), # Room 4
	Vector3(0.231, 0, 90.192), # Room 5
	Vector3(0.231, 0, 49.758), # Room 6
	Vector3(0.231, 0, 9.045), # Room 7
	Vector3(40.598, 0, 9.045), # Room 8
]

var player_x = 0.231
var player_z = 9.045

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHandler.receive_new_location.connect(get_player_location)
	EventHandler.update_enemy_rotation.connect(update_rotation)
	EventHandler.increase_difficulty.connect(speed_up)
	$Control.hide()
	if enemy_type == 0:
		$Sprite3D.texture = load("res://trenchbroom/textures/Beekeeper.png")
		$Sprite3D.position.y = 4.4
		$Sprite3D.scale = Vector3(2.8, 2.8, 2.8)
		$Steps.stream = load("res://Sfx/u_n1up2g5sdg-stomp-255897.mp3")
	else:
		$Sprite3D.texture = load("res://trenchbroom/textures/gremlin.png")
		$Sprite3D.position.y = 2.4
		$Sprite3D.scale = Vector3(1.6, 1.6, 1.6)
		$Steps.stream = load("res://Sfx/dragon-studio-witch-laugh-401713.mp3")
		_on_move()
	$Steps.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	velocity += get_gravity() * delta
	
	match state:
		State.DEAD:
			_on_death()
		State.MOVE:
			if enemy_type == 0:
				_chase()
			else:
				goblin_brain() #_on_move()
	
	move_and_slide()

func _on_death():
	velocity = Vector3.ZERO # FINISH IF SHOOTING MECHANIC IS IMPLEMENTED

func _on_move():
	nav_agent.target_position = room_locs.pick_random()
	
func goblin_brain(): # Separate from on_move to prevent it from constantly changing rooms
	if nav_agent.is_target_reached():
		return
	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - global_transform.origin).normalized()
	velocity.x = dir.x * ((SPEED + extra_speed) * 2)
	velocity.z = dir.z * ((SPEED + extra_speed) * 2)
	
func _chase():
	nav_agent.target_position = Vector3(player_x, 0, player_z)
	
	if nav_agent.is_target_reached():
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - global_transform.origin).normalized()
	velocity.x = dir.x * (SPEED + extra_speed)
	velocity.z = dir.z * (SPEED + extra_speed)

func get_player_location(p_x, p_z):
	if enemy_type == 0:
		player_x = p_x
		player_z = p_z
		_chase()
	
func update_rotation(p_y):
	$Sprite3D.rotation.y = p_y

func _on_navigation_agent_3d_navigation_finished() -> void:
	if enemy_type == 1:
		_on_move()

func _on_player_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		$DeathSound.play()
		$Control.show()
		await get_tree().create_timer(.4).timeout
		EventHandler.game_over.emit()

func speed_up():
	extra_speed += 1
