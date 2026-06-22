extends ProgressBar

@onready var valuelabel = $Label

func _ready() -> void:
	
	update_label_text(value)
	value_changed.connect(update_label_text)
	
func update_label_text(new_value: float) -> void:
	if valuelabel:
		valuelabel.text = "%.1f" % new_value
