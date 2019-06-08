if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Flag"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "k"
	//killicon.AddFont("dd_launcher", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	
	SWEP.ViewModelFlip = true

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	//killicon.AddFont( "projectile_bolt", "HL2MPTypeDeath","1", color_white )

	
	//SWEP.ReverseCastHand = true

end

function SWEP:InitializeClientsideModels()
	
	
	self.ActionMods = {
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-2.71, -1.964, 4.291), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.298, -1.017) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.325, -30.279, 0) },
		["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Pinky03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -28.633, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.459, 19.298, 0.43) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 32.21, 0) },
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(19.485, 45.814, 9.987) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.709, 0) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.413, 38.618, 0) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 19.739, 0) },
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.947, 29.756, 8.225) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 1.233, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(18.27, 8.324, 9.217) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.386, 6.787, 34.651) },
		["v_weapon.Right_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.264, -32.656, 0) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -4.44, 0.228) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(32.478, 20.069, 10.397) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-1.101, 5.072, -2.596), angle = Angle(-0.189, 3.523, -84.461) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.IdleMods = {
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-2.71, -1.964, 4.291), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.298, -1.017) },
		["v_weapon.Right_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.325, -11.554, 0) },
		["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Pinky03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -49.659, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.462, 11.387, -2.432) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 14.875, 0) },
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(27.517, 2.019, -9.829) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.458, 0) },
		["v_weapon.Right_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.725, 0) },
		["v_weapon.Right_Pinky02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.262, 0) },
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(28.357, -21.946, -14.212) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -22.341, 0) },
		["v_weapon.Right_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(28.708, -26.609, -5.98) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-22.796, 7.039, -10.039) },
		["v_weapon.Right_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.264, -68.03, 0) },
		["v_weapon.Right_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -17.84, 0) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(29.023, -3.718, -0.843) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(1.478, 3.523, -4.291), angle = Angle(27.607, 33.312, -9.99) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}



	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	//self.ViewModelBoneMods["v_weapon.m249"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }

	
	self.VElements = {
		["flag"] = { type = "Model", model = "models/Roller_Spikes.mdl", bone = "v_weapon.Left_Hand", rel = "", pos = Vector(4.092, -0.044, -2.274), angle = Angle(-0.194, -29.067, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Right_Hand", rel = "", pos = Vector(0.864, -0.072, -0.68), angle = Angle(-70, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point_reversed"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Left_Hand", rel = "", pos = Vector(1.417, -0.566, -0.689), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
		

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self:InitializeClientsideModels_Additional()
	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_c4.mdl" )
SWEP.WorldModel			= Model ( "models/Roller_Spikes.mdl" )

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "slam"

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 3.5 * 6 -- 3.5
SWEP.Primary.Damage			= 6.5
SWEP.Primary.NumShots		= 8
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.IgnoreDeploy = true
SWEP.RestrictHolster = true

local throwsound = Sound("weapons/slam/throw.wav")

function SWEP:PrimaryAttack()
	if self.Owner:IsCarryingFlag() then
		if IsValid(GetHillEntity()) and GetHillEntity():GetClass() == "htf_flag" then
			if CLIENT then
				RestoreBoneMods()
			end
			if SERVER then
				GetHillEntity():EmitSound(throwsound)
				GetHillEntity():DropFlag(self.Owner:GetAimVector()*450+vector_up*100)
			end
		end
	end
end

function SWEP:Reload()
return false
end
