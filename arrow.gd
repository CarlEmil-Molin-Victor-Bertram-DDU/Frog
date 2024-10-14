extends CharacterBody2D

@export var speed = 300  # Speed of the arrow
@export var gravity = 500  # Gravity affecting the arrow
@export var air_resistance = 0.98  # Air resistance effect
var has_hit = false

signal hit  # Signal to indicate a hit

func _ready() -> void:
	# Set the initial position of the arrow
	position = get_parent().get_node("Player").position
	
	velocity.y = -100 
	velocity.x = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Apply gravity to the Y component of velocity
	velocity.y += gravity * delta
	
	# Update the X velocity with air resistance
	velocity.x *= air_resistance
	
	# Rotate the arrow to match its direction of flight
	if velocity.length() > 0:
		rotation = velocity.angle()
	
	# Move the arrow using the calculated velocity
	move_and_slide()

	# Free the arrow if it touches the ground
	if is_on_floor():
		queue_free()

# Detect when the arrow hits a body
func _on_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not has_hit:
		queue_free()
		emit_signal("hit",body)
		has_hit = true
