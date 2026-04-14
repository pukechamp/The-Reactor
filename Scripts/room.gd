extends Node3D

@export var room_id: int        # Arrays contain matching directions and the rooms they connect to
@export var connected_dir: Array[String] = [] # ARRAYS MUST BE EQUAL IN SIZE
@export var connected_rooms: Array[int] = [] # AND CORRELATE TO EACH OTHER

# Called when the node enters the scene tree for the first time.
func _ready():
	EventHandler.room_open_door.connect(door_opens)
	EventHandler.room_close_door.connect(door_closes)
	EventHandler.wants_to_move.connect(is_moving_possible)
	EventHandler.request_new_location.connect(send_location)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func door_opens(id: int, id2:int, dir: String): # adds values back upon door opening
	if id == room_id:
		if not connected_rooms.has(id2):
			connected_rooms.append(id2)
			connected_dir.append(dir)

func door_closes(id: int, id2:int, _dir: String): # removes values upon door closing
	if id == room_id:
		var i = connected_rooms.find(id2)
		if i != -1:
			connected_rooms.remove_at(i)
			connected_dir.remove_at(i)
	
func is_moving_possible(id, dir): # Comminicates whether movement is possible, and if so where
	if id == room_id:
		for i in connected_rooms.size():
			if (dir == connected_dir[i]):
				EventHandler.can_move.emit(true, connected_rooms[i])
				return
		EventHandler.can_move.emit(false, -9)

func send_location(id): # Sends the desired room location to the player so they can move there
	if id == room_id:
		EventHandler.receive_new_location.emit(position.x, position.z)
