if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.Author	= ""
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 50
	SWEP.SlotPos = 13
	SWEP.IconLetter = "m"
	killicon.AddFont("dd_p90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.SwitchWorldModel = true
	
end

function SWEP:InitializeClientsideModels()
	


	/*self.IdleMods = {
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.116, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-16.577, 63.733, 6.777) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.014, -18.673, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.51, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.244, -23.026, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(39.101, 11.043, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.843, -10.344, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.604, -15.546, 5.583) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.735, -0.036, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 37.405, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -11.95, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.48, 65.556, 1.289) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.237, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.136, 50.796, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-31.872, -8.08, 0) }
	}*/
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 31.235, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.014, -30.344, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.822, -9.943, -16.744) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.835, -25.078, 3.555) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-37.197, 1.657, 0) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.116, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.87, 86.263, 5.782) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 8.833, -7.915) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.784, 52.356, 41.751) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15.35, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.136, 81.794, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 58.442, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 3.77, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.48, 88.38, 1.289) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 1.187, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.862, 15.824, -11.806) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.973, -11.32, 0) }
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
		["p90"] = { type = "Model", model = "models/weapons/cstrike/c_smg_p90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-18.066, 7.282, -7.536), angle = Angle(-10.259, -2.52, -180), size = Vector(1.292, 1.292, 1.292), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, WorldModel = true }
	}

end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_p90.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_p90.mdl" )

SWEP.IsLight = true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Caliber = CAL_5_7

SWEP.Primary.Sound			= Sound("Weapon_P90.SingleDD")
SWEP.Primary.Recoil			= 0.6--2.6
SWEP.Primary.RecoilKick 	= 0.3
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.06
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber] * 2
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Primary.Cone = 0.07
SWEP.Primary.ConeMoving = 0.07
SWEP.Primary.ConeCrouching = 0.05

SWEP.MuzzleEffect			= "rg_muzzle_smg"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.SprintPos = Vector(0.439, -3.449, -1.053)
SWEP.SprintAng = Angle(-11.327, 35.444, -28.303)

sound.Add( {
	name = "Weapon_P90.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 105,
	sound = "weapons/p90/p90-1.wav"
} )


util.PrecacheSound( "weapons/m4a1/m4a1-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/m4a1/m4a1-1.wav", 70, math.random(195, 205), 0.75, CHAN_WEAPON + 20)
end
