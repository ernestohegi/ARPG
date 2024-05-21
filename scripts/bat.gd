extends CharacterBody2D

@onready var stats = $Stats

const BAT_DEATH_EFFECT = preload("res://scenes/bat_death_effect.tscn")

var is_alive = true
var bat_death_effect = null
var main_scene = null

func _ready():
	main_scene = get_tree().current_scene
	bat_death_effect = BAT_DEATH_EFFECT.instantiate()

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	
	move_and_slide()
	
	if velocity == Vector2.ZERO && !is_alive:
		add_death_animation()
		queue_free()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 120

func _on_stats_no_health():
	is_alive = false

func add_death_animation():
	main_scene.add_child(bat_death_effect)
	bat_death_effect.global_position = global_position
