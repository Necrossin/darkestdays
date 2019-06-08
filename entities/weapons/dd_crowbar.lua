if SERVER then 
	AddCSLuaFile() 
end

//Melee base
SWEP.Base = "dd_meleebase"

//Models paths
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = Model ( "models/weapons/c_dsword2.mdl"  )
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl"  )

//Name and fov
SWEP.PrintName = "Crowbar"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6


SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 31//25
SWEP.MeleeRange = 20+26//55
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//5

SWEP.SwingTime = 0.15 

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.BlockPos = Vector(-23.2, -8.5, 4.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

SWEP.Primary.Delay = 1

SWEP.SwingHoldType = "melee2"

SWEP.Dismember = true

SWEP.NoHitSoundFlesh = true

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

local fleshsound ={
	Sound( "physics/gore/flesh_impact_bullet1.wav" ),
	Sound( "physics/gore/flesh_impact_bullet2.wav" ),
	Sound( "physics/gore/flesh_impact_bullet3.wav" ),
	Sound( "physics/gore/flesh_impact_bullet4.wav" ),
	Sound( "physics/gore/flesh_impact_bullet5.wav" ),
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/gore/flesh_impact_bullet"..math.random(5)..".wav", 100, math.Rand(90, 100), 1, CHAN_AUTO)
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
	--self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",50, math.Rand(110, 120), 0.5, CHAN_AUTO)
end 

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	if not block and hitent:IsValid() and hitent:IsPlayer() and not self.m_ChangingDamage and hitent:Health() >= hitent:GetMaxHealth() / 2 then
		self.m_ChangingDamage = true
		self.MeleeDamage = self.MeleeDamage * 1.2
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)
	if self.m_ChangingDamage then
		self.m_ChangingDamage = false

		self.MeleeDamage = self.MeleeDamage / 1.2
	end
end

--function SWEP:PlayHitFleshSound()
	--self:EmitSound("Weapon_Crowbar.Melee_Hit")
--end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	killicon.AddFont( "dd_crowbar", "HL2MPTypeDeath", "6", Color(231, 231, 231, 255 ) )

end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end


util.PrecacheModel( "models/weapons/w_crowbar.mdl" )

function SWEP:InitializeClientsideModels()
	
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.241, 71.024, 16) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 49.685, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -4.715, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-30.118, -10.584, -18.035) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.829, -8.815, 2.362) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.93, 12.824, 44.318) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.273, 37.96, -5.909) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 76.817, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.77, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.678, 75.078, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 2.282, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 74.755, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.778, 67.012, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.971, 0.273, 0) }
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["crowbar"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "handle", rel = "", pos = Vector(1.363, -4.36, -0.746), angle = Angle(3.453, -95.268, -120.568), size = Vector(0.953, 0.953, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	
	
end
