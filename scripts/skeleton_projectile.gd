extends Node2D

@export var speed = 40
@export var lifetime = 1.8
var direction = Vector2.ZERO

@onready var timer = $Timer
@onready var hitbox = $AttackHitboxArea
@onready var sprite = $Sprite2D
@onready var impact_detector = $ImpactDetector

var exploding = false

func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	#direction = Vector2.RIGHT
	timer.start(lifetime)
	


func _process(delta):
	speed += 1

func _physics_process(delta):
	if exploding == false:
		position += direction * speed * delta


func _on_impact_detector_body_entered(body):
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("explode")
	$sfx/SkeletonProjectile.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_timer_timeout():
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	$AnimatedSprite2D.play("explode")
	$sfx/SkeletonProjectile.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_impact_detector_area_entered(area):
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	$AnimatedSprite2D.play("explode")
	$sfx/SkeletonProjectile.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()
