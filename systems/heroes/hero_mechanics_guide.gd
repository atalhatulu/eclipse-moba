class_name HeroMechanicsGuide
extends RefCounted

## Produces a consistent, data-driven gameplay primer for every hero.  Ability
## resources remain authoritative: this layer turns their exact targeting and
## effect data into player-facing combo and counterplay guidance.

static func get_guide(hero: HeroResource) -> Dictionary:
	if hero == null:
		return {}
	var abilities := [hero.q_ability, hero.w_ability, hero.e_ability, hero.r_ability]
	var has_bespoke_passive := hero.passive_ability != null
	var passive := hero.get_ability_by_slot(AbilityResource.Slot.PASSIVE)
	var passive_desc := passive.description if passive != null else "Temel niteliklerini savaş boyunca verimli kullanır."
	if passive_desc.is_empty():
		passive_desc = "Doğuştan beceri; kahramanın ana oyun planını destekler."
	var passive_name := passive.ability_name if passive != null else "Doğuştan Pasif"
	if not has_bespoke_passive:
		passive_name = "Savaş Ritmi (Combat Rhythm)"
		passive_desc = "Bir yetenek kullandıktan sonra 3 saniyeliğine %12 Saldırı Hızı kazanır. Farklı yetenekleri zincirleyerek baskıyı sürdür."
	return {
		"passive_name": passive_name,
		"passive_desc": passive_desc,
		"combo": _build_combo(abilities),
		"counterplay": _build_counterplay(abilities),
		"targeting": _build_targeting_rules(abilities)
	}

static func _build_combo(abilities: Array) -> String:
	var steps: Array[String] = []
	var labels := ["Q", "W", "E", "R"]
	for i in range(abilities.size()):
		var ab: AbilityResource = abilities[i] as AbilityResource
		if ab == null:
			continue
		var role := _combo_role(ab)
		steps.append("%s %s: %s" % [labels[i], ab.ability_name, role])
	return " → ".join(steps)

static func _combo_role(ab: AbilityResource) -> String:
	if ab.applies_status_effect or ab.pull_force > 0.0:
		return "hedefi kontrol altına al"
	if ab.target_type == AbilityResource.TargetType.GROUND_AOE:
		return "kaçış yoluna/çatışma merkezine bırak"
	if ab.target_type == AbilityResource.TargetType.DIRECTIONAL:
		return "hattı hizala ve birden fazla hedefi vur"
	if ab.target_type == AbilityResource.TargetType.SELF:
		return "güçlenmeyi aç ve pozisyon al"
	if not ab.base_damage.is_empty() and ab.base_damage[0] > 0.0:
		return "tek hedef hasarını uygula"
	return "duruma göre kullan"

static func _build_counterplay(abilities: Array) -> String:
	var answers: Array[String] = []
	for raw in abilities:
		var ab: AbilityResource = raw as AbilityResource
		if ab == null:
			continue
		if ab.target_type == AbilityResource.TargetType.GROUND_AOE:
			answers.append("%s alanından çık" % ab.ability_name)
		elif ab.target_type == AbilityResource.TargetType.DIRECTIONAL:
			answers.append("%s hattına yandan çık" % ab.ability_name)
		elif ab.target_type == AbilityResource.TargetType.SINGLE_TARGET:
			answers.append("%s menzilinin dışında kal" % ab.ability_name)
		if answers.size() >= 2:
			break
	if answers.is_empty():
		answers.append("güçlenme penceresi bitene kadar mesafeyi koru")
	answers.append("sert CC ile kanal ve büyü zincirini kes")
	return " • ".join(answers) + "."

static func _build_targeting_rules(abilities: Array) -> Array[String]:
	var rules: Array[String] = []
	var labels := ["Q", "W", "E", "R"]
	for i in range(abilities.size()):
		var ab: AbilityResource = abilities[i] as AbilityResource
		if ab == null:
			continue
		rules.append("%s: %s — %s" % [labels[i], _target_type_text(ab.target_type), _target_filter_text(ab.target_filter)])
	return rules

static func _target_type_text(type: AbilityResource.TargetType) -> String:
	match type:
		AbilityResource.TargetType.SINGLE_TARGET: return "Birim hedefli"
		AbilityResource.TargetType.GROUND_AOE: return "Zemin alanı"
		AbilityResource.TargetType.DIRECTIONAL: return "Yön/hattı hedefli"
		AbilityResource.TargetType.SELF: return "Kendine"
		_: return "Pasif"

static func _target_filter_text(filter: AbilityResource.TargetFilter) -> String:
	match filter:
		AbilityResource.TargetFilter.ENEMIES_ONLY: return "düşmanlar ve nötrler"
		AbilityResource.TargetFilter.ENEMY_HEROES_ONLY, AbilityResource.TargetFilter.HEROES_ONLY: return "yalnız düşman hero"
		AbilityResource.TargetFilter.ENEMY_CREEPS_ONLY: return "yalnız düşman creep"
		AbilityResource.TargetFilter.ALLIES_ONLY: return "dostlar (kendin dahil)"
		AbilityResource.TargetFilter.ALLIES_NOT_SELF, AbilityResource.TargetFilter.ALLY_HEROES_ONLY: return "dost birimler"
		AbilityResource.TargetFilter.SELF_ONLY: return "yalnız kendin"
		AbilityResource.TargetFilter.NEUTRALS_ONLY: return "yalnız nötrler"
		AbilityResource.TargetFilter.STRUCTURES_ONLY: return "yalnız yapılar"
		AbilityResource.TargetFilter.ALL_EXCEPT_SELF: return "kendin hariç tüm birimler"
		_: return "tüm geçerli birimler"
