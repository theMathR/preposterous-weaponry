extends GunPart

func shoot():
	if $AnimationPlayer.is_playing(): return
	#await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	wielder.knockback += 2
	wielder.velocity += Vector2(-6000,0).rotated(global_rotation) * Vector2(1,0.65)
	#if wielder.velocity.length_squared() > 6000**2: # Remove to sta
	#	wielder.velocity *= 6000/wielder.velocity.length()
	$ShootSound.play()
	$AnimationPlayer.play("shoot")
	for body in $Area2D.get_overlapping_bodies():
		hit(body)
