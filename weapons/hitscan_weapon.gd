extends Node3D

@export_category("Weapon Stats")
@export var fire_rate: float = 14.0
@export var recoil: float = 0.05
@export var weapon_mesh: Node3D 
@export var weapon_damage: = 10
@export_category("Ammo Type")
@export var ammo_handler: AmmoHandler
@export var automatic: bool = true
@export var ammo_type: AmmoHandler.ammo_type
@export_category("Muzzle Sparks")
@export var muzzle_flash: GPUParticles3D
@export var sparks_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_pos: = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_pos, delta * 10.0)


func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		cooldown_timer.start(1.0 / fire_rate)
		var collider: = ray_cast_3d.get_collider()
		muzzle_flash.restart()
		printt("weapon fired!", collider)
		weapon_mesh.position.z += recoil
		var sparks_inst = sparks_scene.instantiate()
		if collider is Enemy:
			collider.hitpoints -= weapon_damage
		add_child(sparks_inst)
		sparks_inst.global_position = ray_cast_3d.get_collision_point()
