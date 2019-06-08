if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "FAMAS"			
	SWEP.Author	= ""
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "t"
	
	killicon.AddFont("dd_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.SwitchWorldModel = true
	
end

function SWEP:InitializeClientsideModels()
	
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 58.519, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 67.54, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.757, -20.946, 15.472) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.063, 29.361, 6.212) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.536, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-32.812, -31.181, 97.593) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.092, -11.853, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 39.683, 3.757) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 67.57, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-22.737, 92.117, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.715, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.169, 43.456, 50.382) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-0.01, 3.315, 0.962), angle = Angle(24.091, 17.739, 5.999) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -64.218, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -75.385, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.46, 47.187, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.592, 3.433, -9.436) }
	}

	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["viewmodel"] = { type = "Model", model = self.ViewModel, bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {}, Bonemerge = true, use_blood = true },
	}

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["famas"] = { type = "Model", model = "models/weapons/cstrike/c_rif_famas.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-18.414, 8.406, -5.998), angle = Angle(-9.742, 0.621, 178.457), size = Vector(1.195, 1.195, 1.195), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_famas.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_famas.mdl" )

SWEP.IsHeavy = true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Caliber = CAL_5_56
SWEP.FirePower = 1.1

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Unrecoil		= 11
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]*SWEP.FirePower
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 26
SWEP.Primary.Delay			= 0.126
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*3.5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Primary.Cone = 0.05
SWEP.Primary.ConeMoving = 0.06
SWEP.Primary.ConeCrouching = 0.045

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 

SWEP.SprintPos = Vector(1.35, -1.362, -5.131)
SWEP.SprintAng = Angle(-4.14, 42.682, -33.015)


SWEP.ReloadDuration = 3.3703702327237

