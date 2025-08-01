extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = 350.0
@export var gravity: float = 800.0
@export var swim_force: float = 250.0
@export var swim_drag: float = 0.9

@onready var washing_machine_node = $"../WashingMachineBound"
@onready var ground = $"../ground"

var is_in_water: bool = false

func _physics_process(delta: float) -> void:
	if is_in_water:
		apply_swim_controls(delta)
	else:
		apply_ground_controls(delta)

	move_and_slide()

func apply_ground_controls(delta: float) -> void:
	var input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Get the washing machine's rotation velocity
	var rotation_speed = washing_machine_node.current_rotation_velocity
	# Convert to speed along the circle
	var rotation_drag = 0
	
	if $Area2D.overlaps_body(ground): rotation_drag = rotation_speed * 100
	# Player walks in circle; drum moves clockwise → drag = positive
	var player_force = input_dir * move_speed

	velocity.x = player_force - rotation_drag

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_force
	else:
		velocity.y += gravity * delta

#func apply_ground_controls(delta: float) -> void:
	#velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#velocity.x *= move_speed
#
	#if is_on_floor():
		#if Input.is_action_just_pressed("ui_accept"):  # space/jump
			#velocity.y = -jump_force
	#else:
		#velocity.y += gravity * delta

func apply_swim_controls(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity += input_vector * swim_force * delta
	velocity *= swim_drag  # add some floaty damping
	
	if !is_on_floor():
		velocity.y += gravity / 5 * delta

func enter_water():
	is_in_water = true
	velocity *= 0.8

func exit_water():
	is_in_water = false
	#velocity.y = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("obstacles"):
		area.queue_free()
