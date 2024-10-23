extends ProgressBar

var player_health = Global.hp_player
var max_player_health = Global.max_hp_player
@onready var progress_bar = $"."

func checkStatus():
	progress_bar.max_value = Global.max_hp_player
	progress_bar.value = Global.hp_player
func _ready():
	checkStatus()
func _physics_process(delta):
	checkStatus()
