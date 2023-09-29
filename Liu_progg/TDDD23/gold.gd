extends Node2D

var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play(str(amount)+"gold")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pick_up_coin_range_body_entered(body):
	if body.is_in_group("hero"):
		global.gold += amount
		global.gold_amount_updated = true
		self.queue_free()
