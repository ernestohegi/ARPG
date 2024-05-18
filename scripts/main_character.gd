extends CharacterBody2D

const SPEED = 100.0
const DECELERATION = SPEED/8
const ACCELERATION = SPEED/2

enum {
	MOVE,
	ATTACK
}

var state = MOVE

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get('parameters/playback')

func _ready():
	animation_tree.active = true

func _physics_process(_delta):
	match state:
		MOVE:
			move()
		ATTACK:
			attack()

func move():
	var vector = Vector2.ZERO;
	var horizontalDirection = Input.get_axis("move_left", "move_right")
	var verticalDirection = Input.get_axis("move_up", "move_down")
	
	vector.x = horizontalDirection
	vector.y = verticalDirection
	vector = vector.normalized() # Normalise diagonals speed
	
	velocity.x = move_toward(velocity.x, SPEED * vector.x, ACCELERATION) if horizontalDirection else move_toward(velocity.x, 0, DECELERATION)
	velocity.y = move_toward(velocity.y, SPEED * vector.y, ACCELERATION) if verticalDirection else move_toward(velocity.y, 0, DECELERATION)

	if vector != Vector2.ZERO:
		animation_tree.set('parameters/Attack/TimeScale/scale', 20.0)
		animation_tree.set('parameters/Run/blend_position', vector)
		animation_tree.set('parameters/Idle/blend_position', vector)
		animation_tree.set('parameters/Attack/blend_position', vector)
		animation_state.travel('Run')
	else:
		animation_state.travel('Idle')

	move_and_slide()

	if (Input.is_action_just_pressed('attack')):
		state = ATTACK

func attack():
	velocity = Vector2.ZERO
	animation_state.travel('Attack')

func attack_animation_finished():
	state = MOVE
