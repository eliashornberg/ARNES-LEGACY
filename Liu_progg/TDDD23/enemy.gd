extends CharacterBody2D

@export var speed = 40 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var _animatedSprite2d = $AnimatedSprite2D
var switch = 0
var flipped = false
var chase = false
var player = null
var health = 100
var player_in_attack_range = false
var attack_cooldown = true
var enemy_dead = false

func _ready():
	screen_size = get_viewport_rect().size
	_animatedSprite2d.play("idle")
	
func _process(delta):
	if enemy_dead and not _animatedSprite2d.is_playing():
		self.queue_free()
	if not _animatedSprite2d.is_playing():
			_animatedSprite2d.play("walk")
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
		_animatedSprite2d.play("walk")


func _on_detection_area_body_exited(body):
	if body.has_method("templar"):
		chase = false
		player = null
		_animatedSprite2d.play("idle")
		
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("templar"):
		player_in_attack_range = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("templar"):
		player_in_attack_range = false
		
func enemy_attacked():
	if player_in_attack_range and global.player_attacking and attack_cooldown:
		attack_cooldown = false
		$attack_cooldown.start()
		health -= 20
		print(health)
		_animatedSprite2d.play("hit")
		if health <= 0:
			enemy_dead = true
			_animatedSprite2d.play("death")
			


func _on_attack_cooldown_timeout():
	attack_cooldown = true
