if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Boomstick"//"SPAS-12"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 60
	SWEP.IconLetter = "k"
	//killicon.AddFont("dd_spas12", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	killicon.AddFont( "dd_spas12", 	"HL2MPTypeDeath", 	"0", 	Color(231,231,231,255) )
	
end

function SWEP:InitializeClientsideModels()
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 30.871, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 28.691, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0.49, 0, 2.74), angle = Angle(21.065, -16.837, -48.899) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.352, -8.362, 45.466) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -81.548, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 4.71, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.447, 1.634, 36.131) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -16.059, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.635, 17.607, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.306, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.335, 11.029, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 14.954, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.242, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.856, 21.045, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -42.342, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 9.019, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.642, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.653, 19.509, 65.863) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-16.896, -21.583, 22.357) }
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
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_shotgun.mdl" )
SWEP.WorldModel			= Model ( "models/Weapons/w_shotgun.mdl" )

//SWEP.IsHeavy = true

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Caliber = CAL_12_GAUGE

SWEP.Primary.Sound			= Sound("Weapon_Shotgun.DoubleDD")//Sound("Weapon_Shotgun.Single")
SWEP.Primary.Recoil			= 5//25 -- 3.5
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 7//5
SWEP.Primary.ClipSize		= 2//4
SWEP.Primary.Delay			= 0.25
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//16
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"
SWEP.IsShotgun = true
SWEP.ReloadSound			= Sound("Weapon_Shotgun.Reload")

SWEP.Primary.Cone = 0.2
SWEP.Primary.ConeMoving = 0.22
SWEP.Primary.ConeCrouching = 0.22

SWEP.SprintPos = Vector(0.201, -15.277, -3.217)
SWEP.SprintAng = Angle(-7.035, 53.466, -24.623)

sound.Add( {
	name = "Weapon_Shotgun.DoubleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 110,
	sound = "weapons/shotgun/shotgun_dbl_fire.wav"
} )

SWEP.Tracer = ""

SWEP.MuzzleEffect			= "rg_muzzle_hmg"
SWEP.ShellEffect			= "rg_shelleject_shotgun" 

//SWEP.MuzzleAttachment = "muzzle"

SWEP.ReloadDelay = 0.3

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.AerodashPenalty = true

util.PrecacheSound( "weapons/m249/m249-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/m249/m249-1.wav", 70, math.random(175, 185), 0.55, CHAN_WEAPON + 20)
end

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

	if not self:CanReload() or self:GetOwner():KeyDown(IN_ATTACK) and self:Clip1() > 0 or self:GetOwner():KeyDown(IN_ATTACK2) then
		self:StopReloading()
		return
	end
	
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:EmitSound( self.ReloadSound )
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