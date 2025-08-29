extends Node2D


signal token_delivered(room_name)
signal go_to_room(destination_name)
signal wake_up(wakeup_reason)

@export var room_name: String

@onready var audio = $AudioStreamPlayer2D

@onready var room_view = $RoomView
@onready var room_click = $RoomView/ClickDetect
@onready var poster_icon = $RoomView/PosterIcon
@onready var room_nav = $RoomView/Nav

@onready var poster_view = $PosterView
@onready var poster_click = $PosterView/ClickDetect

@onready var sign_view = $SignView
@onready var sign_yes = $SignView/YesButton
@onready var sign_no = $SignView/NoButton

@onready var flipping_view = $FlippingView
@onready var flip_icon = $FlippingView/FlipIcon
@onready var flip_text = $FlippingView/FlipText


var token_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	room_nav.connect("pressed", Callable(self, "_on_room_nav"))
	
	room_click.connect("gui_input", Callable(self, "_on_room_gui_input"))
	poster_click.connect("gui_input", Callable(self, "_on_poster_gui_input"))
	
	sign_yes.connect("pressed", Callable(self, "_on_yes_btn_pressed"))
	sign_no.connect("pressed", Callable(self, "_on_no_btn_pressed"))
	
	room_view.position = Vector2(0,0)
	poster_view.position = Vector2(0,0)
	sign_view.position = Vector2(0,0)
	flipping_view.position = Vector2(0,0)
	
	room_view.show()
	poster_view.hide()
	sign_view.hide()
	flipping_view.hide()


func _on_room_nav():
	emit_signal("go_to_room", room_nav.destination)
	hide()
	
	
func _on_room_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		poster_view.show()
		

func _on_poster_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		poster_view.hide()
		sign_view.show()


func _on_yes_btn_pressed():
	sign_view.hide()
	flipping_view.show()
	flip_text.hide()
	
	# start timer and run animations
	flip_icon.speed_scale = 1
	flip_icon.play("flip")
	await get_tree().create_timer(2).timeout

	# speed up animation
	flip_icon.speed_scale = 2
	flip_icon.play("flip")
	await get_tree().create_timer(1).timeout

	# stop and choose result
	flip_icon.stop()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result_frame = rng.randi_range(0, 1)
	flip_icon.frame = result_frame
	flip_text.frame = result_frame
	flip_text.show()
	
	# if sucess, play sound and update room display
	if result_frame == 0:
		audio.play()
		room_click.queue_free()
		poster_icon.frame = 1
		
	await get_tree().create_timer(2).timeout
	
	# if success, emit token collected signal
	if result_frame == 0:
		emit_signal("token_delivered", "cliff_room")
		flipping_view.hide()
	
	# if fail, reset the room and do nothing
	if result_frame == 1:
		emit_signal("wake_up", "fall")
		flipping_view.hide()
		hide()


func _on_no_btn_pressed():
	sign_view.hide()
