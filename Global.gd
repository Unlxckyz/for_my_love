extends Node
var first_time_saimon = 0
var rat_elite_killed = false
var is_chating = 1
var can_sword = false
var can_spell = false
var hp_player = 100
var mp_player = 50
var max_hp_player = 100
var player_heart = 3
var potions_hp = 0
var dicas_value = 0
var player_death = false
var tutorial_show = true
var first_spawn = false
var first_time_andrik = 0
var player_caudas = 0
var first_time_mage = 0
var rat_killed = 0
@onready var label_global = get_tree().get_first_node_in_group("LabelGlobal")
@onready var last_checkpoint = null
