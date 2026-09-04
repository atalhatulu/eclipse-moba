extends SceneTree

func _init() -> void:
	# Autoload singletons are added after SceneTree construction.  Delaying the
	# suite load keeps its Database references available in direct CLI runs.
	call_deferred("_run_test_suite")

func _run_test_suite() -> void:
	print("Running automated CLI test suite...")
	var suite_script = load("res://tests/test_suite.gd")
	if suite_script == null:
		push_error("Unable to load automated test suite.")
		quit(1)
		return
	var suite = suite_script.new()
	var report = suite.run_all()
	var passed = report.get("passed", 0)
	var failed = report.get("failed", 0)
	print("SONUÇ: %d GEÇTİ, %d HATA" % [passed, failed])
	if failed > 0:
		for res in report.get("results", []):
			if not res.get("passed", false):
				print("FAIL: %s -> %s" % [res.get("name"), res.get("error")])
		quit(1)
	else:
		quit(0)
