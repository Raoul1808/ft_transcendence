extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/Label.text = str(Network.client_player_ins.healt)
	$CanvasLayer/Control/client_point.text = str(Main.p1_point)
	$CanvasLayer/Control/not_client_point.text = str(Main.p2_point)
