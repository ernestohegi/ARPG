extends CharacterBody2D

@onready var stats = $Stats

var is_alive = true

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	
	move_and_slide()
	
	if velocity == Vector2.ZERO && !is_alive:
		queue_free()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 120

func _on_stats_no_health():
	is_alive = false
