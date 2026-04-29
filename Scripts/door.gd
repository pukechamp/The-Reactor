extends Node3D

@export var door_id: int                     # Matching arrays for each connected rooms and their respective directions
@export var connected_rooms: Array[int] = [] # BOTH ARRAYS MUST BE EQUAL IN SIZE
@export var connected_dir: Array[String] = [] # AND EACH ELEMENT MATCHING
@onready var nav_region = get_tree().get_first_node_in_group("level")

var is_open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	EventHandler.open_door.connect(open_door)
	EventHandler.close_door.connect(close_door)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Both opening and closing the doors sends signals to the rooms to have them remove possible directions and rooms from their arrays to prevent movement through closed paths
func open_door(id):
	if id == door_id && !is_open:
		is_open = true
		EventHandler.room_open_door.emit(connected_rooms[0], connected_rooms[1], connected_dir[0])
		EventHandler.room_open_door.emit(connected_rooms[1], connected_rooms[0], connected_dir[1])
		$front_light.texture = load("res://trenchbroom/textures/doorlight_open.png")
		$back_light.texture = load("res://trenchbroom/textures/doorlight_open.png")
		$doorlight_f.light_color = Color(0.0, 1.0, 0.0, 1.0)
		$doorlight_b.light_color = Color(0.0, 1.0, 0.0, 1.0)
		$AudioStreamPlayer3D.stream = load("res://Sfx/freesound_community-large-metal-lift-door-openingwav-14459.mp3")
		$AudioStreamPlayer3D.play()
		var open = create_tween()
		open.tween_property($door_t, "position:y", 14.2, .75)
		
		await open.finished
		if nav_region.is_baking():
			await get_tree().create_timer(0.1).timeout # To avoid further errors whenm rebaking the mesh TODO: fix it so it works entirely
		nav_region.bake_navigation_mesh()

func close_door(id):
	if id == door_id && is_open:
		is_open = false
		$ReopenTimer.start()
		EventHandler.room_close_door.emit(connected_rooms[0], connected_rooms[1], connected_dir[0])
		EventHandler.room_close_door.emit(connected_rooms[1], connected_rooms[0], connected_dir[1])
		$front_light.texture = load("res://trenchbroom/textures/doorlight_closed.png")
		$back_light.texture = load("res://trenchbroom/textures/doorlight_closed.png")
		$doorlight_f.light_color = Color(1.0, 0.0, 0.0, 1.0)
		$doorlight_b.light_color = Color(1.0, 0.0, 0.0, 1.0)
		$AudioStreamPlayer3D.stream = load("res://Sfx/freesound_community-locker-slam-2-101487.mp3")
		$AudioStreamPlayer3D.play()
		var close = create_tween()
		close.tween_property($door_t, "position:y", 5.4, .75)
		await close.finished
		if nav_region.is_baking():
			await get_tree().create_timer(0.1).timeout
		nav_region.bake_navigation_mesh()

func _on_reopen_timer_timeout() -> void:
	EventHandler.open_door.emit(door_id) # Every door automatically reopens after 12 seconds
