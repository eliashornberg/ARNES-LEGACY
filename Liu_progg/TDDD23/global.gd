extends Node

var player_attacking = false
var justEnteredBatemanHouse = false
var justEnteredWorld = false
var enemies = 0
var wave = 4
var game_started = false
var gold = 0
var drop_gold = false
var gold_pos = Vector2.ZERO
var gold_amount = 0
var gold_amount_updated = false

var health = 200
var speed = 200
var templarDamage = 20

var speedPrice = 100
var attackPrice = 100
var healthPrice = 50

var speedOffer = 50
var attackOffer = 20
var healthOffer = 40
