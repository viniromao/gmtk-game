extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var drag_speed: float = 1.0
@export var initial_zoom: Vector2 = Vector2(1.0, 1.0)

var is_dragging: bool = false
var drag_start_position: Vector2
var camera_start_position: Vector2

func _ready():
	zoom = initial_zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				start_drag(event.position)
			else:
				stop_drag()
	
	elif event is InputEventMouseMotion and is_dragging:
		update_drag(event.position)

func start_drag(mouse_pos: Vector2):
	is_dragging = true
	drag_start_position = mouse_pos
	camera_start_position = global_position

func stop_drag():
	is_dragging = false

func update_drag(mouse_pos: Vector2):
	var drag_delta = (drag_start_position - mouse_pos) * drag_speed / zoom.x
	global_position = camera_start_position + drag_delta

func zoom_in():
	var new_zoom = zoom.x + zoom_speed
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	zoom = Vector2(new_zoom, new_zoom)

func zoom_out():
	var new_zoom = zoom.x - zoom_speed
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	zoom = Vector2(new_zoom, new_zoom)
