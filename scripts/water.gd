extends Area2D

@export var default_water_pos: float
@export var spray_speed: float = 1
@export var drain_speed: float = 1
@export var max_water_level: float = 10

@onready var spray = $"../spray"
@onready var timer = $CycleTimer
@onready var washing_machine_node = $"../WashingMachineBound"

var water_level: float = 0

#0: default; 1: spraying; 2: draining
var status: int = 2

func _process(_delta):
	match status:
		1:
			washing_machine_node.paused = false
			spray.emitting = true
			water_level += _delta * spray_speed
			if water_level >= max_water_level:
				status = 0
				spray.emitting = false
				timer.start()
		2:
			water_level -= _delta * drain_speed
			if water_level <= 0:
				water_level = 0
				status = 0
				timer.start()
				washing_machine_node.paused = true
				
			
	position.y = default_water_pos - water_level * 30

func _on_body_entered(body):
	if body.name == "player":
		body.enter_water()


func _on_body_exited(body):
	if body.name == "player":
		body.exit_water()

func _on_cycle_timer_timeout():
	# Decide next action based on current water level
	if water_level <= 0:
		status = 1  # start spraying
	elif water_level >= max_water_level:
		status = 2  # start draining
