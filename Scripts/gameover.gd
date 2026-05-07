extends Control

# Simple game over screen, has the option for a player to restart 

# var game_scene = preload("res://Scenes/main.tscn")
var cause_of_death = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cause_of_death = Data.cause_of_death
	match cause_of_death:
		0:
			pass
		1:
			pass
		2: 
			pass
	match (randi_range(0, 6)):
		0:
			$Tip.text = "Keep an ear out for footsteps, you're never as safe as you think."
		1:
			$Tip.text = "You can turn away from the terminals if things get risky, don't get cocky."
		2:
			$Tip.text = "The small one doesn't like the terminals, the lights hurt its eyes."
		3:
			$Tip.text = "The small one doesn't care about you, you're just in its way."
		4:
			$Tip.text = "You don't need to completely fix the terminals, but doing so might make things easier."
		5: 
			$Tip.text = "Always look before you move, you never know what lies in the dark."
		6: 
			$Tip.text = "Remember what you came here to do, don't let those terminals break."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_restart_pressed() -> void: # Restarts the game
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit() # Closes the game
