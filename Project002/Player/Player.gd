extends KinematicBody2D

#常量
#const ABC = 1
#可以将变量前方改成export var来更好的管理数值
export var ACCELERATION = 500	#加速度
export var MAX_SPEED = 80	#速度最大值
export var ROLL_SPEED = 150	#摩擦力2
export var FRICTION = 500	#摩擦力

#计数器，集，里面的常数就会自动有了0，1，2，.....的赋值
enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

var velocity = Vector2.ZERO	#零
var roll_vector = Vector2.DOWN
#velocity速度 = Vector2(0,0)
#Vector2二维向量，表示2D的向量和点

#动画
#var animationPlayer = null
#func _ready():
#	animationPlayer = $AnimationPlayer	#'$'符号，是get_node()的缩写，可以获取树的中节点
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")
												#animstionTree下的整个root
onready var swordHitbox = $HitboxPivot/SwordHitbox

#自定义信号
signal true_popup

	#先将AnimationTree的Active播放关闭，然后通过代码实现运行时才会开始播放
func _ready():
	animationTree.active = true
#傻逼代码，
	
	swordHitbox.knockback_vector = roll_vector
	
#移动
#_physics_process和_process，区别在于前者在使用到物理变量计算时才会用到，没有用物理变量计算时用后者
func _physics_process(delta):	#只要有根据帧率变化的设置就要乘以delta
	match state:
		MOVE:	#移动
			move_state(delta)	#不加这个代码velocity就会裂开，真尼玛奇怪
		
		ROLL:	#翻滚
			roll_state(delta)
		
		ATTACK:	#攻击
			attack_state(delta)
#封装
func move_state(delta):
	var input_vector = Vector2.ZERO	#定义变量
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#输入_向量的 x = 输入.获取动作为键盘按下 右（坐标轴x=1，y=0） - 输入.获取动作为键盘按下 左-1（坐标轴x=-1，y=0）
	#在坐标系网格中，x，左为负数，右为正数
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#输入_向量的 x = 输入.获取动作为键盘按下 下（坐标轴x=0，y=1） - 输入.获取动作为键盘按下 上 （坐标轴x=0，y=-1）
	#在坐标系网格中，y，上为负数，下为正数
	input_vector = input_vector.normalized()
	#输入_向量 等于       输入向量 归一化，也称 标准化
	
	if input_vector != Vector2.ZERO:#如果输入的向量不等于2D向量(0,0)
		
#		if input_vector.x > 0:	#如果输入向量x轴大于0
#			animationPlayer.play("RunRight")	#播放动画向右
#		else:	#如果不是
#			animationPlayer.play("RunLeft")	#播放动画向左
#		使用animstionTree后不在使用该动画播放方式
		
		roll_vector = input_vector
		
		#攻击检测框击退的方向等于向量的方向
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)	#移动时更新混合动画
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		#移动
		#velocity += input_vector * ACCELERATION * delta
			#速度等于输入的向量乘以加速度乘以delta
		#velocity = velocity.clamped(MAX_SPEED)
			#速度等于速度限制（最大速度乘以delta）
		
	else:
#		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#速度等于2D向量(0,0)
		
		animationState.travel("Idle")

#	if Input.is_action_pressed("ui_right"):#如果输入为被按下 右
#		velocity.x = 4#向右移动 4
#		#向右移动速度为 4
#	elif Input.is_action_pressed("ui_left"):#否则如果输入为被按下 左
#		velocity.x = -4#向左移动 -4
#		#向左移动速度为 4		#在坐标系网格中，x,左为负数，右为正数
#	elif Input.is_action_pressed("ui_up"):
#		velocity.y = -4#向上
#	elif Input.is_action_pressed("ui_down"):
#		velocity.y = 4#向下
#		#在坐标系中，y，上为负数，下为正数
#	else:#其他（可理解为没有按键操作）
#		velocity.x = 0#速度为 0
#		velocity.y = 0

	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		#改变state为ATTACK，只运行ATTACK不会运行state machine中的其他代码
	
	#退出
	if Input.is_action_pressed("Esc"):#如果输入为按下esc键
		#发送信号
		emit_signal("true_popup")

	#instructions_Kye
#	if Input.is_action_pressed("ui_up"):
#		print("上")
#	elif Input.is_action_pressed("ui_down"):
#		print("下")
#	elif Input.is_action_pressed("ui_left"):
#		print("左")
#	elif Input.is_action_pressed("attack"):
#		print("空格")
#	elif Input.is_action_pressed("roll"):
#		print("crtl")
#	elif Input.is_action_pressed("Esc"):
#		print("esc")

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED	#翻滚速度
	animationState.travel("Roll")	#动画状态播放，翻滚
	move()
	
func attack_state(_delta):
	velocity = Vector2.ZERO		#防止角色攻击动画播放完后向前移动
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)	#移动和碰撞
	#velocity * delta 这样做的是为了让速度相对于帧率
	#后面也可以乘以MAX_SPEED 因为乘以delta以后velocity会变得非常小
	#但是在指定向量归一化后就不需要在这里加MAX_SPEED了
	#在速度限制里乘过delta后这里也可以不用再乘以delta

#在翻滚动画帧后面插入一个函数关键帧，
func roll_animation_finished():
	velocity = velocity * 0.2	#速度百分之，动画播放完后会有一个向前的移动
	#velocity = Vector2.ZERO		#防止角色攻击动画播放完后向前移动
	state = MOVE

#在攻击动画帧后面插入一个函数关键帧，形成一个循环调用，防止动画放到最后一帧时卡在最后一帧
func attack_animation_finished():
	state = MOVE

