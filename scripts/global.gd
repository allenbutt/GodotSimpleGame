extends Node

var current_player = null
var player_current_attack = false
var player_dash_attack = false
var player_dash_invul = false
var player_dash_ready = true
var player_throw_ready = true

var player_dash_upgrade = false
var player_throw_upgrade = false
var player_fire_upgrade = false
var player_key_1 = false
var player_key_2 = false
var dungeon_key_1 = false
var dungeon_key_2 = false
var dungeon_key_3 = false
var dungeon_key_4 = false

#var current_scene = "level_3"
var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 481
var player_exit_cliffside_posy = 33
var player_start_posx = 11
var player_start_posy = 58
var player_exit_level2to1_posx = 1317
var player_exit_level2to1_posy = 486

var game_first_loadin = true
var coming_from_level_2 = false
var coming_from_level_2_bottom = false
var coming_from_level_3 = false
var coming_from_pit = false
var pit_complete = false

var player_damage = 20
var player_dash_damage = 20
var player_throw_damage = 15

var slime_damage = 6
var enemy_player_damage = 12
var goblin_damage = 11
var goblin_bomb_damage = 18
var mushroom_damage = 14
var mushroom_projectile_damage = 12
var skeleton_damage = 17
var skeleton_projectile_damage = 10
var bat_damage = 12
var final_boss_damage = 13
var final_boss_projectile = 8
var spike_damage = 7


#Temp Variables for Game Over
var temp_player_dash_upgrade = false
var temp_player_throw_upgrade = false
var temp_player_fire_upgrade = false
var temp_player_key_1 = false
var temp_player_key_2 = false
var temp_dungeon_key_1 = false
var temp_dungeon_key_2 = false
var temp_dungeon_key_3 = false
var temp_dungeon_key_4 = false
var temp_current_scene = "world"
var temp_game_first_loadin = true
var temp_coming_from_level_2 = false
var temp_coming_from_level_2_bottom = false
var temp_coming_from_level_3 = false
var temp_coming_from_pit = false
var temp_pit_complete = false


func finish_changescenes(newscene):
	var skip_temps = false
	if global.current_scene == "cliff_side" or global.current_scene == "hole_secret" \
	 or newscene == "cliff_side" or newscene == "hole_secret":
		skip_temps = true
	if transition_scene == true:
		transition_scene = false
		current_scene = newscene
	player_current_attack = false
	player_dash_attack = false
	player_dash_invul = false
	player_dash_ready = true
	player_throw_ready = true
	if skip_temps == false:
		global.set_temp_variables()

func set_temp_variables():
	temp_player_dash_upgrade = player_dash_upgrade
	temp_player_throw_upgrade = player_throw_upgrade
	temp_player_fire_upgrade = player_fire_upgrade
	temp_player_key_1 = player_key_1
	temp_player_key_2 = player_key_2
	temp_dungeon_key_1 = false
	temp_dungeon_key_2 = false
	temp_dungeon_key_3 = false
	temp_dungeon_key_4 = false
	temp_current_scene = current_scene
	temp_game_first_loadin = game_first_loadin
	temp_coming_from_level_2 = coming_from_level_2
	temp_coming_from_level_2_bottom = coming_from_level_2_bottom
	temp_coming_from_level_3 = coming_from_level_3
	temp_coming_from_pit = coming_from_pit
	temp_pit_complete = pit_complete

func load_temp_variables():
	player_dash_upgrade = temp_player_dash_upgrade
	player_throw_upgrade = temp_player_throw_upgrade
	player_fire_upgrade = temp_player_fire_upgrade
	player_key_1 = temp_player_key_1
	player_key_2 = temp_player_key_2
	dungeon_key_1 = false
	dungeon_key_2 = false
	dungeon_key_3 = false
	dungeon_key_4 = false
	current_scene = temp_current_scene
	game_first_loadin = temp_game_first_loadin
	coming_from_level_2 = temp_coming_from_level_2
	coming_from_level_2_bottom = temp_coming_from_level_2_bottom
	coming_from_level_3 = temp_coming_from_level_3
	coming_from_pit = temp_coming_from_pit
	pit_complete = temp_pit_complete
	player_dash_attack = false
	player_dash_invul = false
	player_dash_ready = true
	player_throw_ready = true

func reload_game():
	load_temp_variables()
	if current_scene == "world":
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	elif current_scene == "level_1":
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	elif current_scene == "cliff_side":
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
	elif current_scene == "level_2":
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	elif current_scene == "hole_secret":
		get_tree().change_scene_to_file("res://scenes/hole_secret.tscn")
	elif current_scene == "level_3":
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	elif current_scene == "level_4":
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")
	elif current_scene == "level_final_boss":
		get_tree().change_scene_to_file("res://scenes/level_final_boss.tscn")

func fade_in():
	var fade_time = 0.05
	get_tree().current_scene.modulate = "000000"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "131313"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "282828"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "363636"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "494949"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "5c5c5c"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "6f6f6f"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "939393"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "a7a7a7"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "c5c5c5"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "ededed"
	await get_tree().create_timer(fade_time).timeout
	get_tree().current_scene.modulate = "ffffff"
	await get_tree().create_timer(fade_time).timeout
