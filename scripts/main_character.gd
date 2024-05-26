extends CharacterBody2D

@export var BASE_SPEED = 100.0
@export var ROLL_SPEED = BASE_SPEED * 1.8
@export var RUN_SPEED = BASE_SPEED * 1.2
@export var DECELERATION = BASE_SPEED / 8
@export var ACCELERATION = BASE_SPEED / 2

enum {
	MOVE,
	ATTACK,
	ROLL
}

var state = MOVE
var move_vector = Vector2.ZERO
var roll_vector = Vector2.ZERO
var stats = PlayerStats

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get('parameters/playback')
@onready var sword_hitbox = $HitboxPivot/SwordHitbox

func _ready():
	stats.connect('no_health', Callable(self, 'queue_free'))
	animation_tree.active = true
	sword_hitbox.knockback_vector = move_vector

func _physics_process(_delta):
	match state:
		MOVE:
			move()
		ATTACK:
			attack()
		ROLL:
			roll()

func move():
	var horizontalDirection = Input.get_axis("move_left", "move_right")
	var verticalDirection = Input.get_axis("move_up", "move_down")
	
	move_vector.x = horizontalDirection
	move_vector.y = verticalDirection
	move_vector = move_vector.normalized() # Normalise diagonals speed

	velocity.x = move_toward(velocity.x, BASE_SPEED * move_vector.x, ACCELERATION) if horizontalDirection else move_toward(velocity.x, 0, DECELERATION)
	velocity.y = move_toward(velocity.y, BASE_SPEED * move_vector.y, ACCELERATION) if verticalDirection else move_toward(velocity.y, 0, DECELERATION)

	if move_vector != Vector2.ZERO:
		roll_vector = move_vector
		sword_hitbox.knockback_vector = move_vector
		animation_tree.set('parameters/Run/blend_position', move_vector)
		animation_tree.set('parameters/Idle/blend_position', move_vector)
		animation_tree.set('parameters/Attack/blend_position', move_vector)
		animation_tree.set('parameters/Roll/blend_position', move_vector)
		run()
	else:
		idle()

	move_and_slide()

	if (Input.is_action_just_pressed('attack')):
		state = ATTACK
		
	if (Input.is_action_just_pressed('roll')):
		state = ROLL

func attack():
	velocity = Vector2.ZERO
	animation_state.travel('Attack')

func roll():
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel('Roll')
	move_and_slide()

func run():
	velocity = move_vector * RUN_SPEED
	animation_state.travel('Run')
	
func idle():
	animation_state.travel('Idle')

func reset_animation_state():
	state = MOVE

func roll_animation_finished():
	velocity = Vector2.ZERO
	reset_animation_state()

func attack_animation_finished():
	reset_animation_state()

func _on_hurtbox_area_entered(area):
	print('hurt')
	stats.health -= 1
