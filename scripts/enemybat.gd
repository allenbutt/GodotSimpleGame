extends CharacterBody2D

const fire = preload("res://scenes/fire_damage.tscn")
@onready var shoot_position = $ShootPosition_Left

@export var speed = 75
var player_chase = false
var player = null
var charge_ip = false
var charge_direction_temp = Vector2(0,0)
var charge_direction = Vector2(0,0)

@export var health_max = 65
@export var boss = false
var health = health_max
var player_inattack_zone = false
var can_take_damage = true
var alive = true
var knockeddir = Vector2(0,0)
var knockback = false
var current_dir = "left"
var attack_ip = false
var target = null
var on_fire = false

func _ready():
	health = health_max
	if boss == true:
#		$AnimatedSprite2D.self_modulate = Color.ORANGE
		health_max = health_max * 2
		speed = 95
		health = health_max
		self.scale = Vector2(1,1)
	$healthbar.max_value = health_max

func _physics_process(delta):
	update_health()
	if alive == true:
		if player_chase:
			var direction = Vector2.ZERO
			if(player.position.x - position.x) > 0:
				direction.x += 1
				if(player.position.x - position.x) > 5:
					current_dir = "right"
			else:
				if(player.position.x - position.x) < 5:
					pass
					current_dir = "left"
				direction.x -= 1
				
			if(player.position.y - position.y) < 0:
				direction.y -= 1
			else:
				direction.y += 1
			
#			if(position.y - player.position.y > abs(player.position.x - position.x)):
#				current_dir = "up"
#			if(player.position.y - position.y > abs(player.position.x - position.x)):
#				current_dir = "down"
			
			direction = direction.normalized()
			charge_direction_temp = direction
			if abs(position.y - player.position.y) < 1:
				charge_direction_temp.y = 0
			charge_direction_temp = charge_direction_temp.normalized()
			
			if charge_ip == true:
				if knockback == false:
					direction = charge_direction
					velocity.x = direction.x * speed * delta * 60
					velocity.y = direction.y * speed * delta * 60
					play_anim(1)
					move_and_slide()
				else:
					direction = knockeddir.normalized()
					velocity.x = direction.x * speed * delta * 60 * 5
					velocity.y = direction.y * speed * delta * 60 * 5
					play_anim(0)
					move_and_slide()
			
			else:
				if knockback == false:
					direction = direction.normalized()
					velocity.x = direction.x * speed * delta * 60
					velocity.y = direction.y * speed * delta * 60
					play_anim(1)
					if attack_ip == false:
						move_and_slide()
				else:
					direction = knockeddir.normalized()
					velocity.x = direction.x * speed * delta * 60 * 5
					velocity.y = direction.y * speed * delta * 60 * 5
					play_anim(0)
					move_and_slide()
					
		else: play_anim(0)
		_attack_target()

func play_anim(movement):
	var dir = current_dir
	var anim = $PlayerSprite/PlayerAnimations
	var sprite = $PlayerSprite
	if attack_ip == false and alive == true:
		if dir == "right":
			sprite.scale = Vector2(1,1)
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "left":
			sprite.scale = Vector2(-1,1)
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "down":
			sprite.scale = Vector2(1,1)
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_idle")
		if dir == "up":
			sprite.scale = Vector2(1,1)
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
#	player = null
#	player_chase = false
	pass

func enemy():
	pass


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
			$PlayerSprite/PlayerAnimations.play("death")
			alive = false
			$sfx/BatDeath.play()
		if alive:
			if global.player_fire_upgrade and area.fire:
				on_fire = true
				$FireAnimation.visible = true
				$FireDuration.start()
				$FireDamage.start()
			$PlayerSprite.self_modulate = Color.RED
#			if boss == false:
#				$PlayerSprite.self_modulate = Color.RED
#			else:
#				$PlayerSprite.self_modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$PlayerSprite.self_modulate = Color.WHITE
#			if boss == false:
#				$PlayerSprite.self_modulate = Color.WHITE
#			else:
#				$PlayerSprite.self_modulate = Color.ORANGE


func _on_knockback_timer_timeout():
	knockback = false


func _on_attack_range_body_entered(body):
	target = body

func _attack_target():
	var attack_animation_name
	if randi_range(0,1) == 0:
		attack_animation_name = "side_attack"
	else:
		attack_animation_name = "side_attack_2"
	if target != null and attack_ip == false and randf_range(0,1) > 0.80:
		var dir = current_dir
		var anim = $PlayerSprite/PlayerAnimations
		var sprite = $PlayerSprite
		if attack_ip == false:
			attack_ip = true
			if attack_animation_name == "side_attack_2":
				charge_ip = true
				$Charge_Attack_Timer.start()
				charge_direction = charge_direction_temp
			if dir == "right":
				sprite.scale = Vector2(1,1)
				anim.play(attack_animation_name)
				$AttackTimer.start()
			if dir == "left":
				sprite.scale = Vector2(-1,1)
				anim.play(attack_animation_name)
				$AttackTimer.start()
			if dir == "down":
				anim.play("front_attack")
				$AttackTimer.start()
			if dir == "up":
				anim.play("back_attack")
				$AttackTimer.start()
			if attack_animation_name == "side_attack_2":
				#await get_tree().create_timer(0.2).timeout
				$sfx/BatDash.play()
			else:
				await get_tree().create_timer(0.2).timeout
				$sfx/BatAttack.play()


func _on_attack_timer_timeout():
	attack_ip = false


func _on_attack_range_body_exited(body):
	target = null


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
		$PlayerSprite/PlayerAnimations.play("death")
		alive = false
		$sfx/BatDeath.play()


func _on_charge_attack_timer_timeout():
	charge_ip = false
