if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "'Riot' Shotgun"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 50
	SWEP.IconLetter = "k"

	killicon.AddFont( "dd_riot", 	"HL2MPTypeDeath", 	"0", 	Color(231,231,231,255) )
	
	SWEP.ShowWorldModel = true
	
end

function SWEP:InitializeClientsideModels()
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.992, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 81.168, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.284, -3.889, 59.873) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 65.874, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 9.958, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.278, -4.987, 6.947) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.11, 64.6, 7.162) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 83.209, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 26.631, 82.323) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(22.266, 16.524, -0.19) }
	}

	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["shotty"] = { type = "Model", model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(-0.04, -2.422, 0.7), angle = Angle(-90, -90, 180), size = Vector(0.64, 0.64, 0.64), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["shotty_worldmodel"] = { type = "Model", model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.977, 1.049, -1.183), angle = Angle(101.676+90, -180, -0.387), size = Vector(0.667, 0.667, 0.667), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_shot_xm1014.mdl" )--"models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel			= Model ( "models/weapons/w_shot_xm1014.mdl" )--"models/Weapons/w_shotgun.mdl"

//SWEP.IsHeavy = true

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Caliber = CAL_12_GAUGE

SWEP.Primary.Sound			= Sound("Weapon_Riot.SingleDD")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 8
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.9
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//16
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"
SWEP.IsShotgun = true

sound.Add( {
	name = "Weapon_Riot.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 130,
	sound = "weapons/xm1014/xm1014-1.wav"
} )

SWEP.Primary.Cone = 0.13
SWEP.Primary.ConeMoving = 0.13
SWEP.Primary.ConeCrouching = 0.09

//SWEP.Tracer = ""

SWEP.MuzzleEffect			= "rg_muzzle_hmg"
SWEP.ShellEffect			= "rg_shelleject_shotgun" 

SWEP.SprintPos = Vector(1.588, -7.644, 0.592)
SWEP.SprintAng = Angle(-13.195, 46.192, -17.199)

SWEP.ReloadDelay = 0.5

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.AerodashPenalty = true

-- more snippets from zs weapon base

function SWEP:Reload()
	if self.Owner:IsCrow() then return end
	if self:IsCasting() then return end
	
	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:StartReloading()
	self:SetDTFloat( 3, CurTime() + self.ReloadDelay)
	self:SetNextPrimaryFire( CurTime() + math.max( self.Primary.Delay, self.ReloadDelay) )

	self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RELOAD_SHOTGUN, true ) 
	--self:GetOwner():DoReloadEvent()
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)	
end

function SWEP:StopReloading()
	self:SetDTFloat(3, 0)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.75)
	
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
end

function SWEP:DoReload()

	if not self:CanReload() or self:GetOwner():KeyDown(IN_ATTACK) then
		self:StopReloading()
		return
	end
	
	self:SendWeaponAnim(ACT_VM_RELOAD)
	--self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RELOAD_SHOTGUN ) 

	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1)

	self:SetDTFloat(3, CurTime() + self.ReloadDelay)

	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, self.ReloadDelay))
end

function SWEP:OnThink()
	if self:ShouldDoReload() then
		self:DoReload()
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		self:Reload() 
		return false
	end

	if self:IsReloading() then
		self:StopReloading()
		return false
	end

	return true
end

function SWEP:CanReload()
	return self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo)
end

function SWEP:ShouldDoReload()
	return self:GetDTFloat(3) > 0 and CurTime() >= self:GetDTFloat(3)
end

function SWEP:IsReloading()
	return self:GetDTFloat(3) > 0
end
