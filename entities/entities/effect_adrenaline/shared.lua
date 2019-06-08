ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Duration = 7

if SERVER then
	AddCSLuaFile("shared.lua")
end


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efAdrenaline) then
		if SERVER then
			self.EntOwner._efAdrenaline:Remove()
		end
		self.EntOwner._efAdrenaline = nil
	end
	
	self.EntOwner._efAdrenaline = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
	end
	
	if CLIENT then
		self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	end
	
	self.DieTime = CurTime() + self.Duration
	
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self.EntOwner._efAdrenaline = nil
	end
	if CLIENT then
		if IsValid( self.EntOwner ) and self.Particle then
			self.EntOwner:StopParticlesNamed( "evil_eyes" ) 
		end
	end
end

function ENT:Think()
	if CLIENT then
		--if self.Sound then
		--	self.Sound:PlayEx(0.9, 95 + math.sin(RealTime())*5) 
		--end
	end

	if SERVER then
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		--self.EntOwner:SetLocalVelocity(vector_origin)
		
	end
end

if CLIENT then
function ENT:Draw()
	
	if self.Particle and MySelf == self.EntOwner and not GAMEMODE.ThirdPerson then
		self.Particle = nil
		self.EntOwner:StopParticlesNamed( "evil_eyes" ) 
		return
	end
	
	if not self.Particle then
		ParticleEffectAttach("evil_eyes",PATTACH_POINT_FOLLOW,self.EntOwner,self.EntOwner:LookupAttachment("eyes"))
		self.Particle = true
	end
	//ParticleEffectAttach("frozenplayer",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)

end
end