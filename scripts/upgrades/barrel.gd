extends GunPart

func _set_wielder(x):
	wielder = x
	#$RayCast2D.collision_mask += 2  if wielder.is_in_group('enemies') else 4 # Set RayCast mask to shoot through other enemies

func shoot():
	if $AnimationPlayer.is_playing(): return
	#await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	$ShootSound.play()
	wielder.knockback += 1
	$AnimationPlayer.play("shoot")
	hit($RayCast2D.get_collider())
