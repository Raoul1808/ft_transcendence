extends Control

var health_to_remove = 0
var healt : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/Control2/healthbar.show()
	
	$CanvasLayer/Label.text = str(Network.client_player_ins.healt)
	healt = Network.client_player_ins.healt
	$CanvasLayer/Control/client_point.text = str(Main.p1_point)
	$CanvasLayer/Control/not_client_point.text = str(Main.p2_point)
	$CanvasLayer/Control2/healthbar/Sprite2D2.scale.x = $CanvasLayer/Control2/healthbar/Timer.time_left * health_to_remove / 100
	health_to_remove *= $CanvasLayer/Control2/healthbar/Timer.time_left
	#print(Network.client_player_ins.healt)


func healthbar_(dmg: int, b: bool):
	
	if (healt > 0):
		health_to_remove += dmg
	healt -= dmg
	if (healt <= 0):
		healt = 0
	$CanvasLayer/Control2/healthbar/Sprite2D.scale.x = healt / 100
	$CanvasLayer/Control2/healthbar/Sprite2D2.position.x = -192 + (healt * 192 * 2)/100
	$CanvasLayer/Control2/healthbar/Label.text = type_convert(type_convert(healt, TYPE_INT), TYPE_STRING) + "%"
	$CanvasLayer/Control2/healthbar/Timer.start()
	


func _on_timer_timeout() -> void:
	$healthbar/Timer.stop()
