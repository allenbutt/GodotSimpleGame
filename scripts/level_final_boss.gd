extends Node2D

var boss_start = false


func _ready():
	self.modulate = "000000"
	global.fade_in()
	$enemyfinalboss.arena = $ArenaMap/CollisionShape2D
	get_node("enemyfinalboss").boss_death.connect(_boss_death_signal_received)
	get_node("Chest").chest_opened.connect(_chest_open_signal_received)
	music_player.play_song("level_final_boss")

func _on_boss_trigger_body_entered(body):
	if boss_start == false:
		boss_start = true
		$StartDoorCollision/CollisionShape2D.set_deferred("disabled", false)
		var tile : Vector2 = $TileMap.local_to_map($StartDoorTileLocation.position)
		tile.x = tile.x-0
		tile.y = tile.y+0
		$sfx/DoorOpen.play()
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(18,7),0)
		await get_tree().create_timer(0.025).timeout
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(16,7),0)
		await get_tree().create_timer(0.025).timeout
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(14,7),0)
		await get_tree().create_timer(0.025).timeout
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(12,7),0)
		await get_tree().create_timer(0.025).timeout
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(6,7),0)
		await get_tree().create_timer(0.15).timeout
		$TileMapDoor.set_cell(2, tile, 7, Vector2i(6,5),0)

func _boss_death_signal_received():
	await get_tree().create_timer(1.0).timeout
	$EndDoorCollision/CollisionShape2D.set_deferred("disabled", true)
	var tile : Vector2 = $TileMap.local_to_map($EndDoorTileLocation.position)
	tile.x = tile.x-0
	tile.y = tile.y+0
	$sfx/DoorOpen.play()
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(8,7),0)
	await get_tree().create_timer(0.2).timeout
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(12,7),0)
	await get_tree().create_timer(0.1).timeout
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(14,7),0)
	await get_tree().create_timer(0.1).timeout
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(16,7),0)
	await get_tree().create_timer(0.1).timeout
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(18,7),0)
	await get_tree().create_timer(0.1).timeout
	$TileMapDoor.set_cell(2, tile, 7, Vector2i(8,5),0)

func _chest_open_signal_received():
	$Riches01.visible = true
	$Riches02.visible = true
	$Riches03.visible = true
	$Riches04.visible = true
	$Riches05.visible = true
	$Riches06.visible = true
	$Riches07.visible = true
	$Riches08.visible = true
	$Riches09.visible = true
	$Riches10.visible = true
	$Riches11.visible = true
	$Riches12.visible = true
	$Riches13.visible = true
	$Riches14.visible = true
	$Riches15.visible = true
	$Riches16.visible = true
	$Riches17.visible = true
	$Riches18.visible = true
	$Riches19.visible = true
	$Riches20.visible = true
	await get_tree().create_timer(6).timeout
	get_tree().quit()
