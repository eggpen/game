extends AnimatedSprite

#获取动画
onready var animatedSprite = $AnimatedSprite

func _ready():
	
	#无论脚本附加在什么特效上，都会链接到信号里的queue_free函数
	#有信号的节点，信号的名称，链接的节点，连接到的函数
	connect("animation_finished",self,"_on_animation_finished")
	
	#动画帧，默认开始帧的值为0
	frame = 0
	
	#调用animatedSprite里面的动画Animate
	play("Animate")

#链接信号
func _on_animation_finished():
	queue_free()
