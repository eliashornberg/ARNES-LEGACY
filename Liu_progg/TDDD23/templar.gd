extends CharacterBody2D

@export var speed = 40 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animation_player = $AnimationPlayer

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	var move = "idle"
	var looking_right = true
	if Input.is_action_pressed("right"):
		velocity.x += 1
		looking_right = true
		move = "run-sword"
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		looking_right = false
		move = "run-left"
	if Input.is_action_pressed("down"):
		velocity.y += 1
		move = "run-down"
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		move = "run-up"
	if Input.is_action_pressed("attack"):
		if looking_right:
			move = "attack-right"
		else:
			move = "attack-left"
	if Input.is_action_pressed("roll"):
		move = "roll-right"
	if Input.is_action_pressed("thanos"):
		move = "thanos-snapped"
	
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	_animation_player.play(move)
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	move_and_slide()
