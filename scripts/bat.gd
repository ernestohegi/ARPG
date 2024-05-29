extends CharacterBody2D

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var sprite = $Bat
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController

const BAT_DEATH_EFFECT = preload("res://scenes/bat_death_effect.tscn")
const SPEED = Vector2.ZERO
const ACCELERATION = 200

var is_alive = true
var bat_death_effect = null 
var main_scene = null

enum {
	WANDER,
	IDLE
}

const IDLE_STATES = [WANDER, IDLE]

func _ready():
	main_scene = get_tree().current_scene
	bat_death_effect = BAT_DEATH_EFFECT.instantiate()

func _physics_process(delta):
	wander()
				
	if player_detection_zone.is_player_inside_detection_zone():
		var player = player_detection_zone.player
		var player_direction = player.global_position - global_position  
		velocity = velocity.move_toward(player_direction, ACCELERATION)
	else:
		if !wander_controller.has_time_left():
			if IDLE_STATES[randi_range(0, 1)] == WANDER:
				wander_controller.restart_random_timer()
				wander()
			else:
				velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * ACCELERATION * delta

	sprite.flip_h = velocity.x < 0

	move_and_slide()

func wander():
	velocity = velocity.move_toward(
		wander_controller.target_position - global_position, 
		ACCELERATION
	)

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * ACCELERATION * 4.5

func _on_stats_no_health():
	add_death_animation()
	queue_free()

func add_death_animation():
	main_scene.add_child(bat_death_effect)
	bat_death_effect.global_position = global_position
