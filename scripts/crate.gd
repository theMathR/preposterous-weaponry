extends Damageable

func damage(dmg):
	super.damage(dmg)
	if 2*hp < max_hp:
		$Sprites.texture = load("res://assets/misc/crate/damaged.png")

func _physics_process(delta):
	velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0, 4096*2. * delta)
	move_and_slide()


func die():
	$Sprites.hide()
	$CollisionShape2D.set_deferred('disabled', true)
	$DeathParticles.restart()
func _on_death_particles_finished():
	queue_free()
