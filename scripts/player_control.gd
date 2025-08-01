extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = 350.0
@export var gravity: float = 800.0
@export var swim_force: float = 250.0
@export var swim_drag: float = 0.9

var is_in_water: bool = false

func _physics_process(delta: float) -> void:
	if is_in_water:
		apply_swim_controls(delta)
	else:
		apply_ground_controls(delta)

	move_and_slide()

func apply_ground_controls(delta: float) -> void:
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x *= move_speed

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):  # space/jump
			velocity.y = -jump_force
	else:
		velocity.y += gravity * delta

func apply_swim_controls(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity += input_vector * swim_force * delta
	velocity *= swim_drag  # add some floaty damping

func enter_water():
	is_in_water = true
	velocity *= 0.7 

func exit_water():
	is_in_water = false
	velocity.y = 0  


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("obstacles"):
		area.queue_free()
