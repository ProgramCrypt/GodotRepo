extends Resource

class_name ProjectileWeaponStatList

@export var weaponType = "projectile"
@export var damageType : int #0=ballistic, 1=laser, 2=plasma
@export var damage : float #value of health lost. cannot go below 1
@export var energyUse : float #value of energy used per shot or per second for lasers
@export var projectileRange : float #number of pixels before damage dropoff starts. cannot go below 100
@export var fireRate : float #time between shots / warm up time for shot
@export var accuracy : float #angle in degrees that projectiles can be fired
@export var projectileSpeed : float #pixels per second
@export var projectileSize : float #percentage set to 1 by default
@export var penetration : float #number of possible enemies hit. cannot go below 1
@export var effectsOnHit : Array
