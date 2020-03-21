extends Control

onready var scene_tree: = get_tree()
#onready var score_label: Lable = $Score
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var score: Label = get_node("Label")
onready var title_label: Label = get_node("PauseOverlay/Title")
onready var main_screen_button: Button = $PauseOverlay/VBoxContainer/ChangeSceneButton

const MESSAGE_DIED = "You died"

var paused: = false setget set_paused

func _ready():
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()

func _on_PlayerData_player_died() -> void:
	self.paused = true
	title_label.text = MESSAGE_DIED

func _on_Player_reset() -> void:
	self.paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and title_label.text != MESSAGE_DIED:
		self.paused =  not paused
		#scene_tree.set_input_as_handled()

func update_interface() -> void:
	score.text = "Score %s" % PlayerData.score

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
