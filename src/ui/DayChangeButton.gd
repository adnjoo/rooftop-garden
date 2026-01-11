extends Button

func _on_pressed() -> void:
	GameManager.set_current_day(GameManager.current_day + 1)