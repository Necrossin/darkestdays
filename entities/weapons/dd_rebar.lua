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
SWEP.PrintName = "Rebar"
SWEP.ViewModelFOV = 70

SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 20 + 22

SWEP.SwingTime = 0.15

SWEP.BlockPos = Vector(-23.2, -4.5, -2.8)
SWEP.BlockAng = Angle(68.32, -28.1, -100)

//SWEP.BlockPos = Vector(-7.08, 0, -10.12)
//SWEP.BlockAng = Angle(25.222, 19.809, -44.902)

SWEP.Primary.Delay = 1.1

SWEP.SwingHoldType = "melee2"

SWEP.NoHitSoundFlesh = true
SWEP.Dismember = true

util.PrecacheSound("physics/concrete/concrete_break2.wav")
util.PrecacheSound("physics/concrete/concrete_break3.wav")

for i=2,4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end

util.PrecacheModel( "models/props_debris/rebar002d_96.mdl" )
util.PrecacheModel( "models/props_debris/rebar001d_96.mdl" )

//function SWEP:PlaySwingSound()
//	self:EmitSound("Weapon_Crowbar.Single")
//end

function SWEP:PlayHitSound()
	if self:IsBroken() then
		self:EmitSound("Weapon_Crowbar.Melee_Hit")
	else
		self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav",100, math.Rand(86, 100))
	end
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90)) 
	if self:IsBroken() then
		self:EmitSound("Weapon_Crowbar.Melee_Hit")
	else
		self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav",100, math.Rand(86, 100))
	end
end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_rebar", "Bison_30", "killicon_rebar", Color(231, 231, 231, 255 ) ) 
	//killicon.AddFont( "dd_crowbar", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

function SWEP:SetBroken( bl )
	self:SetDTBool( 10 , bl )
end

function SWEP:IsBroken()
	return self:GetDTBool( 10 )
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	if hitent:IsValid() and (not block and hitent:IsPlayer() or not hitent:IsPlayer()) or hitent:IsWorld() then
		
		if not self.m_FirstHit and not self:IsBroken() then
			self.MeleeDamage = self.MeleeDamage * 2.6
			self.m_FirstHit = true
			/*if self.VElements and self.VElements["rebar"] and self.VElements["rebar2"] then
				self.VElements["rebar"].color.a = 0
				self.VElements["rebar"].no_blood = true
				self.VElements["rebar2"].color.a = 255
			end
			if self.WElements and self.WElements["rebar"] and self.WElements["rebar2"] then
				self.WElements["rebar"].color.a = 0
				self.WElements["rebar"].no_blood = true
				self.WElements["rebar2"].color.a = 255
			end*/
		end
	end
end

local gibs_mdl = Model("models/props_debris/concrete_spawnplug001a.mdl")
function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)
	if self.m_FirstHit and not self.m_Broken then
		self.m_FirstHit = false
		//self.m_Broken = true
		self:SetBroken( true )
		self.MeleeDamage = self.MeleeDamage / 2.6
		
		if CLIENT then
			local e = EffectData()
			e:SetOrigin(tr.HitPos)
			e:SetNormal(tr.HitNormal)
			e:SetScale(5)
			util.Effect("Impact",e,nil,true)
		end
	end
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
	
	/*self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.048, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0.425, 4.719, -1.417), angle = Angle(-27.328, -0.086, -8.014) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.659, 5.785, 10.493) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.814, 17.486, 0.984) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.04, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 33.259, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.48, 35.192, -0.895) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.063, 0) }
	}
	
	
	self.BlockMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(6.375, -0.486, 1.57), angle = Angle(3.802, 17.038, -4.722) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.047, -25.187, 29.27) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.609, 3.542, 11.421) }
	}*/

	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
	
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["rebar"] = { type = "Model", model = "models/props_debris/rebar002d_96.mdl", bone = "handle", rel = "", pos = Vector(-1.405, -12.2, -0.186), angle = Angle(-90, 90, 0), size = Vector(0.317, 0.317, 0.317), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["rebar2"] = { type = "Model", model = "models/props_debris/rebar001d_96.mdl", bone = "handle", rel = "", pos = Vector(-0.304, -12.28, -0.144), angle = Angle(-90, 90, 0), size = Vector(0.317, 0.317, 0.317), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}
	
	//models/props_debris/rebar001d_96.mdl
	
	self.WElements = {
		["rebar"] = { type = "Model", model = "models/props_debris/rebar002d_96.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.088, 1.233, -10.009), angle = Angle(3.657, -99.179, -171.648), size = Vector(0.368, 0.368, 0.368), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["rebar2"] = { type = "Model", model = "models/props_debris/rebar001d_96.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.773, 1, -10), angle = Angle(3, -99, -171), size = Vector(0.319, 0.319, 0.319), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}
	
	
	
end

function SWEP:OnVElementDrawn( name, model )
	if name == "rebar" and self.VElements and self.VElements[ name ] then
		self.VElements[ name ].color.a = self:IsBroken() and 0 or 255
		self.VElements[ name ].no_blood = self:IsBroken()
	end

	if name == "rebar2" and self.VElements and self.VElements[ name ] then
		self.VElements[ name ].color.a = self:IsBroken() and 255 or 0
		self.VElements[ name ].no_blood = !self:IsBroken()
	end
end

function SWEP:OnWElementDrawn( name, model )
	if name == "rebar" and self.WElements and self.WElements[ name ] then
		self.WElements[ name ].color.a = self:IsBroken() and 0 or 255
		self.WElements[ name ].no_blood = self:IsBroken()
	end

	if name == "rebar2" and self.WElements and self.WElements[ name ] then
		self.WElements[ name ].color.a = self:IsBroken() and 255 or 0
		self.WElements[ name ].no_blood = !self:IsBroken()
	end
end

function SWEP:OnOrbPickup()
	self:SetBroken( false )
end