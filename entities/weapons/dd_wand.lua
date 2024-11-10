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
SWEP.PrintName = "Magic Wand"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.IdleAnim = ACT_VM_IDLE

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 15//11
SWEP.MeleeRange = 20+16//50
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//5

SWEP.SwingTime = 0.15 

SWEP.BlockPos = Vector(-7.08, 0, -10.12)
SWEP.BlockAng = Angle(25.222, 19.809, -44.902)

SWEP.Primary.Delay = 0.7

SWEP.SwingHoldType = "melee"

SWEP.BlockPower = 80

SWEP.NoHitSoundFlesh = true

util.PrecacheModel( "models/Weapons/w_stunbaton.mdl" )

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing") 
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end 

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_wand", "Bison_30", "killicon_wand", Color(231, 231, 231, 255 ) ) 
end

function SWEP:InitializeClientsideModels()
	
	
	self.ActionMods = {
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
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
		
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wand"] = { type = "Model", model = "models/Weapons/w_stunbaton.mdl", bone = "handle", rel = "", pos = Vector(1.024, -7.452, -0.45), angle = Angle(0.4, -89.13, 0), size = Vector(0.852, 0.852, 0.852), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}


	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cover"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wand", pos = Vector(-8.101, -0.715, 0.671), angle = Angle(90.595, 0, 0), size = Vector(0.021, 0.021, 0.021), color = Color(0, 104, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wand"] = { type = "Model", model = "models/Weapons/w_stunbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.14, 1.057, -4.969), angle = Angle(90, 0, -95.07), size = Vector(0.731, 0.731, 0.731), color = Color(140, 140, 140, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["cover_glow"] = { type = "Sprite", sprite = "sprites/yellowflare", bone = "ValveBiped.Bip01_R_Hand", rel = "cover", pos = Vector(-0.064, 0, 0.46), size = { x = 10, y = 10 }, color = Color(0, 90, 255, 196), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["cover2"] = { type = "Model", model = "models/props_combine/combine_mortar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "cover", pos = Vector(0, 0, -1.089), angle = Angle(0, 83.862, 180), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cover3"] = { type = "Model", model = "models/props_combine/breen_arm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "cover", pos = Vector(0, -1.989, -2.133), angle = Angle(23.229, -90, -3.356), size = Vector(0.035, 0.035, 0.035), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

function SWEP:SecondaryAttack()
	
	if self.Owner:IsSprinting() then return end
	if self:IsBlocking() then return end
	if !self.Owner:IsDurationSpell() then
		self.Owner:CastSpell()
		if not self.Owner._efCantCast or self.Owner._efCantCast and self.Owner._efCantCast <= CurTime() then
			self:SetSpellEnd(CurTime() + self.SpellTime)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.SpellTime)
			self.Weapon:SetNextSecondaryFire(CurTime() + self.SpellTime)

			self:SetNextAttack(0)

			//local anim = "cast_"..self.HoldType
			//if GetLuaAnimations()[anim] then
				//self.Owner:SetLuaAnimation(anim)
			//end
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	end
end

function SWEP:Reload()
	return false
end