extends Node2D


func _ready():
	pass


func _process(delta):
	pass


func _on_exit_body_entered(body):
	if $Chest.opened == true:
		if body.has_method("player"):
			global.transition_scene = true
			global.game_first_loadin = false
			global.pit_complete = true
			global.coming_from_pit = true
			get_tree().change_scene_to_file("res://scenes/level_2.tscn")
			global.finish_changescenes("level_2")
