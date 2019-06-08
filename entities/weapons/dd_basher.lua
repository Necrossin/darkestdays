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
SWEP.PrintName = "Baseball Bat"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6


SWEP.HoldType = "melee2"//melee2

SWEP.MeleeDamage = 40//26
SWEP.MeleeRange = 20+26//60

SWEP.SwingTime = 0.4--0.16 

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

SWEP.BlockPos = Vector(-23.2, -4.5, -2.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

SWEP.Primary.Delay = 1.1

SWEP.ExtraDamageForce = 70

SWEP.HitDecal = "ExplosiveGunshot"

SWEP.SwingHoldType = "melee2"

SWEP.FixScale = true

SWEP.BloodScaleMin = 7
SWEP.BloodScaleMax = 10

SWEP.AnimSpeed = 0.75

SWEP.NoHitSoundFlesh = true
SWEP.Dismember = true

//SWEP.AnimSpeed = 0.7

for i=1,6 do
	util.PrecacheSound("physics/wood/wood_box_impact_hard"..i..".wav")
end

for i=1,3 do
	util.PrecacheSound("physics/wood/wood_strain"..i..".wav")
end


util.PrecacheSound("physics/wood/wood_panel_impact_hard1.wav")
util.PrecacheModel( "models/weapons/c_models/c_boston_basher/c_boston_basher.mdl" )

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 100, math.Rand(150, 165))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/gore/dismemberment.wav", 75, math.Rand(100, 110))
	--self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(90, 100)) 
	self:EmitSound("physics/wood/wood_strain"..math.random(3)..".wav", 70, math.Rand(95, 105), 1, CHAN_AUTO)
end 

//Killicon
if CLIENT then //killicon.AddFont( "weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255 ) ) 
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	killicon.AddFont( "dd_basher", "Bison_30", "bashed", Color(231, 231, 231, 255 ) ) 
end

function SWEP:Precache()

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
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.1040000915527, 1.4670000076294, 5.6259999275208), angle = Angle(180, 0, 0), size = Vector(0.80500000715256, 0.77499997615814, 0.075000002980232), color = Color(70, 70, 70, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 18.72500038147), angle = Angle(0, -37.417999267578, 180), size = Vector(0.8759999871254, 0.8759999871254, 2.3120000362396), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, -0.17800000309944), angle = Angle(-180, -72.513000488281, 180), size = Vector(0.48800000548363, 0.48800000548363, 0.12300000339746), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
		--["basher"] = { type = "Model", model = "models/weapons/c_models/c_boston_basher/c_boston_basher.mdl", bone = "handle", rel = "", pos = Vector(0.741, 1.365, -0.181), angle = Angle(0.209, 0, -94), size = Vector(0.866, 0.866, 0.866), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
	}
	self.WElements = {
		--["basher"] = { type = "Model", model = "models/weapons/c_models/c_boston_basher/c_boston_basher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.665, 0.603, 4.234), angle = Angle(7.747, 2.302, 171.777), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["2"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 18.72500038147), angle = Angle(0, -37.417999267578, 180), size = Vector(0.8759999871254, 0.8759999871254, 2.3120000362396), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.1040000915527, 1.4670000076294, 5.6259999275208), angle = Angle(180, 0, 0), size = Vector(0.80500000715256, 0.77499997615814, 0.075000002980232), color = Color(70, 70, 70, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, -0.17800000309944), angle = Angle(-180, -72.513000488281, 180), size = Vector(0.48800000548363, 0.48800000548363, 0.12300000339746), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}
	
	//self:InitializeClientsideModels_Additional()
	
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	if not block and IsValid(hitent) and hitent:IsPlayer() and hitflesh then
		if SERVER then
			/*for i=1,math.random(4) do
				local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal * -1 )
				effectdata:SetMagnitude(180)
				effectdata:SetRadius( 0 )
				util.Effect( "gib", effectdata, nil, true)
			end*/
			local e = EffectData()
				e:SetOrigin(tr.HitPos)
				e:SetNormal(tr.HitNormal*-1)
			util.Effect("melee_blood_hit",e,nil,true)
			
			hitent:SetGroundEntity( NULL )
			hitent:SetMana( math.Clamp( hitent:GetMana() - 15, 0, hitent:GetMaxMana() ) )
		end
		
		
		
	end
end
