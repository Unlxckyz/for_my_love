extends Node2D

var global_dicas_value = Global.dicas_value
@onready var dica_1 = $dica1
@onready var dica_2 = $dica2
@onready var dica_3 = $dica3
@onready var dica_4 = $dica4
@onready var dica_5 = $dica5
@onready var dica_6 = $dica6
@onready var tutorial_windown = $".."

func _physics_process(delta: float) -> void:
	if Global.tutorial_show == true:
		tutorial_windown.visible = true
	if Global.tutorial_show == false:
		tutorial_windown.visible = false
		
	if Global.dicas_value > 5:
		Global.dicas_value = 0

	if Global.dicas_value == 0:
		dica_1.visible = true
		dica_2.visible = false
		dica_3.visible = false
		dica_4.visible = false
		dica_5.visible = false
		dica_6.visible = false
	elif Global.dicas_value == 1:
		dica_1.visible = false
		dica_2.visible = true
		dica_3.visible = false
		dica_4.visible = false
		dica_5.visible = false
		dica_6.visible = false
	elif Global.dicas_value == 2:
		dica_1.visible = false
		dica_2.visible = false
		dica_3.visible = true
		dica_4.visible = false
		dica_5.visible = false
		dica_6.visible = false
	elif Global.dicas_value == 3:
		dica_1.visible = false
		dica_2.visible = false
		dica_3.visible = false
		dica_4.visible = true
		dica_5.visible = false
		dica_6.visible = false
	elif Global.dicas_value == 4:
		dica_1.visible = false
		dica_2.visible = false
		dica_3.visible = false
		dica_4.visible = false
		dica_5.visible = true
		dica_6.visible = false
	elif Global.dicas_value == 5:
		dica_1.visible = false
		dica_2.visible = false
		dica_3.visible = false
		dica_4.visible = false
		dica_5.visible = false
		dica_6.visible = true

func _on_skip_pressed() -> void:
	if Global.dicas_value >= 0 and Global.dicas_value <= 5:
		Global.dicas_value += 1


func _on_button_pressed() -> void:
	if Global.tutorial_show == true:
		Global.tutorial_show = false
	else:
		Global.tutorial_show = true
	
