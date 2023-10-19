extends TileMap

var door_coordinates = Vector2()
var notificationposition = Vector2()
var door_collision

var door_opened = false

func _ready():
	pass

func set_door_coordinates(new_coordinates, new_door_collision):
	door_coordinates.x = new_coordinates.x
	door_coordinates.y = new_coordinates.y
	door_collision = new_door_collision


func _process(delta):
	pass


func _on_open_door_body_entered(body):
	if door_opened == false:
		door_opened = true
		await get_tree().create_timer(1.0).timeout
		var tile : Vector2 = local_to_map(door_coordinates)
		door_collision.queue_free()
		self.set_cell(2, tile, 20, Vector2i(0,5),0)
		DialogManager.start_dialog(notificationposition, ["Tunnel door has been opened."])
