extends Node2D

signal spawn_projectile(projectile_type)
signal fire_turret
export var fire_delay = 0.3
var rng = RandomNumberGenerator.new()

var _ready_to_fire
# Called when the node enters the scene tree for the first time.

func _ready():
	get_node("../..").connect("fire_turret", self, "_fire")
	get_node("../..").connect("turn_turret", self, "_turn")
	_ready_to_fire = true

func _turn(mouse_pos):
	look_at(mouse_pos)
	rotation_degrees -= 90

func _fire(group):
	if (_ready_to_fire):
		rng.randomize()
		var my_random_number = rng.randf_range(-0.04, 0.04)
		var direction = Vector2(0, 1).rotated(self.global_rotation)
		direction.y += my_random_number
		direction.x += my_random_number
		emit_signal("spawn_projectile", 1, $Muzzle.global_position, direction)
		$MuzzleAnimation.show()
		$MuzzleAnimation.set_frame(0)
		$MuzzleAnimation.play('MissileFlare')
		$FireDelay.start(fire_delay)
		_ready_to_fire = false

func _on_FireDelay_timeout():
	_ready_to_fire = true


func _on_MuzzleAnimation_animation_finished():
	$MuzzleAnimation.hide()
