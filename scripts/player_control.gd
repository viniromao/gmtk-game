extends CharacterBody2D
@export var move_speed: float = 200.0
@export var jump_force: float = 350.0
@export var gravity: float = 800.0
@export var swim_force: float = 250.0
@export var swim_drag: float = 0.9
@export var aura_texture_q: Texture2D
@export var aura_texture_w: Texture2D
@export var aura_texture_e: Texture2D
@export var combo_scene: PackedScene
@export var current_aura: AuraTypes.Type = AuraTypes.Type.BLUE
@onready var washing_machine_node = $"../WashingMachineBound"
@onready var ground = $"../ground"
@onready var aura_sprite = $Aura
@onready var audio_combo_hit = $ComboHit
@onready var bad_hit = $BadHit
@onready var animated_sprite = $AnimatedSprite2D


var last_flip: bool = false
@export var MAX_COMBO_PITCH_AMOUNT: float = 7.0

var combo_amount: float = 4.0
var is_in_water: bool = false

func _ready():
	update_aura_sprite()

func _physics_process(delta: float) -> void:
	handle_aura_input()
	
	if velocity.x != 0.0:
		if velocity.x > 0.0:
			animated_sprite.flip_h = false
			last_flip = false
		elif velocity.x < 0.0:
			animated_sprite.flip_h = true
			last_flip = true
	else:
		animated_sprite.flip_h = last_flip
	
	if is_in_water:
		apply_swim_controls(delta)
	else:
		apply_ground_controls(delta)
	move_and_slide()

func handle_aura_input():
	if Input.is_key_pressed(KEY_Q):
		change_aura(AuraTypes.Type.BLUE)
	elif Input.is_key_pressed(KEY_W):
		change_aura(AuraTypes.Type.GREEN)
	elif Input.is_key_pressed(KEY_E):
		change_aura(AuraTypes.Type.RED)

func change_aura(new_aura: AuraTypes.Type):
	if current_aura != new_aura:
		current_aura = new_aura
		update_aura_sprite()

func update_aura_sprite():
	match current_aura:
		AuraTypes.Type.BLUE:
			if aura_texture_q:
				aura_sprite.texture = aura_texture_q
		AuraTypes.Type.GREEN:
			if aura_texture_w:
				aura_sprite.texture = aura_texture_w
		AuraTypes.Type.RED:
			if aura_texture_e:
				aura_sprite.texture = aura_texture_e

func spawn_floating_object():
	if combo_scene:
		var combo_instance = combo_scene.instantiate()
		self.add_child(combo_instance)

func get_aura_name() -> String:
	match current_aura:
		AuraTypes.Type.RED:
			return "red"
		AuraTypes.Type.BLUE:
			return "blue"
		AuraTypes.Type.GREEN:
			return "green"
		_:
			return "unknown"

func is_aura_active(aura_type: AuraTypes.Type) -> bool:
	return current_aura == aura_type

func apply_ground_controls(delta: float) -> void:
	var input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var rotation_speed = washing_machine_node.current_rotation_velocity
	var rotation_drag = 0
	
	if $Area2D.overlaps_body(ground): 
		rotation_drag = rotation_speed * 100
	
	var player_force = input_dir * move_speed
	velocity.x = player_force - rotation_drag
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force
	else:
		velocity.y += gravity * delta

func apply_swim_controls(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	velocity = input_vector * swim_force
	
	if !is_on_floor():
		velocity.y += gravity / 5 * delta

func enter_water():
	is_in_water = true

func exit_water():
	is_in_water = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		if area.cloth_type == current_aura:
			combo_amount += 1.0
			if combo_amount > MAX_COMBO_PITCH_AMOUNT:
				combo_amount = MAX_COMBO_PITCH_AMOUNT
			audio_combo_hit.pitch_scale = (combo_amount/4)
			audio_combo_hit.play()
		else: 
			bad_hit.play()
			combo_amount = 4
		
		area.queue_free()
		
