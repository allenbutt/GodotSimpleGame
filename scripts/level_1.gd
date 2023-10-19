extends Node2D

var door_opened = false

func _ready():
	self.modulate = "000000"
	global.fade_in()
	global.player_dash_ready = true
	global.current_scene = "level_1"
	music_player.play_song("level_1")
	
	if global.coming_from_level_2:
		$player.position.x = global.player_exit_level2to1_posx
		$player.position.y = global.player_exit_level2to1_posy
		global.coming_from_level_2 = false
		
	if global.coming_from_level_2_bottom:
		$player.position.x = $Start_Point_Level_2_Bottom.position.x
		$player.position.y = $Start_Point_Level_2_Bottom.position.y
		global.coming_from_level_2_bottom = false
		$enemy12.queue_free()
		$enemy25.queue_free()

	if global.coming_from_level_3:
		$player.position.x = $level_3_return_point.position.x
		$player.position.y = $level_3_return_point.position.y
		global.coming_from_level_3 = false
		$enemy10.queue_free()
	
	global.coming_from_pit = false

func _process(delta):
	pass


func _on_exit_level_2_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		global.game_first_loadin = false
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
		global.finish_changescenes("level_2")


func _on_exit_level_3_body_entered(body):
	if body.has_method("player") and global.player_key_2 == false:
		global.transition_scene = true
		global.game_first_loadin = false
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")
		global.finish_changescenes("level_3")


func _on_key_check_body_entered(body):
	if global.player_key_1 and global.player_key_2 and door_opened == false:
		await get_tree().create_timer(0.5).timeout
		$sfx/GateOpen.play()
		await get_tree().create_timer(0.5).timeout
		door_opened = true
		$CastleArt/Castle_Closed.visible = false
		$CastleArt/Castle_Open.visible = true
		await get_tree().create_timer(0.1).timeout
		
		$Door_Block.queue_free()


func _on_exit_level_4_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		global.game_first_loadin = false
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")
		global.finish_changescenes("level_4")


func _on_sign_trigger_body_entered(body):
	if body.has_method("player"):
		var signposition = $SignTextLocation.position
		var signposition2 = $SignTextLocation2.position
		if global.player_key_1 and global.player_key_2:
#			DialogManager.start_dialog(signposition, ["Come on in."])
			pass
		else:
			DialogManager.start_dialog(signposition, ["Find two keys to enter.\nOne in the Southeast.\nOne in the Northwest."])
		
