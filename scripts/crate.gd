extends Damageable

func damage(dmg):
	super.damage(dmg)
	if 2*hp < max_hp:
		$Sprites.texture = load("res://assets/misc/crate/damaged.png")

func _physics_process(delta):
	shake(delta)
	velocity += get_gravity() * delta
	move_and_slide()


func die():
	$Sprites.hide()
	$CollisionShape2D.disabled = true
	$DeathParticles.restart()
func _on_death_particles_finished():
	queue_free()
