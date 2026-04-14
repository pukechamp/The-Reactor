extends Node3D

@export var fx_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHandler.update_lights.connect(change_colors)
	EventHandler.turn_off_screen.connect(turn_off)
	EventHandler.turn_on_screen.connect(turn_on)
	visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if $flickertimer.is_stopped():
		flicker()
	
func flicker():
	$flickertimer.start()
	$OmniLight3D.light_energy = .6
	$OmniLight3D.omni_range = 20
	var f = create_tween()
	f.tween_property($OmniLight3D, "light_energy", .8, .10)
	f.parallel().tween_property($OmniLight3D, "omni_range", 30.0, .10)

func turn_off(id):
	if fx_id == id:
		await get_tree().create_timer(2).timeout
		visible = false
		$flickertimer.paused = true
		$AudioStreamPlayer3D.stream_paused = true
		$Alarm.stop()

func turn_on(id):
	if fx_id == id:
		if !$AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play()
		visible = true
		$flickertimer.paused = false
		$AudioStreamPlayer3D.stream_paused = false

func change_colors(id, color):
	if fx_id == id:
		match color:
			0:
				$Alarm.stop()
				$Screen.texture = load("res://trenchbroom/textures/warning.png")
				$OmniLight3D.light_color = Color.GREEN
			1:
				$Alarm.stop()
				$Screen.texture = load("res://trenchbroom/textures/hazard.png")
				$OmniLight3D.light_color = Color.YELLOW
			2:
				if not $Alarm.playing:
					$Alarm.play()
				$Screen.texture = load("res://trenchbroom/textures/emergency.png")
				$OmniLight3D.light_color = Color.RED
