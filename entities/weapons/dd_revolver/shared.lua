if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Revolver"
	SWEP.Author	= ""
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 60
	killicon.AddFont( "dd_revolver", "HL2MPTypeDeath", ".", Color(231, 231, 231, 255 ) )
	
	SWEP.SwitchWorldModel = true

end

function SWEP:InitializeClientsideModels()
	

	/*self.ActionMods = {
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.181, 0) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0.926, 0) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -4.976, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(3.24, 8.647, -4.903), angle = Angle(23.423, 2.24, -180) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.819, 4.802) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 3.93, 13.965) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.423, 0) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -8.823, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.555, 59.345, 7.602) },
		["v_weapon.Right_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 14.637, 1.432) },
		["v_weapon.Right_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.676, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.213, 23.52, -7.685) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -23.924, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.003, 67.579, 6.908) },
		["v_weapon.Right_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.511, 0) },
		["v_weapon.Right_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.844, 0) },
		["v_weapon.Deagle_Trigger"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Deagle_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Deagle_Hammer"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Deagle_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Deagle_Clip"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Deagle_ClipRelease"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}*/
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.106, -3.852) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 12.946, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.224, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(1.34, 5.024, 0), angle = Angle(9.293, -3.836, -17.779) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.58, 30.076, 118.683) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.109, 0), angle = Angle(-14.115, -6.251, -1.461) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.871, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15.088, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.6, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.983, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.63, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.804, 0) }
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["viewmodel"] = { type = "Model", model = self.ViewModel, bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {}, Bonemerge = true, use_blood = true },
	}

	self.WElements = {
		//["revolver"] = { type = "Model", model = "models/weapons/c_models/c_snub_nose/c_snub_nose.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.532, 1.384, -2.438), angle = Angle(0, 0, -169.745), size = Vector(0.912, 0.912, 0.912), color = Color(170, 170, 170, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["357"] = { type = "Model", model = "models/weapons/c_357.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-15.013, 5.993, -5.279), angle = Angle(-2.881, 0.897, -174.247), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, WorldModel = true }
	}

end

SWEP.Base = "dd_base"


SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_357.mdl" )//"models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= Model ( "models/weapons/W_357.mdl" )

//SWEP.IsLight = true
SWEP.IsPistol = true

function SWEP:RunSequence() return "run_all_02" end

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "revolver"

SWEP.Caliber = CAL_11_20

SWEP.Primary.Sound			= Sound("Weapon_357.Single")--Sound( "weapons/diamond_back_01.wav" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.RecoilKick		= 0.4
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*4
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.Cone			= 0.065
SWEP.ConeMoving				= 0.13
SWEP.ConeCrouching			= 0.035

SWEP.DrawAnim = ACT_VM_DRAW

SWEP.FlipYaw = true

SWEP.Primary.Cone = 0.035
SWEP.Primary.ConeMoving = 0.045
SWEP.Primary.ConeCrouching = 0.025
SWEP.ConeIron = 0.035
SWEP.ConeIronCrouching = 0.025

SWEP.Tracer = ""

//SWEP.MuzzleAttachment = "muzzle"
SWEP.MuzzleEffect			= "rg_muzzle_hmg"

function SWEP:OnReload()
	/*for i=1,6 do
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(1)
		util.Effect("rg_shelleject_pistol",fx)
	end*/
end

util.PrecacheSound( "weapons/m249/m249-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/m249/m249-1.wav", 70, math.random(135, 145), 0.75, CHAN_WEAPON + 20)
end

SWEP.SprintPos = Vector(0, -17.555, -10.82)
SWEP.SprintAng = Angle(68.277, 0, 0)

SWEP.ReloadDuration = 3.6666665573915
