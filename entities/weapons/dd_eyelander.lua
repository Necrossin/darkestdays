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
SWEP.PrintName = "Highlander"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6


SWEP.HoldType = "melee2"//melee2

SWEP.MeleeDamage = 50//40
SWEP.MeleeRange = 20+35//60
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//8

SWEP.SwingTime = 0.4 

/*SWEP.BlockPos = Vector(-14.391, -3.056, -0.89)
SWEP.BlockAng = Angle(39.291, 17.312, -67.795)*/

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.BlockPos = Vector(-23.2, -4.5, -2.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

SWEP.Primary.Delay = 1.2

SWEP.HitDecal = "Manhackcut"

SWEP.SwingHoldType = "melee2"

SWEP.NoHitSoundFlesh = true
SWEP.FixScale = true

SWEP.CanSlice = true

for i=1,4 do
	util.PrecacheSound("weapons/dsword/dsword_hit"..i..".wav")
end

util.PrecacheSound("weapons/dsword/dsword_hitwall1.wav")
util.PrecacheSound("weapons/dsword/dsword_stab.wav")

util.PrecacheSound("weapons/stunstick/stunstick_swing1.wav")
util.PrecacheSound("weapons/stunstick/stunstick_swing2.wav")

util.PrecacheModel( "models/weapons/c_models/c_claymore/c_claymore.mdl" )

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/stunstick/stunstick_swing"..math.random(2)..".wav", 75, math.Rand(80, 90))
end

function SWEP:PlayHitSound()
	//self:EmitSound("weapons/knife/knife_hitwall1.wav")
	self:EmitSound("weapons/dsword/dsword_hitwall1.wav", 70, math.random(80,90))
end

function SWEP:PlayHitFleshSound()
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 100, math.random(80,90))
	--self.Owner:EmitSound("weapons/physcannon/superphys_small_zap"..math.random(4)..".wav", 50, math.random(100,110))
	//self:EmitSound("weapons/dsword/dsword_hit"..math.random(4)..".wav")
end 

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	killicon.AddFont( "dd_eyelander", "Bison_30", "dominated", Color(231, 231, 231, 255 ) ) 
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
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.7550001144409, 0) },
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.912000656128, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.521999835968, 0) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.18500000238419, 0) }
	}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade+"] = { type = "Model", model = "models/props_canal/boat001b.mdl", bone = "handle", rel = "handle", pos = Vector(-26.215999603271, 0, 0.21099999547005), angle = Angle(0.21099999547005, 180, -180), size = Vector(0.20000000298023, 0.032000001519918, 0.0099999997764826), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["blade"] = { type = "Model", model = "models/props_canal/boat001b.mdl", bone = "handle", rel = "handle", pos = Vector(-26.215999603271, 0, -0.17000000178814), angle = Angle(0.22100000083447, 180, 0), size = Vector(0.20000000298023, 0.032000001519918, 0.0099999997764826), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "handle", rel = "", pos = Vector(0.74800002574921, -0.11100000143051, -0.16200000047684), angle = Angle(0, -90, 0), size = Vector(0.079000003635883, 0.041000001132488, 0.041000001132488), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["guard_part+"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "handle", rel = "guard", pos = Vector(0, -2.5759999752045, 1.6430000066757), angle = Angle(74.249000549316, -90, -180), size = Vector(0.092000000178814, 0.092000000178814, 0.092000000178814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["guard_part"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "handle", rel = "guard", pos = Vector(0, 2.5450000762939, 1.7369999885559), angle = Angle(108.76300048828, -90, 0), size = Vector(0.092000000178814, 0.092000000178814, 0.092000000178814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["guard"] = { type = "Model", model = "models/props_combine/combine_mortar01b.mdl", bone = "handle", rel = "handle", pos = Vector(-4.103000164032, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.039000000804663, 0.039000000804663, 0.039000000804663), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["core"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "handle", rel = "handle", pos = Vector(-13.918999671936, 0.17499999701977, 0.15299999713898), angle = Angle(90, 0, 0), size = Vector(0.078000001609325, 0.071000002324581, 0.20700000226498), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, no_blood = true }
	}
		

	self.WElements = {
		["core"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-13.918999671936, 0.17499999701977, 0.15299999713898), angle = Angle(90, 0, 0), size = Vector(0.078000001609325, 0.071000002324581, 0.20700000226498), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, no_blood = true },
		["guard"] = { type = "Model", model = "models/props_combine/combine_mortar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-4.103000164032, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.039000000804663, 0.039000000804663, 0.039000000804663), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.6310000419617, 0.91200000047684, 1.3880000114441), angle = Angle(90, -90, 0), size = Vector(0.079000003635883, 0.041000001132488, 0.041000001132488), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["guard_part"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "guard", pos = Vector(0, 2.5450000762939, 1.7369999885559), angle = Angle(108.76300048828, -90, 0), size = Vector(0.092000000178814, 0.092000000178814, 0.092000000178814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["guard_part+"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "guard", pos = Vector(0, -2.5759999752045, 1.6430000066757), angle = Angle(74.249000549316, -90, -180), size = Vector(0.092000000178814, 0.092000000178814, 0.092000000178814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade"] = { type = "Model", model = "models/props_canal/boat001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-26.215999603271, 0, -0.17000000178814), angle = Angle(0.22100000083447, 180, 0), size = Vector(0.20000000298023, 0.032000001519918, 0.0099999997764826), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["blade+"] = { type = "Model", model = "models/props_canal/boat001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-26.215999603271, 0, 0.21099999547005), angle = Angle(0.21099999547005, 180, -180), size = Vector(0.20000000298023, 0.032000001519918, 0.0099999997764826), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	
end
