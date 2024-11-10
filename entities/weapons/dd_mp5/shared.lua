if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "MP5"			
	SWEP.Author	= ""
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFlip = false//true
	SWEP.IconLetter = "x"
	SWEP.ViewModelFOV = 55//65
	GAMEMODE:KilliconAddFont("dd_mp5", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.SwitchWorldModel = true
		
end

function SWEP:InitializeClientsideModels()

	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.449, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 55.826, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 31.621, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.933, -16.671, 38.969) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.537, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.805, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.078, -29.507, 45.777) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.185, 55.515, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 13.442, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.587, 79.385, -12.735) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.5, 57.05, 60.123) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.022, 96.39, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-20.316, 82.165, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -36.39, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.645, 17.565, -6.618) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.569, 0.104, 16.229) }
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
		["mp5"] = { type = "Model", model = "models/weapons/cstrike/c_smg_mp5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-18.132, 7.808, -9.037), angle = Angle(-6.198, 0, -180), size = Vector(1.309, 1.309, 1.309), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, WorldModel = true }
	}

end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model( "models/weapons/cstrike/c_smg_mp5.mdl" )//Model ( "models/weapons/v_smg_mp5.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_mp5.mdl" )

SWEP.IsLight = true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Caliber = CAL_9

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.SingleDD")
SWEP.Primary.Recoil			= 0.8//2.2
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.Primary.Delay			= 0.085
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*4//62
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Primary.Cone = 0.055
SWEP.Primary.ConeMoving = 0.055//0.065
SWEP.Primary.ConeCrouching = 0.04

SWEP.Tracer = "Tracer" //temp fix
SWEP.NoSmoke = false

SWEP.ShellEffect			= "rg_shelleject" 
SWEP.MuzzleEffect			= "rg_muzzle_smg"

SWEP.MuzzleAttachment		= 1//"1"

SWEP.SprintPos = Vector(0.444, -3.988, -1.045)
SWEP.SprintAng = Angle(-11.327, 35.444, -28.116)

sound.Add( {
	name = "Weapon_MP5Navy.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 110,
	sound = "weapons/mp5navy/mp5-1.wav"
} )


util.PrecacheSound( "weapons/m4a1/m4a1-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/m4a1/m4a1-1.wav", 70, math.random(165, 175), 0.75, CHAN_WEAPON + 20)
end

local cone_skill = SKILL_BULLET_STEADYAIM_BONUS
function SWEP:FireBullet()

	local cone_mul = 1
	
	if self.Owner._SkillSteadyAim then
		cone_mul = cone_skill * 1
	end
	
	local primary = self.Primary.Cone * cone_mul
	local moving = self.Primary.ConeMoving * cone_mul
	local crouching = self.Primary.ConeCrouching * cone_mul

	if self.Owner:GetVelocity():LengthSqr() > 900 then		
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Owner:IsDiving() and crouching or moving)
	else
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, crouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, primary)
		end
	end
end

function SWEP:GetPrimaryDelayModifier()
	return self.Owner:IsDiving() and 0.8 or 1
end
