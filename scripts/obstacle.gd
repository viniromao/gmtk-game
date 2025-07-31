extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var cloth_textures: Array[String] = [
	"res://textures/cloth_1.webp",
	"res://textures/cloth_2.png",
	"res://textures/cloth_3.png"
]

@export var target_size: Vector2 = Vector2(2, 2)

#whether to blur or not
var state: int = 0

func _ready():
	set_random_cloth_sprite()

func set_random_cloth_sprite():
	var random_index = randi() % cloth_textures.size()
	var texture_path = cloth_textures[random_index]
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

func normalize_sprite_size_keep_aspect():
	if sprite.texture == null:
		return
	
	var original_size = sprite.texture.get_size()
