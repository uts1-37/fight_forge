extends Node2D
@onready var total_enemy: Node = $Enemy
var score = 0
@onready var player: CharacterBody2D = $player

func _ready() -> void:
	spawnmob()
	spawnmob()
	spawnmob()
	spawnmob()
	spawnmob()

	player.set_physics_process(false)
	


func _on_hud_start_game() -> void:
	player.set_physics_process(true)
	
func _on_hud_restart() -> void:
	get_tree().reload_current_scene()

	
func game_over() -> void:
	$HUD.show_game_over(score)
	player.set_physics_process(false)
	$Enemy.process_mode = Node.PROCESS_MODE_DISABLED   # 멈춤
	$player.process_mode = Node.PROCESS_MODE_DISABLED   # 멈춤
	
	



func _physics_process(delta: float) -> void:
	while total_enemy.get_child_count() < 5:
		score += 1
		$HUD.update_score(score)
		spawnmob()

		
		
	
func spawnmob():
		var mob = preload("uid://b8b1bbb1ir2mm").instantiate()
		%MobSpawnLocation.progress_ratio = randf()
		mob.global_position = %MobSpawnLocation.global_position
		total_enemy.add_child(mob)
