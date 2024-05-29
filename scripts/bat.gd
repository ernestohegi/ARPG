extends CharacterBody2D

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var sprite = $Bat
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController

const BAT_DEATH_EFFECT = preload("res://scenes/bat_death_effect.tscn")
const SPEED = Vector2.ZERO

var is_alive = true
var bat_death_effect = null 
var main_scene = null

enum {
	WANDER,
	IDLE
}

func _ready():
	main_scene = get_tree().current_scene
	bat_death_effect = BAT_DEATH_EFFECT.instantiate()

func _physics_process(delta):
	if player_detection_zone.is_player_inside_detection_zone():
		var player = player_detection_zone.player
		var player_direction = player.global_position - global_position  
		velocity = velocity.move_toward(player_direction, 200)
	else:
		if !wander_controller.has_time_left():
			const IDLE_STATES = [IDLE, WANDER];
			IDLE_STATES.shuffle()
			if IDLE_STATES[0] == WANDER:
				wander_controller.restart_random_timer()
				velocity = velocity.move_toward(
					wander_controller.target_position - global_position, 
					200
				)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, 200)
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * 200 * delta

	sprite.flip_h = velocity.x < 0

	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 900

func _on_stats_no_health():
	add_death_animation()
	queue_free()

func add_death_animation():
	main_scene.add_child(bat_death_effect)
	bat_death_effect.global_position = global_position
