extends CharacterBody2D

@export var speed = 40 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animation_player = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

func _ready():
	screen_size = get_viewport_rect().size
	_state_machine.travel("idle")
	_animation_tree.active = true
	
func _process(delta):
	var moving = false
	var current = _state_machine.get_current_node()
	if current != "roll-right" and current != "thanos-snapped":
		$Sprite2D.flip_h = false
	var velocity = Vector2.ZERO # The player's movement vector.
	var looking_right = true
	if Input.is_action_pressed("down"):
		velocity.y += 1
		moving = true
		_state_machine.travel("run-down")
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		moving = true
		_state_machine.travel("run-up")
	if Input.is_action_pressed("right"):
		velocity.x += 1
		looking_right = true
		moving = true
		_state_machine.travel("run-sword")
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		looking_right = false
		moving = true
		_state_machine.travel("run-left")
	if Input.is_action_pressed("attack"):
		moving = true
		if looking_right:
			_state_machine.travel("attack-right")
		else:
			_state_machine.travel("attack-left")
	if Input.is_action_pressed("roll"):
		moving = true
		if looking_right:
			_state_machine.travel("roll-right")
		else:
			$Sprite2D.flip_h = true
			_state_machine.travel("roll-right")
	if Input.is_action_pressed("thanos"):
		moving = true
		if looking_right:
			_state_machine.travel("thanos-snapped")
		else:
			$Sprite2D.flip_h = true
			_state_machine.travel("thanos-snapped")
	if not moving:
		_state_machine.travel("idle")
		
	
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	move_and_slide()
