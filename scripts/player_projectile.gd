extends Node2D

@export var speed = 400.0
@export var lifetime = 0.75
var direction = Vector2.ZERO

@onready var timer = $Timer
@onready var hitbox = $AttackHitboxArea
@onready var sprite = $Sprite2D
@onready var impact_detector = $ImpactDetector



func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	#direction = Vector2.RIGHT
	timer.start(lifetime)
	


func _process(delta):
	pass

func _physics_process(delta):
	position += direction * speed * delta


func _on_impact_detector_body_entered(body):
	if body.has_method("enemy") == true:
		if body.alive == true:
			queue_free()
	else:
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_impact_detector_area_entered(area):
	pass
#	queue_free()
