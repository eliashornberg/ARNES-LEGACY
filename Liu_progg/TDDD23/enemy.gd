extends CharacterBody2D

@export var speed = 40 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animatedSprite2d = $AnimatedSprite2D
var switch = 0
var flipped = false
var chase = false
var player = null

func _ready():
	screen_size = get_viewport_rect().size
	_animatedSprite2d.play("idle")
	
func _process(delta):
	var movement = 0
	"""
	var velocity = Vector2.ZERO # The player's movement vector.
	if switch > 20:
		if not flipped:
			_animatedSprite2d.flip_h = true
			flipped = true
		velocity.x -= 1
		switch += 1
		_animatedSprite2d.play("walk")
		if switch > 40:
			switch = 0
			_animatedSprite2d.flip_h = false
			flipped = false
	else:
		switch += 1
		velocity.x += 1
		_animatedSprite2d.play("walk")
		
		
	
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	"""
	if chase:
		movement = (player.position - position)/speed
		if movement.x < 0:
			_animatedSprite2d.flip_h = true
		else:
			_animatedSprite2d.flip_h = false
		position += movement
		move_and_slide()


func _on_detection_area_body_entered(body):
	chase = true
	player = body
	_animatedSprite2d.play("walk")
	print("inne")


func _on_detection_area_body_exited(body):
	print("ute")
	chase = false
	player = null
	_animatedSprite2d.play("idle")
