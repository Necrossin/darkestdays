if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Sparkler"
	SWEP.Author	= ""
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 68
	killicon.AddFont( "dd_sparkler", "CSKillIcons", "u", Color(231, 231, 231, 255 ) )
	
	SWEP.ShowWorldModel = false
	
	--SWEP.IgnoreThumbs = true

end

function SWEP:InitializeClientsideModels()
	

	/*self.ActionMods = {
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.753, 53.949, 1.462) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.221, 0) },
		["v_weapon.Right_Pinky03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -41.57, 0) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 47.123, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.909, 1.722, 12.404) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.411, 48.486, 7.302) },
		["v_weapon.Right_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -23.932, 0) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 17.156, 0) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -4.178, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.292, -1.354, -3.254) },
		["v_weapon.Right_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.273, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.357, 48.956, 0) },
		["v_weapon.Right_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -39.19, 0) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0.55, 0) },
		["v_weapon.Right_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -36.975, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.385, 37.632, 9.342) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0.653, 11.758, -5.038), angle = Angle(18.666, 14.597, -180) }
	}
	
	self.IdleMods = {
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.753, 0.093, 1.462) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.451, 0) },
		["v_weapon.Right_Pinky03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -41.57, 0) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.54, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(21.716, 6.383, 25.594) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.411, 13.789, 7.302) },
		["v_weapon.Right_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -23.932, 0) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -13.596, 0) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 19.934, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.292, 5.781, -14.566) },
		["v_weapon.Right_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -11.285, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.357, -4.791, 0) },
		["v_weapon.Right_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -39.19, 0) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.16, 0) },
		["v_weapon.Right_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -36.975, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.385, -0.373, 9.342) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(3.394, 5.723, -3.886), angle = Angle(33.14, -23.903, -128.743) }
	}*/
	
	self.IdleMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 2.734, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 34.325, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-6.582, 0.731, 2.9), angle = Angle(9.649, 63.039, -15.58) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.526, -7.716, -60.021) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -75.21, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0.356, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.416, -6.505) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10.989, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.053, -12.537, 12.744) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15.76, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.31, 9.784, 0.093) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.167, -47.36, 57.695) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.015, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -60.19, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.239, 16.976, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -56.732, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.884, 7.935, 0) }
	}
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.465, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.196, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-3.826, 0.731, 0), angle = Angle(16.572, 75.934, -31.409) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.325, -5.657, -56.229) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -75.21, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 46.655, 2.292) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -9.504, -6.505) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10.989, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.053, 35.883, 9.73) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.444, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.31, 50.185, 0.093) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.986, 1.151, 4.475) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.296, 31.069, 123.183) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12.04, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -60.19, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.239, 56.568, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -41.93, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.826, 0.024, 4.397) }
	}

	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	
	self.VElements = {
		["thing1"] = { type = "Model", model = "models/Items/battery.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(-0.021, 1.034, -0.08), angle = Angle(-90, 0, -90), size = Vector(0.273, 0.273, 0.273), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["thing2"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib6.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "thing1", pos = Vector(-0.095, -0.185, -2.243), angle = Angle(-19.282, 90, -3.106), size = Vector(0.425, 0.425, 0.425), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["viewmodel"] = { type = "Model", model = self.ViewModel, bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {}, Bonemerge = true, use_blood = true },
	}

	self.WElements = {
		["sparkler"] = { type = "Model", model = "models/weapons/w_pist_fiveseven.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.726, 1.34, 1.776), angle = Angle(-1.527, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["thing1"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sparkler", pos = Vector(1.32, 0.079, 5.921), angle = Angle(90, 0, 0), size = Vector(0.365, 0.365, 0.365), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "dd_base"


SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_fiveseven.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "revolver"

SWEP.Caliber = CAL_5_7

SWEP.Primary.Sound			= Sound("Weapon_AR2.NPC_Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.165
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.065
SWEP.ConeMoving				= 0.13
SWEP.ConeCrouching			= 0.035

SWEP.Mana = 3

SWEP.IsSpell = true

SWEP.UseCursedTracer = true

SWEP.GunSmokeAtt = 1
SWEP.MuzzleEffect			= "rg_muzzle_smg"

SWEP.FlipYaw = true

SWEP.Primary.Cone = 0.04
SWEP.Primary.ConeMoving = 0.04
SWEP.Primary.ConeCrouching = 0.03
SWEP.ConeIron = 0.035
SWEP.ConeIronCrouching = 0.025


function SWEP:TakeAmmo()
	if CLIENT then return end
	if self.Owner then
		self.Owner:SetMana(math.Clamp(self.Owner:GetMana()-self.Mana,0,self.Owner:GetMana()))
	end
end

function SWEP:CanPrimaryAttack()
	
	if self.Owner:IsGhosting() then return false end

	if self.Owner:GetMana() < self.Mana then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

SWEP.SprintPos = Vector(0, -15.08, -10.056)
SWEP.SprintAng = Angle(54.326, 0, 0)