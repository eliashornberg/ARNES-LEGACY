extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

func _ready():
	pass
	
func _process(delta):
	_animation_player.play("flag")
	move_and_slide()
