extends CharacterBody2D

@export var speed : float = 300
@export var healt : float = 100
@export var weapon : int = -1 #weapon id

@export var client_player : bool = true
@export var bot : bool = false
@export var player_id: int = 0
@export var username: String = "player"

var player_skin_id : int = 0
var player_palette_id : int = 0

#=======================================================================
#weapon loot
#=======================================================================
var in_loot_zone = false
var loot_zone_id = 0
var loot_id = 0 #incetance id of the entered loot zone
var health_to_remove = 0
var shoot_rotation = 0
var shoot_position = Vector2(0, 0)

#=======================================================================
#network val
#=======================================================================
var regular_update_timer = 0.0
var interval = 0.033

func player_enter_loot_zone(w_id : int, id : int):
	in_loot_zone = true
	loot_zone_id = w_id
	loot_id = id

func player_exit_loot_zone():
	in_loot_zone = false

func interact_with_loot():
	if (in_loot_zone == true):
		if (Input.is_action_just_pressed("loot")):
			in_loot_zone = false
			
			drop_weapon()
			equip_weapon(loot_zone_id)
			
			var loot_ins = instance_from_id(loot_id)
			loot_ins.free()

func interact_with_loot_not_client():
	if (in_loot_zone == true):
		in_loot_zone = false
		
		drop_weapon()
		equip_weapon(loot_zone_id)
		
		var loot_ins = instance_from_id(loot_id)
		loot_ins.free()
		

#============================================================================
#light update
#============================================================================

func toggle_light():
	if ($PointLight2D/playerlight.visible == false):
		$PointLight2D/playerlight.visible = true
		$PointLight2D/bushlight.visible = true
	else:
		$PointLight2D/playerlight.visible = false
		$PointLight2D/bushlight.visible = false

#============================================================================
#skin update
#============================================================================

func update_skin():
	print("update_skin")
	#Network.client_player_ins.get_node("AnimatedSprite2D").
	self.get_node("AnimatedSprite2D").material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	self.get_node("AnimatedSprite2D").material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	self.get_node("AnimatedSprite2D").material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])

#============================================================================
#weapon management
#============================================================================
func equip_weapon(id : int):
	weapon = id
	$hand/Sprite2D.texture = load(WeaponData.weapon_data[weapon][3])
	
	if client_player:
		Network.send_text(JSON.stringify(
			{
				"type": "player_equip_weapon",
				"id": player_id,
				"weapon": weapon
			}
		))

func unequip_weapon():
	weapon = -1
	$hand/Sprite2D.texture = null

func drop_weapon():
	if (weapon != -1):
		var droped_weapon = load("res://scene/item/loot_weapon.tscn")
		var droped_weapon_ins = droped_weapon.instantiate()
		droped_weapon_ins.weapon_id = weapon
		droped_weapon_ins.position = position
		get_tree().current_scene.add_child(droped_weapon_ins)
		weapon = -1
		$hand/Sprite2D.texture = null
		if client_player:
			Network.send_text(JSON.stringify(
				{
					"type": "player_drop_weapon",
					"id": player_id,
				}
			))

func shoot_particule(pos : Vector2):
	if (client_player):
		var gap = (position.direction_to(pos)) * 75
		
		shoot_rotation = rotation
		shoot_position = position# + gap
		
		$GPUParticles2D.process_material.emission_box_extents.x = pos.distance_to(position) / 4# - gap.x
		$GPUParticles2D.process_material.emission_shape_offset.x = pos.distance_to(position) / 4
		$GPUParticles2D.amount = pos.distance_to(position) / 5
		$GPUParticles2D.emitting = true

func shoot_particule_network(data: Dictionary):
	var pos : Vector2
	pos.x = float(data["pos"][0])
	pos.y = float(data["pos"][1])
	var gap = (position.direction_to(pos)) * 75
		
	shoot_rotation = rotation
	shoot_position = position# + gap
	
	$GPUParticles2D.process_material.emission_box_extents.x = data["pro_mat_emit_box_x"]
	$GPUParticles2D.process_material.emission_shape_offset.x = data["proc_mat_emit_of_x"]
	$GPUParticles2D.amount = data["amount"]
	$GPUParticles2D.texture.current_frame = WeaponData.weapon_data[weapon][5]
	$GPUParticles2D.emitting = true

func use_weapon():
	if (weapon != -1):
		var shoot = load("res://scene/item/ray_bullet.tscn")
		var shoot_ins : Node2D = shoot.instantiate()
		shoot_ins.position = position
		shoot_ins.w_range = WeaponData.weapon_data[weapon][1]
		shoot_ins.w_damage = WeaponData.weapon_data[weapon][2]
		shoot_ins.w_ray_color = WeaponData.weapon_data[weapon][4]
		$GPUParticles2D.texture.current_frame = WeaponData.weapon_data[weapon][5]
		var ray: RayCast2D = shoot_ins.get_node("RayCast2D")
		var dir = (get_global_mouse_position() - ray.global_position).normalized()
		ray.target_position = ray.to_local(ray.global_position + dir * shoot_ins.w_range)
		
		var part: GPUParticles2D = ray.get_node("GPUParticles2D")
		part.look_at(get_global_mouse_position())

		get_tree().current_scene.add_child(shoot_ins)
		if (client_player):
			Network.send_text(JSON.stringify(
				{
					"type": "player_shoot",
					"id": player_id,
					"pos": [ray.target_position.x, ray.target_position.y],
					"pro_mat_emit_box_x": $GPUParticles2D.process_material.emission_box_extents.x,
					"proc_mat_emit_of_x": $GPUParticles2D.process_material.emission_shape_offset.x,
					"amount": $GPUParticles2D.amount
				}
			))

#===========================================================================
# Called when the node enters the scene tree for the first time.
#===========================================================================
func _ready() -> void:
	GlobalEvent.enter_loot_zone.connect(player_enter_loot_zone)
	GlobalEvent.exit_loot_zone.connect(player_exit_loot_zone)
	GlobalEvent.shoot_action.connect(shoot_particule)
	if (client_player == false):
		$Camera2D.enabled = false
	else:
		Network.set_client_player(self)
		#player_id = Network.socket.
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	update_skin()

#===========================================================================
#network function
#===========================================================================
func update_player(data: Dictionary):
	position.x = data["pos"][0]
	position.y = data["pos"][1]
	rotation = data["rot"]

#===========================================================================
#player physic proc
#===========================================================================
func client_physic_proc(_delta):
	
	var vel = Vector2.ZERO
	look_at(get_global_mouse_position())

	#======================================================================================
	#MOVEMENT
	#======================================================================================
	if not Input.is_action_pressed("move"):
		$AnimatedSprite2D.play(str(1 + player_skin_id * 2))
	if (Main.can_move == true):
		if Input.is_action_pressed("up"):
			vel.y -= 1
			$AnimatedSprite2D.play(str(2 + player_skin_id * 2))
		if Input.is_action_pressed("down"):
			vel.y += 1
			$AnimatedSprite2D.play(str(2 + player_skin_id * 2))
		if Input.is_action_pressed("right"):
			vel.x += 1
			$AnimatedSprite2D.play(str(2 + player_skin_id * 2))
		if Input.is_action_pressed("left"):
			vel.x -= 1
			$AnimatedSprite2D.play(str(2 + player_skin_id * 2))
	
	if vel.length() >= 1:
		vel = vel.normalized()
	
	velocity = (vel * speed)
	move_and_slide()

#================================================================================
#CLIENT PROCESS
#================================================================================
func client_proc(delta):
	#======================================================================================
	#CAMERA
	#======================================================================================
	var posA = global_position
	var posB = get_global_mouse_position()
	var posC = Vector2.ZERO
	posC.x = (posA.x + posB.x) / 2
	posC.y = (posA.y + posB.y) / 2
	
	var max_rad : float = 500
	var dist = sqrt(pow(posB.x - posA.x,2) + pow(posB.y - posA.y, 2))
	var distC = sqrt(pow(posC.x - posA.x,2) + pow(posC.y - posA.y, 2))
	if (distC > max_rad):
		var posD = Vector2.ZERO
		posD.x = posA.x + max_rad / dist * (posB.x - posA.x)
		posD.y = posA.y + max_rad / dist * (posB.y - posA.y)
		$Camera2D.global_position = posD
	else:
		$Camera2D.global_position = posC

	#======================================================================================
	#ACTION
	#======================================================================================
	if (Main.can_move == true):
		if Input.is_action_just_pressed("shoot"):
			use_weapon()
		if Input.is_action_just_pressed("loot"):
			GlobalEvent.map_action.emit(global_position, $".", true)
		if (Input.is_action_just_pressed("drop_weapon")):
			drop_weapon()
		interact_with_loot()

	#======================================================================================
	#NETWORK REGULAR UPDATE
	#======================================================================================
	regular_update_timer += delta
	if regular_update_timer >= interval:
		regular_update_timer = 0.0
		if (Network.socket.get_ready_state() == WebSocketPeer.STATE_OPEN):
			Network.send_text(JSON.stringify(
				{
					"type": "player_update",
					"id": player_id,
					"pos": [position.x, position.y],
					"rot": rotation
				}
			))
	
	#game state
	if (healt <= 0):
		healt = 100
		Main.end_round(player_id, true)

func bot_proc(_delta: float):
	use_weapon()
	
func not_client_proc(_delta):
	$AnimatedSprite2D.play(str(1 + player_skin_id * 2))
	
func _physics_process(delta: float) -> void:
	if client_player == true:
		client_physic_proc(delta)

func _process(delta: float):
	$Label.text = "id: " + str(player_id)
	if bot == true:
		bot_proc(delta)
	else:
		if client_player == true:
			client_proc(delta)
		else:
			not_client_proc(delta)
	
	$GPUParticles2D.global_rotation = shoot_rotation
	$GPUParticles2D.global_position = shoot_position
	$healthbar.global_rotation = 0
	$healthbar.global_position = position + Vector2(0, -92)
	$healthbar/Sprite2D2.scale.x = $healthbar/Timer.time_left * health_to_remove / 100
	health_to_remove *= $healthbar/Timer.time_left

func get_hit(dmg: int, b: bool):
	if (healt > 0):
		health_to_remove += dmg
	healt -= dmg
	if (healt <= 0):
		healt = 0
		hide()
		var body: PackedScene = load("res://scene/player/dead_body.tscn")
		var body_ins: Node2D = body.instantiate()
		body_ins.global_position = global_position
		get_tree().current_scene.get_node("body").add_child(body_ins)
	$healthbar/Sprite2D.scale.x = healt / 100
	$healthbar/Sprite2D2.position.x = -192 + (healt * 192 * 2)/100
	$healthbar/Label.text = type_convert(type_convert(healt, TYPE_INT), TYPE_STRING) + "%"
	$healthbar/Timer.start()

	if (not b):
		get_tree().current_scene.get_node("HUD").healthbar_(dmg)

	if (b):
		$healthbar.show()
		Network.send_text(JSON.stringify(
			{
				"type": "player_get_hit",
				"id": player_id,
				"dmg": dmg
			}
		))


func _on_timer_timeout() -> void:
	$healthbar.hide()
	$healthbar/Timer.stop()
