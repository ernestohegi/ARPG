extends CharacterBody2D

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var sprite = $Bat

const BAT_DEATH_EFFECT = preload("res://scenes/bat_death_effect.tscn")
const SPEED = Vector2.ZERO

enum {
	IDLE,
	WANDER,
	CHASE
}

var is_alive = true
var bat_death_effect = null 
var main_scene = null
var move = CHASE

func _ready():
	main_scene = get_tree().current_scene
	bat_death_effect = BAT_DEATH_EFFECT.instantiate()

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	
	match move:
		IDLE:
			seek_player()
			pass
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			
			sprite.flip_h = velocity.x < 0
			
			if player != null:
				var player_direction = player.global_position - global_position  # Should normalize the direction here
				velocity = velocity.move_toward(player_direction, 200)
			pass
			
	move_and_slide()


func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 120

func _on_stats_no_health():
	add_death_animation()
	queue_free()

func add_death_animation():
	main_scene.add_child(bat_death_effect)
	bat_death_effect.global_position = global_position
	
func seek_player():
	if player_detection_zone.is_player_inside_detection_zone():
		move = CHASE
