class_name TestRunnerScene
extends Control

## Visual on-screen test runner scene for Godot editor & headless testing

@onready var output_label: RichTextLabel = $VBox/OutputLabel

func _ready() -> void:
	Database.initialize()
	run_all_tests()

func run_all_tests() -> void:
	if output_label != null:
		output_label.clear()
		output_label.append_text("[b][color=yellow]=== ECLIPSE FRONT OTOMATIK TEST SUITE ===[/color][/b]\n\n")
		
	print("=== ECLIPSE FRONT OTOMATIK TEST SUITE ===")
	
	var suite = TestSuite.new()
	var report = suite.run_all()
	
	for res in report["results"]:
		if res["passed"]:
			if output_label != null:
				output_label.append_text("[color=green]  [GEÇTİ][/color] %s\n" % res["name"])
			print("  [GEÇTİ] %s" % res["name"])
		else:
			if output_label != null:
				output_label.append_text("[color=red]  [HATA][/color] %s - Gerekçe: %s\n" % [res["name"], res["error"]])
			print("  [HATA] %s - Gerekçe: %s" % [res["name"], res["error"]])
			
	if output_label != null:
		output_label.append_text("\n[b]------------------------------------------------[/b]\n")
		output_label.append_text("[b]SONUÇ: %d GEÇTİ, %d HATA[/b]\n" % [report["passed"], report["failed"]])
		output_label.append_text("[b]------------------------------------------------[/b]\n")
		
	print("------------------------------------------------")
	print("SONUÇ: %d GEÇTİ, %d HATA" % [report["passed"], report["failed"]])
	print("------------------------------------------------")
	
	if DisplayServer.get_name() == "headless" or OS.has_feature("template"):
		get_tree().quit(0 if report["failed"] == 0 else 1)
