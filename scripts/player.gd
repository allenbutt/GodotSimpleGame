extends CharacterBody2D

const player_projectile_scene = preload("res://scenes/player_projectile.tscn")
@onready var shoot_position = $ShootPositionSide

const speedstart = 60
var speed = speedstart
var current_dir = "right"

var enemy_inattack_range = false
var in_spikes = false
var enemy_attack_cooldown = true
var health_max = 100
var health = health_max
var player_alive = true

var attack_ip = false
var throw_ip = false

var regen = false

func _ready():
	$healthbar.max_value = health_max
	global.current_player = self

func _physics_process(delta):
	if player_alive:
		current_camera()
		player_movement(delta)
		enemy_attack()
		spike_attack()
		attack()
		update_health()
		if health <= 0:
			player_alive = false
			health = 0
			music_player._fade_out(music_player.current_song)
			$PlayerSprite/PlayerAnimations.play("death")
			$sfx/PlayerDeath.play()
			var fade_wait = 0.05
			await get_tree().create_timer(0.5).timeout
			get_tree().current_scene.modulate = "ffefec"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ffe6e1"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ffd6ce"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ffc2b6"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ffb0a1"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ff9885"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ff7862"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ff614a"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ff3f27"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "f21f00"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "e11c00"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "ce1900"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "a81200"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "960f00"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "780a00"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "600600"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "400300"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "2b0100"
			await get_tree().create_timer(fade_wait).timeout
			get_tree().current_scene.modulate = "000000"
			await get_tree().create_timer(1).timeout
			global.reload_game()

func player_movement(delta):
	var direction = Vector2.ZERO
	var dash_bonus = 1
	if global.player_dash_attack:
		dash_bonus = 3.5
	else:
		dash_bonus = 1
	if Input.is_action_pressed("shift") and global.player_dash_attack == false:
		speed = speedstart * 1.5
	else:
		speed = speedstart
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	if direction.x > 0:
		current_dir = "right"
		play_anim(1)
	elif direction.x < 0:
		current_dir = "left"
		play_anim(1)
	elif direction.y > 0:
		current_dir = "down"
		play_anim(1)
	elif direction.y < 0:
		current_dir = "up"
		play_anim(1)
	else:
		play_anim(0)
	velocity.x = direction.x * speed * dash_bonus
	velocity.y = direction.y * speed * dash_bonus
	
#	if  global.player_current_attack == false:
#		move_and_slide()
		
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $PlayerSprite/PlayerAnimations
	var sprite = $PlayerSprite
	if attack_ip == false and throw_ip == false:
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
		if Input.is_action_pressed("shift"):
			anim.speed_scale = 2
		else:
			anim.speed_scale = 1

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemyslime") and body.alive == true:
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemyslime"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true and global.player_dash_invul == false:
		health = health - global.slime_damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		regen = false
		$regen_cooldown.start()
		if player_alive:
			$sfx/PlayerHit.play()
		$PlayerSprite.self_modulate = Color.RED
		$healthbar.self_modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$PlayerSprite.self_modulate = Color.WHITE
		$healthbar.self_modulate = Color.WHITE

func spike_attack():
	if in_spikes and enemy_attack_cooldown:
		health = health - global.spike_damage
		enemy_attack_cooldown = false
		$attack_cooldown.start(0.5)
		regen = false
		$regen_cooldown.start()
		if player_alive:
			$sfx/PlayerHit.play()
		$PlayerSprite.self_modulate = Color.RED
		$healthbar.self_modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$PlayerSprite.self_modulate = Color.WHITE
		$healthbar.self_modulate = Color.WHITE


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	var anim = $PlayerSprite/PlayerAnimations
	var sprite = $PlayerSprite
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("shift") == false and global.player_current_attack == false:
		global.player_current_attack = true
		if global.player_fire_upgrade:
			$sfx/PlayerAttackFire.play()
		else:
			$sfx/PlayerAttack.play()
		attack_ip = true
		if dir == "right":
			sprite.scale = Vector2(1,1)
			if global.player_fire_upgrade:
				anim.play("side_attack_fire")
			else:
				anim.play("side_attack")
		if dir == "left":
			sprite.scale = Vector2(-1,1)
			if global.player_fire_upgrade:
				anim.play("side_attack_fire")
			else:
				anim.play("side_attack")
		if dir == "down":
			if global.player_fire_upgrade:
				anim.play("front_attack_fire")
			else:
				anim.play("front_attack")
		if dir == "up":
			if global.player_fire_upgrade:
				anim.play("back_attack_fire")
			else:
				anim.play("back_attack")
		$deal_attack_timer.start(0.4)
	elif Input.is_action_just_pressed("dash") and global.player_dash_ready \
		and global.player_dash_upgrade:
		#global.player_current_attack = true
		global.player_dash_attack = true
		global.player_dash_invul = true
		global.player_dash_ready = false
		attack_ip = true
		if global.player_fire_upgrade:
			$sfx/PlayerDash.play()
			anim.play("side_dash_fire")
		else:
			$sfx/PlayerDash.play()
			anim.play("side_dash")
		$deal_attack_timer.start(0.6)
		$dash_invul.start()
		$dash_effect.start()
		$dash_cooldown.start()
		#set_collision_mask_value(3,0)
	elif Input.is_action_just_pressed("ranged_attack") and global.player_throw_ready \
		 and Input.is_action_pressed("shift") == false and global.player_throw_upgrade:
		throw_ip = true
		global.player_throw_ready = false
		$throw_cooldown.start()
		$sfx/PlayerThrow.play()
		dir = _determine_direction(Vector2(position.x, position.y),get_global_mouse_position())
		if dir == "right":
			sprite.scale = Vector2(1,1)
			anim.play("side_throw")
			shoot_position = $ShootPositionSide
		if dir == "left":
			sprite.scale = Vector2(-1,1)
			anim.play("side_throw")
			shoot_position = $ShootPositionSide
		if dir == "down":
			anim.play("front_throw")
			shoot_position = $ShootPositionFront
		if dir == "up":
			anim.play("back_throw")
			shoot_position = $ShootPositionBack
		await get_tree().create_timer(0.1).timeout
		var projectile_instance = player_projectile_scene.instantiate()
		projectile_instance.position = shoot_position.global_position
		projectile_instance.direction = global_position.direction_to(get_global_mouse_position())
		add_child(projectile_instance)
		await get_tree().create_timer(0.2).timeout
		throw_ip = false


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func current_camera():
	if global.current_scene == "world":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 721
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 319
		$player_camera.zoom = Vector2(8,8)
	elif global.current_scene == "cliff_side":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 305
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 200
		$player_camera.zoom = Vector2(12,12)
	elif global.current_scene == "level_1":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 1350
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 720
		$player_camera.zoom = Vector2(8,8)
	elif global.current_scene == "level_2":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 1044
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 802
		$player_camera.zoom = Vector2(8,8)
	elif global.current_scene == "level_3":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 879
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 755
		$player_camera.zoom = Vector2(8,8)
	elif global.current_scene == "hole_secret":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 383
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 142
		$player_camera.zoom = Vector2(12,12)
	elif global.current_scene == "level_4":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 1245
		$player_camera.limit_top = 0
		$player_camera.limit_bottom = 940
		$player_camera.zoom = Vector2(8,8)
	elif global.current_scene == "level_final_boss":
		$player_camera.limit_left = 0
		$player_camera.limit_right = 450
		$player_camera.limit_top = -50
		$player_camera.limit_bottom = 480
		$player_camera.zoom = Vector2(10,10)


func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= health_max:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_regen_timer_timeout():
	if health < health_max and regen:
		health = health + 1.5
		if health > health_max:
			health = health_max
	if health <= 0:
		health = 0



func _on_dash_effect_timeout():
	global.player_dash_attack = false
	#set_collision_mask_value(3,1)


func _on_dash_invul_timeout():
	global.player_dash_invul = false


func _on_dash_cooldown_timeout():
	global.player_dash_ready = true


func _on_player_hitbox_enemyplayer_area_entered(area):
	if enemy_attack_cooldown:
		health = health - area.damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		regen = false
		$regen_cooldown.start()
		if player_alive:
			$sfx/PlayerHit.play()
		$PlayerSprite.self_modulate = Color.RED
		$healthbar.self_modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$PlayerSprite.self_modulate = Color.WHITE
		$healthbar.self_modulate = Color.WHITE


func _on_throw_cooldown_timeout():
	global.player_throw_ready = true

func _determine_direction(origin, target):
	var direction_calc = Vector2.ZERO
	var direction_return
	if(target.x - origin.x) > 0:
		direction_calc.x += 1
		if(target.x - origin.x) > 5:
			direction_return = "right"
	else:
		if(target.x - origin.x) < 5:
			pass
			direction_return = "left"
		direction_calc.x -= 1
		
	if(target.y - origin.y) < 0:
		direction_calc.y -= 1
	else:
		direction_calc.y += 1
	
	if(origin.y - target.y > abs(target.x - origin.x)):
		direction_return = "up"
	if(target.y - origin.y > abs(target.x - origin.x)):
		direction_return = "down"
	return direction_return


func _on_player_hitbox_area_entered(area):
	if area.has_method("spike"):
		in_spikes = true


func _on_player_hitbox_area_exited(area):
	if area.has_method("spike"):
		in_spikes = false


func _on_regen_cooldown_timeout():
	regen = true
