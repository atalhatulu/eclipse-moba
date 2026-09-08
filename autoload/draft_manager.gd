class_name DraftManagerAutoload
extends Node

## Deterministic local draft state.  It is intentionally independent from the
## selection screen so the same sequence can later be driven by a host/server.

signal draft_changed(state: Dictionary)
signal draft_completed(radiant_pick: String, dire_pick: String)

enum Phase { IDLE, RADIANT_BAN, DIRE_BAN, RADIANT_PICK, DIRE_PICK, COMPLETE }

@export var bans_per_team: int = 2
var phase: Phase = Phase.IDLE
var radiant_bans: Array[String] = []
var dire_bans: Array[String] = []
var radiant_pick := ""
var dire_pick := ""

func begin() -> void:
	phase = Phase.RADIANT_BAN
	radiant_bans.clear()
	dire_bans.clear()
	radiant_pick = ""
	dire_pick = ""
	_emit_changed()

func reset() -> void:
	phase = Phase.IDLE
	radiant_bans.clear()
	dire_bans.clear()
	radiant_pick = ""
	dire_pick = ""
	_emit_changed()

func can_select(hero_id: String) -> bool:
	var id = hero_id.to_lower()
	return HeroDefinition.has_definition(id) and not id in radiant_bans and not id in dire_bans and id != radiant_pick and id != dire_pick

func apply_selection(hero_id: String) -> bool:
	var id = hero_id.to_lower()
	if not can_select(id):
		return false
	match phase:
		Phase.RADIANT_BAN:
			radiant_bans.append(id)
			phase = Phase.DIRE_BAN if radiant_bans.size() >= bans_per_team else Phase.RADIANT_BAN
		Phase.DIRE_BAN:
			dire_bans.append(id)
			phase = Phase.RADIANT_PICK if dire_bans.size() >= bans_per_team else Phase.DIRE_BAN
		Phase.RADIANT_PICK:
			radiant_pick = id
			phase = Phase.DIRE_PICK
		Phase.DIRE_PICK:
			dire_pick = id
			phase = Phase.COMPLETE
			GlobalHeroSelection.set_player_hero(radiant_pick)
			GlobalHeroSelection.set_bot_hero(dire_pick)
			draft_completed.emit(radiant_pick, dire_pick)
		_:
			return false
	_emit_changed()
	return true

func get_phase_label() -> String:
	match phase:
		Phase.IDLE: return "Serbest seçim"
		Phase.RADIANT_BAN: return "Radiant yasaklıyor (%d/%d)" % [radiant_bans.size() + 1, bans_per_team]
		Phase.DIRE_BAN: return "Dire yasaklıyor (%d/%d)" % [dire_bans.size() + 1, bans_per_team]
		Phase.RADIANT_PICK: return "Radiant seçim yapıyor"
		Phase.DIRE_PICK: return "Dire seçim yapıyor"
		Phase.COMPLETE: return "Draft tamamlandı"
	return ""

func get_state() -> Dictionary:
	return {"phase": phase, "radiant_bans": radiant_bans.duplicate(), "dire_bans": dire_bans.duplicate(), "radiant_pick": radiant_pick, "dire_pick": dire_pick}

func _emit_changed() -> void:
	draft_changed.emit(get_state())
