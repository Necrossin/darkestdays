function EFFECT:Init(data)
	self.DieTime = CurTime() + 4

	self.ent = data:GetEntity()
	
	if self.ent then
		//self.Emitter = ParticleEmitter(self.ent:GetPos())
		ParticleEffectAttach("burningplayer",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)
	end
	
end

function EFFECT:Think()
	
	if IsValid(self.ent) then
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		self.Entity:SetPos(self.ent:GetPos())
		
		if self.ent.Gibbed then
			self.ent:StopParticleEmission("burningplayer")
			return false
		end
		
	end
	
	
	
	if CurTime() > self.DieTime then
		if IsValid(self.ent) then
			self.ent:StopParticleEmission("burningplayer")
		end
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
		return false
	end
	return true
end

function EFFECT:Render()

	if !ValidEntity(self.ent) then return end
	
	/*self.NextEmit = self.NextEmit or 0
	
	if self.NextEmit > CurTime() then return end
	
	self.NextEmit = CurTime() + 0.03*/
	
	local obj = IsValid( self.ent:GetRagdollEntity() ) and self.ent:GetRagdollEntity() or self.ent
	if obj.IsPlayer and not obj:IsPlayer() then
		obj:SetColor(Color(50,50,50,255))
	end
	/*	for i=0, 25, 1 do
			local bone = obj:GetBoneMatrix(i)
			if bone then
				local pos = bone:GetTranslation()
				local particle = self.Emitter:Add("effects/fire_cloud"..math.random(1,2), pos+VectorRand()*1.4 )
				--particle:SetVelocity(owner:GetVelocity())
				particle:SetDieTime(math.Rand(0.8, 1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(5, 10))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector(0,0,30))
				particle:SetCollide(true)
				--particle:SetLighting(true)
				particle:SetAirResistance(12)
			end				
	end*/
	

end
