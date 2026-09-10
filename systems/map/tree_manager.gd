class_name TreeManager
extends Node

const TreeEntityClass = preload("res://core/entities/tree_entity.gd")

## Manages tree clusters, chopping and dynamic navigation obstables in Eclipse MOBA

static func chop_nearest_tree_to(pos: Vector3, max_range: float = 3.5, destroyer: Node = null) -> Node3D:
	var tree_nodes: Array = []
	if Engine.has_singleton("TreeManager"):
		var tm = Engine.get_singleton("TreeManager")
		tree_nodes = tm.get_tree().get_nodes_in_group("trees")
	elif destroyer != null and destroyer.is_inside_tree() and destroyer.get_tree() != null:
		tree_nodes = destroyer.get_tree().get_nodes_in_group("trees")
	elif destroyer != null:
		# Fallback for standalone test nodes
		for c in destroyer.get_children():
			if c.is_in_group("trees"):
				tree_nodes.append(c)
		if destroyer.get_parent() != null:
			for c in destroyer.get_parent().get_children():
				if c.is_in_group("trees"):
					tree_nodes.append(c)
		
	var closest: Node3D = null
	var min_dist: float = max_range
	
	for n in tree_nodes:
		if is_instance_valid(n) and ("is_alive_tree" in n) and n.is_alive_tree:
			var d = pos.distance_to(n.global_position if n.is_inside_tree() else n.position)
			if d <= min_dist:
				min_dist = d
				closest = n
				
	if closest != null:
		closest.chop(destroyer)
		return closest
	return null

static func get_trees_in_radius(tree: SceneTree, pos: Vector3, radius: float) -> Array[Node3D]:
	var result: Array[Node3D] = []
	if tree == null:
		return result
	for n in tree.get_nodes_in_group("trees"):
		if is_instance_valid(n) and ("is_alive_tree" in n) and n.is_alive_tree:
			if pos.distance_to(n.global_position) <= radius:
				result.append(n)
	return result

static func spawn_grove(parent: Node, center: Vector3, count: int = 5, spread: float = 4.0, is_dire: bool = false) -> Array[Node3D]:
	var spawned: Array[Node3D] = []
	if parent == null:
		return spawned
	for i in range(count):
		var tree = TreeEntityClass.new()
		tree.is_dire_side = is_dire
		var angle = (float(i) / float(count)) * TAU
		var offset = Vector3(cos(angle) * (spread * 0.7 + randf() * spread * 0.3), 0, sin(angle) * (spread * 0.7 + randf() * spread * 0.3))
		tree.position = center + offset
		parent.add_child(tree)
		spawned.append(tree)
	return spawned
