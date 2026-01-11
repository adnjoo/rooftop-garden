extends Button

func _input(event):
	if(event.is_action_pressed("next_day")):
		_on_pressed()

func _on_pressed() -> void:
	GameManager.set_current_day(GameManager.current_day + 1)
