extends Resource

class_name ProjectileWeaponStatList

@export var damageType : int #0=ballistic, 1=laser, 2=plasma
@export var damage : float #value of health lost. cannot go below 1
@export var projectileRange : float #number of tiles. cannot go below 1
@export var fireRate : float #time between shots / warm up time for shot
@export var speed : float #pixels per second
@export var size : float #percentage set to 1 by default
@export var penetration : float #number of possible enemies hit. cannot go below 1
@export var projectilesPerShot : int #cannot go below 1
@export var effectsOnHit : Array
