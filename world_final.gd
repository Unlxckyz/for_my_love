extends Node2D

@onready var window = $CanvasLayer/Inventory
@onready var hp_count = $CanvasLayer2/CanvasLayer2/hp
@onready var tutorial_window_keyboard = $tutorial/keyboard
var window_animation
var player_health = Global.hp_player
var max_player_health = Global.max_hp_player
@onready var progress_bar = $CanvasLayer/ProgressBar

func checkStatus():
	progress_bar.max_value = Global.max_hp_player
	progress_bar.value = Global.hp_player

func _ready() -> void:
	var window_animation = window.get_node("AnimationPlayer")
	hp_count.text = str(Global.potions_hp)
	checkStatus()
	
func _physics_process(delta: float) -> void:
	checkPotions()
	checkStatus()
func checkPotions():
	hp_count.text = str(Global.potions_hp)
func _on_configuraçoes_toggled(toggled_on: bool) -> void:
	var window_animation = window.get_node("AnimationPlayer")
	if window.visible == true:
		window.visible = false
		
	else:
		window.visible = true
		window_animation.play("scroll_up")



	
