extends GunPart

var shooting = false

func hit_target():
	var targets = $Area2D.get_overlapping_bodies().filter(func (x): return is_instance_of(x, Damageable))
	
	if not targets:
		$Random.rotation_degrees = randf_range(-20, 20)
		$Random/Node2D.position.x = randf_range(400, 800)
		$Zap.to = $Random/Node2D
	else:
		var target = targets.pick_random()
		hit(target)
		$Zap.to = target

func shoot():
	shooting = true
func release():
	shooting = false

func deploy():
	$AnimationTree['parameters/conditions/deploy'] = true
