extends Control

@export var track_name_edit : LineEdit 

@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var fadeblock : ColorRect = $CanvasLayer/fadeblock
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

const MEMBER_INPUT_SCENE = preload("res://UI/Scenes/control.tscn")

@export var columns_parent_container : HBoxContainer
@export var max_fields_per_column: int = 3

func _ready() -> void:
	Globaldata.roster_names.clear()
	_spawn_initial_slots_no_await()
	await get_tree().process_frame
	animplayer.play("fadein")
	await animplayer.animation_finished

func _spawn_initial_slots_no_await() -> void:
	if not columns_parent_container: return
	var active_column = _create_new_column()
	var new_line = MEMBER_INPUT_SCENE.instantiate()
	new_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	active_column.add_child(new_line)
	new_line.modulate.a = 1.0 
	new_line.grab_focus()

func _on_add_member_button_pressed() -> void:	
	if not columns_parent_container:
		return
		
	var total_current_fields = 0
	for col in columns_parent_container.get_children():
		total_current_fields += col.get_child_count()
		
	if total_current_fields >= 6:
		print("Maximum tracking limit of 6 reached!")
		return

	var active_column: VBoxContainer = null
	
	if columns_parent_container.get_child_count() == 0:
		active_column = _create_new_column()
	else:
		var last_col = columns_parent_container.get_child(columns_parent_container.get_child_count() - 1)
		if last_col.get_child_count() >= max_fields_per_column:
			active_column = _create_new_column()
		else:
			active_column = last_col

	var new_line = MEMBER_INPUT_SCENE.instantiate()
	new_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	new_line.modulate.a = 0.0
	active_column.add_child(new_line)
			
	var tween = create_tween().set_parallel(true)
	tween.tween_property(new_line, "modulate:a", 1.0, 0.3)

	await tween.finished
	new_line.grab_focus()

func _create_new_column() -> VBoxContainer:
	var new_col = VBoxContainer.new()
	new_col.custom_minimum_size.x = 250
	columns_parent_container.add_child(new_col)
	return new_col
			
func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Scenes/menu.tscn")

func _on_create_button_pressed() -> void:
	if animplayer.is_playing():
		animplayer.stop()

	fadeblock.modulate.a = 0.0
	fadeblock.show()
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(fadeblock, "modulate:a", 1.0, 0.5)
	tween.tween_property(audio, "volume_db", -80.0, 0.5)
	
	await tween.finished
	
	if track_name_edit and track_name_edit.text != "":
		Globaldata.current_track_title = track_name_edit.text
		print_rich("[color=yellowgreen][b]Track title is set to ", track_name_edit.text)
	else:
		Globaldata.current_track_title = "Unknown Track"
		print_rich("[color=white][b]Track Name left in blank.[/b] Using the singleton's defualt track title value instead.[/color]\n")
			
	Globaldata.roster_names.clear()
	for column in columns_parent_container.get_children():
		for child in column.get_children():
			if child.has_method("get_member_name"):
				var typed_name = child.get_member_name()
				if typed_name != "":
					Globaldata.roster_names.append(typed_name)
					print_rich("[color=yellowgreen][b]Instantiated ", typed_name, ". GLHF!")
					
	if Globaldata.roster_names.is_empty():
		Globaldata.roster_names = ["WONYOUNG", "LIZ", "REI", "YUJIN", "GAEUL", "LEESEO"]
		print_rich("[color=pink][b]Members section left in blank.[/b] Instantiating the baked default roster instead.[/color]")

	get_tree().change_scene_to_file("res://UI/Scenes/line_distribution_screen.tscn")
