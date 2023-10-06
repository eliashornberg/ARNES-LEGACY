extends CanvasLayer

@onready var animations = $AnimationPlayer

@onready var speedPriceLabel = $SpeedPrice
@onready var attackPriceLabel = $AttackPrice
@onready var healthPriceLabel = $HealthPrice

@onready var speedText = $SpeedText
@onready var attackText = $attackText
@onready var healthText = $healthText

@onready var goldAmount = $GoldAmount

@onready var patrickText = $PatrikDialogue







# Called when the node enters the scene tree for the first time.
func _ready():
	speedPriceLabel.text = str(global.speedPrice)
	attackPriceLabel.text = str(global.attackPrice)
	healthPriceLabel.text = str(global.healthPrice)
	
	speedText.text = "+ " + str(global.speedOffer)
	attackText.text = "+ " + str(global.attackOffer)
	healthText.text = "+ " + str(global.healthOffer)
	
	goldAmount.text = ": " + str(global.gold)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open_shop():
	animations.play("TranformIn")
	patrickText.text = "Welcome to my shop, my name is Patrik. 
Here you can buy stuff to defeat those nasty 
monsters. This is the cheapest shop you can find so 
dont try to negotiate the price Arne!"
	
func close_shop():
	animations.play("TransformOut")


func _on_buy_speed_button_pressed():
	if global.gold >= global.speedPrice:
		global.speed += global.speedOffer
		global.gold -= global.speedPrice
		global.speedPrice *= 2
		speedPriceLabel.text = str(global.speedPrice)
		goldAmount.text = ": " + str(global.gold)
		patrickText.text = "Nice! you now have " + str(global.speed) + " speed"
	else:
		taunt()


func _on_buy_health_button_pressed():
	if global.gold >= global.healthPrice:
		global.health += global.healthOffer
		global.gold -= global.healthPrice
		global.healthPrice *= 2
		healthPriceLabel.text = str(global.healthPrice)
		goldAmount.text = ": " + str(global.gold)
		patrickText.text = "Nice! you now have " + str(global.health) + " health"
	else:
		taunt()

func _on_buy_attack_button_pressed():
	if global.gold >= global.attackPrice:
		global.templarDamage += global.attackOffer
		global.gold -= global.attackPrice
		global.attackPrice *= 2
		attackPriceLabel.text = str(global.attackPrice)
		goldAmount.text = ": " + str(global.gold)
		patrickText.text = "Nice! you now have " + str(global.templarDamage) + " attack"
	else:
		taunt()
		
func taunt():
	patrickText.text = "Are you poor or what?"
