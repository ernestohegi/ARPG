extends Node

signal no_health
signal health_changed(value)

@export var max_health = 2

@onready var health = max_health:
	get:
		return health
	set(value):
		health = value
		emit_signal('health_changed', value)
		if health <= 0:
			emit_signal('no_health')
