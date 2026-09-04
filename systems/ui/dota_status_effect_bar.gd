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
		var was_hidden = not icon.visible
		icon.visible = true
		if was_hidden:
			icon.play_entry_animation()
		return icon
		
	var new_icon = DotaStatusEffectIconClass.new()
	add_child(new_icon)
	icon_pool.append(new_icon)
	new_icon.call_deferred("play_entry_animation")
	return new_icon

func _refresh_hero_status_effects() -> void:
	var items_data: Array[Dictionary] = []
	
	# 1. Collect standard StatusEffects from EffectContainer
	if target_hero.effect_container != null:
		for eff in target_hero.effect_container.active_effects:
			var name_clean = _get_effect_display_name(eff)
			var desc = _get_effect_description(eff)
			if eff.source_entity != null and is_instance_valid(eff.source_entity):
				var source_name = eff.source_entity.entity_name if "entity_name" in eff.source_entity else eff.source_entity.name
				desc += "\nKaynak: " + source_name
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
	_collect_equipped_item_passives(target_hero, items_data)
	
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

func _collect_equipped_item_passives(hero: HeroEntity, out_list: Array[Dictionary]) -> void:
	if hero.inventory_manager == null:
		return
	for item in hero.inventory_manager.get_all_equipped_items():
		if item == null or item.item_tags.is_empty():
			continue
		var effects: Array[String] = []
		for tag in item.item_tags:
			effects.append(_get_item_passive_text(tag))
		out_list.append({
			"id": "item_passive_%d" % item.id,
			"name": item.item_name + " — Pasif",
			"desc": item.description + "\nPasif: " + ", ".join(effects),
			"is_debuff": false,
			"dur": -1.0,
			"rem": -1.0,
			"stacks": 1,
			"symbol": "◆",
			"is_passive": true
		})

func _get_item_passive_text(tag: String) -> String:
	match tag:
		"ON_HIT_BLEED": return "Vuruşta Kanama"
		"ON_HIT_SLOW": return "Vuruşta Yavaşlatma"
		"ON_HIT_MANA_BURN": return "Vuruşta Mana Yakma"
		"ON_HIT_CHAIN_LIGHTNING": return "Zincir Yıldırım"
		"DEFENSIVE_THORNS": return "Dikenli Yansıma"
		"DEFENSIVE_LIFELINE": return "Can Kurtaran Kalkan"
		"ON_KILL_HEAL": return "Öldürmede İyileşme"
		_: return tag.replace("_", " ").capitalize()

func _get_effect_description(eff: StatusEffect) -> String:
	if eff.has_meta("description"):
		return str(eff.get_meta("description"))
	if eff.effect_id == "hero_combo_momentum":
		return "Üç farklı yetenek art arda kullanıldı. 3 saniye boyunca %10 ilave hasar verir."
	if eff.effect_id == "fallback_combat_rhythm":
		return "Yetenek kullandıktan sonra 3 saniye boyunca %12 Saldırı Hızı kazanır."
	if eff.get_meta("airborne", false):
		return "Havada! Hareket, saldırı ve yetenek kullanımı kilitli."
	if eff.get_meta("grants_invisibility", false):
		return "Görünmez. Gerçek görüş yoksa hedef seçilemez."
	match eff.effect_type:
		StatusEffect.EffectType.STUN:
			return "Sersemletildi! Karakter hareket edemez ve yetenek kullanamaz."
		StatusEffect.EffectType.SILENCE:
			return "Susturuldu! Büyü ve yetenekler kilitli."
		StatusEffect.EffectType.SLOW:
			return "Yavaşlatıldı! Hareket hızı %%.0f%% oranında azaldı." % (eff.intensity * 100.0)
		StatusEffect.EffectType.ROOT:
			return "Yere sabitlendi! Hareket edilemez."
		StatusEffect.EffectType.KNOCKBACK:
			return "Geri itiliyor! Konum kontrolü geçici olarak kaybedildi."
		StatusEffect.EffectType.DISARM:
			return "Silahsızlandırıldı! Normal saldırı yapılamaz."
		StatusEffect.EffectType.BLIND:
			return "Kör edildi! Normal saldırıların %%%.0f kadarı ıskalar." % (eff.intensity * 100.0)
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

func _get_effect_display_name(eff: StatusEffect) -> String:
	if eff.has_meta("display_name"):
		return str(eff.get_meta("display_name"))
	if eff.effect_id == "hero_combo_momentum":
		return "Combo Momentumu"
	if eff.effect_id == "fallback_combat_rhythm":
		return "Savaş Ritmi"
	if eff.get_meta("airborne", false):
		return "Havaya Kaldırıldı"
	if eff.get_meta("grants_invisibility", false):
		return "Görünmezlik"
	match eff.effect_type:
		StatusEffect.EffectType.STUN: return "Sersemletme"
		StatusEffect.EffectType.SILENCE: return "Susturma"
		StatusEffect.EffectType.SLOW: return "Yavaşlatma"
		StatusEffect.EffectType.ROOT: return "Köklenme"
		StatusEffect.EffectType.KNOCKBACK: return "Geri İtme"
		StatusEffect.EffectType.DISARM: return "Silahsızlandırma"
		StatusEffect.EffectType.BLIND: return "Körlük"
		StatusEffect.EffectType.SHIELD: return "Kalkan"
		StatusEffect.EffectType.DAMAGE_OVER_TIME: return "Zamanla Hasar"
		StatusEffect.EffectType.HEAL_OVER_TIME: return "Zamanla İyileşme"
	return eff.effect_id.replace("_", " ").capitalize()

func _get_effect_symbol(eff: StatusEffect) -> String:
	if eff.has_meta("symbol"):
		return str(eff.get_meta("symbol"))
	match eff.effect_type:
		StatusEffect.EffectType.STUN: return "✕"
		StatusEffect.EffectType.SILENCE: return "!"
		StatusEffect.EffectType.SLOW: return "▼"
		StatusEffect.EffectType.ROOT: return "☗"
		StatusEffect.EffectType.KNOCKBACK: return "↝"
		StatusEffect.EffectType.DISARM: return "⚔"
		StatusEffect.EffectType.BLIND: return "◉"
		StatusEffect.EffectType.INVULNERABILITY: return "★"
		StatusEffect.EffectType.SHIELD: return "🛡"
		StatusEffect.EffectType.DAMAGE_OVER_TIME: return "☠"
		StatusEffect.EffectType.BUFF: return "▲"
		_: return "✦"
