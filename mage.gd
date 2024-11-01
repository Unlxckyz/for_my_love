extends CharacterBody2D
#todo eu
@onready var sprite = $Sprite2D
@onready var baloon_new = $Sprite2D/new
@onready var baloon_chatting = $Sprite2D/chatting
@onready var quest_label = $Sprite2D/quest_complete
var is_chat = false
var player_in_area = false
var count = 0
var player_pegou_tome = false

func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)

func _physics_process(delta: float) -> void:
	if player_in_area and not is_chat and Input.is_action_pressed("interact"):
		handle_dialogue()
	if Global.rat_killed > 10:
		baloon_new.visible = false
		quest_label.visible = true
		

	

func handle_dialogue() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	Global.is_chating = 0
	if Global.rat_killed > 10 and not player_pegou_tome:
		run_dialogue("mageTimeline3")
		baloon_new.visible = false
		baloon_chatting.visible = true
		quest_label.visible = false
	if Global.first_time_mage == 0:
		run_dialogue("mageTimeline")
		Global.first_time_mage  += 1
		baloon_new.visible = false
		baloon_chatting.visible = true
	if Global.first_time_mage  == 1:
		run_dialogue("mageTimeline2")
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
	if arg == "exit_mage":
		baloon_chatting.visible = false
		is_chat = false
	if Global.first_time_mage == 1:
		baloon_new.visible = true
	if arg == "get_tome":
		Global.can_spell = true
		player_pegou_tome = true
	Global.is_chating = 1
	
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
