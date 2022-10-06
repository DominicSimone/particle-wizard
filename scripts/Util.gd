class_name Util

static func rand_array(array: Array):
	return array[randi() % array.size()]

static func parent_hook(object: Node, signal_name: String):
	var method_name = "_on_" + signal_name
	if object.get_parent().has_method(method_name):
		object.connect(signal_name, object.get_parent(), method_name)
	else:
		printerr("Parent does not have a '", method_name, "' method.")
