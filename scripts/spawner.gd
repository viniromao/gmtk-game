extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_delay: float = 1.0
@export var spawn_timer := 0.0 

@onready var washing_machine_bound = $"../WashingMachineBound"

func _ready():
	spawn()

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_delay:
		spawn_timer = 0.0
		spawn()
		
func spawn():
	if obstacle_scene == null or washing_machine_bound == null:
		print("obstacle or washing machine not set, obstacle <",obstacle_scene,"> washing_machine_bound <",washing_machine_bound,">")
		return

	washing_machine_bound.add_obstacle(obstacle_scene, Vector2(300,randf_range(0.0, 200.0)))
	
