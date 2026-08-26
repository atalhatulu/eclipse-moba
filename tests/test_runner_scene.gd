class_name TestRunnerScene
extends Control

## Visual on-screen test runner scene for Godot editor

@onready var output_label: RichTextLabel = $VBox/OutputLabel

func _ready() -> void:
	Database.initialize()
	run_all_tests()

func run_all_tests() -> void:
	output_label.clear()
	output_label.append_text("[b][color=yellow]=== ECLIPSE FRONT OTOMATIK TEST SUITE ===[/color][/b]\n\n")
	
	var suite = TestSuite.new()
	var report = suite.run_all()
	
	for res in report["results"]:
		if res["passed"]:
			output_label.append_text("[color=green]  [GEÇTİ][/color] %s\n" % res["name"])
		else:
			output_label.append_text("[color=red]  [HATA][/color] %s - Gerekçe: %s\n" % [res["name"], res["error"]])
			
	output_label.append_text("\n[b]------------------------------------------------[/b]\n")
	output_label.append_text("[b]SONUÇ: %d GEÇTİ, %d HATA[/b]\n" % [report["passed"], report["failed"]])
	output_label.append_text("[b]------------------------------------------------[/b]\n")
	
	if report["failed"] == 0:
		output_label.append_text("[color=lime][b]Tüm çekirdek oynanış sistemleri ve test sahneleri başarıyla çalışıyor.[/b][/color]\n")
	else:
		output_label.append_text("[color=red][b]Bazı testler başarısız oldu.[/b][/color]\n")
