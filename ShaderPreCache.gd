class_name ShaderPreCache extends MeshInstance

var _shader_paths = ["res://shaders/"]
var _to_cache = []
var _dirty := false
onready var material := ShaderMaterial.new()

# Doesn't seem to work with particle shaders, or particles stutter for a reason
# other than shader compilation

func _ready() -> void:
	material_override = material
	for path in _shader_paths:
		explore_path(path)

func _process(delta: float) -> void:
	if not _dirty:
		var shader_path = _to_cache.pop_back()
		if shader_path != null:
			cache_gdshader(shader_path)
		else:
			set_process(false)
		_dirty = true
	else:
		_dirty = false
	
func cache_gdshader(path: String):
	print("Caching ", path)
	var shader: Shader = load(path)
	material.shader = shader

func explore_path(path: String):
	if path.ends_with("/"):
		explore_directory(path)
	elif path.ends_with(".gdshader"):
		_to_cache.append(path)

func explore_directory(path: String):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				explore_directory(path + file_name + "/")
			else:
				explore_path(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: ", path)
