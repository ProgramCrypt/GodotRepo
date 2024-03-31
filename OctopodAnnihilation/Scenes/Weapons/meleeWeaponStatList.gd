extends Resource

class_name MeleeWeaponStatList

@export var weaponType = "melee"
@export var damageType : int #0=hammer, 1=shield
@export var damage : float #value of health lost
@export var energyUse : float #value of energy used per swing
@export var swingRange : float #number of pixels outward swing prjects
@export var swingAngle : float #number of pixels of width of swing
@export var swingRate : float #time between swings
@export var swingSpeed : float #time that a swing takes
@export var effectsOnHit : Array
