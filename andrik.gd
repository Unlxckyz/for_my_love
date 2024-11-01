extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var baloon_new = $Sprite2D/new
@onready var baloon_chatting = $Sprite2D/chatting
var is_chat = false
var player_in_area = false
var count = 0


func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)

func _physics_process(delta: float) -> void:
	if player_in_area and not is_chat and Input.is_action_pressed("interact"):
		handle_dialogue()

	

func handle_dialogue() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	Global.is_chating = 0
	if Global.player_caudas > 10:
		run_dialogue("andrikTimeline3")
	# Controle do diálogo
	if Global.first_time_andrik== 0:
		run_dialogue("andrikTimeline")
		Global.first_time_andrik += 1
		baloon_new.visible = false
		baloon_chatting.visible = true
	if Global.first_time_andrik == 1:
		run_dialogue("andrikTimeline2")
		baloon_new.visible = false
		baloon_chatting.visible = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true
	


func run_dialogue(dialogue_string: String) -> void:
	is_chat = true
	
	Global.is_chating = 0
	Dialogic.start(dialogue_string)

func DialogicSignal(arg: String) -> void:
	if arg == "exit_andrik":
		baloon_chatting.visible = false
		is_chat = false
	if Global.first_time_andrik == 1:
		baloon_new.visible = true
	
		Global.is_chating = 1
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
