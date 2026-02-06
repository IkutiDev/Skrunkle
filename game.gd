@tool
extends Node2D

@export var skrunklies_scenes : Array[PackedScene]
@export var x_count : int
@export var y_count : int
@export var top_left_corner_position : Marker2D
@export var instances_parent : Node2D
@export_tool_button("test build board") var test_build = _reshuffle
@export_tool_button("clear") var clear = clear_board

var x_size : int = 200
var y_size : int = 175

var skrunkly_held : bool = false
var is_moving : bool = false

var _instances :  Array[Node2D]

func _ready() -> void:
	for s in skrunklies_scenes:
		_instances.append(s.instantiate())
	spawn_board()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reshuffle"):
		_reshuffle()
	if event.is_action_pressed("press_skrunkly"):
		pressed_skrunkly()
	if event.is_action_released("press_skrunkly"):
		release_skrunkly()
		
	if skrunkly_held and event is InputEventMouseMotion and not is_moving:
		
		if abs((event as InputEventMouseMotion).relative.y) > 2.0:
			print("Moving vertically")
			is_moving = true
		elif abs((event as InputEventMouseMotion).relative.x) > 2.0:
			print("Moving horizontally")
			is_moving = true

func spawn_board() -> void:
	var current_position : Vector2 = top_left_corner_position.position
	for x in x_count:
		for y in y_count:
			var instance : Node2D = skrunklies_scenes.pick_random().instantiate()
			instance.position = current_position
			instance.owner = self
			instances_parent.add_child(instance)
			current_position.y += y_size
		current_position.x += x_size
		current_position.y = top_left_corner_position.position.y
		
		
func clear_board() -> void:
	for c in instances_parent.get_children():
		instances_parent.remove_child(c)
		c.queue_free()
		
func _reshuffle() -> void:
	clear_board()
	spawn_board()

func pressed_skrunkly() -> void:
	print("Pressed Skrunkly")
	skrunkly_held = true

func release_skrunkly() -> void:
	print("No longer holding skrunkly. Check if position of skrunklies is within bounds and if any match happened")
	skrunkly_held = false
	is_moving = false
	
