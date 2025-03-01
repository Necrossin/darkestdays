if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Silenced Dual Elites"
	SWEP.Author	= ""
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 65
	GAMEMODE:KilliconAddFont( "dd_elites_silenced", "CSKillIcons", "s", Color(231, 231, 231, 255 ) )
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
		["silencer1"] = { type = "Model", model = "models/hunter/tubes/tube1x1x6.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(0, -3.165, 7.587), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["silencer1+"] = { type = "Model", model = "models/hunter/tubes/tube1x1x6.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0, -2.916, 7.427), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.WElements = {
		["silencer1+"] = { type = "Model", model = "models/hunter/tubes/tube1x1x6.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(11.244, 2.051, 3.798), angle = Angle(-90, -9.478, 0), size = Vector(0.014, 0.014, 0.014), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["plug1+"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "silencer1+", pos = Vector(0, 0, 3.349), angle = Angle(90, 0, 0), size = Vector(0.048, 0.048, 0.048), color = Color(30, 30, 30, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["silencer1"] = { type = "Model", model = "models/hunter/tubes/tube1x1x6.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.661, 2.565, -3.806), angle = Angle(-90, -12.065, 0), size = Vector(0.014, 0.014, 0.014), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["plug1"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "silencer1", pos = Vector(0, 0, 3.349), angle = Angle(90, 0, 0), size = Vector(0.048, 0.048, 0.048), color = Color(30, 30, 30, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
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
SWEP.IsSilenced = true

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= CaliberDamage[SWEP.Caliber] * SILENCER_REDUCTION
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.16
SWEP.Primary.DefaultClip	= CaliberAmmo[SWEP.Caliber]//SWEP.Primary.ClipSize*4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Tracer = ""

SWEP.MuzzleEffect			= "rg_muzzle_silenced"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.Dual = true

SWEP.Primary.Cone = 0.048
SWEP.Primary.ConeMoving = 0.053
SWEP.Primary.ConeCrouching = 0.04

SWEP.ReloadDuration = 3.7999998641014

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end

function SWEP:ShootCustomEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	if not IsFirstTimePredicted() then return end
	
	
	if self.MuzzleEffect ~= "none" then
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
		fx:SetNormal(PlayerAim)
		fx:SetAttachment(self:Clip1() % 2 == 0 and 1 or 2)
		util.Effect(self.MuzzleEffect,fx)
	end
	
	if self.ShellEffect ~= "none" then
		if self.ShellEffect then
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(PlayerAim)
			fx:SetAttachment(self:Clip1() % 2 == 0 and 3 or 4)
			util.Effect(self.ShellEffect,fx)
		end
	end
	
end
