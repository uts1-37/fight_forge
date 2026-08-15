extends CanvasLayer

signal start_game
signal restart

func update_score(score):
	$Score.text = str(score)




func _on_startbutton_pressed() -> void:
	$ColorRect.hide()
	$StartEnd.hide()
	$Button.hide()
	start_game.emit()
	$Score.show()

func show_game_over(score):
	$ColorRect.show()
	await get_tree().create_timer(0.4).timeout          # ← 이게 맞는 형태

	$GameOver.show()
	await get_tree().create_timer(0.7).timeout          # ← 이게 맞는 형태

	$EndScore.show()
	await get_tree().create_timer(0.7).timeout          # ← 이게 맞는 형태

	$EndScore2.text = str(score)
	$EndScore2.show()
	await get_tree().create_timer(0.7).timeout          # ← 이게 맞는 형태

	$Button2.show()

func _on_button_2_pressed() -> void:
	restart.emit()
	
