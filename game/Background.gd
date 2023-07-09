extends Node2D

func move(delta):
	$Mountains.global_position.x -= delta*0.037
	$Trees.global_position.x -= delta*0.25
	var x = $Mountains.texture.get_size().x*$Mountains.scale.x
	if $Mountains.global_position.x <= -x:
		$Mountains.global_position.x += x
	x = $Trees.texture.get_size().x*$Trees.scale.x-16
	if $Trees.global_position.x <= -x:
		$Trees.global_position.x += x
