extends Spatial

var sensi : float = 0.2

var select_view

var mouse_3D

var Model_Button : PackedScene = preload("res://Scenes/HUD/Model.tscn")
var create_model = preload("res://Scenes/HUD/Models_Create.tscn")
var new_pos = preload("res://Scenes/Models/Pos.tscn")

onready var Model : Spatial = $Model
onready var Select : Spatial = $Select
onready var Player : Spatial = $Player
onready var Cam : Spatial = $Player/Camera
onready var Ray : RayCast = $Player/Camera/RayCast

func _ready() -> void:
	
	Index.world = $"."
	


func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_TAB):
			if is_instance_valid(Index.select):
				$Player.global_transform.origin = Index.select.global_transform.origin
		if Input.is_key_pressed(KEY_SHIFT) and Input.is_mouse_button_pressed(1) and is_instance_valid(Index.select) == false:
			for i in($"GUI/2D/Nod".get_children()):
				i.queue_free()
			var ct = create_model.instance()
			$"GUI/2D/Nod".add_child(ct)
			ct.rect_global_position = ct.get_global_mouse_position()
	
	if event is InputEventMouseMotion:
		
		var position2D = get_viewport().get_mouse_position()
		var dropPlane  = Plane($"Player/Camera".global_transform.origin, 1)
		mouse_3D = dropPlane.intersects_ray($Player/Camera.project_ray_origin(position2D),$Player/Camera.project_ray_normal(position2D))
		if mouse_3D != null:
			Ray.look_at(mouse_3D,Vector3.UP)
			if Ray.get_collider():
				Select.global_transform.origin = Ray.get_collision_point()
			else:
				Select.global_transform.origin = mouse_3D
		
		if Input.is_mouse_button_pressed(1):
			if mouse_3D == null:
				Index.select = null
			else:
				if is_instance_valid(Index.select):
					if Input.is_key_pressed(KEY_SHIFT):
						Index.select.global_transform.origin = mouse_3D.snapped(Vector3(0.5,0.5,0.5))
					else: Index.select.global_transform.origin = mouse_3D
				if Input.is_mouse_button_pressed(2):
					if is_instance_valid(Index.select):
						if Ray.get_collider():
							Index.select.get_child(0).collision_layer = 2
							
							Index.select.global_transform.origin = Ray.get_collision_point() + Vector3.UP
		else:
			if is_instance_valid(Index.select):
				Index.select.get_child(0).collision_layer = 1
		
		if Input.is_mouse_button_pressed(3):
			Player.rotation.y += -deg2rad(event.relative.x * sensi)
			Player.rotation.x += -deg2rad(event.relative.y * sensi)
	
	if event is InputEventMouseButton:
		
		if Input.is_mouse_button_pressed(1):
			for i in(Model.get_children()):
				if is_instance_valid(select_view):
					select_propriety()
			if Ray.get_collider() == null:
				Index.select = null
				for i in($Pos.get_children()):
					i.queue_free()
		
		if Input.is_mouse_button_pressed(4):
			Cam.transform.origin.y += -sensi * 3.5
		if Input.is_mouse_button_pressed(5):
			Cam.transform.origin.y += sensi * 3.5

func select_propriety():
	Index.select = select_view
	for i in($Pos.get_children()):
		i.queue_free()
	var pos = new_pos.instance()
	$Pos.add_child(pos)
	$"GUI/2D/Panel/vbox/Panel/Vbox/Name".text = str(Index.select.name)
	$"GUI/2D/Panel/vbox/Panel/Vbox/Translate/Vbox/X".value = Index.select.transform.origin.x
	$"GUI/2D/Panel/vbox/Panel/Vbox/Translate/Vbox/Y".value = Index.select.transform.origin.y
	$"GUI/2D/Panel/vbox/Panel/Vbox/Translate/Vbox/Z".value = Index.select.transform.origin.z

func _on_Area_body_entered(body: Node) -> void:
	if body.name != "not":
		$Select/Model.get_active_material(0).albedo_color = Color(0, 1, 1)
		select_view = body.get_parent()
	else:
		$Select/Model.get_active_material(0).albedo_color = Color(1, 0, 0.351563)

func _on_Timer_timeout() -> void:
	for x in($"GUI/2D/Tree/Vbox/Panel/Mesh".get_children()):
		x.queue_free()
	for i in(Model.get_children()):
		
		var mode = Model_Button.instance()
		mode.model = i
		$"GUI/2D/Tree/Vbox/Panel/Mesh".add_child(mode)
	
