extends CharacterBody3D

# Exported Variables
@export var sprint_enabled = true
@export var crouch_enabled = true
@export var base_speed = 5
@export var sprint_speed = 8
@export var jump_velocity = 4
@export var sensitivity = 0.1
@export var accel = 10
@export var crouch_speed = 3

# Member Variables
var state = "normal"  # normal, sprinting, crouching
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = base_speed
var camera_fov_extents = [75.0, 85.0]  #index 0 is normal, index 1 is sprinting
var base_player_y_scale = 1.0
var crouch_player_y_scale = 0.75

# Node References
@onready var parts = {
	"head": $head,
	"camera": $head/camera,
	"camera_animation": $head/camera/camera_animation,
	"body": $body,
	"collision": $collision
}
@onready var world = get_tree()

func _ready():
	parts.camera.current = true

func _process(delta):
	handle_movement_input(delta)
	update_camera(delta)

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	move_character(delta)

func _input(event):
	handle_mouse_movement(event)

# Movement Logic
func handle_movement_input(delta):
	if Input.is_action_pressed("move_sprint") and !Input.is_action_pressed("move_crouch") and sprint_enabled:
		enter_sprint_state(delta)
	elif Input.is_action_pressed("move_crouch") and !Input.is_action_pressed("move_sprint") and sprint_enabled:
		enter_crouch_state(delta)
	else:
		enter_normal_state(delta)

func enter_sprint_state(delta):
	state = "sprinting"
	speed = sprint_speed
	parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[1], 10*delta)

func enter_crouch_state(delta):
	state = "crouching"
	speed = crouch_speed
	apply_crouch_transform(delta)

func enter_normal_state(delta):
	state = "normal"
	speed = base_speed
	reset_transforms(delta)

# Camera Logic
func update_camera(delta):
	match state:
		"sprinting":
			parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[1], 10*delta)
		"normal":
			parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[0], 10*delta)

# Animation Logic
func apply_crouch_transform(delta):
	parts.body.scale.y = lerp(parts.body.scale.y, crouch_player_y_scale, 10*delta)
	parts.collision.scale.y = lerp(parts.collision.scale.y, crouch_player_y_scale, 10*delta)

func reset_transforms(delta):
	parts.body.scale.y = lerp(parts.body.scale.y, base_player_y_scale, 10*delta)
	parts.collision.scale.y = lerp(parts.collision.scale.y, base_player_y_scale, 10*delta)

# Physics Logic
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_jump():
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y += jump_velocity

func move_character(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = input_dir.normalized().rotated(-parts.head.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	if is_on_floor():
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	move_and_slide()

# Input Handling
func handle_mouse_movement(event):
	if event is InputEventMouseMotion:
		if !world.paused:
			parts.head.rotation_degrees.y -= event.relative.x * sensitivity
			parts.head.rotation_degrees.x -= event.relative.y * sensitivity
			parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
