extends Node2D

@export var w_range : int = 500
@export var w_damage : int = 5
@export var w_ray_color = [Color(1.0, 1.0, 1.0, 0.0), Color(0.0, 0.0, 0.0, 1.0)]

var ray2D : RayCast2D

func _ready() -> void:
	$point.position = $RayCast2D.target_position
	$RayCast2D/GPUParticles2D.process_material.emission_box_extents.x = w_range
	$RayCast2D/GPUParticles2D.emitting = true
	ray2D = $RayCast2D
	$RayCast2D/Sprite2D.look_at(get_global_mouse_position())
	$RayCast2D/Sprite2D.texture.width = w_range / 3
	$RayCast2D/Sprite2D.texture.gradient.colors = w_ray_color
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (ray2D.is_colliding()):
			var mark = load("res://scene/item/hit_marker.tscn")
			var mark_ins : Node2D = mark.instantiate()
			mark_ins.global_position = ray2D.get_collision_point()
			if ("CharacterBody2D" == ray2D.get_collider().get_class()):
				ray2D.get_collider().get_hit(w_damage, true)
			get_tree().current_scene.add_child(mark_ins)
			GlobalEvent.shoot_action.emit(ray2D.get_collision_point())
	else:
		GlobalEvent.shoot_action.emit($point.global_position)
	
	self.queue_free()
	
