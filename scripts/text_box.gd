extends MarginContainer


@onready var label = $MarginContainer/Label
@onready var timer = $Letter_Display

const MAX_WIDTH = 256
var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.09

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #wait for x
		await resized #wait for y
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	label.text = ""
	_display_letter()

func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	$sfx/Sign.play()
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_letter_display_timeout():
	_display_letter()


func _on_text_duration_timeout():
	queue_free()
	DialogManager.is_dialog_active = false
	DialogManager.current_line_index = 0
