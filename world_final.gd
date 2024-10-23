extends Node2D

@onready var window = $CanvasLayer/Inventory
@onready var hp_count = $CanvasLayer2/CanvasLayer2/hp
var window_animation
func _ready() -> void:
	var window_animation = window.get_node("AnimationPlayer")
	hp_count.text = str(Global.potions_hp)
	
func _physics_process(delta: float) -> void:
	checkPotions()
func checkPotions():
	hp_count.text = str(Global.potions_hp)
func _on_configuraçoes_toggled(toggled_on: bool) -> void:
	var window_animation = window.get_node("AnimationPlayer")
	if window.visible == true:
		window.visible = false
		
	else:
		window.visible = true
		window_animation.play("scroll_up")
