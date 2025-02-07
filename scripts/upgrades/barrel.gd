extends GunPart

func shoot():
	if not $Cooldown.is_stopped(): return
	$Cooldown.start()
	await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	$ShootSound.play()
	wielder.knockback += 1
	$AnimationPlayer.play("shoot")
	hit($RayCast2D.get_collider())
