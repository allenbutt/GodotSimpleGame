extends Node2D

@export var speed = 50
var direction = Vector2.ZERO

var travel = true

func _ready():
	set_as_top_level(true)
	$Sprite2D/AnimationPlayer.play("ready")
	$movement_timer.start(randf_range(0.35,0.7))
	$sfx/BombStart.play()
	
func _process(delta):
	pass

func _physics_process(delta):
	if travel == true:
		position += direction * speed * delta


func _on_movement_timer_timeout():
	travel = false


func _on_destroy_timer_timeout():
	#queue_free()
	pass


func _on_animation_player_animation_finished(anim_name):
	queue_free()

func _bomb_sound():
	$sfx/BombStart.stop()
	$sfx/BombExplode.play()

