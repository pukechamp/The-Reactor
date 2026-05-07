extends Node3D

var enemies = preload("res://Scenes/enemy.tscn")
var minigame_ids = [ -1, -2, -3, -4] # Array of each minigames ID
var open_doors = [0, 1, 2, 3, 4 , 5, 6, 7, 8, 9, 10, 11]
var difficulty = 0

# TODO: Rework how the door activations work so they spawn at different times individually of each other and never overlap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHandler.open_door.connect(update_open_doors)
	EventHandler.game_over.connect(game_over)
	EventHandler.hide_or_show_clock.connect(set_clock_vis)
	minigame_ids.shuffle() # Shuffled in order to randomize the order in which they boot
	$DoorTimer.start()
	
	await get_tree().create_timer(5).timeout
	for i in range(4):
		EventHandler.boot_minigame.emit(minigame_ids[i])
		await get_tree().create_timer(15).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CenterContainer/Label.text = time_to_string()

func game_over(_cod):
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/gameover.tscn")

func enemy_spawn(id):
	var enemy = enemies.instantiate()
	enemy.enemy_type = id
	enemy.player_x = $Player.position.x # Enemy type 0 needs this for his first location
	enemy.player_z = $Player.position.z
	enemy.position = get_spawn_point()
	add_child(enemy)
	
func get_spawn_point() -> Vector3: # Replace with something more sophisticated if time allows
	var rand_num = randi() & 4 # Will always spawn a given enemy in a room far away from the player
	match $Player.current_room:
		-4:
			return $Room4.position
		-3:
			return $Room2.position
		-2:
			return $Room8.position
		-1:
			return $Room6.position
		0:
			if rand_num == 0:
				return $Room1.position
			elif rand_num == 1:
				return $Room3.position
			elif rand_num == 2:
				return $Room5.position
			else:
				return $Room7.position
		1:
			return $Room5.position
		2:
			return $Room6.position
		3:
			return $Room7.position
		4:
			return $Room8.position
		5:
			return $Room1.position
		6:
			return $Room2.position
		7:
			return $Room3.position
		8:
			return $Room4.position
	return Vector3.ZERO

func time_to_string() -> String: # Creates a string to display the time left
	var s_count = int($GameTimer.time_left)
	@warning_ignore("integer_division")
	var minutes = s_count / 60
	s_count -= (minutes * 60)
	if s_count >= 10:
		return "%d : %d" % [minutes, s_count]
	else:return "%d : 0%d" % [minutes, s_count]

func set_clock_vis(vis): # Sets visibility of the clock, this is for interaction with the minigames
	if vis: # Ideally, the clock should disappear if and only if the player is interacting with the terminals
		$CenterContainer/Label.visible = true
	else:
		$CenterContainer/Label.visible = false

func _on_game_timer_timeout() -> void: # Transitions to victory screen
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/win_screen.tscn") 

func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	match difficulty:
		1:
			enemy_spawn(0)
			$DoorTimer.start()
		2:
			enemy_spawn(1)
			EventHandler.increase_difficulty.emit()
		3:
			EventHandler.increase_difficulty.emit()
		4:
			$TickTock.play()

func update_open_doors(id):
	open_doors.append(id)

func door_close_logic():
	var temp = open_doors.pick_random()
	open_doors.erase(temp)
	EventHandler.close_door.emit(temp)
	
func _on_door_timer_timeout() -> void: # Updates amount of doors that can be closed at once as difficulty increases
	door_close_logic()                 # TODO: Upgrate to something more sophisticated if there's time
	if difficulty > 1:
		if $DoorTimer2.is_stopped():
			await get_tree().create_timer(5).timeout
			print("door 2")
			$DoorTimer2.start()

func _on_door_timer_2_timeout() -> void:
	door_close_logic()
	if difficulty > 3:
		if $DoorTimer3.is_stopped():
			await get_tree().create_timer(5).timeout
			print("door 3")
			$DoorTimer3.start()

func _on_door_timer_3_timeout() -> void:
	door_close_logic()
