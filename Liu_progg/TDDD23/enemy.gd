extends CharacterBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var attacks = ["attack", "attack2", "attack3"]

@onready var _animatedSprite2d = $AnimatedSprite2D

@onready var _animationplayer = $AnimationPlayer

@onready var _animation_tree = $AnimationTree

@onready var _state_machine = _animation_tree.get("parameters/playback")

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

func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.active = true
	_state_machine.travel("idle")
	
func _process(delta):
	if _state_machine.get_current_node() == "End":
		self.queue_free()
	var movement = 0
	enemy_attacked()
	attack()
	if chase and not enemy_dead:
		movement = (player.position - position)/speed
		if movement.x < 0:
			_animatedSprite2d.flip_h = true
			flipped = true
		else:
			
			flipped = false
			_animatedSprite2d.flip_h = false
		position += movement
		move_and_slide()


func _on_detection_area_body_entered(body):
	if body.has_method("templar"):
		chase = true
		player = body
		_state_machine.travel("walk")


func _on_detection_area_body_exited(body):
	if body.has_method("templar"):
		chase = false
		player = null
		_state_machine.travel("idle")


func enemy():
	pass


func _on_attack_1_body_entered(body):
	if body.has_method("templar") and not flipped:
		body.enemy_attack(damage)

func _on_attack_1_left_body_entered(body):
	if body.has_method("templar") and flipped:
		body.enemy_attack(damage)


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("templar"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("templar"):
		player_in_attack_range = false


func _on_attack_range_body_entered(body):
	if body.has_method("templar"):
		in_attack_range = true

func _on_attack_range_body_exited(body):
	if body.has_method("templar"):
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
	
func attack():
	if in_attack_range and attack_cooldown:
		_state_machine.travel("attack")
		attack_cooldown = false
		$attack_cooldown.start()
