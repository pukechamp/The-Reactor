extends Control

# Simple win screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fade_in = create_tween()
	fade_in.tween_property($Music, "volume_db", -5, 15).set_trans(Tween.TRANS_LINEAR)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
