extends CharacterBody2D

const skeleton_projectile = preload("res://scenes/skeleton_projectile.tscn")
const final_boss_projectile = preload("res://scenes/final_boss_projectile.tscn")
const goblin_projectile_scene = preload("res://scenes/goblin_bomb.tscn")
@onready var shoot_position = $ShootPosition_Left

@export var speed = 120
var player_chase = false
var player = null
var melee_distance = false

@export var health_max = 1800
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
var teleport_to = Vector2(0,0)
var arena

var halfway = false
var near_death = false

signal boss_death

func _ready():
	$PlayerSprite.scale = Vector2(1,1)
	health = health_max
	$healthbar.max_value = health_max

func _physics_process(delta):
	if health <= health_max * 0.67 and halfway == false:
		speed = 160
		$PlayerSprite/PlayerAnimations.set_speed_scale(1.5)
		halfway = true
	if health <= health_max * 0.33 and near_death == false:
		speed = 200
		$PlayerSprite/PlayerAnimations.set_speed_scale(2.0)
		near_death = true
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
			
			direction = direction.normalized()
			
			direction = direction.normalized()
			velocity.x = direction.x * speed * delta * 60
			velocity.y = direction.y * speed * delta * 60
			play_anim(1)
			if attack_ip == false:
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
	emit_signal("boss_death")	
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
			$FireAnimation.visible = false
			$PlayerSprite/PlayerAnimations.set_speed_scale(1)
			set_collision_layer_value(3,0)
			$death_timer.start()
			$PlayerSprite/PlayerAnimations.play("death")
			$sfx/FinalBossDeath.play()
			alive = false
			await get_tree().create_timer(0.9).timeout
			$sfx/FinalBossDeathExplode.play()
			$sfx/BombExplode.play()
		if alive:
			if global.player_fire_upgrade and area.fire:
				on_fire = true
				$FireAnimation.visible = true
				$FireDuration.start()
				$FireDamage.start()
			$PlayerSprite.self_modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$PlayerSprite.self_modulate = Color.WHITE


func _on_knockback_timer_timeout():
	knockback = false


func _on_attack_range_body_entered(body):
	target = body

func _attack_target():
	var attack_animation_name
	if randi_range(0,3) <= 2 and melee_distance:
		attack_animation_name = "side_attack"
	else:
		attack_animation_name = "ranged_attack"
	if target != null and attack_ip == false and randf_range(0,1) > 0.80:
		var dir = current_dir
		var anim = $PlayerSprite/PlayerAnimations
		var sprite = $PlayerSprite
		if attack_ip == false:
			attack_ip = true
			if randi_range(0,1) > 0:
				attack_animation_name = "teleport"
			if dir == "right":
				sprite.scale = Vector2(1,1)
				anim.play(attack_animation_name)
				$AttackTimer.start(anim.current_animation_length / anim.speed_scale)
			if dir == "left":
				sprite.scale = Vector2(-1,1)
				anim.play(attack_animation_name)
				$AttackTimer.start(anim.current_animation_length / anim.speed_scale)
			if attack_animation_name == "teleport":
				$sfx/FinalBossTeleport.play()
			elif attack_animation_name == "ranged_attack":
				$sfx/FinalBossChargeUp.play()


func _on_attack_timer_timeout():
	attack_ip = false


func _on_attack_range_body_exited(body):
	target = null


func _on_follow_area_body_exited(body):
	player = null
	player_chase = false

func ranged_attack():
	$sfx/FinalBossChargeUp.stop()
	var projectile_instance
	var projectiles_upper_range
	if near_death:
		projectiles_upper_range = 5
	elif halfway:
		projectiles_upper_range = 4
	else:
		projectiles_upper_range = 3
	for projectiles in range(0,projectiles_upper_range):
		if $PlayerSprite.scale == Vector2(1,1):
			shoot_position = $ShootPosition_Right
		else:
			shoot_position = $ShootPosition_Left
		projectile_instance = final_boss_projectile.instantiate()
		projectile_instance.position = shoot_position.global_position
		projectile_instance.direction = Vector2(player.position.x-position.x+randf_range(-40,40),player.position.y-position.y+randf_range(-40,60)).normalized()
		$sfx/FinalBossRangedAttack.play(0.23)
		add_child(projectile_instance)
		
		await get_tree().create_timer(0.1 / $PlayerSprite/PlayerAnimations.speed_scale).timeout

func teleport():
	var projectile_instance = goblin_projectile_scene.instantiate()
	projectile_instance.position = self.global_position
	projectile_instance.scale = Vector2(1.25,1.25)
	projectile_instance.modulate = Color.PURPLE
	add_child(projectile_instance)
	var teleport_to = _get_random_point_in_arena()
	self.position = teleport_to

func _on_melee_range_body_entered(body):
	melee_distance = true

func _on_melee_range_body_exited(body):
	melee_distance = false


func _on_fire_duration_timeout():
	on_fire = false
	$FireAnimation.visible = false
	$FireDamage.stop()


func _on_fire_damage_timeout():
	health = health - 1.0
	if health <= 0 and alive:
		$FireAnimation.visible = false
		$PlayerSprite/PlayerAnimations.set_speed_scale(1)
		set_collision_layer_value(3,0)
		$death_timer.start()
		$PlayerSprite/PlayerAnimations.play("death")
		alive = false
		$sfx/FinalBossDeath.play()
		await get_tree().create_timer(0.9).timeout
		$sfx/FinalBossDeathExplode.play()
		$sfx/BombExplode.play()

func _get_random_point_in_arena():
	return(Vector2(arena.position.x + randf_range(0,arena.get_shape().get_size().x),arena.position.y + randf_range(0,arena.get_shape().get_size().y)))

func _melee_attack_sound():
	$sfx/FinalBossAttack.play()
