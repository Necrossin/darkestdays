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
SWEP.PrintName = "Katana"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.HoldType = "melee2"//melee2

SWEP.MeleeDamage = 40//30.5
SWEP.MeleeRange = 20+35//60
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//9.4

SWEP.SwingTime = 0.2

SWEP.BlockPos = Vector(-23.2, -4.5, -2.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

--SWEP.BlockPos  = Vector(-9.36, 1.001, -0.447)
--SWEP.BlockAng = Angle(-0.235, -25.39, -69.953)

SWEP.Primary.Delay = 1.15

SWEP.HitDecal = "Manhackcut"

SWEP.SwingHoldType = "revolver"

SWEP.NoHitSoundFlesh = true

SWEP.CanSlice = true

--SWEP.BlockSpeed = 0.8

SWEP.FixScale = true



for i=1,6 do
	util.PrecacheSound("weapons/samurai/TF_katana_0"..i..".wav")
end

for i=1,3 do
	util.PrecacheSound("weapons/samurai/TF_katana_impact_object_0"..i..".wav")
end

for i=1,3 do
	util.PrecacheSound("weapons/samurai/TF_katana_slice_0"..i..".wav")
end

util.PrecacheModel( "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl" )

/*function SWEP:PlaySwingSound()
	self:EmitSound("weapons/samurai/TF_katana_0"..math.random(1, 6)..".wav", 75, math.random(95, 110))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/samurai/TF_katana_impact_object_0"..math.random(1, 3)..".wav", 75, math.random(95, 110))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/samurai/TF_katana_slice_0"..math.random(1, 3)..".wav", 75, math.random(95, 110) )
end */

function SWEP:PlayHitSound()
	self:EmitSound("weapons/dsword/dsword_hitwall1.wav", 75, math.random(135, 140))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/dsword/dsword_hit"..math.random(4)..".wav", 75, math.random(120, 130))
end 


//Killicon
if CLIENT then //killicon.AddFont( "weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255 ) ) 
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_katana", "Bison_30", "killicon_katana", Color(231, 231, 231, 255 ) ) 
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


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["katana"] = { type = "Model", model = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl", bone = "handle", rel = "", pos = Vector(0.894, -2.523, -0.301), angle = Angle(-89.14, 90, 0), size = Vector(0.797, 0.797, 0.797), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {}, use_blood = true}
		["blade"] = { type = "Model", model = "models/props_canal/boat002b.mdl", bone = "handle", rel = "1", pos = Vector(16.850999832153, -0.24600000679493, 0.78299999237061), angle = Angle(0, 0, -90), size = Vector(0.32100000977516, 0.003000000026077, 0.05799999833107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/prison_objects005", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "handle", rel = "", pos = Vector(0.45100000500679, -0.81400001049042, -1.2289999723434), angle = Angle(0, 90, 0), size = Vector(0.019999999552965, 0.054999999701977, 0.043999999761581), color = Color(200, 200, 200, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(4.0089998245239, 0, 0.76399999856949), angle = Angle(0, 0, 0), size = Vector(0.045000001788139, 0.40000000596046, 0.30000001192093), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/plates/plate05x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(4.6100001335144, 0, 0.76399999856949), angle = Angle(90, -90, 0.5), size = Vector(0.026000000536442, 0.025000000372529, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
		["2++++"] = { type = "Model", model = "models/hunter/misc/sphere1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-3.6579999923706, 0, 0.77999997138977), angle = Angle(90, -90, 90), size = Vector(0.045000001788139, 0.054999999701977, 0.019999999552965), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} }
	}
	

	self.WElements = {
		--["katana"] = { type = "Model", model = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.526, 1.258, -0.991), angle = Angle(0, -94.154, -180), size = Vector(0.847, 0.847, 0.847), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {}, use_blood = true },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade"] = { type = "Model", model = "models/props_canal/boat002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(16.850999832153, -0.24600000679493, 0.78299999237061), angle = Angle(0, 0, -90), size = Vector(0.32100000977516, 0.003000000026077, 0.05799999833107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/prison_objects005", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4519999027252, 1.87600004673, 1.652999997139), angle = Angle(-90, 90, 0), size = Vector(0.019999999552965, 0.054999999701977, 0.043999999761581), color = Color(200, 200, 200, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.0089998245239, 0, 0.76399999856949), angle = Angle(0, 0, 0), size = Vector(0.045000001788139, 0.40000000596046, 0.30000001192093), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/plates/plate05x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.6100001335144, 0, 0.76399999856949), angle = Angle(90, -90, 0.5), size = Vector(0.026000000536442, 0.025000000372529, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
		["2++++"] = { type = "Model", model = "models/hunter/misc/sphere1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-3.6579999923706, 0, 0.77999997138977), angle = Angle(90, -90, 90), size = Vector(0.045000001788139, 0.054999999701977, 0.019999999552965), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} }
	}
	
	//self:InitializeClientsideModels_Additional()
	
end

function SWEP:OnKill( attacker, pl, dmginfo )
	if IsValid( attacker._efSpeedBoost ) then
		attacker._efSpeedBoost.DieTime = CurTime() + 10
	else
		attacker:SetEffect( "speedboost" )
	end
end
