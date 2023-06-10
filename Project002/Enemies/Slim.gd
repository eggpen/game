extends KinematicBody2D
#受到攻击时有击退效果

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

#移动时所需要的数值
export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 200

#小怪的三种状态，
enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO

#定义位置为0
var knockback = Vector2.ZERO

#初始值为
var state = CHASE

#引用场景
onready var animatedSprite = $AnimatedSprite
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

#运行时播放动画
func _ready():
	animatedSprite.playing = true
	
#摩擦力	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:					#向前移动
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:#获取玩家向量并追踪玩家
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:#停止移动
				state = IDLE
			#方向始终面向玩家
			sprite.flip_h = velocity.x < 0
	
	#速度=移动和滑动（速度）
	velocity = move_and_slide(velocity)

#寻找玩家
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

#信号
func _on_hurtbox_area_entered(area):
	
	#受到攻击减的血量
	#stats.health -= 1
	stats.health -= area.damage
	
	#if stats.health <= 0:	#如果为零时销毁
	#	queue_free()
	
	#被击退时，后退的距离
	#var knockback_vector = area.knockback_vector
	knockback = area.knockback_vector * 150
	
	#死亡效果
func _on_Stats_no_health():
	queue_free()
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
