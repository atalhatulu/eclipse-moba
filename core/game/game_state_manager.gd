class_name GameStateManager
extends Node

## Manages high-level MOBA match states, transitions, match clocks, and day/night cycles

signal state_changed(previous_state: State, new_state: State)
signal match_clock_ticked(seconds_elapsed: float)
signal day_night_cycle_changed(is_day: bool)

enum State {
	PRE_GAME,
	HERO_SELECTION,
	LOADING,
	PLAYING,
	PAUSED,
	VICTORY,
	DEFEAT
}

@export var current_state: State = State.PRE_GAME
@export var day_night_phase_duration: float = 300.0 # 5 minutes per cycle

var match_time: float = 0.0
var is_daytime: bool = true

func _process(delta: float) -> void:
	if current_state != State.PLAYING:
		return
		
	match_time += delta
	match_clock_ticked.emit(match_time)
	
	# Day/Night evaluation
	var cycle_phase = int(match_time / day_night_phase_duration) % 2
	var expected_day = (cycle_phase == 0)
	if expected_day != is_daytime:
		is_daytime = expected_day
		day_night_cycle_changed.emit(is_daytime)

func transition_to(new_state: State) -> void:
	if current_state == new_state:
		return
		
	var prev = current_state
	current_state = new_state
	state_changed.emit(prev, new_state)

func start_match() -> void:
	match_time = 0.0
	is_daytime = true
	transition_to(State.PLAYING)

func pause_match() -> void:
	if current_state == State.PLAYING:
		transition_to(State.PAUSED)

func resume_match() -> void:
	if current_state == State.PAUSED:
		transition_to(State.PLAYING)

func declare_winner(winning_team: TeamDefinitions.Team, local_player_team: TeamDefinitions.Team) -> void:
	if winning_team == local_player_team:
		transition_to(State.VICTORY)
	else:
		transition_to(State.DEFEAT)
