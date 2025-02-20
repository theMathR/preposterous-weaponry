extends GunPart

func shoot():
	if $AnimationPlayer.is_playing(): return
	#await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	wielder.knockback += 1
	$ShootSound.play()
	$AnimationPlayer.play("shoot")
	for body in $Area2D.get_overlapping_bodies():
		hit(body)
