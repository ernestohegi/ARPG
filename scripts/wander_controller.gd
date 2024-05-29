extends Node2D

const WANDER_RANGE = 32

@onready var timer = $Timer
@onready var start_position = global_position
@onready var target_position = global_position

func update_target_position():
	var target_vector = Vector2(
		randf_range(-WANDER_RANGE, WANDER_RANGE), 
		randf_range(-WANDER_RANGE, WANDER_RANGE)
	)
	target_position = start_position + target_vector

func has_time_left():
	return timer.time_left > 0

func restart_random_timer():
	timer.start(randf_range(1, 3))

func _on_timer_timeout():
	update_target_position()
