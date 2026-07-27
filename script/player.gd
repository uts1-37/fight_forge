extends CharacterBody2D

@export var speed = 400 #makes a slider
var HEALTH = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.ZERO
var is_attacking = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword: Node2D = $sword
#melee attack
@onready var attackarea: Area2D = $sword/attackarea
var hit_target = []
@onready var hurt_animation: AnimationPlayer = $HurtAnimation
@onready var player: CharacterBody2D = $"."
@onready var progress_bar: ProgressBar = $ProgressBar


func get_input():
	if is_attacking:
		velocity = Vector2.ZERO
		return
	direction = Input.get_vector("move_left" , "move_right", "move_up", "move_down")
	velocity = direction * speed

	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	if is_attacking:
		var overlapping_objects = attackarea.get_overlapping_areas()
	
		for area in overlapping_objects:
			var parent = area.get_parent()
			if parent in hit_target:
				continue
			hit_target.append(parent)
			if parent.has_method("take_damage"):
				parent.take_damage()
		
	
func _process(delta: float) -> void:
	
	#look direction
	if direction.x > 0:
		animated_sprite.flip_h = false
		sword.scale.x = 1
	elif direction.x < 0:
		animated_sprite.flip_h = true
		sword.scale.x = -1
		
	#animation play
	if is_attacking == false:
		if direction.length() > 0:
			animated_sprite.play("run")
		elif direction.length() == 0:
			animated_sprite.play("idle")
	if Input.is_action_just_pressed("attack"):
		attack()
	
func attack():
	hit_target.clear()
	is_attacking = true
	animated_sprite.play("attack")
	animation_player.play("attack")
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
	
func take_damage_byenemy():
	hurt_animation.play("hurt")
	HEALTH -=5
	progress_bar.value = HEALTH
	print(HEALTH)
	if HEALTH <= 0:
		hurt_animation.play("die")
		await hurt_animation.animation_finished
		player.visible = false
		const SMOKE_SCENE = preload("uid://cmq24bpr083xl")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
	
