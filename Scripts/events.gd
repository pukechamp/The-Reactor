extends Node

# Constantly runs in the background and allows signals to be sent and received across different scenes

# Updates the arrays on their adjecent rooms
@warning_ignore("unused_signal")
signal room_close_door(id: int, t_id:int, dir: String) 
@warning_ignore("unused_signal")
signal room_open_door(id: int, t_id:int, dir: String)

# Updates both the actual doors and their icons on the minimap
@warning_ignore("unused_signal")
signal close_door(door_id: int)
@warning_ignore("unused_signal")
signal open_door(door_id: int)

# Informs the player's current room on what direction the player is facing
@warning_ignore("unused_signal")
signal wants_to_move(id: int, dir: String) 
# The room responds whether or not it's possible, and the desired room id
@warning_ignore("unused_signal")
signal can_move(y_n: bool, n_id: int) 

# For the player to request the location of a new room and receive it
@warning_ignore("unused_signal")
signal request_new_location(id: int)
@warning_ignore("unused_signal")
signal receive_new_location(n_x: float, n_z: float) # How enemies receive the location of the player

#Allows the minigames to become functional
@warning_ignore("unused_signal")
signal boot_minigame(id)
# Player sends their current room and direction for the minigame to validate their input
@warning_ignore("unused_signal")
signal minigame_input(id)
# Check if the minigame ui should show up when looking at new direction
@warning_ignore("unused_signal")
signal check_minigame_ui (id, dir)

@warning_ignore("unused_signal")
signal hide_or_show_clock(show)

# Sends signal to terminal rooms to update lights and sfx (0 for green, 1 yellow and 2 red)
@warning_ignore("unused_signal")
signal update_lights(id, mode) 

@warning_ignore("unused_signal")
signal turn_on_screen(id)  # For terminal rooms
@warning_ignore("unused_signal")
signal turn_off_screen(id)

@warning_ignore("unused_signal")
signal got_ammo() # Signal to add to the player's ammo counter

@warning_ignore("unused_signal")
signal stationary_enemy_spawn() # For a cut enemy type
@warning_ignore("unused_signal")
signal destroyed(enemy) # For the main to handle enemy deaths/respawns, another cut feature
@warning_ignore("unused_signal")
signal update_enemy_rotation(angle) # For the enemy to always face the player

@warning_ignore("unused_signal")
signal increase_difficulty() # Self-explanatory, for each individual object to handle as required

@warning_ignore("unused_signal")
signal game_over(cod) # Self-explanatory
