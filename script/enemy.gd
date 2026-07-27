extends CharacterBody2D

@onready var player = get_node("/root/Main/player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $player_out
@onready var attacktimer: Timer = $Attacktimer
@onready var hurt_animation: AnimationPlayer = $HurtAnimation

#sword collide animation
@onready var sword: Node2D = $sword
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#melee attack
@onready var collision_shape_2d: CollisionShape2D = $sword/attackarea/CollisionShape2D
@onready var attackarea: Area2D = $sword/attackarea
var hit_target = []


var SPEED = 140
var HEALTH = 20.0
var direction = Vector2.ZERO
var is_player_detected = false
var is_attack = false


func _physics_process(delta: float) -> void:
	if is_attack:
		var overlapping_objects = attackarea.get_overlapping_areas()
	
		for area in overlapping_objects:
			var parent = area.get_parent()
			if parent in hit_target:
				continue
			hit_target.append(parent)
			if parent.has_method("take_damage_byenemy"):
				parent.take_damage_byenemy()
	if is_attack or not attacktimer.is_stopped():
		idle()
		
		return
				
	if is_player_detected and is_attack == false:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
	move_and_slide()
	


func _process(delta: float) -> void:
	#look directiona
	if direction.x > 0:
		animated_sprite.flip_h = false
		sword.scale.x = 1

		
	elif direction.x < 0:
		animated_sprite.flip_h = true
		sword.scale.x = -1
	
	if is_attack == false:
		if direction.length() > 0:
			animated_sprite.play("run")
		elif direction.length() == 0:
			animated_sprite.play("idle")
		
	
	

#direction to the player (enemy_movement)
func _on_player_detect_body_entered(body: Node2D) -> void:
	if body == player:
		timer.stop()
		is_player_detected = true

func _on_player_detect_body_exited(body: Node2D) -> void:
	if is_queued_for_deletion():
		return
	if body == player:
		timer.start()
		
func _on_timer_timeout() -> void:
	is_player_detected = false
	idle()
	

#attack the player
func _on_player_detect_for_hit(body: Node2D) -> void:
	if body == player:
		is_attack = true
		call_deferred("attack")
		attacktimer.start()

func _on_player_detect_for_hit_body_exited(body: Node2D) -> void:
	if body == player:
		attacktimer.stop()

func _on_attacktimer_timeout() -> void:
	is_attack = true
	call_deferred("attack") # Replace with function body.

		
#motion
func attack():
	hit_target.clear()
	animated_sprite.play("attack")
	animation_player.play("attack")
	
	
func idle():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO

	
	

##if attack is finished
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		is_attack = false
		
#take damage
func take_damage():
	hurt_animation.play("hurt")
	HEALTH -= 5

	
	if HEALTH <= 0:
		pass
		hurt_animation.play("die")
		await hurt_animation.animation_finished
		queue_free()
		const SMOKE_SCENE = preload("uid://c28tjplplnvuj")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
	

	
