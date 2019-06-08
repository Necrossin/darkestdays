if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Sword Gun!"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "k"
	//killicon.AddFont("dd_launcher", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	SWEP.ReverseCastHand = true

end

function SWEP:InitializeClientsideModels()
	
	self.ActionMods = {
		["v_weapon.Left_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -62.288, 0) },
		["v_weapon.Left_Index03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.855, 0) },
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
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Right_Hand", rel = "", pos = Vector(0.864, -0.072, -0.68), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point_reversed"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.Left_Hand", rel = "", pos = Vector(1.417, -0.566, -0.689), angle = Angle(0, 0, 0), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole_plug"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "v_weapon.Right_Arm", rel = "hole", pos = Vector(0, 0, -3.034), angle = Angle(-90, 0, 0), size = Vector(0.041, 0.041, 0.041), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x8.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.05, -0.486, 21.61), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.02), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.Right_Arm", rel = "side2+", pos = Vector(-1.683, -0.687, -0.278), angle = Angle(0, 95.35, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1++++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.Right_Arm", rel = "side2+", pos = Vector(-0.417, -0.75, 1.639), angle = Angle(0, 94.824, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side2"] = { type = "Model", model = "models/weapons/w_eq_eholster.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.87, 0.515, 5.737), angle = Angle(-175.95, 0, -90), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole"] = { type = "Model", model = "models/hunter/tubes/tube2x2x8.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.05, -0.486, 17.589), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.02), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.Right_Arm", rel = "side2+", pos = Vector(-0.817, -0.756, 0.527), angle = Angle(0, 93.913, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1+++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.Right_Arm", rel = "side2+", pos = Vector(-0.576, -0.763, 1.085), angle = Angle(0, 94.824, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1+"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.Right_Arm", rel = "side2+", pos = Vector(-1.203, -0.729, 0.041), angle = Angle(0, 95.541, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side1"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.061, 1.728, 10.748), angle = Angle(0, 0, -90), size = Vector(0.326, 0.326, 0.326), color = Color(80, 80, 80, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side2+"] = { type = "Model", model = "models/weapons/w_eq_eholster.mdl", bone = "v_weapon.m249", rel = "side2", pos = Vector(0.133, 1.312, 0.078), angle = Angle(0, 0, 0), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}


	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole_plug"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hole", pos = Vector(0, 0, -3.034), angle = Angle(-90, 0, 0), size = Vector(0.041, 0.041, 0.041), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1+"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2+", pos = Vector(-1.203, -0.729, 0.041), angle = Angle(0, 95.541, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x8.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(31, 0, -4.081), angle = Angle(-88.612, 0, 0), size = Vector(0.02, 0.02, 0.02), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2+", pos = Vector(-1.683, -0.687, -0.278), angle = Angle(0, 95.35, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1++++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2+", pos = Vector(-0.417, -0.75, 1.639), angle = Angle(0, 94.824, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side2"] = { type = "Model", model = "models/weapons/w_eq_eholster.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.088, 2.352, -3.284), angle = Angle(180, -85.374, -0.638), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole"] = { type = "Model", model = "models/hunter/tubes/tube2x2x8.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(28.24, 0.004, -4.145), angle = Angle(-87.705, 0, 0), size = Vector(0.02, 0.02, 0.02), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side1"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.61, 0, 0.129), angle = Angle(0, -90, -177.898), size = Vector(0.532, 0.532, 0.532), color = Color(80, 80, 80, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1+++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2+", pos = Vector(-0.576, -0.763, 1.085), angle = Angle(0, 94.824, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell1++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2+", pos = Vector(-0.817, -0.756, 0.527), angle = Angle(0, 93.913, 0), size = Vector(0.681, 0.681, 0.681), color = Color(50, 50, 50, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hole_plug+"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hole", pos = Vector(0.079, 0, 4.857), angle = Angle(-90, 0, 0), size = Vector(0.041, 0.041, 0.041), color = Color(30, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["side2+"] = { type = "Model", model = "models/weapons/w_eq_eholster.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side2", pos = Vector(0.133, 1.312, 0.078), angle = Angle(0, 0, 0), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
	//self:InitializeClientsideModels_Additional()
	
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

SWEP.Primary.Sound			= Sound("Weapon_G3SG1.Single")
SWEP.Primary.Recoil			= 3.5 * 6 -- 3.5
SWEP.Primary.Damage			= 6.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.19
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize*5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "rpg_round"

SWEP.KnifePower = 1800

SWEP.Primary.Cone = 0.045

util.PrecacheSound("weapons/grenade_launcher1.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard3.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard1.wav")

function SWEP:PrimaryAttack()
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end
	
	if SERVER then	
		
		local owner = self.Owner
		
		local ent = ents.Create("crossbow_bolt")//"projectile_bolt"
		if ent:IsValid() then		
			ent:SetOwner(owner)
			ent:SetPos(owner:GetShootPos())
			local ang = owner:GetAimVector():Angle()
			//ang:RotateAroundAxis(ang:Right(),180)
			ent:SetAngles(ang)
			//ent.Team = owner:Team()
			//ent.m_iDamage = 60
			ent:Spawn()
			ent:AddEffects(EF_NODRAW)
			//ent:SetModel("models/weapons/w_knife_t.mdl
			local e = EffectData()
			e:SetOrigin(ent:GetPos())
			e:SetEntity(ent)
			util.Effect("effect_knife_dummy",e,nil,true)
			//ent:SetAngles()
			ent.Damage = 10
			ent:SetVelocity((owner:GetAimVector()+ang:Right()*math.Rand(-self.Primary.Cone,self.Primary.Cone)+ang:Up()*math.Rand(-self.Primary.Cone,self.Primary.Cone))*self.KnifePower)
			
			ent:EmitSound(self.Primary.Sound)
		end

	end

	self:TakeAmmo()
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
end

function SWEP:Reload()
	if self.Owner:IsCrow() then return end
	if self:IsCasting() then return end
	
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		--self.Owner:DoReloadEvent()
		self.Weapon:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
		self.Weapon:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
		
		//self:EmitSound("physics/metal/paintcan_impact_hard3.wav",math.random(100,110),math.random(90,100))
		
	end
end

function SWEP:CanPrimaryAttack()
	
	if self.Owner:IsGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("physics/metal/paintcan_impact_hard1.wav")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload()
		
		return false
	end

	return true//self:GetNextPrimaryFire() <= CurTime()
end

if CLIENT then
local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	lerp = math.Approach(lerp, ((self:GetNextReload() > CurTime()) and 1) or 0, FrameTime() * ((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), -33 * lerp)
	return pos, ang
end 
end