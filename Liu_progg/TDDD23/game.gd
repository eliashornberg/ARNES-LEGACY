extends Node2D

@export var enemy_scene: PackedScene

var spawn_timer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_timer:
		$Spawn_timer.start()
		spawn_timer = false
		
	

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(85,190)
	add_child(enemy)


func _on_spawn_timer_timeout():
	spawn_enemy()
	spawn_timer = true
