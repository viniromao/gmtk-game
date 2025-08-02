extends Sprite2D

@export var move_speed: float = 200.0
@export var fade_duration: float = 1.0

func _ready():
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(queue_free).set_delay(fade_duration)

func _process(delta):
	position.y -= move_speed * delta
