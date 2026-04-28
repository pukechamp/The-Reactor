extends Control

# Simple start screen, contains a simple paragraph explaining the story of the game
# TODO: Make credits button that changes the text in the story_text node in order to match it, and then turns it back

# var game_scene = preload("res://Scenes/main.tscn")
var clickable = true

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fade_in = create_tween()
	fade_in.tween_property($Music, "volume_db", -10, 12).set_trans(Tween.TRANS_LINEAR)
	$story_text.hide()
	$BackToMenu.hide()
	if Input.is_action_pressed("move_forward"):
		pass
	if Input.is_action_pressed("scroll_down"):
		pass
	if Input.is_action_pressed("interact"):
		pass
	if InputEventMouseMotion:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	if clickable == true:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_pressed() -> void:
	if clickable == true:
		get_tree().quit()

func _on_story_pressed() -> void:
	if clickable == true:
		$VBoxContainer.z_index = -3
		$VBoxContainer/Start.hide()
		$VBoxContainer/Story.hide()
		$VBoxContainer/Credits.hide()
		$VBoxContainer/Quit.hide()
		$story_text.show()
		$BackToMenu.show()
		clickable = false

func _on_back_to_menu_pressed() -> void: # Only pressable while on the story screen
	if clickable == false:
		$VBoxContainer.z_index = 0
		$VBoxContainer/Start.show()
		$VBoxContainer/Story.show()
		$VBoxContainer/Credits.show()
		$VBoxContainer/Quit.show()
		$story_text.hide()
		$BackToMenu.hide()
		$story_text.text = "Kostromvik Union, 198X

After decades, a long abandoned nuclear reactor in a secluded region of the city of Krivichesk has mysteriously shown signs of activity. City records show no entry in or out of the region, or nothing else that would explain it, fueling decades-long whispers of strange happenings in the area. In a matter of three days, activity has grown exponentially and all signs indicate the unmanned reactor is rapidly approaching a meltdown. 

You have been tasked with going into the reactor and pushing the implosion back for long enough to conduct a safe evacuation. 
"
		clickable = true

func _on_credits_pressed() -> void:
	if clickable == true:
		$story_text.text = "Game by Angel Zayas

Thanks to my beautiful girlfiend for helping me playtest this game and pushing me to make it in the first place.

[left]Contains modified textures from 3djungle.net.

All music and sound effects from pixabay.com

\"190501 - Dark / Industrial / Ambient / Mechanical / Electronica\" by WELC0MEИ0
https://pixabay.com/music/electronic-190501-dark-industrial-ambient-mechanical-electronica-155502/

\"220626 - Glitch / Dark / Industrial / IDM / Electronica / SF\" by WELC0MEИ0
https://pixabay.com/music/upbeat-220626-glitch-dark-industrial-idm-electronica-sf-155641/[/left]"
		_on_story_pressed()
