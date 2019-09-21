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
SWEP.PrintName = "Axe"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.BlockPos  = Vector(-9.36, 1.001, -0.447)
SWEP.BlockAng = Angle(-0.235, -25.39, -69.953)

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 35//27
SWEP.MeleeRange = 20 + 25//58
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//5

SWEP.SwingTime = 0.15

//SWEP.BlockPos = Vector(-14.391, -3.056, -0.89)
//SWEP.BlockAng = Angle(39.291, 17.312, -67.795)

SWEP.Primary.Delay = 0.9

SWEP.SwingHoldType = "melee2"

SWEP.NoHitSoundFlesh = true
SWEP.Dismember = true


for i=6,8 do
	util.PrecacheSound("physics/metal/metal_sheet_impact_hard"..i..".wav")
end

for i=1,4 do
	util.PrecacheSound("ambient/machines/slicer"..i..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(1,4)..".wav",100, math.Rand(86, 100))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90)) 
	self:EmitSound("ambient/machines/slicer"..math.random(1,4)..".wav",100, math.Rand(86, 100))
end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	killicon.AddFont( "dd_axe", "Bison_30", "axe'd", Color(231, 231, 231, 255 ) ) 
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)

end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)

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


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["axe_bloody"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "handle", rel = "", pos = Vector(0.901, -3.195, -0.157), angle = Angle(0, 0, 180), size = Vector(0.815, 0.815, 0.815) * 1.1, color = Color(255, 255, 255, 255), surpresslightning = false, material = "decals/blood"..math.random(8), skin = 0, bodygroup = {} },
		["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "handle", rel = "", pos = Vector(0.901, -3.195, -0.157), angle = Angle(0, 0, 180), size = Vector(0.815, 0.815, 0.815), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
	}

	self.WElements = {
		["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.272, 1.741, -6.066), angle = Angle(0, 0, 83.808), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
end

util.PrecacheModel( "models/props/CS_militia/axe.mdl" )
util.PrecacheModel( "models/props_junk/PopCan01a.mdl" )

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	local health_mul = math.Clamp( self.Owner:Health() / self.Owner:GetMaxHealth(), 0, 1 )
	if not block and hitent:IsValid() and hitent:IsPlayer() and not self.m_ChangingDamage and health_mul <= 0.5 then
		self.m_ChangingDamage = true
		self.MeleeDamage = self.MeleeDamage * 1.5
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)
	if self.m_ChangingDamage then
		self.m_ChangingDamage = false

		self.MeleeDamage = self.MeleeDamage / 1.5
	end
end
