extends Area2D

@export var rotation_velocity: float = 1.0

var obstacles: Array[Node] = []
var obstacle_sprites: Array[Node2D] = []

func _process(delta: float) -> void:
	rotation += rotation_velocity * delta
	
	for sprite in obstacle_sprites:
		if is_instance_valid(sprite):
			sprite.rotation = -rotation
	
	check_and_destroy_obstacles()

func add_obstacle(obstacle: PackedScene, world_pos: Vector2):
	var instance = obstacle.instantiate()
	add_child(instance)
	instance.global_position = world_pos
	
	obstacles.append(instance)
	
	find_and_store_sprites(instance)

func find_and_store_sprites(node: Node):
	if node is Sprite2D or node is AnimatedSprite2D:
		obstacle_sprites.append(node)
	
	for child in node.get_children():
		find_and_store_sprites(child)

func check_and_destroy_obstacles():
	for i in range(obstacles.size() - 1, -1, -1):
		var obstacle = obstacles[i]
		
		if is_instance_valid(obstacle):
			var pos = obstacle.global_position
			
			if pos.y < 280 and pos.x < 280:
				remove_obstacle_sprites(obstacle)
				
				obstacles.remove_at(i)
				obstacle.queue_free()

func remove_obstacle_sprites(obstacle_node: Node):
	for i in range(obstacle_sprites.size() - 1, -1, -1):
		var sprite = obstacle_sprites[i]
		if is_instance_valid(sprite) and is_ancestor_of_obstacle(sprite, obstacle_node):
			obstacle_sprites.remove_at(i)

func is_ancestor_of_obstacle(sprite: Node, obstacle: Node) -> bool:
	var current = sprite
	while current != null:
		if current == obstacle:
			return true
		current = current.get_parent()
	return false
