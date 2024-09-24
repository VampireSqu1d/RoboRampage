extends CharacterBody3D

@export var atack_range: = 1.5

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var player
var provoked: bool = false
var aggro_range: = 12
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position


func _physics_process(delta: float) -> void:
	var next_pos = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = global_position.direction_to(next_pos)
	var squared_distance = global_position.distance_squared_to(player.global_position)
	
	if squared_distance <= aggro_range*aggro_range:
		provoked = true
	
	if provoked:
		if squared_distance <= atack_range*atack_range:
			animation_player.play("attack")
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func look_at_target(direction: Vector3) -> void:
	var adjusted_dir = direction
	adjusted_dir.y = 0
	look_at(global_position + adjusted_dir, Vector3.UP, true)


func attack() -> void:
	print("Enemy attack")
