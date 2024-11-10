if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "M3 Super 90"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 55
	SWEP.IconLetter = "k"
	GAMEMODE:KilliconAddFont("dd_m3super90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.SwitchWorldModel = true
end

function SWEP:InitializeClientsideModels()
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 8.817, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.792, 48.234, -4.156) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.402, 9.88, -3.237) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-16.285, -6.84, 21.245) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.71, 66.892, 12.578) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -42.965, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.13, -5.072) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-16.584, 37.367, 1.582) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.937, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 58.141, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.884, 15.196, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.937, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.876, 32.393, 122.89) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -40.399, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.503, -33.982, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.377, 78.275, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(24.035, -3.427, -21.414) }
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
		["m3"] = { type = "Model", model = "models/weapons/cstrike/c_shot_m3super90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-13.31, 8.656, -5.302), angle = Angle(-10.563, 0, -180), size = Vector(1.054, 1.054, 1.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, WorldModel = true }
	}
	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_shot_m3super90.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_shot_m3super90.mdl" )

//SWEP.IsHeavy = true

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Caliber = CAL_12_GAUGE

SWEP.Primary.Sound			= Sound( "Weapon_M3.SingleDD" )//Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 3//20 -- 3.5
SWEP.Primary.RecoilKick 	= 1 
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 12//10
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 1.25
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.IsShotgun = true

sound.Add( {
	name = "Weapon_M3.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 95,
	sound = "weapons/m3/m3-1.wav"
} )

SWEP.ViewmodelOffset = Vector(-4, 0, 0)

SWEP.SprintPos = Vector(1.588, -7.644, 0.592)
SWEP.SprintAng = Angle(-13.195, 46.192, -17.199)

SWEP.Primary.Cone = 0.18
SWEP.Primary.ConeMoving = 0.19
SWEP.Primary.ConeCrouching = 0.14

//SWEP.Tracer = ""

SWEP.MuzzleEffect			= "rg_muzzle_hmg"
SWEP.ShellEffect			= "rg_shelleject_shotgun" 

SWEP.ReloadDelay = 0.6

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.AerodashPenalty = true

util.PrecacheSound( "weapons/m249/m249-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/m249/m249-1.wav", 70, math.random(175, 185), 0.55, CHAN_WEAPON + 20)
end

function SWEP:SendWeaponAnimation()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "shoot2" ) )
	vm:SetPlaybackRate( 0.8 )	
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