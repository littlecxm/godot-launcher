extends Node

var always_on_top_wanted: Array = []

onready var library = $NativeLibrary


func _ready():
	if not library.has_method("start"):
		push_error("NativeLibrary is missing expected method: start")
		return
	library.call("start")


func _set_window_always_on_top(enabled: bool) -> void:
	if not library.has_method("get_window_id") or not library.has_method("set_always_on_top"):
		push_error("NativeLibrary is missing expected methods: get_window_id/set_always_on_top")
		return

	var window_id = library.call("get_window_id")
	library.call("set_always_on_top", window_id, enabled)


func want_always_on_top(object):
	var on_top = always_on_top_wanted.size() > 0
	if not always_on_top_wanted.has(object):
		always_on_top_wanted.append(object)
		if always_on_top_wanted.size() > 0 and not on_top:
			_set_window_always_on_top(true)


func unwant_always_on_top(object):
	var on_top = always_on_top_wanted.size() > 0
	if always_on_top_wanted.has(object):
		always_on_top_wanted.erase(object)
		if always_on_top_wanted.size() == 0 and on_top:
			_set_window_always_on_top(false)
