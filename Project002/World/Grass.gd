extends Node2D
#调用场景
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	#调用场景
		#var GrassEffect = load("res://Effects/GrassEffect.tscn")
		#将调用的场景变量为节点
		var grassEffect = GrassEffect.instance()
		
		#获取当前场景的根节点
		#var world = get_tree().current_scene
		get_parent().add_child(grassEffect)
		
		grassEffect.global_position = global_position


func _on_hurtbox_area_entered(area):
	
		create_grass_effect()
	
		#queue_free()会把将要删除,但不会立即删除的节点放进_free()里面，通常是在帧结束后删除
		#和free()不同，free会立即删除
		queue_free()
