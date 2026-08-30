class_name SoundManager
extends Node

## Central Audio and MOBA Announcer Manager for Eclipse Front
## Manages spatial 3D audio, combat SFX, multi-kills, killstreaks, and announcer events.

signal announcer_triggered(announcement_type: String, message: String)
signal sfx_played(sfx_name: String, is_3d: bool, position: Vector3)

# Announcer state tracking
var first_blood_occurred: bool = false
var hero_kill_streaks: Dictionary = {} # Node/Hero -> int
var hero_multi_kills: Dictionary = {}  # Node/Hero -> { "count": int, "timer": float }
const MULTI_KILL_WINDOW: float = 12.0

# Volume bus levels (0.0 to 1.0)
var bus_volumes: Dictionary = {
	"Master": 1.0,
	"SFX": 1.0,
	"Music": 0.8,
	"Announcer": 1.0
}

# Audio pool for 2D and 3D playback
var _audio_players_2d: Array[AudioStreamPlayer] = []
var _audio_players_3d: Array[AudioStreamPlayer3D] = []
const POOL_SIZE = 8

func _ready() -> void:
	_init_audio_pools()
	_connect_game_events()

func _init_audio_pools() -> void:
	for i in range(POOL_SIZE):
		var p2d = AudioStreamPlayer.new()
		p2d.name = "SFXPlayer2D_%d" % i
		add_child(p2d)
		_audio_players_2d.append(p2d)
		
		var p3d = AudioStreamPlayer3D.new()
		p3d.name = "SFXPlayer3D_%d" % i
		p3d.max_distance = 45.0
		p3d.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		add_child(p3d)
		_audio_players_3d.append(p3d)

func _connect_game_events() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.entity_killed.is_connected(_on_entity_killed):
			GameEvents.entity_killed.connect(_on_entity_killed)
		if not GameEvents.hero_died.is_connected(_on_hero_died):
			GameEvents.hero_died.connect(_on_hero_died)

func _process(delta: float) -> void:
	# Tick multi-kill decay timers
	var expired_heroes: Array = []
	for hero in hero_multi_kills.keys():
		var data = hero_multi_kills[hero]
		data["timer"] -= delta
		if data["timer"] <= 0.0:
			expired_heroes.append(hero)
			
	for hero in expired_heroes:
		hero_multi_kills.erase(hero)

func reset_state() -> void:
	first_blood_occurred = false
	hero_kill_streaks.clear()
	hero_multi_kills.clear()

# ==============================================================================
# 1. ANNOUNCER & KILL TRACKING
# ==============================================================================
func _on_entity_killed(victim: Node, killer: Node) -> void:
	if victim == null:
		return
		
	# Check if victim is Epic Boss
	if victim.name.contains("Leviathan") or victim.name.contains("Boss") or (victim is BaseCombatEntity and (victim as BaseCombatEntity).entity_name.contains("Leviathan")):
		var killer_name = (killer as BaseCombatEntity).entity_name if killer is BaseCombatEntity else "Bilinmeyen"
		trigger_announcement("LEVIATHAN_SLAIN", "%s LEVIATHAN'I KATLETTİ!" % killer_name)
		return

func _on_hero_died(victim: Node, killer: Node, _respawn_time: float) -> void:
	if killer == null or victim == null:
		return
		
	var killer_hero = killer as BaseCombatEntity
	var victim_hero = victim as BaseCombatEntity
	var k_name = killer_hero.entity_name if killer_hero != null else "Bilinmeyen"
	var v_name = victim_hero.entity_name if victim_hero != null else "Bilinmeyen"
	
	# 1. First Blood Check
	if not first_blood_occurred and killer_hero != null and killer_hero != victim_hero:
		first_blood_occurred = true
		trigger_announcement("FIRST_BLOOD", "İLK KAN! %s, %s kahramanını katletti!" % [k_name, v_name])
	
	# 2. Multi-Kill Tracker
	if killer_hero != null and killer_hero != victim_hero:
		var current_mk = hero_multi_kills.get(killer, { "count": 0, "timer": MULTI_KILL_WINDOW })
		current_mk["count"] += 1
		current_mk["timer"] = MULTI_KILL_WINDOW
		hero_multi_kills[killer] = current_mk
		
		match current_mk["count"]:
			2:
				trigger_announcement("DOUBLE_KILL", "İKİDE İKİ! (%s)" % k_name)
			3:
				trigger_announcement("TRIPLE_KILL", "ÜÇTE ÜÇ! (%s)" % k_name)
			4:
				trigger_announcement("ULTRA_KILL", "DÖRTTE DÖRT! (%s)" % k_name)
			5:
				trigger_announcement("RAMPAGE", "BEŞTE BEŞ (RAMPAGE)! %s DÜŞMAN TAKIMI YOK ETTİ!" % k_name)
				
		# 3. Killstreak Tracker
		var current_streak = hero_kill_streaks.get(killer, 0) + 1
		hero_kill_streaks[killer] = current_streak
		
		match current_streak:
			3:
				trigger_announcement("KILLING_SPREE", "%s KATLİAM YAPIYOR (3 Seri)!" % k_name)
			4:
				trigger_announcement("DOMINATING", "%s DOMİNE EDİYOR (4 Seri)!" % k_name)
			5:
				trigger_announcement("MEGA_KILL", "%s MEGA KILL (5 Seri)!" % k_name)
			6:
				trigger_announcement("UNSTOPPABLE", "%s DURDURULAMAZ (6 Seri)!" % k_name)
			7:
				trigger_announcement("WICKED_SICK", "%s DEHŞET SAÇIYOR (7 Seri)!" % k_name)
			8:
				trigger_announcement("MONSTER_KILL", "%s CANAVARLAŞTI (8 Seri)!" % k_name)
			9:
				trigger_announcement("GODLIKE", "%s EFSANEVİ / GODLIKE (9 Seri)!" % k_name)
			10:
				trigger_announcement("BEYOND_GODLIKE", "%s TANRISAL DÜZEYDE (10+ Seri)!" % k_name)
				
	# 4. Shutdown check
	var victim_streak = hero_kill_streaks.get(victim, 0)
	if victim_streak >= 3 and killer_hero != null and killer_hero != victim_hero:
		trigger_announcement("SHUTDOWN", "%s, %s kahramanının %d serilik katliamını sonlandırdı!" % [k_name, v_name, victim_streak])
		
	# Reset victim's streak
	hero_kill_streaks[victim] = 0

func trigger_announcement(announcement_type: String, message: String) -> void:
	announcer_triggered.emit(announcement_type, message)
	play_sfx("announcer_" + announcement_type.to_lower())

# ==============================================================================
# 2. SFX & AUDIO PLAYBACK
# ==============================================================================
func play_sfx(sfx_name: String, position: Vector3 = Vector3.ZERO) -> void:
	if position != Vector3.ZERO:
		play_3d_sfx(sfx_name, position)
	else:
		play_2d_sfx(sfx_name)

func play_2d_sfx(sfx_name: String) -> void:
	sfx_played.emit(sfx_name, false, Vector3.ZERO)
	for p in _audio_players_2d:
		if not p.playing:
			p.volume_db = linear_to_db(bus_volumes.get("SFX", 1.0))
			return

func play_3d_sfx(sfx_name: String, global_pos: Vector3) -> void:
	sfx_played.emit(sfx_name, true, global_pos)
	for p in _audio_players_3d:
		if not p.playing:
			p.global_position = global_pos
			p.volume_db = linear_to_db(bus_volumes.get("SFX", 1.0))
			return

# ==============================================================================
# 3. BUS CONTROLS
# ==============================================================================
func set_bus_volume(bus_name: String, volume_linear: float) -> void:
	bus_volumes[bus_name] = clampf(volume_linear, 0.0, 1.0)

func get_bus_volume(bus_name: String) -> float:
	return bus_volumes.get(bus_name, 1.0)
