extends Node2D

@onready var title_page = $TitlePage
@onready var bgm = $BGM

@onready var spawn_room = $SpawnRoom
@onready var cliff_room = $CliffRoom
@onready var painting_room = $PaintingRoom
@onready var arcade_room = $ArcadeRoom
@onready var door_room = $DoorRoom
@onready var locker_room = $LockerRoom
@onready var finale_room = $FinaleScene

@onready var counter = $TokenCounter
@onready var wakeup_scene = $WakeUp

@onready var node_mapping = {
	"spawn_room": spawn_room,
	"cliff_room": cliff_room,
	"painting_room": painting_room,
	"arcade_room": arcade_room,
	"door_room": door_room,
	"locker_room": locker_room,
	"finale_room": finale_room
}

# token variables
var token_count = 0
var token_collection = {
	"spawn_room": 0,
	"cliff_room": 0,
	"painting_room": 0,
	"arcade_room": 0,
	"door_room": 0,
	"locker_room": 0,
	"finale_room": 0
}

# wake up variables
var has_woke_up = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_page.connect("go_to_room", Callable(self, "_on_room_changed"))
	title_page.connect("start_bgm", Callable(self, "_on_start_bgm"))
	
	spawn_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	spawn_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	
	cliff_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	cliff_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	cliff_room.connect("wake_up", Callable(self, "_on_wake_up"))

	painting_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	painting_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	
	arcade_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	arcade_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	arcade_room.connect("wake_up", Callable(self, "_on_wake_up"))
	
	door_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	door_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	door_room.connect("wake_up", Callable(self, "_on_wake_up"))
	door_room.connect("final_lock_check", Callable(self, "_on_final_lock_check"))

	locker_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	locker_room.connect("go_to_room", Callable(self, "_on_room_changed"))
	locker_room.connect("wake_up", Callable(self, "_on_wake_up"))
	locker_room.connect("final_lock_check", Callable(self, "_on_final_lock_check"))
	
	finale_room.connect("token_delivered", Callable(self, "_on_token_delivered"))
	
	wakeup_scene.connect("sleep_again", Callable(self, "_on_sleep_again"))

	title_page.position = Vector2(0,0)
	spawn_room.position = Vector2(0,0)
	cliff_room.position = Vector2(0,0)
	painting_room.position = Vector2(0,0)
	arcade_room.position = Vector2(0,0)
	door_room.position = Vector2(0,0)
	locker_room.position = Vector2(0,0)
	finale_room.position = Vector2(0,0)
	wakeup_scene.position = Vector2(0,0)
	
	title_page.show()
	spawn_room.hide()
	cliff_room.hide()
	painting_room.hide()
	arcade_room.hide()
	door_room.hide()
	locker_room.hide()
	finale_room.hide()
	wakeup_scene.hide()
	
	# randomize once for the whole game session
	randomize()
	

func _on_start_bgm():
	bgm.play()
	
	
func _on_token_delivered(room_name):
	token_collection[room_name] += 1
	token_count += 1
	
	# skip GUD counter display for the finale collection
	if room_name != "finale_room":
		counter.update_token_display(token_count)
	
	# call wakeup by finale token
	if room_name == "finale_room":
		_on_wake_up("finale")
	
	
func _on_room_changed(destination):
	var new_room = node_mapping[destination]
	
	if destination == "finale_room":
		# unlock both entries
		door_room.get_node("FinalRoom").is_locked = false
		locker_room.get_node("FinalRoom").is_locked = false
		# start the finale scene
		new_room.start_finale_scene()
	
	new_room.show()


func _on_wake_up(reason):

	if has_woke_up == false:
		has_woke_up = true
		spawn_room.update_spawn_view()
	
	var wakeup_data = {
		"count": token_count,
		"reason": reason
	}
	
	wakeup_scene.show_wakeup_scene(wakeup_data)
	

func _on_sleep_again():
	spawn_room.start_room()
	spawn_room.show()


func _on_final_lock_check(room_node):
	# send current token count to room for lock check
	room_node.attempt_to_unlock(token_count)
	# display current token count
	counter.update_token_display(token_count)
