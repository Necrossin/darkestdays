if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Lil' Tube"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "k"
	SWEP.ViewModelFOV = 60
	
	killicon.AddFont("dd_launcher", "HL2MPTypeDeath", 	"3", Color(231, 231, 231, 255 ))
	killicon.AddFont("projectile_launchergrenade", "HL2MPTypeDeath", "3", Color(231, 231, 231, 255 ))

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

end

function SWEP:InitializeClientsideModels()
	
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.361, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.745, 39.826, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(27.114, 9.173, 29.559) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-19.153, -36.847, 13.286) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-9.096, 64.435, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-36.463, -29.232, 60.944) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.619, 66.097, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 44.596, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.238, 68.959, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.219, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -62.107, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -39, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -77.281, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.836, 64.567, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.285, 45.436, 73.276) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.617, 19.917, 3.525) }
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["tube"] = { type = "Model", model = "models/weapons/c_rpg.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(13.703, -3.023, -21.71), angle = Angle(90, -90, 0), size = Vector(0.796, 0.796, 0.796), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}

	self.WElements = {
		["launcher"] = { type = "Model", model = "models/Weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.156, -3.132, -6.952), angle = Angle(161.694, 6.293, 92.949), size = Vector(1, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_mach_m249para.mdl" )
SWEP.WorldModel			= Model ( "models/Weapons/w_rocket_launcher.mdl" )

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "shotgun"

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 3
SWEP.Primary.Delay			= 0.9
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "rpg_round"

SWEP.Primary.Cone = 0
SWEP.Primary.ConeMoving = 0
SWEP.Primary.ConeCrouching = 0

SWEP.AerodashPenalty = true

SWEP.SprintPos = Vector(5.828, -8.643, 0)
SWEP.SprintAng = Angle(-21.81, 48.542, -8.443)

util.PrecacheSound("weapons/stinger_fire1.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard3.wav")
util.PrecacheSound("physics/metal/paintcan_impact_hard1.wav")

function SWEP:PrimaryAttack()
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end
	
	if SERVER and self.Owner.SpawnProtection and self.Owner.SpawnProtection > CurTime() then
		self.Owner.SpawnProtection = 0
	end
	
	if SERVER then	
		local ent = ents.Create("projectile_launchergrenade")
		if ent:IsValid() then
			local v = self.Owner:GetShootPos()
			v = v + self.Owner:GetForward() * 5
			v = v + self.Owner:GetRight() * 8
			v = v + self.Owner:GetUp() * -4
			ent:SetPos(v)
			local ang = self.Owner:GetAngles()
			//ang.p = ang.p + 90
			ent:SetAngles(ang)
			ent:SetOwner(self.Owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound("weapons/stinger_fire1.wav")
			
			local vel = 1400
			
			if self.Owner:GetPerk("grvel") then
				//vel = 1800
			end
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:ApplyForceCenter(self.Owner:GetAimVector() * vel)
				//phys:SetVelocity((self.Owner:GetAimVector()) * vel)
			end
		end

	end

	self:TakeAmmo()
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
end

function SWEP:Reload()
	if self.Owner:IsCrow() then return end
	if self:IsCasting() then return end
	
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_PRIMARYATTACK) then
		self.IdleAnimation = CurTime() + 1.5
		self:SetNextReload(self.IdleAnimation)
		--self.Owner:DoReloadEvent()
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		
		self:EmitSound("physics/metal/paintcan_impact_hard3.wav",math.random(100,110),math.random(90,100))
		
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

	return true
end

function SWEP:PreDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(0)
end

function SWEP:PostDrawViewModel( ViewModel, Weapon, Player )
	render.SetBlend(1)
end

if CLIENT then
local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	if self:GetNextReload() > CurTime() then
		lerp = math.Approach(lerp, ((self:GetNextReload() > CurTime()) and 1) or 0, RealFrameTime() * ((lerp + 1) ^ 1.5))
		ang:RotateAroundAxis(ang:Right(), -23 * lerp)
		return pos, ang
	else
		--if IsFirstTimePredicted() then
			lerp = math.Approach(lerp, (self.Owner:IsSprinting() and not self.IgnoreSprint and 1) or 0, RealFrameTime() * 1*((lerp + 1) ^ 2.5))
		--end
	
		if self.SprintPos and self.SprintAng then
			local rot = self.SprintAng
			local offset = self.SprintPos
				
			ang = Angle(ang.pitch, ang.yaw, ang.roll)
				
			ang:RotateAroundAxis(ang:Right(), rot.pitch * lerp)
			ang:RotateAroundAxis(ang:Up(), rot.yaw * lerp)
			ang:RotateAroundAxis(ang:Forward(), rot.roll * lerp)
				
			pos = pos + offset.x * lerp * ang:Right() + offset.y * lerp * ang:Forward() + offset.z * lerp * ang:Up()
		else
			ang:RotateAroundAxis(ang:Right(), (self.IsPistol and 1.5 or -1) * 12 * lerp)
		end
		return pos, ang
	end
	//lerp = math.Approach(lerp, ((self:GetNextReload() > CurTime()) and 1) or 0, FrameTime() * ((lerp + 1) ^ 3))
	//ang:RotateAroundAxis(ang:Right(), -23 * lerp)
	//return pos, ang
end 
end