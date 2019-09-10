ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	RegisterParticleEffectAttach( "electrocuted" )
end

util.PrecacheSound("ambient/energy/electric_loop.wav")


function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efElectrocuted) then
		if SERVER then
			self.EntOwner._efElectrocuted:Remove()
		end
		self.EntOwner._efElectrocuted = nil
	end
	
	self.EntOwner._efElectrocuted = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)		
	end
	
	if CLIENT then
		self.Sound = CreateSound( self,  "ambient/energy/electric_loop.wav" )
		//ParticleEffectAttach("electrocuted",PATTACH_ABSORIGIN_FOLLOW,self.EntOwner,0)
	end
	
	self.DieTime = CurTime() + math.random(1,2)
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efElectrocuted = nil
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Stop() 
		end
	end
end

function ENT:Think()
	if CLIENT then
		if self.Sound then
			self.Sound:PlayEx(0.9, 95 + math.sin(RealTime())*5) 
		end
	end

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
			
		if self.DieTime <= CurTime() then
			self:Remove()
		end
		
		self.NextZap = self.NextZap or 0
		
		if self.NextZap < CurTime() then
			self.EntOwner:SetLocalVelocity(vector_origin)
			self.NextZap = CurTime() + 0.2
		end
		
	end
	self:NextThink(CurTime())
end

if CLIENT then
function ENT:Draw()
	
	if MySelf and MySelf == self.EntOwner and not GAMEMODE.ThirdPerson then
		self.Entity:StopParticles()
		self.Particle = nil
		return
	end
	
	if not self.Particle then
		local CPoint0 = {
			["entity"] = self.EntOwner,
			["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
		}
		self.Entity:CreateParticleEffect("electrocuted",{CPoint0})
		self.Particle = true
	end
	
end
end