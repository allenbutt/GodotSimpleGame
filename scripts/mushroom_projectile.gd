extends Node2D

@export var speed = 55
@export var lifetime = 1.2
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
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_timer_timeout():
	queue_free()


func _on_impact_detector_area_entered(area):
	queue_free()
	pass
