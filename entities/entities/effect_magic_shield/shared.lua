ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

for i=1,3 do
	util.PrecacheSound("physics/glass/glass_sheet_break"..i..".wav")
end

util.PrecacheSound("ambient/levels/citadel/weapon_disintegrate3.wav")
util.PrecacheSound("ambient/levels/citadel/weapon_disintegrate4.wav")

ENT.ManaPercentage = 0.35

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efMagShield) then
		if SERVER then
			self.EntOwner._efMagShield:Remove()
		end
		self.EntOwner._efMagShield = nil
	end
	
	self.EntOwner._efMagShield = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
		self:ResetShield()
	end
	
	self.NextRechargeTime = 0
	
end

function ENT:ResetShield()
	self.Energy = math.Round(self.EntOwner._DefaultMana*self.ManaPercentage)
	self:SetDTBool(0,true)
end

function ENT:SetEnergy(am)
	self.Energy = am
end

function ENT:GetEnergy()
	return self.Energy
end

//physics\surfaces\underwater_impact_bullet1.wav
function ENT:DrainShield(am,norm)
	if not self:GetDTBool(0) then return end
	self:SetEnergy(math.Clamp(self:GetEnergy()-am,0,999))
	
	if self:GetEnergy() <= 0 then
		self:BreakShield(norm)
	end
	
end

function ENT:BreakShield(norm)

	self.NextRechargeTime = CurTime()+25
	self:SetDTBool(0,false)
	
	self:EmitSound("physics/glass/glass_sheet_break"..math.random(1,3)..".wav",90,math.random(90,110))
	
	if norm then
		local e = EffectData()
		e:SetOrigin(self:GetPos()+vector_up*50)
		e:SetNormal(norm)
		e:SetScale(self.EntOwner:Team() == TEAM_BLUE and 0 or 1)
		util.Effect("magic_shield_break",e,nil,true)
	end
	
end




function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efMagShield = nil
	end
end

function ENT:Think()

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() or self.EntOwner:IsThug() then
			self:Remove()
			return
		end
		
		if not self:GetDTBool(0) then
			if self.NextRechargeTime < CurTime() then
				self:ResetShield()
				self:EmitSound("ambient/levels/citadel/weapon_disintegrate"..math.random(3,4)..".wav",90,math.random(97,115))
			end
		end

	end
end

if CLIENT then
function ENT:Draw()
	
	if IsValid(self.EntOwner) and self.EntOwner:IsPlayer() then
		
		local chest = self.EntOwner:LookupBone( "ValveBiped.Bip01_Pelvis" ) 
		if chest then
			local pos, ang = self.EntOwner:GetBonePosition(chest)
			ang:RotateAroundAxis(ang:Right(),-90)
			self.Entity:SetPos(pos-ang:Right()*2)
			self.Entity:SetAngles(ang)
		end
		
		
	end
	
	if self:GetDTBool(0) and not (self.EntOwner:IsCrow() or self.EntOwner:IsGhosting()) then
		if not self.Particle then
			ParticleEffectAttach(self.EntOwner:Team() == TEAM_BLUE and "dd_magic_shield_idle" or "dd_magic_shield_idle_red",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
			self.Particle = true
		end
	else
		if self.Particle then
			self.Entity:StopParticles()
			self.Particle = nil
		end
	end
	
end
end