extends Node3D

@export var current_room: int
@export var current_dir: String
var ammo_counter # Part of unimplemented shooting mechanic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo_counter = 0
	EventHandler.can_move.connect(move_check)
	EventHandler.receive_new_location.connect(move)
	EventHandler.got_ammo.connect(add_ammo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("turn_right"):
		_turn(-PI/2)
	if Input.is_action_just_pressed("turn_left"):
		_turn(PI/2)
	if Input.is_action_just_pressed("move_forward"):
		if $actiontimer.is_stopped():
			EventHandler.wants_to_move.emit(current_room, current_dir)
	if Input.is_action_just_pressed("interact") && current_room < 0:
		EventHandler.minigame_input.emit(current_room)	
	EventHandler.update_enemy_rotation.emit(rotation.y)

func _turn(_angle: float): # Uses tweens for a pseudo animation for the individual turns, the player can't do anything mid-turn by design
	if $actiontimer.is_stopped():
		$actiontimer.start()
		if _angle > 0:
			_changedir(0)
		else:
			_changedir(1)
		var a_offset = Quaternion(Vector3.UP, _angle)
		var t_dir = self.quaternion * a_offset
		var rt = create_tween()
		rt.tween_property(self, "quaternion", t_dir, .4).set_trans(Tween.TRANS_LINEAR)
		await rt.finished

func _changedir(_t: int): # 0 for left, 1 for right, updates the direction the player is currently facing
	match current_dir:
		"north":
			if _t == 0:
				current_dir = "west"
			else: 
				current_dir = "east"
		"east":
			if _t == 0:
				current_dir = "north"
			else: 
				current_dir = "south"
		"south":
			if _t == 0:
				current_dir = "east"
			else: 
				current_dir = "west"
		"west":
			if _t == 0:
				current_dir = "south"
			else: 
				current_dir = "north"
	if current_room < 0:
		EventHandler.check_minigame_ui.emit(current_room, current_dir) # Checks whether or not the player is facing an active terminal screen

func move_check(can: bool, n_room: int): # Confirms whether or not a player is allowed to move to a specific room
	if $actiontimer.is_stopped():
		if can == true:
			current_room = n_room
			EventHandler.request_new_location.emit(n_room)
		else:
			$ErrorSound.play()
			$actiontimer.start(.3)

func move(n_x: float, n_z: float): # Uses tweens to animate movement
	if $actiontimer.is_stopped():
		$actiontimer.start()
		$Footstep.play()
		var movement = create_tween()
		movement.set_parallel(true)
		movement.tween_property(self, "position:x", n_x, .45)
		movement.tween_property(self, "position:z", n_z, .45)
		if current_room < 0:
			await movement.finished
			EventHandler.check_minigame_ui.emit(current_room, current_dir)

func add_ammo(): # For the unused shooting mechanic
	ammo_counter += 1 # The player would've been able to ocasionally pick bullets across the map to either shoot enemies and remove them from the level for around 15 seconds or shoot a closed-door open
