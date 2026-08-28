class_name DotaStatusEffectBar
extends HBoxContainer

## Status Effect & Passives Bar (Dota 2 style above ability dashboard - not.png reference)
## Displays active buffs, debuffs, crowd control, and hero-specific passive mechanics

const DotaStatusEffectIconClass = preload("res://systems/ui/dota_status_effect_icon.gd")

@export var target_hero: HeroEntity = null:
	set(val):
		target_hero = val
		_clear_all_icons()

var icon_pool: Array[DotaStatusEffectIcon] = []

func _ready() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	add_theme_constant_override("separation", 6)
	custom_minimum_size = Vector2(0, 36)

func _process(_delta: float) -> void:
	if target_hero == null or not is_instance_valid(target_hero):
		_hide_all_icons()
		return
		
	_refresh_hero_status_effects()

func _clear_all_icons() -> void:
	for c in get_children():
		c.queue_free()
	icon_pool.clear()

func _hide_all_icons() -> void:
	for icon in icon_pool:
		icon.visible = false

func _get_or_create_icon(index: int) -> DotaStatusEffectIcon:
	if index < icon_pool.size():
		var icon = icon_pool[index]
		icon.visible = true
		return icon
		
	var new_icon = DotaStatusEffectIconClass.new()
	add_child(new_icon)
	icon_pool.append(new_icon)
	return new_icon

func _refresh_hero_status_effects() -> void:
	var items_data: Array[Dictionary] = []
	
	# 1. Collect standard StatusEffects from EffectContainer
	if target_hero.effect_container != null:
		for eff in target_hero.effect_container.active_effects:
			var name_clean = eff.effect_id.replace("_", " ").capitalize()
			var desc = _get_effect_description(eff)
			items_data.append({
				"id": eff.effect_id,
				"name": name_clean,
				"desc": desc,
				"is_debuff": eff.is_debuff,
				"dur": eff.duration,
				"rem": eff.remaining_time,
				"stacks": eff.stacks,
				"symbol": _get_effect_symbol(eff),
				"is_passive": false
			})
			
	# 2. Collect Hero-Specific Passive Stacks and Mechanic States
	_collect_hero_specific_passives(target_hero, items_data)
	
	# 3. Update Icon pool
	for i in range(items_data.size()):
		var data = items_data[i]
		var icon = _get_or_create_icon(i)
		icon.configure(
			data["id"],
			data["name"],
			data["desc"],
			data["is_debuff"],
			data["dur"],
			data["rem"],
			data["stacks"],
			data.get("symbol", ""),
			data.get("is_passive", false)
		)
		
	# Hide unused pooled icons
	for j in range(items_data.size(), icon_pool.size()):
		icon_pool[j].visible = false

func _collect_hero_specific_passives(hero: HeroEntity, out_list: Array[Dictionary]) -> void:
	# Veylin (Study Stacks)
	if "study_stacks" in hero:
		var st = int(hero.get("study_stacks"))
		if st > 0:
			out_list.append({
				"id": "veylin_study",
				"name": "Çalışma (Study Stacks)",
				"desc": "Her yığın +8 Yetenek Gücü (AP) sağlar. Toplam: +%d AP" % (st * 8),
				"is_debuff": false,
				"dur": -1.0,
				"rem": -1.0,
				"stacks": st,
				"symbol": str(st),
				"is_passive": true
			})
			
	# Zyraen (Equilibrium State)
	if "is_in_equilibrium" in hero and hero.get("is_in_equilibrium"):
		out_list.append({
			"id": "zyraen_equilibrium",
			"name": "Kusursuz Denge (Equilibrium)",
			"desc": "Can ve Mana yüzdesi dengede! +35 Yetenek Gücü (AP) ve %15 Hasar Azaltma aktif.",
			"is_debuff": false,
			"dur": -1.0,
			"rem": -1.0,
			"stacks": 1,
			"symbol": "☯",
			"is_passive": true
		})
		
	# Varyn (Flow / Akış)
	if "flow" in hero:
		var fl = float(hero.get("flow"))
		if fl > 0.0:
			var bonus_ad = (fl / 10.0) * 3.0
			var bonus_ms = (fl / 10.0) * 1.0
			out_list.append({
				"id": "varyn_flow",
				"name": "Akış (Flow)",
				"desc": "Akış: %.0f / 100. (+%.1f Saldırı Gücü, +%.0f%% Hareket Hızı)" % [fl, bonus_ad, bonus_ms],
				"is_debuff": false,
				"dur": 3.0,
				"rem": float(hero.get("flow_decay_timer")) if "flow_decay_timer" in hero else 3.0,
				"stacks": int(fl / 10.0),
				"symbol": "≈",
				"is_passive": true
			})
			
	# Mira (Velocity AD)
	if "last_calculated_velocity_ad" in hero:
		var vel_ad = float(hero.get("last_calculated_velocity_ad"))
		if vel_ad > 0.1:
			out_list.append({
				"id": "mira_velocity",
				"name": "Hız Gücü (Velocity)",
				"desc": "Yüksek hareket hızından kaynaklanan bonus saldırı gücü: +%.1f AD" % vel_ad,
				"is_debuff": false,
				"dur": -1.0,
				"rem": -1.0,
				"stacks": 1,
				"symbol": "⚡",
				"is_passive": true
			})
			
	# Mira Evading
	if "is_evading" in hero and hero.get("is_evading"):
		out_list.append({
			"id": "mira_evade",
			"name": "Sıyrılma (Evade)",
			"desc": "Tüm gelen hasarlardan sıyrılır ve hasar almaz.",
			"is_debuff": false,
			"dur": 1.2,
			"rem": float(hero.get("slip_timer")) if "slip_timer" in hero else 1.0,
			"stacks": 1,
			"symbol": "💨",
			"is_passive": false
		})
		
	# Mira Sonic Run
	if "is_sonic_running" in hero and hero.get("is_sonic_running"):
		out_list.append({
			"id": "mira_sonic",
			"name": "Ses Hızı Koşusu (Sonic Run)",
			"desc": "+%80 Hareket Hızı ve temas edilen düşmanlara yüksek büyü hasarı.",
			"is_debuff": false,
			"dur": 5.0,
			"rem": float(hero.get("sonic_run_timer")) if "sonic_run_timer" in hero else 5.0,
			"stacks": 1,
			"symbol": "★",
			"is_passive": false
		})
		
	# Neris (Active Matrix Nodes)
	if "active_nodes" in hero:
		var nodes = hero.get("active_nodes")
		if nodes is Array and not nodes.is_empty():
			out_list.append({
				"id": "neris_nodes",
				"name": "Rezonans Düğümleri",
				"desc": "Haritada aktif %d adet rezonans düğümü mevcut." % nodes.size(),
				"is_debuff": false,
				"dur": 8.0,
				"rem": 8.0,
				"stacks": nodes.size(),
				"symbol": str(nodes.size()),
				"is_passive": true
			})
			
	# Nyxara (Vanish)
	if "is_vanished" in hero and hero.get("is_vanished"):
		out_list.append({
			"id": "nyxara_vanish",
			"name": "Gölgeye Çekilme (Vanish)",
			"desc": "Görünmezlik ve %30 Hareket Hızı artışı.",
			"is_debuff": false,
			"dur": 4.0,
			"rem": float(hero.get("vanish_timer")) if "vanish_timer" in hero else 4.0,
			"stacks": 1,
			"symbol": "👁",
			"is_passive": false
		})

func _get_effect_description(eff: StatusEffect) -> String:
	match eff.effect_type:
		StatusEffect.EffectType.STUN:
			return "Sersemletildi! Karakter hareket edemez ve yetenek kullanamaz."
		StatusEffect.EffectType.SILENCE:
			return "Susturuldu! Büyü ve yetenekler kilitli."
		StatusEffect.EffectType.SLOW:
			return "Yavaşlatıldı! Hareket hızı %%.0f%% oranında azaldı." % (eff.intensity * 100.0)
		StatusEffect.EffectType.ROOT:
			return "Yere sabitlendi! Hareket edilemez."
		StatusEffect.EffectType.INVULNERABILITY:
			return "Dokunulmazlık! Hiçbir kaynaktan hasar veya olumsuz etki alınamaz."
		StatusEffect.EffectType.SHIELD:
			return "Kalkan Aktif! %.0f hasar emme kapasitesi." % eff.intensity
		StatusEffect.EffectType.DAMAGE_OVER_TIME:
			return "Zamanla Hasar! Her saniye %.0f hasar verir." % (eff.intensity * 2.0)
		StatusEffect.EffectType.DAMAGE_REDUCTION:
			return "Hasar Azaltma! Alınan tüm hasarlar %%.0f%% azaltılır." % (eff.intensity * 100.0)
		StatusEffect.EffectType.BUFF:
			return "Güçlendirme aktif."
		_:
			return "Aktif durum etkisi."

func _get_effect_symbol(eff: StatusEffect) -> String:
	match eff.effect_type:
		StatusEffect.EffectType.STUN: return "✕"
		StatusEffect.EffectType.SILENCE: return "!"
		StatusEffect.EffectType.SLOW: return "▼"
		StatusEffect.EffectType.ROOT: return "☗"
		StatusEffect.EffectType.INVULNERABILITY: return "★"
		StatusEffect.EffectType.SHIELD: return "🛡"
		StatusEffect.EffectType.DAMAGE_OVER_TIME: return "☠"
		StatusEffect.EffectType.BUFF: return "▲"
		_: return "✦"
