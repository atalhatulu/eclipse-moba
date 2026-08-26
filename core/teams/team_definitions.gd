class_name TeamDefinitions
extends RefCounted

## Team and target affiliation definitions for Eclipse Front

enum Team {
	RADIANT = 0,
	DIRE = 1,
	NEUTRAL = 2
}

enum Relationship {
	ALLY,
	ENEMY,
	NEUTRAL,
	SELF
}

static func get_relationship(source_team: Team, target_team: Team, is_same_entity: bool = false) -> Relationship:
	if is_same_entity:
		return Relationship.SELF
	if source_team == Team.NEUTRAL or target_team == Team.NEUTRAL:
		return Relationship.NEUTRAL
	if source_team == target_team:
		return Relationship.ALLY
	return Relationship.ENEMY
