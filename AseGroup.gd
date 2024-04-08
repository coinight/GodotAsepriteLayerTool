@tool
extends Node2D

@export_file var sourceJson :
	set(value):
		sourceJson = value
		print(sourceJson.split(".")[0]+".png")
		source = ResourceLoader.load(sourceJson.split(".")[0]+".png")
		loadResource()
@export var source:Texture2D
@export var load:bool = false:
	set(value):
		loadResource()

func loadResource():
	print("load")
	for i in range(get_child_count()):
		get_child(0).free()
	var file = FileAccess.open(sourceJson, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data = json.data
		var layer = 0
		for spriteData in data["frames"]:
			#print(spriteData)
			#print(spriteData["filename"])
			var meta = data["meta"]["layers"][layer]
			print(meta)
			var node = Sprite2D.new()
			node.name = spriteData["filename"].split("(")[1].split(")")[0]
			node.texture = source
			node.region_enabled = true
			node.region_rect = Rect2(spriteData["frame"]["x"],spriteData["frame"]["y"],
				spriteData["frame"]["w"],spriteData["frame"]["h"])
			node.position = Vector2(spriteData["spriteSourceSize"]["x"] + spriteData["frame"]["w"]/2,
				spriteData["spriteSourceSize"]["y"] + spriteData["frame"]["h"]/2)
			node.self_modulate.a = meta["opacity"]/255
			add_child(node)
			node.owner = get_tree().edited_scene_root
			node.z_index = layer
			layer += 1
	set_script(null)
