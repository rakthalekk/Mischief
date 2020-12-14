extends Area2D

export var num = 1

func _on_Key_body_entered(body):
	get_node("../KeyBlock" + str(num)).queue_free()
	queue_free()
