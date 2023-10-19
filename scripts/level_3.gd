extends Node2D

var boss_spawned = false
var halftime = false

const skeleton_scene = preload("res://scenes/enemyskeleton.tscn")

func _ready():
	self.modulate = "000000"
	global.fade_in()
	$TileMapDoorOffset.set_door_coordinates(Vector2($Door.global_position.x,$Door.global_position.y), $collisions/Door_Shape)
	$TileMapDoorOffset.notificationposition = $PillarActivateTextCreate.position
	global.coming_from_level_3 = true
	music_player.play_song("level_3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_create_boss_body_entered(body):
	if boss_spawned == false:
		var boss_instance1 = skeleton_scene.instantiate()
		boss_instance1.position = $bosscreatepoint.position
		boss_instance1.boss = true
		add_child(boss_instance1)
		boss_spawned = true


func _on_goal_detect_body_entered(body):
	if halftime == false:
		var enemy_instance1 = skeleton_scene.instantiate()
		enemy_instance1.position = $halftimecreatepoint1.position
		enemy_instance1.boss = false
		add_child(enemy_instance1)
		var enemy_instance2 = skeleton_scene.instantiate()
		enemy_instance2.position = $halftimecreatepoint2.position
		enemy_instance2.boss = false
		add_child(enemy_instance2)
		var enemy_instance3 = skeleton_scene.instantiate()
		enemy_instance3.position = $halftimecreatepoint3.position
		enemy_instance3.boss = false
		add_child(enemy_instance3)
		var enemy_instance4 = skeleton_scene.instantiate()
		enemy_instance4.position = $halftimecreatepoint4.position
		enemy_instance4.boss = false
		add_child(enemy_instance4)
		var enemy_instance5 = skeleton_scene.instantiate()
		enemy_instance5.position = $halftimecreatepoint5.position
		enemy_instance5.boss = false
		add_child(enemy_instance5)
		var enemy_instance6 = skeleton_scene.instantiate()
		enemy_instance6.position = $halftimecreatepoint6.position
		enemy_instance6.boss = false
		add_child(enemy_instance6)
		var enemy_instance7 = skeleton_scene.instantiate()
		enemy_instance7.position = $halftimecreatepoint7.position
		enemy_instance7.boss = true
		add_child(enemy_instance7)
		halftime = true


func _on_exit_body_entered(body):
	if body.has_method("player") and global.player_key_2 and global.player_dash_upgrade == true and global.player_throw_upgrade == true:
		global.transition_scene = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		global.finish_changescenes("level_1")
	elif body.has_method("player") and (global.player_key_2 == false or global.player_dash_upgrade == false or global.player_throw_upgrade == false):
		var signposition = $exit_text_box.position
		DialogManager.start_dialog(signposition, ["Find the Treasures in this area \n before continuing."])


func _on_open_door_body_entered(body):
	var tile : Vector2 = $TileMap.local_to_map($DoorGlyphLocation.global_position)
	$TileMap.set_cell(3, tile, -1, Vector2i(0,0),0)
	$sfx/MagicPillar.play()
