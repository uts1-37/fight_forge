extends CharacterBody2D

@export var speed = 400 #makes a slider
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.ZERO
var is_attacking = false
@onready var animation_player: AnimationPlayer = $sword/attackarea/CollisionShape2D/AnimationPlayer
@onready var sword: Node2D = $sword

func get_input():
	if is_attacking:
		velocity = Vector2.ZERO
		return
	direction = Input.get_vector("move_left" , "move_right", "move_up", "move_down")
	velocity = direction * speed

	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
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
		is_attacking = true
		attack()
	
func attack():
	animated_sprite.play("attack")
	animation_player.play("attack")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
	
func die():
	queue_free()
