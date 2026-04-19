extends Node

# Both lightbulb scenes are near identical, with minor differences in size and brightness
# This is the hallway variant, it's smaller and not as bright

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ((randi()%200) == 0):
		if $lighttimer.is_stopped():
			_lightsflicker()

func _lightsflicker():
	$lighttimer.start()
	$SpotLight3D.light_energy = .1
	$OmniLight3D.light_energy = .04
	var fanim1 = create_tween()
	var fanim2 = create_tween()
	fanim1.tween_property($SpotLight3D, "light_energy", .2, .5)
	fanim2.tween_property($OmniLight3D, "light_energy", .12, .5)
	if $soundtimer.is_stopped():
		$soundtimer.start()
		$flickersfx.play()
