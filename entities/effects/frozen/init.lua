function EFFECT:Init(data)
	self.DieTime = CurTime() + 4

	self.ent = data:GetEntity()
	
	if self.ent then
		ParticleEffectAttach("frozenplayer",PATTACH_ABSORIGIN_FOLLOW,self.ent,0)
	end
	
end

function EFFECT:Think()
	
	if ValidEntity(self.ent) then
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		self.Entity:SetPos(self.ent:GetPos())
	end
	
	
	
	if CurTime() > self.DieTime then
		if ValidEntity(self.ent) then
			self.ent:StopParticleEmission("frozenplayer")
		end
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
		return false
	end
	return true
end

function EFFECT:Render()
end