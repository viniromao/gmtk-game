extends Node2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var cloth_type: AuraTypes.Type = AuraTypes.Type.BLUE

var cloth_textures: Array[Dictionary] = [
	{"path": "res://textures/cloth_blue.png", "aura": AuraTypes.Type.BLUE},
	{"path": "res://textures/cloth_green.png", "aura": AuraTypes.Type.GREEN},
	{"path": "res://textures/cloth_red.png", "aura": AuraTypes.Type.RED}
]

@export var target_size: Vector2 = Vector2(2, 2)
var state: int = 0

func _ready():
	set_random_cloth_sprite()

func set_random_cloth_sprite():
	var random_index = randi() % cloth_textures.size()
	var texture_path = cloth_textures[random_index]["path"]
	cloth_type = cloth_textures[random_index]["aura"]
	var texture = load(texture_path)
	sprite.texture = texture
	
	normalize_sprite_size()

func normalize_sprite_size():
	if sprite.texture == null:
		return
	
	var original_size = sprite.texture.get_size()
	
	var scale_factor = Vector2(
		target_size.x / original_size.x,
		target_size.y / original_size.y
	)
	
	sprite.scale = scale_factor
	update_collision_shape()

func update_collision_shape():
	if collision_shape == null or sprite.texture == null:
		return
	
	var sprite_size = sprite.texture.get_size() * sprite.scale
	collision_shape.rotation = 0
	
	if collision_shape.shape is RectangleShape2D:
		var rect_shape = collision_shape.shape as RectangleShape2D
		rect_shape.size = sprite_size
	elif collision_shape.shape is CircleShape2D:
		var circle_shape = collision_shape.shape as CircleShape2D
		circle_shape.radius = min(sprite_size.x, sprite_size.y) / 2.0
	elif collision_shape.shape is CapsuleShape2D:
		var capsule_shape = collision_shape.shape as CapsuleShape2D
		capsule_shape.radius = min(sprite_size.x, sprite_size.y) / 2.0
		capsule_shape.height = max(sprite_size.x, sprite_size.y)

func normalize_sprite_size_keep_aspect():
	if sprite.texture == null:
		return
	
	var original_size = sprite.texture.get_size()
	
	var scale_factor = min(
		target_size.x / original_size.x,
		target_size.y / original_size.y
	)
	
	sprite.scale = Vector2(scale_factor, scale_factor)
	update_collision_shape()
