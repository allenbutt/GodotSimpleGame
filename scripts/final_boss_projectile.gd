extends Node2D

@export var speed = 150
@export var lifetime = 1.8
var direction = Vector2.ZERO

var frames = 0
var color_toggle = 0

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
	frames += 1
	if frames < 10 and color_toggle == 0:
		$AnimatedSprite2D.self_modulate = Color.WHITE 
		color_toggle = 1
		frames = 0
	elif frames < 10  and color_toggle == 1:
		$AnimatedSprite2D.self_modulate = Color.PURPLE 
		color_toggle = 0
		frames = 0

func _physics_process(delta):
	if exploding == false:
		position += direction * speed * delta


func _on_impact_detector_body_entered(body):
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	$sfx/FinalBossProjectileExplode.play()
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_timer_timeout():
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	$AnimatedSprite2D.play("explode")
	$sfx/FinalBossProjectileExplode.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_impact_detector_area_entered(area):
	$AttackHitboxArea/AttackCollision.disabled = true
	$ImpactDetector/ImpactCollision.disabled = true
	exploding = true
	$AnimatedSprite2D.play("explode")
	$sfx/FinalBossProjectileExplode.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()
