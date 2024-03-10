extends Resource

class_name WeaponUpgradeAttributes

@export var ballisticName : String
@export var laserName : String
@export var plasmaName : String
@export var meleeName : String
@export var damage : float #value of health lost. cannot go below 1
@export var energyUse : float #value of energy used per shot or per second for lasers
@export var projectileRange : float #number of tiles. cannot go below 1
@export var fireRate : float #time between shots / warm up time for shot
@export var accuracy : float #angle in degrees that projectiles can be fired
@export var projectileSpeed : float #pixels per second
@export var projectileSize : float #percentage set to 1 by default
@export var penetration : float #number of possible enemies hit. cannot go below 1
@export var effectsOnHit : Array


#ballisticUpgrades = [{"levels": int, "name": [upgradeName1, upgradeName2, ...], "stat": stat, "modifier": [mod1, mod2, ...], "cost": [cost1, cost2, ...], "description": ""}]
#{"levels": null, "name": [], "stat": "", "modifier": [], "cost": [], "description": ""}

var ballisticUpgrades = [
	{"levels": 5, "name": ["6mm Caliber", "8mm Caliber", "10mm Caliber", "12mm Caliber", "14mm Caliber"], "stat": "damage", "modifier": [2, 2, 2, 2, 3], "cost": [35, 45, 60, 75, 90], "description": "Increased Damage"},
	{"levels": 2, "name": ["Short Barrel", "Long Barrel"], "stat": "projectileRange", "modifier": [200, 300], "cost": [40, 50], "description": "Increased Range"},
	{"levels": 3, "name": ["Hair Trigger", "Hardened Spring", "Heat Pipes"], "stat": "fireRate", "modifier": [-0.08, -0.06, -0.04], "cost": [50, 70, 90], "description": "Increased Fire Rate"},
	{"levels": 2, "name": ["Reflex Sight", "Telescopic Sight"], "stat": "accuracy", "modifier": [-2, -2], "cost": [40, 55], "description": "Increased Accuracy"},
	{"levels": 2, "name": ["Improved Propellant", "Advanced Propellant"], "stat": "projectileSpeed", "modifier": [200, 200], "cost": [50, 60], "description": "Increased Projectile Speed"},
	{"levels": 2, "name": ["Armor Piercing", "Advanced Armor Piercing"], "stat": "penetration", "modifier": [1, 1], "cost": [60, 80], "description": "Increased Penetration"},
	{"levels": 2, "name": ["Heat Recycling", "Kinetic Energy Recycling"], "stat": "energyUse", "modifier": [-0.5, -0.5], "cost": [50, 70], "description": "Decreased Energy Use"}]
	
	
var laserUpgrades = [
	{"levels": 5, "name": ["Yellow Laser", "Green Laser", "Blue Laser", "Violet Laser", "UV Laser"], "stat": "damage", "modifier": [0.1, 0.1, 0.1, 0.1, 0.1], "cost": [40, 50, 60, 70, 80], "description": "Increased Damage"},
	{"levels": 2, "name": ["Improved Capacitor Charging", "Exceptional Capacitor Charging"], "stat": "fireRate", "modifier": [-0.1, -0.1], "cost": [50, 60], "description": "Decreased Warm-Up Time"},
	{"levels": 4, "name": ["Beam Expander", "Wide Beam Expander", "Advanced Beam Expander", "Maximal Beam Expander"], "stat": "projectileSize", "modifier": [1, 1, 1, 1], "cost": [45, 60, 75, 90], "description": "Widened Beam"},
	{"levels": 3, "name": ["Neutron Beam", "X-Ray Beam", "Gamma Ray Beam"], "stat": "penetration", "modifier": [1, 1, 1], "cost": [50, 65, 80], "description": "Increased Penetration"},
	{"levels": 6, "name": ["Heat Recycling", "Gold Circuitry", "Silver Circuitry", "Graphene Circuitry", "Cryo-Circuitry", "Superconductor Circuitry"], "stat": "energyUse", "modifier": [-1, -1, -0.5, -0.5, -0.5, -0.5], "cost": [40, 50, 60, 70, 80, 90], "description": "Decreased Energy Use"}]


var plasmaUpgrades = [
	{"levels": 5, "name": ["10,000 Degrees", "20,000 Degrees", "30,000 Degrees", "40,000 Degrees", "50,000 Degrees"], "stat": "damage", "modifier": [3, 3, 3, 4, 4], "cost": [45, 55, 65, 75, 85], "description": "Increased Damage"},
	{"levels": 4, "name": ["Short Barrel", "Long Barrel", "Electromagnetic Tightening", "Advanced Electromagnetic Tightening"], "stat": "projectileRange", "modifier": [100, 100, 100, 100], "cost": [35, 45, 60, 75], "description": "Increased Range"},
	{"levels": 4, "name": ["Improved Gas Injection", "Exceptional Gas Injection", "Heat Pipes", "Evaporative Cooling"], "stat": "fireRate", "modifier": [-0.2, -0.2, -0.2, -0.2], "cost": [45, 60, 75, 90], "description": "Increased Fire Rate"},
	{"levels": 3, "name": ["Iron Sight", "Reflex Sight", "Telescopic Sight"], "stat": "accuracy", "modifier": [-2, -1, -1], "cost": [40, 45, 50], "description": "Increased Accuracy"},
	{"levels": 3, "name": ["Tightened Funnel", "Improved Electrodes", "Advanced Electrodes"], "stat": "projectileSpeed", "modifier": [100, 100, 100], "cost": [50, 60, 70], "description": "Increased Projectile Speed"},
	{"levels": 4, "name": ["Enlarged Plasma Chamber", "Reinforced Plasma Chamber", "High-Compression Plasma Chamber", "Maximal-Compression Plasma Chamber"], "stat": "projectileSize", "modifier": [0.8, 0.8, 0.8, 0.8], "cost": [40, 50, 60, 70], "description": "Increased Projectile Size"},
	{"levels": 4, "name": ["Helium-Based Plasma", "Nitrogen-Based Plasma", "Oxygen-Based Plasma", "Argon-Based Plasma"], "stat": "penetration", "modifier": [1, 1, 1, 1], "cost": [40, 55, 70, 90], "description": "Increased Penetration"},
	{"levels": 2, "name": ["Heat Recycling", "Kinetic Energy Recycling"], "stat": "energyUse", "modifier": [-1, -1], "cost": [55, 75], "description": "Decreased Energy Use"}]
