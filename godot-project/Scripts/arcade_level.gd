extends Node2D

signal level_ended(level_node)

@onready var finish = $TileMapLayer/Finish


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finish.connect("level_completed", Callable(self, "_on_level_completed"))
	
	
func _on_level_completed():
	emit_signal("level_ended", self)
