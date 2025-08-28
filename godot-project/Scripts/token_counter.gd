extends Node2D


@onready var label = $Label
@onready var anime = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	label.text = str(0)
	hide()


# Display counter with new count
func update_token_display(count):
	label.text = str(count)
	show()
	anime.play("show_counter")
	await get_tree().create_timer(1).timeout
	hide()
	
