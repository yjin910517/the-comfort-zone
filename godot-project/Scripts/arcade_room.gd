extends Node2D

signal token_delivered(room_name)
signal wake_up(wakeup_reason)
signal completed_room(room_name)


var levels = {
	"easy": preload("res://Scenes/ArcadeEasyLevel.tscn"),
	"hard": preload("res://Scenes/ArcadeHardLevel.tscn"),
}

@onready var room_view = $RoomView
@onready var arcade_click = $RoomView/ClickDetect

@onready var menu_view = $MenuView
@onready var easy_btn = $MenuView/EasyButton
@onready var hard_btn = $MenuView/HardButton

@onready var easy_win = $EasyWin
@onready var continue_btn = $EasyWin/Continue
@onready var hard_win = $HardWin
@onready var secret_door = $HardWin/ClickDetect

var token_collected = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	arcade_click.connect("gui_input", Callable(self, "_on_arcade_gui_input"))
	easy_btn.connect("pressed", Callable(self, "_on_easy_btn_pressed"))
	hard_btn.connect("pressed", Callable(self, "_on_hard_btn_pressed"))
	
	continue_btn.connect("pressed", Callable(self, "_on_continue_btn_pressed"))
	secret_door.connect("gui_input", Callable(self, "_on_door_gui_input"))
	
	room_view.position = Vector2(0,0)
	menu_view.position = Vector2(0,0)
	easy_win.position = Vector2(0,0)
	hard_win.position = Vector2(0,0)
	
	room_view.show()
	
	menu_view.hide()
	easy_win.hide()
	hard_win.hide()
	
	# to do: add arcade bgm and basic sound effect
	
	
# zoom into screen
func _on_arcade_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		menu_view.show()


# start easy level
func _on_easy_btn_pressed():
	menu_view.hide()
	_start_new_level("easy")


# start hard level
func _on_hard_btn_pressed():
	menu_view.hide()
	_start_new_level("hard")


# create new levels
func _start_new_level(level_type):
	var new_level = levels[level_type].instantiate()
	add_child(new_level)
	
	if level_type == "easy":
		new_level.connect("level_ended", Callable(self, "_on_easy_level_ended"))
		
	if level_type == "hard":
		new_level.connect("level_ended", Callable(self, "_on_hard_level_ended"))
		
		var token = new_level.get_node("TileMapLayer/Token")
		if token_collected:
			token.hide()
		else:
			token.connect("token_collected", Callable(self, "_on_arcade_token_collected"))

	new_level.show()
	

# pass the token to main
func _on_arcade_token_collected(token_node):
	print("arcade pass through the token to main")
	token_collected = true
	emit_signal("token_delivered", "arcade_room")
	
	
# show win screen for easy
func _on_easy_level_ended(level_node):
	print("finished easy level")
	level_node.queue_free()
	easy_win.show()
	

# show win screen for hard
func _on_hard_level_ended(level_node):
	print("finished hard level")
	level_node.queue_free()
	hard_win.show()
	

# wake up signal to main
func _on_continue_btn_pressed():
	print("easy wake up")
	emit_signal("wake_up", "easy")
	easy_win.hide()


# proceed to next room
func _on_door_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("proceed to next room")
		emit_signal("completed_room", "arcade_room")
		hard_win.hide()
