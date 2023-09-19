extends CharacterBody2D

@export var speed = 40 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animation_player = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 200
var player_alive = true
var hit_taken = false

func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.active = true
	_state_machine.travel("idle")
	
func _process(delta):
	if player_alive:
		var moving = false
		var current = _state_machine.get_current_node()
		if current != "roll-right" and current != "thanos-snapped":
			$Sprite2D.flip_h = false
		var velocity = Vector2.ZERO # The player's movement vector.
		var looking_right = false
		var looking_up = false
		var looking_down = true
		if Input.is_action_pressed("down"):
			velocity.y += 1
			moving = true
			looking_up = false
			looking_right = false
			looking_down = true
			_state_machine.travel("run-down")
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			moving = true
			looking_up = true
			looking_right = false
			looking_down = false
			_state_machine.travel("run-up")
		if Input.is_action_pressed("right"):
			velocity.x += 1
			looking_right = true
			looking_up = false
			looking_down = false
			moving = true
			_state_machine.travel("run-sword")
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			looking_right = false
			looking_up = false
			looking_down = false
			moving = true
			_state_machine.travel("run-left")
		if Input.is_action_pressed("attack"):
			moving = true

			if looking_right:
				_state_machine.travel("attack-right")
			else:
				if looking_up:
					_state_machine.travel("attack-up")
				else:
					if looking_down:
						_state_machine.travel("attack-down")
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
		if hit_taken:
			moving = true
			hit_taken = false
		if health <= 0:
			player_alive = false
			$death_cooldown.start()
			health = 100
			_state_machine.travel("die-ground")
			moving = true
		if not moving:
			_state_machine.travel("idle")
		
	
		

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		print(position, "innan")
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		print(position, "efter")
		print(velocity, "velocity")
		move_and_slide()
		
func enemy_attack(damage):
	hit_taken = true
	health -= damage
	_state_machine.travel("damaged")


func _on_death_cooldown_timeout():
	player_alive = true


func _on_swordhitright_body_entered(body):
	if body.is_in_group("enemies"):
		global.player_attacking = true


func _on_swordhitright_body_exited(body):
	global.player_attacking = false


func _on_swordhitleft_body_entered(body):
	if body.is_in_group("enemies"):
		global.player_attacking = true


func _on_swordhitleft_body_exited(body):
	global.player_attacking = false


func _on_swordhitdown_body_entered(body):
	if body.is_in_group("enemies"):
		global.player_attacking = true


func _on_swordhitdown_body_exited(body):
	global.player_attacking = false


func _on_swordhitup_body_entered(body):
	if body.is_in_group("enemies"):
		global.player_attacking = true


func _on_swordhitup_body_exited(body):
	global.player_attacking = false
	
