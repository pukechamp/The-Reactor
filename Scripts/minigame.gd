extends Control

@export var minigame_id: int
@export var screen_dir: String

var bar_current
var bar_max = 100
var decrease = 3
var increase = 12
var restart_offset = 0 # This is here in care I wanted to add smaller cooldowns later into the game, for now this remains unused
var input_valid
var m_running = false # Whether the game is running

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProgressBar.max_value = bar_max
	visible = false
	input_valid = false
	bar_current = bar_max
	EventHandler.increase_difficulty.connect(add_difficulty)
	EventHandler.minigame_input.connect(increment)
	EventHandler.check_minigame_ui.connect(show_or_hide)
	EventHandler.boot_minigame.connect(launch)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$ProgressBar.value = bar_current
	
	if bar_current <= 0:
		EventHandler.game_over.emit()
	if $RestartTimer.is_stopped() && m_running:
		bar_current -= delta * decrease
		if (bar_current > 60):
			EventHandler.update_lights.emit(minigame_id, 0)
		elif (bar_current <= 60 && bar_current > 30):
			EventHandler.update_lights.emit(minigame_id, 1)
		else:
			EventHandler.update_lights.emit(minigame_id, 2)

func launch(id): # Boots up the minigame for the first time, after this it can run on its own
	if id == minigame_id:
		m_running = true
		start()

func start(): # Resets the bar whenever the game restarts
	bar_current = bar_max
	EventHandler.turn_on_screen.emit(minigame_id)

func increment(id): # Player interaction, also checks for the winning condition
	if $RestartTimer.is_stopped():
		if id == minigame_id && input_valid && m_running:
			bar_current += increase
			$Press.play()
			if bar_current > bar_max:
				input_valid = false
				$RestartTimer.start(restart_offset)
				$VictoryJingle.play()
				await get_tree().create_timer(1.5).timeout
				visible = false
				EventHandler.turn_off_screen.emit(minigame_id)
				EventHandler.hide_or_show_clock.emit(true)
	
func show_or_hide(id, dir): # Shows or hides the UI, dependent on whether the player faces the screen
	if $RestartTimer.is_stopped():
		if minigame_id == id && m_running:
			if is_looking_at_screen(dir):
				input_valid = true
				visible = true
				EventHandler.hide_or_show_clock.emit(false)
			else:
				input_valid = false
				visible = false
				EventHandler.hide_or_show_clock.emit(true)
	
func is_looking_at_screen(dir): # Self-explanatory
	if screen_dir == dir:
		return true
	else:
		return false

func _on_restart_timer_timeout(): # Restarts the minigame upon a cooldown
	start()

func add_difficulty(): # Triggered whenever the main has a game-wide diff increase 
	decrease += 1
	increase -= 2
