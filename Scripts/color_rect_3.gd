extends CanvasLayer

@onready var animplayer = $"../AnimationPlayer"


func _ready():
	# Play the fade-in animation
	animplayer.play("fadein")
	

	await animplayer.animation_finished
	
