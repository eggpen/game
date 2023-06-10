extends Popup

#esc信号
func _on_Player_true_popup():

	popup()
	

#get_tree().quit()	#结束运行

onready var instructions = $"../instructions"


#结束运行
func _on_Yes_button_up():
	get_tree().quit()	#结束运行

#关闭界面
func _on_No_button_up():
	
	visible = false

#打开说明
func _on_instructions_button_up():
	visible = false
	instructions.visible = true
	
