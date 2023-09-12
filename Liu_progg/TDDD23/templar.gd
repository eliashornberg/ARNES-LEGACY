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

func _ready():
	screen_size = get_viewport_rect().size
	_state_machine.travel("idle")
	_animation_tree.active = true
	
func _process(delta):
	if player_alive:
		var moving = false
		var attacking = false
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
			attacking = true
			global.player_attacking = true
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
		if enemy_attack():
			moving = true
		if health <= 0:
			player_alive = false
			$death_cooldown.start()
			health = 100
			_state_machine.travel("die-ground")
			moving = true
		if not attacking:
				global.player_attacking = false
		if not moving:
			_state_machine.travel("idle")
		
	
		

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		move_and_slide()
	
func templar():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		_state_machine.travel("damaged")
		return true
	else:
		return false


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_death_cooldown_timeout():
	player_alive = true
