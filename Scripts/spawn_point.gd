extends Node3D

var occupied
var ammo_ready

# SCRIPT CURRENTLY DOES NOTHING, it would've been integral to a cut shooting 
# mechanic as well as a third enemy type
# It would've also been integral to a minimap that I had to cut for now

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	occupied = false
	ammo_ready = false
	EventHandler.stationary_enemy_spawn.connect(enemy_spawn)
	$AmmoTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Ammo.rotation.y += (delta * 2)

func enemy_spawn():
	pass

func _on_ammo_timer_timeout() -> void:
	pass # Replace with function body.
