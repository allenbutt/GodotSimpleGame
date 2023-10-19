extends Node2D

func _ready():
	global.player_dash_ready = true
	if global.game_first_loadin == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
		self.modulate = "000000"
		global.fade_in()
		music_player.play_song("world")
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy
		$enemy5.queue_free()
		$enemy4.queue_free()

func _process(_delta):
	pass
	#change_scene()

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player") and global.player_dash_upgrade == false and global.player_throw_upgrade == false:
		global.transition_scene = true
		global.game_first_loadin = false
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
		global.finish_changescenes("cliff_side")


func _on_cliffside_transition_point_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
#	if global.transition_scene == true:
#		global.game_first_loadin = false
#		if global.current_scene == "world":
#			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
#			global.finish_changescenes()
#		else:
#			get_tree().change_scene_to_file("res://scenes/level_1.tscn")
#			global.finish_changescenes()
	pass


func _on_level_1_transition_body_entered(body):
	if body.has_method("player") and (global.player_dash_upgrade == true or global.player_throw_upgrade == true):
		global.transition_scene = true
		global.game_first_loadin = false
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		global.finish_changescenes("level_1")
	elif body.has_method("player") and (global.player_dash_upgrade == true or global.player_throw_upgrade == true) == false:
		var signposition = $Exit_Text_location.position
		DialogManager.start_dialog(signposition, ["Find the Treasure in this area \n before continuing."])

func _on_level_1_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		var signposition = $Sign_Text_Location.position
		DialogManager.start_dialog(signposition, ["Move: ASDW\nAttack: Left-Click\nSprint: Shift (Hold)"])


func _on_sign_text_trigger_2_body_entered(body):
	if body.has_method("player") and global.player_dash_upgrade == false and global.player_throw_upgrade == false:
		var signposition = $Sign_Text_Location2.position
		DialogManager.start_dialog(signposition, ["Secret Treasure directly North.\nDon't tell anyone!"])
