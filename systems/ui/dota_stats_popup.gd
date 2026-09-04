class_name DotaStatsPopup
extends PanelContainer

## Authentic Dota 2 Detailed Stats, Attributes & Abilities Card (stats.png reference)
## Triggered dynamically via ALT key hold or hovering over portrait/stats block

var target_hero: HeroEntity = null

# Attack Column Labels
var lbl_atk_speed: Label = null
var lbl_damage: Label = null
var lbl_range: Label = null
var lbl_move_speed: Label = null
var lbl_spell_amp: Label = null
var lbl_mana_regen: Label = null

# Defense Column Labels
var lbl_armor: Label = null
var lbl_phys_resist: Label = null
var lbl_magic_resist: Label = null
var lbl_status_resist: Label = null
var lbl_slow_resist: Label = null
var lbl_evasion: Label = null
var lbl_hp_regen: Label = null

# Primary Attributes Blocks
var str_panel: PanelContainer = null
var str_title_lbl: Label = null
var str_sub_lbl: Label = null

var agi_panel: PanelContainer = null
var agi_title_lbl: Label = null
var agi_sub_lbl: Label = null

var int_panel: PanelContainer = null
var int_title_lbl: Label = null
var int_sub_lbl: Label = null

# Abilities Overview Section (ALT Skill Details)
var abilities_vbox: VBoxContainer = null

func _init() -> void:
	custom_minimum_size = Vector2(320, 0)
	mouse_filter = MOUSE_FILTER_IGNORE
	_build_ui()

func _build_ui() -> void:
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.06, 0.08, 0.11, 0.98)
	bg_style.border_width_left = 1
	bg_style.border_width_top = 1
	bg_style.border_width_right = 1
	bg_style.border_width_bottom = 1
	bg_style.border_color = Color(0.30, 0.45, 0.60, 1.0)
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	bg_style.shadow_size = 6
	bg_style.shadow_color = Color(0, 0, 0, 0.7)
	bg_style.content_margin_left = 8
	bg_style.content_margin_right = 8
	bg_style.content_margin_top = 6
	bg_style.content_margin_bottom = 6
	add_theme_stylebox_override("panel", bg_style)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 4)
	add_child(main_vbox)
	
	# Header
	var title_lbl = Label.new()
	title_lbl.text = "📊 KAHRAMAN DETAYLI NİTELİKLERİ"
	title_lbl.add_theme_font_size_override("font_size", 10)
	title_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	main_vbox.add_child(title_lbl)
	
	# =========================================================================
	# TOP HALF: SALDIRI vs SAVUNMA 2-COLUMN TABLE (stats.png reference)
	# =========================================================================
	var top_table = HBoxContainer.new()
	top_table.add_theme_constant_override("separation", 10)
	main_vbox.add_child(top_table)
	
	# Left: SALDIRI
	var atk_vbox = VBoxContainer.new()
	atk_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	atk_vbox.add_theme_constant_override("separation", 2)
	top_table.add_child(atk_vbox)
	
	var atk_hdr = Label.new()
	atk_hdr.text = "SALDIRI"
	atk_hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	atk_hdr.add_theme_font_size_override("font_size", 9)
	atk_hdr.add_theme_color_override("font_color", Color(0.80, 0.75, 0.65))
	atk_vbox.add_child(atk_hdr)
	
	var atk_grid = GridContainer.new()
	atk_grid.columns = 2
	atk_grid.add_theme_constant_override("h_separation", 4)
	atk_grid.add_theme_constant_override("v_separation", 1)
	atk_vbox.add_child(atk_grid)
	
	lbl_atk_speed = _create_stat_row(atk_grid, "Saldırı Hızı:")
	lbl_damage = _create_stat_row(atk_grid, "Hasar:")
	lbl_range = _create_stat_row(atk_grid, "Menzil:")
	lbl_move_speed = _create_stat_row(atk_grid, "Hız:")
	lbl_spell_amp = _create_stat_row(atk_grid, "Büyü Gücü:")
	lbl_mana_regen = _create_stat_row(atk_grid, "Mana Yen.:")
	
	# Right: SAVUNMA
	var def_vbox = VBoxContainer.new()
	def_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	def_vbox.add_theme_constant_override("separation", 2)
	top_table.add_child(def_vbox)
	
	var def_hdr = Label.new()
	def_hdr.text = "SAVUNMA"
	def_hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	def_hdr.add_theme_font_size_override("font_size", 9)
	def_hdr.add_theme_color_override("font_color", Color(0.80, 0.75, 0.65))
	def_vbox.add_child(def_hdr)
	
	var def_grid = GridContainer.new()
	def_grid.columns = 2
	def_grid.add_theme_constant_override("h_separation", 4)
	def_grid.add_theme_constant_override("v_separation", 1)
	def_vbox.add_child(def_grid)
	
	lbl_armor = _create_stat_row(def_grid, "Zırh:")
	lbl_phys_resist = _create_stat_row(def_grid, "Fizik Direnç:")
	lbl_magic_resist = _create_stat_row(def_grid, "Büyü Direnç:")
	lbl_status_resist = _create_stat_row(def_grid, "Sıvışma:")
	lbl_slow_resist = _create_stat_row(def_grid, "Yavaş. Dir.:")
	lbl_evasion = _create_stat_row(def_grid, "Savuşturma:")
	lbl_hp_regen = _create_stat_row(def_grid, "Can Yen.:")
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.25, 0.35, 0.45, 0.5)
	main_vbox.add_child(sep1)
	
	# =========================================================================
	# MIDDLE: 3 PRIMARY ATTRIBUTES (STR, AGI, INT)
	# =========================================================================
	var attr_vbox = VBoxContainer.new()
	attr_vbox.add_theme_constant_override("separation", 2)
	main_vbox.add_child(attr_vbox)
	
	# 1. STR Block
	str_panel = _create_attribute_card(attr_vbox, Color(0.95, 0.3, 0.25))
	str_title_lbl = str_panel.get_node("VBox/Title")
	str_sub_lbl = str_panel.get_node("VBox/Sub")
	
	# 2. AGI Block
	agi_panel = _create_attribute_card(attr_vbox, Color(0.25, 0.88, 0.35))
	agi_title_lbl = agi_panel.get_node("VBox/Title")
	agi_sub_lbl = agi_panel.get_node("VBox/Sub")
	
	# 3. INT Block
	int_panel = _create_attribute_card(attr_vbox, Color(0.3, 0.65, 1.0))
	int_title_lbl = int_panel.get_node("VBox/Title")
	int_sub_lbl = int_panel.get_node("VBox/Sub")
	
	var sep2 = ColorRect.new()
	sep2.custom_minimum_size = Vector2(0, 1)
	sep2.color = Color(0.25, 0.35, 0.45, 0.5)
	main_vbox.add_child(sep2)
	
	# =========================================================================
	# BOTTOM: YETENEKLER VE PASİF DETAYLARI (ALT BİLGİ MODU)
	# =========================================================================
	var ab_hdr = Label.new()
	ab_hdr.text = "⚡ YETENEKLER & PASİF"
	ab_hdr.add_theme_font_size_override("font_size", 9)
	ab_hdr.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	main_vbox.add_child(ab_hdr)
	
	abilities_vbox = VBoxContainer.new()
	abilities_vbox.add_theme_constant_override("separation", 2)
	main_vbox.add_child(abilities_vbox)

func _create_stat_row(parent: Control, label_text: String) -> Label:
	var l_name = Label.new()
	l_name.text = label_text
	l_name.add_theme_font_size_override("font_size", 9)
	l_name.add_theme_color_override("font_color", Color(0.65, 0.70, 0.75))
	parent.add_child(l_name)
	
	var l_val = Label.new()
	l_val.text = "-"
	l_val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l_val.add_theme_font_size_override("font_size", 9)
	l_val.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))
	parent.add_child(l_val)
	return l_val

func _create_attribute_card(parent: Control, _theme_col: Color) -> PanelContainer:
	var p = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.14, 0.9)
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	p.add_theme_stylebox_override("panel", style)
	parent.add_child(p)
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.add_theme_constant_override("separation", 1)
	p.add_child(vbox)
	
	var t_lbl = Label.new()
	t_lbl.name = "Title"
	t_lbl.add_theme_font_size_override("font_size", 10)
	vbox.add_child(t_lbl)
	
	var s_lbl = Label.new()
	s_lbl.name = "Sub"
	s_lbl.add_theme_font_size_override("font_size", 8)
	s_lbl.add_theme_color_override("font_color", Color(0.60, 0.70, 0.65))
	vbox.add_child(s_lbl)
	
	return p

func update_stats(hero: HeroEntity) -> void:
	if hero == null or not is_instance_valid(hero) or hero.attribute_system == null:
		return
	target_hero = hero
	var stats = hero.attribute_system
	
	# Attack Stats
	var as_val = stats.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	var as_time = 1.0 / maxf(0.1, as_val)
	lbl_atk_speed.text = "%d (%.2fs)" % [int(as_val * 100), as_time]
	
	var base_ad = stats.base_attack_damage
	var total_ad = stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var bonus_ad = total_ad - base_ad
	lbl_damage.text = "%d + %d" % [int(base_ad), int(bonus_ad)]
	
	var range_val = stats.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	lbl_range.text = "%d" % int(range_val)
	
	var ms_val = stats.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	lbl_move_speed.text = "%d" % int(ms_val)
	
	var amp_val = stats.get_stat(StatModifier.TargetStat.DAMAGE_AMPLIFICATION)
	lbl_spell_amp.text = "%.1f%%" % (amp_val * 100.0)
	
	var base_mp_reg = stats.base_mana_regen
	var total_mp_reg = stats.get_stat(StatModifier.TargetStat.MANA_REGEN)
	var bonus_mp_reg = maxf(0.0, total_mp_reg - base_mp_reg)
	lbl_mana_regen.text = "%.2f + %.2f" % [base_mp_reg, bonus_mp_reg]
	
	# Defense Stats
	var base_arm = stats.base_armor
	var total_arm = stats.get_stat(StatModifier.TargetStat.ARMOR)
	var bonus_arm = maxf(0.0, total_arm - base_arm)
	lbl_armor.text = "%.1f + %.1f" % [base_arm, bonus_arm]
	
	var phys_res = (0.06 * total_arm) / (1.0 + 0.06 * absf(total_arm))
	lbl_phys_resist.text = "%d%%" % int(phys_res * 100.0)
	
	var mr_val = stats.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
	lbl_magic_resist.text = "%d%%" % int(mr_val)
	
	var ten_val = stats.get_stat(StatModifier.TargetStat.TENACITY)
	lbl_status_resist.text = "%.1f%%" % (ten_val * 100.0)
	lbl_slow_resist.text = "0.0%"
	
	var is_pa = (hero.entity_name.to_lower().contains("assassin") or hero is AstrisHero)
	lbl_evasion.text = "75%" if is_pa else "0%"
	
	var base_hp_reg = stats.base_health_regen
	var total_hp_reg = stats.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	var bonus_hp_reg = maxf(0.0, total_hp_reg - base_hp_reg)
	lbl_hp_regen.text = "%.2f + %.2f" % [base_hp_reg, bonus_hp_reg]
	
	# Primary Attributes
	var cur_str = stats.get_stat(StatModifier.TargetStat.STRENGTH)
	var str_growth = stats.strength_growth
	str_title_lbl.text = "🔴 STR: %d (Seviye başına +%.1f)" % [int(cur_str), str_growth]
	str_sub_lbl.text = "= %d Can ve +%.1f Can Yenilenmesi" % [int(cur_str * 22.0), cur_str * 0.1]
	
	var cur_agi = stats.get_stat(StatModifier.TargetStat.AGILITY)
	var agi_growth = stats.agility_growth
	var is_agi_primary = (stats.primary_attribute == AttributeSystem.PrimaryAttributeType.AGILITY)
	agi_title_lbl.text = "🟢 AGI: %d (Seviye başına +%.1f)" % [int(cur_agi), agi_growth]
	agi_sub_lbl.text = "= %d Hasar (Birincil Rol) | +%.1f Zırh | +%d Saldırı Hızı" % [int(cur_agi), cur_agi * 0.16, int(cur_agi)] if is_agi_primary else "= +%.1f Zırh | +%d Saldırı Hızı" % [cur_agi * 0.16, int(cur_agi)]
	
	var cur_int = stats.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var int_growth = stats.intelligence_growth
	var is_int_primary = (stats.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE)
	int_title_lbl.text = "🔵 INT: %d (Seviye başına +%.1f)" % [int(cur_int), int_growth]
	int_sub_lbl.text = "= %d Hasar (Birincil Rol) | %d Mana | +%.1f Mana Yenilenmesi | %%%.1f Büyü Direnci" % [int(cur_int), int(cur_int * 12.0), cur_int * 0.05, cur_int * 0.1] if is_int_primary else "= %d Mana | +%.1f Mana Yenilenmesi | %%%.1f Büyü Direnci" % [int(cur_int * 12.0), cur_int * 0.05, cur_int * 0.1]
	
	# Highlight primary attribute box
	_set_panel_highlight(str_panel, stats.primary_attribute == AttributeSystem.PrimaryAttributeType.STRENGTH)
	_set_panel_highlight(agi_panel, stats.primary_attribute == AttributeSystem.PrimaryAttributeType.AGILITY)
	_set_panel_highlight(int_panel, stats.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE)
	
	# Update Abilities & Passives Overview
	_update_abilities_overview(hero)

func _update_abilities_overview(hero: HeroEntity) -> void:
	if abilities_vbox == null:
		return
		
	for c in abilities_vbox.get_children():
		c.queue_free()
		
	var ab_cont = hero.ability_container
	if ab_cont == null:
		return
		
	var slots = [
		{"slot": AbilityResource.Slot.PASSIVE, "key": "💧 PASİF", "col": Color(0.35, 0.85, 1.0)},
		{"slot": AbilityResource.Slot.Q, "key": "🏹 [ Q ]", "col": Color(1.0, 0.85, 0.3)},
		{"slot": AbilityResource.Slot.W, "key": "💥 [ W ]", "col": Color(1.0, 0.45, 0.35)},
		{"slot": AbilityResource.Slot.E, "key": "🤸 [ E ]", "col": Color(0.4, 0.95, 0.5)},
		{"slot": AbilityResource.Slot.R, "key": "☀️ [ R ]", "col": Color(1.0, 0.3, 0.65)}
	]
	
	for s_info in slots:
		var ab: AbilityResource = ab_cont.abilities.get(s_info.slot)
		if ab != null:
			var lvl = ab_cont.ability_levels.get(s_info.slot, 1)
			
			var row = HBoxContainer.new()
			row.add_theme_constant_override("separation", 6)
			abilities_vbox.add_child(row)
			
			var k_lbl = Label.new()
			k_lbl.text = s_info.key
			k_lbl.custom_minimum_size = Vector2(58, 0)
			k_lbl.add_theme_font_size_override("font_size", 9)
			k_lbl.add_theme_color_override("font_color", s_info.col)
			row.add_child(k_lbl)
			
			var name_lbl = Label.new()
			name_lbl.text = "%s (Svy %d): %s" % [ab.ability_name, lvl, ab.description]
			name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			name_lbl.size_flags_horizontal = SIZE_EXPAND_FILL
			name_lbl.add_theme_font_size_override("font_size", 8)
			name_lbl.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
			row.add_child(name_lbl)

func _set_panel_highlight(panel: PanelContainer, is_primary: bool) -> void:
	var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
	if style != null:
		if is_primary:
			style.bg_color = Color(0.10, 0.22, 0.14, 0.95)
			style.border_width_left = 1
			style.border_width_top = 1
			style.border_width_right = 1
			style.border_width_bottom = 1
			style.border_color = Color(0.3, 0.8, 0.4)
		else:
			style.bg_color = Color(0.08, 0.10, 0.14, 0.9)
			style.border_width_left = 0
			style.border_width_top = 0
			style.border_width_right = 0
