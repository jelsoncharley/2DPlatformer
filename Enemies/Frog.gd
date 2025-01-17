extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var player

func _ready():
	anim.play("Idle")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	player = get_node("../../Player/Character")
	
	if chase == true:
		if anim.animation != "Death":
			anim.play("Jump")
		var direction = (player.position - self.position).normalized()
		if(direction.x > 0):
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if anim.animation != "Death":
			anim.play("Idle")
		velocity.x = 0
	move_and_slide()
	
func _on_player_detection_body_entered(body):
	if body.name == "Character":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Character":
		chase = false


func _on_death_body_entered(body):
	if body.name == "Character":
		death()

func death():
	chase = false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()


func _on_attack_body_entered(body):
	if body.name == "Character":
		body.health -= 2
		death()
