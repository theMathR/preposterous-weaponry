extends Damageable

func damage(dmg):
	super.damage(dmg)
	if hp < max_hp/2:
		$Sprites.texture = load("res://assets/misc/crate/damaged.png")

func _physics_process(delta):
	shake(delta)
	velocity += get_gravity() * delta
	move_and_slide()
