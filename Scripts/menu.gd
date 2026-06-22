extends Control

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var nextscene = preload("res://UI/Scenes/setup_screen.tscn")
@onready var fadeblock : ColorRect = $CanvasLayer/FadeBlock
@onready var devname : Button = $CanvasLayer/Panel/Label/DevName
@onready var toast : Label = $CanvasLayer/Panel/Label/BottomToast

func _ready() -> void:
	
	toast.modulate.a = 0.0

func _on_create_button_pressed():
	# 1. Reset the fade block to invisible just in case
	fadeblock.modulate.a = 0.0
	fadeblock.show() # Make sure the ColorRect visibility isn't hidden completely
	
	# 2. Create a parallel tween to fade out the music AND the screen at the same time
	var tween = create_tween().set_parallel(true)
	
	# Fade visual block to black over 0.5 seconds
	tween.tween_property(fadeblock, "modulate:a", 1.0, 0.5)
	
	# Fade audio volume down to silence (-80 dB) over 0.5 seconds
	tween.tween_property(audio, "volume_db", -80.0, 0.5)
	
	# 3. PAUSE code execution right here until the 0.5-second animation finishes
	await tween.finished
	
	# 4. Now that the screen is fully black and audio is silent, change the scene safely!
	get_tree().change_scene_to_file("res://UI/Scenes/setup_screen.tscn")

func _on_devname_button_pressed():
	
	DisplayServer.clipboard_set("https://instagram.com/airaisnotinyourheart")
	print("Successfully copied instagram link... Follow me or else...")
	
	var tween = create_tween()
	
	toast.text = "Instagram link copied. Follow me PLEASEEEEE I BEG YUOO"
	tween.tween_property(toast, "modulate:a", 1.0, 1.3)
	
	tween.tween_property(toast, "modulate:a", 0.0, 2.3)
	
func _on_exit_button_pressed():
	get_tree().quit()
