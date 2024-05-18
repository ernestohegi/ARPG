extends Node2D

const GRASS_EFFECT = preload("res://scenes/grass_effect.tscn")

var main_scene = null
var grass_effect = null

func _ready():
	main_scene = get_tree().current_scene
	grass_effect = GRASS_EFFECT.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		main_scene.add_child(grass_effect)
		grass_effect.global_position = global_position
		queue_free()
 
