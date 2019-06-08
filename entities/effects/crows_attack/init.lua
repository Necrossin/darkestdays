local util = util
ClientsideModel = ClientsideModel

function EFFECT:Init(data)
	self.DieTime = CurTime() + 7.5

	self.ent = data:GetEntity()
	
	self.Crows = ClientsideModel("models/crow.mdl", RENDERGROUP_TRANSLUCENT)
	self.Crows:SetParent(self.ent)
	--self.Crows:SetSequence(self.Crows:LookupSequence("Hop")) 
	--self.NextSeq = CurTime() + 0//self.Crows:SequenceDuration( )
	self.Crows:AddEffects(EF_NODRAW)

	self.Emitter = ParticleEmitter(self.Entity:GetPos())
	
	self.rad = math.random(30,60)
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end	
end

function EFFECT:Think()
	if ValidEntity(self.ent) then
		self.Entity:SetRenderBounds(Vector(-228, -228, -228), Vector(228, 228, 228))
		self.Entity:SetPos(self.ent:GetPos())
		self.Crows:SetCycle((self.Crows:GetCycle() + RealFrameTime( ) / self.Crows:SequenceDuration()) % 1)
		
		local ent = IsValid( self.ent:GetRagdollEntity() ) and self.ent:GetRagdollEntity() or self.ent
		
		if self.Emitter then
			self.Emitter:SetPos(self.Entity:GetPos())
		end
		
		self.NextEmit = self.NextEmit or 0
		
		if self.NextEmit < CurTime() then
			
			local pos = ent:GetPos()+(ent:IsPlayer() and vector_up*math.random(30,50) or vector_origin)+VectorRand()*math.random(-12,12)
			
			local particle = self.Emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos)
				particle:SetVelocity(VectorRand() * 26)
				particle:SetDieTime(math.Rand(0.5,2))
				particle:SetStartAlpha(255)
				particle:SetStartSize(3)
				particle:SetEndSize(3)
				particle:SetRoll(180)
				particle:SetColor(255, 0, 0)
				particle:SetLighting(true)
				particle:SetCollide(true)
				particle:SetAirResistance(3)
				particle:SetGravity(vector_up*-100)
				particle:SetCollideCallback(CollideCallbackSmall)
			
			local e = EffectData()
			e:SetOrigin(pos)
			e:SetScale(10)
			util.Effect("BloodImpact",e)
			self.NextEmit = CurTime() + math.Rand(0.1,1.1)
		end
		
	end
	
	if CurTime() > self.DieTime then
		SafeRemoveEntity(self.Crows)
		
		if self.Emitter then
			self.Emitter:Finish()
		end
		return false
	end
	
	return true
end

function EFFECT:Render()

	if !ValidEntity(self.ent) then return end

	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)

	local ent = self.ent:GetRagdollEntity() or self.ent
	
	local bone = ent:LookupBone("ValveBiped.Bip01_Spine2")
	
	if bone then
		local pos, ang = ent:GetBonePosition(bone)
			
		if not self.NextSeq then self.NextSeq = {} end
		
		for i=1,7 do
		
			self.NextSeq[i] = self.NextSeq[i] or 0
			self.Crows:SetPlaybackRate( 1+i*0.12 )
			if self.NextSeq[i] <= CurTime() then
				if not ent:IsPlayer() then
					self.Crows:SetSequence("Eat_A") 
				else
					self.Crows:SetSequence(self.Crows:LookupSequence(math.random(2) == 1 and "Hop" or "Fly01")) 
				end
				self.NextSeq[i] = CurTime() + self.Crows:SequenceDuration( )
			end
		
		
			local rad = (self.rad or 40)*i

			self.Crows:SetPos(pos+vector_up*(-25+4*i)+ang:Right()*math.sin( math.rad( rad*i ) ) * 10+ang:Forward()*math.cos( math.rad( rad*i ) ) * 10)
			
			local an = ((pos)-self.Crows:GetPos()):GetNormal():Angle()
			if not ent:IsPlayer() then
				self.Crows:SetAngles(Angle(0,an.y,an.r))
			else
				self.Crows:SetAngles(an)
			end

			self.Crows:SetupBones()
			self.Crows:SetModelScale(0.8,0)
			self.Crows:DrawModel()
			
		end
	end

	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)

end

