extends Area2D

var player = null

#函数返回玩家是否在zone内
func can_see_player():
	return player != null

#玩家进入区域
func _on_PlayerDetectionZone_body_entered(body):
	player = body


#玩家离开区域
func _on_PlayerDetectionZone_body_exited(body):
	player = null
