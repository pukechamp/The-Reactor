extends Node

# Constantly runs in the background and allows signals to be sent and received across different scenes

# Updates the arrays on their adjecent rooms
signal room_close_door(id: int, t_id:int, dir: String) 
signal room_open_door(id: int, t_id:int, dir: String)

# Updates both the actual doors and their icons on the minimap
signal close_door(door_id: int)
signal open_door(door_id: int)

# Informs the player's current room on what direction the player is facing
signal wants_to_move(id: int, dir: String) 
# The room responds whether or not it's possible, and the desired room id
signal can_move(y_n: bool, n_id: int) 

# For the player to request the location of a new room and receive it
signal request_new_location(id: int)
signal receive_new_location(n_x: float, n_z: float) # How enemies receive the location of the player

#Allows the minigames to become functional
signal boot_minigame(id)
# Player sends their current room and direction for the minigame to validate their input
signal minigame_input(id)
# Check if the minigame ui should show up when looking at new direction
signal check_minigame_ui (id, dir)

signal hide_or_show_clock(show)

# Sends signal to terminal rooms to update lights and sfx (0 for green, 1 yellow and 2 red)
signal update_lights(id, mode) 

signal turn_on_screen(id)  # For terminal rooms
signal turn_off_screen(id)

signal got_ammo() # Signal to add to the player's ammo counter

signal stationary_enemy_spawn() # For a cut enemy type
signal destroyed(enemy) # For the main to handle enemy deaths/respawns, another cut feature
signal update_enemy_rotation(angle) # For the enemy to always face the player

signal increase_difficulty() # Self-explanatory, for each individual object to handle as required

signal game_over() # Self-explanatory
