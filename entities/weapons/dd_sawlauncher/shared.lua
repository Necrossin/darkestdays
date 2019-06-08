if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Negotiator"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 87
	SWEP.IconLetter = "k"
	killicon.AddFont("dd_launcher", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	SWEP.ReverseCastHand = true

end

function SWEP:InitializeClientsideModels()
	
	self.ActionMods = {
		["v_weapon.Left_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -62.288, 0) },
		["v_weapon.Left_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.855, 0) },
		["v_weapon.m249"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Index02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10.801, 0) },
		["v_weapon.Left_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(22.299, -17.512, 4.063) },
		["v_weapon.Left_Ring03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.781, 0) },
		["v_weapon.Left_Ring02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12.2, 0) },
		["v_weapon.Left_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -17.445, -22.463) },
		["v_weapon.Left_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -60.806, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-12.075, 0, 0) },
		["v_weapon.Left_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20.175, 0) },
		["v_weapon.Left_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -7.725, 0) },
		["v_weapon.Left_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -61.05, 0) },
		["v_weapon.Left_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -16.3, 0) },
		["v_weapon.Left_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -64.863, 0) },
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(1.537, 0.03, -1.882), angle = Angle(-25.583, 34.537, 200) },
		["v_weapon.Left_Middle03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 44.469, 0) }
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	//self.ViewModelBoneMods["v_weapon.m249"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }

	
	self.VElements = {
		["wep_side1++"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "v_weapon.Right_Arm", rel = "wep_1", pos = Vector(-0.313, 0.606, -0.188), angle = Angle(0, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1+"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "v_weapon.Right_Arm", rel = "wep_1", pos = Vector(-1.425, -0.775, -0.188), angle = Angle(0, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_hand_1"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "v_weapon.Left_Arm", rel = "", pos = Vector(7.574, 0, 0), angle = Angle(0, -180, 14.98), size = Vector(0.122, 0.122, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_saw"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "v_weapon.Right_Arm", rel = "wep_side1", pos = Vector(-0.181, 1.156, 6.188), angle = Angle(-90, -180, 180), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_hand_2"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "v_weapon.Right_Arm", rel = "wep_hand_1", pos = Vector(6.156, -0.213, 2.167), angle = Angle(0, 0, -180), size = Vector(0.041, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1+++"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "v_weapon.Right_Arm", rel = "wep_1", pos = Vector(-1.425, 0.361, -0.188), angle = Angle(0, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "v_weapon.Right_Arm", rel = "wep_1", pos = Vector(-0.313, -0.67, -0.157), angle = Angle(0, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_hand_4"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "v_weapon.Right_Arm", rel = "", pos = Vector(8.48, -0.338, -0.976), angle = Angle(180, 0, 0), size = Vector(0.122, 0.122, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_1"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.813, -1.395, 2.849), angle = Angle(0, 0, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_2"] = { type = "Model", model = "models/props_combine/masterinterface.mdl", bone = "v_weapon.Right_Arm", rel = "wep_1", pos = Vector(-0.527, -0.963, -3.401), angle = Angle(-40.583, 90, 0), size = Vector(0.023, 0.023, 0.023), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_hand_3"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "v_weapon.Right_Arm", rel = "wep_hand_1", pos = Vector(-0.982, 0.075, 0.3), angle = Angle(0, -180, 180), size = Vector(0.634, 0.634, 0.634), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.WElements = {
		["foot1"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_04_cockpit.mdl", bone = "ValveBiped.Bip01_R_Foot", rel = "", pos = Vector(2.549, 0.575, 0.168), angle = Angle(6.067, -138.812, -87.32), size = Vector(0.19, 0.19, 0.19), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1++"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_1", pos = Vector(-1.606, 2.424, 10.112), angle = Angle(0, 0, 0), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body_back1+"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-1.431, 2.536, -2.938), angle = Angle(166.938, -90.325, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body_back1"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-1.431, 2.536, 3.849), angle = Angle(20.062, -90, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_2"] = { type = "Model", model = "models/props_combine/masterinterface.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_1", pos = Vector(-2.251, -3.319, -7.475), angle = Angle(-40.583, 90, 0), size = Vector(0.072, 0.072, 0.072), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm1"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Clavicle", rel = "", pos = Vector(4.031, 1.781, 0), angle = Angle(0, 90, 90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm3_add+"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(3.243, -0.551, 1.256), angle = Angle(-0.525, 180, -172.581), size = Vector(0.085, 0.085, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_saw"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_side1", pos = Vector(-0.551, 3.18, 11.855), angle = Angle(-90, -180, 180), size = Vector(0.423, 0.423, 0.423), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_1", pos = Vector(-1.606, -0.644, 10.112), angle = Angle(0, 0, 0), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm1+"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_L_Clavicle", rel = "", pos = Vector(4.031, 1.781, 0), angle = Angle(0, 90, 90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1+++"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_1", pos = Vector(-4.144, 2.349, 10.112), angle = Angle(0, 0, 0), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side1+"] = { type = "Model", model = "models/props_combine/breenPod_inner.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-21.619, -3.708, -4.081), angle = Angle(90, -180, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head1"] = { type = "Model", model = "models/manhack.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.855, 0.805, -0.076), angle = Angle(-108.394, -66.712, 0), size = Vector(1.8, 1.8, 1.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm2+"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(6.711, 0.112, -0.251), angle = Angle(-8.995, -1.124, 0), size = Vector(0.174, 0.174, 0.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["leg2+"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_L_Calf", rel = "", pos = Vector(14.237, 1.468, 0.407), angle = Angle(0, 1.812, -84.163), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm3"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(15.857, 0.418, 1.993), angle = Angle(-10.513, 180, 0), size = Vector(0.261, 0.261, 0.261), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm3_add_1"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "arm3_add+", pos = Vector(-13.57, -0.226, 1.462), angle = Angle(-4.007, -180, -93.245), size = Vector(1.577, 1.577, 1.577), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["leg1"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_R_Thigh", rel = "", pos = Vector(5.487, -2.063, 1.131), angle = Angle(-0.769, -14.731, -87.937), size = Vector(0.305, 0.305, 0.305), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_side1+"] = { type = "Model", model = "models/props_combine/CombineThumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wep_1", pos = Vector(-4.144, -0.644, 10.112), angle = Angle(0, 0, 0), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body3"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(5.848, -9.176, -4.814), angle = Angle(0, -10.063, 71.888), size = Vector(0.116, 0.116, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["neck1"] = { type = "Model", model = "models/props_combine/combine_smallmonitor001.mdl", bone = "ValveBiped.Bip01_Neck1", rel = "", pos = Vector(0.2, 3.137, -7.718), angle = Angle(0, -129.825, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm3_add"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(3.174, -1.02, -1.275), angle = Angle(-0.525, 180, -14.525), size = Vector(0.085, 0.085, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm3+"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(13.626, 0.418, -1.519), angle = Angle(5.186, 180, -180), size = Vector(0.261, 0.261, 0.261), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_1"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.693, 0.305, -3.938), angle = Angle(-180, 104.099, 80.28), size = Vector(0.196, 0.196, 0.196), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head_light"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head1", pos = Vector(-9.481, -2.083, 6.663), angle = Angle(0, 0, 0), size = Vector(0.197, 0.197, 0.197), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["foot1+"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_04_cockpit.mdl", bone = "ValveBiped.Bip01_L_Foot", rel = "", pos = Vector(2.549, 0.575, 0.168), angle = Angle(6.067, -138.812, -87.32), size = Vector(0.19, 0.19, 0.19), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side1"] = { type = "Model", model = "models/props_combine/breenPod_inner.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-21.619, -3.708, 5.394), angle = Angle(-90, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["arm2"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(6.08, -0.257, 2.137), angle = Angle(-6.526, -2.457, 0), size = Vector(0.174, 0.174, 0.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body3+"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(5.848, -9.138, 5.436), angle = Angle(0, -10.601, 107.47), size = Vector(0.116, 0.116, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head2"] = { type = "Model", model = "models/props_combine/combine_barricade_med01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "head1", pos = Vector(-6.35, 0, 1.944), angle = Angle(0, 180, 0), size = Vector(0.061, 0.061, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["leg1+"] = { type = "Model", model = "models/props_combine/headcrabcannister01b.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(6.076, -0.889, -0.014), angle = Angle(-2.869, -10.275, -88.543), size = Vector(0.305, 0.305, 0.305), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["leg2"] = { type = "Model", model = "models/Combine_Dropship_Container.mdl", bone = "ValveBiped.Bip01_R_Calf", rel = "", pos = Vector(14.237, 2.336, 1.113), angle = Angle(0, -1.576, -103.7), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_mach_m249para.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_mach_m249para.mdl" )

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "shotgun"

local snd = Sound("NPC_Strider.FireMinigun")

//if IsMounted( "ep2" ) and CLIENT then
	//snd = Sound("NPC_Combine_Cannon.FireBullet")
//end

SWEP.Primary.Sound			= snd//Sound("Weapon_G3SG1.Single")
SWEP.Primary.Recoil			= 3.5 * 6 -- 3.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 2
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Primary.Cone = 0.01
SWEP.Primary.ConeMoving = 0.05
SWEP.Primary.ConeCrouching = 0.01

SWEP.Tracer = "AirboatGunHeavyTracer"

util.PrecacheSound("npc/roller/blade_out.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard3.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard1.wav")

if CLIENT then
function SWEP:AdjustMouseSensitivity()
	return 0.8
end
end

/*function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2.2)
	--if not self:CanPrimaryAttack() then return end
	
	if SERVER then	
		local ent = ents.Create("projectile_saw")
		if ent:IsValid() then
			local v = self.Owner:GetShootPos()
			v = v + self.Owner:GetForward() * 10
			v = v + self.Owner:GetRight() * 8
			v = v + self.Owner:GetUp() * -5
			ent:SetPos(v)
			local ang = self.Owner:GetAngles()
			ang.r = ang.r + 90
			ent:SetAngles(ang)
			ent:SetOwner(self.Owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound("npc/roller/blade_out.wav",80,math.random(90,110))
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:EnableGravity(false)
				phys:SetVelocity((self.Owner:GetAimVector()) * 1200)
			end
		end

	end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
end*/

function SWEP:PrimaryAttack()

	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	
	self:EmitFireSound()

	
	local Owner = self.Owner
	
	if Owner.ViewPunch then Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil * 0.25, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0) ) end
	if ( ( SinglePlayer() && SERVER ) || ( !SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	
	self:FireBullet()

	self.IdleAnimation = CurTime() + self:SequenceDuration()
	
	self:SetNextAttack(CurTime()+self:SequenceDuration()+0.5)
	
	self:OnPrimaryAttack()
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetSpellEnd(CurTime() + 0.4)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.4)
	local anim = "cast_"..self.HoldType
	if GetLuaAnimations()[anim] then
		self.Owner:SetLuaAnimation(anim)
	end
	
	if SERVER then	
		local ent = ents.Create("projectile_stickybomb")
		if ent:IsValid() then
			local v = self.Owner:GetShootPos()
			v = v + self.Owner:GetForward() * 10
			v = v + self.Owner:GetRight() * -2
			v = v + self.Owner:GetUp() * -7
			ent:SetPos(v)
			local ang = self.Owner:GetAngles()
			ang.r = ang.r + 90
			ent:SetAngles(ang)
			ent:SetOwner(self.Owner)
			ent:Spawn()
			ent:Activate()
			--ent:EmitSound("npc/roller/blade_out.wav",80,math.random(90,110))
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				--phys:EnableGravity(false)
				phys:SetVelocity((self.Owner:GetAimVector()) * 1100)
			end
		end

	end
	
	self:TakeAmmo()
	
end

function SWEP:Reload()
	/*if self:IsCasting() then return end
	
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_PRIMARYATTACK) then
		self.IdleAnimation = CurTime() + 2
		self:SetNextReload(self.IdleAnimation)
		--self.Owner:DoReloadEvent()
		self.Weapon:SetNextPrimaryFire(CurTime() + 2)
		self.Weapon:SetNextSecondaryFire(CurTime() + 2)
		
		self:EmitSound("physics/metal/paintcan_impact_hard3.wav",math.random(100,110),math.random(90,100))
		
	end*/
end

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	if tr.Hit and tr.HitNormal then
		if SERVER then
			local e = EffectData()
			e:SetOrigin(tr.HitPos)
			e:SetNormal(tr.HitNormal)
			util.Effect("ManhackSparks",e,true,true)
		end
	end
end

function SWEP:CanPrimaryAttack()
	
	if self.Owner:IsGhosting() then return false end

	if self:Clip1() <= 0 then
		--self:EmitSound("physics/metal/paintcan_impact_hard1.wav")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		--self:Reload()
		
		return false
	end

	return true//self:GetNextPrimaryFire() <= CurTime()
end

if CLIENT then
local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	lerp = math.Approach(lerp, ((self:GetNextReload() > CurTime()) and 1) or 0, FrameTime() * ((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), -23 * lerp)
	return pos, ang
end 
end