if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "XBOW"
	SWEP.Author	= ""
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "k"
	killicon.AddFont("dd_launcher", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	SWEP.ViewModelFOV = 57
	SWEP.ViewModelFlip = false//true

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	killicon.AddFont( "projectile_bolt", "HL2MPTypeDeath","1", color_white )

	
	//SWEP.ReverseCastHand = true

end

function SWEP:InitializeClientsideModels()
	
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.992, 0) },
		["v_weapon.xm1014_Bolt"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.xm1014_Shell"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 81.168, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.284, -3.889, 59.873) },
		["v_weapon.xm1014_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0.029, -0.963), angle = Angle(2.914, 13.116, -10.372) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 65.874, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 9.958, 0) },
		["v_weapon.xm1014_Loader"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.278, -4.987, 6.947) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.11, 64.6, 7.162) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 83.209, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 26.631, 82.323) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(22.266, 16.524, -0.19) }
	}



	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	//self.ViewModelBoneMods["v_weapon.m249"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }

	
	self.VElements = {
		["crossbow"] = { type = "Model", model = "models/weapons/c_crossbow.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(-6.875, -7.211, 19.323), angle = Angle(-84.792, 90, 0), size = Vector(0.869, 0.869, 0.869), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["handle"] = { type = "Model", model = "models/Weapons/W_pistol.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -2.905, -0.905), angle = Angle(86.787, -90, 0), size = Vector(0.841, 0.841, 0.841), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	

	self.WElements = {
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self:InitializeClientsideModels_Additional()
	
end

SWEP.Base				= "dd_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_shot_xm1014.mdl" )
SWEP.WorldModel			= Model ( "models/Weapons/W_crossbow.mdl" )

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "crossbow"

SWEP.Primary.Sound			= Sound("Weapon_Crossbow.BoltFly")
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 3
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "xbowbolt"

SWEP.SprintPos = Vector(5.828, -11.056, 0.602)
SWEP.SprintAng = Angle(-24.623, 52.763, -19.698)


function SWEP:PrimaryAttack()
	if self.Owner:IsCrow() then return end
	if self.Owner:IsSprinting() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound( self.Primary.Sound )
	
	if SERVER then	
		
		local owner = self.Owner
		
		local dmg, force = 40,3000
		
		if owner._DefaultBulletFalloffBonus and owner._DefaultBulletFalloffBonus > 0 then
			dmg = dmg * ( 1 + owner._DefaultBulletFalloffBonus/100 )
		end
				
		//if owner:GetPerk("babolt") then
			//dmg, force = 25, 2600
		//end
		
		local ent = ents.Create("crossbow_bolt")//"projectile_bolt"
		if ent:IsValid() then		
			ent:SetOwner(owner)
			local ang = owner:GetAimVector():Angle()
			ang:RotateAroundAxis(ang:Right(), 0.2)
			ang:RotateAroundAxis(ang:Up(), 0.1)
			ent:SetPos(owner:GetShootPos()+ang:Right()*5-ang:Up()*4)
			//ang:RotateAroundAxis(ang:Right(),180)
			ent:SetAngles(ang)
			//ent.Team = owner:Team()
			//ent.m_iDamage = 60
			
			ent:Spawn()
			ent.Damage = dmg
			ent.StartPos = ent:GetPos()
			ent:SetVelocity(ang:Forward() * force)
			ent:SetModelScale( 1.2, 0 )
			ent:EmitSound("npc/manhack/mh_blade_snick1.wav",70,math.random(100,110))
			local col = team.GetColor(owner:Team())
			col.a = 120
			util.SpriteTrail(ent, 0,col , false, 18, 10, 0.3, 1/(18+10)*0.5, "Effects/laser1.vmt")
			
			//local phys = ent:GetPhysicsObject()
			//if phys:IsValid() then
			//	phys:Wake()
			//	phys:SetVelocityInstantaneous(owner:GetAimVector() * 2000)
			//end
		end
		
		//self.Owner:EmitSound("npc/manhack/mh_blade_snick1.wav",70,math.random(100,110))

	end
	
	
	if CLIENT then
		if self:GetCrossbow() then
			self:GetCrossbow():SetSequence(self:GetCrossbow():LookupSequence("fire"))
			
			self:SetAnim(CurTime()+self:GetCrossbow():SequenceDuration())
		end
	end

	self:SetNextAttack(CurTime()+self:SequenceDuration()+0.5)
	
	self:TakeAmmo()
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
end

function SWEP:Reload()
	if self.Owner:IsCrow() then return end
	if self:IsCasting() then return end
	
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_PRIMARYATTACK) then
		self.IdleAnimation = CurTime() + 1.6
		self:SetNextReload(self.IdleAnimation)
		--self.Owner:DoReloadEvent()
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.6)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1.6)
		
		if CLIENT then
			if self:GetCrossbow() then
				self:GetCrossbow():ResetSequence(self:GetCrossbow():LookupSequence("idle"))	
				self:SetAnim(CurTime()+self:GetCrossbow():SequenceDuration())
			end
		end
		self:EmitSound("Weapon_Crossbow.Reload")
		self:EmitSound("Weapon_Crossbow.BoltElectrify")
		
		//self:EmitSound("physics/metal/paintcan_impact_hard3.wav",math.random(100,110),math.random(90,100))
		
	end
end

function SWEP:CanPrimaryAttack()
	
	if self.Owner:IsGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Crossbow.Reload")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload()
		
		return false
	end

	return true//self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:GetCrossbow()
	if self.VElements and self.VElements["crossbow"] then
			if self.VElements["crossbow"].modelEnt and IsValid(self.VElements["crossbow"].modelEnt) then
				return self.VElements["crossbow"].modelEnt
			end
	end
end

function SWEP:SetAnim(tm)
	self:SetDTFloat(3,tm)
end

function SWEP:IsPlayingAnim()
	return self:GetDTFloat(3) > CurTime()
end

function SWEP:OnThink()
	
	if CLIENT then
		if self.VElements and self.VElements["crossbow"] then
			if self.VElements["crossbow"].modelEnt and IsValid(self.VElements["crossbow"].modelEnt) then
				if self:IsPlayingAnim() then
					self.VElements["crossbow"].modelEnt:SetCycle((self.VElements["crossbow"].modelEnt:GetCycle() + RealFrameTime( ) / self.VElements["crossbow"].modelEnt:SequenceDuration()) % 1)
				end
			end
		end
	end

end

if CLIENT then

//finally you get the zoom
local zoom_lerp = 0
function SWEP:TranslateFOV( fov )
	
	zoom_lerp = math.Approach(zoom_lerp, ( self.Owner:KeyDown( IN_RELOAD ) and self:GetNextReload() <= CurTime() and 1 ) or 0, FrameTime() * ((zoom_lerp + 1) ^ 0.2))

	return math.Clamp( fov - zoom_lerp * 60, 10, fov ) 
end

function SWEP:AdjustMouseSensitivity()
	if zoom_lerp > 0 then
		return ( 1 - zoom_lerp * 0.8 )
	end
end

local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	
	/*lerp = math.Approach(lerp, (self.Owner:IsSprinting() and not self.IgnoreSprint and 1) or 0, FrameTime() * 3*((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), -16 * lerp - 5)
	pos = pos + ang:Up()*0.5 + ang:Right()*(self.ViewModelFlip and 0.7 or -0.7)
	return pos, ang*/
	
	if self:GetNextReload() > CurTime() then
		lerp = math.Approach(lerp, ((self:GetNextReload() > CurTime()) and 1) or 0, FrameTime() * ((lerp + 1) ^ 3))
		ang:RotateAroundAxis(ang:Right(), -33 * lerp)
		return pos, ang
	else
		if IsFirstTimePredicted() then
			lerp = math.Approach(lerp, (self.Owner:IsSprinting() and not self.IgnoreSprint and 1) or 0, FrameTime() * 3*((lerp + 1) ^ 2))
		end
	
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
	
	ang:RotateAroundAxis(ang:Right(), - 5)
	pos = pos + ang:Up()*0.5 + ang:Right()*(self.ViewModelFlip and 0.7 or -0.7)
		
	return pos, ang
	end
end 
end