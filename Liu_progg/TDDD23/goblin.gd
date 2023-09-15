extends CharacterBody2D

@export var speed = 50 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animatedSprite2d = $AnimatedSprite2D
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
var damage = 200

func _ready():
	screen_size = get_viewport_rect().size
	_animatedSprite2d.play("idle")
	
func _process(delta):
	if enemy_dead and not _animatedSprite2d.is_playing():
		self.queue_free()
	if not _animatedSprite2d.is_playing():
			_animatedSprite2d.play("run")
	var movement = 0
	enemy_attacked()
	if chase and enemy_dead == false:
		movement = (player.position - position)/speed
		if movement.x < 0:
			_animatedSprite2d.flip_h = true
		else:
			_animatedSprite2d.flip_h = false
		position += movement
		move_and_slide()


func _on_detection_area_body_entered(body):
	if body.has_method("templar"):
		chase = true
		player = body
		_animatedSprite2d.play("run")


func _on_detection_area_body_exited(body):
	if body.has_method("templar"):
		chase = false
		player = null
		_animatedSprite2d.play("idle")
		
func enemy():
	pass
		
func enemy_attacked():
	if player_in_attack_range and global.player_attacking and attacked_cooldown:
		attacked_cooldown = false
		$attacked_cooldown.start()
		health -= 20
		_animatedSprite2d.play("take_hit")
		if health <= 0:
			enemy_dead = true
			_animatedSprite2d.play("death")
			


func _on_attacked_cooldown_timeout():
	attacked_cooldown = true


func _on_hitbox_body_entered(body):
	if body.has_method("templar"):
		player_in_attack_range = true


func _on_hitbox_body_exited(body):
	if body.has_method("templar"):
		player_in_attack_range = false


func _on_attack_cooldown_timeout():
	attack_cooldown = true


func _on_enemy_attack_body_entered(body):
	if body.has_method("templar") and attack_cooldown:
		_animatedSprite2d.play("attack2")
		in_attack_range = true
		attack_cooldown = false
		$attack_cooldown.start()
		body.enemy_attack(damage)


func _on_enemy_attack_body_exited(body):
	if body.has_method("templar"):
		in_attack_range = false
