class_name SecretShopArea
extends Area3D

## Area trigger for the Secret Shop enabling heroes to purchase advanced crafting components

@export var shop_name: String = "Secret Shop"

signal hero_entered_shop(hero: HeroEntity)
signal hero_exited_shop(hero: HeroEntity)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body is HeroEntity:
		hero_entered_shop.emit(body as HeroEntity)

func _on_body_exited(body: Node3D) -> void:
	if body is HeroEntity:
		hero_exited_shop.emit(body as HeroEntity)
