extends Area2D

signal level_completed()

@onready var audio = $AudioStreamPlayer2D


func _ready() -> void:
	
	self.connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body: Node) -> void:
		
	# Only react to the player
	if body is CharacterBody2D:
		
		# audio.play()
		emit_signal("level_completed")
