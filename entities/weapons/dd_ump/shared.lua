if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "UMP-45"			
	SWEP.Author	= ""
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "q"
	SWEP.ViewModelFOV = 55
	killicon.AddFont("dd_ump", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.SwitchWorldModel = true

end

function SWEP:InitializeClientsideModels()
	

	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 79.782, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 77.521, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25.461, 21.61, 5.171) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.142, 2.971, -12.931) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 19.829, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.864, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.492, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.536, 17.28, -25.07) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 79.509, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -35.202, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 86.277, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.506, -6.436, -34.891) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.072, 0, -5.453) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -14.891, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 13.835, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.232, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.114, -24.16, -10.79) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.392, -14.134, -9.235) }
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
		["ump"] = { type = "Model", model = "models/weapons/cstrike/c_smg_ump45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-19.649, 8.928, -5.935), angle = Angle(-10.094, -1.785, 176.057), size = Vector(0.97, 0.97, 0.97), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, WorldModel = true }
	}

end

SWEP.IsLight = true

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_ump45.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_ump45.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Caliber = CAL_11_43

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 26
SWEP.Primary.Delay			= 0.13
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"


SWEP.Primary.Cone = 0.055
SWEP.Primary.ConeMoving = 0.064
SWEP.Primary.ConeCrouching = 0.035

SWEP.ReloadDuration = 3.4848485194673

SWEP.MuzzleEffect			= "rg_muzzle_smg"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.SprintPos = Vector(0, -7.411, -4.865)
SWEP.SprintAng = Angle(-8.558, 45.424, -36.417)