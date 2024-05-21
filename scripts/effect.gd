extends AnimatedSprite2D

@export var free_queue = false

func _ready():
	connect('animation_finished', Callable(self, '_on_animation_finished'))
	
	frame = 0
	
	play('default')

func _on_animation_finished():
	if free_queue:
		queue_free()
