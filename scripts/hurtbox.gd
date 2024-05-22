extends Area2D

@export var has_effect = true

const HIT_EFFECT = preload("res://scenes/hit_effect.tscn")

var main_scene = null

func _ready():
	main_scene = get_tree().current_scene

func add_hit_animation():
	var hit_effect = HIT_EFFECT.instantiate()
	main_scene.add_child(hit_effect)
	hit_effect.global_position = global_position

func _on_area_entered(_area):
	if has_effect:
		add_hit_animation()
