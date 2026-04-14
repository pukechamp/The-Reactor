extends Control

# var game_scene = preload("res://Scenes/main.tscn")
var clickable = true

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$story_text.hide()
	$BackToMenu.hide()


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
		$Start.hide()
		$Story.hide()
		$Quit.hide()
		$story_text.show()
		$BackToMenu.show()
		clickable = false

func _on_back_to_menu_pressed() -> void:
	if clickable == false:
		$Start.show()
		$Story.show()
		$Quit.show()
		$story_text.hide()
		$BackToMenu.hide()
		clickable = true
