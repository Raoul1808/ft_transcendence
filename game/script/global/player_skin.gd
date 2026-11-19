extends Node

#==============================================================
# skin name		| palette path							|	palette path 2						| nb color
# "red wizard"	| res://assets/palette/player/.png"		| 	res://assets/palette/player/.png"	| 8
#==============================================================
var wizard_palette = [
	["Purple Wizard", "res://assets/palette/player/wizard_palette.png", "res://assets/palette/player/wizard_palette.png", 8],
	["Red Wizard", "res://assets/palette/player/wizard_palette.png", "res://assets/palette/player/wizard_palette_red.png", 8],
	["Grey Wizard", "res://assets/palette/player/wizard_palette.png", "res://assets/palette/player/wizard_palette_grey.png", 8],
	["Blue Wizard", "res://assets/palette/player/wizard_palette.png", "res://assets/palette/player/wizard_palette_blue.png", 8]
]

var wiz_palette = [
	["Purple Wizard", "res://assets/palette/player/wizard_palette.png", "res://assets/palette/player/wizard_palette.png", 8]
]

var saruman_palette = [
	["Saruman", "res://assets/palette/player/saruman_palette.png", "res://assets/palette/player/saruman_palette.png", 5],
	["Red Saruman", "res://assets/palette/player/saruman_palette.png", "res://assets/palette/player/saruman_palette_red.png", 5],
]

#==============================================================
# skin group	| skin path						
# "wizard"		| "res://assets/img/blue_staff.png"
#==============================================================
var player_skin = [
	["res://assets/img/wizard.png", wizard_palette],
	["res://assets/img/saruman.png", saruman_palette],
	["res://assets/img/wiz_test.png", wiz_palette]
]



func _ready() -> void:
	pass
