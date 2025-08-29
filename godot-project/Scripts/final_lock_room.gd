extends Node2D

signal lock_request()
signal unlocked()

@onready var nav = $NavBack
@onready var lock = $LockIcon
@onready var lock_click = $LockIcon/ClickDetect
@onready var bg = $Background

var is_locked = true

const LOCK_COST = 7


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_click.connect("gui_input", Callable(self, "_on_lock_gui_input"))


func _on_lock_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("lock_request")
		
		
func start_room():
	if is_locked:
		lock.hide()
		nav.hide()
		bg.play("final_room_locked")
		await get_tree().create_timer(1).timeout
		lock.show()
		nav.show()
	else:
		bg.play("final_room_unlocked")
		lock.hide()
		
		
func lock_check(token_count):
	
	if token_count >= LOCK_COST:
		is_locked = false
		
		# freeze action and play cut scene
		nav.hide()
		lock_click.hide()
		lock.play("unlock_success")
		await get_tree().create_timer(1.2).timeout
		
		# clean up current scene and emit signal
		nav.show()
		emit_signal("unlocked")
		hide()
		 
	else:
		lock.play("unlock_fail")
		await get_tree().create_timer(1.5).timeout
		lock.play("default")
