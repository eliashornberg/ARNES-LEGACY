extends Node2D

var canTalkToPatrik = false
var opened_shop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sounds.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canTalkToPatrik and not opened_shop:
		$shop.open_shop()
		opened_shop = true


func _on_leave_bateman_area_2d_body_entered(body):
	if body.is_in_group("hero"):
		global.justEnteredWorld = true
		if not global.justEnteredBatemanHouse:
			$Sounds.stop()
			get_tree().change_scene_to_file("res://game.tscn")


func _on_leave_bateman_area_2d_body_exited(body):
	if body.is_in_group("hero"):
		global.justEnteredBatemanHouse = false


func _on_interact_with_patrik_area_2d_body_entered(body):
	canTalkToPatrik = true

func _on_interact_with_patrik_area_2d_body_exited(body):
	canTalkToPatrik = false
	if opened_shop:
		$shop.close_shop()
		opened_shop = false
