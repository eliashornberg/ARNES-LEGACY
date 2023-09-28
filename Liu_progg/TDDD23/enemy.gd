extends CharacterBody2D

@export var speed = 0.5 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var attacks = ["attack", "attack2"]

@onready var _animatedSprite2d = $AnimatedSprite2D

@onready var _animationplayer = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

var rng = RandomNumberGenerator.new()

var switch = 0
var flipped = false
var chase = false
var player = null
var health = 100
var player_in_attack_range = false
var attacked_cooldown = true
var enemy_dead = false
var in_attack_range = false
var attack_cooldown = true
var damage = 20
var heavy_damage = 30

func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.active = true
	_state_machine.travel("idle")
	
func _process(delta):
	if _state_machine.get_current_node() == "End":
		self.queue_free()
	else:
		var movement = 0
		if chase and not enemy_dead:
			enemy_attacked()
			attack()
			movement = ((player.position - position)).normalized() * speed
			if movement.x < 0:
				_animatedSprite2d.flip_h = true
				flipped = true
			else:
				
				flipped = false
				_animatedSprite2d.flip_h = false
			position += movement
			move_and_slide()


func _on_detection_area_body_entered(body):
	if body.is_in_group("hero"):
		chase = true
		player = body
		_state_machine.travel("walk")


func _on_detection_area_body_exited(body):
	if body.is_in_group("hero"):
		chase = false
		player = null
		_state_machine.travel("idle")


func _on_attack_1_body_entered(body):
	if body.is_in_group("hero") and not flipped:
		body.enemy_attack(damage)

func _on_attack_1_left_body_entered(body):
	if body.is_in_group("hero") and flipped:
		body.enemy_attack(damage)
		
func _on_attack_2_body_entered(body):
	if body.is_in_group("hero") and not flipped:
		body.enemy_attack(heavy_damage)
		
func _on_attack_2_left_body_entered(body):
	if body.is_in_group("hero") and flipped:
		body.enemy_attack(heavy_damage)


func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("hero"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("hero"):
		player_in_attack_range = false


func _on_attack_range_body_entered(body):
	if body.is_in_group("hero"):
		in_attack_range = true

func _on_attack_range_body_exited(body):
	if body.is_in_group("hero"):
		in_attack_range = false


func _on_attacked_cooldown_timeout():
	attacked_cooldown = true
	
	
func _on_attack_cooldown_timeout():
	attack_cooldown = true
	
	
func enemy_attacked():
	if player_in_attack_range and global.player_attacking and attacked_cooldown:
		attacked_cooldown = false
		$attacked_cooldown.start()
		health -= 20
		_state_machine.travel("hit")
		if health <= 0:
			_state_machine.travel("death")
			global.enemies -= 1
	
func attack():
	if in_attack_range and attack_cooldown:
		var attack = rng.randi() % 2
		_state_machine.travel(attacks[attack])
		attack_cooldown = false
		$attack_cooldown.start()
