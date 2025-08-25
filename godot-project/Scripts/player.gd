extends CharacterBody2D


const SPEED = 100.0


func _physics_process(delta: float) -> void:

	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()  # This will stop on wall tiles (because of their collision shapes)
