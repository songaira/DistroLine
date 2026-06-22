extends Control

@export var progress_bars: Array[ProgressBar] = []
@onready var  animationplayer : AnimationPlayer = $CanvasLayer/AnimationPlayer


var lines_dictionary: Dictionary = {}
var active_member_index : int = -1
var total_time : float = 0.0

@onready var setupscreen = preload("res://UI/Scenes/setup_screen.tscn")


func _ready() -> void:
		
	for i in range(progress_bars.size()):
		if i < Globaldata.roster_names.size():
			var member_name = Globaldata.roster_names[i]
			
			lines_dictionary[i] = 0.0
			progress_bars[i].value = 0.0
			progress_bars[i].show()
			
			var label = progress_bars[i].get_node_or_null("Name")
			if label: 
				label.text = member_name
		else:
			progress_bars[i].hide()
			print_rich("hidden... [b][i]look at the logic on why tf it's happening[i]")
			
		
	
	var title_label = $CanvasLayer/Panel/TitleBar
	if title_label:
		title_label.text = Globaldata.current_track_title
		
	await get_tree().process_frame
		
	animationplayer.play("FADEIN")
		

func _process(delta: float) -> void:
	if active_member_index == -2:
		total_time += delta
		for i in range(progress_bars.size()):
			if i < Globaldata.roster_names.size():
				lines_dictionary[i] += delta
				progress_bars[i].value = lines_dictionary[i]
		_recalculate_bar_rounds()
	elif active_member_index != -1 and active_member_index < Globaldata.roster_names.size():
		lines_dictionary[active_member_index] += delta
		total_time += delta
		progress_bars[active_member_index].value = lines_dictionary[active_member_index]
		_recalculate_bar_rounds()
		
func _unhandled_input(event: InputEvent) -> void:
	for i in range(progress_bars.size()):
		if event.is_action_pressed("ui_key_" + str(i + 1)):
			active_member_index = i
			print("shifted to : ", i + 1)		

		
		if event.is_action_pressed("ui_key_0"):
			active_member_index = -2
			print("in unison")
			$CanvasLayer/NOTICE.text = "In unison"
		

## buttonssssss

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Scenes/setup_screen.tscn")

func _on_up_button_pressed() -> void:
	if active_member_index > 0:
		active_member_index -= 1
		print("shifted up")

func _on_dn_button_pressed() -> void:
	if active_member_index < progress_bars.size() - 1:
		active_member_index += 1
		print("shifted down, blip blip")

func _on_add_button_pressed() -> void:
	active_member_index = -1
	print("lol")
	
func _on_save_ln_dis_button_pressed() -> void:
	
	var safe_title = Globaldata.current_track_title.to_lower().replace(" ", "_")
	var file_name = "res://" + safe_title + "_line_distribution.csv"
	
	var file = FileAccess.open(file_name,FileAccess.WRITE)
	
	if file:
		file.store_line("Member Slot, Member Name, Duration(Seconds), Percentage (%)")
		
		for i in range(progress_bars.size()):
			var member_name = Globaldata.roster_names[i]
			var duration = lines_dictionary[i]
			var percentage = (duration / total_time) * 100.0 if total_time > 0.0 else 0.0
			
			var duration_str = "%.1f"
			var percentage_str = "%.1f" % percentage
			
			var csv_row = str(i + 1) + "," + member_name + "," + duration_str + "," + percentage_str + "%"
			file.store_line(csv_row)
		
			print("exporting slot...")
			
			file.close()
			print("success... pushed at local storage at: ", file_name)
			$CanvasLayer/Panel/SaveButton.text = "Saved"
			return
		
	else:
		var err = FileAccess.get_open_error()
		print("failed to open file write stream. code: ", err)	
		
		
func _recalculate_bar_rounds():
	
	for i in range(progress_bars.size()):
		progress_bars[i].max_value = total_time if total_time > 0.0 else 100.0
