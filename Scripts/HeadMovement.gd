# Copyright JB Stepan. 2020. All rights reserved
# Please read License.md and Readme.md for more info
# Copyright (c) 2020 Droivox
# Under the MIT License
# https://github.com/Droivox/Godot-Engine-FPS
extends Spatial;

export var player_path : NodePath;
export var sensitivity : float = 0.2;
export var captured : bool = true;

var player

func _ready() -> void:
	player = get_node(player_path);
	
func _physics_process(_delta) -> void:
	# Calls function to switch between locked and unlocked mouse
	_mouse_toggle();
	
func _mouse_toggle() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		captured = !captured;
	
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		
func _cam_rotate(event) -> void:
	# If the mouse is locked
	if captured:
		var camera : Dictionary = {0: $".", 1: $"."};
		
		if event is InputEventMouseMotion:
			# Rotates the camera on the x axis
			camera[0].rotation.x += -deg2rad(event.relative.y * sensitivity);
			
			# Rotates the camera on the y axis
			camera[1].rotation.y += -deg2rad(event.relative.x * sensitivity);
		
		# Creates a limit for the camera on the x axis
		var max_angle: int = 85; # Maximum camera angle
		camera[0].rotation.x = min(camera[0].rotation.x,  deg2rad(max_angle))
		camera[0].rotation.x = max(camera[0].rotation.x, -deg2rad(max_angle))

func _input(_event) -> void:
	# Calls the function to rotate the camera
	_cam_rotate(_event);