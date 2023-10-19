extends Node2D

const boss_scene = preload("res://scenes/enemyperson.tscn")

var door_1_opened = false
var door_2_opened = false
var door_3_opened = false
var door_4_opened = false
var boss_spawned = false

func _ready():
	self.modulate = "000000"
	global.fade_in()
	music_player.play_song("level_4")

func _on_door_1_open_body_entered(body):
	if body.has_method("player") and global.dungeon_key_1 and door_1_opened == false:
		door_1_opened = true
		var tile : Vector2 = $TileMap.local_to_map($Door1Open/CollisionShape2D.position)
		tile.x = tile.x-4
		tile.y = tile.y+3
		$sfx/DoorOpen.play()
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,7),0)
		await get_tree().create_timer(0.2).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(10,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(12,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(14,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,5),0)
		await get_tree().create_timer(0.1).timeout
		$DoorCollisions/Door1.queue_free()


func _on_door_2_open_body_entered(body):
	if body.has_method("player") and global.dungeon_key_2 and door_2_opened == false:
		door_2_opened = true
		var tile : Vector2 = $TileMap.local_to_map($Door2Open/CollisionShape2D.position)
		tile.x = tile.x-6
		tile.y = tile.y+6
		$sfx/DoorOpen.play()
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,7),0)
		await get_tree().create_timer(0.2).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(10,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(12,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(14,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,5),0)
		await get_tree().create_timer(0.1).timeout
		$DoorCollisions/Door2.queue_free()


func _on_door_3_open_body_entered(body):
	if body.has_method("player") and global.dungeon_key_3 and door_3_opened == false:
		door_3_opened = true
		var tile : Vector2 = $TileMap.local_to_map($Door3Open/CollisionShape2D.position)
		tile.x = tile.x-12
		tile.y = tile.y+6
		$sfx/DoorOpen.play()
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,7),0)
		await get_tree().create_timer(0.2).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(10,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(12,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(14,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,5),0)
		await get_tree().create_timer(0.1).timeout
		$DoorCollisions/Door3.queue_free()


func _on_door_4_open_body_entered(body):
	if body.has_method("player") and global.dungeon_key_4 and door_4_opened == false:
		door_4_opened = true
		var tile : Vector2 = $TileMap.local_to_map($Door4Open/CollisionShape2D.position)
		tile.x = tile.x-3
		tile.y = tile.y+10
		$sfx/DoorOpen.play()
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,7),0)
		await get_tree().create_timer(0.2).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(10,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(12,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(14,7),0)
		await get_tree().create_timer(0.1).timeout
		$TileMapDoors.set_cell(2, tile, 7, Vector2i(8,5),0)
		await get_tree().create_timer(0.1).timeout
		$DoorCollisions/Door4.queue_free()


func _on_boss_trigger_body_entered(body):
	if body.has_method("player") and boss_spawned == false:
		boss_spawned = true
		var boss_instance1 = boss_scene.instantiate()
		boss_instance1.position = $Boss_Create_Point.position
		boss_instance1.boss = true
		add_child(boss_instance1)

func _on_exit_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		get_tree().change_scene_to_file("res://scenes/level_final_boss.tscn")
		global.finish_changescenes("level_final_boss")
