extends Node

#生命值
#export的值有int(整数型)float(浮点数型)，可改变检查器定义数值
export(int) var max_health = 1
onready var health = max_health setget set_health


#监控bat是否no_health
#func _process(delta):
#	if health <= 0:
#		emit_signal("no_health")

#自定义信号
signal no_health

#health每次被设置时就会执行bat信号-=1
func set_health(value):
	
	#每当health被设置时，就会检测health是否<=0,如果是，就发送自定义信号
	health = value
	if health <= 0:
		emit_signal("no_health")
