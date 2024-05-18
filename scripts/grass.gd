extends Node2D

const GRASS_EFFECT = preload("res://scenes/grass_effect.tscn")

var main_scene = null
var grass_effect = null

func _ready():
	main_scene = get_tree().current_scene
	grass_effect = GRASS_EFFECT.instantiate()

func add_grass_animation():
	main_scene.add_child(grass_effect)
	grass_effect.global_position = global_position

func _on_hurtbox_area_entered(area):
	add_grass_animation()
	queue_free()
