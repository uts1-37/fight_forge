extends CharacterBody2D

@onready var player = get_node("/root/Main/player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $player_out

var SPEED = 140
var HEALTH = 100.0
var direction = Vector2.ZERO
var is_player_detected = false
var is_attack = false

func _physics_process(delta: float) -> void:
	if is_player_detected and is_attack == false:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()


func _process(delta: float) -> void:
	#look directiona
	if direction.x > 0:
		animated_sprite.flip_h = false
		
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
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
	if body == player:
		timer.start()
		
func _on_timer_timeout() -> void:
	is_player_detected = false
	idle()
	

#attack the player
func _on_player_detect_for_hit(body: Node2D) -> void:
	if body == player:
		is_attack = true
		attack()

#motion
func attack():
	animated_sprite.play("attack")
	
func idle():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO

	
	

#if attack is finished
func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	
