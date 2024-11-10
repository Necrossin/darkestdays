if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Dual Elites"
	SWEP.Author	= ""
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 65
	GAMEMODE:KilliconAddFont( "dd_elites", "CSKillIcons", "s", Color(231, 231, 231, 255 ) )
end



function SWEP:InitializeClientsideModels()
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.926, 0), angle = Angle(0, 0, 57.249) },
		["v_weapon.elite_left"] = { scale = Vector(1, 1, 1), pos = Vector(0.972, 0.261, 2.427), angle = Angle(37.533, 32.087, -8.296) }
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
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "dd_base"

SWEP.IgnoreSprint = true

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_elite.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_elite.mdl" )

SWEP.IsLight = true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "duel"

SWEP.Caliber = CAL_9

SWEP.Primary.Sound			= Sound("Weapon_ELITE.SingleDD")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber]
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.16
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Tracer = "Tracer"
SWEP.MuzzleEffect			= "rg_muzzle_pistol"
SWEP.ShellEffect			= "rg_shelleject"

SWEP.Dual = true

SWEP.Primary.Cone = 0.053
SWEP.Primary.ConeMoving = 0.063
SWEP.Primary.ConeCrouching = 0.04

sound.Add( {
	name = "Weapon_ELITE.SingleDD",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 110,
	sound = "weapons/elite/elite-1.wav"
} )


util.PrecacheSound( "weapons/m4a1/m4a1-1.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	//self:EmitSound("weapons/m4a1/m4a1-1.wav", 70, math.random(165, 175), 0.75, CHAN_WEAPON + 20)
	self:EmitSound("weapons/m249/m249-1.wav", 70, math.random(145, 155), 0.75, CHAN_WEAPON + 20)
end
// 2 - left
// 5 - right
function SWEP:SendWeaponAnimation()
	//self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( self:Clip1() % 2 == 0 and 5 or 2 )
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
		local damage = self.Primary.Damage
		
		if self.Owner:IsSprinting() then
			damage = self.Primary.Damage*1.2
		end
		
		if self.Owner:IsDiving() then
			damage = self.Primary.Damage*1.5
		end
		
		self:ShootBullets( damage, self.Primary.NumShots, self.Owner:IsDiving() and crouching or moving)
	else
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, crouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, primary)
		end
	end
end

function SWEP:GetTracerOrigin()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local vm = owner:GetViewModel()
		if vm and vm:IsValid() then
			local attachment = vm:GetAttachment( self:Clip1() % 2 == 0 and 1 or 2 )
			if attachment then
				return attachment.Pos
			end
		end
	end
end

//fix the muzzleflashes and shit
function SWEP:ShootCustomEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	if not IsFirstTimePredicted() then return end
	
	
	if self.MuzzleEffect ~= "none" then
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
		fx:SetNormal(PlayerAim)
		fx:SetAttachment( self:Clip1() % 2 == 0 and 2 or 1 )
		util.Effect(self.MuzzleEffect,fx)
	end
	
	if self.ShellEffect ~= "none" then
		if self.ShellEffect then
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(PlayerAim)
			fx:SetAttachment( self:Clip1() % 2 == 0 and 4 or 3 )
			util.Effect(self.ShellEffect,fx)
		end
	end
	
end
