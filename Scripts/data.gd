extends Node

var cause_of_death = null
var beat_game = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHandler.game_over.connect(update_cause_of_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_cause_of_death(cod):
	cause_of_death = cod
