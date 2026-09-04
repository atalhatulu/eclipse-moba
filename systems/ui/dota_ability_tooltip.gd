class_name DotaAbilityTooltip
extends PanelContainer

## Authentic Dota 2 Ability & Innate Floating Card
## Displays all core stats, scaling values, and mechanical interaction notes together in one clean, zero-lag window.

var title_label: Label = null
var slot_badge_label: Label = null
var level_label: Label = null

var target_type_val: Label = null
var target_filter_val: Label = null
var damage_type_val: Label = null
var bkb_pierce_val: Label = null

var desc_label: Label = null
var stats_vbox: VBoxContainer = null

var cooldown_val_label: Label = null
var mana_val_label: Label = null

var mechanics_box: PanelContainer = null
var mechanics_label: Label = null

func _init() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(380, 0)
	visible = false
	_build_ui()

func _build_ui() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.11, 0.92) # Deep Obsidian Night
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.0, 0.86, 0.95, 0.35) # Electric Cyan Glow
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_size = 12
	style.shadow_color = Color(0, 0, 0, 0.75)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	add_theme_stylebox_override("panel", style)
	
	var main_v = VBoxContainer.new()
	main_v.add_theme_constant_override("separation", 8)
	add_child(main_v)
	
	# 1. Header (Title, Slot Key & Level Pill)
	var header_h = HBoxContainer.new()
	header_h.add_theme_constant_override("separation", 8)
	main_v.add_child(header_h)
	
	title_label = Label.new()
	title_label.text = "YETENEK"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 14)
	title_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	header_h.add_child(title_label)
	
	var pill_panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color(0.0, 0.35, 0.40, 0.6)
	p_style.border_width_left = 1
	p_style.border_width_top = 1
	p_style.border_width_right = 1
	p_style.border_width_bottom = 1
	p_style.border_color = Color(0.0, 0.94, 1.0, 0.6)
	p_style.corner_radius_top_left = 4
	p_style.corner_radius_top_right = 4
	p_style.corner_radius_bottom_left = 4
	p_style.corner_radius_bottom_right = 4
	p_style.content_margin_left = 6
	p_style.content_margin_right = 6
	p_style.content_margin_top = 2
	p_style.content_margin_bottom = 2
	pill_panel.add_theme_stylebox_override("panel", p_style)
	header_h.add_child(pill_panel)
	
	var pill_h = HBoxContainer.new()
	pill_h.add_theme_constant_override("separation", 4)
	pill_panel.add_child(pill_h)
	
	slot_badge_label = Label.new()
	slot_badge_label.text = "Q"
	slot_badge_label.add_theme_font_size_override("font_size", 11)
	slot_badge_label.add_theme_color_override("font_color", Color(0.4, 0.95, 1.0))
	pill_h.add_child(slot_badge_label)
	
	var sep_v = Label.new()
	sep_v.text = "|"
	sep_v.add_theme_font_size_override("font_size", 10)
	sep_v.add_theme_color_override("font_color", Color(0.3, 0.6, 0.7))
	pill_h.add_child(sep_v)
	
	level_label = Label.new()
	level_label.text = "Sv 1"
	level_label.add_theme_font_size_override("font_size", 11)
	level_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.4))
	pill_h.add_child(level_label)
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.15, 0.25, 0.35, 0.5)
	main_v.add_child(sep1)
	
	# 2. Properties Grid
	var prop_grid = GridContainer.new()
	prop_grid.columns = 2
	prop_grid.add_theme_constant_override("h_separation", 14)
	prop_grid.add_theme_constant_override("v_separation", 3)
	main_v.add_child(prop_grid)
	
	target_type_val = _add_prop_row(prop_grid, "Hedef:", "Birim Hedefli")
	target_filter_val = _add_prop_row(prop_grid, "Etkilenen:", "Düşmanlar")
	damage_type_val = _add_prop_row(prop_grid, "Hasar:", "Fiziksel")
	bkb_pierce_val = _add_prop_row(prop_grid, "Delici Etki:", "Hayır")
	
	var sep2 = ColorRect.new()
	sep2.custom_minimum_size = Vector2(0, 1)
	sep2.color = Color(0.15, 0.25, 0.35, 0.5)
	main_v.add_child(sep2)
	
	# 3. Description
	desc_label = Label.new()
	desc_label.text = ""
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 10)
	desc_label.add_theme_color_override("font_color", Color(0.88, 0.90, 0.94))
	main_v.add_child(desc_label)
	
	# 4. Dynamic Stats Box
	stats_vbox = VBoxContainer.new()
	stats_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(stats_vbox)
	
	# 5. Advanced Mechanics Box
	mechanics_box = PanelContainer.new()
	var m_style = StyleBoxFlat.new()
	m_style.bg_color = Color(0.08, 0.11, 0.16, 0.95)
	m_style.border_width_left = 3
	m_style.border_color = Color(0.0, 0.94, 1.0, 0.8) # Electric Cyan
	m_style.content_margin_left = 10
	m_style.content_margin_right = 10
	m_style.content_margin_top = 6
	m_style.content_margin_bottom = 6
	m_style.corner_radius_top_right = 6
	m_style.corner_radius_bottom_right = 6
	mechanics_box.add_theme_stylebox_override("panel", m_style)
	main_v.add_child(mechanics_box)
	
	var m_vbox = VBoxContainer.new()
	m_vbox.add_theme_constant_override("separation", 3)
	mechanics_box.add_child(m_vbox)
	
	var m_hdr = Label.new()
	m_hdr.text = "MEKANİK DETAYLAR"
	m_hdr.add_theme_font_size_override("font_size", 10)
	m_hdr.add_theme_color_override("font_color", Color(0.0, 0.94, 1.0))
	m_vbox.add_child(m_hdr)
	
	mechanics_label = Label.new()
	mechanics_label.text = ""
	mechanics_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mechanics_label.add_theme_font_size_override("font_size", 10)
	mechanics_label.add_theme_color_override("font_color", Color(0.85, 0.92, 0.96))
	m_vbox.add_child(mechanics_label)
	
	var sep3 = ColorRect.new()
	sep3.custom_minimum_size = Vector2(0, 1)
	sep3.color = Color(0.15, 0.25, 0.35, 0.5)
	main_v.add_child(sep3)
	
	# 6. Footer (Cooldown & Mana)
	var footer_h = HBoxContainer.new()
	footer_h.add_theme_constant_override("separation", 14)
	main_v.add_child(footer_h)
	
	var cd_box = HBoxContainer.new()
	cd_box.add_theme_constant_override("separation", 4)
	footer_h.add_child(cd_box)
	
	var cd_lbl = Label.new()
	cd_lbl.text = "BS:"
	cd_lbl.add_theme_font_size_override("font_size", 11)
	cd_lbl.add_theme_color_override("font_color", Color(0.85, 0.70, 0.25))
	cd_box.add_child(cd_lbl)
	
	cooldown_val_label = Label.new()
	cooldown_val_label.text = "10.0s"
	cooldown_val_label.add_theme_font_size_override("font_size", 11)
	cooldown_val_label.add_theme_color_override("font_color", Color(1.0, 0.90, 0.40))
	cd_box.add_child(cooldown_val_label)
	
	var mana_box = HBoxContainer.new()
	mana_box.add_theme_constant_override("separation", 4)
	footer_h.add_child(mana_box)
	
	var m_tag = Label.new()
	m_tag.text = "Mana:"
	m_tag.add_theme_font_size_override("font_size", 11)
	m_tag.add_theme_color_override("font_color", Color(0.3, 0.75, 1.0))
	mana_box.add_child(m_tag)
	
	mana_val_label = Label.new()
	mana_val_label.text = "80"
	mana_val_label.add_theme_font_size_override("font_size", 11)
	mana_val_label.add_theme_color_override("font_color", Color(0.5, 0.90, 1.0))
	mana_box.add_child(mana_val_label)

func _add_prop_row(parent: Control, label_txt: String, val_txt: String) -> Label:
	var h = HBoxContainer.new()
	h.add_theme_constant_override("separation", 4)
	parent.add_child(h)
	
	var lbl = Label.new()
	lbl.text = label_txt
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.add_theme_color_override("font_color", Color(0.55, 0.62, 0.72))
	h.add_child(lbl)
	
	var val = Label.new()
	val.text = val_txt
	val.add_theme_font_size_override("font_size", 10)
	val.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
	h.add_child(val)
	return val

func show_ability(ab: AbilityResource, cur_level: int, slot_key: String) -> void:
	if ab == null:
		hide_tooltip()
		return
		
	visible = true
	title_label.text = ab.ability_name.to_upper()
	slot_badge_label.text = "[ %s ]" % slot_key
	
	if ab.is_passive or ab.target_type == AbilityResource.TargetType.PASSIVE:
		level_label.text = "PASİF"
	else:
		level_label.text = "SVY %d/%d" % [cur_level, ab.max_level]
		
	# Target Type
	match ab.target_type:
		AbilityResource.TargetType.SINGLE_TARGET:
			target_type_val.text = "Birim Hedefli"
		AbilityResource.TargetType.GROUND_AOE:
			target_type_val.text = "Zemin Alanı"
		AbilityResource.TargetType.DIRECTIONAL:
			target_type_val.text = "Yöne Doğru (Hat Delme)"
		AbilityResource.TargetType.SELF:
			target_type_val.text = "Kendine (Self)"
		_:
			target_type_val.text = "Pasif"
			
	# Target Filter
	match ab.target_filter:
		AbilityResource.TargetFilter.ENEMIES_ONLY:
			target_filter_val.text = "Düşmanlar & Orman"
			target_filter_val.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		AbilityResource.TargetFilter.ALLIES_ONLY, AbilityResource.TargetFilter.ALLIES_NOT_SELF:
			target_filter_val.text = "Dost Birimler"
			target_filter_val.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
		AbilityResource.TargetFilter.SELF_ONLY:
			target_filter_val.text = "Yalnızca Kendisi"
			target_filter_val.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
		AbilityResource.TargetFilter.NEUTRALS_ONLY:
			target_filter_val.text = "Orman Kampları"
			target_filter_val.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
		_:
			target_filter_val.text = "Tüm Birimler"
			target_filter_val.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
			
	# Damage Type
	match ab.damage_type:
		DamageRequest.DamageType.MAGICAL:
			damage_type_val.text = "Büyüsel Hasar"
			damage_type_val.add_theme_color_override("font_color", Color(0.35, 0.75, 1.0))
		DamageRequest.DamageType.PHYSICAL:
			damage_type_val.text = "Fiziksel Hasar"
			damage_type_val.add_theme_color_override("font_color", Color(1.0, 0.45, 0.3))
		DamageRequest.DamageType.TRUE_DAMAGE:
			damage_type_val.text = "Saf Hasar (True Damage)"
			damage_type_val.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
		_:
			damage_type_val.text = "Hasarsız / Güçlendirme"
			damage_type_val.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
			
	bkb_pierce_val.text = "Delmez"
	desc_label.text = ab.description if ab.description != "" else "Yetenek açıklaması girilmemiş."
	
	# Clear stats
	for c in stats_vbox.get_children():
		c.queue_free()
		
	# Damage line
	if ab.base_damage.size() > 0 and ab.base_damage[0] > 0.0:
		var dmg_str = _format_scaling_array(ab.base_damage, cur_level)
		var ratio_str = " (+%%%d %s)" % [int(ab.scaling_ratio * 100), "YG" if ab.scaling_stat == StatModifier.TargetStat.ABILITY_POWER else "SG"]
		_add_stat_line(stats_vbox, "Temel Hasar:", dmg_str + ratio_str, Color(1.0, 0.88, 0.3))
		
	if ab.cast_range > 0.0:
		_add_stat_line(stats_vbox, "Menzil:", "%.0fm" % (ab.cast_range / 100.0), Color(0.75, 0.85, 0.95))
		
	if ab.applies_status_effect and ab.effect_duration > 0.0:
		var eff_name = "Yavaşlatma" if ab.effect_type == StatusEffect.EffectType.SLOW else "Sabitleme (Root)"
		_add_stat_line(stats_vbox, eff_name + ":", "%.1f sn" % ab.effect_duration, Color(0.4, 0.9, 1.0))
		
	# Footer Cooldown & Mana
	if ab.cooldowns.size() > 0:
		cooldown_val_label.text = _format_scaling_array(ab.cooldowns, cur_level) + "s"
	else:
		cooldown_val_label.text = "0.0s"
		
	if ab.mana_costs.size() > 0:
		mana_val_label.text = _format_scaling_array(ab.mana_costs, cur_level)
	else:
		mana_val_label.text = "0"
		
	# Set Mechanics Notes
	_set_mechanics_notes(ab)

func _set_mechanics_notes(ab: AbilityResource) -> void:
	if mechanics_label == null:
		return
	var id = ab.id.to_lower()
	var notes = ""
	
	if id.contains("solen_q") or id.contains("piercing"):
		notes = "• Delip geçtiği düşman ve minyon sayısından bağımsız olarak hat boyunca her hedefe %100 tam hasar verir.\n• Çalılık ve karanlıktaki gizli birimleri açığa çıkarır.\n• Mesafe arttıkça hasar düşmez."
	elif id.contains("solen_w") or id.contains("blinding"):
		notes = "• Kör olan düşmanların temel saldırıları 2.0 saniye boyunca %100 ıskalar (Miss).\n• Düşmanları 3.5 metre geriye fırlatır ve kanalize büyülerini keser (Displace).\n• Büyü bağışıklığı olan hedeflere işlemez."
	elif id.contains("solen_e") or id.contains("vault"):
		notes = "• Takla sırasında birim çarpışmalarını (Unit Collision) yok sayar.\n• Verilen +%85'e varan saldırı hızı güçlendirmesi 4.0 saniye sürer.\n• Geriye takla atarken farenin baktığı yönü korur."
	elif id.contains("solen_r") or id.contains("supernova_barrage"):
		notes = "• 6.0 metre çapındaki alana 2.5 saniye boyunca güneş okları yağdırır.\n• Alandaki düşmanları %40 yavaşlatır.\n• Savaş sisi (Fog of War) bölgelerini ve çalıları aydınlatır."
	elif id.contains("solen_passive") or id.contains("solar_charge"):
		notes = "• Her normal saldırı 1 yük verir (maks 5).\n• 5. vuruşta yükler patlar ve hedefe ilave saf hasar ile %40 zırh delme uygular.\n• Yükler 6.0 saniye vuruş yapılmazsa söner. Binalara patlama uygulanmaz."
	elif id.contains("astris_q") or id.contains("arcane"):
		notes = "• Hedefi takip eden homing büyü füzesidir.\n• Aşırı Yük etkinken %120 YG hasarı vurur ve 20 mana yeniler."
	elif id.contains("astris_w") or id.contains("bind"):
		notes = "• Hedefi 2.0 saniye sabitler (Root). Sabitlenen birimler hareket edemez ve kaçış yeteneklerini kullanamaz."
	elif id.contains("astris_e") or id.contains("step"):
		notes = "• Kısa menzilli anlık ışınlanma (Blink) gerçekleştirir. Gelen mermileri bozar."
	elif id.contains("astris_r") or id.contains("supernova"):
		notes = "• 3.0 saniye sonra devasa patlama gerçekleştirir. Patlama öncesi hedefleri içine çeker."
	elif id.contains("mordren_r") or id.contains("final_hunt"):
		notes = "• Yalnızca Av Damgası bulunan ve canı %35 veya altındaki kahramanlara kullanılabilir.\n• Fiziksel darbenin ardından hedefin eksik canının %20/%25/%30'u kadar saf infaz hasarı verir.\n• Eşik sağlanmıyorsa mana ve bekleme süresi harcanmaz."
	elif id.contains("nyxara_e") or id.contains("sever_thread"):
		notes = "• Tüm Gölge Damgalarını tüketir; her damga fiziksel patlama hasarı ekler.\n• Ardından eksik canın %15/%18/%21/%24'ü kadar zırhı yok sayan saf imha hasarı uygular."
	else:
		notes = "• Yetenek seviyesi arttıkça bekleme süresi ve mana bedeli ölçeklenir.\n• Zırh delme ve büyü direnci statlarından tam olarak faydalanır."
		
	mechanics_label.text = notes

func show_talent_tree_tooltip() -> void:
	visible = true
	title_label.text = "YETENEK AĞACI (TALENT TREE)"
	slot_badge_label.text = "[ 🌳 ]"
	level_label.text = "SVY 10/15/20/25"
	target_type_val.text = "Pasif Güçlendirme"
	target_filter_val.text = "Kahraman"
	damage_type_val.text = "Özel"
	bkb_pierce_val.text = "Evet"
	desc_label.text = "10, 15, 20 ve 25. seviyelere ulaşıldığında kahramana özel kalıcı yetenek dalları ve stat bonusları açılır."
	for c in stats_vbox.get_children(): c.queue_free()
	_add_stat_line(stats_vbox, "🌳 10. Seviye:", "+150 Can VEYA +20 Saldırı Hızı", Color(0.4, 1.0, 0.6))
	_add_stat_line(stats_vbox, "🌳 15. Seviye:", "+%15 Büyü Nüfuzu VEYA +30 Hareket Hızı", Color(0.4, 1.0, 0.6))
	_add_stat_line(stats_vbox, "🌳 20. Seviye:", "+200 Yetenek Hasarı VEYA +8 Zırh", Color(0.4, 1.0, 0.6))
	_add_stat_line(stats_vbox, "🌳 25. Seviye:", "-3s Q Bekleme Süresi VEYA +%25 Büyü Direnci", Color(1.0, 0.88, 0.3))
	if mechanics_box != null: mechanics_box.visible = false
	cooldown_val_label.text = "⏳ Pasif"
	mana_val_label.text = "💧 0"

func hide_tooltip() -> void:
	visible = false
	if mechanics_box != null: mechanics_box.visible = true

func _add_stat_line(parent: Control, lbl_txt: String, val_txt: String, col: Color) -> void:
	var h = HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	parent.add_child(h)
	
	var l = Label.new()
	l.text = lbl_txt
	l.add_theme_font_size_override("font_size", 10)
	l.add_theme_color_override("font_color", Color(0.65, 0.72, 0.8))
	h.add_child(l)
	
	var v = Label.new()
	v.text = val_txt
	v.add_theme_font_size_override("font_size", 10)
	v.add_theme_color_override("font_color", col)
	h.add_child(v)

func _format_scaling_array(arr: Array[float], cur_lvl: int) -> String:
	if arr.is_empty():
		return "0"
	var parts: Array[String] = []
	for i in range(arr.size()):
		var val_str = str(int(arr[i])) if arr[i] == float(int(arr[i])) else "%.1f" % arr[i]
		if (i + 1) == cur_lvl:
			parts.append("[%s]" % val_str)
		else:
			parts.append(val_str)
	return " / ".join(parts)
