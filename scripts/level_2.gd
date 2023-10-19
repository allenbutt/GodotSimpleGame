extends Node2D

const mushroom_scene = preload("res://scenes/enemymushroom.tscn")
const goblin_scene = preload("res://scenes/enemygoblin.tscn")

var bosses_spawn = false

func _ready():
	if global.coming_from_pit == true:
		$player.position.x = $hole_exit.position.x
		$player.position.y = $hole_exit.position.y
		$enemygoblin9.queue_free()
		$enemygoblin11.queue_free()
	else:
		self.modulate = "000000"
		global.fade_in()
		music_player.play_song("level_2")


func _process(delta):
	pass


func _on_exit_body_entered(body):
	if body.has_method("player") and global.player_key_1 and global.player_fire_upgrade:
		global.coming_from_level_2 = true
		global.transition_scene = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		global.finish_changescenes("level_1")
	elif body.has_method("player") and (global.player_key_1 == false or global.player_fire_upgrade == false):
		var signposition = $exit_message_box.position
		DialogManager.start_dialog(signposition, ["Find the Treasures in this area \n before continuing."])

func _on_hole_body_entered(body):
	if body.has_method("player") and global.player_fire_upgrade == false:
		global.transition_scene = true
		get_tree().change_scene_to_file("res://scenes/hole_secret.tscn")
		global.finish_changescenes("hole_secret")


func _on_spawn_bosses_body_entered(body):
	if bosses_spawn == false:
		bosses_spawn = true
		var enemy_instance1 = goblin_scene.instantiate()
		enemy_instance1.position = $goblin_boss_spawn.position
		enemy_instance1.boss = true
		add_child(enemy_instance1)
		var enemy_instance2 = mushroom_scene.instantiate()
		enemy_instance2.position = $mushroom_boss_spawn.position
		enemy_instance2.boss = true
		add_child(enemy_instance2)


func _on_exit_bottom_body_entered(body):
	if body.has_method("player") and global.player_key_1 and global.player_fire_upgrade:
		global.coming_from_level_2_bottom = true
		global.transition_scene = true
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		global.finish_changescenes("level_1")
	elif body.has_method("player") and (global.player_key_1 == false or global.player_fire_upgrade == false):
		var signposition = $exit_message_box_bottom.position
		DialogManager.start_dialog(signposition, ["Find the Treasures in this area \n before continuing."])
