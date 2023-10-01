extends CanvasLayer

signal start_game

func show_message(text):
	$Instruction.text = text
	$Instruction.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Instruction.text = "Move with WASD, fight with O.\nKill all enemies!"
	
	$Instruction.show()
	
	await get_tree().create_timer(1.0).timeout
	$Button.show()
	
func update_wave():
	$StartWaveText.hide()
	$Wave.text = "Wave " + str(global.wave)
	
func show_wave():
	$Wave.text = "Wave " + str(global.wave)
	
func update_gold():
	$Money.text = "Cash: " + str(global.gold)
	
func update_health():
	$Life.text = str(global.health)
	
func update_speed():
	$Speed.text = str(global.speed)
	
func update_attack():
	$attack.text = str(global.templarDamage)
	

func wave_ended():
	$StartWaveText.show()


func _on_message_timer_timeout():
	$Instruction.hide()


func _start():
	$Instruction.hide()
	start_game.emit()
