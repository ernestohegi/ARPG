extends Node

@onready var empty_hearts = $EmptyHearts
@onready var full_hearts = $FullHearts

const TEXTURE_PIXELS = 15

var hearts: int
var max_hearts: int

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	update_hearts_ui(PlayerStats.health)
	PlayerStats.connect('health_changed', Callable(self, 'set_hearts'))

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	update_hearts_ui(value)
	
func update_hearts_ui(value):
	full_hearts.size.x = value * TEXTURE_PIXELS
