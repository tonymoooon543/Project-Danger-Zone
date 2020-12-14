#
# weapon.gd
# ------------------
# Part of the Triside
# Copyright (c) 2020 JB Stepan. All Rights Reserved
# Licensed under License.txt. License.txt for more info.
#
# TODO: Work on hold to fire

extends Node

class_name Weapon

export var fire_rate : float;
export var clip_size :int;
export var reload_rate : float;
export var damage : float;
export var can_hold : bool = false;
export var raycast_path : NodePath;
export var weapon_name : String;
export(String, MULTILINE) var weapon_desc


var current_ammo = 0;
var can_fire = true;
var reloading = false;

var raycast : RayCast;

func _ready():
	current_ammo = clip_size;
	raycast = get_node(raycast_path);
	
func _process_gun():
	if Input.is_action_pressed("fire") and can_fire and can_hold:
		yield(get_tree().create_timer(fire_rate), "timeout");
#		if current_ammo > 0 and not reloading:
		fire();
#		elif not reloading:
#			reload();
	
	if Input.is_action_just_pressed("fire") and can_fire:
		if current_ammo > 0 and not reloading:
			fire();
		elif not reloading:
			reload();
	
	if Input.is_action_just_pressed("reload") and not reloading:
		reload();

func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider();
		if collider.is_in_group("Enemies"):
			collider.queue_free();
		else:
			print("Hit Nothing!");

func fire():
	print("Fired weapon" + weapon_name);
	can_fire = false;
	current_ammo -= 1;
	yield(get_tree().create_timer(fire_rate), "timeout");
	can_fire = true

func reload():
	reloading = true;
	yield(get_tree().create_timer(reload_rate), "timeout");
	current_ammo = clip_size;
	reloading = false;
