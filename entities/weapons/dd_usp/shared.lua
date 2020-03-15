if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "USP"
	SWEP.Author	= ""
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 53
	killicon.AddFont( "dd_usp", "CSKillIcons", "a", Color(255, 255, 255, 255 ) )
	

	SWEP.ShowWorldModel = false
end

function SWEP:InitializeClientsideModels()
	

	/*self.ActionMods = {
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 39.138, 0) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15.487, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 33.65, 2.612) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.805, 19.399, -9.207) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12.481, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(6.05, 1.805, 1.886), angle = Angle(33.269, -2.132, -151.094) },
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.464, 61.655, 0.505) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 8.312, -8.431) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 9.994, 18.58) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 51.549, 8.13) },
		["v_weapon"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 7.688) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -15.82, 33.937) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.782, 43.212, -35.813) }
	}
	
	self.IdleMods = {
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -38.419, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.586, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(5.472, 4.653, -3.733), angle = Angle(13.767, -1.727, -155.754) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -8.504, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.268, 14.696, -8.957) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.938, -14.474) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.184, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -3.109, 9.522) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.215, 34.044, 18.667) }
	}*/
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.148, 52.354, 3.252) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.906, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.876, -7.244, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-1.344, 7.295, 0.263), angle = Angle(31.986, 44.648, -10.726) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.338, -0.999, 6.105) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.206, 21.59, 103.916) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.059, -25.538, -15.879) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 48.717, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.922, 52.59, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 61.397, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 17.232, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-27.296, 6.86, 34.075) }
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
		["usp"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.756, 0.898, 2.091), angle = Angle(-3.414, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "dd_base"


SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_usp.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_usp.mdl" )

SWEP.IsLight = true

SWEP.IsPistol = true

function SWEP:RunSequence() return "run_all_02" end

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "revolver"

SWEP.Caliber = CAL_11_43

SWEP.Primary.Sound			= Sound( "Weapon_USP.SingleDD" )
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.16
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.065
SWEP.ConeMoving				= 0.13
SWEP.ConeCrouching			= 0.035

SWEP.FixParticleRotation = true

//SWEP.GunSmokeAtt = "1"
SWEP.MuzzleAttachment		= 1//"1"

SWEP.Primary.Cone = 0.04
SWEP.Primary.ConeMoving = 0.045
SWEP.Primary.ConeCrouching = 0.02

SWEP.MuzzleEffect			= "rg_muzzle_pistol" //todo: fix this sideways shit
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.SprintPos = Vector(0, -21, -11.733)
SWEP.SprintAng = Angle(68.277, 0, 0)

sound.Add( {
	name = "Weapon_USP.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 110,
	sound = "weapons/usp/usp_unsil-1.wav"
} )


util.PrecacheSound( "weapons/m4a1/m4a1-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	//self:EmitSound("weapons/m4a1/m4a1-1.wav", 70, math.random(165, 175), 0.75, CHAN_WEAPON + 20)
	self:EmitSound("weapons/m249/m249-1.wav", 70, math.random(185, 200), 0.75, CHAN_WEAPON + 20)
end
