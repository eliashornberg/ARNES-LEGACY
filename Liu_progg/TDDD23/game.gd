extends Node2D

@export var enemy_scene: PackedScene

var spawn_timer = true
var spawn_freq = 10
var wave_active = false
var wave_timer_running = false
var waves_timer = []
var start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.justEnteredWorld:
		$HUD._start()
		$templar.position.x = 568
		$templar.position.y = 441


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.game_started and not start:
		$HUD._start()
	if start:
		if not wave_timer_running and global.enemies == 0:
			wave_active = false
			start_wave()
		if spawn_timer and wave_active:
			$Spawn_timer.start()
			spawn_timer = false
		
	

func start_wave():
	global.wave += 1
	$HUD.update_wave()
	$Spawn_timer.wait_time = spawn_freq/global.wave
	spawn_timer = true
	$wave_timer.start()
	wave_timer_running = true
	wave_active = true
	
	

func spawn_enemy():
	global.enemies += 1
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(85,190)
	add_child(enemy)


func _on_spawn_timer_timeout():
	spawn_enemy()
	spawn_timer = true


func _on_bateman_area_2d_body_entered(body):
	if body.is_in_group("hero"):
		global.justEnteredBatemanHouse = true
		if not global.justEnteredWorld:
			get_tree().change_scene_to_file("res://bateman_house.tscn")


func _on_bateman_area_2d_body_exited(body):
	if body.is_in_group("hero"):
		global.justEnteredWorld = false


func _on_wave_timer_timeout():
	$Spawn_timer.stop()
	spawn_timer = false
	wave_timer_running = false
	


func _on_hud_start_game():
	start = true
