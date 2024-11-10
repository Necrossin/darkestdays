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
SWEP.PrintName = "Mr Sledge 3.0"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6


SWEP.HoldType = "melee2"//melee2

SWEP.MeleeDamage = 65
SWEP.MeleeRange = 20+25//60

SWEP.SwingTime = 0.6 

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.BlockPos = Vector(-23.2, -8.5, 4.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

SWEP.Primary.Delay = 1.5

SWEP.ExtraDamageForce = 40

SWEP.HitDecal = "ExplosiveGunshot"

SWEP.SwingHoldType = "melee2"

SWEP.NoHitSoundFlesh = true
SWEP.Dismember = true

SWEP.FixScale = true

SWEP.MeleePower = 130
SWEP.BlockPower = 130

SWEP.BlockSpeed = 0.7

SWEP.AnimSpeed = 0.5

util.PrecacheSound("physics/metal/metal_canister_impact_hard1.wav")
util.PrecacheSound("physics/metal/metal_canister_impact_hard2.wav")
util.PrecacheSound("physics/metal/metal_canister_impact_hard3.wav")

util.PrecacheModel( "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl" )

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",50, math.Rand(110, 120), 0.7, CHAN_AUTO)
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/gore/dismemberment.wav", 100, math.Rand(90, 100))
	self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",50, math.Rand(110, 120), 0.5, CHAN_AUTO)
end 

function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed( self.Owner:GetMaxSpeed() * 0.75 )
	end
end

//Killicon
if CLIENT then 
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_sledge", "Bison_30", "killicon_sledge", Color(231, 231, 231, 255 ) ) 
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

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

	

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 37.601001739502, 0) },
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12.512999534607, 0) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.9429998397827, 11.069000244141, 6.5079998970032) }
	}
		
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
	
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lock"] = { type = "Model", model = "models/props_wasteland/prison_padlock001a.mdl", bone = "handle", rel = "head", pos = Vector(-3.7990000247955, 1.7660000324249, -2.3410000801086), angle = Angle(-58.826999664307, -96.708000183105, -96.03099822998), size = Vector(0.15800000727177, 0.15800000727177, 0.15800000727177), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chain++"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "handle", rel = "head", pos = Vector(-2.1960000991821, 2.0759999752045, -1.6460000276566), angle = Angle(92.053001403809, 18.231000900269, 74.732002258301), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/gibs/hgibs_spine.mdl", bone = "handle", rel = "", pos = Vector(0.98900002241135, -5.5500001907349, -0.16599999368191), angle = Angle(-92.90299987793, -87.473999023438, -1.37600004673), size = Vector(0.77499997615814, 0.73100000619888, 1.3170000314713), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_debris/woodset01", skin = 0, bodygroup = {} },
		["chain+"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "handle", rel = "head", pos = Vector(-2.8259999752045, 2.0009999275208, -2.0090000629425), angle = Angle(23.14999961853, -119.39099884033, 57.393001556396), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "handle", rel = "handle", pos = Vector(-0.43000000715256, -2.0160000324249, -6.981999874115), angle = Angle(-92.323997497559, 90, 0), size = Vector(0.29199999570847, 0.29199999570847, 0.29199999570847), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chain"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "handle", rel = "head", pos = Vector(-2.779000043869, 1.4279999732971, -2.4949998855591), angle = Angle(26.429000854492, -69.514999389648, -12.112999916077), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head_part"] = { type = "Model", model = "models/props_c17/trap_crush01a.mdl", bone = "handle", rel = "head", pos = Vector(-3.0179998874664, 0.88800001144409, -1.87399995327), angle = Angle(-23.982000350952, 0, -180), size = Vector(0.048000000417233, 0.048000000417233, 0.048000000417233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		--["mrsledge"] = { type = "Model", model = "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl", bone = "handle", rel = "", pos = Vector(1.001, 0.09, -0.007), angle = Angle(0, 3.915, -90), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}
	self.WElements = {
		--["mrsledge"] = { type = "Model", model = "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.032, 1.312, 0.3), angle = Angle(-169.353, 0, 3.953), size = Vector(0.839, 0.839, 0.839), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["lock"] = { type = "Model", model = "models/props_wasteland/prison_padlock001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head", pos = Vector(-3.7990000247955, 1.7660000324249, -2.3410000801086), angle = Angle(-58.826999664307, -96.708000183105, -96.03099822998), size = Vector(0.15800000727177, 0.15800000727177, 0.15800000727177), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chain++"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head", pos = Vector(-2.1960000991821, 2.0759999752045, -1.6460000276566), angle = Angle(92.053001403809, 18.231000900269, 74.732002258301), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/gibs/hgibs_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.0780000686646, 1.5119999647141, -4.2080001831055), angle = Angle(6.3579998016357, -90, -4.313000202179), size = Vector(0.77499997615814, 0.73100000619888, 1.3170000314713), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_debris/woodset01", skin = 0, bodygroup = {} },
		["head_part"] = { type = "Model", model = "models/props_c17/trap_crush01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head", pos = Vector(-3.0179998874664, 0.88800001144409, -1.87399995327), angle = Angle(-23.982000350952, 0, -180), size = Vector(0.048000000417233, 0.048000000417233, 0.048000000417233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chain"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head", pos = Vector(-2.779000043869, 1.4279999732971, -2.4949998855591), angle = Angle(26.429000854492, -69.514999389648, -12.112999916077), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chain+"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head", pos = Vector(-2.8259999752045, 2.0009999275208, -2.0090000629425), angle = Angle(23.14999961853, -119.39099884033, 57.393001556396), size = Vector(0.11900000274181, 0.098999999463558, 0.11900000274181), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.43000000715256, -2.0160000324249, -6.981999874115), angle = Angle(-92.323997497559, 90, 0), size = Vector(0.29199999570847, 0.29199999570847, 0.29199999570847), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	//self:InitializeClientsideModels_Additional()
	
end
