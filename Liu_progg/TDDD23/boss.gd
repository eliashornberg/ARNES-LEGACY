extends CharacterBody2D

@export var speed = 1 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animatedSprite2d = $AnimatedSprite2D

@onready var _animationplayer = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

var switch = 0
var flipped = false
var chase = false
var player = null
var health = 300
var player_in_attack_range = false
var attacked_cooldown = true
var in_attack_range = false
var attack_cooldown = true
var damage = 60
var dead = false
var attacking = false

func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.active = true
	_state_machine.travel("fly")
	
func _process(delta):
	if _state_machine.get_current_node() != "attack" and attacking:
		attacking = false
	if _state_machine.get_current_node() != "death" and dead:
		global.drop_gold = true
		global.gold_pos = position
		global.gold_amount = 500
		self.queue_free()
	else:
		var movement = 0
		if chase and not dead:
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
			move_and_collide(movement * delta)


func _on_detection_area_body_entered(body):
	if body.is_in_group("hero"):
		chase = true
		player = body
		_state_machine.travel("fly")


func _on_detection_area_body_exited(body):
	if body.is_in_group("hero"):
		chase = false
		player = null
		_state_machine.travel("fly")


func _on_attack_1_body_entered(body):
	if body.is_in_group("hero") and not flipped:
		body.enemy_attack(damage)

func _on_attack_1_left_body_entered(body):
	if body.is_in_group("hero") and flipped:
		body.enemy_attack(damage)


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
		health -= global.templarDamage
		if health <= 0 and not dead:
			dead = true
			_state_machine.travel("death")
			global.enemies -= 1
		else:
			if not attacking:
				_state_machine.travel("hit")
	
func attack():
	if in_attack_range and attack_cooldown and global.health > 0:
		attacking = true
		_state_machine.travel("attack")
		attack_cooldown = false
		$attack_cooldown.start()


func _on_boss_hitbox_body_entered(body):
	if body.is_in_group("hero"):
		player_in_attack_range = true


func _on_boss_hitbox_body_exited(body):
	if body.is_in_group("hero"):
		player_in_attack_range = false
