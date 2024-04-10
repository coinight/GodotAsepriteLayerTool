@tool
extends Node2D

@export_file("*.json") var sourceJson :
	set(value):
		sourceJson = value
		print(sourceJson.split(".")[0]+".png")
		source = ResourceLoader.load(sourceJson.split(".")[0]+".png")
		loadResource()
@export var source:Texture2D
@export var loadEnable:bool = false:
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
		#var layer = 0
		var i = 0
		for spriteData in data["frames"]:
			print(spriteData)
			print(spriteData["filename"])
			#var meta = data["meta"]["layers"][layer]
			#print(meta)
			var node = Sprite2D.new()
			node.name = spriteData["filename"].split("(")[1].split(")")[0]
			node.texture = source
			node.region_enabled = true
			node.region_rect = Rect2(spriteData["frame"]["x"],spriteData["frame"]["y"],
				spriteData["frame"]["w"],spriteData["frame"]["h"])
			node.position = Vector2(spriteData["spriteSourceSize"]["x"] + spriteData["frame"]["w"]/2,
				spriteData["spriteSourceSize"]["y"] + spriteData["frame"]["h"]/2)
			#node.self_modulate.a = meta["opacity"]/255
			add_child(node)
			node.owner = get_tree().edited_scene_root
			node.z_index = i
			i += 1
			#layer += 1
		for l in data["meta"]["layers"]:
			var n:Sprite2D = get_node(l["name"])
			if n:
				if l.has("opacity"):
					n.self_modulate.a = l["opacity"]/255
				if l.has("group"):
					n.get_parent().remove_child(n)
					get_node(l["group"]).add_child(n)
					n.owner = get_tree().edited_scene_root
			else:
				var t = Node2D.new()
				t.name = l["name"]
				add_child(t)
				t.owner = get_tree().edited_scene_root
	set_script(null)
