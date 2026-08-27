extends SceneTree

func _init() -> void:
	print("Running automated CLI test suite...")
	var suite = TestSuite.new()
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
