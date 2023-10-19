extends Node2D

var opened = false
@export var content = ""

signal chest_opened

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_player_collision_body_entered(body):
	if opened == false and $EnemyMonstersCheck.get_overlapping_bodies().size() <= 0:
		$Sprite2D.frame = 9
		opened = true
		emit_signal("chest_opened")
		$sfx/ChestOpen.play()
		var chestposition = Vector2(position.x+10, position.y + 16)
		if content == "fire_sword":
			global.player_fire_upgrade = true
			DialogManager.start_dialog(chestposition, ["You found the Fire Sword!\nYour sword attacks will ignite enemies."])
			$SpriteContent.frame = 348
		elif content == "key_1":
			global.player_key_1 = true
			$SpriteContent.frame = 206
			if global.player_key_2:
				DialogManager.start_dialog(chestposition, ["You found a Key!\nYou can now enter the Castle."])
			else:
				DialogManager.start_dialog(chestposition, ["You found a Key!\nYou need one more to enter the Castle."])
		elif content == "key_2":
			global.player_key_2 = true
			$SpriteContent.frame = 198
			if global.player_key_1:
				DialogManager.start_dialog(chestposition, ["You found a Key!\nYou can now enter the Castle."])
			else:
				DialogManager.start_dialog(chestposition, ["You found a Key!\nYou need one more to enter the Castle."])
		elif content == "random":
			if global.player_dash_upgrade == true:
				global.player_throw_upgrade = true
				DialogManager.start_dialog(chestposition, ["You found Throwing Knives!\nUse 'E' to perform a Throw Attack."])
				$SpriteContent.frame = 336
			elif global.player_throw_upgrade == true:
				global.player_dash_upgrade = true
				DialogManager.start_dialog(chestposition, ["You found the Dash Boots!\nUse Right-Click to perform a Dash Attack."])
				$SpriteContent.frame = 65
			else:
				var random = randi_range(0,1)
				if random == 0:
					global.player_dash_upgrade = true
					DialogManager.start_dialog(chestposition, ["You found the Dash Boots!\nUse Right-Click to perform a Dash Attack."])
					$SpriteContent.frame = 65
				else:
					global.player_throw_upgrade = true
					DialogManager.start_dialog(chestposition, ["You found Throwing Knives!\nUse 'E' to perform a Throw Attack."])
					$SpriteContent.frame = 336
		elif content == "dungeon_key_1":
			global.dungeon_key_1 = true
			$SpriteContent.frame = 199
			DialogManager.start_dialog(chestposition, ["You found a Dungeon Key!\nUse it to open a locked door."])
		elif content == "dungeon_key_2":
			global.dungeon_key_2 = true
			$SpriteContent.frame = 199
			DialogManager.start_dialog(chestposition, ["You found a Dungeon Key!\nUse it to open a locked door."])
		elif content == "dungeon_key_3":
			global.dungeon_key_3 = true
			$SpriteContent.frame = 199
			DialogManager.start_dialog(chestposition, ["You found a Dungeon Key!\nUse it to open a locked door."])
		elif content == "dungeon_key_4":
			global.dungeon_key_4 = true
			$SpriteContent.frame = 199
			DialogManager.start_dialog(chestposition, ["You found a Dungeon Key!\nUse it to open a locked door."])
		elif content == "treasure":
			$SpriteContent.frame = 128
			DialogManager.start_dialog(chestposition, ["You found Wealth!\nThank you for playing."])
		$SpriteContent.visible = true
		await get_tree().create_timer(3.0).timeout
		$SpriteContent.visible = false
