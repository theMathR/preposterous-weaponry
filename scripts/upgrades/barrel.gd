extends GunPart

func _set_wielder(x):
	wielder = x
	$RayCast2D.collision_mask = 10 if wielder.is_enemy() else    12 # Set RayCast mask to shoot through other enemies

func shoot():
	if not $Cooldown.is_stopped(): return
	$Cooldown.start()
	#await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	$ShootSound.play()
	wielder.knockback += 1
	$AnimationPlayer.play("shoot")
	hit($RayCast2D.get_collider())
