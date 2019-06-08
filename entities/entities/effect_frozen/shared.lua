ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	RegisterParticleEffectAttach( "frozenplayer" )
end

util.PrecacheSound("physics/glass/glass_impact_bullet4.wav")

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if ValidEntity(self.EntOwner._efFrozen) then
		if SERVER then
			self.EntOwner._efFrozen:Remove()
		end
		self.EntOwner._efFrozen = nil
	end
	
	self.EntOwner._efFrozen = self.Entity
	if SERVER then
		self.Entity:DrawShadow(false)
		self:EmitSound("physics/glass/glass_impact_bullet4.wav",110,math.random(97,110))
		
		//local e = EffectData()
		//e:SetEntity(self.EntOwner)
		//util.Effect("frozen",e,true,true)
		self.EntOwner._efFrozenTime = CurTime() + 3
	end
	
	self.DieTime = CurTime() + 3
	
end

function ENT:OnRemove()
	if ValidEntity(self.EntOwner) then
		self.EntOwner._efFrozen = nil
	end
	if CLIENT then
		--if self.Sound then
			--self.Sound:Stop() 
		--end
	end
end

function ENT:Think()
	if CLIENT then
		--if self.Sound then
		--	self.Sound:PlayEx(0.9, 95 + math.sin(RealTime())*5) 
		--end
	end

	if SERVER then
		if !ValidEntity(self.EntOwner) or not self.EntOwner:Alive() then
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
	
	if not self.Particle then
		local CPoint0 = {
			["entity"] = self.EntOwner,
			["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
		}
		self.Entity:CreateParticleEffect("frozenplayer",{CPoint0})
		self.Particle = true
	end
	//ParticleEffectAttach("frozenplayer",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)

end
end