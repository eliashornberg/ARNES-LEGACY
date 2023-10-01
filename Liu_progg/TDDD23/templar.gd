extends CharacterBody2D

var screen_size # Size of the game window.

signal damage_taken

@onready var _animation_player = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var hit_taken = false

func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.active = true
	_state_machine.travel("idle")
	
func _process(delta):
	var velocity = Vector2() # The player's movement vector.
	if player_alive:
		var moving = false
		var change_position = false
		var current = _state_machine.get_current_node()
		if current != "roll-right" and current != "thanos-snapped":
			$Sprite2D.flip_h = false
		var looking_right = false
		var looking_up = false
		var looking_down = true
		if Input.is_action_pressed("down"):
			velocity.y += 1
			moving = true
			looking_up = false
			looking_right = false
			looking_down = true
			change_position = true
			_state_machine.travel("run-down")
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			moving = true
			looking_up = true
			looking_right = false
			looking_down = false
			change_position = true
			_state_machine.travel("run-up")
		if Input.is_action_pressed("right"):
			velocity.x += 1
			looking_right = true
			looking_up = false
			looking_down = false
			moving = true
			change_position = true
			_state_machine.travel("run-sword")
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			looking_right = false
			looking_up = false
			looking_down = false
			moving = true
			change_position = true
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
		if global.health <= 0:
			player_alive = false
			global.player_attacking = false
			$death_cooldown.start()
			global.health = 200
			_state_machine.travel("die-ground")
			moving = true
		if not moving:
			_state_machine.travel("idle")
		else:
			if not global.game_started:
				global.game_started = true
		
	
		
		if change_position:
			if velocity.length() > 0:
				velocity = velocity.normalized() * global.speed
			position += velocity * delta
			position = position.clamp(Vector2.ZERO, screen_size)
			move_and_slide()
		
func enemy_attack(damage):
	hit_taken = true
	global.health -= damage
	_state_machine.travel("damaged")
	damage_taken.emit()


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
	
