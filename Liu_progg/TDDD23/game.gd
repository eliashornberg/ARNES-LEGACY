extends Node2D

@export var enemy_scene: PackedScene

@export var goblin_scene: PackedScene

@export var boss_scene: PackedScene

@export var gold_scene: PackedScene

var spawn_timer = true
var spawn_goblin_timer = true
var spawn_freq = 10
var goblin_spawn_freq = 55
var wave_active = false
var wave_timer_running = false
var waves_timer = []
var start = false
var gameOver = false
var show_restart_text = false
var goblin_spawn_positions = [Vector2(983, 138), Vector2(185, 727)]
var enemy_spawn_positions = [Vector2(85,192),Vector2(1048, 620)]
var boss_spawn_positions = [Vector2(571, 53), Vector2(575, 741), Vector2(1130, 419), Vector2(38, 417)]

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.newGame()
	$HUD.wave_ended()
	if global.justEnteredWorld:
		$HUD._start()
		$HUD.show_wave()
		$HUD.update_gold()
		$HUD.update_attack()
		$HUD.update_health()
		$HUD.update_speed()
		$templar.position.x = 568
		$templar.position.y = 441


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not gameOver:
		if global.drop_gold:
			global.drop_gold = false
			add_gold(global.gold_amount, global.gold_pos)
		if global.gold_amount_updated:
			$HUD.update_gold()
			global.gold_amount_updated = false
		if global.game_started and not start:
			$HUD._start()
		if start:
			if not wave_timer_running and global.enemies == 0 and wave_active:
				end_wave()
			if not wave_active:
				if Input.is_action_pressed("StartWave"):
					start_wave()
			if wave_active:
				if spawn_timer:
					$Spawn_timer.start()
					spawn_timer = false
				if spawn_goblin_timer:
					$goblinSpawnTimer.start()
					spawn_goblin_timer = false
	else:
		if show_restart_text:
			$HUD.gameOver()
			if Input.is_action_pressed("StartWave"):
				reset_globals()
				get_tree().reload_current_scene()
			
		
	

func start_wave():
	global.wave += 1
	$HUD.update_wave()
	if global.wave % 5 != 0:
		$Spawn_timer.wait_time = spawn_freq/global.wave
		$goblinSpawnTimer.wait_time = goblin_spawn_freq/global.wave
		spawn_timer = true
		spawn_goblin_timer = true
	else:
		var boss_amount = global.wave / 5
		for n in boss_amount:
			var boss_pos = boss_spawn_positions[n % 4]
			spawn_boss(boss_pos)
	$wave_timer.start()
	wave_timer_running = true
	wave_active = true
	
func end_wave():
	wave_active = false
	$HUD.wave_ended()
	
	

func spawn_enemy():
	global.enemies += 1
	var enemy = enemy_scene.instantiate()
	var enemy_pos = rng.randi() % 2
	enemy.position = enemy_spawn_positions[enemy_pos]
	add_child(enemy)


func _on_spawn_timer_timeout():
	spawn_enemy()
	spawn_timer = true
	
func spawn_goblin():
	global.enemies += 1
	var goblin = goblin_scene.instantiate()
	var goblin_pos = rng.randi() % 2
	goblin.position = goblin_spawn_positions[goblin_pos]
	add_child(goblin)
	
func _on_goblin_spawn_timer_timeout():
	spawn_goblin()
	spawn_goblin_timer = true
	
func spawn_boss(boss_pos):
	global.enemies += 1
	var boss = boss_scene.instantiate()
	boss.position = boss_pos
	add_child(boss)


func _on_bateman_area_2d_body_entered(body):
	if body.is_in_group("hero"):
		global.justEnteredBatemanHouse = true
		if not global.justEnteredWorld and not wave_active:
			get_tree().change_scene_to_file("res://bateman_house.tscn")


func _on_bateman_area_2d_body_exited(body):
	if body.is_in_group("hero"):
		global.justEnteredWorld = false


func _on_wave_timer_timeout():
	$Spawn_timer.stop()
	$goblinSpawnTimer.stop()
	spawn_timer = false
	spawn_goblin_timer = false
	wave_timer_running = false
	


func _on_hud_start_game():
	start = true
	
func add_gold(amount, gold_pos):
	var gold = gold_scene.instantiate()
	gold.position = gold_pos
	gold.amount = amount
	add_child(gold)


func _on_templar_damage_taken():
	$HUD.update_health()


func _on_templar_game_over():
	gameOver = true
	$gameOverTimer.start()
	


func _on_game_over_timer_timeout():
	show_restart_text = true
	
func reset_globals():
	global.player_attacking = false
	global.justEnteredBatemanHouse = false
	global.justEnteredWorld = false
	global.enemies = 0
	global.wave = 0
	global.game_started = false
	global.gold = 0
	global.drop_gold = false
	global.gold_pos = Vector2.ZERO
	global.gold_amount = 0
	global.gold_amount_updated = false

	global.health = 200
	global.speed = 200
	global.templarDamage = 20

	global.speedPrice = 100
	global.attackPrice = 100
	global.healthPrice = 50

	global.speedOffer = 50
	global.attackOffer = 20
	global.healthOffer = 40
