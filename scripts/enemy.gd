extends CharacterBody2D

@export var speed = 35
var player_chase = false
var player = null

@export var health_max = 35
@export var boss = false
@export var boss2 = false
var health = health_max
var player_inattack_zone = false
var can_take_damage = true
var alive = true
var knockeddir = Vector2(0,0)
var knockback = false
var on_fire = false

func _ready():
	if boss == true:
		$AnimatedSprite2D.self_modulate = Color.ORANGE
		health_max = 100
		speed = 45
		self.scale = Vector2(1.25,1.25)
	if boss2 == true:
		$AnimatedSprite2D.self_modulate = Color.RED
		health_max = 150
		speed = 65
		self.scale = Vector2(1.5,1.5)
	
	health = health_max
	$healthbar.max_value = health_max

func _physics_process(delta):
	deal_with_damage()
	update_health()
	if alive == true:
		if player_chase:
			
			var direction = Vector2.ZERO
			$AnimatedSprite2D.play("walk")
			if(player.position.x - position.x) > 0:
				direction.x += 1
				if(player.position.x - position.x) > 5:
					$AnimatedSprite2D.flip_h = false
			else:
				if(player.position.x - position.x) < 5:
					$AnimatedSprite2D.flip_h = true
				direction.x -= 1
				
			if(player.position.y - position.y) < 0:
				direction.y -= 1
			else:
				direction.y += 1
			
			direction = direction.normalized()
			
			if knockback == false:
				direction = direction.normalized()
				velocity.x = direction.x * speed * delta * 60
				velocity.y = direction.y * speed * delta * 60
			else:
				direction = knockeddir.normalized()
				velocity.x = direction.x * speed * delta * 60 * 5
				velocity.y = direction.y * speed * delta * 60 * 5
				$AnimatedSprite2D.play("idle")
			
			move_and_slide()
			
		else: $AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
#	player = null
#	player_chase = false
	pass

func enemy():
	pass
	
func enemyslime():
	pass




func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true and alive == true:
		if can_take_damage:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				$death_timer.start()
				$AnimatedSprite2D.play("death")
				alive = false


func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= health_max:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_death_timer_timeout():
	self.queue_free()


func _on_enemy_hitbox_area_entered(area):
	if can_take_damage:
		if player == null:
			player = global.current_player
			player_chase = true
		var sourcepoint = Vector2(player.position.x, player.position.y)
		knockeddir = transform.origin - sourcepoint
		$Knockback_Timer.start()
		knockback = true
		can_take_damage = false
		health = health - area.damage
		$take_damage_cooldown.start()
		if alive:
			$sfx/EnemyHit.play()
		if health <= 0 and alive:
			set_collision_layer_value(3,0)
			$death_timer.start()
			$AnimatedSprite2D.play("death")
			alive = false
			$sfx/SlimeDeath.play()
		if alive:
			if global.player_fire_upgrade and area.fire:
				on_fire = true
				$FireAnimation.visible = true
				$FireDuration.start()
				$FireDamage.start()
			if boss2 == true:
				$AnimatedSprite2D.self_modulate = Color.BLACK
			else:
				$AnimatedSprite2D.self_modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			if boss2 == true:
				$AnimatedSprite2D.self_modulate = Color.RED
			elif boss == true:
				$AnimatedSprite2D.self_modulate = Color.ORANGE
			else:
				$AnimatedSprite2D.self_modulate = Color.WHITE


func _on_knockback_timer_timeout():
	knockback = false


func _on_follow_area_body_exited(body):
	player = null
	player_chase = false

func _on_fire_duration_timeout():
	on_fire = false
	$FireAnimation.visible = false
	$FireDamage.stop()


func _on_fire_damage_timeout():
	health = health - 1.0
	if health <= 0 and alive:
		set_collision_layer_value(3,0)
		$death_timer.start()
		$AnimatedSprite2D.play("death")
		alive = false
		$sfx/SlimeDeath.play()
